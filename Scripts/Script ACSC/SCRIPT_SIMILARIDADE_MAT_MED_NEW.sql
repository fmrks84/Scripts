with grf as(
select 
distinct
gp.cd_gru_fat,
gp.cd_gru_pro
from gru_pro gp
where gp.cd_gru_pro in (8,95,89,96, 7,43,15,71,94,92,12,44)
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
where epd.cd_multi_empresa = 3
and pd.sn_bloqueio_de_compra = 'N'
order by pd.cd_produto
)
select 
*
from
(
select
distinct
case when gf.cd_gru_pro in (8,95,89,96) then 'MATERIAIS'
          when gf.cd_gru_pro in (7,43,15,71,94,92,12,44) then 'MEDICAMENTOS'
END DS_PRODUTO,
ts.cd_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
ts.cd_pro_fat,
pdd.cd_registro anvisa,
pdd.REFERENCIA,
pdd.marca,
count(*)total
from
tuss ts
left join prod pdd on pdd.cd_pro_fat = ts.cd_pro_fat and pdd.cd_multi_empresa = ts.cd_multi_empresa
inner join reg_Fat rf on rf.cd_multi_empresa = ts.cd_multi_empresa
inner join itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat and irf.cd_pro_fat = ts.cd_pro_fat
inner join grf gf on gf.cd_gru_fat  = irf.cd_gru_fat
where to_char(irf.dt_lancamento,'mm/rrrr') between '01/2022' and '12/2022'
and ts.cd_tip_tuss in (19,20) --- 19 materiais , 20 medicamentos
and ts.cd_convenio is null
and ts.cd_multi_empresa = 3
--and ts.cd_tuss = '70015368'
--and pdd.cd_registro is not null
--and irf.cd_reg_Fat = 380039
--and irf.cd_pro_fat = '00084865'
group by 
gf.cd_gru_pro ,
ts.cd_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
ts.cd_pro_fat,
cd_registro,
pdd.REFERENCIA,
pdd.marca

union all

select
distinct
case when gf.cd_gru_pro in (8,95,89,96) then 'MATERIAIS'
          when gf.cd_gru_pro in (7,43,15,71,94,92,12,44) then 'MEDICAMENTOS'
END DS_PRODUTO,
ts.cd_tip_tuss,
--iramb.cd_reg_amb,
ts.cd_tuss,
ts.ds_tuss,
ts.cd_pro_fat,
pdd.cd_registro anvisa,
pdd.REFERENCIA,
pdd.marca,
count(*)total
from
tuss ts
left join prod pdd on pdd.cd_pro_fat = ts.cd_pro_fat and pdd.cd_multi_empresa = ts.cd_multi_empresa
inner join reg_amb ramb on ramb.cd_multi_empresa = ts.cd_multi_empresa
inner join itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb and iramb.cd_pro_fat = ts.cd_pro_fat
inner join grf gf on gf.cd_gru_fat = iramb.cd_gru_fat
where to_char(iramb.hr_lancamento,'mm/rrrr') between '01/2022' and '12/2022'
and ts.cd_tip_tuss in (19,20)  --- 19 materiais , 20 medicamentos
and ts.cd_convenio is null
and ts.cd_multi_empresa = 3
--and pdd.cd_registro is not null
--and pdd.REFERENCIA is not null
--and pdd.marca is not null
--and iramb.cd_reg_amb = 291118
--and iramb.cd_pro_fat = '00244011'
--and irf.cd_reg_Fat = 380039
--and irf.cd_pro_fat = '00084865'
group by
ds_produto,
gf.cd_gru_pro, 
ts.cd_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
ts.cd_pro_fat,
pdd.cd_registro,
pdd.REFERENCIA,
pdd.marca
--order by total desc
)
where cd_pro_fat = '70015368'
order by total desc

--select * from itreg_fAT where cd_reg_fat = 380039 and cd_pro_fat = 70015368
