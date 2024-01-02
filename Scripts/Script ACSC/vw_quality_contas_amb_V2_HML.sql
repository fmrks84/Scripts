------------======= ABAIXO CODIGO VIEW CRIADO CONFORME SOLICITADO POR ANA PAULA ---------
/*QUANDO A CONTA FOR RECEBIDA PELO SETOR 51 (DT_RECEBIMENTO = IS NOT NULL )


*/
------------
select 
distinct 
emp.cd_multi_empresa,
emp.ds_multi_empresa,
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
idoc.dt_recebimento



from
dbamv.reg_amb ramb 
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.atendime atend on atend.cd_atendimento = iramb.cd_atendimento 
inner join dbamv.paciente pact on pact.cd_paciente = atend.cd_paciente
inner join dbamv.multi_empresas emp on emp.cd_multi_empresa = atend.cd_multi_empresa
inner join dbamv.empresa_convenio econv on econv.cd_convenio = iramb.cd_convenio 
                                       and iramb.cd_con_pla = atend.cd_con_pla
inner join dbamv.convenio conv on conv.cd_convenio = econv.cd_convenio         
inner join dbamv.itagrupamento iagr on iagr.cd_convenio = iramb.cd_convenio and iagr.cd_ori_ate = atend.cd_ori_ate
inner join dbamv.agrupamento agr on agr.cd_agrupamento = iagr.cd_agrupamento  
inner join dbamv.it_protocolo_doc idoc on idoc.cd_atendimento = iramb.cd_atendimento   
inner join dbamv.protocolo_doc doc on doc.cd_protocolo_doc = idoc.cd_protocolo_doc                        
where iramb.cd_convenio in (7,641) --- BRADESCO
and doc.cd_setor_destino = 51 ---- 
and atend.cd_ori_ate = 3 -- LABORATORIO ANALISES CLINICAS
and ramb.dt_lancamento > = '01/03/2021' 
and atend.tp_atendimento = 'E'
and ramb.vl_total_conta <> '0'
and ramb.cd_remessa is null
and idoc.dt_recebimento is not null
