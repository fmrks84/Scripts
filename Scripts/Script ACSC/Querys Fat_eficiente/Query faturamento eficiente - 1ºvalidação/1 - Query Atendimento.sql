SELECT atendime.cd_atendimento id_atendimento,
       atendime.nr_carteira numero_carteira,
       ensemble.fnc_data_hora(atendime.dt_atendimento, atendime.hr_atendimento) data_atendimento,
       ensemble.fnc_data_hora(atendime.dt_alta, atendime.hr_alta) data_alta,
       case when atendime.tp_atendimento = 'I' then 'INTERNACAO' 
            when atendime.tp_atendimento in ('U','E') then 'SADT' 
            when atendime.tp_atendimento in ('C','A') then 'CONSULTA' END tipo_guia,
       case when atendime.tp_carater_internacao in ('E',null) then 'ELETIVO' else 'URGENCIA_EMERGENCIA'end carater_Atendimento,     
       decode(tp_atendimento,'I','INTERNACAO','U','PRONTO SOCORRO','E','EXAME AMBULATORIAL','A','CONSULTA')tipo_Atendimento,   
       case when atendime.cd_tipo_internacao in (1,3) then 'CLINICA'
            when atendime.cd_tipo_internacao in (2,4,26,27,28,29,32) then 'CIRURGICA'
            when atendime.cd_tipo_internacao in (31) then 'OBSTETRICA' end tipo_internacao,
       case when atendime.cd_tip_acom in (3,4,61) then 'HOSPITAL_DIA' else 'HOSPITALAR' end regime_Internacao,      
       case when (SYSDATE - paciente.dt_nascimento) <= 28 then 'TRUE' else 'false' end atendimento_RN,     
       atendime.cd_multi_empresa id_prestador,      
       multi_empresas.ds_multi_empresa nm_prestador,
       atendime.id_operadora,
       convenio.nm_operadora,
       atendime.id_paciente,
       paciente.nm_paciente,
       atendime.cd_con_pla id_plano,
       con_pla.ds_con_pla nm_plano,
       atendime.cd_sub_plano id_sub_plano,
       sub_plano.ds_sub_plano nm_sub_plano, 
       ''data_Cadastro,
       ''responsavel_cadastro,
       ''data_atualizacao,
       ''responsavel_atualizacao
   FROM dbamv.atendime,
        dbamv.paciente,
        dbamv.prestador,
        dbamv.convenio,
        dbamv.con_pla,
        dbamv.sub_plano,
        dbamv.multi_empresas
WHERE convenio.tp_convenio = 'C'
  AND atendime.cd_convenio = convenio.cd_convenio
  AND paciente.cd_paciente = atendime.cd_paciente
  AND prestador.cd_prestador = atendime.cd_prestador
  AND convenio.cd_convenio = con_pla.cd_convenio
  AND con_pla.cd_convenio = sub_plano.cd_convenio(+)
  AND con_pla.cd_con_pla = sub_plano.cd_con_pla(+)
  AND atendime.cd_sub_plano = sub_plano.cd_sub_plano(+)
  AND atendime.cd_con_pla = con_pla.cd_con_pla
  and atendime.cd_multi_empresa = multi_empresas.cd_multi_empresa;
