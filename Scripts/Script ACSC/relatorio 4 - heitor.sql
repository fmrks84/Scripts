select 
decode (atend.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
atend.dt_atendimento,
rf.Cd_Atendimento,
atend.cd_paciente,
pct.nm_paciente,
rf.cd_reg_fat conta,
rf.cd_remessa,
case when atend.tp_atendimento = 'I' then 'Internado'
     when atend.tp_atendimento = 'U' then 'Urgência'
     when atend.tp_atendimento = 'A' then 'Ambulatóio'
     when atend.tp_atendimento = 'E' then 'Externo'    
     end tp_Atendimento,
rf.cd_convenio,
conv.nm_convenio,
rf.dt_inicio,
rf.dt_final     

from 
reg_fat rf
inner join atendime atend on atend.cd_atendimento = rf.cd_atendimento
inner join paciente pct on pct.cd_paciente = atend.cd_paciente
inner join convenio conv on conv.cd_convenio = atend.cd_convenio and atend.cd_convenio = rf.cd_convenio
where trunc(atend.dt_atendimento) between '01/01/2018' and '17/05/2021'
and rf.sn_fechada = 'N'
and rf.cd_convenio = 261
and atend.tp_atendimento = 'I'

union all 

select 
distinct 
decode (atend1.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
atend1.dt_atendimento,
iramb.cd_atendimento,
atend1.cd_paciente,
pct1.nm_paciente,
ramb.cd_reg_amb conta,
ramb.cd_remessa,
case when atend1.tp_atendimento = 'I' then 'Internado'
     when atend1.tp_atendimento = 'U' then 'Urgência'
     when atend1.tp_atendimento = 'A' then 'Ambulatóio'
     when atend1.tp_atendimento = 'E' then 'Externo'    
     end tp_Atendimento,
iramb.cd_convenio,
conv1.nm_convenio,
ramb.dt_lancamento dt_inicio,
ramb.dt_lancamento dt_final
from
reg_amb ramb
inner join itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join atendime atend1 on atend1.cd_atendimento = iramb.Cd_Atendimento
inner join paciente pct1 on pct1.cd_paciente = atend1.cd_paciente
inner join convenio conv1 on conv1.cd_convenio = atend1.cd_convenio and atend1.cd_convenio = iramb.cd_convenio
where trunc(atend1.dt_atendimento) between '01/01/2018' and '17/05/2021'
and iramb.sn_fechada = 'N'
and iramb.cd_convenio = 261
and atend1.tp_atendimento in ('U','A','E')
order by 2
