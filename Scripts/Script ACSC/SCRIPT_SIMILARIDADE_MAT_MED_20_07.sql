with grf as(
select 
distinct
gp.cd_gru_fat,
gp.cd_gru_pro
from gru_pro gp
where gp.cd_gru_pro in (8,95,89,96,7,43,15,71,94,92,12,44)
)
,prod as (
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
pf.cd_gru_pro,
epd.cd_multi_empresa

from
produto pd
inner join empresa_produto epd on epd.cd_produto = pd.cd_produto
left join produto_fornecedor pfor on pfor.cd_produto = epd.cd_produto
left join fornecedor fnc on fnc.cd_fornecedor = pfor.cd_fornecedor
left join lab_pro lpro on lpro.cd_produto = pd.cd_produto
inner join especie esp on esp.cd_especie = pd.cd_especie
inner  join pro_Fat pf on pf.cd_pro_fat = pd.cd_pro_fat
where epd.cd_multi_empresa in (3,10)
and pd.sn_bloqueio_de_compra = 'N'
order by pd.cd_produto
)

select
distinct
cd_produto,
DS_PRODUTO,
ts.cd_pro_fat,
pf.ds_pro_fat,
pf.cd_gru_pro,
pf.ds_unidade,
imp.cd_simpro,
ts.cd_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
ts.cd_multi_empresa,
ts.cd_convenio,
pdd.cd_registro anvisa,
pdd.REFERENCIA,
pdd.marca
from
tuss ts
left join prod pdd on pdd.cd_pro_fat = ts.cd_pro_fat and pdd.cd_multi_empresa = ts.cd_multi_empresa
left join pro_fat pf on pf.cd_pro_fat = pdd.cd_pro_fat
left join imp_simpro imp on imp.cd_pro_fat = pf.cd_pro_fat 
where /*to_char(irf.dt_lancamento,'mm/rrrr') between '01/2022' and '12/2022'
and*/ ts.cd_tip_tuss in (19,20) --- 19 materiais , 20 medicamentos
and ts.cd_convenio is null
and ts.cd_multi_empresa in (3,10)
--and ts.cd_tuss = '70015368'
--and pdd.cd_registro is not null
--and irf.cd_reg_Fat = 380039
--and irf.cd_pro_fat = '00084865'

--AND ts.cd_pro_fat = '70015368'

--select * from itreg_fAT where cd_reg_fat = 380039 and cd_pro_fat = 70015368
--select * from imp_simpro
