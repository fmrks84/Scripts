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
decode (rf.sn_fechada,'S','true','N','false')sn_fechada, 
rf.cd_remessa id_remessa ,
case when rf.sn_importa_auto = 'S'
     then 'true' else 'false'
   end bloqueada , 
tmsg.nr_lote id_lote,
--''id_lote,
''DataCadastro,
''ResponsavelCadastro ,  
''DataAtualizacao,
''ResponsavelAtualizacao 
from
dbamv.reg_Fat rf 
inner join dbamv.multi_empresas emp on emp.cd_multi_empresa = rf.cd_multi_empresa
inner join dbamv.atendime atend on atend.cd_atendimento = rf.cd_atendimento
left join dbamv.guia guia on guia.cd_guia = atend.cd_guia 
inner join dbamv.empresa_convenio econv on econv.cd_convenio = rf.cd_convenio and econv.cd_multi_empresa = rf.cd_multi_empresa
inner join dbamv.convenio conv on conv.cd_convenio = econv.cd_convenio
left join dbamv.tiss_mensagem tmsg on to_char(tmsg.nr_documento) = to_char(rf.cd_remessa)
