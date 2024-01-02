select 
distinct
pd.cd_produto,
pd.ds_produto,
pd.vl_fator_pro_fat,
pd.cd_especie,
esp.ds_especie,
pd.cd_classe,
cls.ds_classe,
pd.cd_sub_cla,
scls.ds_sub_cla,
imp.cd_simpro,
ibra.cd_tiss brasindice,
CASE WHEN pd.ds_produto not like '%REF%' THEN null
     else SubStr(pd.ds_produto,instr(pd.ds_produto,' REF')+5,50)
     end REFERENCIA,
lpro.cd_registro anvisa,
pf.cd_gru_pro,
gp.ds_gru_pro,
pd.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade,
ts.cd_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
vp.cd_tab_fat,
vp.vl_total,
ts.cd_multi_empresa,
ts.cd_convenio,
conv.nm_convenio
from 
dbamv.pro_Fat pf 
inner join dbamv.gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro 
and gp.cd_gru_pro in (7,8,9,12,43,44,55,89,91,92,94,95,96)
inner join dbamv.produto pd on pd.cd_pro_fat = pf.cd_pro_fat
and pd.sn_movimentacao = 'S'
inner join dbamv.especie esp on esp.cd_especie = pd.cd_especie 
and esp.cd_especie not in (5,9,11,21)
inner join dbamv.classe cls on  cls.cd_classe = pd.cd_classe
and cls.cd_especie = pd.cd_especie 
inner join dbamv.sub_clas scls on scls.cd_sub_cla = pd.cd_sub_cla
and scls.cd_classe = pd.cd_classe
and scls.cd_especie = pd.cd_especie
inner join dbamv.empresa_produto emp on emp.cd_produto = pd.cd_produto and
emp.cd_multi_empresa = 1
inner join dbamv.tuss ts on ts.cd_pro_fat = pf.cd_pro_fat and ts.cd_tip_tuss in (00,19,20)
and ts.dt_fim_vigencia is null
and ts.cd_multi_empresa in (3,7,10,11,25)
left join dbamv.convenio conv on conv.cd_convenio = ts.cd_convenio
inner join dbamv.val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat
left join dbamv.imp_simpro imp on imp.cd_pro_fat = vp.cd_pro_fat 
and imp.cd_tab_fat = vp.cd_tab_fat
left join dbamv.imp_bra ibra on ibra.cd_pro_fat= vp.cd_pro_fat
and ibra.cd_tab_fat = vp.cd_tab_fat
inner join dbamv.lab_pro lpro on lpro.cd_produto = pd.cd_produto
where trunc(vp.dt_vigencia) = (select max(x.dt_vigencia) from val_pro x where x.cd_pro_fat = vp.cd_pro_fat
and vp.cd_tab_fat = x.cd_tab_fat)
and ts.cd_multi_empresa = 7 -- filtro
and ts.cd_convenio in  (5)--(&par_convenio) -- filtro traze
--and pd.cd_especie in (&par_especie) -- filtro
--and gp.cd_gru_pro in (&par_gru_pro) 
--and pf.cd_pro_fat = '09000220'
--and ts.cd_convenio is null
order by pd.cd_produto

select 
distinct
pd.cd_especie,
esp.ds_especie
from dbamv.pro_fat pf 
inner join dbamv.produto pd on pd.cd_pro_fat = pf.cd_pro_fat
and pf.cd_gru_pro in (7,8,9,12,43,44,55,89,91,92,94,95,96)
inner join dbamv.empresa_produto emp on emp.cd_produto = pd.cd_produto 
and emp.cd_multi_empresa = 1 
inner join dbamv.especie esp on esp.cd_especie = pd.cd_especie
where pd.cd_especie not in (5,9,11,21)
order by pd.cd_especie 
