select * from dbamv.itreg_Fat f where f.cd_reg_fat = 951112 order by 2  for update-- 1046021 
select * from dbamv.itreg_Fat f where f.cd_reg_fat = 950927 order by 3 -- 1045988

select * from dbamv.reg_Fat d where d.cd_reg_fat IN (951112,950927) for update
