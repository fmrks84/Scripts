select 
pc.cd_multi_empresa,
pc.cd_convenio,
conv.nm_convenio,
pc.cd_pro_fat,
pf.ds_pro_fat,
pc.cd_pro_fat_pacote,
pf1.ds_pro_fat,
ts.cd_tip_tuss,
tts.ds_tip_tuss,
ts.cd_tuss,
ts.ds_tuss
from 
dbamv.pacote pc 
inner join dbamv.convenio conv on conv.cd_convenio = pc.cd_convenio
inner join dbamv.pro_fat pf on pf.cd_pro_fat = pc.cd_pro_fat
inner join dbamv.pro_Fat pf1 on pf1.cd_pro_fat = pc.cd_pro_fat_pacote
inner join dbamv.tuss ts on ts.cd_pro_fat = pc.cd_pro_fat_pacote and ts.cd_convenio = pc.cd_convenio
inner join dbamv.tip_tuss tts on tts.cd_tip_tuss = ts.cd_tip_tuss 
where pc.cd_multi_empresa = 7 
and pc.cd_convenio IN (7,32,641) 
and pc.dt_vigencia_final is null
order by PC.CD_CONVENIO, pc.cd_pro_fat
--and pc.cd_pro_fat_pacote = '20000007'


--select * from itlan_med where cd_reg_fat = 578461
