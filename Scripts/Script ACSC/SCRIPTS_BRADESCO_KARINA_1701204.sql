--select * from gru_pro gp where /*(gp.ds_gru_pro like '%MATER%' OR gp.ds_gru_pro like '%ORTESE%' or*/ gp.ds_gru_pro like '%MEDICA%'--)
/*
select 
tf.cd_tab_fat,
tf.ds_tab_fat
from 
dbamv.tab_Fat tf
where tf.ds_tab_fat like 'HSC%'*/

select 
distinct 
pd.cd_produto,
pd.ds_produto,
pd.cd_especie,
esp.ds_especie ,
pd.cd_classe,
cl.ds_classe,
pd.cd_sub_cla,
slc.ds_sub_cla,
isp.cd_simpro,
pf.cd_pro_fat,
pf.ds_pro_fat,
ts.cd_tip_tuss,
tp.ds_tip_tuss,
ts.cd_tuss,
ts.ds_tuss tuss,
ts.cd_convenio,
conv.nm_convenio,
CASE WHEN pd.ds_produto not like '%REF%' THEN null
     else SubStr(pd.ds_produto,instr(pd.ds_produto,' REF')+5,50)
     end referencia,
pf.ds_unidade,
vp.cd_tab_fat,
tf.ds_tab_fat,
pd.vl_ultima_entrada,
vp.vl_total

from 
dbamv.produto pd 
inner join dbamv.empresa_produto epd on epd.cd_produto = pd.cd_produto and epd.cd_multi_empresa = 7 
inner join dbamv.pro_fat pf on pf.cd_pro_fat = pd.cd_pro_fat
inner join dbamv.especie esp on esp.cd_especie = pd.cd_especie
inner join dbamv.classe cl on cl.cd_classe = pd.cd_classe and cl.cd_especie = pd.cd_especie
inner join dbamv.sub_clas slc on slc.cd_sub_cla = pd.cd_sub_cla and slc.cd_especie = pd.cd_especie
and slc.cd_classe = pd.cd_classe
inner join dbamv.val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat and pf.sn_ativo = 'S'
inner join dbamv.tab_Fat tf on tf.cd_tab_fat = vp.cd_tab_fat and tf.ds_tab_fat like 'CSSJ%'
left join dbamv.imp_simpro isp on isp.cd_tab_fat = vp.cd_tab_fat and isp.cd_pro_fat = vp.cd_pro_fat
left join dbamv.tuss ts on ts.cd_pro_fat = vp.cd_pro_fat
and ts.cd_tip_tuss in (00,19,20)
and ts.cd_multi_empresa = 3 
--and ts.cd_convenio is null
and ts.dt_fim_vigencia is null
inner join dbamv.tip_tuss tp on tp.cd_tip_tuss = ts.cd_tip_tuss
left join dbamv.convenio conv on conv.cd_convenio = ts.cd_convenio
where trunc(vp.dt_vigencia) = (select max(x.dt_vigencia) from val_pro x where x.cd_tab_fat = vp.cd_tab_fat and x.cd_pro_fat = vp.cd_pro_fat)
and pd.sn_movimentacao = 'S'
and pf.cd_gru_pro in (9)--(8,9,89,91,95,96)
--and pf.cd_gru_pro in (9, 71, 7, 8, 12, 91, 92, 15, 89, 43, 44, 94, 95, 96)
/*and (ts.cd_convenio in (select econv.cd_convenio from empresa_convenio econv where econv.sn_ativo = 'S' and econv.cd_multi_empresa = ts.cd_multi_empresa
\*and ts.cd_convenio in (7,32,641)*\)
or ts.cd_convenio is null)*/
--and isp.cd_simpro is not null
--and pf.cd_pro_fat = '09000220'
and ts.cd_convenio is null
order by pd.cd_produto,vp.cd_tab_fat

--select * from gru_pro gp where gp.cd_gru_pro in (9)
--select * from imp_sm

--select * from empresa_convenio where cd_convenio in (56,55,34,6)
