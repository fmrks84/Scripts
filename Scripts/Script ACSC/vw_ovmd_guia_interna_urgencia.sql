create or replace view vw_ovmd_guia_interna_urgencia as
select r.cd_multi_empresa,
             t.cd_guia,
             a.cd_guia id,
             a.cd_convenio,
             mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO', 
                                              r.cd_multi_empresa ,
                                              'OVERMIND', 
                                              a.cd_convenio ,NULL)cd_convenio_ovm,
             t.nr_registro_operadora_ans,
             t.nm_paciente,
             t.nr_carteira,
             t.nm_prestador,
             t.ds_codigo_conselho,
             decode(r.cd_multi_empresa,3,'RJ',4,'RJ',10,'RJ',7,'SP') uf_conselho,
             t.cd_cbos,
             t.ds_hda ds_indicacao,
             decode(t.cd_carater_solicitacao,'E','Eletiva','U','Urgência') ds_carater,
             decode(t.cd_tipo_internacao,'1','Clinica','2','Cirúrgica','3','Obstetrica',t.cd_tipo_internacao) cd_tipo_internacao,
             t.cd_cid,
             it.cd_procedimento,
             it.ds_procedimento,
             it.qt_solicitada,
             decode(t.tp_regime_internacao,'1','Hospitalar','2','Hospital-dia','3','Domiciliar')tp_regime_internacao,
             t.dt_sugerida_internacao,
             t.sn_previsao_uso_opme,
             t.cd_documento_clinico,
             a.cd_atendimento,
             to_char(a.dt_solicitacao, 'DD/MM/YYYY') dt_atendimento,
             l.ds_tip_acom,
             null url,
             (select 'X' from dbamv.pro_fat profat
             where profat.cd_pro_Fat = it.cd_pro_fat
             and   profat.cd_gru_pro = 1) diaria,
             nvl(t.qt_diarias_solicitada,1) qt_diarias_solicitada,
             'Internacao'Origem_pedido,  -- incluido 19-01-2021
             'Internacao'tipo_solicitacao -- incluido 19-01-2021
      from
           dbamv.guia a,
           dbamv.tip_acom l,
           dbamv.tiss_sol_guia t,
           dbamv.tiss_itsol_guia it,
           --dbamv.prestador p
           dbamv.res_lei r
      where a.cd_guia = t.cd_guia
      and  t.id = it.id_pai
      and  a.cd_tip_acom(+) = l.cd_tip_acom
      and  a.cd_res_lei = r.cd_res_lei
      and  trunc(a.dt_geracao) = trunc(sysdate)
      and  a.cd_convenio in(7,12,5,11,22,32,23,34,50,13,38,39,8,9)
      and  r.cd_aviso_cirurgia is null
      and  a.cd_atendimento is null
--------------------------------
union all
--------------------------------
select r.cd_multi_empresa,
       t.cd_guia,
       a.cd_guia id,
       a.cd_convenio,
       mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO', 
                                              r.cd_multi_empresa ,
                                              'OVERMIND', 
                                              a.cd_convenio ,NULL)cd_convenio_ovm,
       t.nr_registro_operadora_ans,
       t.nm_paciente,
       t.nr_carteira,
       t.nm_prestador,
       t.ds_codigo_conselho,
       decode(r.cd_multi_empresa,3,'RJ',4,'RJ',10,'RJ',7,'SP') uf_conselho,
       t.cd_cbos,
       t.ds_hda ds_indicacao,
       decode(t.cd_carater_solicitacao,'E','Eletiva','U','Urgência') ds_carater,
       decode(t.cd_tipo_internacao,'1','Clinica','2','Cirúrgica','3','Obstetrica',t.cd_tipo_internacao) cd_tipo_internacao,
       t.cd_cid,
       case when a.cd_tip_acom in (select cd_tip_acom from tip_acom where tp_acomodacao = 'U') then '10104020' else '28002' end cd_procedimento,
       it.ds_procedimento,
       it.qt_solicitada,
       decode(t.tp_regime_internacao,'1','Hospitalar','2','Hospital-dia','3','Domiciliar')tp_regime_internacao,
       t.dt_sugerida_internacao,
       t.sn_previsao_uso_opme,
       t.cd_documento_clinico,
       a.cd_atendimento,
       to_char(a.dt_solicitacao,'dd/mm/yyyy') dt_atendimento,
       l.ds_tip_acom,
       null url,
       (select 'X' from dbamv.pro_fat profat
       where profat.cd_pro_Fat = it.cd_pro_fat
       and   profat.cd_gru_pro = 1) diaria,
       nvl(t.qt_diarias_solicitada,1) qt_diarias_solicitada,
       'Internacao'Origem_pedido,  -- incluido 19-01-2021
       'Internacao'tipo_solicitacao -- incluido 19-01-2021
