select 
cd_multi_empresa,
             cd_guia,
             id,
             cd_convenio,
             CD_CONVENIO_OVM,
             nr_registro_operadora_ans,
             nm_paciente,
             nr_carteira,
             nm_prestador,
             ds_codigo_conselho,
             uf_conselho,
             cd_cbos,
             ds_indicacao,
             ds_carater,
             cd_tipo_internacao,
             cd_cid,
             cd_procedimento,
             ds_procedimento,
             qt_solicitada,
             tp_regime_internacao,
             dt_sugerida_internacao,
             sn_previsao_uso_opme,
             cd_documento_clinico,
             cd_atendimento,
             dt_atendimento,
             ds_tip_acom,
             url,
             diaria,
             qt_diarias_solicitada,
             Origem_pedido,  
             tipo_solicitacao, 
             DE_PARA_MV,
             OVM 

from
(
select 
             cd_multi_empresa,
             cd_guia,
             id,
             cd_convenio,
             CD_CONVENIO_OVM,
             nr_registro_operadora_ans,
             nm_paciente,
             nr_carteira,
             nm_prestador,
             ds_codigo_conselho,
             uf_conselho,
             cd_cbos,
             ds_indicacao,
             ds_carater,
             cd_tipo_internacao,
             cd_cid,
             cd_procedimento,
             ds_procedimento,
             qt_solicitada,
             tp_regime_internacao,
             dt_sugerida_internacao,
             sn_previsao_uso_opme,
             cd_documento_clinico,
             cd_atendimento,
             dt_atendimento,
             ds_tip_acom,
             url,
             diaria,
             qt_diarias_solicitada,
             Origem_pedido,  -- incluido 19-01-2021
             tipo_solicitacao, -- incluido 19-01-2021
             DE_PARA_MV,
             OVM 

from
 (
select      
            r.cd_multi_empresa,
             t.cd_guia,
             a.cd_guia id,
             a.cd_convenio,
             ovm.cd_depara_integra CD_CONVENIO_OVM,
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
             TO_date(a.dt_solicitacao, 'DD/MM/YYYY') dt_atendimento,
             l.ds_tip_acom,
             null url,
             (select 'X' from dbamv.pro_fat profat
             where profat.cd_pro_Fat = it.cd_pro_fat
             and   profat.cd_gru_pro = 1) diaria,
             nvl(t.qt_diarias_solicitada,1) qt_diarias_solicitada,
             'Internacao'Origem_pedido,  -- incluido 19-01-2021
             'Internacao'tipo_solicitacao, -- incluido 19-01-2021
             'OVERMIND'DE_PARA_MV,
             ovm.cd_sistema_integra OVM 
      from
           dbamv.guia a,
           dbamv.tip_acom l,
           dbamv.tiss_sol_guia t,
           dbamv.tiss_itsol_guia it,
           dbamv.res_lei r,
          mvintegra.depara ovm
      where a.cd_guia = t.cd_guia
      and  t.id = it.id_pai
      and  a.cd_tip_acom(+) = l.cd_tip_acom
      and  a.cd_res_lei = r.cd_res_lei
      and  ovm.cd_multi_empresa = r.cd_multi_empresa
     and  ovm.cd_depara_mv = a.cd_convenio
     --and  trunc(a.dt_geracao) = trunc(sysdate)
      and  a.cd_convenio in(7,12,5,11,22,32,23,34,50,13,38,39,8,9)
      and  r.cd_aviso_cirurgia is null
      and  a.cd_atendimento is null
)where OVM = DE_PARA_MV 

union all

select 
cd_multi_empresa,
cd_guia,
id,
cd_convenio,
CD_CONVENIO_OVM,
nr_registro_operadora_ans,
nm_paciente,
nr_carteira,
nm_prestador,
ds_codigo_conselho,
uf_conselho,
cd_cbos,
ds_indicacao,
ds_carater,
cd_tipo_internacao,
cd_cid,
cd_procedimento,
ds_procedimento,
qt_solicitada,
tp_regime_internacao,
dt_sugerida_internacao,
sn_previsao_uso_opme,
cd_documento_clinico,
cd_atendimento,
dt_atendimento,
ds_tip_acom,
url,
diaria,
qt_diarias_solicitada,
Origem_pedido,  
tipo_solicitacao, 
DE_PARA_MV,
OVM 
from
(
select r.cd_multi_empresa,
       t.cd_guia,
       a.cd_guia id,
       a.cd_convenio,
       ovm.cd_depara_integra CD_CONVENIO_OVM,
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
       to_date(a.dt_solicitacao,'dd/mm/yyyy') dt_atendimento,
       l.ds_tip_acom,
       null url,
       (select 'X' from dbamv.pro_fat profat
       where profat.cd_pro_Fat = it.cd_pro_fat
       and   profat.cd_gru_pro = 1) diaria,
       nvl(t.qt_diarias_solicitada,1) qt_diarias_solicitada,
       'Internacao'Origem_pedido, 
       'Internacao'tipo_solicitacao, 
       'OVERMIND'DE_PARA_MV,
        ovm.cd_sistema_integra OVM 
from
     dbamv.guia a,
     dbamv.tip_acom l,
     dbamv.tiss_sol_guia t,
     dbamv.tiss_itsol_guia it,
     dbamv.res_lei r,
     mvintegra.depara ovm
where a.cd_guia = t.cd_guia
and  t.id = it.id_pai
and  a.cd_tip_acom(+) = l.cd_tip_acom
and  a.cd_res_lei = r.cd_res_lei
and  ovm.cd_multi_empresa = r.cd_multi_empresa
and  ovm.cd_depara_mv = a.cd_convenio
--and  to_char(a.dt_geracao,'dd/mm/yyyy') = to_char(sysdate,'dd/mm/yyyy')
--and  a.tp_atendimento = 'I'
and  a.cd_convenio in(41)
and  r.cd_aviso_cirurgia is null
and  a.cd_atendimento is null    
) where OVM = DE_PARA_MV     

union all 

select 
cd_multi_empresa,
cd_guia,
id,
cd_convenio,
CD_CONVENIO_OVM,
nr_registro_operadora_ans,
nm_paciente,
nr_carteira,
nm_prestador,
ds_codigo_conselho,
uf_conselho,
cd_cbos,
ds_indicacao,
ds_carater,
cd_tipo_internacao,
cd_cid,
cd_procedimento,
ds_procedimento,
qt_solicitada,
tp_regime_internacao,
dt_sugerida_internacao,
sn_previsao_uso_opme,
cd_documento_clinico,
cd_atendimento,
dt_atendimento,
ds_tip_acom,
url,
diaria,
qt_diarias_solicitada,
Origem_pedido,  
tipo_solicitacao, 
DE_PARA_MV,
OVM 

from
(
select r.cd_multi_empresa,
       t.cd_guia,
       a.cd_guia id,
       a.cd_convenio,
       ovm.cd_depara_integra CD_CONVENIO_OVM,
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
       to_date(a.dt_solicitacao,'dd/mm/yyyy') dt_atendimento,
       l.ds_tip_acom,
       null url,
       (select 'X' from dbamv.pro_fat profat
       where profat.cd_pro_Fat = it.cd_pro_fat
       and   profat.cd_gru_pro = 1) diaria,
       nvl(t.qt_diarias_solicitada,1) qt_diarias_solicitada,
       'Internacao'Origem_pedido,  
       'Internacao'tipo_solicitacao, 
       'OVERMIND'DE_PARA_MV,
        ovm.cd_sistema_integra OVM 
from
     dbamv.guia a,
     dbamv.tip_acom l,
     dbamv.tiss_sol_guia t,
     dbamv.tiss_itsol_guia it,
     dbamv.res_lei r,
     mvintegra.depara ovm
where a.cd_guia = t.cd_guia
and  t.id = it.id_pai
and  a.cd_tip_acom(+) = l.cd_tip_acom
and  a.cd_res_lei = r.cd_res_lei
and  ovm.cd_multi_empresa = r.cd_multi_empresa
and  ovm.cd_depara_mv = a.cd_convenio
--and  to_char(a.dt_geracao,'dd/mm/yyyy') = to_char(sysdate,'dd/mm/yyyy')
--and  a.tp_atendimento = 'I'
and  a.cd_convenio in(48)
and  r.cd_aviso_cirurgia is null
and  a.cd_atendimento is null
)where OVM = DE_PARA_MV 
)where cd_guia = 1304610
