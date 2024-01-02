select a.cd_bem,
       a.ds_plaqueta,
       a.dt_tombamento , 
       a.dt_ult_depre
from dbamv.bens a
where a.cd_multi_empresa = 10
and to_number (a.ds_plaqueta) between '596' and '641'
--a.cd_bem = 28200
order by a.ds_plaqueta
for update 
