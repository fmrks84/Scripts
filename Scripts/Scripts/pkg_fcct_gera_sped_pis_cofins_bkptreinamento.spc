CREATE OR REPLACE PACKAGE pkg_fcct_gera_sped_pis_cofins IS
   param_nVLRECM410 NUMBER := 0;
   PROCEDURE PRC1_VALIDA_DT_CANC_INI;
   PROCEDURE PRC2_DADOS_EMPRESA( dCopetencia DATE
                                ,psnretificador VARCHAR2
                                ,psNUM_REC_ANTERIOR VARCHAR2 );
   PROCEDURE PRC3_REGIME_COMP_DET_BLOCOA( dCopetencia DATE );
   PROCEDURE PRC4_MERC_ICMS_IPI_BLOCOC( dCopetencia DATE );
   PROCEDURE PRC5_SERV_ICMS_IPI_BLOCOD( dCopetencia DATE );
   PROCEDURE PRC6_DOC_OPE_BLOCOF( dCopetencia DATE
                                 ,consolidadora NUMBER );
   PROCEDURE PRC61_REGIME_COMP_DET_BLOCOF( dCopetencia DATE
                                          ,vCGC NUMBER );
   PROCEDURE PRC62_REG_COMP_DET_BLOCOF_IND9( dCopetencia DATE );
   PROCEDURE PRC63_REGIME_CAIXA( dCopetencia DATE );
   PROCEDURE prc7_regime_comp_det_BLOCOM( dCopetencia DATE );
   PROCEDURE PRC8_CONTR_PREV_RECBRU_BLOCOP( dCopetencia DATE );
   PROCEDURE PRC9_SALDO_CRED_RET_BLOCO1( dCopetencia DATE );
   PROCEDURE fnc_insere_linha( vRegistro VARCHAR2
                              ,vLinha VARCHAR2 );
   FUNCTION FNC_RETORNA_DIG_IBGE( pCD_IBGE IN NUMBER )
      RETURN NUMBER;
   FUNCTION FNC_RETORNA_COD_IBGE( pUF VARCHAR2
                                 ,pCidade VARCHAR2 )
      RETURN NUMBER;
   FUNCTION FNC_VALIDA_CNPJ_CPF_DIG( tipo IN VARCHAR2
                                    ,numero IN VARCHAR2 )
      RETURN VARCHAR2;
   FUNCTION FNC_VALIDA_CNPJ_CPF( tpDoc VARCHAR2
                                ,nr_cgc_cpf VARCHAR2 )
      RETURN BOOLEAN;
   FUNCTION FNC_LIMPA_CARAC_ESP( vtexto VARCHAR2 )
      RETURN VARCHAR2;
   PROCEDURE PRC99_FECHAMENTO( dCopetencia DATE );
   -- Author  : RAUSE.WANDERLEY
   PROCEDURE prc_gera_sped_pis_cofins( vcd_log NUMBER
                                      ,dCopetencia DATE
                                      ,psnretificador VARCHAR2
                                      ,psNUM_REC_ANTERIOR VARCHAR2
                                      ,psndiferimento VARCHAR2
                                      ,psEmpresa DBAMV.MULTI_EMPRESAS.CD_MULTI_EMPRESA%TYPE );
   PROCEDURE PRC32_INSERE_REG_A170( param_dtcompet DATE
                                   ,nnum_sequencia NUMBER
                                   ,cd_multi_empresa NUMBER
                                   ,param_DS_NUM_ITEM VARCHAR2
                                   ,param_DS_COD_ITEM VARCHAR2
                                   ,param_DS_DESCR_COMPL VARCHAR2
                                   ,param_DS_VL_ITEM VARCHAR2
                                   ,param_DS_VL_DESC VARCHAR2
                                   ,param_DS_NAT_BC_CRED VARCHAR2
                                   ,param_DS_IND_ORIG_CRED VARCHAR2
                                   ,param_DS_CST_PIS VARCHAR2
                                   ,param_DS_VL_BC_PIS VARCHAR2
                                   ,param_DS_ALIQ_PIS VARCHAR2
                                   ,param_DS_VL_PIS VARCHAR2
                                   ,param_DS_CST_COFINS VARCHAR2
                                   ,param_DS_VL_BC_COFINS VARCHAR2
                                   ,param_DS_ALIQ_COFINS VARCHAR2
                                   ,param_DS_VL_COFINS VARCHAR2
                                   ,param_DS_COD_CTA VARCHAR2
                                   ,param_DS_COD_CCUS VARCHAR2 );
   PROCEDURE PRC31_INSERE_REG_A100( param_ds_competencia VARCHAR2
                                   ,param_ds_ind_oper VARCHAR2
                                   ,param_ds_ind_emit VARCHAR2
                                   ,param_ds_cod_part VARCHAR2
                                   ,param_ds_cod_sit VARCHAR2
                                   ,param_ds_ser VARCHAR2
                                   ,param_ds_sub VARCHAR2
                                   ,param_ds_num_doc VARCHAR2
                                   ,param_ds_chv_nfse VARCHAR2
                                   ,param_ds_dt_doc VARCHAR2
                                   ,param_ds_dt_exe_serv VARCHAR2
                                   ,param_ds_vl_doc VARCHAR2
                                   ,param_ds_ind_pgto VARCHAR2
                                   ,param_ds_vl_desc VARCHAR2
                                   ,param_ds_vl_bc_pis VARCHAR2
                                   ,param_ds_vl_pis VARCHAR2
                                   ,param_ds_vl_bc_cofins VARCHAR2
                                   ,param_ds_vl_cofins VARCHAR2
                                   ,param_ds_vl_pis_ret VARCHAR2
                                   ,param_ds_vl_cofins_ret VARCHAR2
                                   ,param_ds_vl_iss VARCHAR2
                                   ,param_cd_multi_empresa NUMBER );
   FUNCTION fnc_charnum( vtexto IN VARCHAR2 )
      RETURN NUMBER;
