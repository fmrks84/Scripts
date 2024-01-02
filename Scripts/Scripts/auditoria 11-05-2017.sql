select *
       from dbamv.itfat_nota_fiscal c ,
            dbamv.reg_amb b 
where c.cd_reg_amb in (971050,968041,968017,968296,968364,966723)
and c.cd_remessa = b.cd_remessa
and c.cd_reg_amb = b.cd_reg_amb
--971050 - 100429
--968041 - 100386
--968296 - 100386
--968364 - 100038
--966723 - 99897

select * from dbamv.Reg_Amb amb ,
              dbamv.itreg_amb amb2 
where amb.cd_reg_amb = 971050
and amb.cd_reg_amb = amb2.cd_reg_amb
