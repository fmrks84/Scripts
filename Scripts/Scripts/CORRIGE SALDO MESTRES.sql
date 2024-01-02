--<DS_SCRIPT>
-- DESCRIÇÃO..: CORRIGE O SALDO DOS PRODUTOS MESTRES ATUALIZADO
-- RESPONSAVEL: Gyzelle Monteiro
-- DATA.......: 10/04/2007
-- APLICAÇÃO..: MGES - GERENCIAMENTO DE ESTOQUE
--</DS_SCRIPT>
--<USUARIO=DBAMV>

Alter Trigger dbamv.Trg_lot_Pro disable
/
declare
    -- Cursor para trazer a sequence da tabela Lot_Pro
    cursor cSeqLotPro is
        select dbamv.seq_lot_pro.nextval
          from dual;

    -- Cursor que irá trazer os lotes que devem conter no produto mestre. Que são todos os lotes dos filhos
    cursor cLotProNaoMestre is
      select produto.cd_produto_tem
         , lot_pro.cd_estoque
         , lot_pro.dt_validade
         , lot_pro.cd_lote
         , sum(lot_pro.qt_estoque_atual)      qt_estoque_atual
         , sum(lot_pro.qt_estoque_doado)      qt_estoque_doado
         , sum(lot_pro.qt_orcamentario)       qt_orcamentario
         , sum(lot_pro.qt_extra_orcamentario) qt_extra_orcamentario
         , sum(lot_pro.qt_kit) qt_kit
      from dbamv.lot_pro
         , dbamv.produto
         , dbamv.produto produto_mestre
         , dbamv.empresa_produto
     where lot_pro.cd_produto = produto.cd_produto
       and produto.sn_mestre = 'N'
       and produto.cd_produto_tem is not null
       and produto.cd_produto_tem = produto_mestre.cd_produto
       and produto.cd_produto = empresa_produto.cd_produto
       and empresa_produto.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
       and produto_mestre.sn_mestre = 'S'
--       and produto_mestre.cd_produto in (53790)
  group by produto.cd_produto_tem
         , lot_pro.cd_estoque
         , lot_pro.dt_validade
         , lot_pro.cd_lote
  order by produto.cd_produto_tem;

    -- Cursor que irá trazer o saldo que devem conter no produto mestre. Que é a soma do saldo dos filhos
    cursor cEstProMestre is
        select produto.cd_produto_tem
              ,est_pro.cd_estoque
              ,sum(est_pro.qt_estoque_atual)         qt_estoque_atual
              ,sum(est_pro.qt_estoque_doado)         qt_estoque_doado
              ,sum(est_pro.qt_solicitacao_de_compra) qt_solicitacao_de_compra
              ,sum(est_pro.qt_ordem_de_compra )      qt_ordem_de_compra
              ,sum(est_pro.qt_estoque_reservado)     qt_estoque_reservado
         from dbamv.produto
             ,dbamv.est_pro
             ,dbamv.estoque
        where produto.cd_produto       = est_pro.cd_produto
          and est_pro.cd_estoque       = estoque.cd_estoque
          and estoque.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
          and produto.sn_mestre        = 'N'
          and produto.cd_produto_tem is not null
 --         and produto.cd_produto not in ( 3715, 3877)
     group by produto.cd_produto_tem
             ,est_pro.cd_estoque
     order by produto.cd_produto_tem;

    nCdLotPro number; -- Armazena a sequence da lot_pro

begin
    -- atribuir para que empresa será executado o script. Caso o cliente seja multi_empresa
    -- deverá ser colocado para que empresa o script será executado
    dbamv.pkg_mv2000.atribui_empresa(1);
    -- Deleta todos os lotes dos produtos mestres

    delete dbamv.lot_pro
     where cd_produto in (select produto.cd_produto
                            from dbamv.produto
                           where produto.sn_mestre = 'S' );
  --   commit;

    /*delete dbamv.est_pro
     where cd_produto in (select produto.cd_produto
                            from dbamv.produto
                           where produto.sn_mestre = 'S'); /*AND CD_PRODUTO <> 12 AND CD_ESTOQUE <> 5*/
 --   commit;


    -- Cria as linhas dos lotes dos filho no mestre
    for rLotProNaoMestre in cLotProNaoMestre loop
        -- Abrindo cursor para retornar a sequence do lote
--        open cSeqLotPro;
--       fetch cSeqLotPro into nCdLotPro;
--       close cSeqLotPro;

    dbamv.pkg_mv2000.atribui_empresa(1);

      begin
       -- cria os lotes dos produtos filhos. A trigger da lot_pro irá atualizar a tabela est_pro


      dbamv.mges.grava_lot_pro(rLotProNaoMestre.cd_estoque
                        ,rLotProNaoMestre.cd_produto_tem
                        ,rLotProNaoMestre.dt_validade
                        ,rLotProNaoMestre.qt_estoque_atual
                        ,rLotProNaoMestre.cd_lote
                        ,false
                        ,Null
 		                ,Null
                        ,rLotProNaoMestre.qt_kit);
        exception
         when others then
--           raise_application_error(-20001,sqlerrm);
           raise_application_error(-20001,'esto:'||rLotProNaoMestre.cd_estoque
                                                                        ||'pro_m:'|| rLotProNaoMestre.cd_produto_tem
                                                                        ||'vali:'|| rLotProNaoMestre.dt_validade
                                                                        ||'est_qt:'|| rLotProNaoMestre.qt_estoque_atual
                                                                        ||'lot:'|| rLotProNaoMestre.cd_lote
                                                                        ||'bloq:'|| 'N' -- Nvl(rLotProNaoMestre.sn_bloqueio,'N')
                                                                        ||'est_do:'|| rLotProNaoMestre.qt_estoque_doado
                                                                        ||'qt_or:'||rLotProNaoMestre.qt_orcamentario
                                                                        ||'qt_ex:'|| rLotProNaoMestre.qt_extra_orcamentario);
        end;
        commit;
    end loop;

    -- atualza a est_pro para deixar o saldo do produto mestre igual a soma dos filhos
    for rEstProMestre in cEstProMestre loop
      Begin
        update dbamv.est_pro
           set qt_estoque_atual         = rEstProMestre.qt_estoque_atual
              ,qt_estoque_doado         = rEstProMestre.qt_estoque_doado
              ,qt_solicitacao_de_compra = rEstProMestre.qt_solicitacao_de_compra
              ,qt_ordem_de_compra       = rEstProMestre.qt_ordem_de_compra
              ,qt_estoque_reservado     = rEstProMestre.qt_estoque_reservado
         where est_pro.cd_produto       = rEstProMestre.cd_produto_tem
           and est_pro.cd_estoque       = rEstProMestre.cd_estoque;
      exception
       when others then
         raise_application_error(-20001,'alteração est_pro '|| sqlerrm );
      end;

      commit;

    end loop;

end;
/

Alter Trigger dbamv.Trg_lot_Pro Enable
/
