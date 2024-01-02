CREATE OR REPLACE VIEW DBAMV_VW_REDESC_QUALITY_RP013 AS
(
SELECT
cd_multi_empresa,
ds_multi_empresa,
cd_protocolo_doc,
nm_paciente,
cd_atendimento,
conta,
cd_convenio,
nm_convenio,
cd_con_pla,
status,
cd_remessa,
cd_agrupamento,
ds_agrupamento,
dt_realizacao,
cd_setor_destino,
dt_recebimento,
dt_abertura,
dbamv.retorna_data_45_dias(dbamv.retorna_data_45_dias (To_Date(dt_fechamento,'dd/mm/yyyy'),0,7),45,7) dt_pagamento,
nr_limite_pre_remessa,
dbamv.retorna_data_45_dias (To_Date(dt_fechamento,'dd/mm/yyyy'),0,7) dt_fechamento,
dbamv.retorna_data_45_dias (To_Date(dt_envio_fisico,'dd/mm/yyyy'),0,7) dt_envio_fisico,
dbamv.retorna_data_45_dias (To_Date(dt_entrega,'dd/mm/yyyy'),0,7) dt_entrega

FROM (
SELECT DISTINCT
emp.cd_multi_empresa,
emp.ds_multi_empresa,
doc.cd_protocolo_doc,
pact.nm_paciente,
atend.cd_atendimento,
ramb.cd_reg_amb conta,
iramb.cd_convenio,
conv.nm_convenio,
iramb.cd_con_pla,
iramb.sn_fechada status,
ramb.cd_remessa,
agr.cd_agrupamento,
agr.ds_agrupamento,
idoc.dt_realizacao,
doc.cd_setor_destino,
idoc.dt_recebimento,
sysdate dt_abertura,
conv.nr_limite_pre_remessa,
----- ALTERADO AS DATAS DE FECHAMENTO CONFORME PEDIDO CHAMADO C2302/7617 
case when to_char(sysdate,'dd') between '01' and '12' then to_char('12')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '13' and to_char(sysdate,'D') = '2' then to_char('12')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '13' and to_char(sysdate,'D') <> '2' then to_char('28')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '14' and to_char(sysdate,'D') = '2' then to_char('12')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '14' and to_char(sysdate,'D') <> '2' then to_char('28')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') between '13' and '28' then to_char('28')||'/'||to_char(sysdate,'mm/yyyy')
else to_char(sysdate,'dd/mm/yyyy') end dt_fechamento,
case when to_char(sysdate,'dd') between '01' and '12' then to_char('12')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '13' and to_char(sysdate,'D') = '2' then to_char('12')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '13' and to_char(sysdate,'D') <> '2' then to_char('28')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '14' and to_char(sysdate,'D') = '2' then to_char('12')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '14' and to_char(sysdate,'D') <> '2' then to_char('28')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') between '13' and '28' then to_char('28')||'/'||to_char(sysdate,'mm/yyyy')
else to_char(sysdate,'dd/mm/yyyy') end dt_envio_fisico,
case when to_char(sysdate,'dd') between '01' and '12' then to_char('12')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '13' and to_char(sysdate,'D') = '2' then to_char('12')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '13' and to_char(sysdate,'D') <> '2' then to_char('28')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '14' and to_char(sysdate,'D') = '2' then to_char('12')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '14' and to_char(sysdate,'D') <> '2' then to_char('28')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') between '13' and '28' then to_char('28')||'/'||to_char(sysdate,'mm/yyyy')
else to_char(sysdate,'dd/mm/yyyy') end dt_entrega

FROM dbamv.reg_amb ramb
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.atendime atend on atend.cd_atendimento = iramb.cd_atendimento
inner join dbamv.paciente pact on pact.cd_paciente = atend.cd_paciente
inner join dbamv.multi_empresas emp on emp.cd_multi_empresa = atend.cd_multi_empresa
inner join dbamv.empresa_convenio econv on econv.cd_convenio = iramb.cd_convenio and iramb.cd_con_pla = atend.cd_con_pla
inner join dbamv.convenio conv on conv.cd_convenio = econv.cd_convenio
inner join dbamv.itagrupamento iagr on iagr.cd_convenio = iramb.cd_convenio and iagr.cd_ori_ate = atend.cd_ori_ate
inner join dbamv.agrupamento agr on agr.cd_agrupamento = iagr.cd_agrupamento
inner join (select max(cd_protocolo_doc) cd_protocolo_doc, cd_atendimento from it_protocolo_doc group by cd_atendimento) imax on imax.cd_atendimento = iramb.cd_atendimento
inner join dbamv.it_protocolo_doc idoc on idoc.cd_atendimento = iramb.cd_atendimento and idoc.cd_protocolo_doc = imax.cd_protocolo_doc
inner join dbamv.protocolo_doc doc on doc.cd_protocolo_doc = idoc.cd_protocolo_doc

where iramb.cd_convenio in (7,641)
and doc.cd_setor_destino = 3733
and atend.cd_ori_ate = 3
and atend.tp_atendimento = 'E'
and ramb.vl_total_conta <> '0'
and ramb.cd_remessa is null
and idoc.dt_recebimento is not NULL
--and iramb.cd_atendimento = 3881594
--and iramb.sn_fechada = 'N'
AND Trunc(atend.dt_atendimento) BETWEEN Trunc(SYSDATE) -90 AND Trunc(SYSDATE) -1)
)
;
