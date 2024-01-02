/*create or replace view dbamv_vw_redesc_quality_rp015 as
(*/
SELECT
distinct
cd_multi_empresa,
ds_multi_empresa,
cd_convenio,
nm_convenio,
cd_remessa,
case when tp_transacao is null then 'AGUARD_GERA_XML'
     else tp_transacao
     end tp_transacao


FROM (
SELECT DISTINCT
t.tp_transacao,
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


case when to_char(sysdate,'dd') between '01' and '10' then to_char('10')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '11' and to_char(sysdate,'D') = '2' then to_char('10')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '11' and to_char(sysdate,'D') <> '2' then to_char('25')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '12' and to_char(sysdate,'D') = '2' then to_char('10')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '12' and to_char(sysdate,'D') <> '2' then to_char('25')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') between '13' and '25' then to_char('25')||'/'||to_char(sysdate,'mm/yyyy')
else to_char(sysdate,'dd/mm/yyyy') end dt_fechamento,
case when to_char(sysdate,'dd') between '01' and '10' then to_char('10')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '11' and to_char(sysdate,'D') = '2' then to_char('10')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '11' and to_char(sysdate,'D') <> '2' then to_char('25')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '12' and to_char(sysdate,'D') = '2' then to_char('10')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '12' and to_char(sysdate,'D') <> '2' then to_char('25')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') between '13' and '25' then to_char('25')||'/'||to_char(sysdate,'mm/yyyy')
else to_char(sysdate,'dd/mm/yyyy') end dt_envio_fisico,
case when to_char(sysdate,'dd') between '01' and '10' then to_char('10')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '11' and to_char(sysdate,'D') = '2' then to_char('10')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '11' and to_char(sysdate,'D') <> '2' then to_char('25')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '12' and to_char(sysdate,'D') = '2' then to_char('10')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') = '12' and to_char(sysdate,'D') <> '2' then to_char('25')||'/'||to_char(sysdate,'mm/yyyy')
when to_char(sysdate,'dd') between '13' and '25' then to_char('25')||'/'||to_char(sysdate,'mm/yyyy')
else to_char(sysdate,'dd/mm/yyyy') end dt_entrega

FROM dbamv.reg_amb ramb
inner join dbamv.itreg_amb        iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.atendime         atend on atend.cd_atendimento = iramb.cd_atendimento
inner join dbamv.paciente          pact on pact.cd_paciente = atend.cd_paciente
inner join dbamv.multi_empresas     emp on emp.cd_multi_empresa = atend.cd_multi_empresa
inner join dbamv.empresa_convenio econv on econv.cd_convenio = iramb.cd_convenio and iramb.cd_con_pla = atend.cd_con_pla
inner join dbamv.convenio          conv on conv.cd_convenio = econv.cd_convenio
inner join dbamv.itagrupamento     iagr on iagr.cd_convenio = iramb.cd_convenio and iagr.cd_ori_ate = atend.cd_ori_ate
inner join dbamv.agrupamento        agr on agr.cd_agrupamento = iagr.cd_agrupamento
inner join (select max(cd_protocolo_doc) cd_protocolo_doc, cd_atendimento from it_protocolo_doc group by cd_atendimento) imax on imax.cd_atendimento = iramb.cd_atendimento
inner join dbamv.it_protocolo_doc  idoc on idoc.cd_atendimento = iramb.cd_atendimento and idoc.cd_protocolo_doc = imax.cd_protocolo_doc
inner join dbamv.protocolo_doc      doc on doc.cd_protocolo_doc = idoc.cd_protocolo_doc
inner join dbamv.remessa_fatura     rem on rem.cd_remessa = ramb.cd_remessa  --vinculo_remessa
left join dbamv.tiss_mensagem         t on t.cd_convenio = ramb.cd_convenio AND T.NR_DOCUMENTO = TO_CHAR(REM.CD_REMESSA)
                                  

where iramb.cd_convenio in (7,641)
and   doc.cd_setor_destino = 3733
and   atend.cd_ori_ate = 3
and   atend.tp_atendimento = 'E'
and   ramb.vl_total_conta <> '0'
and   ramb.cd_remessa is not null -- condição de conta somente com remessa
and   rem.sn_fechada = 'S' -- remessa fechada
and   idoc.dt_recebimento is not NULL
--and   ramb.cd_remessa in ('299276','314582')
and t.tp_transacao is null
--and   (t.tp_transacao = 'ENVIO_LOTE_GUIAS' or t.tp_transacao is null)
and   Trunc(atend.dt_atendimento) BETWEEN Trunc(SYSDATE) -90 AND Trunc(SYSDATE) -1)
--where cd_remessa = '315588'
--grant select on dbamv_vw_redesc_quality_rp015 TO DBAMV;
/*);
grant select on dbamv_vw_redesc_quality_rp013 TO victor_rpa;
grant select on dbamv_vw_redesc_quality_rp015 TO DBAMV;
*/

/*select * 
from tiss_mensagem t 
left join remessa_fatura r on r.cd_remessa = t.nr_documento
where t.nr_documento in ('299276','314582') 
and t.tp_transacao = 'ENVIO_LOTE_GUIAS'
*/

--SELECT * FROM ITAGRUPAMENTO TP WHERE TP.CD_CONVENIO = 7 AND TP.CD_ORI_ATE = 3
--315598,315594,315592,315580,315579,315579,315581,315588,315582


--select * from tiss_mensagem where cd_convenio in (7,641) and tp_transacao = 'ENVIO_LOTE_GUIAS'  order by 3 desc 
