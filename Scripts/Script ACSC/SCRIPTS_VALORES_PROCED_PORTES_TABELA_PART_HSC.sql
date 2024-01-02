with port_anest as (
select 
vpt.cd_por_ane,
vpt.cd_tab_fat,
vpt.dt_vigencia,
vpt.vl_porte
from 
dbamv.val_porte vpt
where vpt.dt_vigencia = (select max(vptx.dt_vigencia)from val_porte vptx where vptx.cd_tab_fat = vpt.cd_tab_fat 
and vptx.cd_por_ane = vpt.cd_por_ane)
and vpt.cd_tab_fat in (73,222)

)

select
vp.cd_tab_fat,
tf.ds_tab_fat,
pf.cd_pro_fat,
pf.ds_pro_fat,
pf.cd_gru_pro,
gp.ds_gru_pro,
vp.dt_vigencia,
vp.vl_total vl_proced,
nvl(pt.vl_porte,0) vl_porte

from dbamv.pro_Fat pf 
inner join dbamv.val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat
inner join dbamv.gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
inner join dbamv.tab_fat tf on tf.cd_tab_fat = vp.cd_tab_fat
left join  port_anest pt on pt.cd_por_ane = pf.cd_por_ane
where vp.dt_vigencia = (select max(x.dt_vigencia) from val_pro x where x.cd_pro_fat = vp.cd_pro_fat
and x.cd_tab_fat = vp.cd_tab_fat)
and vp.cd_tab_fat in (73,222)
and vp.sn_ativo = 'S'
--and pf.cd_pro_fat in ('30729386')
order by vp.cd_tab_fat,pf.cd_pro_fat;

/*
select * from val_porte 

select * from 

select * from dbamv.vw_ovmd_guia_sadt_eletivo*/
