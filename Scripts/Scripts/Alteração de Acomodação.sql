select * from reg_fat where cd_atendimento in (15130)
select * from atendime where cd_atendimento in (12419,11473,11964,11010)
update reg_fat set cd_con_pla = '3' where cd_convenio = 10 and cd_atendimento in (15130)
update reg_fat set cd_tip_acom = '1' where  cd_atendimento in (14130)

