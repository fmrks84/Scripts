select 
tf.cd_tab_fat,
tf.ds_tab_fat,
vp.cd_pro_fat,
vp.vl_honorario,
vp.vl_operacional,
vp.vl_total,
vp.dt_vigencia

from pro_Fat pf
inner join val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat 
inner join tab_Fat tf on tf.cd_tab_fat = vp.cd_tab_fat
where vp.dt_vigencia = (select max(x.dt_vigencia)from val_pro x where x.cd_tab_fat = vp.cd_tab_fat
                                                    and x.cd_pro_fat = vp.cd_pro_fat)
and (tf.ds_tab_fat like '%HM%' or tf.ds_tab_fat like '%HONORA%')
and vp.cd_pro_fat in ('40202666','40201120')
order by 
tf.cd_tab_fat,
vp.cd_pro_fat
