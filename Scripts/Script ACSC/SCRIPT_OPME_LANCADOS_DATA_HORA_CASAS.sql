select 
x1.cd_multi_empresa,
x1.cd_atendimento,
x1.cd_reg_fat,
x.cd_pro_fat,
x2.ds_pro_fat,
x.hr_lancamento,
x.qt_lancamento,
x.vl_unitario,
x.vl_total_conta
from 
itreg_fat x 
inner join reg_Fat x1 on x1.cd_reg_fat = x.cd_reg_fat
inner join pro_fat x2 on x2.cd_pro_fat = x.cd_pro_fat
where x.cd_pro_fat in (select pf.cd_pro_fat from dbamv.pro_Fat pf where pf.sn_ativo = 'S' 
and pf.cd_gru_pro in (select cd_Gru_pro from gru_pro where cd_gru_fat in (5,9)))
and to_CHAR(x.hr_lancamento,'DD/MM/RRRR HH24:MM') between  to_CHAR('27/09/2022 05:45') and to_CHAR('27/09/2022 09:00')
and x1.cd_multi_empresa in (3,4,7,10,25)
order by x1.cd_multi_empresa, x.hr_lancamento
 


