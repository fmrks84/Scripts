
-- 
select 
 -- 31/10/2022
-- C2304/9593
distinct
ts.cd_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
ts.dt_fim_vigencia,
ts.cd_pro_fat,
--sp.cd_tab_fat tab_simpro,
sp.cd_simpro,
ts.cd_convenio,
ts.cd_multi_empresa
from
--update 
tuss ts
left  join imp_simpro sp on sp.cd_pro_fat = ts.cd_pro_fat
--and sp.cd_tab_fat = 2 
--set ts.dt_fim_vigencia =  '31/10/2022'
where ts.cd_tip_tuss in (00,19,20)
and ts.cd_tuss in ('80071198','80071147','80071210','60010061','80071104','80071112','80071120','60010126')
and ts.cd_convenio in (6,71,115,155)
order by ts.cd_convenio,ts.cd_multi_empresa
--and sp.cd_tab_fat = 2



--select * from tip_tuss
