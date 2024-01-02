select * from tuss ts 
--update tuss ts set ts.cd_pro_fat = lpad(ts.cd_pro_fat,8,'0000')
where ts.cd_tip_tuss = 25
and ts.cd_convenio = 99
and ts.cd_multi_empresa = 3
and ts.dt_inicio_vigencia = '01/10/2022'
--and length(ts.cd_pro_fat)=4
--and ts.cd_pro_fat = 09101753
--order by ts.cd_pro_fat


