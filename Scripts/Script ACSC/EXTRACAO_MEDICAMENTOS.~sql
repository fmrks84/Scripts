---- MEDICAMENTO --------
select
distinct
pd.cd_produto,
pd.ds_produto,
pd.vl_fator_pro_fat,
pd.cd_especie,
esp.ds_especie,
pd.cd_classe,
cl.ds_classe,
pd.cd_sub_cla,
scl.ds_sub_cla,
sp.cd_simpro,
ibra.cd_tiss brasindice,
CASE WHEN pd.ds_produto not like '%REF%' THEN null
     else SubStr(pd.ds_produto,instr(pd.ds_produto,' REF')+5,50)
     end REFERENCIA,
lpro.cd_registro anvisa,
gp.cd_gru_pro,
gp.ds_gru_pro,
pf.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade,
ts.cd_tip_tuss tab_tuss,
ts.cd_tuss,
ts.ds_tuss,
vp.cd_tab_fat,
vp.vl_total,
ts.cd_multi_empresa,
ts.cd_convenio,
conv.nm_convenio

from
produto pd
inner join pro_Fat pf on pf.cd_pro_fat = pd.cd_pro_fat
inner join empresa_produto emp on emp.cd_produto = pd.cd_produto
inner join tuss ts on ts.cd_pro_fat = pd.cd_pro_fat and emp.cd_multi_empresa = ts.cd_multi_empresa
left join imp_simpro sp on sp.cd_pro_fat = pd.cd_pro_fat
inner join especie esp on esp.cd_especie = pd.cd_especie
inner join classe cl on cl.cd_classe = pd.cd_classe and cl.cd_especie = pd.cd_especie
inner join sub_clas scl on scl.cd_sub_cla = pd.cd_sub_cla and scl.cd_classe = pd.cd_classe
and scl.cd_especie = esp.cd_especie
inner join lab_pro lpro on lpro.cd_produto = pd.cd_produto
left join convenio conv on conv.cd_convenio = ts.cd_convenio
left join imp_bra ibra on ibra.cd_pro_fat = pd.cd_pro_fat
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
left join val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat 
where trunc(vp.dt_vigencia) = (select max(x.dt_vigencia) from val_pro x where x.cd_pro_fat = vp.cd_pro_fat and x.cd_tab_fat = vp.cd_tab_fat)
and ts.cd_multi_empresa = 7 -- filtro empresa 
and ts.cd_tip_tuss in (19,20,00) -- manter 
and gp.cd_gru_pro in (7,43,94,92,12,44) -- MEDICAMENTO   
and ts.cd_convenio is null -- aqui quando o convenio for null  
and ts.dt_fim_vigencia is null

union all

select
distinct
pd.cd_produto,
pd.ds_produto,
pd.vl_fator_pro_fat,
pd.cd_especie,
esp.ds_especie,
pd.cd_classe,
cl.ds_classe,
pd.cd_sub_cla,
scl.ds_sub_cla,
sp.cd_simpro,
ibra.cd_tiss brasindice,
CASE WHEN pd.ds_produto not like '%REF%' THEN null
     else SubStr(pd.ds_produto,instr(pd.ds_produto,' REF')+5,50)
     end REFERENCIA,
lpro.cd_registro anvisa,
gp.cd_gru_pro,
gp.ds_gru_pro,
pf.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade,
ts.cd_tip_tuss tab_tuss,
ts.cd_tuss,
ts.ds_tuss,
vp.cd_tab_fat,
vp.vl_total,
ts.cd_multi_empresa,
ts.cd_convenio,
conv.nm_convenio

from
produto pd
inner join pro_Fat pf on pf.cd_pro_fat = pd.cd_pro_fat
inner join empresa_produto emp on emp.cd_produto = pd.cd_produto
inner join tuss ts on ts.cd_pro_fat = pd.cd_pro_fat and emp.cd_multi_empresa = ts.cd_multi_empresa
left join imp_simpro sp on sp.cd_pro_fat = pd.cd_pro_fat
inner join especie esp on esp.cd_especie = pd.cd_especie
inner join classe cl on cl.cd_classe = pd.cd_classe and cl.cd_especie = pd.cd_especie
inner join sub_clas scl on scl.cd_sub_cla = pd.cd_sub_cla and scl.cd_classe = pd.cd_classe
and scl.cd_especie = esp.cd_especie
inner join lab_pro lpro on lpro.cd_produto = pd.cd_produto
left join convenio conv on conv.cd_convenio = ts.cd_convenio
left join imp_bra ibra on ibra.cd_pro_fat = pd.cd_pro_fat
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
left join val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat 
where trunc(vp.dt_vigencia) = (select max(x.dt_vigencia) from val_pro x where x.cd_pro_fat = vp.cd_pro_fat and x.cd_tab_fat = vp.cd_tab_fat)
and ts.cd_multi_empresa = 7 -- filtro empresa 
and ts.cd_tip_tuss in (19,20,00) -- manter 
and gp.cd_gru_pro in (7,43,94,92,12,44) -- MEDICAMENTO  
and ts.cd_convenio is not null -- aqui quando o convenio não for null  
and ts.dt_fim_vigencia is null
