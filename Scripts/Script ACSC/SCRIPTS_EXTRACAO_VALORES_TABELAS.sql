select 
pf.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade,
pf.cd_gru_pro,
gp.ds_gru_pro,
vp.cd_tab_fat,
tf.ds_tab_fat,
vp.dt_vigencia,
vp.vl_total
from 
dbamv.pro_fat pf 
inner join dbamv.val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat
inner join dbamv.gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
inner join dbamv.tab_Fat tf on tf.cd_tab_fat = vp.cd_tab_fat
where /*trunc(vp.dt_vigencia) = (select max(x.dt_vigencia)from dbamv.val_pro x where x.cd_tab_fat = vp.cd_tab_fat 
and x.cd_pro_fat = vp.cd_pro_fat)
and */pf.cd_gru_pro in (8, 9 , 89 , 95 , 96 , 7 , 12, 15 , 43 , 44 , 55 , 91 , 92 , 94)
and pf.sn_ativo = 'S'
and vp.cd_tab_fat in (525,526,581)
order by vp.cd_pro_fat,vp.cd_tab_fat,vp.dt_vigencia

