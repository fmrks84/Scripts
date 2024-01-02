select 
distinct
pd.cd_produto,
pd.ds_produto,
CASE WHEN pd.ds_produto not like '%REF%' THEN null
     else SubStr(pd.ds_produto,instr(pd.ds_produto,' REF')+5,50)
     end REFERENCIA,
pd.cd_especie,
esp.ds_especie,
lpro.cd_laborator marca,
lpro.cd_registro,
lpro.dt_validade_registro,
pd.cd_pro_fat,
pf.cd_gru_pro

from 
produto pd
inner join empresa_produto epd on epd.cd_produto = pd.cd_produto
left join produto_fornecedor pfor on pfor.cd_produto = epd.cd_produto
left join fornecedor fnc on fnc.cd_fornecedor = pfor.cd_fornecedor
left join lab_pro lpro on lpro.cd_produto = pd.cd_produto
inner join especie esp on esp.cd_especie = pd.cd_especie
inner  join pro_Fat pf on pf.cd_pro_fat = pd.cd_pro_fat
where epd.cd_multi_empresa = 3
and pd.sn_bloqueio_de_compra = 'N'

order by pd.cd_produto
--and pd.cd_produto = 2018990


