select 
rf.cd_atendimento,
rf.cd_convenio,
conv.nm_convenio,
rf.cd_reg_fat,
irf.dt_lancamento,
irf.cd_pro_fat,
pf.ds_pro_fat,
rf.vl_total_conta,
irf.sn_pertence_pacote
from 
reg_Fat rf 
inner join itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join convenio conv on conv.cd_convenio = rf.cd_convenio
inner join pro_fat pf on pf.cd_pro_fat = irf.cd_pro_fat
where to_date(irf.dt_lancamento,'DD/MM/RRRR') BETWEEN '01/06/2023' AND '01/08/2023'
and irf.tp_mvto = 'Cirurgia'
and RF.CD_MULTI_EMPRESA = 3 
order by irf.dt_lancamento,rf.cd_atendimento,rf.cd_reg_fat,rf.cd_convenio