from
     dbamv.guia a,
     dbamv.tip_acom l,
     dbamv.tiss_sol_guia t,
     dbamv.tiss_itsol_guia it,
     --dbamv.prestador p
     dbamv.res_lei r
where a.cd_guia = t.cd_guia
and  t.id = it.id_pai
and  a.cd_tip_acom(+) = l.cd_tip_acom
and  a.cd_res_lei = r.cd_res_lei
and  trunc(a.dt_geracao) = trunc(sysdate)
and  a.cd_convenio in(41)
and  r.cd_aviso_cirurgia is null
and  a.cd_atendimento is null
--------------------------------
union all
--------------------------------
select r.cd_multi_empresa,
       t.cd_guia,
       a.cd_guia id,
       a.cd_convenio,
       mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO', 
                                              r.cd_multi_empresa ,
                                              'OVERMIND', 
                                              a.cd_convenio ,NULL)cd_convenio_ovm,
       t.nr_registro_operadora_ans,
       t.nm_paciente,
       t.nr_carteira,
       t.nm_prestador,
       t.ds_codigo_conselho,
       decode(r.cd_multi_empresa,3,'RJ',4,'RJ',10,'RJ',7,'SP') uf_conselho,
       t.cd_cbos,
       t.ds_hda ds_indicacao,
       decode(t.cd_carater_solicitacao,'E','Eletiva','U','Urgência') ds_carater,
       decode(t.cd_tipo_internacao,'1','Clinica','2','Cirúrgica','3','Obstetrica',t.cd_tipo_internacao) cd_tipo_internacao,
       t.cd_cid,
       to_Char(64430090) cd_procedimento,
       it.ds_procedimento,
       it.qt_solicitada,
       decode(t.tp_regime_internacao,'1','Hospitalar','2','Hospital-dia','3','Domiciliar')tp_regime_internacao,
       t.dt_sugerida_internacao,
       t.sn_previsao_uso_opme,
       t.cd_documento_clinico,
       a.cd_atendimento,
       to_char(a.dt_solicitacao,'dd/mm/yyyy') dt_atendimento,
       l.ds_tip_acom,
       null url,
       (select 'X' from dbamv.pro_fat profat
       where profat.cd_pro_Fat = it.cd_pro_fat
       and   profat.cd_gru_pro = 1) diaria,
       nvl(t.qt_diarias_solicitada,1) qt_diarias_solicitada,
       'Internacao'Origem_pedido,  -- incluido 19-01-2021
       'Internacao'tipo_solicitacao -- incluido 19-01-2021
from
     dbamv.guia a,
     dbamv.tip_acom l,
     dbamv.tiss_sol_guia t,
     dbamv.tiss_itsol_guia it,
     --dbamv.prestador p
     dbamv.res_lei r
where a.cd_guia = t.cd_guia
and  t.id = it.id_pai
and  a.cd_tip_acom(+) = l.cd_tip_acom
and  a.cd_res_lei = r.cd_res_lei
and  trunc(a.dt_geracao) = trunc(sysdate)
and  a.cd_convenio in(48)
and  r.cd_aviso_cirurgia is null
and  a.cd_atendimento is null
);


