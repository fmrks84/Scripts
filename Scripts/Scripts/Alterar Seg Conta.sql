select * from reg_fat where cd_reg_fat in (53030)
select * from itreg_fat where cd_reg_fat in (53030)

update itreg_fat set cd_reg_fat = 132 where cd_reg_fat in (53030)
update itreg_fat set cd_conta_pai = 132 where cd_reg_fat in (132)
update reg_fat set cd_reg_fat = 132 where cd_reg_fat in (53030)

select cd_remessa from reg_fat where cd_reg_fat in (112,122,130,131,132)







--select  * from reg_fat order by cd_reg_fat
