CREATE or replace
PROCEDURE dbamv.p_mov_estoque_s_atende(
   pcd_aviso_cirurgia   In   Number
  ,pcd_atendimento      In   Number
  ,pcd_prestador        In   Number
  ,pdt_realizacao            Date
) Is
   -- cursor para retornar a data do atendimento
   Cursor c_aviso_cirurgia Is
      Select To_date(   TO_CHAR(dt_atendimento, 'dd/mm/yyyy')
                     || TO_CHAR(hr_atendimento, ' hh24miss')
                    ,'dd/mm/yyyy hh24miss'
                    ) dh_atendimento
        From dbamv.atendime
       Where cd_atendimento = pcd_atendimento;

   -- cursor para retornar os itens da movimentação relacionados ao aviso de
   -- cirurgia e que não estão com o atendimento vinculado
   Cursor c_itmvto_est Is
      Select   mvto_estoque.cd_estoque
              ,mvto_estoque.cd_mvto_estoque cd_mvto_estoque
              ,mvto_estoque.cd_setor
              ,mvto_estoque.cd_unid_int
              ,mvto_estoque.tp_mvto_estoque
              ,itmvto_estoque.cd_itmvto_estoque
              ,itmvto_estoque.cd_produto
              ,itmvto_estoque.cd_formula_kit
              ,itmvto_estoque.cd_uni_pro
              ,itmvto_estoque.sn_fatura
              ,produto.cd_produto_tem
              ,To_date(   TO_CHAR(mvto_estoque.dt_mvto_estoque, 'dd/mm/yyyy')
                       || TO_CHAR(mvto_estoque.hr_mvto_estoque, ' hh24miss')
                      ,'dd/mm/yyyy hh24miss'
                      ) dt_mvto
              ,itmvto_estoque.cd_fornecedor cd_fornecedor
              ,itmvto_estoque.cd_lote
              ,itmvto_estoque.dt_validade dt_validade
              ,itmvto_estoque.qt_movimentacao
              ,uni_pro.vl_fator
              ,sn_consignado -- JPFF
          From dbamv.mvto_estoque
              ,dbamv.itmvto_estoque
              ,dbamv.produto
              ,dbamv.estoque -->> pda 118607 (ACGM)
              ,dbamv.uni_pro
         Where mvto_estoque.cd_aviso_cirurgia = pcd_aviso_cirurgia
           And mvto_estoque.cd_atendimento Is Null
           And mvto_estoque.cd_estoque = estoque.cd_estoque
           And itmvto_estoque.cd_uni_pro = uni_pro.cd_uni_pro
           And estoque.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
           And itmvto_estoque.cd_mvto_estoque = mvto_estoque.cd_mvto_estoque
           And itmvto_estoque.cd_produto = produto.cd_produto
      Order By mvto_estoque.cd_mvto_estoque, itmvto_estoque.cd_produto;

   -- cursor para retornar o tipo do convenio do aviso de cirurgia
   Cursor c_convenio Is
      Select cv.tp_convenio
        From dbamv.convenio cv
            ,dbamv.cirurgia_aviso ca
            ,dbamv.empresa_convenio
       Where ca.cd_aviso_cirurgia = pcd_aviso_cirurgia
         And cv.cd_convenio = empresa_convenio.cd_convenio
         And empresa_convenio.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
         And cv.cd_convenio = ca.cd_convenio;

   -- cursor para retornar o tipo de solicitação existentes para o aviso de cirurgia
   Cursor ctpsolsaipro Is
      Select solsai_pro.tp_solsai_pro tp_solsai_pro
        From dbamv.solsai_pro solsai_pro
       Where cd_aviso_cirurgia = pcd_aviso_cirurgia;

   vtp_solsai_pro         ctpsolsaipro%Rowtype;
   vtp_solsai_pro_receb   dbamv.solsai_pro.tp_solsai_pro%Type;
   vn_cd_itmvto_estoque   dbamv.itmvto_estoque.cd_itmvto_estoque%Type;
   ncd_mvto_estoque       dbamv.mvto_estoque.cd_mvto_estoque%Type;
   vdt_aviso              Date;
   vhr_aviso              Date;
   vhr_atendimento        Date;
   vdh_mvto_estoque       Date;
   v_tp_convenio          Varchar2(1);
   vqtitem                Number;

   -- *** ***

   Procedure p_mov_lanca_ffcv(
      p_cd_mvto_estoque     In   Number
     ,p_cd_itmvto_estoque   In   Number
     ,p_cd_estoque          In   Number
     ,p_cd_formula_kit      In   Number
     ,p_cd_produto          In   Number
     ,p_cd_fornecedor       In   Number
     ,p_cd_uni_pro          In   Number
     ,p_qt_movimentacao     In   Number
     ,p_sn_fatura           In   Varchar
   ) Is
      Cursor c_tipo Is
         Select convenio.tp_convenio, atendime.cd_convenio
               ,atendime.cd_con_pla
           From dbamv.atendime
               ,dbamv.convenio
               ,dbamv.mvto_estoque
               ,dbamv.estoque
          Where (atendime.cd_atendimento = mvto_estoque.cd_atendimento)
            And (convenio.cd_convenio = atendime.cd_convenio)
            And (mvto_estoque.cd_mvto_estoque = p_cd_mvto_estoque)
            And mvto_estoque.cd_estoque = estoque.cd_estoque
            And estoque.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;

      Cursor c_configkitconpla(
         iconv     In   Number
        ,iconpla   In   Number
        ,ikit      In   Number
      ) Is
         Select   kit_aberto_fechado, sn_item_pertence_pacote
             From dbamv.config_con_pla_kit
            Where cd_formula = ikit
              And (   (cd_convenio = iconv And cd_con_pla = iconpla)
                   Or (cd_convenio = iconv And cd_con_pla Is Null)
                   Or (cd_convenio Is Null And cd_con_pla Is Null)
                  )
         Order By cd_convenio, cd_con_pla;

      caction             Varchar2(1);
      ctpatend            Varchar2(1);
      ctipo               Varchar2(1);
      iconvenio           Number;
      iconpla             Number;
      ckitabefec          Varchar2(1);
      csnitempertpacote   Varchar2(1);
   Begin
      Open c_tipo;
      Fetch c_tipo Into ctipo, iconvenio, iconpla;
      Close c_tipo;

      If ctipo <> 'H' Then
         caction     := 'I';

         If NVL(p_sn_fatura, 'S') = 'S' Then
            Open c_configkitconpla(iconvenio, iconpla, p_cd_formula_kit);
            Fetch c_configkitconpla Into ckitabefec, csnitempertpacote;
            Close c_configkitconpla;

            If ckitabefec = 'F' And csnitempertpacote = 'S' Then
               ctpatend    :=
                  dbamv.pack_lanca_ffcv.lanca_mges_ffcv(p_cd_produto
                                                       ,p_cd_mvto_estoque
                                                       ,p_cd_uni_pro
                                                       ,p_qt_movimentacao
                                                       ,Null
                                                       ,caction
                                                       ,csnitempertpacote
                                                       , --Charles libere este parametro 15/01/02
                                                        p_cd_itmvto_estoque
                                                       ,p_cd_fornecedor
                                                       ); -- PDA 74859
            Elsif NVL(ckitabefec, 'A') = 'A' Then
               ctpatend    :=
                  dbamv.pack_lanca_ffcv.lanca_mges_ffcv(p_cd_produto
                                                       ,p_cd_mvto_estoque
                                                       ,p_cd_uni_pro
                                                       ,p_qt_movimentacao
                                                       ,p_qt_movimentacao
                                                       ,caction
                                                       , --cAction
                                                        'X'
                                                       , --Charles libere este parametro 15/01/02
                                                        p_cd_itmvto_estoque
                                                       ,p_cd_fornecedor
                                                       );
            End If;
         End If;
      End If;
   End;
