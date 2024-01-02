select 
distinct 
ramb.cd_reg_amb id_Conta,
guia1.nr_guia numero_guia_prestador,
case when guia1.tp_guia = 'I' then 'INTERNACAO' 
    when guia1.tp_guia = 'S' then 'SADT'
    when guia1.tp_guia = 'O' then 'OPME'
    when guia1.tp_guia = 'P' then 'PROCEDIMENTO'
end tipo_Guia,
ramb.cd_multi_empresa id_prestador,
emp1.ds_multi_empresa nm_prestador,
iramb.cd_convenio id_operadora,
conv1.nm_convenio nm_operadora,
econv1.cd_hospital_no_convenio cd_prestador_operadora,
iramb.cd_atendimento id_atendimento,
guia1.cd_guia id_autorizacao,
'TOTAL'tipo_Faturamento,
''Sequencial_parcial,
atend1.hr_atendimento Data_Abertura,
iramb.dt_fechamento Data_fechamento,
decode (iramb.sn_fechada,'S','true','N','false')SN_FECHADA, 
ramb.cd_remessa id_remessa,
'true'bloqueada, 
--''id_lote,
tmsg.nr_lote id_lote,
''Data_Cadastro,
''Responsavel_Cadastro ,  
''Data_Atualizacao,
''Responsavel_Atualizacao 
from
dbamv.reg_amb ramb 
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.multi_empresas emp1 on emp1.cd_multi_empresa = ramb.cd_multi_empresa
inner join dbamv.atendime atend1 on atend1.cd_atendimento = iramb.cd_atendimento
left join dbamv.guia guia1 on guia1.cd_guia  = atend1.cd_guia 
inner join dbamv.empresa_convenio econv1 on econv1.cd_convenio = iramb.cd_convenio and econv1.cd_multi_empresa = ramb.cd_multi_empresa
inner join dbamv.convenio conv1 on conv1.cd_convenio = econv1.cd_convenio
left join dbamv.tiss_mensagem tmsg on to_char(tmsg.nr_documento) = to_char(ramb.cd_remessa)
