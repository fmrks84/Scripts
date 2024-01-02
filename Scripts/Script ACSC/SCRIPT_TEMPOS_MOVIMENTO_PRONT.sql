select ---3529
--count(*)
atd.cd_multi_empresa,
a.cd_protocolo_doc,
b.cd_atendimento,
atd.tp_atendimento,
dp.cd_reg_fat,
rf.vl_total_conta,
a.cd_setor,
a.dt_envio,
a.cd_setor_destino,
b.dt_recebimento,
dp.nr_pasta,
(to_date(b.dt_recebimento,'DD/MM/RRRR HH24:MI') - to_date(a.dt_envio,'DD/MM/RRRR HH24:MI'))TEMPO_RECEB
from 
protocolo_doc a
inner join it_protocolo_doc b on b.cd_protocolo_doc = a.cd_protocolo_doc
inner join atendime atd on atd.cd_atendimento = b.cd_atendimento
inner join convenio conv on conv.cd_convenio = atd.cd_convenio
inner join documento_pasta_parcial dp on dp.cd_atendimento = b.cd_atendimento
and b.cd_documento_pasta_parcial = dp.cd_documento_pasta_parcial
inner join reg_Fat rf on rf.cd_reg_fat = dp.cd_reg_fat
where a.dt_envio between '01/04/2023' and '30/04/2023'
and a.cd_setor in (3736,3735)
and a.cd_setor_destino in (3736,3735)
and b.cd_atendimento = 1574746
order by b.cd_atendimento
