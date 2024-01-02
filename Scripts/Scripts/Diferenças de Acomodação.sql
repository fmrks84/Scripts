select p.cd_pro_fat, p.ds_pro_fat, v.vl_total, v.dt_vigencia, v.cd_tab_fat, t.ds_tab_fat
from dbamv.val_pro v, dbamv.pro_fat p, dbamv.tab_fat t
where v.cd_pro_fat in ('00050088','00050090','00050088','00050205','00050203','00050203','00050205','00050021', '00050204')
and   v.cd_pro_fat = p.cd_pro_fat
and   v.cd_tab_fat = t.cd_tab_fat
order by 5,1,4
