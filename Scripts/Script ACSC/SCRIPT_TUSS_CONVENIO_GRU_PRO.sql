select
vp.cd_tab_fat,
vp.cd_pro_fat,
ts.cd_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
ts.cd_convenio,
ts.cd_multi_empresa,
pf.ds_pro_fat,
vp.dt_vigencia,
vp.vl_honorario,
vp.vl_operacional,
vp.vl_total,
vp.sn_ativo

from
val_pro vp
inner join pro_fat pf on pf.cd_pro_fat = vp.cd_pro_fat
left join tuss ts on ts.cd_pro_fat = pf.cd_pro_fat
where (ts.cd_convenio = 112 or ts.cd_convenio is null)
and (ts.cd_multi_empresa = 10 or ts.cd_multi_empresa is null)
 and ts.cd_tip_tuss in (00,18,19,20,22,98)
 and pf.cd_gru_pro in (73,7,12,15,44,55)
 and ts.cd_pro_fat = 90020286
order by 2,1


