select
a.cd_guia cd_guia,
a.nr_guia numero_guia_prestador,
a.cd_atendimento id_Atendimento,
''numero_guia_operadora,
a.cd_senha senha,
a.dt_solicitacao data_solicitacao,
''dt_Agendamento,
a.dt_autorizacao data_autorizacao,
a.dt_validade data_Validade_senha,
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
                                     ,null,'EXTERNO')caracter_atendimento,
decode (d.tp_atendimento,'U','PRONTO_SOCORRO',
                         'A','CONSULTA',
                         'E','EXAMES',
                         'I','INTERNACAO')tipo_atendimento,
case when d.cd_tipo_internacao in (1,3) then 'CLINICA'
             when d.cd_tipo_internacao in (2,4,26,27,28,29,32) then 'CIRURGICA'
             when d.cd_tipo_internacao in (31) then 'OBSTETRICA' end tp_internacao,   
case when d.cd_tip_acom in (3,4,61) 
     then 'HOSPITAL_DIA' else 'HOSPITALAR' 
     end regime_Internacao,   
c.cd_multi_empresa cd_prestador,
e.ds_multi_empresa nm_prestador_autorizado,
a.cd_paciente,
f.nm_paciente,
a.cd_convenio codigo_operadora,
g.nm_convenio nm_operadora,
d.cd_con_pla c_plano,
h.ds_con_pla ds_plano,
d.cd_sub_plano Cd_Sub_Plano,
i.ds_sub_plano ds_sub_plano,
d.cd_prestador id_profissional_solicitante,
j.nm_prestador nm_prestador,
a.nr_dias_solicitados quantidade_diarias_solicitada,
case when upper(h.ds_tip_acom)  like 'ENF%'
     then 'ENFERMARIA'
     when h.ds_tip_acom  like 'UTI%'
     then 'UTI'
     when upper(h.ds_tip_acom) like 'APART%'
     then 'APARTAMENTO'
     when h.ds_tip_acom like 'DAY%'
     then 'HOSPITAL_DIA'
     end tipo_acomodacao,  
case when ts.cd_tip_tuss = 18
     then 'TUSS_TAXAS'
     when ts.cd_tip_tuss = 19
     then 'TUSS_MATERIAIS'
     when ts.cd_tip_tuss = 20
     then 'TUSS_MEDICAMENTOS'
     when ts.cd_tip_tuss = 22
     then 'TUSS_PROCEDIMENTOS'
     when ts.cd_tip_tuss = 98
     then 'PROPRIA_PACOTES'
     when ts.cd_tip_tuss = 00
     then 'PROPRIA_OPERADORAS'
     else ts.ds_tuss
     end ds_tip_tuss,  
--b.cd_pro_fat,   
--ts.cd_tuss cod_tuss,
dbamv.fc_acsc_tuss(c.cd_multi_empresa,
                  b.cd_pro_fat,
                  a.cd_convenio,
                   'COD')COD_TUSS,                 
dbamv.fc_acsc_tuss(c.cd_multi_empresa,
                   b.cd_pro_fat,
                  a.cd_convenio,
                   'DESC')DS_TUSS, 
---ts.ds_tuss ds_tuss,                           
b.qt_autorizado quantidade_Solicitada,
trunc(b.dt_geracao) dh_solicitado                         
from 
dbamv.guia a 
inner join dbamv.it_guia b on b.cd_guia = a.cd_guia
inner join dbamv.empresa_convenio c on c.cd_convenio = a.cd_convenio
left join dbamv.atendime d on d.cd_atendimento = a.cd_atendimento
inner join dbamv.multi_empresas e on e.cd_multi_empresa = c.cd_multi_empresa
inner join dbamv.paciente f on f.cd_paciente = a.cd_paciente
inner join dbamv.convenio g on g.cd_convenio = a.cd_convenio
left join dbamv.con_pla h on h.cd_con_pla = d.cd_con_pla and h.cd_convenio = c.cd_convenio
left join dbamv.sub_plano i on i.cd_sub_plano = d.Cd_Sub_Plano and d.cd_con_pla  = i.cd_con_pla 
left join dbamv.prestador j on j.cd_prestador = d.cd_prestador
left join dbamv.tip_acom h on h.cd_tip_acom = d.cd_tip_acom
left join dbamv.tuss ts on ts.cd_pro_fat = b.cd_pro_fat and ts.cd_multi_empresa is null 
                                                            and (ts.cd_convenio is null or ts.cd_convenio is not null) 
;

--grant execute on dbamv.fc_acsc_tuss to ensemble ; 
