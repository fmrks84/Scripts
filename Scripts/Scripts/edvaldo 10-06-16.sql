select * from dbamv.itreg_fat a where a.cd_reg_fat = 1253872
and a.cd_pro_fat = 45010072
--and a.cd_prestador = 6117
for update
  
update dbamv.itreg_fat a set a.cd_prestador = '1824' where a.cd_reg_fat = 1253872
and a.cd_pro_fat = 45010072
and a.cd_prestador = 8808
