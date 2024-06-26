select
rf.cd_reg_fat ID_CONTA,
guia.nr_guia numero_guia_prestador,
case when guia.tp_guia = 'I' then 'INTERNACAO' 
     when guia.tp_guia = 'S' then 'SADT'
     when guia.tp_guia = 'O' then 'OPME'
     when guia.tp_guia = 'P' then 'PROCEDIMENTO'
end tipo_Guia,
rf.cd_multi_empresa id_prestador,
emp.ds_multi_empresa nm_prestador,
rf.cd_convenio id_operadora,
conv.nm_convenio nm_operadora,
econv.cd_hospital_no_convenio cd_prestador_operadora,
rf.cd_atendimento id_atendimento,
guia.cd_guia id_autorizacao,
case when rf.tp_classificacao_conta = 'P'
     then 'PARCIAL'
     when rf.tp_classificacao_conta = 'C'    
     then 'COMPLEMENTAR'
     when rf.tp_classificacao_conta = 'N'    
     then 'TOTAL'
END Tipo_Faturamento,
''sequencial_parcial,
rf.dt_inicio data_Abertura,
rf.dt_fechamento data_fechamento,
decode (rf.sn_fechada,'S','TRUE','N','FALSE')sn_fechada, 
rf.cd_remessa id_remessa ,
case when rf.sn_importa_auto = 'S'
     then 'true' else 'false'
	 end bloqueada , 
''id_lote,
''DataCadastro,
''ResponsavelCadastro ,  
''DataAtualizacao,
''ResponsavelAtualizacao 
from
dbamv.reg_Fat rf 
inner join dbamv.multi_empresas emp on emp.cd_multi_empresa = rf.cd_multi_empresa
inner join dbamv.atendime atend on atend.cd_atendimento = rf.cd_atendimento
inner join dbamv.guia guia on guia.cd_guia = atend.cd_guia 
inner join dbamv.empresa_convenio econv on econv.cd_convenio = rf.cd_convenio and econv.cd_multi_empresa = rf.cd_multi_empresa
inner join dbamv.convenio conv on conv.cd_convenio = econv.cd_convenio 
where atend.cd_atendimento in (2370063,2370064)  

union all

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
decode (iramb.sn_fechada,'S','TRUE','N','FALSE')SN_FECHADA, 
ramb.cd_remessa id_remessa,
'true'bloqueada, 
''id_lote,
''Data_Cadastro,
''Responsavel_Cadastro ,  
''Data_Atualizacao,
''Responsavel_Atualizacao 
from
dbamv.reg_amb ramb 
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.multi_empresas emp1 on emp1.cd_multi_empresa = ramb.cd_multi_empresa
inner join dbamv.atendime atend1 on atend1.cd_atendimento = iramb.cd_atendimento
inner join dbamv.guia guia1 on guia1.cd_guia  = atend1.cd_guia 
inner join dbamv.empresa_convenio econv1 on econv1.cd_convenio = iramb.cd_convenio and econv1.cd_multi_empresa = ramb.cd_multi_empresa
inner join dbamv.convenio conv1 on conv1.cd_convenio = econv1.cd_convenio
where iramb.cd_atendimento in (2370063,2370064)
