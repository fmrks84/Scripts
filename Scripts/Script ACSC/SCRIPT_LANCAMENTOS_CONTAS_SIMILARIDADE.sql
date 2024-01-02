select
irf.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade,
gp.cd_gru_pro,
gp.ds_gru_pro,
irf.cd_gru_fat,
gf.ds_gru_fat,
count(*)QTD_LANCAMENTOS
from
pro_fat pf
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
inner join gru_fat gf on gf.cd_gru_fat = gp.cd_gru_fat
inner join itreg_fat irf on irf.cd_pro_fat = pf.cd_pro_fat
inner join reg_fat rf on rf.cd_reg_fat = irf.cd_reg_fat 
inner join atendime atd on atd.cd_atendimento = rf.cd_atendimento
where atd.dt_atendimento between '01/01/2022' and '01/01/2023'
and atd.cd_multi_empresa = 3 
and gf.cd_gru_fat in (4,9,5)
group by 
irf.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade,
gp.cd_gru_pro,
gp.ds_gru_pro,
irf.cd_gru_fat,
gf.ds_gru_fat

union all

select 
iramb.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade,
gp.cd_gru_pro,
gp.ds_gru_pro,
iramb.cd_gru_fat,
gf.ds_gru_fat,
count(*)QTD_LANCAMENTOS
from 
pro_fat pf
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
inner join gru_fat gf on gf.cd_gru_fat = gp.cd_gru_fat
inner join itreg_amb iramb on iramb.cd_pro_fat = pf.cd_pro_fat
inner join reg_amb ramb on ramb.cd_reg_amb = iramb.cd_reg_amb 
inner join atendime atd on atd.cd_atendimento = iramb.cd_atendimento
where atd.dt_atendimento between '01/01/2022' and '01/01/2023'
and atd.cd_multi_empresa = 3 
and gf.cd_gru_fat in (4,9,5)
group by 
iramb.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade,
gp.cd_gru_pro,
gp.ds_gru_pro,
iramb.cd_gru_fat,
gf.ds_gru_fat
order by 8 desc 
--) order by 
--select * from gru_fat 
