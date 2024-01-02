select sum (a.vl_unitario) 
from dbamv.itreg_amb a where a.cd_reg_amb in (918994,914407,917238,918674)
and a.cd_pro_fat = 08050823

select sum (b.qt_lancamento * b.vl_unitario)
  from dbamv.itreg_fat b where b.cd_reg_fat in (1322120)
and b.cd_pro_fat in (07003082) --90194497

select * from dbamv.tiss_guia d where d.cd_reg_fat = 1322120


