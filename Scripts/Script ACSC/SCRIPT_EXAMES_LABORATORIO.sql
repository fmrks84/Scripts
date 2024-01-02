select 
distinct
decode(rf.cd_multi_empresa,'4','HST')empresa,
irf.cd_reg_fat conta,
irf.cd_pro_fat,
pf.ds_pro_fat,
irf.hr_lancamento,
irf.tp_mvto,
irf.cd_mvto,
pl.cd_pre_med prescricao
from
reg_Fat rf  
inner join itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat
left join ped_lab  pl on pl.cd_ped_lab = irf.cd_mvto and pl.cd_atendimento = rf.cd_atendimento
inner join pro_fat pf on pf.cd_pro_fat = irf.cd_pro_fat
where irf.cd_prestador = 39410 
and rf.cd_multi_empresa = 4
and irf.tp_mvto not in ('PSSD_SUS')
and to_date(irf.hr_lancamento,'dd/mm/rrrr') = '07/03/2023'

union all

select 
distinct
decode(rf.cd_multi_empresa,'10','HSJ')empresa,
irf.cd_reg_fat conta,
irf.cd_pro_fat,
pf.ds_pro_fat,
irf.hr_lancamento,
irf.tp_mvto,
irf.cd_mvto,
pl.cd_pre_med prescricao
from
reg_Fat rf  
inner join itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat
left join ped_lab  pl on pl.cd_ped_lab = irf.cd_mvto and pl.cd_atendimento = rf.cd_atendimento
inner join pro_fat pf on pf.cd_pro_fat = irf.cd_pro_fat
where irf.cd_prestador = 39410 
and rf.cd_multi_empresa = 10
and irf.tp_mvto not in ('PSSD_SUS')
and to_date(irf.hr_lancamento,'dd/mm/rrrr') = '25/03/2023'

union all

select 
distinct
decode(rf.cd_multi_empresa,'25','HCNSC')empresa,
irf.cd_reg_fat conta,
irf.cd_pro_fat,
pf.ds_pro_fat,
irf.hr_lancamento,
irf.tp_mvto,
irf.cd_mvto,
pl.cd_pre_med prescricao
from
reg_Fat rf  
inner join itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat
left join ped_lab  pl on pl.cd_ped_lab = irf.cd_mvto and pl.cd_atendimento = rf.cd_atendimento
inner join pro_fat pf on pf.cd_pro_fat = irf.cd_pro_fat
where irf.cd_prestador = 39410 
and rf.cd_multi_empresa = 25
and to_date(irf.hr_lancamento,'dd/mm/rrrr') = '11/03/2023'
and irf.tp_mvto not in ('PSSD_SUS')
order by hr_lancamento



