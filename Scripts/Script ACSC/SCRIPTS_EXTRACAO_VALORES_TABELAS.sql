select 
pf.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade,
pf.cd_gru_pro,
gp.ds_gru_pro,
vp.cd_tab_fat,
tf.ds_tab_fat,
to_Date(vp.dt_vigencia,'dd/mm/rrrr')dt_vigencia,
vp.vl_total
from 
dbamv.pro_fat pf 
inner join dbamv.val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat
inner join dbamv.gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
inner join dbamv.tab_Fat tf on tf.cd_tab_fat = vp.cd_tab_fat
where to_date(vp.dt_vigencia,'dd/mm/rrrr') between '01/01/2023' and '31/12/2023' 
and pf.cd_gru_pro  in (7, 8, 9, 12, 15, 43, 44, 71, 89, 92, 94, 95, 96)
 and pf.sn_ativo = 'S'
and vp.cd_tab_fat in (2,1,181)
order by vp.cd_pro_fat,
         vp.cd_tab_fat,
         vp.dt_vigencia


--select * from gru_pro where cd_gru_pro in  (8, 9,44,89,95,96)
