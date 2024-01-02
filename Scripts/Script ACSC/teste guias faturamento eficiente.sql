select distinct
       a.cd_guia ID,
       a.nr_guia numero_guia_prestador,
       a.cd_atendimento id_Atendimento,
       b.nr_guia_operadora,
       a.cd_senha senha,
       a.dt_solicitacao data_solicitacao,
       ''dt_Agendamento, ----
       a.dt_autorizacao data_autorizacao,
       a.dt_validade data_Validade_senha,
       decode (a.tp_guia,'C','Consulta',
                         'D','Radioterapia',
                         'I','Internacao',
                         'M','Medicamentos',
                         'O','OPME',
                         'P','Procedimento',
                         'Q','Quimioterapia',
                         'R','Prorrogação',
                         'S','SADT',
                         'T','Materiais')tipo_guia,
                         
                         
       decode(d.tp_carater_internacao,'U','Urgencia/Emergencia'
                                     ,'E','Eletivo'
                                     ,null,'Externo')caracter_atendimento,
       decode (d.tp_atendimento,'U','Urgência',
                                'A','Ambulatorio',
                                'E','Externo',
                                'I','Internação')tipo_atendimento,
                                
       decode(b.cd_tipo_internacao,'1','Clinica',
                                   '2','Cirurgica',
                                   '3','Obstetrica',
                                   '4','Pediatrica',
                                   '5','Psiquiatrica')tipo_internacao,
       decode (b.tp_regime_internacao,'1','Hospitalar',
                                      '2','Hospital Dia',
                                      '3','Domiciliar')regime_internacao,
       b.cd_operadora_autorizado id_prestador,
       b.nm_prestador_autorizado,
       a.cd_paciente id_paciente,
       b.nm_paciente,
       d.cd_con_pla id_plano,
       f.ds_con_pla ds_plano,
       d.Cd_Sub_Plano ,
       ''ds_sub_plano,
       d.cd_prestador id_profissional_solicitante,
       b.nm_prestador,
       b.qt_diarias_solicitada quantidade_solicitada,
       e.ds_tip_acom tipo_acomodacao,
       c.tp_tab_fat codigo_Tabela,
       c.cd_procedimento codigo,
       c.ds_procedimento descricao,
       c.qt_solicitada quantidade_Solicitada,
       trunc(b.dh_solicitado)
       
       
       
       
       
from dbamv.guia a
inner join dbamv.tiss_sol_guia b on b.cd_guia = a.cd_guia
inner join dbamv.tiss_itsol_guia c on c.id_pai = b.id
left join dbamv.atendime d on d.cd_atendimento = a.cd_atendimento
inner join dbamv.tip_acom e on e.cd_tip_acom = d.cd_tip_acom
inner join dbamv.con_pla f on f.cd_con_pla = d.cd_con_pla and f.cd_convenio = d.cd_convenio
inner join dbamv.empresa_con_pla g on g.cd_con_pla = f.cd_con_pla and g.cd_convenio = f.cd_convenio
left join dbamv.sub_plano h on h.cd_convenio = g.cd_convenio and h.cd_con_pla = g.cd_con_pla
where 1= 1 --d.cd_atendimento = 2116968


---and s


--SELECT * FROM DBAMV.GUIA WHERE CD_GUIA = 2116968
--select * from dbamv.tiss_sol_guia where cd_guia = 2116968
