select 
'INTERNADO',
rf.cd_atendimento,
pct.nm_paciente,
rf.cd_reg_fat conta,
rf.cd_convenio,
rf.cd_remessa,
gf.ds_gru_fat,
irf.cd_pro_fat,
pf.ds_pro_fat,
trunc(irf.dt_lancamento)dt_lancamento,
irf.qt_lancamento,
irf.vl_unitario,
irf.vl_total_conta

from 
dbamv.reg_fat rf
inner join dbamv.itreg_Fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join dbamv.pro_Fat pf on pf.cd_pro_fat = irf.cd_pro_fat
inner join dbamv.convenio conv on conv.cd_convenio = rf.cd_convenio
inner join dbamv.gru_Fat gf on gf.cd_gru_fat = irf.cd_gru_fat
inner join dbamv.atendime atend  on atend.cd_atendimento = rf.cd_atendimento
inner join dbamv.paciente pct on pct.cd_paciente = atend.cd_paciente
where trunc (irf.dt_lancamento) between '01/01/2021' and sysdate 
and rf.cd_convenio in (41,42)
and irf.cd_gru_fat in (9)
and rf.cd_remessa is not null
and irf.sn_pertence_pacote = 'N'
--order by rf.cd_atendimento,irf.hr_lancamento

union all
select 
'AMBULATORIO',
iramb.cd_atendimento,
pct.nm_paciente,
iramb.cd_reg_amb conta,
iramb.cd_convenio,
ramb.cd_remessa,
gf.ds_gru_fat,
iramb.cd_pro_fat,
pf.ds_pro_fat,
trunc(iramb.hr_lancamento)dt_lancamento,
iramb.qt_lancamento,
iramb.vl_unitario,
iramb.vl_total_conta
from 
dbamv.reg_amb ramb
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.pro_Fat pf on pf.cd_pro_fat = iramb.cd_pro_fat
inner join dbamv.convenio conv on conv.cd_convenio = iramb.cd_convenio and conv.cd_convenio = ramb.cd_convenio
inner join dbamv.gru_fat gf on gf.cd_gru_fat = iramb.cd_gru_fat
inner join dbamv.atendime atend  on atend.cd_atendimento = iramb.cd_atendimento
inner join dbamv.paciente pct on pct.cd_paciente = atend.cd_paciente
where trunc(iramb.hr_lancamento) between '01/01/2021' and sysdate 
and iramb.cd_convenio in (41,42)
and iramb.cd_gru_fat in (9)
and ramb.cd_remessa is not null 
and iramb.sn_pertence_pacote = 'N'
--order by iramb.cd_atendimento, iramb.hr_lancamento