END PKG_FCCT_GERA_SPED_PIS_COFINS;
/
CREATE OR REPLACE PACKAGE BODY pkg_fcct_gera_sped_pis_cofins IS
   dtCancIni      DATE;
   CURSOR cDtCancIni IS
      SELECT TO_DATE( valor, 'YYYYMMDD' ) dt_canc_ini
        FROM dbamv.configuracao
       WHERE cd_sistema = 'FCCT'
         AND chave = 'SN_SPED_DT_CANC_INI'
         AND cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;
   CURSOR cDadosEmpresa IS
      SELECT me.DS_RAZAO_SOCIAL
            ,me.CD_CGC
            ,me.CD_CIDADE
            ,me.CD_UF
            ,c.cd_ibge
            ,me.DS_NOME_CONTADOR
            ,LPAD( me.CD_CPF_CONTADOR, 11, 0 ) CD_CPF_CONTADOR
            ,me.CD_CRC_CONTADOR
            ,me.CD_IMUN
        FROM dbamv.multi_empresas me
            ,dbamv.cidade c
       WHERE me.cd_cidade = c.cd_cidade
         AND cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;
   CURSOR cTributo IS
      SELECT DISTINCT fd.vl_percentual
                     ,t.TP_DETALHAMENTO
        FROM dbamv.tip_detalhe t
            ,dbamv.faixa_detalhe fd
       WHERE t.TP_DETALHAMENTO IN ('P', 'C')
         AND fd.cd_detalhamento = t.cd_detalhamento
         AND fd.vl_percentual > 0
         AND cd_atividade IN (8109, 2172);
   --     cumulativo = PIS 8109 e COFINS 2172
   -- não cumulativo = PIS 6912 e COFINS 5856
   --
   CURSOR cTributoF100 IS
      SELECT DISTINCT fd.vl_percentual
                     ,t.TP_DETALHAMENTO
        FROM dbamv.tip_detalhe t
            ,dbamv.faixa_detalhe fd
       WHERE t.TP_DETALHAMENTO IN ('P', 'C')
         AND fd.cd_detalhamento = t.cd_detalhamento
         AND fd.vl_percentual > 0
         AND cd_atividade IN (6912, 5856);
   -- PDA 572267 - Fim
   --
   -- PDA 572267 - Inicio - Dados da empresa por Fomulário .
   CURSOR cEmpresa0140( dCopetencia DATE ) IS
      SELECT DISTINCT ds_cnpj
                     ,DS_INSCRICAO_MUNICIPAL
                     ,NM_EMPRESA
        FROM ( SELECT ds_cnpj
                     ,DS_INSCRICAO_MUNICIPAL
                     ,NM_EMPRESA
                 FROM dbamv.formulario_nf_cnpj
                WHERE cd_formulario_nf IN (SELECT DISTINCT cd_formulario_nf
                                             FROM dbamv.nota_fiscal
                                            WHERE TO_CHAR( dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' ))
                  AND dbamv.pkg_mv2000.le_cliente = 1736
               UNION ALL
               SELECT 'X' ds_cnpj
                     ,'X' DS_INSCRICAO_MUNICIPAL
                     ,'X' NM_EMPRESA
                 FROM dbamv.nota_fiscal
                WHERE TO_CHAR( dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                  AND dbamv.pkg_mv2000.le_cliente <> 1736 );
   -- PDA 572267 - Fim
   CURSOR cDadosEmpSped IS
      SELECT SUBSTR( cd_CST_PIS, 0, 2 ) cd_CST_PIS
            ,SUBSTR( cd_CST_COFINS, 0, 2 ) cd_CST_COFINS
            ,cd_COD_INC_TRIB
            ,cd_IND_APRO_CRED
            ,CD_VISAO_CRED_0
            ,CD_VISAO_CONTRIB_1
            ,CD_VISAO_CONTRIB_2
            ,cd_ind_reg_cum -- PDA 533705
        FROM dbamv.Empresa_SPED_PIS_COFINS
       WHERE cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;
   CURSOR cTotalRecBruCumu( dCopetencia DATE ) IS
      SELECT SUM( vl_total_nota ) total_nota
        FROM dbamv.nota_fiscal
       WHERE ( TO_CHAR( dt_emissao, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'mm/yyyy' )
          AND NVL( cd_status, 'E' ) = 'E' )
          OR ( ( TO_CHAR( dt_emissao, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'mm/yyyy' )
            AND TO_CHAR( dt_cancelamento, 'mm/yyyy' ) <> TO_CHAR( dCopetencia, 'mm/yyyy' )
            AND cd_status IS NOT NULL ) );
   CURSOR cRecNCumTribu( dCopetencia DATE ) IS
      SELECT SUM( vl_total_RecNCumTribu ) vl_total_RecNCumTribu
            ,SUM( vl_total_RecNCumNTribu ) vl_total_RecNCumNTribu
        FROM ( SELECT 0 vl_total_RecNCumTribu
                     ,SUM( ABS( sm.vl_credito - sm.vl_debito ) ) vl_total_RecNCumNTribu
                 FROM dbamv.saldo_mensal sm
                     ,dbamv.plano_contas pc
                WHERE TO_CHAR( dt_saldo_mes, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' ) -- '01/2008'
                  AND pc.cd_reduzido = sm.cd_reduzido
                  AND sm.cd_reduzido IN (SELECT ivc.cd_reduzido
                                           FROM dbamv.empresa_sped_pis_cofins pc
                                               ,dbamv.visao_contabil vc
                                               ,dbamv.it_visao_contabil ivc
                                          WHERE pc.cd_visao_contrib_1 = vc.cd_visao_contabil
                                            AND ivc.cd_visao_contabil = vc.cd_visao_contabil
                                            AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                                            AND SUBSTR( ivc.cd_CST_PIS, 0, 2 ) IN ('06', '07')
                                            AND SUBSTR( ivc.cd_CST_COFINS, 0, 2 ) IN ('06', '07'))
                  AND NOT EXISTS (SELECT dt_saldo_mes
                                    FROM dbamv.saldo_mes_sem_apuracao smsa
                                        ,dbamv.plano_contas pc
                                   WHERE TO_CHAR( smsa.dt_saldo_mes, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                                     AND pc.cd_reduzido = sm.cd_reduzido
                                     AND smsa.cd_reduzido = sm.cd_reduzido)
               UNION ALL
               SELECT 0 vl_total_RecNCumTribu
                     ,SUM( ABS( sm.vl_credito - sm.vl_debito ) ) vl_total_RecNCumNTribu
                 FROM dbamv.saldo_mes_sem_apuracao sm
                     ,dbamv.plano_contas pc
                WHERE TO_CHAR( dt_saldo_mes, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' ) -- '01/2008'
                  AND pc.cd_reduzido = sm.cd_reduzido
                  AND sm.cd_reduzido IN (SELECT ivc.cd_reduzido
                                           FROM dbamv.empresa_sped_pis_cofins pc
                                               ,dbamv.visao_contabil vc
                                               ,dbamv.it_visao_contabil ivc
                                          WHERE pc.cd_visao_contrib_1 = vc.cd_visao_contabil
                                            AND ivc.cd_visao_contabil = vc.cd_visao_contabil
                                            AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                                            AND SUBSTR( ivc.cd_CST_PIS, 0, 2 ) IN ('06', '07')
                                            AND SUBSTR( ivc.cd_CST_COFINS, 0, 2 ) IN ('06', '07'))
               UNION ALL
               SELECT SUM( ABS( sm.vl_credito - sm.vl_debito ) ) vl_total_RecNCumTribu
                     ,0 vl_total_RecNCumNTribu
                 FROM dbamv.saldo_mensal sm
                     ,dbamv.plano_contas pc
                WHERE TO_CHAR( dt_saldo_mes, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' ) -- '01/2008'
                  AND pc.cd_reduzido = sm.cd_reduzido
                  AND sm.cd_reduzido IN (SELECT ivc.cd_reduzido
                                           FROM dbamv.empresa_sped_pis_cofins pc
                                               ,dbamv.visao_contabil vc
                                               ,dbamv.it_visao_contabil ivc
                                          WHERE pc.cd_visao_contrib_1 = vc.cd_visao_contabil
                                            AND ivc.cd_visao_contabil = vc.cd_visao_contabil
                                            AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                                            AND SUBSTR( ivc.cd_CST_PIS, 0, 2 ) NOT IN ('06', '07')
                                            AND SUBSTR( ivc.cd_CST_COFINS, 0, 2 ) NOT IN ('06', '07'))
                  AND NOT EXISTS (SELECT dt_saldo_mes
                                    FROM dbamv.saldo_mes_sem_apuracao smsa
                                        ,dbamv.plano_contas pc
                                   WHERE TO_CHAR( smsa.dt_saldo_mes, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                                     AND pc.cd_reduzido = sm.cd_reduzido
                                     AND smsa.cd_reduzido = sm.cd_reduzido)
               UNION ALL
               SELECT SUM( ABS( sm.vl_credito - sm.vl_debito ) ) vl_total_RecNCumTribu
                     ,0 vl_total_RecNCumNTribu
                 FROM dbamv.saldo_mes_sem_apuracao sm
                     ,dbamv.plano_contas pc
                WHERE TO_CHAR( dt_saldo_mes, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' ) -- '01/2008'
                  AND pc.cd_reduzido = sm.cd_reduzido
                  AND sm.cd_reduzido IN (SELECT ivc.cd_reduzido
                                           FROM dbamv.empresa_sped_pis_cofins pc
                                               ,dbamv.visao_contabil vc
                                               ,dbamv.it_visao_contabil ivc
                                          WHERE pc.cd_visao_contrib_1 = vc.cd_visao_contabil
                                            AND ivc.cd_visao_contabil = vc.cd_visao_contabil
                                            AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                                            AND SUBSTR( ivc.cd_CST_PIS, 0, 2 ) NOT IN ('06', '07')
                                            AND SUBSTR( ivc.cd_CST_COFINS, 0, 2 ) NOT IN ('06', '07')) );
   CURSOR cBaseCalculo( pcd_nota NUMBER ) IS
        SELECT cd_gru_fat
              ,SUM( vl_itfat_nf ) vl_itfat_nf
          FROM (   SELECT SUM( itf.vl_itfat_nf ) vl_itfat_nf
                         ,i.cd_gru_fat
                     FROM dbamv.itfat_nota_fiscal itf
                         ,dbamv.itreg_fat i
                    WHERE itf.cd_reg_fat = i.cd_reg_fat
                      AND itf.cd_lancamento_fat = i.cd_lancamento
                      AND itf.cd_nota_fiscal = pcd_nota
                      AND NOT EXISTS (SELECT cd_pro_fat
                                        FROM dbamv.produto
                                       WHERE cd_pro_fat = itf.cd_pro_fat
                                         AND NVL( tp_classificacao_tributaria, 'T' ) = 'II')
                 GROUP BY i.cd_gru_fat
                 UNION ALL
                   SELECT SUM( itf.vl_itfat_nf ) vl_itfat_nf
                         ,i.cd_gru_fat
                     FROM dbamv.itfat_nota_fiscal_canc itf
                         ,dbamv.itreg_fat i
                    WHERE itf.cd_reg_fat = i.cd_reg_fat
                      AND itf.cd_lancamento_fat = i.cd_lancamento
                      AND itf.cd_nota_fiscal = pcd_nota
                      AND NOT EXISTS (SELECT cd_pro_fat
                                        FROM dbamv.produto
                                       WHERE cd_pro_fat = itf.cd_pro_fat
                                         AND NVL( tp_classificacao_tributaria, 'T' ) = 'II')
                 GROUP BY i.cd_gru_fat
                 UNION ALL
                   SELECT SUM( itf.vl_itfat_nf ) vl_itfat_nf
                         ,i.cd_gru_fat
                     FROM dbamv.itfat_nota_fiscal itf
                         ,dbamv.itreg_amb i
                    WHERE itf.cd_reg_amb = i.cd_reg_amb
                      AND i.cd_lancamento = itf.cd_lancamento_amb
                      AND itf.cd_nota_fiscal = pcd_nota
                      AND NOT EXISTS (SELECT cd_pro_fat
                                        FROM dbamv.produto
                                       WHERE cd_pro_fat = itf.cd_pro_fat
                                         AND NVL( tp_classificacao_tributaria, 'T' ) = 'II')
                 GROUP BY i.cd_gru_fat
                 UNION ALL
                   SELECT SUM( itf.vl_itfat_nf ) vl_itfat_nf
                         ,i.cd_gru_fat
                     FROM dbamv.itfat_nota_fiscal_canc itf
                         ,dbamv.itreg_amb i
                    WHERE itf.cd_reg_amb = i.cd_reg_amb
                      AND i.cd_lancamento = itf.cd_lancamento_amb
                      AND itf.cd_nota_fiscal = pcd_nota
                      AND NOT EXISTS (SELECT cd_pro_fat
                                        FROM dbamv.produto
                                       WHERE cd_pro_fat = itf.cd_pro_fat
                                         AND NVL( tp_classificacao_tributaria, 'T' ) = 'II')
                 GROUP BY i.cd_gru_fat
                 UNION ALL
                 SELECT SUM( NVL( itf.vl_itfat_nf, 0 ) ) vl_itfat_nf
                       ,0 cd_gru_fat
                   FROM dbamv.itfat_nota_fiscal itf
                  WHERE itf.cd_nota_fiscal = pcd_nota
                    AND itf.cd_pro_fat IN (SELECT cd_pro_fat
                                             FROM dbamv.produto
                                            WHERE NVL( tp_classificacao_tributaria, 'T' ) = 'II')
                 UNION ALL
                 SELECT SUM( NVL( itf.vl_itfat_nf, 0 ) ) vl_itfat_nf
                       ,0 cd_gru_fat
                   FROM dbamv.itfat_nota_fiscal_canc itf
                  WHERE itf.cd_nota_fiscal = pcd_nota
                    AND itf.cd_pro_fat IN (SELECT cd_pro_fat
                                             FROM dbamv.produto
                                            WHERE NVL( tp_classificacao_tributaria, 'T' ) = 'II')
                 UNION ALL
                   /*SN_BASE_TAXA_PC Início */
                   SELECT SUM( NVL( i.vl_acrescimo, 0 ) ) vl_itfat_nf
                         ,i.cd_gru_fat
                     FROM dbamv.itfat_nota_fiscal itf
                         ,dbamv.produto p
                         ,dbamv.itreg_fat i
                    WHERE p.cd_pro_fat = itf.cd_pro_fat
                      AND i.cd_reg_fat = itf.cd_reg_fat
                      AND i.cd_lancamento = itf.cd_lancamento_fat
                      AND itf.cd_nota_fiscal = pcd_nota
                      AND NVL( tp_classificacao_tributaria, 'T' ) = 'II'
                      AND NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_BASE_TAXA_PC' ), 'N' ) = 'S'
                 GROUP BY i.cd_gru_fat
                 UNION ALL
                   SELECT SUM( NVL( i.vl_acrescimo, 0 ) ) vl_itfat_nf
                         ,i.cd_gru_fat
                     FROM dbamv.itfat_nota_fiscal_canc itf
                         ,dbamv.produto p
                         ,dbamv.itreg_fat i
                    WHERE p.cd_pro_fat = itf.cd_pro_fat
                      AND i.cd_reg_fat = itf.cd_reg_fat
                      AND i.cd_lancamento = itf.cd_lancamento_fat
                      AND itf.cd_nota_fiscal = pcd_nota
                      AND NVL( tp_classificacao_tributaria, 'T' ) = 'II'
                      AND NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_BASE_TAXA_PC' ), 'N' ) = 'S'
                 GROUP BY i.cd_gru_fat
                 UNION ALL
                   SELECT SUM( NVL( i.vl_acrescimo, 0 ) ) vl_itfat_nf
                         ,i.cd_gru_fat
                     FROM dbamv.itfat_nota_fiscal itf
                         ,dbamv.produto p
                         ,dbamv.itreg_amb i
                    WHERE p.cd_pro_fat = itf.cd_pro_fat
                      AND i.cd_reg_amb = itf.cd_reg_amb
                      AND i.cd_lancamento = itf.cd_lancamento_amb
                      AND itf.cd_nota_fiscal = pcd_nota
                      AND NVL( tp_classificacao_tributaria, 'T' ) = 'II'
                      AND NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_BASE_TAXA_PC' ), 'N' ) = 'S'
                 GROUP BY i.cd_gru_fat
                 UNION ALL
                   SELECT SUM( NVL( i.vl_acrescimo, 0 ) ) vl_itfat_nf
                         ,i.cd_gru_fat
                     FROM dbamv.itfat_nota_fiscal_canc itf
                         ,dbamv.produto p
                         ,dbamv.itreg_amb i
                    WHERE p.cd_pro_fat = itf.cd_pro_fat
                      AND i.cd_reg_amb = itf.cd_reg_amb
                      AND i.cd_lancamento = itf.cd_lancamento_amb
                      AND itf.cd_nota_fiscal = pcd_nota
                      AND NVL( tp_classificacao_tributaria, 'T' ) = 'II'
                      AND NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_BASE_TAXA_PC' ), 'N' ) = 'S'
                 GROUP BY i.cd_gru_fat
                 /*SN_BASE_TAXA_PC Fim  */
                 UNION ALL
                   SELECT SUM( itn.vl_gru_fat ) vl_itfat_nf
                         ,itn.cd_gru_fat
                     FROM dbamv.itnota_fiscal itn
                         ,dbamv.nota_fiscal n
                    WHERE itn.cd_nota_fiscal = pcd_nota
                      AND n.cd_nota_fiscal = itn.cd_nota_fiscal
                      AND n.tp_nota_fiscal = 'A'
                 GROUP BY itn.cd_gru_fat
                 -- PDA 546073 - Inicio - tratando erro de nota fiscal emitida sem daos na tabela itfat_nota_fiscal .
                 UNION ALL
                   SELECT SUM( itn.vl_gru_fat ) vl_itfat_nf
                         ,itn.cd_gru_fat
                     FROM dbamv.itnota_fiscal itn
                         ,dbamv.nota_fiscal n
                    WHERE itn.cd_nota_fiscal = pcd_nota
                      AND n.cd_nota_fiscal = itn.cd_nota_fiscal
                      AND n.tp_nota_fiscal = 'N'
                      AND n.cd_status = 'E'
                      AND NOT EXISTS (SELECT cd_nota_fiscal
                                        FROM dbamv.itfat_nota_fiscal
                                       WHERE itfat_nota_fiscal.cd_nota_fiscal = n.cd_nota_fiscal
                                      UNION ALL
                                      SELECT cd_nota_fiscal
                                        FROM dbamv.itfat_nota_fiscal_canc
                                       WHERE itfat_nota_fiscal_canc.cd_nota_fiscal = n.cd_nota_fiscal)
                 GROUP BY itn.cd_gru_fat
                 UNION ALL
                 SELECT VL_GRU_FAT
                       ,itn.cd_gru_fat cd_gru_fat
                   FROM dbamv.nota_fiscal n
                       ,dbamv.itnota_fiscal itn
                  WHERE n.cd_nota_fiscal = pcd_nota
                    AND n.cd_nota_fiscal = itn.cd_nota_fiscal
                    AND n.tp_nota_fiscal = 'N'
                    AND n.cd_status = 'C'
                    AND TO_CHAR( n.dt_emissao, 'MM/YYYY' ) <> TO_CHAR( n.dt_cancelamento, 'MM/YYYY' )
                    AND n.dt_cancelamento > TO_DATE( dbamv.pkg_mv2000.le_configuracao( 'FCCT', 'SN_SPED_DT_CANC_INI' ), 'YYYYMMDD' )
                    AND ( SELECT COUNT( qtd )
                            FROM ( SELECT itf.CD_ITFAT_NF qtd
                                     FROM dbamv.itfat_nota_fiscal_canc itf
                                         ,dbamv.itreg_amb i
                                    WHERE i.cd_reg_amb = itf.cd_reg_amb
                                      AND i.cd_lancamento = itf.cd_lancamento_amb
                                      AND itf.cd_nota_fiscal = pcd_nota
                                   UNION ALL
                                   SELECT itf.CD_ITFAT_NF qtd
                                     FROM dbamv.itfat_nota_fiscal_canc itf
                                         ,dbamv.itreg_fat i
                                    WHERE i.cd_reg_fat = itf.cd_reg_fat
                                      AND i.cd_lancamento = itf.cd_lancamento_fat
                                      AND itf.cd_nota_fiscal = pcd_nota ) ) = 0 )
      GROUP BY cd_gru_fat;
   rcBaseCalculo  cBaseCalculo%ROWTYPE;
   -- PDA 546073 - Fim
   -- CURSOR REGISTRO 0500 PLANO DE CONTAS
   vsndiferimento VARCHAR2( 1 ) := '0';
   bNaoEscrituraBlccoF BOOLEAN;
   rDadosEmpSped  cDadosEmpSped%ROWTYPE;
   nescrituraM400m800 NUMBER;
   rDadosEmpresa  cDadosEmpresa%ROWTYPE;
   bEcrituraM410  BOOLEAN := FALSE;
   ncontaM990     NUMBER;
   ncontaM400     NUMBER;
   ncontaM410     NUMBER;
   ncontaM800     NUMBER;
   ncontaM810     NUMBER;
   nTotalPisCofinsF600 NUMBER;
   nContaF600     NUMBER := 0;
   nContaF700     NUMBER := 0;
   contaBlcF010   NUMBER := 0;
   nContaConfigF500 NUMBER := 0;
   nContaConfigF525 NUMBER := 0;
   nContaConfigF509 NUMBER := 0;
   nConta1900     NUMBER := 0;
   dtInicio       DATE;
   dtfim          DATE;
   vdtInicio      VARCHAR2( 8 );
   vCompetencia   VARCHAR2( 6 );
   vdtfim         VARCHAR2( 8 );
   bArqExiste     BOOLEAN;
   vArquivo       VARCHAR2( 100 );
   IBGE_NOT_FOUND Exception;
   CPF_NOT_FOUND Exception;
   CPF_CARACTER_INVALIDO Exception;
   vNOME          VARCHAR2( 100 );
   vCNPJ          VARCHAR2( 14 );
   vUF            VARCHAR2( 2 );
   vCOD_MUN       VARCHAR2( 7 );
   vNOMEContador  VARCHAR2( 100 );
   vCPFcontador   VARCHAR2( 11 );
   vCRC           VARCHAR2( 15 );
   vIM            VARCHAR2( 14 );
   vPGTO          VARCHAR2( 2 );
   vCODMUNCliente NUMBER;
   VlPIS          VARCHAR2( 15 );
   VlCofins       VARCHAR2( 15 );
   VlPISitens     VARCHAR2( 15 );
   VlCofinsitens  VARCHAR2( 15 );
   vlBasepisA170  VARCHAR2( 15 );
   vlBaseCofinsA170 VARCHAR2( 15 );
   nPercPis       NUMBER;
   nPercCofins    NUMBER;
   nPercPisA170   NUMBER;
   nPercCofinsA170 NUMBER;
   rcTributo      cTributo%ROWTYPE;
   rcTributoF100  cTributoF100%ROWTYPE;
   nNrNotaIbge    NUMBER;
   vCPFcliente    VARCHAR2( 11 );
   vCNPJcliente   VARCHAR2( 14 );
   vCodPais       VARCHAR2( 5 );
   ContaBlc0      NUMBER := 0;
   ContaBlcA      NUMBER := 0;
   contaBlcA170   NUMBER := 0;
   contaSeqA170   NUMBER;
   contaBlctotA170 NUMBER := 0;
   ContaBlc0150   NUMBER := 0;
   ContaBlc0200   NUMBER := 0;
   ContaBlc0500   NUMBER := 0;
   contaBlcA100   NUMBER := 0;
   contaBlcA111   NUMBER := 0;
   ContaBlcATot   NUMBER := 0;
   contatotalArq  NUMBER := 0;
   nRecNCumTribu0111 NUMBER := 0;
   nRecNCumNTribu0111 NUMBER := 0;
   nRecBruCumu    NUMBER := 0;
   nTotalRec0111  NUMBER := 0;
   bErroCnpjCpf   BOOLEAN := FALSE;
   nVlbasetrib    NUMBER;
   nVlbaseNtrib   NUMBER;
   nVlbasetribNota NUMBER;
   nVlbaseNtribNota NUMBER;
   nVlOperf100    NUMBER;
   nAliqPIS       NUMBER;
   vAliqPIS       VARCHAR2( 10 );
   vVlPIS         VARCHAR2( 20 );
   nAliqCofins    NUMBER;
   vAliqCofins    VARCHAR2( 10 );
   vVlCofins      VARCHAR2( 10 );
   nContaConfigF100 NUMBER := 0;
   nContaConfigF990 NUMBER;
   vIND_OPER      VARCHAR2( 1000 );
   vVAL_OPER      VARCHAR2( 1000 );
   nVAL_OPER      NUMBER;
   vPart_credito  VARCHAR2( 1000 );
   vconta         VARCHAR2( 1000 );
   vlinha         VARCHAR2( 4000 );
   vSPED_CST_PIS  NUMBER; -- Código da situação tributária referente ao pis/pasep
   vSPED_CST_COFINS NUMBER; -- Código da situação tributária referente à cofins
   nSPED_COD_INC_TRIB NUMBER; --  Código indicador da incidência tributária no período
   nSPED_IND_APRO_CRED NUMBER; -- Código indicador de método de apropriação de créditos  comuns, no caso de incidência no regime não-cumulativo
   vDESC_DOC_OPER VARCHAR2( 1000 ); -- F100 Descrição do Documento/Operação
   nCdNota        NUMBER;
   nNrDoc         NUMBER;
   vCodVerifNFSe  VARCHAR2( 100 );
   vDTDoc         VARCHAR2( 100 );
   vVlNota        VARCHAR2( 100 );
   vVlNotaDesc    VARCHAR2( 100 );
   vVlBasePis     VARCHAR2( 100 );
   vVlBaseCofins  VARCHAR2( 100 );
   /*   param_nVLRECM410     NUMBER := 0;*/
   nVLRECM400     NUMBER;
   bexiste410Cumul BOOLEAN;
   nVlPisA100     NUMBER;
   nVlCofinsA100  NUMBER;
   ContaBlc0111   NUMBER;
   conta9900      NUMBER;
   conta9990      NUMBER;
   ncontaRegistroM NUMBER;
   vInseriuTomador VARCHAR2( 32000 );
   vNAT_BC_CRED   VARCHAR2( 5 );
   vIND_ORIG_CRED VARCHAR2( 1 );
   nconta9999     NUMBER;
   nVl_Rec_Brt    NUMBER;
   nVlbasetribm210T NUMBER;
   nVlbasetribM210NT NUMBER;
   nVlbasetribM210TNC NUMBER;
   nVL_RET_CUM_pis NUMBER;
   nVL_OUT_DED_CUM_pis NUMBER;
   nVL_RET_CUM_cofins NUMBER;
   nVL_OUT_DED_CUM_cofins NUMBER;
   ncontam205     NUMBER := 0;
   ncontam210     NUMBER := 0;
   ncontam605     NUMBER := 0;
   ncontam610     NUMBER := 0;
   nPerceAcrescNota NUMBER;
   nPerceDescNota NUMBER;
   nVlItfat       NUMBER := 0;
   nvltaxa        NUMBER;
   vRegistroA111  VARCHAR2( 4000 );
   vRegistro1010  VARCHAR2( 4000 );
   vRegistro1020  VARCHAR2( 4000 );
   nVL_CONT_DIF   NUMBER;
   ncontam630     NUMBER := 0;
   nVL_CONT_APUR_DIFER NUMBER;
   nVL_CRED_DESC_DIFER NUMBER;
   nVL_CONT_DIFER_ANT NUMBER;
   ncontam300     NUMBER := 0;
   ncontam700     NUMBER := 0;
   mVL_CONT_DIFER_ANT_PIS NUMBER := 0;
   mVL_CONT_DIFER_ANT_COFINS NUMBER := 0;
   bprimeiroitemA100 BOOLEAN;
   bprimeiroitemA170 BOOLEAN;
   nCdPais        NUMBER; -- PDA 537790
   -- PDA 572267 - Inicio
   rcEmpresa0140  cEmpresa0140%ROWTYPE;
   ncontaA010     NUMBER := 0;
   nconta0140     NUMBER := 0;
   ncontaBloco1   NUMBER := 0;
   vversao        VARCHAR2( 3 );
   -- PDA 572267 - Fim
   ncontam230     NUMBER := 0;
   --   dtCancIni      DATE;
   nVL_CONT_CUM_REC_200 NUMBER;
   nVL_TOT_CONT_REC_200 NUMBER;
   nVL_CONT_CUM_REC_600 NUMBER;
   nVL_TOT_CONT_REC_600 NUMBER;
   nVL_DEBITO_205 NUMBER;
   nVL_DEBITO_605 NUMBER;
   nVL_REC_BRT_210 NUMBER;
   nVL_BC_CONT_210 NUMBER;
   nVL_REC_BRT_610 NUMBER;
   nVL_BC_CONT_610 NUMBER;
   /******************************************************************************************************************/
   FUNCTION FNC_RETORNA_COD_IBGE( pUF VARCHAR2
                                 ,pCidade VARCHAR2 )
      RETURN NUMBER IS
      CURSOR cIbge IS
         SELECT cd_ibge
               ,NR_DIGITO_IBGE
           FROM dbamv.cidade
          WHERE REPLACE( UPPER( REPLACE( nm_cidade, CHR( 39 ), ' ' ) ), ' ' ) = REPLACE( UPPER( ( pCidade ) ), ' ' )
            AND UPPER( CD_UF ) = UPPER( pUF );
      ncdibge        NUMBER;
      ndigibge       NUMBER;
   BEGIN
      OPEN cIbge;
      FETCH cIbge
      INTO ncdibge
          ,ndigibge;
      CLOSE cIbge;
      IF ncdibge IS NOT NULL THEN
         IF ndigibge IS NULL THEN
            ncdibge := ncdibge || FNC_RETORNA_DIG_IBGE( ncdibge );
         ELSE
            ncdibge := ncdibge || ndigibge;
         END IF;
      ELSE
         ncdibge := 0;
      END IF;
      RETURN ncdibge;
   END FNC_RETORNA_COD_IBGE;
   /**************************************************************/
   /******************************************************************************************************************/
   FUNCTION FNC_RETORNA_DIG_IBGE( pCD_IBGE IN NUMBER )
      RETURN NUMBER IS
      i              NUMBER;
      valor          NUMBER;
      soma           NUMBER;
      digito         VARCHAR2( 100 );
      n              NUMBER;
      peso           VARCHAR2( 10 ) := '1212120';
      vCodigo        VARCHAR2( 100 );
   BEGIN
      vCodigo := pCD_IBGE;
      n := LENGTH( vCodigo );
      soma := 0;
      FOR i IN 1 .. n
      LOOP
         valor := SUBSTR( vCodigo, i, 1 ) * SUBSTR( peso, i, 1 );
         IF valor > 9 THEN
            soma := soma + SUBSTR( valor, 1, 1 ) + SUBSTR( valor, 2, 1 );
         ELSE
            soma := soma + valor;
         END IF;
      END LOOP;
      digito := ( 10 - ( soma MOD 10 ) );
      IF ( ( soma MOD 10 ) = 0 ) THEN
         digito := '0';
      END IF;
      RETURN digito;
   EXCEPTION
      WHEN OTHERS THEN
         Raise_Application_Error( -20999, 'Erro no calculo do Digito do IBGE do código da cidade ! SQL ERRO : ' || SQLERRM );
   END FNC_RETORNA_DIG_IBGE;
   /******************************************************************************************************************/
   FUNCTION FNC_VALIDA_CNPJ_CPF( tpDoc VARCHAR2
                                ,nr_cgc_cpf VARCHAR2 )
      RETURN BOOLEAN IS
      digito_calc    VARCHAR2( 2 );
   BEGIN
      IF TO_NUMBER( nr_cgc_cpf ) > 0 THEN
         digito_calc := FNC_VALIDA_CNPJ_CPF_DIG( tpDoc, SUBSTR( nr_cgc_cpf, 1, 13 ) );
         IF digito_calc = SUBSTR( nr_cgc_cpf, 14, 2 ) THEN
            RETURN TRUE;
         ELSE
            RETURN FALSE;
         END IF;
      ELSE
         RETURN FALSE;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN FALSE;
   END FNC_VALIDA_CNPJ_CPF;
   FUNCTION FNC_LIMPA_CARAC_ESP( vtexto IN VARCHAR2 )
      RETURN VARCHAR2 IS
      vaux           VARCHAR2( 1000 );
   BEGIN
      vaux := RTRIM( LTRIM( REPLACE( vTexto, CHR( 9 ), ' ' ) ) );
      vaux := RTRIM( LTRIM( REPLACE( vaux, CHR( 10 ), ' ' ) ) );
      RETURN vAux;
   END;
   FUNCTION FNC_VALIDA_CNPJ_CPF_DIG( tipo IN VARCHAR2
                                    ,numero IN VARCHAR2 )
      RETURN VARCHAR2 IS
      primeiro_dig   NUMBER;
      segundo_dig    NUMBER;
   BEGIN
      IF tipo = 'CPF' THEN
         primeiro_dig :=
            11 - MOD( TO_NUMBER( SUBSTR( numero, 13, 1 ) * 2 ) + TO_NUMBER( SUBSTR( numero, 12, 1 ) * 3 ) + TO_NUMBER( SUBSTR( numero, 11, 1 ) * 4 ) + TO_NUMBER( SUBSTR( numero, 10, 1 ) * 5 ) + TO_NUMBER( SUBSTR( numero, 9, 1 ) * 6 ) + TO_NUMBER( SUBSTR
            ( numero, 8, 1 ) * 7 ) + TO_NUMBER( SUBSTR( numero, 7, 1 ) * 8 ) + TO_NUMBER( SUBSTR( numero, 6, 1 ) * 9 ) + TO_NUMBER( SUBSTR( numero, 5, 1 ) * 10 ), 11 );
         IF ( primeiro_dig = 11 )
         OR ( primeiro_dig = 10 ) THEN
            primeiro_dig := 0;
         END IF;
         segundo_dig :=
            11 - MOD( primeiro_dig * 2 + TO_NUMBER( SUBSTR( numero, 13, 1 ) * 3 ) + TO_NUMBER( SUBSTR( numero, 12, 1 ) * 4 ) + TO_NUMBER( SUBSTR( numero, 11, 1 ) * 5 ) + TO_NUMBER( SUBSTR( numero, 10, 1 ) * 6 ) + TO_NUMBER( SUBSTR( numero, 9, 1 ) * 7 )
            + TO_NUMBER( SUBSTR( numero, 8, 1 ) * 8 ) + TO_NUMBER( SUBSTR( numero, 7, 1 ) * 9 ) + TO_NUMBER( SUBSTR( numero, 6, 1 ) * 10 ) + TO_NUMBER( SUBSTR( numero, 5, 1 ) * 11 ), 11 );
         IF ( segundo_dig = 11 )
         OR ( segundo_dig = 10 ) THEN
            segundo_dig := 0;
         END IF;
         RETURN ( CONCAT( TO_CHAR( primeiro_dig ), TO_CHAR( segundo_dig ) ) );
      ELSIF tipo = 'CGC' THEN
         primeiro_dig :=
            ( 11 - MOD( TO_NUMBER( SUBSTR( numero, 13, 1 ) * 2 ) + TO_NUMBER( SUBSTR( numero, 12, 1 ) * 3 ) + TO_NUMBER( SUBSTR( numero, 11, 1 ) * 4 ) + TO_NUMBER( SUBSTR( numero, 10, 1 ) * 5 ) + TO_NUMBER( SUBSTR( numero, 9, 1 ) * 6 ) + TO_NUMBER(
             SUBSTR                                                                                                                                                                                                                                     (
             numero, 8, 1 ) * 7 ) + TO_NUMBER( SUBSTR( numero, 7, 1 ) * 8 ) + TO_NUMBER( SUBSTR( numero, 6, 1 ) * 9 ) + TO_NUMBER( SUBSTR( numero, 5, 1 ) * 2 ) + TO_NUMBER( SUBSTR( numero, 4, 1 ) * 3 ) + TO_NUMBER( SUBSTR( numero, 3, 1 ) * 4 ) +
             TO_NUMBER                                                                                                                                                                                                                                ( SUBSTR
             ( numero, 2, 1 ) * 5 ), 11 ) );
         IF ( primeiro_dig = 11 )
         OR ( primeiro_dig = 10 ) THEN
            primeiro_dig := 0;
         END IF;
         segundo_dig :=
            ( 11 - MOD( primeiro_dig * 2 + TO_NUMBER( SUBSTR( numero, 13, 1 ) * 3 ) + TO_NUMBER( SUBSTR( numero, 12, 1 ) * 4 ) + TO_NUMBER( SUBSTR( numero, 11, 1 ) * 5 ) + TO_NUMBER( SUBSTR( numero, 10, 1 ) * 6 ) + TO_NUMBER( SUBSTR( numero, 9, 1 ) * 7 )
             + TO_NUMBER( SUBSTR( numero, 8, 1 ) * 8 ) + TO_NUMBER( SUBSTR( numero, 7, 1 ) * 9 ) + TO_NUMBER( SUBSTR( numero, 6, 1 ) * 2 ) + TO_NUMBER( SUBSTR( numero, 5, 1 ) * 3 ) + TO_NUMBER( SUBSTR( numero, 4, 1 ) * 4 ) + TO_NUMBER( SUBSTR( numero, 3
             , 1 ) * 5 ) + TO_NUMBER( SUBSTR( numero, 2, 1 ) * 6 ), 11 ) );
         IF ( segundo_dig = 11 )
         OR ( segundo_dig = 10 ) THEN
            segundo_dig := 0;
         END IF;
         RETURN ( CONCAT( TO_CHAR( primeiro_dig ), TO_CHAR( segundo_dig ) ) );
      ELSE
         RETURN ( 'ER' );
      END IF;
   END FNC_VALIDA_CNPJ_CPF_DIG;
   /******************************************************************************************************************/
   PROCEDURE fnc_insere_linha( vRegistro VARCHAR2
                              ,vLinha VARCHAR2 ) IS
   BEGIN
      INSERT INTO dbamv.tmpmv_ffcv_sped_pis_cofins( cd_linha
                                                   ,ds_registro
                                                   ,ds_linha_arquivo )
          VALUES ( dbamv.seq_sped_pis_cofins.NEXTVAL
                  ,vRegistro
                  ,vLinha );
   END fnc_insere_linha;
   /*******************************************/
   PROCEDURE PRC_GERA_SPED_PIS_COFINS( vcd_log NUMBER
                                      ,dCopetencia DATE
                                      ,psnretificador VARCHAR2
                                      ,psNUM_REC_ANTERIOR VARCHAR2
                                      ,psndiferimento VARCHAR2
                                      ,psEmpresa DBAMV.MULTI_EMPRESAS.CD_MULTI_EMPRESA%TYPE ) IS
      -- Todas variaveis foram para global da package, para possibilitar a divisão de procedures.
      consolidadora  NUMBER;
      dtCancIni      DATE;
   --sps
   BEGIN
      ncontaM990 := 0;
      ncontaM400 := 0;
      ncontaM410 := 0;
      ncontaM800 := 0;
      ncontaM810 := 0;
      nContaF600 := 0;
      nContaF700 := 0;
      contaBlcF010 := 0;
      nContaConfigF500 := 0;
      nContaConfigF525 := 0;
      nContaConfigF509 := 0;
      nConta1900 := 0;
      ContaBlc0 := 0;
      ContaBlcA := 0;
      contaBlcA170 := 0;
      contaSeqA170 := 0;
      contaBlctotA170 := 0;
      ContaBlc0150 := 0;
      ContaBlc0200 := 0;
      ContaBlc0500 := 0;
      contaBlcA100 := 0;
      contaBlcA111 := 0;
      ContaBlcATot := 0;
      contatotalArq := 0;
      ContaBlc0111 := 0;
      conta9900 := 0;
      conta9990 := 0;
      ncontaRegistroM := 0;
      ncontam210 := 0;
      ncontam610 := 0;
      ncontam630 := 0;
      ncontam300 := 0;
      ncontam700 := 0;
      ncontaA010 := 0;
      nconta0140 := 0;
      ncontam230 := 0;
      param_nVLRECM410 := 0;
      nconta9999 := 0;
      nVlItfat := 0;
      nVL_RET_CUM_pis := 0;
      nVL_OUT_DED_CUM_pis := 0;
      nVL_RET_CUM_cofins := 0;
      nVL_OUT_DED_CUM_cofins := 0;
      vsndiferimento := psndiferimento;
      --dbamv.pkg_mv2000.atribui_empresa('1');
      consolidadora := dbamv.pkg_mv2000.le_empresa;
      --
      /********************/
      dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC1_VALIDA_DT_CANC_INI( );
      --
      OPEN cDtCancIni;
      FETCH cDtCancIni
      INTO dtCancIni;
      CLOSE cDtCancIni;
      dtInicio := dCopetencia;
      dtfim := LAST_DAY( dCopetencia );
      vdtInicio := TO_CHAR( dCopetencia, 'ddmmyyyy' );
      vdtfim := TO_CHAR( LAST_DAY( dCopetencia ), 'ddmmyyyy' );
      --
      -- Dados da empresa
      OPEN cDadosEmpresa;
      FETCH cDadosEmpresa
      INTO rDadosEmpresa;
      CLOSE cDadosEmpresa;
      -- Chamada dos registros referente a empresa
      OPEN cDadosEmpSped;
      FETCH cDadosEmpSped
      INTO rDadosEmpSped;
      CLOSE cDadosEmpSped;
      dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC2_DADOS_EMPRESA( dCopetencia, psnretificador, psNUM_REC_ANTERIOR );
      IF rDadosEmpSped.cd_ind_reg_cum = 9
      OR rDadosEmpSped.cd_ind_reg_cum IS NULL THEN
         /** Chama dos registro referente ao BLOCO A: DOCUMENTOS FISCAIS - SERVIÇOS (NÃO SUJEITOS AO ICMS) *****************************************************/
         dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC3_REGIME_COMP_DET_BLOCOA( dCopetencia );
      END IF;
      /***************************************************** BLOCO C:  DOCUMENTOS FISCAIS I - MERCADORIAS (ICMS/IPI) *****************************************************/
      -- Este bloco não deverá conter informações,pois os hospitais não recolhem ICMS
      -- REGISTRO C001: ABERTURA DO BLOCO C
      --C  Documentos Fiscais I ¿ Mercadorias (ICMS/IPI)
      dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC4_MERC_ICMS_IPI_BLOCOC( dCopetencia );
      --
      /************************************  BLOCO D: DOCUMENTOS FISCAIS II - SERVIÇOS (ICMS) **************/
      -- Este bloco não deverá conter informações
      -- REGISTRO D001: ABERTURA DO BLOCO D
      --
      dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC5_SERV_ICMS_IPI_BLOCOD( dCopetencia );
      --
      /**************************  BLOCO F: DEMAIS DOCUMENTOS E OPERAÇÕES **********************/
      -- Este bloco não deverá conter informações
      -- REGISTRO D001: ABERTURA DO BLOCO D
      dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC6_DOC_OPE_BLOCOF( dCopetencia, consolidadora );
      --
      --
      /*************  BLOCO M ¿ APURAÇÃO DA CONTRIBUIÇÃO E CRÉDITO DO PIS/PASEP E DA COFINS ****************************/
      -- PDA 534996 - Início
      /************ Bloco P : Apuração da Contribuição Previdenciária sobre a Receita Bruta ************************************************************************************/
      --
      dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC7_REGIME_COMP_DET_BLOCOM( dCopetencia );
      --
      --
      /*****************************-- REGISTRO P001: ABERTURA DO BLOCO P ******************************/
      /***********BLOCO_P - Apuração da Contribuição Previdenciária sobre a Receita Bruta  *************/
      --                                  123456789012345678901234567890
      dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC8_CONTR_PREV_RECBRU_BLOCOP( dCopetencia );
      --
      --
      -- PDA 534996 - Fim
      /************ BLOCO 1: COMPLEMENTO DA ESCRITURAÇÃO ¿ CONTROLE DE SALDOS DE CRÉDITOS E DE RETENÇÕES *****/
      /************ OPERAÇÕES EXTEMPORÂNEAS E OUTRAS INFORMAÇÕES **********************/
      --
      dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC9_SALDO_CRED_RET_BLOCO1( dCopetencia );
      --
      --
      /***************************************************************  BLOCO 9: CONTROLE E ENCERRAMENTO DO ARQUIVO DIGITAL *****************************************************/
      PRC99_FECHAMENTO( dCopetencia );
   --
   EXCEPTION
      WHEN IBGE_NOT_FOUND THEN
         Raise_Application_Error( -20997, 'ERRO : Código IBGE da cidade da nota ' || nNrNotaIBGE || ' Verifica se existe código do IBGE da Cidade e UF informados na Nota  ' );
      WHEN CPF_NOT_FOUND THEN
         Raise_Application_Error( -20998, 'ERRO : Nota Fiscal\RPS sem nùmero do CPF ou CNPJ do cliente |' || nNrNotaIBGE );
      WHEN CPF_CARACTER_INVALIDO THEN
         Raise_Application_Error( -20999, 'ERRO : CPF\ CNPJ da Nota Fiscal\RPS ' || nNrNotaIBGE || ' Iválido ! ' );
   --
   END PRC_GERA_SPED_PIS_COFINS;
   /*****************************************/
   PROCEDURE PRC1_VALIDA_DT_CANC_INI IS
      --
      CURSOR cEmpresa IS
         SELECT cd_multi_empresa
           FROM dbamv.multi_empresas;
      --
      CURSOR cConfig IS
         SELECT c.chave
           FROM dbamv.configuracao c
          WHERE UPPER( c.cd_sistema ) = 'FCCT'
            AND c.chave = 'SN_SPED_DT_CANC_INI';
      --
      CURSOR cSeq IS
         SELECT dbamv.seq_configuracao.NEXTVAL
           FROM sys.DUAL;
      --
      vcConfig       cConfig%ROWTYPE;
      nSeq           NUMBER;
   --
   BEGIN
      --
      OPEN cConfig;
      FETCH cConfig
      INTO vcConfig;
      IF cConfig%NOTFOUND THEN
         --
         FOR vcEmpresa IN cEmpresa
         LOOP
            --
            OPEN cSeq;
            FETCH cSeq
            INTO nSeq;
            CLOSE cSeq;
            INSERT INTO dbamv.configuracao( cd_sistema
                                           ,chave
                                           ,valor
                                           ,sn_somente_leitura
                                           ,cd_configuracao
                                           ,cd_configuracao_processo
                                           ,ds_configuracao
                                           ,cd_multi_empresa )
                VALUES ( 'FCCT'
                        ,'SN_SPED_DT_CANC_INI'
                        ,TO_CHAR( SYSDATE, 'YYYYMMDD' )
                        ,'N'
                        ,nSeq
                        ,NULL
                        ,'SPED - DATA DE CONTROLE CANC INI'
                        ,vcEmpresa.cd_multi_empresa );
         END LOOP;
      --
      END IF;
      --
      COMMIT;
   --
   END PRC1_VALIDA_DT_CANC_INI;
   /*************************************************************/
   PROCEDURE PRC2_DADOS_EMPRESA( dCopetencia DATE
                                ,psnretificador VARCHAR2
                                ,psNUM_REC_ANTERIOR VARCHAR2 ) IS
      --
      CURSOR c0500( dCopetencia DATE
                   ,vcnpj VARCHAR2 ) IS
           SELECT DISTINCT '0500' C01
                          ,TO_CHAR( dt_criacao, 'DDMMYYYY' ) C02
                          ,DECODE( LPAD( SUBSTR( p.cd_contabil, 1, 1 ), 2, '0' ), '01', '01', DECODE( LPAD( SUBSTR( p.cd_contabil, 1, 1 ), 2, '0' ), '02', '02', '09' ) ) C03
                          ,p.tp_conta C04
                          ,p.cd_grau_da_conta C05
                          ,p.cd_contabil C06
                          ,p.ds_conta C07
                          ,p.Cd_Cta_Ref_Sped C08
                          ,NULL C09
             FROM ( SELECT c.cd_reduzido
                      FROM ( -- Bloco A
                            SELECT  n.cd_nota_fiscal cd_nota_fiscal
                               FROM dbamv.nota_fiscal n
                              WHERE TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                                AND ( ( NVL( n.cd_status, 'E' ) = 'E' )
                                  OR ( n.cd_status = 'C'
                                  AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) <> TO_CHAR( dCopetencia, 'MM/YYYY' )
                                  AND n.dt_cancelamento > dtCancIni ) )
                                AND NVL( n.vl_total_nota, 0 ) > 0
                                AND cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                                AND dbamv.pkg_mv2000.le_cliente <> 1736
                             UNION ALL
                             SELECT n.cd_nota_fiscal cd_nota_fiscal
                               FROM dbamv.nota_fiscal n
                              WHERE TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                                AND ( ( NVL( n.cd_status, 'E' ) = 'E' )
                                  OR ( n.cd_status = 'C'
                                  AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) <> TO_CHAR( dCopetencia, 'MM/YYYY' )
                                  AND n.dt_cancelamento > dtCancIni ) )
                                AND NVL( n.vl_total_nota, 0 ) > 0
                                AND cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                                AND dbamv.pkg_mv2000.le_cliente = 1736
                                AND n.cd_formulario_nf IN (SELECT cd_formulario_nf
                                                             FROM dbamv.formulario_nf_cnpj
                                                            WHERE ds_cnpj = vcnpj) ) n
                          ,CON_REC C
                     WHERE n.cd_nota_fiscal = c.cd_nota_fiscal
                       AND cd_exp_contabilidade IS NOT NULL
                    UNION ALL
                    SELECT c.cd_reduzido
                      FROM ( SELECT n.cd_nota_fiscal cd_nota_fiscal
                               FROM dbamv.nota_fiscal n
                              WHERE TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                                AND ( ( NVL( n.cd_status, 'E' ) = 'E' )
                                  OR ( n.cd_status = 'C'
                                  AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) <> TO_CHAR( dCopetencia, 'MM/YYYY' )
                                  AND n.dt_cancelamento > dtCancIni ) )
                                AND NVL( n.vl_total_nota, 0 ) > 0
                                AND cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                                AND dbamv.pkg_mv2000.le_cliente <> 1736
                             UNION ALL
                             SELECT n.cd_nota_fiscal cd_nota_fiscal
                               FROM dbamv.nota_fiscal n
                              WHERE TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                                AND ( ( NVL( n.cd_status, 'E' ) = 'E' )
                                  OR ( n.cd_status = 'C'
                                  AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) <> TO_CHAR( dCopetencia, 'MM/YYYY' )
                                  AND n.dt_cancelamento > dtCancIni ) )
                                AND NVL( n.vl_total_nota, 0 ) > 0
                                AND cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                                AND dbamv.pkg_mv2000.le_cliente = 1736
                                AND n.cd_formulario_nf IN (SELECT cd_formulario_nf
                                                             FROM dbamv.formulario_nf_cnpj
                                                            WHERE ds_cnpj = vcnpj) ) n
                          ,CON_REC C
                          ,RAT_CONREC R
                     WHERE n.cd_nota_fiscal = c.cd_nota_fiscal
                       AND C.CD_CON_REC = R.CD_CON_REC
                       AND c.cd_exp_contabilidade IS NOT NULL
                    UNION ALL
                    -- BLOCO F
                    SELECT ivc.cd_reduzido
                      FROM dbamv.empresa_sped_pis_cofins pc
                          ,dbamv.visao_contabil vc
                          ,dbamv.it_visao_contabil ivc
                     WHERE pc.cd_visao_cred_0 = vc.cd_visao_contabil
                       AND ivc.cd_visao_contabil = vc.cd_visao_contabil
                       AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                    UNION ALL
                    SELECT ivc.cd_reduzido
                      FROM dbamv.empresa_sped_pis_cofins pc
                          ,dbamv.visao_contabil vc
                          ,dbamv.it_visao_contabil ivc
                     WHERE pc.cd_visao_contrib_1 = vc.cd_visao_contabil
                       AND ivc.cd_visao_contabil = vc.cd_visao_contabil
                       AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                    UNION ALL
                    SELECT ivc.cd_reduzido
                      FROM dbamv.visao_contabil vc
                          ,dbamv.it_visao_contabil ivc
                     WHERE vc.cd_visao_contabil = 9
                       AND ivc.cd_visao_contabil = vc.cd_visao_contabil
                       AND vc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                       AND dbamv.pkg_mv2000.le_cliente = 267
                    UNION ALL
                    SELECT ivc.cd_reduzido
                      FROM dbamv.empresa_sped_pis_cofins pc
                          ,dbamv.visao_contabil vc
                          ,dbamv.it_visao_contabil ivc
                     WHERE pc.cd_visao_contrib_2 = vc.cd_visao_contabil
                       AND ivc.cd_visao_contabil = vc.cd_visao_contabil
                       AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa ) n
                 ,dbamv.plano_contas p
                 ,dbamv.MULTI_EMPRESAS m
            WHERE n.cd_reduzido = p.cd_reduzido
              AND p.cd_multi_empresa = m.cd_multi_empresa
         ORDER BY p.cd_contabil;
      --
      CURSOR cDadosTomador( vcnpj VARCHAR2 ) IS
           SELECT DISTINCT *
             FROM ( SELECT n.cd_nota_fiscal
                          ,n.nm_cliente
                          ,n.nr_cgc_cpf
                          ,DECODE( n.nr_nota_fiscal_nfe, NULL, n.nr_id_nota_fiscal, n.nr_nota_fiscal_nfe ) NUM_DOC
                          ,n.cd_verificacao_nfe
                          ,DECODE( n.hr_emissao_nfe, NULL, n.dt_emissao, n.hr_emissao_nfe ) DT_DOC
                          ,n.nm_uf
                          ,n.nm_cidade
                          ,n.nr_id_nota_fiscal
                          ,n.tp_pessoa_rps
                          ,n.cd_pais
                          ,'A' q
                      FROM dbamv.nota_fiscal n
                     WHERE TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND NVL( n.vl_total_nota, 0 ) > 0
                       AND dbamv.pkg_mv2000.le_cliente <> 1736 -- PDA 572267
                       AND ( rDadosEmpSped.cd_ind_reg_cum = '9'
                         OR rDadosEmpSped.cd_ind_reg_cum IS NULL )
                    UNION ALL
                    SELECT n.cd_nota_fiscal
                          ,n.nm_cliente
                          ,n.nr_cgc_cpf
                          ,DECODE( n.nr_nota_fiscal_nfe, NULL, n.nr_id_nota_fiscal, n.nr_nota_fiscal_nfe ) NUM_DOC
                          ,n.cd_verificacao_nfe
                          ,DECODE( n.hr_emissao_nfe, NULL, n.dt_emissao, n.hr_emissao_nfe ) DT_DOC
                          ,n.nm_uf
                          ,n.nm_cidade
                          ,n.nr_id_nota_fiscal
                          ,n.tp_pessoa_rps
                          ,n.cd_pais
                          ,'A' q
                      FROM dbamv.nota_fiscal n
                          ,dbamv.con_rec cr
                          ,Dbamv.Itcon_Rec ir
                          ,dbamv.reccon_rec rcr
                          ,dbamv.multi_empresas me
                     WHERE TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND NVL( n.vl_total_nota, 0 ) > 0
                       AND ( me.CD_MULTI_EMPRESA = dbamv.pkg_mv2000.le_empresa
                         OR me.CD_MULTI_EMPRESA_CONSOL = dbamv.pkg_mv2000.le_empresa )
                       AND me.sn_ativo = 'S'
                       AND n.cd_multi_empresa = me.CD_MULTI_EMPRESA
                       AND n.cd_nota_fiscal = cr.cd_nota_fiscal
                       AND cr.cd_con_rec = ir.cd_con_rec
                       AND ir.cd_itcon_rec = rcr.cd_itcon_rec
                       AND rDadosEmpSped.cd_ind_reg_cum = '1'
                    -- PDA 572267 - Inicio - retornado os tomadores por empresa
                    UNION ALL
                    SELECT n.cd_nota_fiscal
                          ,n.nm_cliente
                          ,n.nr_cgc_cpf
                          ,DECODE( n.nr_nota_fiscal_nfe, NULL, n.nr_id_nota_fiscal, n.nr_nota_fiscal_nfe ) NUM_DOC
                          ,n.cd_verificacao_nfe
                          ,DECODE( n.hr_emissao_nfe, NULL, n.dt_emissao, n.hr_emissao_nfe ) DT_DOC
                          ,n.nm_uf
                          ,n.nm_cidade
                          ,n.nr_id_nota_fiscal
                          ,n.tp_pessoa_rps
                          ,n.cd_pais
                          ,'A' q
                      FROM dbamv.nota_fiscal n
                     WHERE TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND NVL( n.vl_total_nota, 0 ) > 0
                       AND dbamv.pkg_mv2000.le_cliente = 1736
                       AND n.cd_formulario_nf IN (SELECT cd_formulario_nf
                                                    FROM dbamv.formulario_nf_cnpj
                                                   WHERE ds_cnpj = vcnpj)
                    -- PDA 572267 - Fim
                    UNION ALL
                    SELECT DISTINCT f.cd_fornecedor cd_nota_fiscal
                                   ,f.nm_fornecedor nm_cliente
                                   ,DECODE( f.tp_fornecedor, 'F', TO_CHAR( f.nr_cgc_cpf, '00000000000' ), LPAD( TO_CHAR( f.nr_cgc_cpf, '00000000000000' ), 14, '0' ) ) nr_cgc_cpf
                                   ,0 NUM_DOC
                                   ,' ' cd_verificacao_nfe
                                   ,SYSDATE DT_DOC
                                   ,c.cd_uf
                                   ,c.nm_cidade
                                   ,0 nr_id_nota_fiscal
                                   ,f.tp_fornecedor
                                   ,c.cd_pais
                                   ,'B ' q
                      FROM dbamv.fornecedor f
                          ,dbamv.cidade c
                     WHERE c.cd_cidade = f.cd_cidade(+)
                       AND NVL( f.sn_ativo, 'S' ) = 'S'
                       AND NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'N'
                       -- PDA 546073 - Início
                       AND f.cd_fornecedor IN (SELECT cp.cd_fornecedor
                                                 FROM dbamv.lcto_contabil lct
                                                     ,dbamv.con_pag cp
                                                WHERE lct.cd_reduzido_debito IN (SELECT cd_reduzido
                                                                                   FROM dbamv.it_visao_contabil
                                                                                  WHERE cd_cst_pis IS NOT NULL)
                                                  AND TO_CHAR( dt_lcto, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                                                  AND cd_origem = cp.cd_con_pag
                                               UNION ALL
                                               SELECT cr.cd_fornecedor
                                                 FROM dbamv.lcto_contabil lct
                                                     ,dbamv.con_rec cr
                                                WHERE lct.cd_reduzido_debito IN (SELECT cd_reduzido
                                                                                   FROM dbamv.it_visao_contabil
                                                                                  WHERE cd_cst_pis IS NOT NULL)
                                                  AND TO_CHAR( dt_lcto, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                                                  AND cd_origem = cr.cd_con_rec)
                       -- PDA 546073 - Fim
                       AND NOT EXISTS (SELECT cd_nota_fiscal
                                         FROM dbamv.nota_fiscal nf
                                             ,dbamv.convenio c
                                        WHERE c.cd_convenio = nf.cd_convenio
                                          AND c.cd_fornecedor = f.cd_fornecedor
                                          AND c.tp_convenio = 'P') )
         ORDER BY NUM_DOC;
         --ORDER BY cd_nota_fiscal;
      CURSOR cNotaGruFat( dtinicio DATE
                         ,dtfim DATE ) IS
         SELECT DISTINCT i.CD_GRU_FAT
                        ,gf.DS_GRU_FAT
           FROM dbamv.nota_fiscal n
               ,dbamv.itnota_fiscal i
               ,dbamv.gru_fat gf
          WHERE n.cd_nota_fiscal = i.cd_nota_fiscal
            AND gf.cd_gru_fat = i.cd_gru_fat
            AND n.dt_emissao BETWEEN dtinicio AND dtfim
            AND ( rDadosEmpSped.cd_ind_reg_cum = '9'
              OR rDadosEmpSped.cd_ind_reg_cum IS NULL )
         UNION
         SELECT DISTINCT i.CD_GRU_FAT
                        ,gf.DS_GRU_FAT
           FROM dbamv.nota_fiscal n
               ,dbamv.con_rec cr
               ,Dbamv.Itcon_Rec ir
               ,dbamv.reccon_rec rcr
               ,dbamv.itnota_fiscal i
               ,dbamv.gru_fat gf
               ,dbamv.multi_empresas me
          WHERE TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
            AND NVL( n.vl_total_nota, 0 ) > 0
            AND n.cd_multi_empresa = me.cd_multi_empresa
            AND ( me.CD_MULTI_EMPRESA = dbamv.pkg_mv2000.le_empresa
              OR me.CD_MULTI_EMPRESA_CONSOL = dbamv.pkg_mv2000.le_empresa )
            AND n.cd_nota_fiscal = cr.cd_nota_fiscal
            AND cr.cd_con_rec = ir.cd_con_rec
            AND ir.cd_itcon_rec = rcr.cd_itcon_rec
            AND n.cd_nota_fiscal = i.cd_nota_fiscal
            AND gf.cd_gru_fat = i.cd_gru_fat
            AND rDadosEmpSped.cd_ind_reg_cum = '1'
         UNION
         SELECT 0 cd_gru_fat
               ,'PRODUTOS ALIQUOTA ZERO' ds_gru_fat
           FROM DUAL
         UNION
         SELECT ivc.cd_reduzido CD_GRU_FAT
               ,pct.ds_conta DS_GRU_FAT
           FROM dbamv.empresa_sped_pis_cofins pc
               ,dbamv.visao_contabil vc
               ,dbamv.it_visao_contabil ivc
               ,dbamv.plano_contas pct
          WHERE pc.cd_visao_cred_0 = vc.cd_visao_contabil
            AND ivc.cd_visao_contabil = vc.cd_visao_contabil
            AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
            AND pct.cd_reduzido = ivc.cd_reduzido
         UNION
         SELECT ivc.cd_reduzido CD_GRU_FAT
               ,pct.ds_conta DS_GRU_FAT
           FROM dbamv.empresa_sped_pis_cofins pc
               ,dbamv.visao_contabil vc
               ,dbamv.it_visao_contabil ivc
               ,dbamv.plano_contas pct
          WHERE pc.cd_visao_contrib_1 = vc.cd_visao_contabil
            AND ivc.cd_visao_contabil = vc.cd_visao_contabil
            AND pct.cd_reduzido = ivc.cd_reduzido
            AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
         UNION
         SELECT ivc.cd_reduzido CD_GRU_FAT
               ,pct.ds_conta DS_GRU_FAT
           FROM dbamv.empresa_sped_pis_cofins pc
               ,dbamv.visao_contabil vc
               ,dbamv.it_visao_contabil ivc
               ,dbamv.plano_contas pct
          WHERE pc.cd_visao_contrib_2 = vc.cd_visao_contabil
            AND ivc.cd_visao_contabil = vc.cd_visao_contabil
            AND pct.cd_reduzido = ivc.cd_reduzido
            AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
         UNION
         SELECT ivc.cd_reduzido CD_GRU_FAT
               ,pc.ds_conta DS_GRU_FAT
           FROM dbamv.visao_contabil vc
               ,dbamv.it_visao_contabil ivc
               ,dbamv.plano_contas pc
          WHERE vc.cd_visao_contabil = 9
            AND ivc.cd_visao_contabil = vc.cd_visao_contabil
            AND vc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
            AND pc.cd_reduzido = ivc.cd_reduzido
            AND dbamv.pkg_mv2000.le_cliente = 267;
      CURSOR c0140 IS
           SELECT me.cd_multi_empresa
                 ,me.cd_cgc
                 ,me.Ds_Razao_Social
                 ,me.CD_UF
                 ,c.Cd_Ibge
                 ,me.cd_imun
             FROM dbamv.multi_empresas me
                 ,dbamv.cidade c
            WHERE me.cd_cidade = c.cd_cidade
              AND ( me.CD_MULTI_EMPRESA = dbamv.pkg_mv2000.le_empresa
                OR me.CD_MULTI_EMPRESA_CONSOL = dbamv.pkg_mv2000.le_empresa )
              AND me.sn_ativo = 'S'
              AND EXISTS (SELECT n.cd_nota_fiscal
                            FROM dbamv.nota_fiscal n
                                ,dbamv.con_rec cr
                                ,Dbamv.Itcon_Rec ir
                                ,dbamv.reccon_rec rcr
                           WHERE TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) >= TO_CHAR( dCopetencia, 'MM/YYYY' )
                             AND NVL( n.vl_total_nota, 0 ) > 0
                             AND n.cd_multi_empresa = me.cd_multi_empresa
                             AND n.cd_nota_fiscal = cr.cd_nota_fiscal
                             AND cr.cd_con_rec = ir.cd_con_rec
                             AND ir.cd_itcon_rec = rcr.cd_itcon_rec)
         ORDER BY me.CD_MULTI_EMPRESA_CONSOL DESC
                 ,me.CD_MULTI_EMPRESA;
      --
      rc0500         c0500%ROWTYPE;
      r0140          c0140%ROWTYPE;
      rcNotaGruFat   cNotaGruFat%ROWTYPE;
      rDadosTomador  cDadosTomador%ROWTYPE;
   BEGIN
      --
      vNOME := SUBSTR( rDadosEmpresa.DS_RAZAO_SOCIAL, 0, 100 );
      vCNPJ := SUBSTR( LPAD( rDadosEmpresa.CD_CGC, 14, '0' ), 0, 14 );
      vUF := SUBSTR( rDadosEmpresa.CD_UF, 0, 2 );
      BEGIN
         vCOD_MUN := rDadosEmpresa.CD_IBGE || FNC_RETORNA_DIG_IBGE( rDadosEmpresa.CD_IBGE );
      EXCEPTION
         WHEN OTHERS THEN
            vCOD_MUN := '2604106';
      END;
      vNOMEContador := SUBSTR( rDadosEmpresa.DS_NOME_CONTADOR, 0, 100 );
      vCPFcontador := SUBSTR( rDadosEmpresa.CD_CPF_CONTADOR, 0, 11 );
      vCRC := SUBSTR( rDadosEmpresa.CD_CRC_CONTADOR, 0, 15 );
      vIM := SUBSTR( rDadosEmpresa.CD_IMUN, 0, 14 );
      --
      nSPED_COD_INC_TRIB := rDadosEmpSped.cd_COD_INC_TRIB;
      nSPED_IND_APRO_CRED := rDadosEmpSped.cd_IND_APRO_CRED;
      /************************************************************ BLOCO 0: ABERTURA, IDENTIFICAÇÃO E REFERÊNCIAS **************************************************************/
      --
      -- REGISTRO 0000: ABERTURA DO ARQUIVO DIGITAL E IDENTIFICAÇÃO DA PESSOA JURÍDICA
      --
      -- PDA 572267 - Fim
      IF dCopetencia < TO_DATE( '01/07/2012', 'dd/mm/yyyy' ) THEN
         vversao := '002';
      ELSE
         vversao := '003';
      END IF;
      -- PDA 572267 - Fim
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|0000'; -- 01
      vlinha := vlinha || '|' || vversao; -- 02 -- PDA 572267
      vlinha := vlinha || '|' || NVL( psnretificador, '0' ); -- 03
      vlinha := vlinha || '|'; -- 04
      vlinha := vlinha || '|' || psNUM_REC_ANTERIOR; -- 05
      vlinha := vlinha || '|' || vdtInicio; -- 06
      vlinha := vlinha || '|' || vdtfim; -- 07
      vlinha := vlinha || '|' || NVL( vNOME, 'NULAO' ); -- 08
      vlinha := vlinha || '|' || vCNPJ; -- 09
      vlinha := vlinha || '|' || vUF; -- 10
      vlinha := vlinha || '|' || vCOD_MUN; -- 11
      vlinha := vlinha || '|'; -- 12
      vlinha := vlinha || '|'; -- 13
      vlinha := vlinha || '|1'; -- 14 -> Pretação de Serviço (IND_ATIV) - FIXO
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '0000', vlinha );
      ContaBlc0 := ContaBlc0 + 1;
      -- REGISTRO 0001: ABERTURA DO BLOCO 0
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|0001';
      vlinha := vlinha || '|0';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '0001', vlinha );
      ContaBlc0 := ContaBlc0 + 1;
      -- REGISTRO 0100: DADOS DO CONTABILISTA
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|0100';
      vlinha := vlinha || '|' || vNOMEContador;
      vlinha := vlinha || '|' || vCPFcontador;
      vlinha := vlinha || '|' || LPAD( vCRC, 11, '0' );
      vlinha := vlinha || '|';
      vlinha := vlinha || '|';
      vlinha := vlinha || '|';
      vlinha := vlinha || '|';
      vlinha := vlinha || '|';
      vlinha := vlinha || '|';
      vlinha := vlinha || '|';
      vlinha := vlinha || '|';
      vlinha := vlinha || '|';
      vlinha := vlinha || '|';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '0100', vlinha );
      ContaBlc0 := ContaBlc0 + 1;
      --
      -- REGISTRO 0110: REGIMES DE APURAÇÃO DA CONTRIBUIÇÃO SOCIAL E DE APROPRIAÇÃO DE CRÉDITO
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|0110';
      vlinha := vlinha || '|' || nSPED_COD_INC_TRIB; /* -- > 1 ¿ Escrituração de operações com incidência exclusivamente no regime não-cumulativo;
                                                             2 ¿ Escrituração de operações com incidência exclusivamente no regime cumulativo;
                                                             3 ¿ Escrituração de operações com incidência nos regimes não-cumulativo e cumulativo.*/
      vlinha := vlinha || '|' || nSPED_IND_APRO_CRED; -- >  1 ¿ Método de Apropriação Direta  2 ¿ Método de Rateio Proporcional (Receita Bruta)
      vlinha := vlinha || '|';
      IF vversao <> '002' THEN -- PDA 572267 - Inicio
         vlinha := vlinha || '|' || rDadosEmpSped.cd_ind_reg_cum; -- PDA 533705
      END IF; -- PDA 572267 - Fim
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '0110', vlinha );
      ContaBlc0 := ContaBlc0 + 1;
      ContaBlc0111 := 0;
      --
      OPEN cTotalRecBruCumu( dCopetencia );
      FETCH cTotalRecBruCumu
      INTO nRecBruCumu;
      CLOSE cTotalRecBruCumu;
      --
      IF nSPED_IND_APRO_CRED = '2'
     AND nSPED_COD_INC_TRIB IN ('1', '3') THEN
         -- REGISTRO 0111: TABELA DE RECEITA BRUTA MENSAL PARA FINS DE RATEIO DE CRÉDITOS COMUNS
         --
         OPEN cRecNCumTribu( dCopetencia );
         FETCH cRecNCumTribu
         INTO nRecNCumTribu0111
             ,nRecNCumNTribu0111;
         CLOSE cRecNCumTribu;
         --
         IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'S' THEN
            nRecNCumTribu0111 := 0;
            nRecNCumNTribu0111 := 0;
            nRecBruCumu := 0;
         END IF;
         --nRecBruCumu := 0;
         --
         nTotalRec0111 := NVL( nRecNCumTribu0111, 0 ) + NVL( nRecNCumNTribu0111, 0 ) + NVL( nRecBruCumu, 0 );
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|0111'; -- 01
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nRecNCumTribu0111, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 02
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nRecNCumNTribu0111, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 03
         vlinha := vlinha || '|0'; -- 04  - Receita Bruta Não-Cumulativa ¿ Exportação
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nRecBruCumu, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 05
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nTotalRec0111, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 06
         vlinha := vlinha || '|';
         --
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '0111', vlinha );
         ContaBlc0 := ContaBlc0 + 1;
         ContaBlc0111 := NVL( ContaBlc0111, 0 ) + 1;
      --
      END IF;
      --
      -- REGISTRO 0140: TABELA DE CADASTRO DE ESTABELECIMENTO
      --
      IF pkg_mv2000.le_cliente <> 1736 THEN -- PDA 572267
         --
         FOR r0140 IN c0140
         LOOP
            vlinha := NULL;
            vNOME := SUBSTR( r0140.DS_RAZAO_SOCIAL, 0, 100 );
            vCNPJ := SUBSTR( LPAD( r0140.CD_CGC, 14, '0' ), 0, 14 );
            vUF := SUBSTR( r0140.CD_UF, 0, 2 );
            BEGIN
               vCOD_MUN := r0140.CD_IBGE || FNC_RETORNA_DIG_IBGE( r0140.CD_IBGE );
            EXCEPTION
               WHEN OTHERS THEN
                  vCOD_MUN := '2604106';
            END;
            vIM := SUBSTR( r0140.CD_IMUN, 0, 14 );
            --
            vlinha := vlinha || '|0140';
            vlinha := vlinha || '|';
            vlinha := vlinha || '|' || vNOME;
            vlinha := vlinha || '|' || vCNPJ;
            vlinha := vlinha || '|' || vUF;
            vlinha := vlinha || '|';
            vlinha := vlinha || '|' || vCOD_MUN;
            vlinha := vlinha || '|' || vIM;
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( '0140', vlinha );
            ContaBlc0 := ContaBlc0 + 1;
            nconta0140 := nconta0140 + 1;
         END LOOP;
      ELSE -- PDA 572267 - Inicio
         FOR rcEmpresa0140 IN cEmpresa0140( dCopetencia )
         LOOP
            --
            vCOD_MUN := '3504107';
            vUF := 'SP';
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|0140';
            vlinha := vlinha || '|' || nconta0140;
            vlinha := vlinha || '|' || rcEmpresa0140.NM_EMPRESA;
            vlinha := vlinha || '|' || rcEmpresa0140.DS_CNPJ;
            vlinha := vlinha || '|' || vUF;
            vlinha := vlinha || '|';
            vlinha := vlinha || '|' || vCOD_MUN;
            vlinha := vlinha || '|' || rcEmpresa0140.DS_INSCRICAO_MUNICIPAL;
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( '0140', vlinha );
            ContaBlc0 := ContaBlc0 + 1;
            nconta0140 := nconta0140 + 1;
            --
            --
            -- REGISTRO 0150: TABELA DE CADASTRO DO PARTICIPANTE
            --
            nCdPais := NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'CD_NACION_BRASILEIRA' ), 1 ); -- PDA 537790
            IF NVL( nRecBruCumu, 0 ) > 0 THEN
               FOR rDadosTomador IN cDadosTomador( rcEmpresa0140.DS_CNPJ )
               LOOP
                  IF NVL( rDadosTomador.cd_pais, nCdPais ) = nCdPais THEN -- PDA 537790
                     nNrNotaIBGE := rDadosTomador.nr_id_nota_fiscal;
                     --
                     vCODMUNCliente := FNC_RETORNA_COD_IBGE( rDadosTomador.nm_uf, rDadosTomador.nm_cidade );
                     IF LENGTH( vCODMUNCliente ) <> 7 THEN
                        vCODMUNCliente := vCOD_MUN;
                     END IF;
                     IF vCOD_MUN = '5300108' THEN
                        vCODMUNCliente := vCOD_MUN;
                     END IF;
                     --
                     -- Trata o CPF\CNPJ .
                     vCPFcliente := NULL;
                     vCNPJcliente := NULL;
                     bErroCnpjCpf := FALSE;
                     IF rdadostomador.nr_cgc_cpf IS NOT NULL THEN
                        -- Verifica caracter inválido
                        DECLARE
                           nValidaCPFCNPJ NUMBER;
                        BEGIN
                           rDadosTomador.nr_cgc_cpf := REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( rDadosTomador.nr_cgc_cpf, '-', '' ), '.', '' ), '/', '' ), '\', '' ), ' ', '' );
                           nValidaCPFCNPJ := TO_NUMBER( rDadosTomador.nr_cgc_cpf );
                           -- RDBS
                           IF rDadosTomador.tp_pessoa_rps = 'F' THEN
                              IF NOT FNC_VALIDA_CNPJ_CPF( 'CPF', LPAD( nValidaCPFCNPJ, 15, '0' ) ) THEN
                                 bErroCnpjCpf := TRUE;
                              END IF;
                           END IF;
                           IF rDadosTomador.tp_pessoa_rps = 'J' THEN
                              IF NOT FNC_VALIDA_CNPJ_CPF( 'CGC', LPAD( nValidaCPFCNPJ, 15, '0' ) ) THEN
                                 bErroCnpjCpf := TRUE;
                              END IF;
                           END IF;
                        -- RDBS
                        EXCEPTION
                           WHEN OTHERS THEN
                              bErroCnpjCpf := TRUE;
                        END;
                     END IF;
                     --
                     IF rdadostomador.nr_cgc_cpf IS NULL
                     OR bErroCnpjCpf
                     OR NVL( rdadostomador.NM_uf, 'XX' ) = 'EX' THEN
                        vCPFcliente := NULL;
                        vCNPJcliente := NULL;
                        vCodPais := '02496';
                        vCODMUNCliente := '9999999';
                     ELSE
                        IF rDadosTomador.tp_pessoa_rps = 'F' THEN
                           vCPFcliente := LPAD( SUBSTR( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( rDadosTomador.nr_cgc_cpf, '-', '' ), '.', '' ), '/', '' ), '\', '' ), ' ', '' ), 0, 11 ), 11, '0' );
                        ELSE
                           vCNPJcliente := LPAD( SUBSTR( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( rDadosTomador.nr_cgc_cpf, '-', '' ), '.', '' ), '/', '' ), '\', '' ), ' ', '' ), 0, 14 ), 14, '0' );
                        END IF;
                        vCodPais := '01058';
                     END IF;
                  ELSE -- Para estrangeiros
                     vCPFcliente := NULL;
                     vCNPJcliente := NULL;
                     vCodPais := '02496';
                     vCODMUNCliente := '9999999';
                  END IF;
                  --
                  vlinha := NULL;
                  --
                  vlinha := vlinha || '|0150';
                  vlinha := vlinha || '|' || rDadosTomador.cd_nota_fiscal;
                  vlinha := vlinha || '|' || SUBSTR( rDadosTomador.nm_cliente, 0, 100 );
                  vlinha := vlinha || '|' || vCodPais; --  Código do país do participante, conforme a tabela indicada no item 3.2.1. , mas como não existe esta tabela disponível no MV , então todos os estrangeiro serão informados com código dos EUA .
                  vlinha := vlinha || '|' || LPAD( vCNPJcliente, 14, '0' );
                  vlinha := vlinha || '|' || LPAD( vCPFcliente, 11, 0 );
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|' || vCODMUNCliente;
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  nconta9999 := NVL( nconta9999, 0 ) + 1;
                  fnc_insere_linha( '0150', vlinha );
                  ContaBlc0150 := ContaBlc0150 + 1;
                  ContaBlc0 := ContaBlc0 + 1;
                  vInseriuTomador := NVL( vCNPJcliente, vCPFcliente );
               END LOOP;
            END IF;
            IF NVL( nRecBruCumu, 0 ) > 0 THEN
               FOR rcNotaGruFat IN cNotaGruFat( dtInicio, dtfim )
               LOOP
                  --
                  vlinha := NULL;
                  --
                  vlinha := vlinha || '|0200';
                  vlinha := vlinha || '|' || rcNotaGruFat.cd_gru_fat;
                  vlinha := vlinha || '|' || rcNotaGruFat.ds_gru_fat;
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|09'; -- Tipo do item ¿ Atividades Industriais, Comerciais e Serviços: - 09 ¿ Serviços
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  nconta9999 := NVL( nconta9999, 0 ) + 1;
                  fnc_insere_linha( '0200', vlinha );
                  ContaBlc0200 := ContaBlc0200 + 1;
                  ContaBlc0 := ContaBlc0 + 1;
               END LOOP;
            END IF;
            -- REGISTRO 0500 - PLANO DE CONTAS
            FOR Rc0500 IN c0500( dCopetencia, vCNPJ )
            LOOP
               --
               vlinha := NULL;
               --
               vlinha := vlinha || '|0500';
               vlinha := vlinha || '|' || Rc0500.c02;
               vlinha := vlinha || '|' || Rc0500.c03;
               vlinha := vlinha || '|' || Rc0500.c04;
               vlinha := vlinha || '|' || Rc0500.c05;
               vlinha := vlinha || '|' || Rc0500.c06;
               vlinha := vlinha || '|' || Rc0500.c07;
               vlinha := vlinha || '|' || Rc0500.c08;
               vlinha := vlinha || '|' || Rc0500.c09;
               vlinha := vlinha || '|';
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               fnc_insere_linha( '0500', vlinha );
               ContaBlc0500 := ContaBlc0500 + 1;
               ContaBlc0 := ContaBlc0 + 1;
            END LOOP;
         END LOOP;
      END IF;
      -- PDA 572267 - Fim
      --
      -- REGISTRO 0150: TABELA DE CADASTRO DO PARTICIPANTE
      --
      IF dbamv.pkg_mv2000.le_cliente <> 1736 THEN -- PDA 572267 - Inicio
         nCdPais := NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'CD_NACION_BRASILEIRA' ), 1 ); -- PDA 537790
         IF NVL( nRecBruCumu, 0 ) > 0 THEN
            FOR rDadosTomador IN cDadosTomador( NULL )
            LOOP
               IF NVL( rDadosTomador.cd_pais, nCdPais ) = nCdPais THEN -- PDA 537790
                  nNrNotaIBGE := rDadosTomador.nr_id_nota_fiscal;
                  --
                  vCODMUNCliente := FNC_RETORNA_COD_IBGE( rDadosTomador.nm_uf, rDadosTomador.nm_cidade );
                  IF LENGTH( vCODMUNCliente ) <> 7 THEN
                     vCODMUNCliente := vCOD_MUN;
                  END IF;
                  IF vCOD_MUN = '5300108' THEN
                     vCODMUNCliente := vCOD_MUN;
                  END IF;
                  --
                  -- Trata o CPF\CNPJ .
                  vCPFcliente := NULL;
                  vCNPJcliente := NULL;
                  bErroCnpjCpf := FALSE;
                  IF rdadostomador.nr_cgc_cpf IS NOT NULL THEN
                     -- Verifica caracter inválido
                     DECLARE
                        nValidaCPFCNPJ NUMBER;
                     BEGIN
                        rDadosTomador.nr_cgc_cpf := REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( rDadosTomador.nr_cgc_cpf, '-', '' ), '.', '' ), '/', '' ), '\', '' ), ' ', '' );
                        nValidaCPFCNPJ := TO_NUMBER( rDadosTomador.nr_cgc_cpf );
                        -- RDBS
                        IF rDadosTomador.tp_pessoa_rps = 'F' THEN
                           IF NOT FNC_VALIDA_CNPJ_CPF( 'CPF', LPAD( nValidaCPFCNPJ, 15, '0' ) ) THEN
                              bErroCnpjCpf := TRUE;
                           END IF;
                        END IF;
                        IF rDadosTomador.tp_pessoa_rps = 'J' THEN
                           IF NOT FNC_VALIDA_CNPJ_CPF( 'CGC', LPAD( nValidaCPFCNPJ, 15, '0' ) ) THEN
                              bErroCnpjCpf := TRUE;
                           END IF;
                        END IF;
                     -- RDBS
                     EXCEPTION
                        WHEN OTHERS THEN
                           bErroCnpjCpf := TRUE;
                     END;
                  END IF;
                  --
                  IF rdadostomador.nr_cgc_cpf IS NULL
                  OR bErroCnpjCpf
                  OR NVL( rdadostomador.NM_uf, 'XX' ) = 'EX' THEN
                     vCPFcliente := NULL;
                     vCNPJcliente := NULL;
                     vCodPais := '02496';
                     vCODMUNCliente := '9999999';
                  ELSE
                     IF rDadosTomador.tp_pessoa_rps = 'F' THEN
                        vCPFcliente := LPAD( SUBSTR( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( rDadosTomador.nr_cgc_cpf, '-', '' ), '.', '' ), '/', '' ), '\', '' ), ' ', '' ), 0, 11 ), 11, '0' );
                     ELSE
                        vCNPJcliente := LPAD( SUBSTR( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( rDadosTomador.nr_cgc_cpf, '-', '' ), '.', '' ), '/', '' ), '\', '' ), ' ', '' ), 0, 14 ), 14, '0' );
                     END IF;
                     vCodPais := '01058';
                  END IF;
               ELSE -- Para estrangeiros
                  vCPFcliente := NULL;
                  vCNPJcliente := NULL;
                  vCodPais := '02496';
                  vCODMUNCliente := '9999999';
               END IF;
               --
               vlinha := NULL;
               --
               vlinha := vlinha || '|0150';
               vlinha := vlinha || '|' || rDadosTomador.cd_nota_fiscal;
               vlinha := vlinha || '|' || SUBSTR( rDadosTomador.nm_cliente, 0, 100 );
               vlinha := vlinha || '|' || vCodPais; --  Código do país do participante, conforme a tabela indicada no item 3.2.1. , mas como não existe esta tabela disponível no MV , então todos os estrangeiro serão informados com código dos EUA .
               vlinha := vlinha || '|' || LPAD( vCNPJcliente, 14, '0' );
               vlinha := vlinha || '|' || LPAD( vCPFcliente, 11, 0 );
               vlinha := vlinha || '|';
               vlinha := vlinha || '|' || vCODMUNCliente;
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               fnc_insere_linha( '0150', vlinha );
               ContaBlc0150 := ContaBlc0150 + 1;
               ContaBlc0 := ContaBlc0 + 1;
               vInseriuTomador := NVL( vCNPJcliente, vCPFcliente );
            END LOOP;
         END IF;
         --
         -- REGISTRO 0200: TABELA DE IDENTIFICAÇÃO DO ITEM (PRODUTOS E SERVIÇOS)
         --
         IF NVL( nRecBruCumu, 0 ) > 0 THEN
            FOR rcNotaGruFat IN cNotaGruFat( dtInicio, dtfim )
            LOOP
               --
               vlinha := NULL;
               --
               vlinha := vlinha || '|0200';
               vlinha := vlinha || '|' || rcNotaGruFat.cd_gru_fat;
               vlinha := vlinha || '|' || rcNotaGruFat.ds_gru_fat;
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|09'; -- Tipo do item ¿ Atividades Industriais, Comerciais e Serviços: - 09 ¿ Serviços
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               fnc_insere_linha( '0200', vlinha );
               ContaBlc0200 := ContaBlc0200 + 1;
               ContaBlc0 := ContaBlc0 + 1;
            END LOOP;
         END IF;
      END IF; -- IF dbamv.pkg_mv2000.le_cliente <> 1736 THEN    -- PDA 572267 - Fim
      -- REGISTRO 0500 - PLANO DE CONTAS
      FOR Rc0500 IN c0500( dCopetencia, vCNPJ )
      LOOP
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|0500';
         vlinha := vlinha || '|' || Rc0500.c02;
         vlinha := vlinha || '|' || Rc0500.c03;
         vlinha := vlinha || '|' || Rc0500.c04;
         vlinha := vlinha || '|' || Rc0500.c05;
         vlinha := vlinha || '|' || Rc0500.c06;
         vlinha := vlinha || '|' || Rc0500.c07;
         vlinha := vlinha || '|' || Rc0500.c08;
         vlinha := vlinha || '|' || Rc0500.c09;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '0500', vlinha );
         ContaBlc0500 := ContaBlc0500 + 1;
         ContaBlc0 := ContaBlc0 + 1;
      END LOOP;
      --
      -- REGISTRO 0990: ENCERRAMENTO DO BLOCO 0
      --
      vlinha := NULL;
      --
      ContaBlc0 := ContaBlc0 + 1;
      vlinha := vlinha || '|0990';
      vlinha := vlinha || '|' || ContaBlc0;
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '0990', vlinha );
      ContaBlc0 := ContaBlc0 + 1;
   END PRC2_DADOS_EMPRESA;
   /*******************************************/
   PROCEDURE PRC3_REGIME_COMP_DET_BLOCOA( dCopetencia DATE ) IS
      --
      --
      CURSOR cNota( dtinicio DATE
                   ,dtfim DATE
                   ,vcnpj VARCHAR2 ) IS
         SELECT n.cd_nota_fiscal cd_nota_fiscal
               ,n.nm_cliente
               ,n.nr_cgc_cpf
               ,'00' status
               ,n.cd_serie
               ,n.vl_total_nota vl_total_nota
               --,n.nr_id_nota_fiscal NUM_DOC
               ,Nvl(n.nr_nota_fiscal_nfe,n.nr_id_nota_fiscal) NUM_DOC
               ,n.cd_verificacao_nfe cd_verificacao_nfe
               ,n.dt_emissao DT_DOC
               ,n.VL_DESCONTO_NOTA VL_DESCONTO_NOTA
               ,n.VL_acrescimo_NOTA VL_acrescimo_NOTA
               ,n.nm_uf
               ,n.nm_cidade
               ,n.nr_id_nota_fiscal
               ,n.tp_pessoa_rps
           FROM dbamv.nota_fiscal n
          WHERE TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
            AND ( ( NVL( n.cd_status, 'E' ) = 'E' )
              OR ( n.cd_status = 'C'
              AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) <> TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND n.dt_cancelamento > dtCancIni ) )
            AND NVL( n.vl_total_nota, 0 ) > 0
            AND cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
            AND dbamv.pkg_mv2000.le_cliente <> 1736 -- PDA 572267
         UNION ALL
         SELECT NULL cd_nota_fiscal
               ,n.nm_cliente
               ,n.nr_cgc_cpf
               ,'02' status
               ,n.cd_serie
               ,NULL vl_total_nota
               --,n.nr_id_nota_fiscal NUM_DOC
               ,Nvl(n.nr_nota_fiscal_nfe,n.nr_id_nota_fiscal) NUM_DOC
               ,NULL cd_verificacao_nfe
               ,NULL DT_DOC
               ,NULL VL_DESCONTO_NOTA
               ,NULL VL_acrescimo_NOTA
               ,n.nm_uf
               ,n.nm_cidade
               ,n.nr_id_nota_fiscal
               ,n.tp_pessoa_rps
           FROM dbamv.nota_fiscal n
          WHERE TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
            AND ( ( n.cd_status = 'C'
               AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' ) )
              OR ( n.cd_status = 'C'
              AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) <> TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND n.dt_cancelamento <= dtCancIni ) )
            AND NVL( n.vl_total_nota, 0 ) > 0
            AND cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
            AND dbamv.pkg_mv2000.le_cliente <> 1736 -- PDA 572267
         UNION ALL
         SELECT NULL cd_nota_fiscal
               ,n.nm_cliente
               ,n.nr_cgc_cpf
               ,'02' status
               ,n.cd_serie
               ,NULL vl_total_nota
               --,n.nr_id_nota_fiscal NUM_DOC
               ,Nvl(n.nr_nota_fiscal_nfe,n.nr_id_nota_fiscal) NUM_DOC
               ,NULL cd_verificacao_nfe
               ,NULL DT_DOC
               ,NULL VL_DESCONTO_NOTA
               ,NULL VL_acrescimo_NOTA
               ,n.nm_uf
               ,n.nm_cidade
               ,n.nr_id_nota_fiscal
               ,n.tp_pessoa_rps
           FROM dbamv.nota_fiscal n
          WHERE n.dt_emissao < dCopetencia
            AND n.cd_status = 'C'
            AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
            AND NVL( n.vl_total_nota, 0 ) > 0
            AND cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
            AND dbamv.pkg_mv2000.le_cliente <> 1736
         UNION ALL
         SELECT n.cd_nota_fiscal cd_nota_fiscal
               ,n.nm_cliente
               ,n.nr_cgc_cpf
               ,'00' status
               ,n.cd_serie
               ,n.vl_total_nota vl_total_nota
               --,n.nr_id_nota_fiscal NUM_DOC
               ,Nvl(n.nr_nota_fiscal_nfe,n.nr_id_nota_fiscal) NUM_DOC
               ,n.cd_verificacao_nfe cd_verificacao_nfe
               ,n.dt_emissao DT_DOC
               ,n.VL_DESCONTO_NOTA VL_DESCONTO_NOTA
               ,n.VL_acrescimo_NOTA VL_acrescimo_NOTA
               ,n.nm_uf
               ,n.nm_cidade
               ,n.nr_id_nota_fiscal
               ,n.tp_pessoa_rps
           FROM dbamv.nota_fiscal n
          WHERE TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
            AND ( ( NVL( n.cd_status, 'E' ) = 'E' )
              OR ( n.cd_status = 'C'
              AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) <> TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND n.dt_cancelamento > dtCancIni ) )
            AND NVL( n.vl_total_nota, 0 ) > 0
            AND cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
            AND dbamv.pkg_mv2000.le_cliente = 1736
            AND n.cd_formulario_nf IN (SELECT cd_formulario_nf
                                         FROM dbamv.formulario_nf_cnpj
                                        WHERE ds_cnpj = vcnpj)
         UNION ALL
         SELECT NULL cd_nota_fiscal
               ,n.nm_cliente
               ,n.nr_cgc_cpf
               ,'02' status
               ,n.cd_serie
               ,NULL vl_total_nota
               --,n.nr_id_nota_fiscal NUM_DOC
               ,Nvl(n.nr_nota_fiscal_nfe,n.nr_id_nota_fiscal) NUM_DOC
               ,NULL cd_verificacao_nfe
               ,NULL DT_DOC
               ,NULL VL_DESCONTO_NOTA
               ,NULL VL_acrescimo_NOTA
               ,n.nm_uf
               ,n.nm_cidade
               ,n.nr_id_nota_fiscal
               ,n.tp_pessoa_rps
           FROM dbamv.nota_fiscal n
          WHERE TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
            AND ( ( n.cd_status = 'C'
               AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' ) )
              OR ( n.cd_status = 'C'
              AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) <> TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND n.dt_cancelamento <= dtCancIni ) )
            AND NVL( n.vl_total_nota, 0 ) > 0
            AND cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
            AND dbamv.pkg_mv2000.le_cliente = 1736
            AND n.cd_formulario_nf IN (SELECT cd_formulario_nf
                                         FROM dbamv.formulario_nf_cnpj
                                        WHERE ds_cnpj = vcnpj)
         UNION ALL
         SELECT NULL cd_nota_fiscal
               ,n.nm_cliente
               ,n.nr_cgc_cpf
               ,'02' status
               ,n.cd_serie
               ,NULL vl_total_nota
               --,n.nr_id_nota_fiscal NUM_DOC
               ,Nvl(n.nr_nota_fiscal_nfe,n.nr_id_nota_fiscal) NUM_DOC
               ,NULL cd_verificacao_nfe
               ,NULL DT_DOC
               ,NULL VL_DESCONTO_NOTA
               ,NULL VL_acrescimo_NOTA
               ,n.nm_uf
               ,n.nm_cidade
               ,n.nr_id_nota_fiscal
               ,n.tp_pessoa_rps
           FROM dbamv.nota_fiscal n
          WHERE n.dt_emissao < dCopetencia
            AND n.cd_status = 'C'
            AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
            AND NVL( n.vl_total_nota, 0 ) > 0
            AND cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
            AND dbamv.pkg_mv2000.le_cliente = 1736
            AND n.cd_formulario_nf IN (SELECT cd_formulario_nf
                                         FROM dbamv.formulario_nf_cnpj
                                        WHERE ds_cnpj = vcnpj)
         ORDER BY 7;
      CURSOR cVencimentoConrec( pcdnota NUMBER ) IS
         SELECT DECODE( NVL( tp_vencimento, 'X' ), 'P', '1', '0' ) tp_vencimento
           FROM dbamv.con_rec
          WHERE cd_nota_fiscal = pcdnota;
      CURSOR cNotaConRec( pCdConRec NUMBER ) IS
         SELECT cd_nota_fiscal
           FROM dbamv.con_rec
          WHERE cd_con_rec = pCdConRec;
      --
      rNota          cNota%ROWTYPE;
      rcBaseCalculo  cBaseCalculo%ROWTYPE;
   BEGIN
      BEGIN
         --- deletando as tabelas temporarias de registros SPED
         DELETE DBAMV.TEMP_SPED_CONTR_REG_A100;
         --WHERE DS_COMPETENCIA = TO_CHAR( dCopetencia, 'mm/yyyy' );
         COMMIT;
         DELETE DBAMV.TEMP_SPED_CONTR_REG_A170;
         --WHERE DS_COMPETENCIA = TO_CHAR( dCopetencia, 'mm/yyyy' );
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            Raise_Application_Error( -20999, 'Erro na deletar competência ! ' );
      END;
      --SPS-DADOS-----------------------------------
      --nRecBruCumu := 1;
      --SPS-DADOS-----------------------------------
      IF NVL( nRecBruCumu, 0 ) = 0
      OR dbamv.pkg_mv2000.le_cliente = 267 THEN
         -------------------------------------------------------
         -- REGISTRO A001: ABERTURA DO BLOCO A
         -------------------------------------------------------
         vlinha := NULL;
         --
         vlinha := vlinha || '|A001';
         vlinha := vlinha || '|1' /*IND_MOV [0 - Bloco com dados informados/1 - Bloco sem dados informados]*/
                                 ;
         vlinha := vlinha || '|';
         vlinha := vlinha || '|' || nRecBruCumu;
         vlinha := vlinha || '|' || dbamv.pkg_mv2000.le_cliente;
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'A001', vlinha );
         ContaBlcA := ContaBlcA + 1;
         --REGISTRO A990: ENCERRAMENTO DO BLOCO A
         ContaBlcATot := ContaBlcA + contaBlcA170 + 1;
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|A990';
         vlinha := vlinha || '|2';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'A990', vlinha );
      --
      ELSE
         --
         -- REGISTRO A001: ABERTURA DO BLOCO A
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|A001';
         vlinha := vlinha || '|0' /*IND_MOV [0 - Bloco com dados informados/1 - Bloco sem dados informados]*/
                                 ;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'A001', vlinha );
         ContaBlcA := ContaBlcA + 1;
         --
         -- REGISTRO A010: IDENTIFICAÇÃO DO ESTABELECIMENTO
         --
         -- PDA 572267 - Inicio
         FOR rcEmpresa0140 IN cEmpresa0140( dCopetencia )
         LOOP
            --
            IF pkg_mv2000.le_cliente = 1736 THEN -- PDA 572267
               vCNPJ := rcEmpresa0140.ds_cnpj;
            END IF;
            --
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|A010';
            vlinha := vlinha || '|' || vCNPJ;
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( 'A010', vlinha );
            ContaBlcA := ContaBlcA + 1;
            --
            -- REGISTRO A100: DOCUMENTO - NOTA FISCAL DE SERVIÇO
            --
            FOR rNota IN cNota( dtInicio, dtfim, rcEmpresa0140.ds_cnpj )
            LOOP -- PDA 572267  - passando cnpj
               --
               OPEN cVencimentoConrec( rNota.cd_nota_fiscal );
               FETCH cVencimentoConrec
               INTO vPGTO;
               CLOSE cVencimentoConrec;
               --
               vPGTO := NVL( vPGTO, '1' );
               --
               FOR rcTributo IN cTributo
               LOOP
                  IF rcTributo.TP_DETALHAMENTO = 'P' THEN
                     nPercPis := rcTributo.VL_PERCENTUAL;
                  ELSE
                     nPercCofins := rcTributo.VL_PERCENTUAL;
                  END IF;
               END LOOP;
               --
               nVlbasetrib := 0;
               nVlbaseNtrib := 0;
               nPerceDescNota := 0;
               nPerceAcrescNota := 0;
               nVlItfat := 0;
               --
               bprimeiroitemA100 := TRUE;
               FOR rcBaseCalculo IN cBaseCalculo( rNota.cd_nota_fiscal )
               LOOP
                  --
                  nVlItfat := 0;
                  IF rcBaseCalculo.cd_gru_fat <> 0 THEN
                     --
                     IF NVL( rNota.vl_desconto_nota, 0 ) > 0 THEN
                        nPerceDescNota := ( rNota.vl_desconto_nota * 100 ) / ( rNota.vl_total_nota + rNota.vl_desconto_nota );
                        nVlItfat := NVL( rcBaseCalculo.vl_itfat_nf, 0 ) - ( ( NVL( rcBaseCalculo.vl_itfat_nf, 0 ) * nPerceDescNota ) / 100 );
                     ELSIF NVL( rNota.vl_acrescimo_nota, 0 ) > 0
                       AND bprimeiroitemA100 THEN
                        /*nPerceAcrescNota := (rNota.vl_desconto_nota * 100 )/ (rNota.vl_total_nota - rNota.vl_acrescimo_nota) ;
                        nVlItfat := Nvl(rcBaseCalculo.vl_itfat_nf,0) - ( ( Nvl(rcBaseCalculo.vl_itfat_nf,0) * nPerceAcrescNota ) / 100)     ;*/
                        bprimeiroitemA100 := FALSE;
                        nVlItfat := TRUNC( NVL( rcBaseCalculo.vl_itfat_nf, 0 ) + NVL( rNota.vl_acrescimo_nota, 0 ), 2 );
                     ELSE
                        nVlItfat := NVL( rcBaseCalculo.vl_itfat_nf, 0 );
                     END IF;
                     --
                     nVlItfat := TRUNC( nVlItfat, 2 );
                     nVlbasetrib := NVL( nVlbasetrib, 0 ) + TRUNC( NVL( nVlItfat, 0 ), 2 );
                  ELSE
                     nVlbaseNtrib := NVL( nVlbaseNtrib, 0 ) + rcBaseCalculo.vl_itfat_nf;
                  END IF;
               END LOOP;
               --
               nVlbasetribM210T := NVL( nVlbasetrib, 0 ) + NVL( nVlbasetribm210T, 0 );
               --
               nVlPisA100 := 0;
               nVlCofinsA100 := 0;
               --
               nPerceDescNota := 0;
               nPerceAcrescNota := 0;
               nVlItfat := 0;
               --
               bprimeiroitemA100 := TRUE;
               FOR rcBaseCalculo IN cBaseCalculo( rNota.cd_nota_fiscal )
               LOOP
                  nVlItfat := 0;
                  --
                  IF rcBaseCalculo.cd_gru_fat <> 0 THEN
                     --
                     IF NVL( rNota.vl_desconto_nota, 0 ) > 0 THEN
                        nPerceDescNota := ( rNota.vl_desconto_nota * 100 ) / ( rNota.vl_total_nota + rNota.vl_desconto_nota );
                        nVlItfat := NVL( rcBaseCalculo.vl_itfat_nf, 0 ) - ( ( NVL( rcBaseCalculo.vl_itfat_nf, 0 ) * TRUNC( nPerceDescNota, 2 ) ) / 100 );
                     ELSIF NVL( rNota.vl_acrescimo_nota, 0 ) > 0
                       AND bprimeiroitemA100 THEN
                        /*  nPerceAcrescNota := (rNota.vl_desconto_nota * 100 )/ (rNota.vl_total_nota - rNota.vl_acrescimo_nota) ;
                        nVlItfat := Nvl(rcBaseCalculo.vl_itfat_nf,0) - ( ( Nvl(rcBaseCalculo.vl_itfat_nf,0) * nPerceAcrescNota ) / 100)     ;*/
                        bprimeiroitemA100 := FALSE;
                        nVlItfat := TRUNC( NVL( rcBaseCalculo.vl_itfat_nf, 0 ) + NVL( rNota.vl_acrescimo_nota, 0 ), 2 );
                     ELSE
                        nVlItfat := NVL( rcBaseCalculo.vl_itfat_nf, 0 );
                     END IF;
                     --
                     nVlPisA100 := nVlPisA100 + ROUND( ( ( nVlItfat * nPercPis ) / 100 ), 2 );
                     nVlCofinsA100 := nVlCofinsA100 + ROUND( ( ( nVlItfat * nPercCofins ) / 100 ), 2 );
                  --
                  END IF;
               END LOOP;
               --
               vlPIS := 0;
               VlCofins := 0;
               IF nVlbasetrib > 0 THEN
                  vlPIS := REPLACE( REPLACE( TO_CHAR( ROUND( NVL( nVlPisA100, 0 ), 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
                  VlCofins := REPLACE( REPLACE( TO_CHAR( ROUND( NVL( nVlCofinsA100, 0 ), 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               END IF;
               --
               nCdNota := rNota.cd_nota_fiscal;
               nNrDoc := rNota.NUM_DOC;
               vCodVerifNFSe := rNota.cd_verificacao_nfe;
               vDTDoc := TO_CHAR( rNota.DT_DOC, 'ddmmyyyy' );
               vVlNota := REPLACE( REPLACE( TO_CHAR( rNota.vl_total_nota, '9999999999999990.00' ), ' ' ), '.', ',' );
               vVlNotaDesc := REPLACE( REPLACE( TO_CHAR( rNota.VL_DESCONTO_NOTA, '9999999999999990.00' ), ' ' ), '.', ',' );
               vVlBasePis := REPLACE( REPLACE( TO_CHAR( NVL( nVlbasetrib, 0 ) + NVL( nVlbaseNtrib, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vVlBaseCofins := REPLACE( REPLACE( TO_CHAR( NVL( nVlbasetrib, 0 ) + NVL( nVlbaseNtrib, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               --
               IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'S' THEN
                  vVlBasePis := 0;
                  vVlBaseCofins := 0;
                  VlCofins := 0;
                  VlPIS := 0;
               END IF;
               -- Para documento fiscal de servio cancelado (cdigo da situao = 02 ou 03), preencher somente os campos cdigo da situao, indicador de operao, emitente, nmero do documento, srie e subsrie.
               IF rNota.status = '02' THEN
                  VlCofins := NULL;
                  VlPIS := NULL;
                  vPGTO := NULL;
                  nCdNota := NULL;
                  vCodVerifNFSe := NULL;
                  vDTDoc := NULL;
                  vVlNota := NULL;
                  vVlNotaDesc := NULL;
                  vVlBasePis := NULL;
                  vVlBaseCofins := NULL;
               END IF;
               --
               ---------------------------------------------------------------------------------------
               --Iserindo o reg_A100 --|A100  --A100:
               ---------------------------------------------------------------------------------------
               --dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC31_INSERE_REG_A100(
               PRC31_INSERE_REG_A100( param_ds_competencia =>   dCopetencia --00
                                     ,param_ds_ind_oper =>      '1' -- 02
                                     ,param_ds_ind_emit =>      '0' --03
                                     ,param_ds_cod_part =>      nCdNota --04
                                     ,param_ds_cod_sit =>       rNota.status --05
                                     ,param_ds_ser =>           rNota.cd_serie --06
                                     ,param_ds_sub =>           NULL --07
                                     ,param_ds_num_doc =>       nNrDoc --08
                                     ,param_ds_chv_nfse =>      vCodVerifNFSe --09
                                     ,param_ds_dt_doc =>        vDTDoc --10
                                     ,param_ds_dt_exe_serv =>   vDTDoc --11
                                     ,param_ds_vl_doc =>        vVlNota --12
                                     ,param_ds_ind_pgto =>      vPGTO --13
                                     ,param_ds_vl_desc =>       vVlNotaDesc --14
                                     ,param_ds_vl_bc_pis =>     vVlBasePis --15
                                     ,param_ds_vl_pis =>        VlPIS --16
                                     ,param_ds_vl_bc_cofins =>  vVlBaseCofins --17
                                     ,param_ds_vl_cofins =>     VlCofins --18
                                     ,param_ds_vl_pis_ret =>    NULL --19
                                     ,param_ds_vl_cofins_ret => NULL --20
                                     ,param_ds_vl_iss =>        NULL --21
                                     ,param_cd_multi_empresa => dbamv.pkg_mv2000.le_empresa );
               --
               --REGISTRO A170: COMPLEMENTO DO DOCUMENTO - ITENS DO DOCUMENTO
               --
               contaSeqA170 := 0;
               bprimeiroitemA170 := TRUE;
               nVlItfat := 0;
               FOR rcBaseCalculo IN cBaseCalculo( rNota.cd_nota_fiscal )
               LOOP
                  --
                  nVlItfat := 0;
                  nPerceDescNota := 0;
                  nPerceAcrescNota := 0;
                  nPercPisA170 := nPercPis;
                  nPercCofinsA170 := nPercCofins;
                  --
                  --
                  -- PDA  546252 - Inicio
                  IF rcBaseCalculo.cd_gru_fat = 0 THEN
                     nVlItfat := TRUNC( NVL( rcBaseCalculo.vl_itfat_nf, 0 ), 2 );
                  ELSE
                     IF NVL( rNota.vl_desconto_nota, 0 ) > 0 THEN
                        nPerceDescNota := ( rNota.vl_desconto_nota * 100 ) / ( rNota.vl_total_nota + TRUNC( rNota.vl_desconto_nota, 2 ) );
                        nVlItfat := TRUNC( NVL( rcBaseCalculo.vl_itfat_nf, 0 ) - ( ( NVL( rcBaseCalculo.vl_itfat_nf, 0 ) * nPerceDescNota ) / 100 ), 2 );
                     ELSIF NVL( rNota.vl_acrescimo_nota, 0 ) > 0
                       AND bprimeiroitemA170 THEN
                        bprimeiroitemA170 := FALSE;
                        nVlItfat := TRUNC( NVL( rcBaseCalculo.vl_itfat_nf, 0 ) + NVL( rNota.vl_acrescimo_nota, 0 ), 2 );
                     /* nPerceAcrescNota := (rNota.vl_desconto_nota * 100 )/ (rNota.vl_total_nota - rNota.vl_acrescimo_nota) ;
                      nVlItfat := Nvl(rcBaseCalculo.vl_itfat_nf,0) - ( ( Nvl(rcBaseCalculo.vl_itfat_nf,0) * nPerceAcrescNota ) / 100)     ;*/
                     ELSE
                        nVlItfat := TRUNC( NVL( rcBaseCalculo.vl_itfat_nf, 0 ), 2 );
                     END IF;
                  END IF;
                  --
                  IF NVL( rcBaseCalculo.vl_itfat_nf, 0 ) > 0 THEN
                     --
                     contaSeqA170 := contaSeqA170 + 1;
                     --
                     nVlItfat := TRUNC( NVL( nVlItfat, 0 ), 2 );
                     nVl_Rec_Brt := NVL( nVl_Rec_Brt, 0 ) + NVL( nVlItfat, 0 );
                     IF rcBaseCalculo.cd_gru_fat <> 0 THEN
                        VlPISitens := REPLACE( REPLACE( TO_CHAR( TRUNC( ( ( nVlItfat * nPercPisA170 ) / 100 ), 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
                        VlCofinsitens := REPLACE( REPLACE( TO_CHAR( TRUNC( ( ( nVlItfat * nPercCofinsA170 ) / 100 ), 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
                        vSPED_CST_PIS := SUBSTR( rDadosEmpSped.cd_CST_PIS, 0, 2 );
                        vSPED_CST_COFINS := SUBSTR( rDadosEmpSped.cd_CST_COFINS, 0, 2 );
                     ELSE
                        VlPISitens := '0';
                        VlCofinsitens := '0';
                        vSPED_CST_PIS := '06';
                        vSPED_CST_COFINS := '06';
                        nPercPISA170 := 0;
                        nPercCofinsA170 := 0;
                     END IF;
                     IF LPAD( vSPED_CST_PIS, 2, '0' ) IN ('04', '05', '06', '07', '08', '09')
                     OR LPAD( vSPED_CST_COFINS, 2, '0' ) IN ('04', '05', '06', '07', '08', '09') THEN
                        bEcrituraM410 := TRUE;
                     END IF;
                     --
                     IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'S' THEN
                        VlPISitens := 0;
                        nPercPisA170 := 0;
                        VlCofinsItens := 0;
                        nPercCofinsA170 := 0;
                        vlBasepisA170 := 0;
                        vlBaseCofinsA170 := 0;
                     ELSE
                        vlBasepisA170 := REPLACE( REPLACE( TO_CHAR( NVL( nVlItfat, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
                        vlBaseCofinsA170 := REPLACE( REPLACE( TO_CHAR( NVL( nVlItfat, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
                     END IF;
                     nVlItfat := TRUNC( NVL( nVlItfat, 0 ), 2 );
                     param_nVLRECM410 := NVL( param_nVLRECM410, 0 ) + NVL( nVlItfat, 0 );
                     ---------------------------------------------------------------------------------------
                     --Iserindo o reg_a170 --|A170  --A170:
                     ---------------------------------------------------------------------------------------
                     --dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC32_INSERE_REG_A170( param_dtcompet =>         dCopetencia
                     PRC32_INSERE_REG_A170( param_dtcompet =>         dCopetencia
                                           ,nnum_sequencia =>         1 /*NULL*/
                                           ,cd_multi_empresa =>       dbamv.pkg_mv2000.le_empresa
                                           ,param_DS_NUM_ITEM =>      contaSeqA170 --02
                                           ,param_DS_COD_ITEM =>      rcBaseCalculo.CD_GRU_FAT -- 03
                                           ,param_DS_DESCR_COMPL =>   NULL --04
                                           ,param_DS_VL_ITEM =>       REPLACE( REPLACE( TO_CHAR( NVL( nVlItfat, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' ) --05
                                           ,param_DS_VL_DESC =>       NULL --06
                                           ,param_DS_NAT_BC_CRED =>   NULL --07
                                           ,param_DS_IND_ORIG_CRED => NULL --08
                                           ,param_DS_CST_PIS =>       LPAD( vSPED_CST_PIS, 2, '0' ) --09
                                           ,param_DS_VL_BC_PIS =>     vlBasepisA170 -- 10
                                           ,param_DS_ALIQ_PIS =>      REPLACE( REPLACE( TO_CHAR( NVL( nPercPisA170, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' ) -- 11
                                           ,param_DS_VL_PIS =>        VlPISitens -- 12
                                           ,param_DS_CST_COFINS =>    LPAD( vSPED_CST_COFINS, 2, 0 ) -- 13 CST_COFINS
                                           ,param_DS_VL_BC_COFINS =>  vlBaseCofinsA170 -- 14
                                           ,param_DS_ALIQ_COFINS =>   REPLACE( REPLACE( TO_CHAR( NVL( nPercCofinsA170, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' ) -- 15
                                           ,param_DS_VL_COFINS =>     VlCofinsItens -- 16
                                           ,param_DS_COD_CTA =>       NULL --17
                                           ,param_DS_COD_CCUS =>      NULL ); --18
                     nVlItfat := 0;
                  END IF;
               END LOOP;
               ContaBlcA := ContaBlcA + 1;
               VlPISitens := NULL;
               VlCofinsitens := NULL;
            --
            END LOOP;
         END LOOP;
         --REGISTRO A990: ENCERRAMENTO DO BLOCO A
         ContaBlcATot := ContaBlcA + contaBlcA170 + contaBlcA111 + 1;
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|A990';
         vlinha := vlinha || '|' || ContaBlcATot;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'A990', vlinha );
      --
      END IF;
   END PRC3_REGIME_COMP_DET_BLOCOA;
   /*********************************************************/
   PROCEDURE PRC31_INSERE_REG_A100( param_ds_competencia VARCHAR2
                                   ,param_ds_ind_oper VARCHAR2
                                   ,param_ds_ind_emit VARCHAR2
                                   ,param_ds_cod_part VARCHAR2
                                   ,param_ds_cod_sit VARCHAR2
                                   ,param_ds_ser VARCHAR2
                                   ,param_ds_sub VARCHAR2
                                   ,param_ds_num_doc VARCHAR2
                                   ,param_ds_chv_nfse VARCHAR2
                                   ,param_ds_dt_doc VARCHAR2
                                   ,param_ds_dt_exe_serv VARCHAR2
                                   ,param_ds_vl_doc VARCHAR2
                                   ,param_ds_ind_pgto VARCHAR2
                                   ,param_ds_vl_desc VARCHAR2
                                   ,param_ds_vl_bc_pis VARCHAR2
                                   ,param_ds_vl_pis VARCHAR2
                                   ,param_ds_vl_bc_cofins VARCHAR2
                                   ,param_ds_vl_cofins VARCHAR2
                                   ,param_ds_vl_pis_ret VARCHAR2
                                   ,param_ds_vl_cofins_ret VARCHAR2
                                   ,param_ds_vl_iss VARCHAR2
                                   ,param_cd_multi_empresa NUMBER ) IS
   BEGIN
      /*.......*/
      INSERT INTO DBAMV.TEMP_SPED_CONTR_REG_A100( ds_competencia
                                                 ,ds_ind_oper
                                                 ,ds_ind_emit
                                                 ,ds_cod_part
                                                 ,ds_cod_sit
                                                 ,ds_ser
                                                 ,ds_sub
                                                 ,ds_num_doc
                                                 ,ds_chv_nfse
                                                 ,ds_dt_doc
                                                 ,ds_dt_exe_serv
                                                 ,ds_vl_doc
                                                 ,ds_ind_pgto
                                                 ,ds_vl_desc
                                                 ,ds_vl_bc_pis
                                                 ,ds_vl_pis
                                                 ,ds_vl_bc_cofins
                                                 ,ds_vl_cofins
                                                 ,ds_vl_pis_ret
                                                 ,ds_vl_cofins_ret
                                                 ,ds_vl_iss
                                                 ,cd_multi_empresa )
          VALUES ( param_ds_competencia
                  ,param_ds_ind_oper
                  ,param_ds_ind_emit
                  ,param_ds_cod_part
                  ,param_ds_cod_sit
                  ,param_ds_ser
                  ,param_ds_sub
                  ,param_ds_num_doc
                  ,param_ds_chv_nfse
                  ,param_ds_dt_doc
                  ,param_ds_dt_exe_serv
                  ,param_ds_vl_doc
                  ,param_ds_ind_pgto
                  ,param_ds_vl_desc
                  ,param_ds_vl_bc_pis
                  ,param_ds_vl_pis
                  ,param_ds_vl_bc_cofins
                  ,param_ds_vl_cofins
                  ,param_ds_vl_pis_ret
                  ,param_ds_vl_cofins_ret
                  ,param_ds_vl_iss
                  ,param_cd_multi_empresa );
      COMMIT;
      /***************************************************************************/
      vlinha := NULL;
      --
      vlinha := vlinha || '|A100'; --01
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_ind_oper ); --02
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_ind_emit ); --03
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_cod_part ); --04
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_cod_sit ); --05
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_ser ); --06
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_sub ); --07
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_num_doc ); --08
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_chv_nfse ); --09
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_dt_doc ); --10
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_dt_exe_serv ); -- 11
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_vl_doc ); --12
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_ind_pgto ); --13
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_vl_desc ); --14
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_vl_bc_pis ); --15
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_vl_pis ); --16
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_vl_bc_cofins ); --17
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_vl_cofins ); --18
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_vl_pis_ret ); --19
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_vl_cofins_ret ); --20
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_ds_vl_iss ); --21
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( 'A100', vlinha );
      contaBlcA100 := contaBlcA100 + 1;
      vregistroA111 := dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SPED_PC_REGISTRO_A111' );
      vregistro1010 := dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SPED_PC_REGISTRO_1010' );
      vregistro1020 := dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SPED_PC_REGISTRO_1020' );
      IF NVL( nVlbaseNtrib, 0 ) > 0
     AND vregistroA111 IS NOT NULL THEN
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'A111', vregistroA111 );
         contaBlcA111 := contaBlcA111 + 1;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         Raise_Application_Error( -20017, 'Problema ao inserir o registro A100, erro :' || 'Empresa:[' || dbamv.pkg_mv2000.le_empresa || ']' || CHR( 10 ) || 'param_dtcompet:[' || param_ds_competencia || ']' || CHR( 10 ) || ' ds_cod_part:[' ||
                                          param_ds_cod_part || ']' || CHR( 10 ) || ' ds_ser:[' || param_ds_ser || ']' || CHR( 10 ) || ' ds_sub:[' || param_ds_sub || ']' || CHR( 10 ) || ' ds_num_doc:[' || ']' || CHR( 10 ) || param_ds_num_doc || ']' ||
                                          CHR                                                                                                                                                                                                              (
                                          10 ) || 'Erro: ' || TO_CHAR( SQLCODE ) || '/sqlerrm: ' || SQLERRM );
   END PRC31_INSERE_REG_A100;
   /***************************************************************/
   PROCEDURE PRC32_INSERE_REG_A170( param_dtcompet DATE
                                   ,nnum_sequencia NUMBER
                                   ,cd_multi_empresa NUMBER
                                   ,param_DS_NUM_ITEM VARCHAR2
                                   ,param_DS_COD_ITEM VARCHAR2
                                   ,param_DS_DESCR_COMPL VARCHAR2
                                   ,param_DS_VL_ITEM VARCHAR2
                                   ,param_DS_VL_DESC VARCHAR2
                                   ,param_DS_NAT_BC_CRED VARCHAR2
                                   ,param_DS_IND_ORIG_CRED VARCHAR2
                                   ,param_DS_CST_PIS VARCHAR2
                                   ,param_DS_VL_BC_PIS VARCHAR2
                                   ,param_DS_ALIQ_PIS VARCHAR2
                                   ,param_DS_VL_PIS VARCHAR2
                                   ,param_DS_CST_COFINS VARCHAR2
                                   ,param_DS_VL_BC_COFINS VARCHAR2
                                   ,param_DS_ALIQ_COFINS VARCHAR2
                                   ,param_DS_VL_COFINS VARCHAR2
                                   ,param_DS_COD_CTA VARCHAR2
                                   ,param_DS_COD_CCUS VARCHAR2 ) IS
   BEGIN
      INSERT INTO DBAMV.TEMP_SPED_CONTR_REG_A170( DS_NUM_ITEM
                                                 ,DS_COD_ITEM
                                                 ,DS_DESCR_COMPL
                                                 ,DS_VL_ITEM
                                                 ,DS_VL_DESC
                                                 ,DS_NAT_BC_CRED
                                                 ,DS_IND_ORIG_CRED
                                                 ,DS_CST_PIS
                                                 ,DS_VL_BC_PIS
                                                 ,DS_ALIQ_PIS
                                                 ,DS_VL_PIS
                                                 ,DS_CST_COFINS
                                                 ,DS_VL_BC_COFINS
                                                 ,DS_ALIQ_COFINS
                                                 ,DS_VL_COFINS
                                                 ,DS_COD_CTA
                                                 ,DS_COD_CCUS
                                                 ,CD_MULTI_EMPRESA
                                                 ,DS_COMPETENCIA )
          VALUES ( param_DS_NUM_ITEM
                  ,param_DS_COD_ITEM
                  ,param_DS_DESCR_COMPL
                  ,param_DS_VL_ITEM
                  ,param_DS_VL_DESC
                  ,param_DS_NAT_BC_CRED
                  ,param_DS_IND_ORIG_CRED
                  ,param_DS_CST_PIS
                  ,param_DS_VL_BC_PIS
                  ,param_DS_ALIQ_PIS
                  ,param_DS_VL_PIS
                  ,param_DS_CST_COFINS
                  ,param_DS_VL_BC_COFINS
                  ,param_DS_ALIQ_COFINS
                  ,param_DS_VL_COFINS
                  ,param_DS_COD_CTA
                  ,param_DS_COD_CCUS
                  ,dbamv.pkg_mv2000.le_empresa
                  ,param_dtcompet );
      COMMIT;
      /***************************************************************************/
      --cHist_Grava := rtrim(ltrim( Replace( cHist_Grava, chr(10), ' ' )));
      vlinha := NULL;
      --
      vlinha := vlinha || '|A170'; -- 01
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_NUM_ITEM ); --02
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_COD_ITEM ); --03
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_DESCR_COMPL ); -- 04
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_VL_ITEM ); -- 05
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_VL_DESC ); -- 06
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_NAT_BC_CRED ); -- 07
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_IND_ORIG_CRED ); -- 08
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_CST_PIS ); -- 09 CST_PIS
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_VL_BC_PIS ); -- 10
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_ALIQ_PIS ); -- 11
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_VL_PIS ); -- 12
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_CST_COFINS ); -- 13
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_VL_BC_COFINS ); -- 14
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_ALIQ_COFINS ); -- 15
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_VL_COFINS ); -- 16
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_COD_CTA ); -- 17
      vlinha := vlinha || '|' || FNC_LIMPA_CARAC_ESP( param_DS_COD_CCUS ); -- 18
      vlinha := vlinha || '|'; -- 19
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( 'A170', vlinha );
      contaBlcA170 := contaBlcA170 + 1;
      contaBlctotA170 := contaBlctotA170 + 1;
      nVlItfat := 0;
   EXCEPTION
      WHEN OTHERS THEN
         Raise_Application_Error( -20104, 'Problema ao inserir o registro A170, erro :' || CHR( 10 ) || 'Empresa:[' || dbamv.pkg_mv2000.le_empresa || ']' || CHR( 10 ) || 'param_dtcompet:[' || param_DTCOMPET || ']' || CHR( 10 ) || ' DS_NUM_ITEM:[' ||
                                          param_DS_NUM_ITEM || ']' || CHR( 10 ) || ' DS_COD_ITEM:[' || param_DS_COD_ITEM || ']' || CHR( 10 ) || ' sqlcode:' || SQLCODE || ' msg: ' || SQLERRM );
   END PRC32_INSERE_REG_A170;
   /************************************************************************/
   PROCEDURE PRC4_MERC_ICMS_IPI_BLOCOC( dCopetencia DATE ) IS
   BEGIN
      /***************************************************** BLOCO C:  DOCUMENTOS FISCAIS I - MERCADORIAS (ICMS/IPI) *****************************************************/
      -- Este bloco não deverá conter informações,pois os hospitais não recolhem ICMS
      -- REGISTRO C001: ABERTURA DO BLOCO C
      --C  Documentos Fiscais I ¿ Mercadorias (ICMS/IPI)
      --dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC4_REG_ICMS_IPI_BLOCOC( dCopetencia );
      vlinha := NULL;
      --
      vlinha := vlinha || '|C001';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( 'C001', vlinha );
      -- ENCERRAMENTO DO BLOCO C
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|C990';
      vlinha := vlinha || '|2';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( 'C990', vlinha );
   END PRC4_MERC_ICMS_IPI_BLOCOC;
   /***************************************************************/
   PROCEDURE PRC5_SERV_ICMS_IPI_BLOCOD( dCopetencia DATE ) IS
   BEGIN
      /*****************************************************  BLOCO D: DOCUMENTOS FISCAIS II - SERVIÇOS (ICMS) *****************************************************/
      -- Este bloco não deverá conter informações
      -- REGISTRO D001: ABERTURA DO BLOCO D
      --
      --dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC5_SERV_ICMS_IPI_BLOCOD( dCopetencia );
      vlinha := NULL;
      --
      vlinha := vlinha || '|D001';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( 'D001', vlinha );
      -- ENCERRAMENTO DO BLOCO D
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|D990';
      vlinha := vlinha || '|2';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( 'D990', vlinha );
   END PRC5_SERV_ICMS_IPI_BLOCOD;
   /*********************************************************************************************/
   PROCEDURE PRC6_DOC_OPE_BLOCOF( dCopetencia DATE
                                 ,consolidadora NUMBER ) IS
      CURSOR cF010( consolidadora NUMBER ) IS
           SELECT me.cd_multi_empresa
                 ,me.cd_cgc
             FROM dbamv.multi_empresas me
            WHERE me.CD_MULTI_EMPRESA = consolidadora
               OR me.CD_MULTI_EMPRESA_CONSOL = consolidadora
              AND me.sn_ativo = 'S'
              AND EXISTS (SELECT n.cd_nota_fiscal
                            FROM dbamv.nota_fiscal n
                                ,dbamv.con_rec cr
                                ,Dbamv.Itcon_Rec ir
                                ,dbamv.reccon_rec rcr
                           WHERE TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) >= TO_CHAR( dCopetencia, 'MM/YYYY' )
                             AND NVL( n.vl_total_nota, 0 ) > 0
                             AND n.cd_multi_empresa = me.cd_multi_empresa
                             AND n.cd_nota_fiscal = cr.cd_nota_fiscal
                             AND cr.cd_con_rec = ir.cd_con_rec
                             AND ir.cd_itcon_rec = rcr.cd_itcon_rec)
         ORDER BY me.CD_MULTI_EMPRESA_CONSOL DESC
                 ,me.CD_MULTI_EMPRESA;
      rF010          cF010%ROWTYPE;
   BEGIN
      /************************************  BLOCO F: DEMAIS DOCUMENTOS E OPERAÇÕES **********************/
      -- Este bloco não deverá conter informações
      -- REGISTRO D001: ABERTURA DO BLOCO D
      --dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC6_DOC_OPE_BLOCOF(dCopetencia );
      --
      IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'S'
      OR NVL( nRecBruCumu, 0 ) = 0 THEN
         -- REGISTRO F001: ABERTURA DO BLOCO F
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|F001';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'F001', vlinha );
         -- ENCERRAMENTO DO BLOCO F
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|F990';
         vlinha := vlinha || '|2';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'F990', vlinha );
      --
      ELSE -- IF nvl(dbamv.pkg_mv2000.le_configuracao('FFCV','SN_IMUNE_IRPJ'),'N') = 'S' THEN
         -- REGISTRO F001: ABERTURA DO BLOCO F
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|F001';
         vlinha := vlinha || '|0';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'F001', vlinha );
         FOR rF010 IN cF010( consolidadora )
         LOOP
            dbamv.pkg_mv2000.atribui_empresa( rF010.cd_multi_empresa );
            dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC61_REGIME_COMP_DET_BLOCOF( dCopetencia, rF010.cd_cgc );
         END LOOP;
         dbamv.pkg_mv2000.atribui_empresa( consolidadora );
         -- ENCERRAMENTO DO BLOCO F
         --
         vlinha := NULL;
         --
         nContaConfigF990 := nContaConfigF100 + nContaf600 + nContaf700 + contaBlcF010 + nContaConfigF500 + nContaConfigF525 + nContaConfigF509 + 2;
         vlinha := vlinha || '|F990';
         vlinha := vlinha || '|' || nContaConfigF990;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'F990', vlinha );
      --
      END IF;
   -- dbamv.pkg_mv2000.le_configuracao('FFCV','N')
   END PRC6_DOC_OPE_BLOCOF;
   /*************************************************************/
   PROCEDURE PRC61_REGIME_COMP_DET_BLOCOF( dCopetencia DATE
                                          ,vCGC NUMBER ) IS
      CURSOR cEscrituraBlccoF IS
         SELECT CD_VISAO_CRED_0
               ,CD_VISAO_CONTRIB_1
               ,CD_VISAO_CONTRIB_2
           FROM dbamv.empresa_sped_pis_cofins
          WHERE cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;
      rcEscrituraBlccoF cEscrituraBlccoF%ROWTYPE;
   BEGIN
      bNaoEscrituraBlccoF := FALSE;
      --
      OPEN cEscrituraBlccoF;
      FETCH cEscrituraBlccoF
      INTO rcEscrituraBlccoF;
      CLOSE cEscrituraBlccoF;
      --
      -- REGISTRO F010: IDENTIFICAÇÃO DO ESTABELECIMENTO
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|F010';
      vlinha := vlinha || '|' || LPAD( vCGC, 14, '0' );
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( 'F010', vlinha );
      contaBlcF010 := contaBlcF010 + 1;
      ---
      dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC62_REG_COMP_DET_BLOCOF_IND9( dCopetencia );
   ---
   END PRC61_REGIME_COMP_DET_BLOCOF;
   /***********************************/
   /***********************************/
   PROCEDURE PRC62_REG_COMP_DET_BLOCOF_IND9( dCopetencia DATE ) IS
      CURSOR cVisoes IS
         SELECT '0' ind_oper
               ,ivc.cd_reduzido
               ,vc.cd_visao_contabil
               ,SUBSTR( ivc.cd_CST_PIS, 0, 2 ) cd_CST_PIS
               ,SUBSTR( ivc.cd_CST_COFINS, 0, 2 ) cd_CST_COFINS
               ,SUBSTR( ivc.cd_cod_cred, 0, 3 ) cd_cod_cred
           FROM dbamv.empresa_sped_pis_cofins pc
               ,dbamv.visao_contabil vc
               ,dbamv.it_visao_contabil ivc
          WHERE pc.cd_visao_cred_0 = vc.cd_visao_contabil
            AND ivc.cd_visao_contabil = vc.cd_visao_contabil
            AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
         UNION ALL
         SELECT '1' ind_oper
               ,ivc.cd_reduzido
               ,vc.cd_visao_contabil
               ,SUBSTR( ivc.cd_CST_PIS, 0, 2 ) cd_CST_PIS
               ,SUBSTR( ivc.cd_CST_COFINS, 0, 2 ) cd_CST_COFINS
               ,SUBSTR( ivc.cd_cod_cred, 0, 3 ) cd_cod_cred
           FROM dbamv.empresa_sped_pis_cofins pc
               ,dbamv.visao_contabil vc
               ,dbamv.it_visao_contabil ivc
          WHERE pc.cd_visao_contrib_1 = vc.cd_visao_contabil
            AND ivc.cd_visao_contabil = vc.cd_visao_contabil
            AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
         UNION ALL
         SELECT '1' ind_oper
               ,ivc.cd_reduzido
               ,vc.cd_visao_contabil
               ,SUBSTR( ivc.cd_CST_PIS, 0, 2 ) cd_CST_PIS
               ,SUBSTR( ivc.cd_CST_COFINS, 0, 2 ) cd_CST_COFINS
               ,SUBSTR( ivc.cd_cod_cred, 0, 3 ) cd_cod_cred
           FROM dbamv.visao_contabil vc
               ,dbamv.it_visao_contabil ivc
          WHERE vc.cd_visao_contabil = 9
            AND ivc.cd_visao_contabil = vc.cd_visao_contabil
            AND vc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
            AND dbamv.pkg_mv2000.le_cliente = 267
         UNION ALL
         SELECT '2' ind_oper
               ,ivc.cd_reduzido
               ,vc.cd_visao_contabil
               ,SUBSTR( ivc.cd_CST_PIS, 0, 2 ) cd_CST_PIS
               ,SUBSTR( ivc.cd_CST_COFINS, 0, 2 ) cd_CST_COFINS
               ,SUBSTR( ivc.cd_cod_cred, 0, 3 ) cd_cod_cred
           FROM dbamv.empresa_sped_pis_cofins pc
               ,dbamv.visao_contabil vc
               ,dbamv.it_visao_contabil ivc
          WHERE pc.cd_visao_contrib_2 = vc.cd_visao_contabil
            AND ivc.cd_visao_contabil = vc.cd_visao_contabil
            AND pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;
      CURSOR cVlOper( pCdreduzido dbamv.saldo_mensal.cd_reduzido%TYPE ) IS
         SELECT ABS( sm.vl_credito - sm.vl_debito ) vl_saldo_mes
           FROM dbamv.saldo_mensal sm
               ,dbamv.plano_contas pc
          WHERE TO_CHAR( dt_saldo_mes, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
            AND pc.cd_reduzido = sm.cd_reduzido
            AND sm.cd_reduzido = pCdreduzido
            AND NOT EXISTS (SELECT dt_saldo_mes
                              FROM dbamv.saldo_mes_sem_apuracao sm
                                  ,dbamv.plano_contas pc
                             WHERE TO_CHAR( sm.dt_saldo_mes, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                               AND pc.cd_reduzido = sm.cd_reduzido
                               AND sm.cd_reduzido = pCdreduzido)
         UNION
         SELECT ABS( sm.vl_credito - sm.vl_debito ) vl_saldo_mes
           FROM dbamv.saldo_mes_sem_apuracao sm
               ,dbamv.plano_contas pc
          WHERE TO_CHAR( dt_saldo_mes, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
            AND pc.cd_reduzido = sm.cd_reduzido
            AND sm.cd_reduzido = pCdreduzido;
      CURSOR cValoresCredito( pcdreduzido NUMBER ) IS
           SELECT SUM( vl_lancado ) vl_operacao
                 ,cd_fornecedor
             FROM ( SELECT lct.vl_lancado
                          ,cp.cd_fornecedor
                      FROM dbamv.lcto_contabil lct
                          ,dbamv.con_pag cp
                     WHERE lct.cd_reduzido_debito = pcdreduzido
                       AND TO_CHAR( dt_lcto, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND cd_origem = cp.cd_con_pag
                       AND ( lct.cd_reduzido_debito = cp.cd_reduzido
                         OR lct.cd_reduzido_credito = cp.cd_reduzido )
                       AND lct.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                    UNION ALL
                    SELECT lct.vl_lancado
                          ,cr.cd_fornecedor
                      FROM dbamv.lcto_contabil lct
                          ,dbamv.con_rec cr
                     WHERE lct.cd_reduzido_debito = pcdreduzido
                       AND TO_CHAR( dt_lcto, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND cd_origem = cr.cd_con_rec
                       AND ( lct.cd_reduzido_debito = cr.cd_reduzido
                         OR lct.cd_reduzido_credito = cr.cd_reduzido )
                       AND lct.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa )
         GROUP BY cd_fornecedor;
/*      CURSOR cNotasRetem IS
           SELECT SUM( vl_recebido ) vl_recebido
                 ,SUM( vl_tributo ) vl_tributo
                 ,SUM( vl_tributo_pis ) vl_tributo_pis
                 ,SUM(vl_tributo_Cofins ) vl_tributo_Cofins
                 ,nr_cgc_cpf
                 ,dt_recebimento
                 ,cd_ind_nat_ret
             FROM ( SELECT DISTINCT LPAD( f.nr_cgc_cpf, 14, '0' ) nr_cgc_cpf
                                   ,rcr.dt_recebimento
                                   ,( rcr.vl_recebido + NVL( RCR.VL_IMPOSTO_RETIDO, 0 ) ) vl_recebido
                                   ,d.tp_detalhamento
                                   ,SUM( DECODE( tp_detalhamento, 'P', vl_tributo, 0 ) ) vl_tributo_pis
                                   ,SUM( DECODE( tp_detalhamento, 'C', vl_tributo, 0 ) ) vl_tributo_Cofins
                                   ,trc.vl_tributo
                                   ,f.cd_ind_nat_ret
                      FROM dbamv.fornecedor f
                          ,dbamv.forn_detalhamento fd
                          ,dbamv.tip_detalhe d
                          ,dbamv.con_rec cr
                          ,dbamv.itcon_rec icr
                          ,dbamv.reccon_rec rcr
                          ,dbamv.tip_det_reccon_rec trc
                     WHERE fd.cd_fornecedor = f.cd_fornecedor
                       AND d.cd_detalhamento = fd.cd_detalhamento
                       AND d.tp_detalhamento IN ('C', 'P')
                       AND NVL( fd.sn_retem, 'N' ) = 'S'
                       AND cr.cd_fornecedor = f.cd_fornecedor
                       AND trc.cd_reccon_rec = rcr.cd_reccon_rec
                       AND d.cd_detalhamento = trc.cd_detalhamento
                       AND icr.tp_quitacao <> 'L'
                       AND icr.cd_con_rec = cr.cd_con_rec
                       AND icr.cd_itcon_rec = rcr.cd_itcon_rec
                       AND NVL( rcr.vl_recebido, 0 ) > 0
                       AND TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND cr.cd_previsao IS NULL
                       AND rcr.dt_estorno IS NULL
                       AND cr.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                       AND ICR.CD_CON_REC_AGRUP IS NULL
                       AND dbamv.pkg_mv2000.le_cliente NOT IN (267)
                       GROUP BY LPAD( f.nr_cgc_cpf, 14, '0' )
                       ,rcr.dt_recebimento
                       ,( rcr.vl_recebido + NVL( RCR.VL_IMPOSTO_RETIDO, 0 ) )
                       ,d.tp_detalhamento
                       ,trc.vl_tributo
                       ,f.cd_ind_nat_ret
                       )
         GROUP BY nr_cgc_cpf
                 ,dt_recebimento
                 ,cd_ind_nat_ret
         UNION ALL
           SELECT SUM( rcr.vl_recebido + NVL( RCR.VL_IMPOSTO_RETIDO, 0 ) ) vl_recebido
                 ,SUM( lcto.VL_LANCADO ) vl_tributo
                 ,SUM( DECODE( lcto.CD_REDUZIDO_DEBITO, 285009, lcto.VL_LANCADO, 0 ) ) vl_tributo_pis
                 ,SUM( DECODE( lcto.CD_REDUZIDO_DEBITO, 285007, lcto.VL_LANCADO, 0 ) ) vl_tributo_Cofins
                 ,LPAD( f.nr_cgc_cpf, 14, '0' ) nr_cgc_cpf
                 ,rcr.dt_recebimento
                 ,f.cd_ind_nat_ret
             FROM DBAMV.LCTO_CONTABIL lcto
                 ,dbamv.reccon_rec rcr
                 ,dbamv.itcon_rec icr
                 ,dbamv.con_rec cr
                 ,dbamv.fornecedor f
            WHERE lcto.CD_REDUZIDO_DEBITO IN (285007, 285009)
              AND TO_CHAR( lcto.dt_lcto, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND cr.cd_con_rec = icr.cd_con_rec
              AND icr.cd_itcon_rec = rcr.cd_itcon_rec
              AND f.cd_fornecedor = cr.cd_fornecedor
              AND rcr.cd_reccon_rec = lcto.cd_origem
              AND dbamv.pkg_mv2000.le_cliente IN (267)
         GROUP BY f.nr_cgc_cpf
                 ,rcr.dt_recebimento
                 ,f.cd_ind_nat_ret;
*/
 CURSOR cNotasRetem IS
           SELECT vl_recebido
                 ,SUM( vl_tributo ) vl_tributo
                 ,SUM( DECODE( tp_detalhamento, 'P', vl_tributo, 0 ) ) vl_tributo_pis
                 ,SUM( DECODE( tp_detalhamento, 'C', vl_tributo, 0 ) ) vl_tributo_Cofins
                 ,nr_cgc_cpf
                 ,dt_recebimento
                 ,cd_ind_nat_ret
             FROM ( SELECT DISTINCT LPAD( f.nr_cgc_cpf, 14, '0' ) nr_cgc_cpf
                                   ,rcr.dt_recebimento
                                   ,f.cd_ind_nat_ret
                                   ,d.tp_detalhamento
                                   ,Sum(vl_tributo) vl_tributo
                                   ,sum( rcr.vl_recebido + NVL( RCR.VL_IMPOSTO_RETIDO, 0 ) ) vl_recebido
                      FROM dbamv.fornecedor f
                          ,dbamv.forn_detalhamento fd
                          ,dbamv.tip_detalhe d
                          ,dbamv.con_rec cr
                          ,dbamv.itcon_rec icr
                          ,dbamv.reccon_rec rcr
                          ,dbamv.tip_det_reccon_rec trc
                     WHERE fd.cd_fornecedor = f.cd_fornecedor
                       AND d.cd_detalhamento = fd.cd_detalhamento
                       AND d.tp_detalhamento = 'C'
                       AND NVL( fd.sn_retem, 'N' ) = 'S'
                       AND cr.cd_fornecedor = f.cd_fornecedor
                       AND trc.cd_reccon_rec = rcr.cd_reccon_rec
                       AND d.cd_detalhamento = trc.cd_detalhamento
                       AND icr.tp_quitacao <> 'L'
                       AND icr.cd_con_rec = cr.cd_con_rec
                       AND icr.cd_itcon_rec = rcr.cd_itcon_rec
                       AND NVL( rcr.vl_recebido, 0 ) > 0
                       AND TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND cr.cd_previsao IS NULL
                       AND rcr.dt_estorno IS NULL
                       AND cr.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                       AND ICR.CD_CON_REC_AGRUP IS NULL
                       AND dbamv.pkg_mv2000.le_cliente NOT IN (267)
                       GROUP BY LPAD( f.nr_cgc_cpf, 14, '0' )
                                   ,rcr.dt_recebimento
                                   ,f.cd_ind_nat_ret
                                   ,d.tp_detalhamento
                       UNION
                       SELECT DISTINCT LPAD( f.nr_cgc_cpf, 14, '0' ) nr_cgc_cpf
                                   ,rcr.dt_recebimento
                                   ,f.cd_ind_nat_ret
                                   ,d.tp_detalhamento
                                   ,Sum(vl_tributo) vl_tributo
                                   ,sum( rcr.vl_recebido + NVL( RCR.VL_IMPOSTO_RETIDO, 0 ) ) vl_recebido
                      FROM dbamv.fornecedor f
                          ,dbamv.forn_detalhamento fd
                          ,dbamv.tip_detalhe d
                          ,dbamv.con_rec cr
                          ,dbamv.itcon_rec icr
                          ,dbamv.reccon_rec rcr
                          ,dbamv.tip_det_reccon_rec trc
                     WHERE fd.cd_fornecedor = f.cd_fornecedor
                       AND d.cd_detalhamento = fd.cd_detalhamento
                       AND d.tp_detalhamento = 'P'
                       AND NVL( fd.sn_retem, 'N' ) = 'S'
                       AND cr.cd_fornecedor = f.cd_fornecedor
                       AND trc.cd_reccon_rec = rcr.cd_reccon_rec
                       AND d.cd_detalhamento = trc.cd_detalhamento
                       AND icr.tp_quitacao <> 'L'
                       AND icr.cd_con_rec = cr.cd_con_rec
                       AND icr.cd_itcon_rec = rcr.cd_itcon_rec
                       AND NVL( rcr.vl_recebido, 0 ) > 0
                       AND TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND cr.cd_previsao IS NULL
                       AND rcr.dt_estorno IS NULL
                       AND cr.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                       AND ICR.CD_CON_REC_AGRUP IS NULL
                       AND dbamv.pkg_mv2000.le_cliente NOT IN (267)
                       GROUP BY LPAD( f.nr_cgc_cpf, 14, '0' )
                                     ,rcr.dt_recebimento
                                     ,f.cd_ind_nat_ret
                                     ,d.tp_detalhamento
                       )
         GROUP BY nr_cgc_cpf
                 ,dt_recebimento
                 ,cd_ind_nat_ret
                 ,vl_recebido
         UNION ALL
           SELECT SUM( rcr.vl_recebido + NVL( RCR.VL_IMPOSTO_RETIDO, 0 ) ) vl_recebido
                 ,SUM( lcto.VL_LANCADO ) vl_tributo
                 ,SUM( DECODE( lcto.CD_REDUZIDO_DEBITO, 285009, lcto.VL_LANCADO, 0 ) ) vl_tributo_pis
                 ,SUM( DECODE( lcto.CD_REDUZIDO_DEBITO, 285007, lcto.VL_LANCADO, 0 ) ) vl_tributo_Cofins
                 ,LPAD( f.nr_cgc_cpf, 14, '0' ) nr_cgc_cpf
                 ,rcr.dt_recebimento
                 ,f.cd_ind_nat_ret
             FROM DBAMV.LCTO_CONTABIL lcto
                 ,dbamv.reccon_rec rcr
                 ,dbamv.itcon_rec icr
                 ,dbamv.con_rec cr
                 ,dbamv.fornecedor f
            WHERE lcto.CD_REDUZIDO_DEBITO IN (285007, 285009)
              AND TO_CHAR( lcto.dt_lcto, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND cr.cd_con_rec = icr.cd_con_rec
              AND icr.cd_itcon_rec = rcr.cd_itcon_rec
              AND f.cd_fornecedor = cr.cd_fornecedor
              AND rcr.cd_reccon_rec = lcto.cd_origem
              AND dbamv.pkg_mv2000.le_cliente IN (267)
         GROUP BY f.nr_cgc_cpf
                 ,rcr.dt_recebimento
                 ,f.cd_ind_nat_ret;
      CURSOR cGloasRegF700 IS
           SELECT SUM( vl_rateio ) VL_BC_OPER
                 ,nr_cgc_cpf
             FROM ( SELECT DISTINCT f.*
                                   ,DECODE( k.tp_fornecedor, 'F', LPAD( k.nr_cgc_cpf, 11, '0' ), LPAD( k.nr_cgc_cpf, 14, '0' ) ) nr_cgc_cpf
                      FROM dbamv.lcto_contabil a
                          ,dbamv.mov_glosas b
                          ,dbamv.itcon_rec c
                          ,dbamv.con_rec d
                          ,dbamv.rat_mov_glosas f
                          ,dbamv.fornecedor k
                     WHERE c.cd_itcon_rec = b.cd_itcon_rec
                       AND d.cd_con_rec = c.cd_con_rec
                       AND TO_CHAR( a.dt_lcto, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND b.cd_exp_contabilidade = a.cd_lote
                       AND f.cd_mov_glosas = b.cd_mov_glosas
                       AND k.cd_fornecedor = d.cd_fornecedor
                       AND Nvl(rDadosEmpSped.cd_ind_reg_cum,9) != '1' -- Não retornar o F700 no regime de caixa
                                                               )
         GROUP BY nr_cgc_cpf;
      rVisoes        cvisoes%ROWTYPE;
      rcValoresCredito cValoresCredito%ROWTYPE;
      rNotasRetem    cNotasRetem%ROWTYPE;
      rcGloasRegF700 cGloasRegF700%ROWTYPE;
   BEGIN
      -- REGISTRO F100: DEMAIS DOCUMENTOS E OPERAÇÕES GERADORAS DE CONTRIBUIÇÃO E CRÉDITOS
      --
      nContaConfigF100 := 0;
      --
      IF rDadosEmpSped.cd_ind_reg_cum = '9'
      OR rDadosEmpSped.cd_ind_reg_cum IS NULL THEN
         FOR rvisoes IN cvisoes
         LOOP
            --
            nVlOperf100 := NULL;
            --
            OPEN cVlOper( rvisoes.cd_reduzido );
            FETCH cVlOper
            INTO nVlOperf100;
            CLOSE cVlOper;
            --
            FOR rcTributoF100 IN cTributoF100
            LOOP
               IF rcTributof100.TP_DETALHAMENTO = 'P' THEN
                  nAliqPIS := rcTributoF100.VL_PERCENTUAL;
               ELSE
                  nAliqCofins := rcTributoF100.VL_PERCENTUAL;
               END IF;
            END LOOP;
            --
            IF rvisoes.cd_visao_contabil = 9
           AND dbamv.pkg_mv2000.le_cliente = 267 THEN
               nAliqPIS := NULL;
               nAliqCofins := NULL;
               FOR rcTributo IN cTributo
               LOOP
                  IF rcTributo.TP_DETALHAMENTO = 'P' THEN
                     nPercPis := rcTributo.VL_PERCENTUAL;
                  ELSE
                     nPercCofins := rcTributo.VL_PERCENTUAL;
                  END IF;
               END LOOP;
            END IF;
            --
            IF rvisoes.ind_oper = '0' THEN
               vIND_ORIG_CRED := '0';
               vNAT_BC_CRED := rvisoes.cd_cod_cred;
            ELSE
               vNAT_BC_CRED := NULL;
               vIND_ORIG_CRED := NULL;
            END IF;
            --
            IF LPAD( rvisoes.cd_CST_PIS, 2, '0' ) IN ('04', '05', '06', '07', '08', '09')
            OR LPAD( rvisoes.cd_CST_COFINS, 2, '0' ) IN ('04', '05', '06', '07', '08', '09') THEN
               bEcrituraM410 := TRUE;
               nAliqPIS := 0;
               nAliqCofins := 0;
            END IF;
            --
            vAliqPIS := REPLACE( REPLACE( TO_CHAR( NVL( nAliqPIS, nPercPis ), '9999999999999990.00' ), ' ' ), '.', ',' );
            vAliqCofins := REPLACE( REPLACE( TO_CHAR( NVL( nAliqCofins, nPercCofins ), '9999999999999990.00' ), ' ' ), '.', ',' );
            --
            vVlPIS := REPLACE( REPLACE( TO_CHAR( TRUNC( ( nVlOperf100 * NVL( nAliqPIS, nPercPis ) ) / 100, 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
            vVlCofins := REPLACE( REPLACE( TO_CHAR( TRUNC( ( nVlOperf100 * NVL( nAliqCofins, nPercCofins ) ) / 100, 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
            --
            IF rvisoes.IND_OPER IN ('1', '2') THEN
               nVl_Rec_Brt := NVL( nVl_Rec_Brt, 0 ) + NVL( nVlOperf100, 0 );
            END IF;
            --
            IF NVL( nVlOperf100, 0 ) > 0 THEN
               IF rvisoes.IND_OPER <> '0' THEN
                  --
                  IF rvisoes.cd_visao_contabil = 9
                 AND dbamv.pkg_mv2000.le_cliente = 267 THEN
                     nVlbasetribM210T := NVL( nVlOperf100, 0 ) + NVL( nVlbasetribm210T, 0 );
                  ELSE
                     nVlbasetribM210TNC := NVL( nVlbasetribM210Tnc, 0 ) + NVL( nVlOperf100, 0 );
                  END IF;
                  --
                  vlinha := NULL;
                  --
                  vlinha := vlinha || '|F100'; -- 01 REG
                  vlinha := vlinha || '|' || rvisoes.IND_OPER; -- 02 IND_OPER
                  vlinha := vlinha || '|'; -- 03 COD_PART
                  vlinha := vlinha || '|' || rvisoes.cd_reduzido; -- 04 COD_ITEM
                  vlinha := vlinha || '|' || vdtfim; -- 05 DT_OPER
                  vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVlOperf100, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 06 VL_OPER
                  vlinha := vlinha || '|' || SUBSTR( LPAD( rvisoes.cd_CST_PIS, 2, '0' ), 0, 2 ); -- 07 CST_PIS
                  vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVlOperf100, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 08 VL_BC_PIS
                  vlinha := vlinha || '|' || vAliqPIS; -- 09 ALIQ_PIS
                  vlinha := vlinha || '|' || vVlPIS; -- 10 VL_PIS
                  vlinha := vlinha || '|' || SUBSTR( LPAD( rvisoes.cd_CST_COFINS, 2, '0' ), 0, 2 ); -- 11 CST_COFINS
                  vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVlOperf100, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 12 VL_BC_COFINS
                  vlinha := vlinha || '|' || vAliqCofins; -- 13 ALIQ_COFINS
                  vlinha := vlinha || '|' || vVlCofins; -- 14 VL_COFINS
                  vlinha := vlinha || '|' || vNAT_BC_CRED; -- 15 NAT_BC_CRED
                  vlinha := vlinha || '|' || vIND_ORIG_CRED; -- 16 IND_ORIG_CRED
                  vlinha := vlinha || '|'; -- 17 COD_CTA
                  vlinha := vlinha || '|'; -- 18 COD_CCUS
                  vlinha := vlinha || '|'; -- 19 DESC_DOC_OPER
                  vlinha := vlinha || '|';
                  nconta9999 := NVL( nconta9999, 0 ) + 1;
                  fnc_insere_linha( 'F100', vlinha );
                  nContaConfigF100 := NVL( nContaConfigF100, 0 ) + 1;
               ELSE
                  FOR rcValoresCredito IN cValoresCredito( rvisoes.cd_reduzido )
                  LOOP
                     --
                     --
                     vVlPIS := REPLACE( REPLACE( TO_CHAR( TRUNC( ( rcValoresCredito.vl_operacao * NVL( nAliqPIS, nPercPis ) ) / 100, 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
                     vVlCofins := REPLACE( REPLACE( TO_CHAR( TRUNC( ( rcValoresCredito.vl_operacao * NVL( nAliqCofins, nPercCofins ) ) / 100, 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
                     --
                     vlinha := NULL;
                     --
                     vlinha := vlinha || '|F100'; -- 01 REG
                     vlinha := vlinha || '|' || rvisoes.IND_OPER; -- 02 IND_OPER
                     vlinha := vlinha || '|' || rcValoresCredito.cd_fornecedor; -- 03 COD_PART
                     vlinha := vlinha || '|' || rvisoes.cd_reduzido; -- 04 COD_ITEM
                     vlinha := vlinha || '|' || vdtfim; -- 05 DT_OPER
                     vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rcValoresCredito.vl_operacao, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 06 VL_OPER
                     vlinha := vlinha || '|' || SUBSTR( LPAD( rvisoes.cd_CST_PIS, 2, '0' ), 0, 2 ); -- 07 CST_PIS
                     vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rcValoresCredito.vl_operacao, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 08 VL_BC_PIS
                     vlinha := vlinha || '|' || vAliqPIS; -- 09 ALIQ_PIS
                     vlinha := vlinha || '|' || vVlPIS; -- 10 VL_PIS
                     vlinha := vlinha || '|' || SUBSTR( LPAD( rvisoes.cd_CST_COFINS, 2, '0' ), 0, 2 ); -- 11 CST_COFINS
                     vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rcValoresCredito.vl_operacao, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 12 VL_BC_COFINS
                     vlinha := vlinha || '|' || vAliqCofins; -- 13 ALIQ_COFINS
                     vlinha := vlinha || '|' || vVlCofins; -- 14 VL_COFINS
                     vlinha := vlinha || '|' || vNAT_BC_CRED; -- 15 NAT_BC_CRED
                     vlinha := vlinha || '|' || vIND_ORIG_CRED; -- 16 IND_ORIG_CRED
                     vlinha := vlinha || '|'; -- 17 COD_CTA
                     vlinha := vlinha || '|'; -- 18 COD_CCUS
                     vlinha := vlinha || '|'; -- 19 DESC_DOC_OPER
                     vlinha := vlinha || '|';
                     nconta9999 := NVL( nconta9999, 0 ) + 1;
                     fnc_insere_linha( 'F100', vlinha );
                     nContaConfigF100 := NVL( nContaConfigF100, 0 ) + 1;
                  END LOOP;
               END IF;
            END IF;
         END LOOP;
      END IF;
      IF rDadosEmpSped.cd_ind_reg_cum = 1 THEN
         dbamv.PKG_FCCT_GERA_SPED_PIS_COFINS.PRC63_REGIME_CAIXA( dCopetencia );
      END IF;
      --nVL_RET_CUM_pis := 0;
      --nVL_RET_CUM_cofins := 0;
      -- REGISTRO F600: CONTRIBUIÇÃO RETIDA NA FONTE
      FOR rNotasRetem IN cNotasRetem
      LOOP
         --
         nContaf600 := nContaf600 + 1;
         --
         nVlbasetribNota := 0;
         nVlbaseNtribNota := 0;
         --
         nVlbasetribNota := rNotasRetem.vl_recebido;
         --
         vlPIS := 0;
         VlCofins := 0;
         IF nVlbasetribNota > 0 THEN
            vlPIS := REPLACE( REPLACE( TO_CHAR( TRUNC( ( ( nVlbasetribNota * nPercPis ) / 100 ), 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
            VlCofins := REPLACE( REPLACE( TO_CHAR( TRUNC( ( ( nVlbasetribNota * nPercCofins ) / 100 ), 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
         END IF;
         --
         -- nTotalPisCofinsF600 :=  trunc (((nVlbasetrib * nPercPis)/100),2) + trunc (((nVlbasetrib * nPercCofins)/100),2) ;
         IF rDadosEmpSped.cd_ind_reg_cum IS NULL then
            nTotalPisCofinsF600 := nVlbasetribNota;
         ELSIF rDadosEmpSped.cd_ind_reg_cum = 1 THEN
            nTotalPisCofinsF600 := ( NVL( rNotasRetem.vl_tributo_cofins, 0 ) * 100 / nPerccofins );
         ELSE
            nTotalPisCofinsF600 := ( NVL( rNotasRetem.vl_tributo_cofins, 0 ) * 100 / nPerccofins ) + ( NVL( rNotasRetem.vl_tributo_pis, 0 ) * 100 / nPercpis );
         END IF;
         nVL_RET_CUM_pis := NVL( nVL_RET_CUM_pis, 0 ) + rNotasRetem.vl_tributo_pis; -- nvl(nVL_RET_CUM_pis,0) + trunc (((nVlbasetrib * nPercPis)/100),2) ;
         nVL_RET_CUM_cofins := NVL( nVL_RET_CUM_cofins, 0 ) + rNotasRetem.vl_tributo_cofins; --  + trunc (((nVlbasetrib * nPerccofins)/100),2) ;
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|F600';
         IF rNotasRetem.cd_ind_nat_ret IS NULL THEN
            vlinha := vlinha || '|01';
         ELSE
            --vlinha := vlinha || '|'||To_Char(rNotasRetem.cd_ind_nat_ret,'00')  ;
            vlinha := vlinha || '|' || LPAD( rNotasRetem.cd_ind_nat_ret, 2, '0' );
         END IF;
         --vlinha := vlinha || '|01'  ;
         vlinha := vlinha || '|' || TO_CHAR( rNotasRetem.dt_recebimento, 'ddmmyyyy' );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nTotalPisCofinsF600, '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rNotasRetem.vl_tributo_pis + rNotasRetem.vl_tributo_cofins, '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|';
         IF ( rDadosEmpSped.CD_COD_INC_TRIB IS NULL )
         OR ( rDadosEmpSped.CD_COD_INC_TRIB IN ('1', '3') ) THEN
            vlinha := vlinha || '|0'; -- 0 ¿> Receita de Natureza Não Cumulativa | 1 ¿> Receita de Natureza Cumulativa
         ELSE
            vlinha := vlinha || '|1';
         END IF;
         vlinha := vlinha || '|' || SUBSTR( LPAD( rNotasRetem.nr_CGC_cpf, 14, '0' ), 0, 14 );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rNotasRetem.vl_tributo_pis, '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rNotasRetem.vl_tributo_cofins, '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|0';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'F600', vlinha );
      --
      END LOOP;
      --
      -- REGISTRO F700: DEDUÇÕES DIVERSAS
      --
      nPercPis := 0;
      nPercCofins := 0;
      FOR rcTributo IN cTributo
      LOOP
         IF rcTributo.TP_DETALHAMENTO = 'P' THEN
            nPercPis := rcTributo.VL_PERCENTUAL;
         ELSE
            nPercCofins := rcTributo.VL_PERCENTUAL;
         END IF;
      END LOOP;
      --
      FOR rcGloasRegF700 IN cGloasRegF700
      LOOP
         nContaf700 := nContaf700 + 1;
         nVL_OUT_DED_CUM_pis := NVL( nVL_OUT_DED_CUM_pis, 0 ) + ROUND( ( rcGloasRegF700.VL_BC_OPER * nPercPis ) / 100, 2 );
         nVL_OUT_DED_CUM_cofins := NVL( nVL_OUT_DED_CUM_cofins, 0 ) + ROUND( ( rcGloasRegF700.VL_BC_OPER * nPerccofins ) / 100, 2 );
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|F700';
         vlinha := vlinha || '|99'; -- 99 - Outras Deduções
         vlinha := vlinha || '|1'; -- 1 ¿ Dedução de Natureza Cumulativa
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ROUND( ( rcGloasRegF700.VL_BC_OPER * nPercPis ) / 100, 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ROUND( ( rcGloasRegF700.VL_BC_OPER * nPercCofins ) / 100, 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ROUND( rcGloasRegF700.VL_BC_OPER, 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|' || rcGloasRegF700.nr_cgc_cpf;
         vlinha := vlinha || '|' || 'Soma do valor das glosa aceitas';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'F700', vlinha );
      --
      END LOOP;
   END PRC62_REG_COMP_DET_BLOCOF_IND9;
   /****************************************************/
   PROCEDURE PRC63_REGIME_CAIXA( dCopetencia DATE ) IS
      -- Registro F500
      CURSOR cF500( dCopetencia DATE ) IS
           SELECT SUM( DECODE( NVL( n.cd_status, 'E' ), 'E', ( rcr.vl_recebido + NVL( RCR.VL_IMPOSTO_RETIDO, 0 ) ), 0 ) ) VL_RECEBIDO
             FROM dbamv.nota_fiscal n
                 ,dbamv.con_rec cr
                 ,Dbamv.Itcon_Rec ir
                 ,dbamv.reccon_rec rcr
            WHERE TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND NVL( n.vl_total_nota, 0 ) > 0
              AND n.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
              AND n.cd_nota_fiscal = cr.cd_nota_fiscal
              AND cr.cd_con_rec = ir.cd_con_rec
              AND ir.cd_itcon_rec = rcr.cd_itcon_rec
         ORDER BY n.cd_nota_fiscal;
      --and NVL(n.cd_pais,nCdPais) = nCdPais
      CURSOR cF525Nota( dCopetencia DATE ) IS
           SELECT SUM( vl_recebido ) vl_recebido
                 ,cd_nota_fiscal
                 ,NR_ID_NOTA_FISCAL
                 ,NR_CGC_CPF
                 ,CD_PAIS
             FROM ( SELECT DECODE( NVL( n.cd_status, 'E' ), 'E', ( rcr.vl_recebido + NVL( RCR.VL_IMPOSTO_RETIDO, 0 ) ), 0 ) VL_RECEBIDO
                          ,DECODE( NVL( n.cd_status, 'E' ), 'E', n.cd_nota_fiscal, NULL ) cd_nota_fiscal
                          ,DECODE( NVL( n.cd_status, 'E' ), 'E', n.NR_ID_NOTA_FISCAL, NULL ) NR_ID_NOTA_FISCAL
                          ,N.NR_CGC_CPF
                          ,N.CD_PAIS
                      FROM dbamv.nota_fiscal n
                          ,dbamv.con_rec cr
                          ,Dbamv.Itcon_Rec ir
                          ,dbamv.reccon_rec rcr
                     WHERE TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND NVL( n.vl_total_nota, 0 ) > 0
                       AND n.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                       AND n.cd_nota_fiscal = cr.cd_nota_fiscal
                       AND cr.cd_con_rec = ir.cd_con_rec
                       AND ir.cd_itcon_rec = rcr.cd_itcon_rec )
         GROUP BY cd_nota_fiscal
                 ,NR_ID_NOTA_FISCAL
                 ,NR_CGC_CPF
                 ,CD_PAIS
         ORDER BY NR_ID_NOTA_FISCAL;
      nVlRecF500     VARCHAR2( 20 );
      nVlRecF525     VARCHAR2( 20 );
      nVlRecF525Nota VARCHAR( 20 );
      vregistroF509  VARCHAR2( 4000 );
      vregistroF559  VARCHAR2( 4000 );
      rcF525Nota     cF525Nota%ROWTYPE;
      vItemNF        NUMBER;
      nCountItens    NUMBER;
      nContaF525     NUMBER;
      vSomaItensNF   NUMBER;
      nPerceBaixaNota NUMBER;
      vCFGCGC        VARCHAR( 30 );
      vIndRec        VARCHAR( 2 );
      vValItemTotal  NUMBER;
      nValorCalculo  NUMBER;
   BEGIN
      nPercPis := NULL;
      nPercCofins := NULL;
      nAliqPIS := NULL;
      nAliqCofins := NULL;
      vregistroF509 := dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SPED_PC_REGISTRO_F509' );
      vregistroF559 := dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SPED_PC_REGISTRO_F559' );
      FOR rcTributo IN cTributo
      LOOP
         IF rcTributo.TP_DETALHAMENTO = 'P' THEN
            nPercPis := rcTributo.VL_PERCENTUAL;
         ELSE
            nPercCofins := rcTributo.VL_PERCENTUAL;
         END IF;
      END LOOP;
      IF rDadosEmpSped.cd_ind_reg_cum = 9
      OR rDadosEmpSped.cd_ind_reg_cum IS NULL THEN
         FOR rcTributoF100 IN cTributoF100
         LOOP
            IF rcTributof100.TP_DETALHAMENTO = 'P' THEN
               nAliqPIS := rcTributoF100.VL_PERCENTUAL;
            ELSE
               nAliqCofins := rcTributoF100.VL_PERCENTUAL;
            END IF;
         END LOOP;
      END IF;
      nVlRecF500 := 0;
      OPEN cF500( dCopetencia );
      FETCH cF500
      INTO nVlRecF500;
      CLOSE cF500;
      IF nVlRecF500 IS NOT NULL THEN
         vSPED_CST_PIS := SUBSTR( rDadosEmpSped.cd_CST_PIS, 0, 2 );
         vSPED_CST_COFINS := SUBSTR( rDadosEmpSped.cd_CST_COFINS, 0, 2 );
         vAliqPIS := REPLACE( REPLACE( TO_CHAR( NVL( nAliqPIS, nPercPis ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vAliqCofins := REPLACE( REPLACE( TO_CHAR( NVL( nAliqCofins, nPercCofins ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vVlPIS := REPLACE( REPLACE( TO_CHAR( TRUNC( ( nVlRecF500 * NVL( nAliqPIS, nPercPis ) ) / 100, 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vVlCofins := REPLACE( REPLACE( TO_CHAR( TRUNC( ( nVlRecF500 * NVL( nAliqCofins, nPercCofins ) ) / 100, 2 ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := NULL;
         vlinha := vlinha || '|F500'; -- 01
         vlinha := vlinha || '|' || REPLACE( REPLACE( NVL( nVlRecF500, '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|' || LPAD( vSPED_CST_PIS, 2, '0' );
         vlinha := vlinha || '|';
         vlinha := vlinha || '|' || REPLACE( REPLACE( NVL( nVlRecF500, '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|' || vAliqPIS;
         vlinha := vlinha || '|' || vVlPIS; -- 07
         vlinha := vlinha || '|' || LPAD( vSPED_CST_COFINS, 2, '0' ); -- 09 CST_PIS
         vlinha := vlinha || '|';
         vlinha := vlinha || '|' || REPLACE( REPLACE( NVL( nVlRecF500, '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|' || vAliqCofins;
         vlinha := vlinha || '|' || vVlCofins;
         vlinha := vlinha || '|';
         vlinha := vlinha || '|';
         vlinha := vlinha || '|';
         vlinha := vlinha || '|';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'F500', vlinha );
         nContaConfigF500 := NVL( nContaConfigF500, 0 ) + 1;
         -- Registro F509
         vlinha := NULL;
         IF vRegistroF509 IS NOT NULL THEN
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( 'F509', vregistroF509 );
            nContaConfigF509 := NVL( nContaConfigF509, 0 ) + 1;
         END IF;
         vValItemTotal := 0;
         FOR rcF525Nota IN cF525Nota( dCopetencia )
         LOOP
            FOR rcBaseCalculo IN cBaseCalculo( rcF525Nota.cd_nota_fiscal )
            LOOP
               IF TO_NUMBER( rcBaseCalculo.vl_itfat_nf ) > 0 THEN
                  vValItemTotal := vValItemTotal + TO_NUMBER( rcBaseCalculo.vl_itfat_nf );
               END IF;
            END LOOP;
         END LOOP;
         FOR rcF525Nota IN cF525Nota( dCopetencia )
         LOOP
            nCountItens := 0;
            IF rcF525Nota.Vl_Recebido > 0 THEN
               FOR rcBaseCalculo IN cBaseCalculo( rcF525Nota.cd_nota_fiscal )
               LOOP
                  IF TO_NUMBER( rcBaseCalculo.vl_itfat_nf ) > 0 THEN
                     nCountItens := nCountItens + 1;
                  END IF;
               END LOOP;
               nValorCalculo := rcF525Nota.vl_recebido / vValItemTotal;
               nContaF525 := 0;
               vSomaItensNF := 0;
               FOR rcBaseCalculo IN cBaseCalculo( rcF525Nota.cd_nota_fiscal )
               LOOP
                  IF TO_NUMBER( rcBaseCalculo.vl_itfat_nf ) > 0 THEN
                     --vItemNF := TRUNC(TO_NUMBER(rcBaseCalculo.vl_itfat_nf) * (nPerceBaixaNota/100),2);
                     vItemNF := TRUNC( ( TO_NUMBER( rcBaseCalculo.vl_itfat_nf ) * nValorCalculo ), 2 );
                     nContaF525 := nContaF525 + 1;
                     vSomaItensNF := vSomaItensNF + vItemNF;
                     IF nContaF525 = nCountItens THEN
                        vItemNF := vItemNF + ( rcF525Nota.Vl_Recebido - vSomaItensNF );
                     END IF;
                  ELSE
                     vItemNF := 0;
                  END IF;
                  IF NVL( rcF525Nota.cd_pais, nCdPais ) = nCdPais THEN
                     vCFGCGC := REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( rcF525Nota.NR_CGC_CPF, '-', '' ), '.', '' ), '/', '' ), '\', '' ), ' ', '' );
                     vIndRec := '01';
                  ELSE
                     vCFGCGC := NULL;
                     vIndRec := '04';
                  END IF;
                  IF vItemNF > 0 THEN
                     vlinha := NULL;
                     vlinha := vlinha || '|F525'; -- 01
                     vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( rcF525Nota.Vl_Recebido, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' ); -- 05;
                     vlinha := vlinha || '|' || vIndRec;
                     vlinha := vlinha || '|' || vCFGCGC; -- 02;
                     vlinha := vlinha || '|' || rcF525Nota.NR_ID_NOTA_FISCAL;
                     vlinha := vlinha || '|' || rcBaseCalculo.CD_GRU_FAT;
                     vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( vItemNF, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' ); -- 05;
                     vlinha := vlinha || '|' || LPAD( vSPED_CST_PIS, 2, '0' );
                     vlinha := vlinha || '|' || LPAD( vSPED_CST_COFINS, 2, '0' ); -- 09 CST_COFINS;
                     vlinha := vlinha || '|';
                     vlinha := vlinha || '|';
                     vlinha := vlinha || '|';
                     nconta9999 := NVL( nconta9999, 0 ) + 1;
                     fnc_insere_linha( 'F525', vlinha );
                     nContaConfigF525 := NVL( nContaConfigF525, 0 ) + 1;
                  END IF;
                  nVlbasetribM210T := NVL( vItemNF, 0 ) + NVL( nVlbasetribm210t, 0 );
               END LOOP;
            END IF;
         END LOOP;
      END IF;
   END PRC63_REGIME_CAIXA;
   /****************************************************/
   PROCEDURE PRC7_REGIME_COMP_DET_BLOCOM( dCopetencia DATE ) IS
      CURSOR CTotalM400M800 IS
           SELECT ds_cst_pis CST_PIS
                 ,ds_cst_cofins CST_cofins
                 ,SUM( fnc_charnum( ds_vl_item ) ) vl_total_M400M800
             --,SUM( TO_NUMBER( REPLACE( TRIM( ds_vl_item ), '.', ',' ) ) ) vl_total_M400M800
             FROM dbamv.temp_sped_contr_reg_a170
            WHERE ds_cst_pis IN ('04', '06', '07', '08', '09')
              AND ds_cst_cofins IN ('04', '06', '07', '08', '09')
         GROUP BY ds_cst_pis
                 ,ds_cst_cofins;
      CURSOR CTotalM410M810( vCST VARCHAR2 ) IS
           SELECT SUM( vl_total_M410M810 ) vl_total_M410M810
                 ,NAT_REC_PIS
                 ,NAT_REC_COFINS
             FROM ( SELECT SUM( fnc_charnum( ds_vl_item ) ) vl_total_M410M810
                          ,DECODE( SUM( NVL( fnc_charnum( ds_vl_item ), 0 ) ), 0, NULL, '999' ) NAT_REC_PIS
                          ,DECODE( SUM( NVL( fnc_charnum( ds_vl_item ), 0 ) ), 0, NULL, '999' ) NAT_REC_COFINS
                      FROM dbamv.temp_sped_contr_reg_a170
                     WHERE ds_cst_pis IN ('04', '06', '07', '08', '09')
                       AND ds_cst_cofins IN ('04', '06', '07', '08', '09') )
            WHERE vl_total_M410M810 > 0
              AND NAT_REC_COFINS IS NOT NULL
              AND NAT_REC_COFINS IS NOT NULL
         GROUP BY NAT_REC_COFINS
                 ,NAT_REC_PIS;
      CURSOR cDiferimentoM300M700 IS
           SELECT SUM( vl_recebido ) VL_CONT_APUR_DIFER
                 ,0 VL_CRED_DESC_DIFER
                 ,dt_emissao PER_APUR
             FROM ( SELECT ( NVL( rcr.vl_recebido, 0 ) + NVL( RCR.VL_IMPOSTO_RETIDO, 0 ) ) vl_recebido
                          ,TO_CHAR( n.dt_emissao, 'MMYYYY' ) dt_emissao
                      FROM dbamv.nota_fiscal n
                          ,dbamv.fornecedor f
                          ,dbamv.constituicao_empresa ce
                          ,dbamv.con_rec cr
                          ,Dbamv.Itcon_Rec ir
                          ,dbamv.reccon_rec rcr
                          ,dbamv.multi_empresas me
                     WHERE ( me.CD_MULTI_EMPRESA = dbamv.pkg_mv2000.le_empresa
                         OR me.CD_MULTI_EMPRESA_CONSOL = dbamv.pkg_mv2000.le_empresa )
                       AND n.cd_multi_empresa = me.cd_multi_empresa
                       AND TO_CHAR( n.dt_emissao, 'MM/YYYY' ) <> TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND n.cd_fornecedor = f.cd_fornecedor(+)
                       AND f.cd_constituicao_empresa = ce.cd_constituicao_empresa(+)
                       AND ( ( rDadosEmpSped.cd_ind_reg_cum = '1' )
                         OR ( ( rDadosEmpSped.cd_ind_reg_cum = '9'
                            OR rDadosEmpSped.cd_ind_reg_cum IS NULL )
                         AND ce.cd_constituicao_empresa = 1
                         AND n.tp_pessoa_rps = 'J' ) )
                       AND NVL( n.vl_total_nota, 0 ) > 0
                       AND n.cd_nota_fiscal = cr.cd_nota_fiscal
                       AND cr.cd_con_rec = ir.cd_con_rec
                       AND ir.cd_itcon_rec = rcr.cd_itcon_rec )
         GROUP BY dt_emissao
         ORDER BY dt_emissao;
      CURSOR cEscrituraM400M800 IS
         SELECT SUM( vl_total_M400M800 ) vl_total_M400M800
           FROM ( SELECT SUM( NVL( itf.vl_itfat_nf, 0 ) ) vl_total_M400M800
                    FROM dbamv.itfat_nota_fiscal itf
                        ,dbamv.nota_fiscal n
                   WHERE n.cd_nota_fiscal = itf.cd_nota_fiscal
                     AND TO_CHAR( n.dt_emissao, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'mm/yyyy' )
                     AND itf.cd_pro_fat IN (SELECT cd_pro_fat
                                              FROM dbamv.produto
                                             WHERE NVL( tp_classificacao_tributaria, 'T' ) = 'II'
                                               AND produto.cd_pro_fat = itf.cd_pro_fat)
                  UNION ALL
                  SELECT SUM( NVL( itf.vl_itfat_nf, 0 ) ) vl_total_M400M800
                    FROM dbamv.itfat_nota_fiscal_canc itf
                        ,dbamv.nota_fiscal n
                   WHERE n.cd_nota_fiscal = itf.cd_nota_fiscal
                     AND TO_CHAR( n.dt_emissao, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'mm/yyyy' )
                     AND n.cd_status = 'C'
                     AND TO_CHAR( n.dt_cancelamento, 'mm/yyyy' ) <> TO_CHAR( dCopetencia, 'mm/yyyy' )
                     AND n.dt_cancelamento > dtCancIni
                     AND itf.cd_pro_fat IN (SELECT cd_pro_fat
                                              FROM dbamv.produto
                                             WHERE NVL( tp_classificacao_tributaria, 'T' ) = 'II'
                                               AND produto.cd_pro_fat = itf.cd_pro_fat)
                  UNION ALL
                    SELECT SUM( NVL( itf.vl_itfat_nf, 0 ) ) vl_total_M400M800
                      FROM dbamv.itfat_nota_fiscal itf
                          ,dbamv.nota_fiscal n
                          ,dbamv.empresa_sped_pis_cofins epc
                     WHERE n.cd_nota_fiscal = itf.cd_nota_fiscal
                       AND TO_CHAR( n.dt_emissao, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'mm/yyyy' )
                       AND epc.cd_multi_empresa = n.cd_multi_empresa
                       AND epc.cd_cst_pis IN ('07', '08')
                       AND epc.cd_cst_cofins IN ('07', '08')
                       AND tp_nota_fiscal = 'N'
                  GROUP BY epc.cd_cst_pis
                          ,epc.cd_cst_cofins
                  UNION ALL
                    SELECT SUM( NVL( itf.vl_itfat_nf, 0 ) ) vl_total_M400M800
                      FROM dbamv.itfat_nota_fiscal_canc itf
                          ,dbamv.nota_fiscal n
                          ,dbamv.empresa_sped_pis_cofins epc
                     WHERE n.cd_nota_fiscal = itf.cd_nota_fiscal
                       AND TO_CHAR( n.dt_emissao, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'mm/yyyy' )
                       AND n.cd_status = 'C'
                       AND TO_CHAR( n.dt_cancelamento, 'mm/yyyy' ) <> TO_CHAR( dCopetencia, 'mm/yyyy' )
                       AND n.dt_cancelamento > dtCancIni
                       AND epc.cd_multi_empresa = n.cd_multi_empresa
                       AND epc.cd_cst_pis IN ('07', '08')
                       AND epc.cd_cst_cofins IN ('07', '08')
                       AND tp_nota_fiscal = 'N'
                  GROUP BY epc.cd_cst_pis
                          ,epc.cd_cst_cofins
                  UNION ALL
                    SELECT SUM( NVL( n.vl_total_nota, 0 ) ) vl_total_M400M800
                      FROM dbamv.itnota_fiscal itf
                          ,dbamv.nota_fiscal n
                          ,dbamv.empresa_sped_pis_cofins epc
                     WHERE n.cd_nota_fiscal = itf.cd_nota_fiscal
                       AND TO_CHAR( n.dt_emissao, 'mm/yyyy' ) = TO_CHAR( dCopetencia, 'mm/yyyy' )
                       AND epc.cd_multi_empresa = n.cd_multi_empresa
                       AND epc.cd_cst_pis IN ('07', '08')
                       AND epc.cd_cst_cofins IN ('07', '08')
                       AND tp_nota_fiscal = 'A'
                       AND ( NVL( n.cd_status, 'E' ) <> 'C'
                         OR ( n.cd_status = 'C'
                         AND TO_CHAR( n.dt_cancelamento, 'mm/yyyy' ) <> TO_CHAR( dCopetencia, 'mm/yyyy' )
                         AND n.dt_cancelamento > dtCancIni ) )
                  GROUP BY epc.cd_cst_pis
                          ,epc.cd_cst_cofins
                  UNION ALL
                    SELECT SUM( ABS( sm.vl_credito - sm.vl_debito ) ) vl_total_M400M800
                      FROM dbamv.saldo_mensal sm
                          ,dbamv.plano_contas pc
                          ,dbamv.empresa_sped_pis_cofins epc
                          ,dbamv.visao_contabil vc
                          ,dbamv.it_visao_contabil ivc
                     WHERE TO_CHAR( dt_saldo_mes, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' ) -- '01/2008'
                       AND pc.cd_reduzido = sm.cd_reduzido
                       AND pc.cd_reduzido = ivc.cd_reduzido
                       AND sm.cd_reduzido = ivc.cd_reduzido
                       AND epc.cd_multi_empresa = 1
                       AND ivc.cd_visao_contabil = vc.cd_visao_contabil
                       AND SUBSTR( ivc.cd_CST_PIS, 0, 2 ) IN ('04', '05', '06', '07', '08', '09')
                       AND SUBSTR( ivc.cd_CST_COFINS, 0, 2 ) IN ('04', '05', '06', '07', '08', '09')
                  GROUP BY ivc.cd_CST_PIS
                          ,ivc.cd_CST_COFINS );
      CURSOR cDiferimentoM230M630 IS
           SELECT nr_cgc_cpf
                 ,DECODE( SIGN( SUM( VL_VEND ) - SUM( VL_RECEB ) ), 1, ( SUM( VL_VEND ) - SUM( VL_RECEB ) ), SUM( VL_VEND ) ) VL_NAO_RECEB
                 ,SUM( VL_VEND ) VL_VEND
                 ,SUM( VL_RECEB ) VL_RECEB
             FROM ( SELECT REPLACE( REPLACE( REPLACE( REPLACE( N.nr_cgc_cpf, '.', '' ), '-', '' ), '/', '' ), ' ', '' ) nr_cgc_cpf
                          ,( DECODE( NVL( n.cd_status, 'E' ), 'E', NVL( rcr.vl_recebido, 0 ) + NVL( RCR.VL_IMPOSTO_RETIDO, 0 ), 0 ) ) VL_RECEB
                          ,0 VL_VEND
                      FROM dbamv.nota_fiscal n
                          ,dbamv.fornecedor f
                          ,dbamv.constituicao_empresa ce
                          ,dbamv.con_rec cr
                          ,dbamv.multi_empresas me
                          ,Dbamv.Itcon_Rec ir
                          ,dbamv.reccon_rec rcr
                     WHERE ( me.CD_MULTI_EMPRESA = dbamv.pkg_mv2000.le_empresa
                         OR me.CD_MULTI_EMPRESA_CONSOL = dbamv.pkg_mv2000.le_empresa )
                       AND n.cd_multi_empresa = me.cd_multi_empresa
                       AND TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND NVL( n.vl_total_nota, 0 ) > 0
                       AND n.cd_nota_fiscal = cr.cd_nota_fiscal
                       AND cr.cd_con_rec = ir.cd_con_rec
                       AND ir.cd_itcon_rec = rcr.cd_itcon_rec
                       AND n.cd_fornecedor = f.cd_fornecedor(+)
                       AND f.cd_constituicao_empresa = ce.cd_constituicao_empresa(+)
                       --AND ((rDadosEmpSped.cd_ind_reg_cum = '1') OR ((rDadosEmpSped.cd_ind_reg_cum = '9' or rDadosEmpSped.cd_ind_reg_cum is null) AND ce.cd_constituicao_empresa = 1 AND n.tp_pessoa_rps = 'J'))
                       AND ( ( rDadosEmpSped.cd_ind_reg_cum = '1' )
                         OR ( ( rDadosEmpSped.cd_ind_reg_cum = '9'
                            OR rDadosEmpSped.cd_ind_reg_cum IS NULL )
                         AND ce.cd_constituicao_empresa = 1 ) )
                       AND n.tp_pessoa_rps = 'J'
                    UNION ALL
                    SELECT REPLACE( REPLACE( REPLACE( REPLACE( N.nr_cgc_cpf, '.', '' ), '-', '' ), '/', '' ), ' ', '' ) nr_cgc_cpf
                          ,0 VL_RECEB
                          ,DECODE( NVL( n.cd_status, 'E' ), 'E', NVL( N.VL_TOTAL_NOTA, 0 ), 0 ) VL_VEND
                      FROM dbamv.nota_fiscal n
                          ,dbamv.fornecedor f
                          ,dbamv.constituicao_empresa ce
                          ,dbamv.multi_empresas me
                     WHERE ( me.CD_MULTI_EMPRESA = dbamv.pkg_mv2000.le_empresa
                         OR me.CD_MULTI_EMPRESA_CONSOL = dbamv.pkg_mv2000.le_empresa )
                       AND n.cd_multi_empresa = me.cd_multi_empresa
                       AND TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND n.cd_fornecedor = f.cd_fornecedor(+)
                       AND f.cd_constituicao_empresa = ce.cd_constituicao_empresa(+)
                       --AND ((rDadosEmpSped.cd_ind_reg_cum = '1') OR ((rDadosEmpSped.cd_ind_reg_cum = '9' or rDadosEmpSped.cd_ind_reg_cum is null) AND ce.cd_constituicao_empresa = 1 AND n.tp_pessoa_rps = 'J'))
                       AND ( ( rDadosEmpSped.cd_ind_reg_cum = '1' )
                         OR ( ( rDadosEmpSped.cd_ind_reg_cum = '9'
                            OR rDadosEmpSped.cd_ind_reg_cum IS NULL )
                         AND ce.cd_constituicao_empresa = 1 ) )
                       AND n.tp_pessoa_rps = 'J'
                       AND NVL( n.vl_total_nota, 0 ) > 0 )
         GROUP BY nr_cgc_cpf;
      CURSOR cDiferimentoM230M630ComPF IS
           SELECT nr_cgc_cpf
                 ,DECODE( SIGN( SUM( VL_VEND ) - SUM( VL_RECEB ) ), 1, ( SUM( VL_VEND ) - SUM( VL_RECEB ) ), SUM( VL_VEND ) ) VL_NAO_RECEB
                 ,SUM( VL_VEND ) VL_VEND
                 ,SUM( VL_RECEB ) VL_RECEB
             FROM ( SELECT REPLACE( REPLACE( REPLACE( REPLACE( N.nr_cgc_cpf, '.', '' ), '-', '' ), '/', '' ), ' ', '' ) nr_cgc_cpf
                          ,( DECODE( NVL( n.cd_status, 'E' ), 'E', NVL( rcr.vl_recebido, 0 ) + NVL( RCR.VL_IMPOSTO_RETIDO, 0 ), 0 ) ) VL_RECEB
                          ,0 VL_VEND
                      FROM dbamv.nota_fiscal n
                          ,dbamv.fornecedor f
                          ,dbamv.constituicao_empresa ce
                          ,dbamv.con_rec cr
                          ,dbamv.multi_empresas me
                          ,Dbamv.Itcon_Rec ir
                          ,dbamv.reccon_rec rcr
                     WHERE ( me.CD_MULTI_EMPRESA = dbamv.pkg_mv2000.le_empresa
                         OR me.CD_MULTI_EMPRESA_CONSOL = dbamv.pkg_mv2000.le_empresa )
                       AND n.cd_multi_empresa = me.cd_multi_empresa
                       AND TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND NVL( n.vl_total_nota, 0 ) > 0
                       AND n.cd_nota_fiscal = cr.cd_nota_fiscal
                       AND cr.cd_con_rec = ir.cd_con_rec
                       AND ir.cd_itcon_rec = rcr.cd_itcon_rec
                       AND n.cd_fornecedor = f.cd_fornecedor(+)
                       AND f.cd_constituicao_empresa = ce.cd_constituicao_empresa(+)
                       AND ( ( rDadosEmpSped.cd_ind_reg_cum = '1' )
                         OR ( ( rDadosEmpSped.cd_ind_reg_cum = '9'
                            OR rDadosEmpSped.cd_ind_reg_cum IS NULL )
                         AND ce.cd_constituicao_empresa = 1
                         AND n.tp_pessoa_rps = 'J' ) )
                    UNION ALL
                    SELECT REPLACE( REPLACE( REPLACE( REPLACE( N.nr_cgc_cpf, '.', '' ), '-', '' ), '/', '' ), ' ', '' ) nr_cgc_cpf
                          ,0 VL_RECEB
                          ,DECODE( NVL( n.cd_status, 'E' ), 'E', NVL( N.VL_TOTAL_NOTA, 0 ), 0 ) VL_VEND
                      FROM dbamv.nota_fiscal n
                          ,dbamv.fornecedor f
                          ,dbamv.constituicao_empresa ce
                          ,dbamv.multi_empresas me
                     WHERE ( me.CD_MULTI_EMPRESA = dbamv.pkg_mv2000.le_empresa
                         OR me.CD_MULTI_EMPRESA_CONSOL = dbamv.pkg_mv2000.le_empresa )
                       AND n.cd_multi_empresa = me.cd_multi_empresa
                       AND TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
                       AND n.cd_fornecedor = f.cd_fornecedor(+)
                       AND f.cd_constituicao_empresa = ce.cd_constituicao_empresa(+)
                       AND ( ( rDadosEmpSped.cd_ind_reg_cum = '1' )
                         OR ( ( rDadosEmpSped.cd_ind_reg_cum = '9'
                            OR rDadosEmpSped.cd_ind_reg_cum IS NULL )
                         AND ce.cd_constituicao_empresa = 1
                         AND n.tp_pessoa_rps = 'J' ) )
                       AND NVL( n.vl_total_nota, 0 ) > 0 )
         GROUP BY nr_cgc_cpf;
      rCTotalM400M800 CTotalM400M800%ROWTYPE;
      rCTotalM410M810 CTotalM410M810%ROWTYPE;
      rcDiferimentoM300M700 cDiferimentoM300M700%ROWTYPE;
      rcDiferimentoM230M630 cDiferimentoM230M630%ROWTYPE;
      mVL_DIFER_PIS  NUMBER := 0;
      mVL_DIFER_COFINS NUMBER := 0;
      mVL_VPERIODO_PIS NUMBER := 0;
      mVL_VPERIODO_COFINS NUMBER := 0;
      vVl_RecebiComp NUMBER := 0;
      vVl_RecebiForaComp NUMBER := 0;
      mVL_TOTAL_RECEBIDO NUMBER := 0;
      nVlCumulatico  NUMBER := 0;
      nVlNCumulatico NUMBER := 0;
   BEGIN
      ncontam205 := 0;
      ncontam605 := 0;
      OPEN cEscrituraM400M800;
      FETCH cEscrituraM400M800
      INTO nEscrituraM400M800;
      CLOSE cEscrituraM400M800;
      IF NVL( nEscrituraM400M800, 0 ) = 0 THEN
         bEcrituraM410 := FALSE;
      END IF;
      --
      OPEN cTotalRecBruCumu( dCopetencia );
      FETCH cTotalRecBruCumu
      INTO nRecBruCumu;
      CLOSE cTotalRecBruCumu;
      --
      IF rDadosEmpSped.cd_ind_reg_cum = 1 THEN
         /* select SUM(decode (nvl(n.cd_status ,'E'),'E' , (rcr.vl_recebido + RCR.VL_IMPOSTO_RETIDO), 0 )) vl_recebido
            Into nVlbasetribM210T
            from dbamv.nota_fiscal  n,
                dbamv.con_rec cr,
                Dbamv.Itcon_Rec ir,
                dbamv.reccon_rec rcr,
             dbamv.multi_empresas me
           where (me.CD_MULTI_EMPRESA = dbamv.pkg_mv2000.le_empresa
               OR me.CD_MULTI_EMPRESA_CONSOL = dbamv.pkg_mv2000.le_empresa)
           AND n.cd_multi_empresa = me.cd_multi_empresa
           AND   To_Char( rcr.dt_recebimento,'MM/YYYY') =  TO_CHAR(dCopetencia , 'MM/YYYY')
             And nvl(n.vl_total_nota,0) > 0
             And n.cd_nota_fiscal = cr.cd_nota_fiscal
             and cr.cd_con_rec = ir.cd_con_rec
             and ir.cd_itcon_rec = rcr.cd_itcon_rec
             order by n.cd_nota_fiscal;*/
         -- É referente ao valor total da notas que foram emitidas na competência, independente se foi recebido ou não. (Faturamento x Alíquota)
         SELECT SUM( n.vl_total_nota )
           INTO nVlbasetribM210T
           FROM dbamv.nota_fiscal n
               ,dbamv.multi_empresas me
          WHERE ( me.CD_MULTI_EMPRESA = dbamv.pkg_mv2000.le_empresa
              OR me.CD_MULTI_EMPRESA_CONSOL = dbamv.pkg_mv2000.le_empresa )
            AND n.cd_multi_empresa = me.cd_multi_empresa
            AND TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
            AND ( ( NVL( n.cd_status, 'E' ) = 'E' )
              OR ( n.cd_status = 'C'
              AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) <> TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND n.dt_cancelamento > dtCancIni ) )
            AND NVL( n.vl_total_nota, 0 ) > 0;
           --  Referente ao valor das notas com emissão na competência e não teve recebimento. (Obrigatório a escrituração do M230)
           SELECT nVlbasetribM210T - SUM( DECODE( NVL( n.cd_status, 'E' ), 'E', ( rcr.vl_recebido + NVL( RCR.VL_IMPOSTO_RETIDO, 0 ) ), 0 ) ) VL_RECEBIDO
             INTO vVl_RecebiComp
             FROM dbamv.nota_fiscal n
                 ,dbamv.con_rec cr
                 ,Dbamv.Itcon_Rec ir
                 ,dbamv.reccon_rec rcr
            WHERE TO_CHAR( rcr.dt_recebimento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND NVL( n.vl_total_nota, 0 ) > 0
              AND n.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
              AND n.cd_nota_fiscal = cr.cd_nota_fiscal
              AND cr.cd_con_rec = ir.cd_con_rec
              AND ir.cd_itcon_rec = rcr.cd_itcon_rec
         ORDER BY n.cd_nota_fiscal;
      /*   --Que são as notas emitidas em competências anteriores e que foram recebidas na competência.
      select SUM(decode (nvl(n.cd_status ,'E'),'E' , rcr.vl_recebido, 0 )) VL_RECEBIDO
        into vVl_RecebiForaComp
        from dbamv.nota_fiscal  n,
             dbamv.con_rec cr,
             Dbamv.Itcon_Rec ir,
             dbamv.reccon_rec rcr
       where To_Char( rcr.dt_recebimento,'MM/YYYY') =  TO_CHAR(dCopetencia , 'MM/YYYY')
         And To_Char( n.dt_emissao,'MM/YYYY') <> TO_CHAR(dCopetencia , 'MM/YYYY')
         And nvl(n.vl_total_nota,0) > 0
         AND n.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
         And n.cd_nota_fiscal = cr.cd_nota_fiscal
         and cr.cd_con_rec = ir.cd_con_rec
         and ir.cd_itcon_rec = rcr.cd_itcon_rec
         order by n.cd_nota_fiscal;      */
      END IF;
      -- REGISTRO M001: ABERTURA DO BLOCO M
      IF ( NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'N'
       OR NVL( nRecBruCumu, 0 ) > 0 ) THEN
         FOR rcTributoF100 IN cTributoF100
         LOOP
            IF rcTributof100.TP_DETALHAMENTO = 'P' THEN
               nAliqPIS := rcTributoF100.VL_PERCENTUAL;
            ELSE
               nAliqCofins := rcTributoF100.VL_PERCENTUAL;
            END IF;
         END LOOP;
         --
         FOR rcTributo IN cTributo
         LOOP
            IF rcTributo.TP_DETALHAMENTO = 'P' THEN
               nPercPis := rcTributo.VL_PERCENTUAL;
            ELSE
               nPercCofins := rcTributo.VL_PERCENTUAL;
            END IF;
         END LOOP;
         --
         nRecNCumTribu0111 := NULL;
         nRecNCumNTribu0111 := NULL;
         IF nVL_RET_CUM_pis IS NULL THEN
            nVL_RET_CUM_pis := 0;
         END IF;
         --
         OPEN cRecNCumTribu( dCopetencia );
         FETCH cRecNCumTribu
         INTO nRecNCumTribu0111
             ,nRecNCumNTribu0111;
         CLOSE cRecNCumTribu;
         --
         IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'S' THEN
            nRecNCumTribu0111 := 0;
            nVlbasetribM210T := 0;
            nVL_RET_CUM_pis := 0;
            nVL_OUT_DED_CUM_pis := 0;
         END IF;
         --
         vlinha := NULL;
         --
         mVL_DIFER_PIS := 0;
         mVL_TOTAL_RECEBIDO := 0;
         IF ( rDadosEmpSped.cd_ind_reg_cum = '9'
          OR rDadosEmpSped.cd_ind_reg_cum IS NULL ) THEN
            mVL_TOTAL_RECEBIDO := NVL( param_nVLRECM410, 0 );
         END IF;
         IF rDadosEmpSped.cd_ind_reg_cum = '9' THEN
            --
            FOR rCTotalM400M800 IN CTotalM400M800
            LOOP
               mVL_TOTAL_RECEBIDO := mVL_TOTAL_RECEBIDO - NVL( rCTotalM400M800.vl_total_M400M800, 0 );
            /*DECLARE
               vauxds_vl_item NUMBER;
               vaux varchar2(1000);
            BEGIN
               vaux  := rCTotalM400M800.ds_vl_item;
               vauxds_vl_item := TO_NUMBER( rCTotalM400M800.ds_vl_item );
               mVL_TOTAL_RECEBIDO := mVL_TOTAL_RECEBIDO - vauxds_vl_item;
            EXCEPTION
               WHEN OTHERS THEN
                  raise_application_error( -20301,
                  ' Não converte valor: [' || vaux ||'] - '||
                  ' Valor Orig:['||rCTotalM400M800.ds_vl_item ||'] - '||
                  chr(10)|| TO_CHAR( SQLCODE ) ||' - '|| SQLERRM );
            END;
            */
            END LOOP;
         --
         END IF;
         --If rDadosEmpSped.cd_ind_reg_cum = '1' or rDadosEmpSped.cd_ind_reg_cum is null Then
         mVL_CONT_DIFER_ANT_PIS := 0;
         FOR rcDiferimentoM230M630 IN cDiferimentoM230M630ComPF
         LOOP
            mVL_TOTAL_RECEBIDO := mVL_TOTAL_RECEBIDO + NVL( rcDiferimentoM230M630.vl_receb, 0 );
         END LOOP;
         IF ( rDadosEmpSped.cd_ind_reg_cum = '9'
          OR rDadosEmpSped.cd_ind_reg_cum IS NULL ) THEN
            FOR rcDiferimentoM230M630 IN cDiferimentoM230M630
            LOOP
               mVL_DIFER_PIS := mVL_DIFER_PIS + ROUND( ( rcDiferimentoM230M630.VL_NAO_RECEB * nPercPis ) / 100, 2 );
            END LOOP;
         END IF;
         FOR rcDiferimentoM300M700 IN cDiferimentoM300M700
         LOOP
            mVL_TOTAL_RECEBIDO := mVL_TOTAL_RECEBIDO + NVL( rcDiferimentoM300M700.VL_CONT_APUR_DIFER, 0 );
         END LOOP;
         IF ( vsndiferimento = '1' ) THEN
            FOR rcDiferimentoM300M700 IN cDiferimentoM300M700
            LOOP
               mVL_CONT_DIFER_ANT_PIS := mVL_CONT_DIFER_ANT_PIS + ROUND( ( rcDiferimentoM300M700.VL_CONT_APUR_DIFER * nPercpis ) / 100, 2 );
            END LOOP;
         END IF;
         --End If;
         IF ( rDadosEmpSped.cd_cod_inc_trib = '3' ) THEN
            mVL_TOTAL_RECEBIDO := NVL( mVL_TOTAL_RECEBIDO, 0 ) + NVL( nVlbasetribM210t, 0 );
         END IF;
         mVL_VPERIODO_PIS := ROUND( ( mVL_TOTAL_RECEBIDO * nPercPis ) / 100, 2 );
         mVL_TOTAL_RECEBIDO := ROUND( mVL_TOTAL_RECEBIDO, 2 );
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|M001';
         vlinha := vlinha || '|0';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'M001', vlinha );
         --
         -- REGISTRO M200: CONSOLIDAÇÃO DA CONTRIBUIÇÃO PARA O PIS/PASEP DO PERÍODO
         --
         vlinha := NULL;
         --
         nVlCumulatico := ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqPIS, 0 ) ) / 100;
         nVlNCumulatico := NVL( mVL_VPERIODO_PIS, 0 ) - NVL( mVL_DIFER_PIS, 0 ) + NVL( mVL_CONT_DIFER_ANT_PIS, 0 ) - NVL( nVL_RET_CUM_pis, 0 ) - NVL( nVL_OUT_DED_CUM_pis, 0 );
         --
         vlinha := vlinha || '|M200'; -- 1
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqPIS, 0 ) ) / 100, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 2
         vlinha := vlinha || '|0'; -- 3
         vlinha := vlinha || '|0'; -- 4
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqPIS, 0 ) ) / 100, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 5
         vlinha := vlinha || '|0'; -- 6
         vlinha := vlinha || '|0'; -- 7 -- 8 - PIS de tudo que foi recebido - pis total nao recebido no periodo + PIS recebidos de meses anteriores
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVlCumulatico, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 8
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( mVL_VPERIODO_PIS, 0 ) - NVL( mVL_DIFER_PIS, 0 ) + NVL( mVL_CONT_DIFER_ANT_PIS, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( nVL_RET_CUM_pis, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' ); -- 10
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( nVL_OUT_DED_CUM_pis, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' ); -- 11
         nVL_CONT_CUM_REC_200 := ABS( nVlNCumulatico );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_CONT_CUM_REC_200, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 12
         nVL_TOT_CONT_REC_200 := ABS( ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqPIS, 0 ) ) / 100 + NVL( mVL_VPERIODO_PIS, 0 ) - NVL( mVL_DIFER_PIS, 0 ) + NVL( mVL_CONT_DIFER_ANT_PIS, 0 ) - NVL( nVL_RET_CUM_pis, 0 ) - NVL( nVL_OUT_DED_CUM_pis, 0 ) );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ABS( nVL_TOT_CONT_REC_200 ), '9999999999999990.00' ), ' ' ), '.', ',' ); --  13
         vlinha := vlinha || '|'; -- 14
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'M200', vlinha );
         --
         -- REGISTRO M205: CONSOLIDAÇÃO DA CONTRIBUIÇÃO PARA O PIS/PASEP DO PERÍODO
         --
         nVL_DEBITO_205 := 0;
         IF nVlCumulatico <> 0
         OR nvl_cont_cum_rec_200 <> 0 THEN
            IF rDadosEmpSped.cd_COD_INC_TRIB IN (1, 3) THEN
               vlinha := NULL;
               vlinha := vlinha || '|M205'; -- 1
               vlinha := vlinha || '|08'; -- 2
               vlinha := vlinha || '|691201'; -- 3
               nVL_DEBITO_205 := ABS( nVlCumulatico );
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_DEBITO_205, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 4
               vlinha := vlinha || '|'; -- 5
               IF NVL( nVL_DEBITO_205, 0 ) > 0 THEN
                  nconta9999 := NVL( nconta9999, 0 ) + 1;
                  ncontam205 := NVL( ncontam205, 0 ) + 1;
                  fnc_insere_linha( 'M205', vlinha );
               END IF;
            END IF;
            IF rDadosEmpSped.cd_COD_INC_TRIB IN (2, 3) THEN
               vlinha := NULL;
               vlinha := vlinha || '|M205'; -- 1
               vlinha := vlinha || '|12'; -- 2
               vlinha := vlinha || '|810902'; -- 3
               --nVL_DEBITO_205 := ABS( nVlNCumulatico );
               nVL_DEBITO_205 := nVL_TOT_CONT_REC_200;
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_DEBITO_205, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 04
               vlinha := vlinha || '|'; -- 5
               -- IF NVL( nVL_DEBITO_205, 0 ) > 0 THEN
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               ncontam205 := NVL( ncontam205, 0 ) + 1;
               fnc_insere_linha( 'M205', vlinha );
            --END IF;
            END IF;
         END IF;
         --
         -- REGISTRO M210: DETALHAMENTO DA CONTRIBUIÇÃO PARA O PIS/PASEP DO PERÍODO
         --
         --
         IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'N' THEN
            --
            nVL_REC_BRT_210 := ABS( NVL( mVL_TOTAL_RECEBIDO, 0 ) );
            nVL_BC_CONT_210 := ABS( NVL( mVL_TOTAL_RECEBIDO, 0 ) );
            vlinha := NULL;
            --
            IF ( NVL( mVL_VPERIODO_PIS, 0 ) - NVL( mVL_DIFER_PIS, 0 ) + NVL( mVL_CONT_DIFER_ANT_PIS, 0 ) > 0 ) THEN
               vlinha := vlinha || '|M210';
               vlinha := vlinha || '|51';
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_REC_BRT_210, '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_BC_CONT_210, '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( nPercPis, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( mVL_VPERIODO_PIS, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( mVL_DIFER_PIS, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( mVL_CONT_DIFER_ANT_PIS, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := --anali
                        vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( mVL_VPERIODO_PIS, 0 ) - NVL( mVL_DIFER_PIS, 0 ) + NVL( mVL_CONT_DIFER_ANT_PIS, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|';
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               ncontam210 := NVL( ncontam210, 0 ) + 1;
               fnc_insere_linha( 'M210', vlinha );
            END IF;
            --   END IF;
            IF NVL( nVlbasetribm210NT, 0 ) > 0 THEN
               --
               vlinha := NULL;
               --
               nVL_REC_BRT_210 := ABS( NVL( nVl_Rec_Brt, 0 ) );
               nVL_BC_CONT_210 := ABS( NVL( nVlbasetribM210NT, 0 ) );
               vlinha := vlinha || '|M210';
               vlinha := vlinha || '|51';
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_REC_BRT_210, '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_BC_CONT_210, '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|';
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               ncontam210 := NVL( ncontam210, 0 ) + 1;
               fnc_insere_linha( 'M210', vlinha );
            END IF;
            --
            IF NVL( ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqPIS, 0 ) ) / 100 - NVL( mVL_DIFER_PIS, 0 ), 0 ) > 0 THEN
               --
               vlinha := NULL;
               --
               nVL_REC_BRT_210 := ABS( NVL( nRecNCumTribu0111, 0 ) );
               nVL_BC_CONT_210 := ABS( NVL( nRecNCumTribu0111, 0 ) );
               vlinha := vlinha || '|M210';
               vlinha := vlinha || '|01';
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_REC_BRT_210, '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_BC_CONT_210, '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( nAliqPIS, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ( nRecNCumTribu0111 * nAliqPIS ) / 100, '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|0';
               --vlinha := vlinha || '|';
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( mVL_DIFER_PIS, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|';
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqPIS, 0 ) ) / 100 - NVL( mVL_DIFER_PIS, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|';
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               ncontam210 := NVL( ncontam210, 0 ) + 1;
               fnc_insere_linha( 'M210', vlinha );
            END IF;
         END IF; --
         --
         --
         -- REGISTRO M230: INFORMAÇÕES ADICIONAIS DE DIFERIMENTO
         --
         IF ( vsndiferimento = '1' ) THEN
            IF ( rDadosEmpSped.cd_ind_reg_cum = '9'
             OR rDadosEmpSped.cd_ind_reg_cum IS NULL ) THEN
               FOR rcDiferimentoM230M630 IN cDiferimentoM230M630
               LOOP
                  --
                  nVL_CONT_DIF := ( rcDiferimentoM230M630.VL_NAO_RECEB * nPercPis ) / 100;
                  --
                  --
                  vlinha := NULL;
                  --
                  vlinha := vlinha || '|M230';
                  vlinha := vlinha || '|' || LPAD( REPLACE( REPLACE( REPLACE( REPLACE( rcDiferimentoM230M630.nr_cgc_cpf, '.', '' ), '-', '' ), '/', '' ), ' ', '' ), 14, '0' );
                  vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rcDiferimentoM230M630.VL_VEND, '9999999999999990.00' ), ' ' ), '.', ',' );
                  vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rcDiferimentoM230M630.VL_NAO_RECEB, '9999999999999990.00' ), ' ' ), '.', ',' );
                  vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_CONT_DIF, '9999999999999990.00' ), ' ' ), '.', ',' );
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  ncontaM230 := ncontam230 + 1;
                  nconta9999 := NVL( nconta9999, 0 ) + 1;
                  fnc_insere_linha( 'M230', vlinha );
               END LOOP;
            END IF;
            --
            -- REGISTRO M300: CONTRIBUIÇÃO DE PIS/PASEP DIFERIDA EM PERÍODOS ANTERIORES ¿ VALORES A PAGAR NO PERÍODO.
            --
            FOR rcDiferimentoM300M700 IN cDiferimentoM300M700
            LOOP
               --
               nVL_CONT_APUR_DIFER := ( rcDiferimentoM300M700.VL_CONT_APUR_DIFER * nPercpis ) / 100;
               nVL_CRED_DESC_DIFER := 0;
               nVL_CONT_DIFER_ANT := nVL_CONT_APUR_DIFER - nVL_CRED_DESC_DIFER;
               --
               vlinha := NULL;
               --
               vlinha := vlinha || '|M300'; -- 1
               vlinha := vlinha || '|51'; -- 2
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_CONT_APUR_DIFER, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 3
               vlinha := vlinha || '|'; -- 4
               vlinha := vlinha || '|'; -- 5
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_CONT_DIFER_ANT, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 6
               vlinha := vlinha || '|' || rcDiferimentoM300M700.PER_APUR; -- 7
               vlinha := vlinha || '|';
               vlinha := vlinha || '|'; -- 8
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               fnc_insere_linha( 'M300', vlinha );
               --
               ncontam300 := ncontam300 + 1;
            --
            END LOOP;
         END IF;
         --
         -- REGISTRO M400: RECEITAS ISENTAS, NÃO ALCANÇADAS PELA INCIDÊNCIA DA CONTRIBUIÇÃO, SUJEITAS A ALÍQUOTA ZERO OU DE VENDAS COM SUSPENSÃO ¿ PIS/PASEP
         --
         ncontaM400 := 0;
         ncontaM410 := 0;
         --
         IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'S' THEN
            --
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|M400';
            vlinha := vlinha || '|' || LPAD( vSPED_CST_PIS, 2, 0 );
            vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( param_nVLRECM410, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( 'M400', vlinha );
            --
            -- REGISTRO M410: DETALHAMENTO DAS RECEITAS ISENTAS, NÃO ALCANÇADAS PELA INCIDÊNCIA DA CONTRIBUIÇÃO, SUJEITAS A ALÍQUOTA ZERO OU DE VENDAS COM SUSPENSÃO ¿ PIS/PASEP
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|M410';
            vlinha := vlinha || '|201';
            vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( param_nVLRECM410, '9999999999999990.00' ), ' ' ), '.', ',' );
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( 'M410', vlinha );
            --
            ncontaM400 := 1;
            ncontaM410 := 1;
         ELSIF bEcrituraM410 THEN
            FOR rCTotalM400M800 IN CTotalM400M800
            LOOP
               --
               --
               vlinha := NULL;
               --
               vlinha := vlinha || '|M400';
               vlinha := vlinha || '|' || rCTotalM400M800.CST_PIS;
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rCTotalM400M800.vl_total_M400M800, '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               fnc_insere_linha( 'M400', vlinha );
               --
               FOR rCTotalM410M810 IN CTotalM410M810( LPAD( rCTotalM400M800.CST_PIS, 2, 0 ) )
               LOOP
                  --
                  -- REGISTRO M410: DETALHAMENTO DAS RECEITAS ISENTAS, NÃO ALCANÇADAS PELA INCIDÊNCIA DA CONTRIBUIÇÃO, SUJEITAS A ALÍQUOTA ZERO OU DE VENDAS COM SUSPENSÃO ¿ PIS/PASEP
                  --
                  vlinha := NULL;
                  --
                  vlinha := vlinha || '|M410';
                  vlinha := vlinha || '|' || NVL( rCTotalM410M810.NAT_REC_PIS, '999' );
                  vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rCTotalM410M810.vl_total_M410M810, '9999999999999990.00' ), ' ' ), '.', ',' );
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  nconta9999 := NVL( nconta9999, 0 ) + 1;
                  fnc_insere_linha( 'M410', vlinha );
                  --
                  ncontaM410 := ncontaM410 + 1;
               END LOOP;
               --
               ncontaM400 := ncontaM400 + 1;
            END LOOP;
         END IF;
         --
         vlinha := NULL;
         --
         --nVL_RET_CUM_Cofins := 0; -- TESTE RAUSE
         mVL_DIFER_COFINS := 0;
         IF ( rDadosEmpSped.cd_ind_reg_cum = '9'
          OR rDadosEmpSped.cd_ind_reg_cum IS NULL ) THEN
            FOR rcDiferimentoM230M630 IN cDiferimentoM230M630
            LOOP
               mVL_DIFER_COFINS := mVL_DIFER_COFINS + ROUND( ( rcDiferimentoM230M630.VL_NAO_RECEB * nPercCofins ) / 100, 2 );
            END LOOP;
         END IF;
         mVL_CONT_DIFER_ANT_COFINS := 0;
         IF ( vsndiferimento = '1' ) THEN
            FOR rcDiferimentoM300M700 IN cDiferimentoM300M700
            LOOP
               mVL_CONT_DIFER_ANT_COFINS := mVL_CONT_DIFER_ANT_COFINS + ROUND( ( rcDiferimentoM300M700.VL_CONT_APUR_DIFER * nPercCofins ) / 100, 2 );
            END LOOP;
         END IF;
         mVL_VPERIODO_COFINS := ROUND( ( mVL_TOTAL_RECEBIDO * nPercCofins ) / 100, 2 );
         --
         nVlCumulatico := ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqCofins, 0 ) ) / 100;
         nVlNCumulatico := ( NVL( mVL_TOTAL_RECEBIDO, 0 ) * NVL( nPercCofins, 0 ) ) / 100 - NVL( mVL_DIFER_COFINS, 0 ) + NVL( mVL_CONT_DIFER_ANT_COFINS, 0 ) - NVL( nVL_RET_CUM_Cofins, 0 ) - NVL( nVL_OUT_DED_CUM_Cofins, 0 );
         vlinha := vlinha || '|M600';
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqCofins, 0 ) ) / 100, '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|0';
         vlinha := vlinha || '|0';
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqCofins, 0 ) ) / 100, '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|0';
         vlinha := vlinha || '|0';
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVlCumulatico, '9999999999999990.00' ), ' ' ), '.', ',' );
         nvl_cont_cum_rec_600 := ABS( nVlNCumulatico );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ( NVL( mVL_TOTAL_RECEBIDO, 0 ) * NVL( nPercCofins, 0 ) ) / 100 - NVL( mVL_DIFER_COFINS, 0 ) + NVL( mVL_CONT_DIFER_ANT_COFINS, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( nVL_RET_CUM_Cofins, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( nVL_OUT_DED_CUM_Cofins, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ABS( nVlNCumulatico ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha :=
            vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ABS( ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqCofins, 0 ) ) / 100 + ( NVL( mVL_TOTAL_RECEBIDO, 0 ) * NVL( nPercCofins, 0 ) ) / 100 - NVL( mVL_DIFER_COFINS, 0 ) + NVL( mVL_CONT_DIFER_ANT_COFINS, 0 )
            - NVL( nVL_RET_CUM_Cofins, 0 ) - NVL( nVL_OUT_DED_CUM_Cofins, 0 ) ), '9999999999999990.00' ), ' ' ), '.', ',' );
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'M600', vlinha );
         --sps
         --
         -- REGISTRO M610: DETALHAMENTO DA CONTRIBUIÇÃO PARA O COFINS DO PERÍODO
         --
         --
         IF nVlCumulatico <> 0
         OR nvl_cont_cum_rec_600 <> 0 THEN
            IF rDadosEmpSped.cd_COD_INC_TRIB IN (1, 3) THEN
               vlinha := NULL;
               vlinha := vlinha || '|M605'; -- 1
               vlinha := vlinha || '|08'; -- 2
               vlinha := vlinha || '|585601'; -- 3
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ABS( nVlCumulatico ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|'; -- 5
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               ncontam605 := NVL( ncontam605, 0 ) + 1;
               fnc_insere_linha( 'M605', vlinha );
            END IF;
            IF rDadosEmpSped.cd_COD_INC_TRIB IN (2, 3) THEN
               vlinha := NULL;
               vlinha := vlinha || '|M605'; -- 1
               vlinha := vlinha || '|12'; -- 2
               vlinha := vlinha || '|217201'; -- 3
              -- vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ABS( nVlNCumulatico ), '9999999999999990.00' ), ' ' ), '.', ',' );
              vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ABS( ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqCofins, 0 ) ) / 100 + ( NVL( mVL_TOTAL_RECEBIDO, 0 ) * NVL( nPercCofins, 0 ) ) / 100 - NVL( mVL_DIFER_COFINS, 0 ) + NVL( mVL_CONT_DIFER_ANT_COFINS, 0 )- NVL( nVL_RET_CUM_Cofins, 0 ) - NVL( nVL_OUT_DED_CUM_Cofins, 0 ) ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|'; -- 5
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               ncontam605 := NVL( ncontam605, 0 ) + 1;
               fnc_insere_linha( 'M605', vlinha );
            END IF;
         END IF;
         --sps
         --
         -- REGISTRO M610: DETALHAMENTO DA CONTRIBUIÇÃO PARA O COFINS DO PERÍODO
         --
         --
         IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'N' THEN
            --
            --IF NVL( nVlbasetribm210NT, 0 ) > 0 THEN
            vlinha := NULL;
            --
            vlinha := vlinha || '|M610';
            vlinha := vlinha || '|51';
            vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( mVL_TOTAL_RECEBIDO, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
            vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( mVL_TOTAL_RECEBIDO, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
            vlinha := vlinha || '|' || NVL( nPercCofins, '0' );
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ( NVL( mVL_TOTAL_RECEBIDO, 0 ) * NVL( nPercCofins, 0 ) ) / 100, '9999999999999990.00' ), ' ' ), '.', ',' );
            vlinha := vlinha || '|0';
            vlinha := vlinha || '|0';
            vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( mVL_DIFER_COFINS, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
            vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( mVL_CONT_DIFER_ANT_COFINS, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
            vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ( NVL( mVL_TOTAL_RECEBIDO, 0 ) * NVL( nPercCofins, 0 ) ) / 100 - NVL( mVL_DIFER_COFINS, 0 ) + NVL( mVL_CONT_DIFER_ANT_COFINS, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            ncontam610 := NVL( ncontam610, 0 ) + 1;
            fnc_insere_linha( 'M610', vlinha );
            -- END IF;
            --
            IF NVL( nVlbasetribm210NT, 0 ) > 0 THEN
               --
               vlinha := NULL;
               --
               vlinha := vlinha || '|M610';
               vlinha := vlinha || '|51';
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( nVl_Rec_Brt, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( nVlbasetribM210NT, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|' || NVL( nPercCofins, '0' );
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|';
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               ncontam610 := NVL( ncontam610, 0 ) + 1;
               fnc_insere_linha( 'M610', vlinha );
            END IF;
            --
            IF NVL( nRecNCumTribu0111, 0 ) > 0 THEN
               --
               vlinha := NULL;
               --
               vlinha := vlinha || '|M610';
               vlinha := vlinha || '|01';
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( nRecNCumTribu0111, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( nRecNCumTribu0111, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( NVL( nAliqCofins, 0 ), '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqCofins, 0 ) ) / 100, '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|0';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( ( NVL( nRecNCumTribu0111, 0 ) * NVL( nAliqCofins, 0 ) ) / 100, '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|';
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               ncontam610 := NVL( ncontam610, 0 ) + 1;
               fnc_insere_linha( 'M610', vlinha );
            END IF;
         END IF; --         if nvl(dbamv.pkg_mv2000.le_configuracao('FFCV','SN_IMUNE_IRPJ'),'N') = 'N' then
         ncontaM800 := 0;
         ncontaM810 := 0;
         --
         --
         -- REGISTRO M630: INFORMAÇÕES ADICIONAIS DE DIFERIMENTO
         --
         --
         IF ( vsndiferimento = '1' ) THEN
            IF ( rDadosEmpSped.cd_ind_reg_cum = '9'
             OR rDadosEmpSped.cd_ind_reg_cum IS NULL ) THEN
               FOR rcDiferimentoM230M630 IN cDiferimentoM230M630
               LOOP
                  --
                  nVL_CONT_DIF := ( rcDiferimentoM230M630.VL_NAO_RECEB * nPercCofins ) / 100;
                  --
                  --
                  vlinha := NULL;
                  --
                  vlinha := vlinha || '|M630';
                  vlinha := vlinha || '|' || LPAD( REPLACE( REPLACE( REPLACE( REPLACE( rcDiferimentoM230M630.nr_cgc_cpf, '.', '' ), '-', '' ), '/', '' ), ' ', '' ), 14, '0' );
                  vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rcDiferimentoM230M630.VL_VEND, '9999999999999990.00' ), ' ' ), '.', ',' );
                  vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rcDiferimentoM230M630.VL_NAO_RECEB, '9999999999999990.00' ), ' ' ), '.', ',' );
                  vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_CONT_DIF, '9999999999999990.00' ), ' ' ), '.', ',' );
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  ncontaM630 := ncontam630 + 1;
                  nconta9999 := NVL( nconta9999, 0 ) + 1;
                  fnc_insere_linha( 'M630', vlinha );
               END LOOP;
            END IF;
            --
            --
            -- REGISTRO M700: CONTRIBUIÇÃO DE COFINS DIFERIDA EM PERÍODOS ANTERIORES ¿ VALORES A PAGAR NO PERÍODO.
            --
            nVL_CONT_APUR_DIFER := 0;
            nVL_CONT_DIFER_ANT := 0;
            FOR rcDiferimentoM300M700 IN cDiferimentoM300M700
            LOOP
               --
               nVL_CONT_APUR_DIFER := ( rcDiferimentoM300M700.VL_CONT_APUR_DIFER * nPercCofins ) / 100;
               nVL_CRED_DESC_DIFER := 0;
               nVL_CONT_DIFER_ANT := nVL_CONT_APUR_DIFER - nVL_CRED_DESC_DIFER;
               --
               vlinha := NULL;
               --
               vlinha := vlinha || '|M700'; -- 1
               vlinha := vlinha || '|51'; -- 2
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_CONT_APUR_DIFER, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 3
               vlinha := vlinha || '|'; -- 4
               vlinha := vlinha || '|'; -- 5
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( nVL_CONT_DIFER_ANT, '9999999999999990.00' ), ' ' ), '.', ',' ); -- 6
               vlinha := vlinha || '|' || rcDiferimentoM300M700.PER_APUR; -- 7
               vlinha := vlinha || '|';
               vlinha := vlinha || '|'; -- 8
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               fnc_insere_linha( 'M700', vlinha );
               --
               ncontam700 := ncontam700 + 1;
            --
            END LOOP;
         END IF;
         --
         IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'S' THEN
            --
            --REGISTRO M800: RECEITAS ISENTAS, NÃO ALCANÇADAS PELA INCIDÊNCIA DA CONTRIBUIÇÃO, SUJEITAS A ALÍQUOTA ZERO OU DE VENDAS COM SUSPENSÃO ¿ COFINS
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|M800';
            vlinha := vlinha || '|' || LPAD( vSPED_CST_Cofins, 2, 0 );
            vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( param_nVLRECM410, '9999999999999990.00' ), ' ' ), '.', ',' );
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( 'M800', vlinha );
            --
            --REGISTRO M810: DETALHAMENTO DAS RECEITAS ISENTAS, NÃO ALCANÇADAS PELA INCIDÊNCIA DA CONTRIBUIÇÃO, SUJEITAS A ALÍQUOTA ZERO OU DE VENDAS COM SUSPENSÃO ¿ COFINS
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|M810';
            vlinha := vlinha || '|201';
            vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( param_nVLRECM410, '9999999999999990.00' ), ' ' ), '.', ',' );
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( 'M810', vlinha );
            --
            ncontaM800 := ncontaM800 + 1;
            ncontaM810 := ncontaM810 + 1;
         --
         ELSIF bEcrituraM410 THEN
            FOR rCTotalM400M800 IN CTotalM400M800
            LOOP
               --
               --
               vlinha := NULL;
               --
               vlinha := vlinha || '|M800';
               vlinha := vlinha || '|' || rCTotalM400M800.CST_COFINS;
               vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rCTotalM400M800.vl_total_M400M800, '9999999999999990.00' ), ' ' ), '.', ',' );
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               vlinha := vlinha || '|';
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               fnc_insere_linha( 'M800', vlinha );
               --
               FOR rCTotalM410M810 IN CTotalM410M810( LPAD( rCTotalM400M800.CST_cofins, 2, 0 ) )
               LOOP
                  --
                  -- REGISTRO M810: DETALHAMENTO DAS RECEITAS ISENTAS, NÃO ALCANÇADAS PELA INCIDÊNCIA DA CONTRIBUIÇÃO, SUJEITAS A ALÍQUOTA ZERO OU DE VENDAS COM SUSPENSÃO ¿ COFINS
                  --
                  vlinha := NULL;
                  --
                  vlinha := vlinha || '|M810';
                  vlinha := vlinha || '|' || NVL( rCTotalM410M810.NAT_REC_COFINS, '999' );
                  vlinha := vlinha || '|' || REPLACE( REPLACE( TO_CHAR( rCTotalM410M810.vl_total_M410M810, '9999999999999990.00' ), ' ' ), '.', ',' );
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  vlinha := vlinha || '|';
                  nconta9999 := NVL( nconta9999, 0 ) + 1;
                  fnc_insere_linha( 'M810', vlinha );
                  --
                  ncontaM810 := ncontaM810 + 1;
               END LOOP;
               --
               ncontaM800 := ncontaM800 + 1;
            END LOOP;
         END IF;
         --
         -- ENCERRAMENTO DO BLOCO M
         --
         vlinha := NULL;
         --
         ncontaM990 :=
            NVL( ncontaM400, 0 ) +
            NVL( ncontaM410, 0 ) +
            NVL( ncontaM800, 0 ) +
            NVL( ncontaM810, 0 ) +
            NVL( ncontaM205, 0 ) +
            NVL( ncontaM210, 0 ) +
            NVL( ncontam230, 0 ) +
            NVL( ncontam300, 0 ) +
            NVL( ncontaM605, 0 ) +
            NVL( ncontaM610, 0 ) +
            NVL( ncontam630, 0 ) +
            NVL( ncontam700, 0 ) + 4;
         vlinha := vlinha || '|M990';
         vlinha := vlinha || '|' || NVL( ncontaM990, 0 );
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'M990', vlinha );
      --
      ELSE
         --
         -- REGISTRO M001: ABERTURA DO BLOCO M
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|M001';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'M001', vlinha );
         -- ENCERRAMENTO DO BLOCO M
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|M990';
         vlinha := vlinha || '|2';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( 'M990', vlinha );
      --
      END IF;
   END PRC7_REGIME_COMP_DET_BLOCOM;
   /****************************************************************/
   /*******************************************************/
   PROCEDURE PRC8_CONTR_PREV_RECBRU_BLOCOP( dCopetencia DATE ) IS
   BEGIN
      /*****************************-- REGISTRO P001: ABERTURA DO BLOCO P ******************************/
      /***********BLOCO_P - Apuração da Contribuição Previdenciária sobre a Receita Bruta  *************/
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|P001';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( 'P001', vlinha );
      -- ENCERRAMENTO DO BLOCO P
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|P990';
      vlinha := vlinha || '|2';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( 'P990', vlinha );
   END PRC8_CONTR_PREV_RECBRU_BLOCOP;
   /********************************************************************************/
   /**********************************************************************************/
   /********************************************************************************/
   /*
      1
      Complemento da Escrituração ¿ Controle de Saldos de Créditos e de Retenções,
      Operações Extemporâneas e Outras Informações
      */
   PROCEDURE PRC9_SALDO_CRED_RET_BLOCO1( dCopetencia DATE ) IS
      CURSOR c1900( dCopetencia DATE ) IS
           SELECT me.cd_cgc
                 ,'00' status
                 ,n.cd_serie
                 ,SUM( n.vl_total_nota ) vl_total_nota
                 ,COUNT( * ) QTD
             FROM dbamv.nota_fiscal n
                 ,dbamv.multi_empresas me
            WHERE TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND ( NVL( n.cd_status, 'E' ) = 'E'
                OR ( n.cd_status = 'C'
                AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) <> TO_CHAR( dCopetencia, 'MM/YYYY' )
                AND n.dt_cancelamento < dtCancIni ) )
              AND ( me.CD_MULTI_EMPRESA = dbamv.pkg_mv2000.le_empresa
                OR me.CD_MULTI_EMPRESA_CONSOL = dbamv.pkg_mv2000.le_empresa )
              AND NVL( n.vl_total_nota, 0 ) > 0
              AND n.cd_multi_empresa = me.cd_multi_empresa
              AND rDadosEmpSped.cd_ind_reg_cum = '1'
         GROUP BY me.cd_cgc
                 ,'00'
                 ,n.cd_serie
         UNION ALL
           SELECT me.cd_cgc
                 ,'02' status
                 ,n.cd_serie
                 ,SUM( n.vl_total_nota ) vl_total_nota
                 ,COUNT( * ) QTD
             FROM dbamv.nota_fiscal n
                 ,dbamv.multi_empresas me
            WHERE TO_CHAR( n.dt_emissao, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND ( me.CD_MULTI_EMPRESA = dbamv.pkg_mv2000.le_empresa
                OR me.CD_MULTI_EMPRESA_CONSOL = dbamv.pkg_mv2000.le_empresa )
              AND n.cd_status = 'C'
              AND TO_CHAR( n.dt_cancelamento, 'MM/YYYY' ) = TO_CHAR( dCopetencia, 'MM/YYYY' )
              AND NVL( n.vl_total_nota, 0 ) > 0
              AND n.cd_multi_empresa = me.cd_multi_empresa
              AND rDadosEmpSped.cd_ind_reg_cum = '1'
         GROUP BY me.cd_cgc
                 ,'02'
                 ,n.cd_serie
                 ,NULL
         ORDER BY Cd_CGC;
      rc1900         c1900%ROWTYPE;
   BEGIN
      --
      -- PDA 534996 - Fim
      /************  BLOCO 1: COMPLEMENTO DA ESCRITURAÇÃO ¿ CONTROLE DE SALDOS DE CRÉDITOS E DE RETENÇÕES, OPERAÇÕES EXTEMPORÂNEAS E OUTRAS INFORMAÇÕES **********************/
      --
      IF vRegistroA111 IS NOT NULL THEN
         --
         -- REGISTRO 1001: ABERTURA DO BLOCO 1
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|1001';
         vlinha := vlinha || '|0';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '1001', vlinha );
         --
         -- REGISTRO 1010: PROCESSO REFERENCIADO ¿ AÇÃO JUDICIAL
         --
         vlinha := NULL;
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         IF vRegistro1010 IS NOT NULL THEN
            fnc_insere_linha( '1010', vRegistro1010 );
         ELSE
            fnc_insere_linha( '1020', vRegistro1020 );
         END IF;
--        if dbamv.pkg_mv2000.le_cliente = 284 THEN
          IF (nVL_RET_CUM_pis <> 0) THEN
           vcompetencia := TO_CHAR( dCopetencia, 'mmyyyy' );
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|1300';
            vlinha := vlinha || '|01';
            vlinha := vlinha || '|' || vcompetencia || '|';
            vlinha := vlinha || '|' || nVL_RET_CUM_pis || '|';
            vlinha := vlinha || '|' || nVL_RET_CUM_pis || '|';
            vlinha := vlinha || '|0';
            vlinha := vlinha || '|0';
            vlinha := vlinha || '|0|';
            nConta1900 := NVL( nConta1900, 0 ) + 1;
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( '1300', vlinha );
          END IF;
          IF (nVL_RET_CUM_Cofins <> 0) THEN
           vcompetencia := TO_CHAR( dCopetencia, 'mmyyyy' );
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|1700';
            vlinha := vlinha || '|01';
            vlinha := vlinha || '|' || vcompetencia || '|';
            vlinha := vlinha || '|' || nVL_RET_CUM_Cofins || '|';
            vlinha := vlinha || '|' || nVL_RET_CUM_Cofins || '|';
            vlinha := vlinha || '|0';
            vlinha := vlinha || '|0';
            vlinha := vlinha || '|0|';
            nConta1900 := NVL( nConta1900, 0 ) + 1;
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( '1700', vlinha );
          END IF;
 --       END IF;
         --
         -- ENCERRAMENTO DO BLOCO 1
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|1990';
         vlinha := vlinha || '|' ||nConta1900+2 ;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '1990', vlinha );
      --
      ELSE
         --
         -- REGISTRO 1001: ABERTURA DO BLOCO 1
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|1001';
--         IF rDadosEmpSped.cd_ind_reg_cum = '9'
--         OR rDadosEmpSped.cd_ind_reg_cum IS NULL THEN
         IF (nVL_RET_CUM_pis <> 0 ) OR (nVL_RET_CUM_Cofins <> 0) then
            vlinha := vlinha || '|0';
         ELSE
            vlinha := vlinha || '|1';
         END IF;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '1001', vlinha );
         -- ENCERRAMENTO DO BLOCO 1
         --
         --Registro 1900:
         FOR rc1900 IN c1900( dCopetencia )
         LOOP
            vVlNota := REPLACE( REPLACE( TO_CHAR( rc1900.vl_total_nota, '9999999999999990.00' ), ' ' ), '.', ',' );
            vSPED_CST_PIS := SUBSTR( rDadosEmpSped.cd_CST_PIS, 0, 2 );
            vSPED_CST_COFINS := SUBSTR( rDadosEmpSped.cd_CST_COFINS, 0, 2 );
            vlinha := NULL;
            vlinha := vlinha || '|1900'; -- 01
            vlinha := vlinha || '|' || LPAD( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( rc1900.Cd_CGC, '-', '' ), '.', '' ), '/', '' ), '\', '' ), ' ', '' ), 14, '0' ); -- 02
            vlinha := vlinha || '|98'; -- 03
            vlinha := vlinha || '|' || rc1900.cd_serie; -- 04
            vlinha := vlinha || '|';
            vlinha := vlinha || '|' || rc1900.status; -- 05
            vlinha := vlinha || '|' || vVlNota; -- 06
            vlinha := vlinha || '|' || rc1900.QTD; -- 07
            vlinha := vlinha || '|' || LPAD( vSPED_CST_PIS, 2, '0' ); -- 08
            vlinha := vlinha || '|' || LPAD( vSPED_CST_COFINS, 2, '0' ); -- 09 CST_PIS
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( '1900', vlinha );
            nConta1900 := NVL( nConta1900, 0 ) + 1;
         END LOOP;
--        if dbamv.pkg_mv2000.le_cliente = 284 THEN
          IF (nVL_RET_CUM_pis <> 0) THEN
           vcompetencia := TO_CHAR( dCopetencia, 'mmyyyy' );
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|1300';
            vlinha := vlinha || '|01';
            vlinha := vlinha || '|' || vcompetencia;
            vlinha := vlinha || '|' || nVL_RET_CUM_pis;
            vlinha := vlinha || '|' || nVL_RET_CUM_pis;
            vlinha := vlinha || '|0';
            vlinha := vlinha || '|0';
            vlinha := vlinha || '|0|';
            nConta1900 := NVL( nConta1900, 0 ) + 1;
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( '1300', vlinha );
          END IF;
          IF (nVL_RET_CUM_Cofins <> 0) THEN
           vcompetencia := TO_CHAR( dCopetencia, 'mmyyyy' );
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|1700';
            vlinha := vlinha || '|01';
            vlinha := vlinha || '|' || vcompetencia ;
            vlinha := vlinha || '|' || nVL_RET_CUM_Cofins;
            vlinha := vlinha || '|' || nVL_RET_CUM_Cofins;
            vlinha := vlinha || '|0';
            vlinha := vlinha || '|0';
            vlinha := vlinha || '|0|';
            nConta1900 := NVL( nConta1900, 0 ) + 1;
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( '1700', vlinha );
          END IF;
        --END IF;
         vlinha := NULL;
         --
         vlinha := vlinha || '|1990';
         vlinha := vlinha || '|' || TO_CHAR( nConta1900 + 2 );
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '1990', vlinha );
      --
      END IF;
   END PRC9_SALDO_CRED_RET_BLOCO1;
   /****/
   /****************************************************************/
   PROCEDURE PRC99_FECHAMENTO( dCopetencia DATE ) IS
   BEGIN
      -- REGISTRO 1001: ABERTURA DO BLOCO 1
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9001';
      vlinha := vlinha || '|0';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9001', vlinha );
      -- REGISTRO 9900: REGISTROS DO ARQUIVO
      conta9900 := 0;
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|0000';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|0001';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|0100';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|0110';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      IF ContaBlc0111 > 0 THEN
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|0111';
         vlinha := vlinha || '|' || ContaBlc0111;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
      END IF;
      --
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|0140';
      vlinha := vlinha || '|' || nconta0140; -- PDA 572267
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      IF NVL( nRecBruCumu, 0 ) > 0 THEN
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|0150';
         vlinha := vlinha || '|' || ContaBlc0150;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
      END IF;
      --
      IF NVL( nRecBruCumu, 0 ) > 0 THEN
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|0200';
         vlinha := vlinha || '|' || ContaBlc0200;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
      END IF;
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|0500';
      vlinha := vlinha || '|' || ContaBlc0500;
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|0990';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      IF NVL( nRecBruCumu, 0 ) = 0
      OR dbamv.pkg_mv2000.le_cliente = 267 THEN
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|A001';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|A990';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
      --
      ELSE
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|A001';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|A010';
         vlinha := vlinha || '|' || ncontaA010; -- PDA 572267
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|A100';
         vlinha := vlinha || '|' || contaBlcA100;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|A111';
         vlinha := vlinha || '|' || contaBlcA111;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|A170';
         vlinha := vlinha || '|' || contaBlctotA170;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|A990';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
      --
      END IF;
      IF (nVL_RET_CUM_pis <> 0 ) OR (nVL_RET_CUM_Cofins <> 0) THEN
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|1300';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|1700';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
      END IF;
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|C001';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|C990';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|D001';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|D990';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      --
      IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'S'
      OR NVL( nRecBruCumu, 0 ) = 0 THEN
         --
         nContaConfigF100 := 0;
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|F001';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|F990';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
      --
      --
      ELSE
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|F001';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|F010';
         vlinha := vlinha || '|' || contaBlcF010;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|F100';
         vlinha := vlinha || '|' || nContaConfigF100;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         IF nContaConfigF500 > 0 THEN
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|9900';
            vlinha := vlinha || '|F500';
            vlinha := vlinha || '|' || nContaConfigF500;
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( '9900', vlinha );
            conta9900 := conta9900 + 1;
         --
         END IF;
         IF nContaConfigF525 > 0 THEN
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|9900';
            vlinha := vlinha || '|F525';
            vlinha := vlinha || '|' || nContaConfigF525;
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( '9900', vlinha );
            conta9900 := conta9900 + 1;
         --
         END IF;
         IF nContaf600 > 0 THEN
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|9900';
            vlinha := vlinha || '|F600';
            vlinha := vlinha || '|' || nContaf600;
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( '9900', vlinha );
            conta9900 := conta9900 + 1;
         --
         END IF;
         --
         IF nContaf700 > 0 THEN
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|9900';
            vlinha := vlinha || '|F700';
            vlinha := vlinha || '|' || nContaf700;
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( '9900', vlinha );
            conta9900 := conta9900 + 1;
         --
         END IF;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|F990';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
      --
      --
      END IF;
      IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'N'
      OR NVL( nRecBruCumu, 0 ) > 0 THEN
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M001';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M200';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M205';
         vlinha := vlinha || '|' || NVL( ncontam205, 0 ); -- PDA 541546 - incluido nvl
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'N' THEN
            --
            IF NVL( ncontam210, 0 ) > 0 THEN
               vlinha := NULL;
               --
               vlinha := vlinha || '|9900';
               vlinha := vlinha || '|M210';
               vlinha := vlinha || '|' || NVL( ncontam210, 0 ); -- PDA 541546 - incluido nvl
               vlinha := vlinha || '|';
               nconta9999 := NVL( nconta9999, 0 ) + 1;
               fnc_insere_linha( '9900', vlinha );
               conta9900 := conta9900 + 1;
            END IF;
         END IF;
         --
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M230';
         vlinha := vlinha || '|' || NVL( ncontam230, 0 );
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M300';
         vlinha := vlinha || '|' || ncontam300;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M400';
         vlinha := vlinha || '|' || ncontaM400;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M410';
         vlinha := vlinha || '|' || ncontaM410;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M600';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M605';
         vlinha := vlinha || '|' || NVL( ncontam605, 0 ); -- PDA 541546 - incluido nvl
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         IF NVL( dbamv.pkg_mv2000.le_configuracao( 'FFCV', 'SN_IMUNE_IRPJ' ), 'N' ) = 'N' THEN
            --
            vlinha := NULL;
            --
            vlinha := vlinha || '|9900';
            vlinha := vlinha || '|M610';
            vlinha := vlinha || '|' || NVL( ncontam610, 0 ); -- PDA 541546 - incluido nvl
            vlinha := vlinha || '|';
            nconta9999 := NVL( nconta9999, 0 ) + 1;
            fnc_insere_linha( '9900', vlinha );
            conta9900 := conta9900 + 1;
         --
         END IF;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M630';
         vlinha := vlinha || '|' || ncontam630;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M700';
         vlinha := vlinha || '|' || ncontam700;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M800';
         vlinha := vlinha || '|' || ncontaM800;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M810';
         vlinha := vlinha || '|' || ncontaM810;
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M990';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         ncontaRegistroM := 3;
      ELSE
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M001';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         vlinha := vlinha || '|M990';
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
         --
         ncontaRegistroM := 0;
      END IF;
      --
      -- PDA 534996 - Início
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|P001';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|P990';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      -- PDA 534996 -- Fim
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|1001';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      IF vRegistroA111 IS NOT NULL THEN
         --
         --
         vlinha := NULL;
         --
         vlinha := vlinha || '|9900';
         IF vRegistro1010 IS NOT NULL THEN
            vlinha := vlinha || '|1010';
         ELSE
            vlinha := vlinha || '|1020';
         END IF;
         vlinha := vlinha || '|1';
         vlinha := vlinha || '|';
         nconta9999 := NVL( nconta9999, 0 ) + 1;
         fnc_insere_linha( '9900', vlinha );
         conta9900 := conta9900 + 1;
      --
      END IF;
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|1900';
      vlinha := vlinha || '|' || nConta1900;
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|1990';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      --
      vlinha := NULL;
      --
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|9001';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      conta9900 := conta9900 + 1;
      --
      --
      vlinha := NULL;
      --
      conta9900 := conta9900 + 3;
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|' || conta9900;
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      --
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|9990';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      --
      --
      vlinha := NULL;
      --
      vlinha := vlinha || '|9900';
      vlinha := vlinha || '|9999';
      vlinha := vlinha || '|1';
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 1;
      fnc_insere_linha( '9900', vlinha );
      --
      --
      vlinha := NULL;
      --
      conta9990 := conta9900 + 3;
      vlinha := vlinha || '|9990';
      vlinha := vlinha || '|' || conta9990;
      vlinha := vlinha || '|';
      nconta9999 := NVL( nconta9999, 0 ) + 2;
      fnc_insere_linha( '9990', vlinha );
      --
      contatotalArq := nconta9999; -- nvl(ContaBlc0,0) + nvl(ContaBlcATot,0) + nvl(nContaConfigF100,0)+ nvl(nContaf600,0) + nvl(nContaf700,0) +  nvl(conta9990,0) + nvl(ncontaM990,0) + 9  ; /*Somando 43 , devido a quantidade de registros fixos no arquivo */
      --MLSLABEL
      vlinha := NULL;
      --
      vlinha := vlinha || '|9999';
      vlinha := vlinha || '|' || contatotalArq;
      vlinha := vlinha || '|';
      fnc_insere_linha( '9999', vlinha );
   END PRC99_FECHAMENTO;
   /***************************************************/
   FUNCTION fnc_charnum( vtexto IN VARCHAR2 )
      RETURN NUMBER IS
      naux           NUMBER;
   BEGIN
      naux := TO_NUMBER( TRIM( vTexto ), '9999999999999999999D99', 'nls_numeric_characters = '',.''' );
      RETURN NVL( naux, 0 );
   END;
/****/
END PKG_FCCT_GERA_SPED_PIS_COFINS;
/
