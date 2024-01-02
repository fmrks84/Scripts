/*BEGIN
dbamv.pkg_mv2000.atribui_empresa(2);
END;*/
 
SELECT        itmvto.cd_produto
             ,produto.ds_produto
             ,mvto.cd_multi_empresa empresa_destino
             ,dbamv.verif_vl_custo_medio (itmvto.cd_produto,SYSDATE,'H',NULL,NULL,1 ) Custo_Medio_Santa_Joana
             ,dbamv.verif_vl_custo_medio (itmvto.cd_produto,SYSDATE,'H',NULL,NULL,2) Custo_Medio_Promater
FROM dbamv.mvto_estoque mvto
   , dbamv.itmvto_estoque itmvto
   , dbamv.produto
WHERE mvto.tp_mvto_estoque = 'R'
AND itmvto.cd_mvto_estoque = mvto.cd_mvto_estoque
AND itmvto.cd_produto = produto.cd_produto
--AND trunc(mvto.dt_mvto_estoque) BETWEEN to_date('01/01/2000','dd/mm/yyyy') AND to_date('16/12/2009','dd/mm/yyyy')
--AND mvto.cd_multi_empresa = 1 -- todas as movimentações que foram feitas para o promater
GROUP BY itmvto.cd_produto,produto.ds_produto,mvto.cd_multi_empresa
order by produto.ds_produto
