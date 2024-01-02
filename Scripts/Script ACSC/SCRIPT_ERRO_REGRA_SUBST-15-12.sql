select * from itreg_Fat where cd_pro_fat = 00150975 and cd_Reg_Fat
 in (select cd_reg_fat from reg_Fat where cd_convenio in (
(select cd_Convenio from atendime where cd_convenio = 248 and trunc(dt_atendimento) > = '01/12/2022')))
and vl_unitario is not null 
order by 3 desc

/*

cd_reg_Fat = 385611;
select * from reg_Fat where cd_reg_Fat = 385611
select * from pro_Fat where cd_pro_fat = '00150975'
select * from val_pro where cd_pro_Fat = '00150975' and cd_tab_Fat = 525

select * from itregra x where x.cd_regra = 282 and x.cd_gru_pro = 8
select * from gru_pro where cd_gru_pro = 8*/
