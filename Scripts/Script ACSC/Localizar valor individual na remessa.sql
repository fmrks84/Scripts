
select b.vl_total_conta , 
       b.cd_pro_fat,
       b.cd_reg_fat
      
 from dbamv.reg_Fat a 
inner join dbamv.itreg_fat b on b.cd_reg_fat = a.cd_reg_fat
where a.cd_remessa = 180279
order by 1
