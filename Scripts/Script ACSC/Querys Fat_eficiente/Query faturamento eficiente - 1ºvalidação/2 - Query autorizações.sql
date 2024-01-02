select distinct
       a.cd_guia id_guia,
       a.nr_guia numero_guia_prestador,
       a.cd_atendimento id_Atendimento,
       b.nr_guia_operadora,
       a.cd_senha senha,
       a.dt_solicitacao data_solicitacao,
       ''dt_Agendamento,
       a.dt_autorizacao data_autorizacao,
       a.dt_validade data_validade_senha,
       decode (a.tp_guia,'C','CONSULTA',
                         'D','RADIOTERAPIA',
                         'I','INTERNACAO',
                         'M','MEDICAMENTOS',
                         'O','OPME',
                         'P','PROCEDIMENTO',
                         'Q','QUIMIOTERAPIA',
                         'R','PRORROGACAO',
                         'S','SADT',
                         'T','MATERIAIS')tipo_guia,


       decode(d.tp_carater_internacao,'U','URGENCIA_EMERGENCIA'
                                     ,'E','ELETIVO'
                                     ,null,'Externo')caracter_atendimento,
       decode (d.tp_atendimento,'U','URGENCIA',
                                'A','AMBULATORIO',
                                'E','EXTERNO',
                                'I','INTERNACAO')tipo_atendimento,

       decode(b.cd_tipo_internacao,'1','CLINICA',
                                   null,'CLINICA',
                                   '2','CIRURGICA',
                                   '3','OBSTETRICA',
                                   '4','PEDIATRICA',
                                   '5','PSIQUIATRICA')tipo_internacao,
       decode (b.tp_regime_internacao,'1','HOSPITALAR',
                                      NULL,'HOSPITALAR',
                                      '2','HOSPITAL_DIA',
                                      '3','DOMICILIAR')regime_internacao,

       d.cd_multi_empresa id_prestador, 
       i.ds_multi_empresa nm_prestador,  
       a.cd_paciente id_paciente,
       b.nm_paciente nm_paciente,
       a.cd_convenio id_operadora,
       conv.nm_convenio,
       d.cd_con_pla id_plano,
       f.ds_con_pla nm_plano,
       d.Cd_Sub_Plano id_sub_plano ,
       h.ds_sub_plano nm_sub_plano, 
       d.cd_prestador id_profissional, 
       b.nm_prestador nm_profissional,
       b.qt_diarias_solicitada quantidade_solicitada,
      case
        when upper(e.ds_tip_acom)  like 'ENF%' then 'ENFERMARIA'
        when e.ds_tip_acom  like 'UTI%' then 'UTI'
        when upper(e.ds_tip_acom) like 'APART%' then 'APARTAMENTO'
        when e.ds_tip_acom like 'DAY%' then 'HOSPITAL_DIA'
         end tipo_acomodacao,
    
      case
       when tts.cd_tip_tuss = 18 then 'TUSS_TAXAS'
       when tts.cd_tip_tuss = 19 then 'TUSS_MATERIAIS'
       when tts.cd_tip_tuss = 20 then 'TUSS_MEDICAMENTOS'
       when tts.cd_tip_tuss = 22 then 'TUSS_PROCEDIMENTOS'
       when tts.cd_tip_tuss = 98 then 'PROPRIA_PACOTES'
       when tts.cd_tip_tuss = 00 then 'PROPRIA_OPERADORAS'
       else tts.ds_tip_tuss
       end codigo_tabela, 
       c.cd_procedimento codigo_tuss,
       UPPER(c.ds_procedimento) descricao_tuss,
       c.qt_solicitada quantidade_Solicitada,
       trunc(b.dh_solicitado)data_cadastro,
       ''data_Cadastro,
       ''responsavel_cadastro,
       ''data_atualizacao,
       ''responsavel_atualizacao
      
from dbamv.guia a
inner join dbamv.tiss_sol_guia b on b.cd_guia = a.cd_guia
inner join dbamv.tiss_itsol_guia c on c.id_pai = b.id
left join dbamv.atendime d on d.cd_atendimento = a.cd_atendimento
inner join dbamv.multi_empresas i on i.cd_multi_empresa = d.cd_multi_empresa
left join dbamv.tip_acom e on e.cd_tip_acom = d.cd_tip_acom  
inner join dbamv.convenio conv on conv.cd_convenio  = a.cd_convenio and conv.cd_convenio
inner join dbamv.con_pla f on f.cd_con_pla = d.cd_con_pla and f.cd_convenio = d.cd_convenio
inner join dbamv.empresa_con_pla g on g.cd_con_pla = f.cd_con_pla and g.cd_convenio = f.cd_convenio
inner join dbamv.tip_tuss tts on tts.cd_tip_tuss = c.tp_tab_fat
left join dbamv.sub_plano h on h.cd_convenio = g.cd_convenio and h.cd_con_pla = g.cd_con_pla and h.cd_sub_plano = d.cd_sub_plano;