---------------------------------------------------------------------------------------------------
-- PDA 171524(inicio) - alterada toda a estrutura do procedimento para não ser necessário chamar o
-- processo de ajusta custo médio, com isso melhora a perfomance no momento da confirmação do consumo
Begin
    -- PDA 180612 (inicio) - incluida a condicao para se perder a variavel da empresa
    -- exiba a mensagem.
    If dbamv.pkg_mv2000.le_empresa is  null then
        raise_application_error(-20001, 'Atenção: Por favor reconectar-se ao Banco de Dados!');
    End If;
    -- PDA 180612 (fim)
   /*PDA 165579 (inicio) - modificada a estrutura do procedimento para não ser mais table of record e
    ir buscar os itens que serão inseridos pelo cursor c_itmvto_est. Esta alteração foi feita pois nao estava
    gerando todos os itens do kit no momento da confirmação de cirurgia */
   If (pcd_aviso_cirurgia Is Not Null) And(pcd_atendimento Is Not Null) Then
      -- abertura do cursor q retornar a data do atendimento
      Open c_aviso_cirurgia;
      Fetch c_aviso_cirurgia Into vhr_atendimento;
      Close c_aviso_cirurgia;
      -- abertura do cursor q retorna o tipo do convenio
      Open c_convenio;
      Fetch c_convenio Into v_tp_convenio;
      Close c_convenio;
      ncd_mvto_estoque := Null;
       /*Colocado o cod.abaixo fora do loop das movimentações, pois caso a solicitação não tenha sido confirmada 
       não existiria linha de movimentação e a solicitação não seria atualizada para paciente. ggms-10/04/2007*/
       
          -- quando existirem solicitação em aberto para o aviso de cirurgia
          -- vincular a solicitação com o atendimento referente ao aviso, modificando
          -- também o tipo da solicitação
          Open ctpsolsaipro;
          Fetch ctpsolsaipro Into vtp_solsai_pro;
          Close ctpsolsaipro;
          --
          If vtp_solsai_pro.tp_solsai_pro = 'S' Then -- pedido para setor
               vtp_solsai_pro_receb := 'P'; -- pedido para paciente
          Elsif vtp_solsai_pro.tp_solsai_pro = 'D' Then -- devolução para setor
               vtp_solsai_pro_receb := 'C'; -- devolução para paciente
          End If;
          --
          Update dbamv.solsai_pro
             Set cd_atendimento = pcd_atendimento
                ,cd_prestador = pcd_prestador
                ,tp_solsai_pro = nvl(vtp_solsai_pro_receb,'P')     /*Pda 150633  */
           Where cd_aviso_cirurgia = pcd_aviso_cirurgia;

      -- loop de todos os itens que tem nas movimentações do aviso de cirurgia
      For ritensmovimentacao In c_itmvto_est
      Loop
         Begin
            -- condição para atualizar as informações da movimentação
            If NVL(ncd_mvto_estoque, 0) <> ritensmovimentacao.cd_mvto_estoque Then
               -- regra para identificar se vai ser colocada na data da de faturamento
               -- a data do atendimento ou da movimentação
               If vhr_atendimento < ritensmovimentacao.dt_mvto Then
                  vhr_aviso   := ritensmovimentacao.dt_mvto;
                  vdt_aviso   := ritensmovimentacao.dt_mvto;
               Else
                  vhr_aviso   := vhr_atendimento;
                  vdt_aviso   := vhr_atendimento;
               End If;


               -- atualização da mvto_estoque para vincular o atendimento as movimentações
               -- de saida de setor que tiveram para o aviso de cirurgia
               Update dbamv.mvto_estoque
                  Set cd_atendimento = pcd_atendimento
                     ,cd_prestador = pcd_prestador
                     ,tp_convenio_da_cirurgia = v_tp_convenio
                     ,dt_faturamento = vdt_aviso
                     ,tp_mvto_estoque = 'P'
                Where cd_aviso_cirurgia = pcd_aviso_cirurgia
                  And cd_mvto_estoque = ritensmovimentacao.cd_mvto_estoque
                  And (tp_mvto_estoque = 'S'
                       Or tp_mvto_estoque = 'P') --ggms
                  And cd_atendimento Is Null; --ggms

               ncd_mvto_estoque := ritensmovimentacao.cd_mvto_estoque;

            End If;            -- fim da condicação do codigo da movimentação
                    --

            -- PDA 177280 - (INICIO) JPFF
            --Processo de atualização da LOG_MVTO_CONSIGNADO:
            If ritensmovimentacao.sn_consignado = 'S' then
               -- Apaga o movimento na log SEM atendimento para o aviso de cirurgia:
               dbamv.pkg_mges_consignado.prc_exclui_log(pcdmvto             =>   ritensmovimentacao.cd_mvto_estoque
                                                        ,pcdentpro            =>   Null
                                                        ,pcdfornecedor        =>   ritensmovimentacao.cd_fornecedor
                                                        ,pcdestoque           =>   ritensmovimentacao.cd_estoque
                                                        ,pcdproduto           =>   ritensmovimentacao.cd_produto
                                                        ,pqtmovimentada       => ( ritensmovimentacao.qt_movimentacao
                                                                                 * ritensmovimentacao.vl_fator )
                                                        ,ptpmovimentacao      =>   'S'
                                                        ,pcdatendimento       =>   Null
                                                        ,pcdsetor             =>   ritensmovimentacao.cd_setor
                                                        ,pcdunidint           =>   ritensmovimentacao.cd_unid_int
                                                        );
              -- Atualiza o movimento na log COM atendimento para o aviso de cirurgia:
              dbamv.pkg_mges_consignado.prc_atualiza_log(pcdmvto             =>   ritensmovimentacao.cd_mvto_estoque
                                                        ,pcdentpro            =>   Null
                                                        ,pcdfornecedor        =>   ritensmovimentacao.cd_fornecedor
                                                        ,pcdestoque           =>   ritensmovimentacao.cd_estoque
                                                        ,pcdproduto           =>   ritensmovimentacao.cd_produto
                                                        ,pqtmovimentada       => ( ritensmovimentacao.qt_movimentacao
                                                                                 * ritensmovimentacao.vl_fator)
                                                        ,ptpmovimentacao      =>   'S'
                                                        ,pcdatendimento       =>   pcd_atendimento
                                                        ,pcdsetor             =>   ritensmovimentacao.cd_setor
                                                        ,pcdunidint           =>   ritensmovimentacao.cd_unid_int
                                                        );
            End IF;
               -- PDA 177280 - (FIM)

                    -- chama a atualiza_estoque para zerar a prod_atend para a linhda
                    -- do aviso de cirurgia que não tem atendimento vinculado

            mges.atualiza_estoque(ritensmovimentacao.cd_estoque
                                 ,ritensmovimentacao.cd_produto
                                 ,ritensmovimentacao.cd_produto_tem
                                 ,ritensmovimentacao.cd_fornecedor
                                 ,ritensmovimentacao.cd_lote
                                 ,ritensmovimentacao.dt_validade
                                 ,Null
                                 ,ritensmovimentacao.cd_setor
                                 ,ritensmovimentacao.cd_unid_int
                                 ,'ITMVTO_ESTOQUE'
                                 ,'S'
                                 ,   -1
                                   * ritensmovimentacao.qt_movimentacao
                                   * ritensmovimentacao.vl_fator
                                 ,pcd_aviso_cirurgia
                                 );
            --
            -- chama o procedimento para incluir na prod_atend o registro da movimentação
            -- com aviso de cirurgia e atendimento vinculado
            mges.atualiza_estoque(ritensmovimentacao.cd_estoque
                                 ,ritensmovimentacao.cd_produto
                                 ,ritensmovimentacao.cd_produto_tem
                                 ,ritensmovimentacao.cd_fornecedor
                                 ,ritensmovimentacao.cd_lote
                                 ,ritensmovimentacao.dt_validade
                                 ,pcd_atendimento
                                 ,ritensmovimentacao.cd_setor
                                 ,ritensmovimentacao.cd_unid_int
                                 ,'ITMVTO_ESTOQUE'
                                 ,'P'
                                 ,   ritensmovimentacao.qt_movimentacao
                                   * ritensmovimentacao.vl_fator
                                 ,pcd_aviso_cirurgia
                                 );
            --
            -- procedimento para atualizar as informações do faturamento
            p_mov_lanca_ffcv(ritensmovimentacao.cd_mvto_estoque
                            ,ritensmovimentacao.cd_itmvto_estoque
                            ,ritensmovimentacao.cd_estoque
                            ,ritensmovimentacao.cd_formula_kit
                            ,ritensmovimentacao.cd_produto
                            ,ritensmovimentacao.cd_fornecedor
                            ,ritensmovimentacao.cd_uni_pro
                            ,ritensmovimentacao.qt_movimentacao
                            ,ritensmovimentacao.sn_fatura
                            );
         --
         End;
      End Loop;
   /*PDA 165579 (fim) */
   End If;
End;
-- PDA 171524(fim)
/

