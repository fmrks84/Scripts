with valrg as(
select 
convenio.cd_convenio,
con_pla.cd_con_pla,
con_pla.cd_regra,
regra.ds_regra,
itregra.cd_gru_pro,
itregra.vl_percetual_pago,
empresa_convenio.cd_multi_empresa,
itregra.cd_tab_fat,
tab_fat.ds_tab_fat,
val_pro.cd_pro_fat,
val_pro.vl_total

from convenio 
inner join con_pla on con_pla.cd_convenio = convenio.cd_convenio and con_pla.sn_ativo = 'S'
inner join empresa_convenio on empresa_convenio.cd_convenio =  convenio.cd_convenio
inner join regra on regra.cd_regra =  con_pla.cd_regra
inner join itregra on itregra.cd_regra = con_pla.cd_regra
inner join val_pro on val_pro.cd_tab_fat = itregra.cd_tab_fat 
inner join tab_fat on tab_fat.cd_tab_fat = itregra.cd_tab_fat
where trunc(val_pro.dt_vigencia) = (select max(x.dt_vigencia)from val_pro x where x.cd_tab_fat = val_pro.cd_tab_fat)
and empresa_convenio.cd_multi_empresa = 7 
)


select 
pd.cd_produto,
pd.ds_produto,
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
ts.cd_tip_tuss tab_tuss,
ts.cd_tuss,
ts.ds_tuss,
ts.cd_multi_empresa,
ts.cd_convenio,
conv.nm_convenio,
valrg.cd_regra,
valrg.ds_regra,
valrg.cd_Tab_fat,
valrg.ds_tab_fat,
valrg.vl_total vl_total_tab,
valrg.vl_percetual_pago,
(valrg.vl_total * valrg.vl_percetual_pago)/100 vl_total_conv
from
produto pd
inner join pro_Fat pf on pf.cd_pro_fat = pd.cd_pro_fat
inner join empresa_produto emp on emp.cd_produto = pd.cd_produto
inner join tuss ts on ts.cd_pro_fat = pd.cd_pro_fat and emp.cd_multi_empresa = ts.cd_multi_empresa
left join imp_simpro sp on sp.cd_pro_fat = pd.cd_pro_fat
and ts.cd_tip_tuss in (19,20,00)
inner join especie esp on esp.cd_especie = pd.cd_especie
inner join classe cl on cl.cd_classe = pd.cd_classe and cl.cd_especie = pd.cd_especie
inner join sub_clas scl on scl.cd_sub_cla = pd.cd_sub_cla and scl.cd_classe = pd.cd_classe 
and scl.cd_especie = esp.cd_especie
inner join lab_pro lpro on lpro.cd_produto = pd.cd_produto
left join convenio conv on conv.cd_convenio = ts.cd_convenio
left join imp_bra ibra on ibra.cd_pro_fat = pd.cd_pro_fat
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
inner join valrg on valrg.cd_gru_pro = pf.cd_gru_pro 
and valrg.cd_convenio = ts.cd_convenio
and valrg.cd_multi_empresa = ts.cd_multi_empresa 
and valrg.cd_pro_fat = ts.cd_pro_fat
where 1 =1 --ts.cd_convenio = 7
--and pd.cd_produto = 17204
and ts.cd_convenio is not null
and ts.dt_fim_vigencia is null
order by ts.cd_convenio,pd.cd_produto,valrg.cd_regra


