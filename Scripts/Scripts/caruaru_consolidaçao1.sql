        Select C_Conest.Cd_Produto,
               Produto.sn_consignado,
               Sum( Nvl( C_Conest.Qt_Estoque_Final             , 0 )) Qt_Estoque_Final,
               Sum( Nvl( C_conest.Qt_Estoque_Final_Sem_Transf  , 0 )) Qt_Estoque_Final_Sem_Transf
          From Dbamv.C_Conest,
               Dbamv.Produto
         Where C_conest.Cd_Produto = Produto.Cd_Produto
           And Produto.Sn_Consignado in ( 'N', 'R' )  /* PDA - 191674 */
           And C_Conest.Cd_Mes = 02
           And C_conest.Cd_Ano = 2007
        Having(( Sum( Nvl( C_Conest.Qt_Estoque_Final           , 0 )) <  0   And
                  Produto.Sn_Consignado in ( 'N', 'R' ) ) Or  /* PDA - 191674 */
               ( Sum( Nvl( C_Conest.Qt_Estoque_Final_Sem_Transf, 0 )) <  0   And
                  Produto.Sn_Consignado in ( 'N', 'R' ) ) Or  /* PDA - 191674 */
                  Produto.Sn_Consignado = 'S' )
      Group By C_Conest.Cd_Produto
             , Produto.sn_consignado


        Select C_Conest.Cd_Produto,
               C_Conest.Cd_Estoque,
               C_Conest.Qt_Estoque_Final,
               C_conest.Qt_Estoque_Final_Sem_Transf
          From Dbamv.C_Conest
         Where C_conest.Cd_Produto in ( 53206, 53205, 53207 )
           And C_Conest.Cd_Mes = 02
           And C_conest.Cd_Ano = 2007

select * from dbamv.mvto_ajuste_contabil
select distinct (cd_multi_empresa) from dbamv.empresa_produto
begin
dbamv.pkg_mv2000.atribui_empresa(2);
end;
SELECT
Nvl( Dbamv.Fnc_Mges_Saldo_Anterior( 08
                                  , 53206
                                  , Last_day( to_date( 02 || '/' || 2007, 'mm/yyyy'))), 0 )
FROM DUAL
