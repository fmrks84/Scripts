select 
gp.cd_gru_pro,
gp.ds_gru_pro,
vp.cd_pro_fat,
pf.ds_pro_fat, 
vp.cd_tab_fat,
vp.dt_vigencia,--)vl_ult_vigencia,
vp.vl_honorario,
vp.vl_operacional,
vp.vl_total
from 
tab_Fat tf
inner join val_pro vp on vp.cd_tab_fat = tf.cd_tab_fat
inner join pro_Fat pf on pf.cd_pro_fat = vp.cd_pro_fat
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
where /*vp.dt_vigencia = (select max(x.dt_vigencia) from val_pro x where x.cd_tab_fat = vp.cd_tab_fat and x.cd_pro_fat = vp.cd_pro_fat)
and */tf.cd_tab_fat = 1705
--and pf.cd_pro_fat = '70182043'
/*group by 
gp.cd_gru_pro,
gp.ds_gru_pro,
vp.cd_pro_fat,
pf.ds_pro_fat, 
vp.cd_tab_fat,
vp.vl_honorario,
vp.vl_operacional,
vp.vl_total*/
order by 3,6
