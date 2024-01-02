/*select ac.cd_multi_empresa,
       g.cd_guia,
       g.nr_guia,
       sysdate+2 dt_prev_inter,
       ac.sn_uti,
       g.tp_guia,
       g.ds_justificativa,
       g.cd_aviso_cirurgia,
       g.cd_atendimento,
       g.cd_paciente,
       ac.nm_paciente,
       ac.nr_carteira nr_carteira,
       trunc(g.dt_solicitacao) dt_solicitacao,
       g.dt_autorizacao,
       g.cd_senha,
       g.tp_situacao,
       ca.cd_convenio,
       c.nm_convenio,
       c.nr_cgc,
       c.nr_registro_operadora_ans,
       p.cd_prestador,
       p.nm_prestador,
       con.ds_conselho,
       con.cd_uf,
       p.ds_codigo_conselho nr_crm,
       null cred_prestador,
     -- nvl(fc_ovmd_tuss(ac.cd_multi_empresa,it.cd_pro_fat,ca.cd_convenio,'COD'),it.cd_pro_fat)cd_pro_fat,
     -- nvl(fc_ovmd_tuss(ac.cd_multi_empresa,it.cd_pro_fat,ca.cd_convenio,'DESC'),pro.ds_pro_fat)ds_pro_fat,
       it.qt_autorizado,
       especialid.cd_cbos,
       especialid.ds_especialid,
       (select 'X' from dbamv.pro_fat profat
       where profat.cd_pro_Fat = it.cd_pro_fat
       and   profat.cd_gru_pro = 1) diaria,
       case  g.cd_tip_acom when 3 then 'S' when 4 then 'S' when 61 then 'S' else 'N' end as hospital_dia
from dbamv.guia g,
     dbamv.it_guia it,
     dbamv.aviso_cirurgia ac,
     dbamv.cirurgia_aviso ca,
     dbamv.prestador_aviso pa,
     dbamv.prestador p,
     dbamv.convenio c,
     dbamv.conselho con,
     dbamv.pro_fat pro,
     dbamv.especialid especialid,
     dbamv.carteira cpac 
where g.cd_guia = it.cd_guia
and   g.cd_aviso_cirurgia = ac.cd_aviso_cirurgia
and   ac.cd_aviso_cirurgia = ca.cd_aviso_cirurgia
and   ac.cd_aviso_cirurgia = pa.cd_aviso_cirurgia
and   ca.cd_cirurgia_aviso = pa.cd_cirurgia_aviso
and   ca.cd_especialid = especialid.cd_especialid (+)
and   ca.cd_cirurgia = pa.cd_cirurgia
and   pa.cd_prestador = p.cd_prestador
and   ca.cd_convenio = c.cd_convenio
and   p.cd_conselho = con.cd_conselho
and   it.cd_pro_fat = pro.cd_pro_fat
and   pa.cd_ati_med = '01'
and   pa.sn_principal = 'S'
and   ca.sn_principal = 'S'
--and   g.tp_situacao in ('S','G')
and   g.tp_guia = 'I'
and   ac.cd_multi_empresa =7
--and   g.dt_solicitacao >= trunc(sysdate - 1)
--and   g.cd_convenio in (7,12,22,8,23,38,39,11,48,16,25,32,5,34,42,9,53,50,13)
and   g.cd_convenio in (3,5,6,7,8,9,10,11,12,13,14,15,16,22,23,24,25,29,30,32,
33,34,35,38,39,41,42,46,48,50,51,52,53,55,56,57,58,59,213,214,464,501,641)
--and   ca.cd_cirurgia in (1466,2229,2257)
--and   g.ds_justificativa is not null
--and g.nr_guia = 590938
and   g.cd_aviso_cirurgia = 359840
--and   ac.nr_carteira is not null
--AND   g.nm_autorizador_conv = 'OVMD'
----------------------------------------
union all*/
----------------------------------------

--create or replace view vw_ovmd_guia_solicitadas as



select 
       --distinct
       ac.cd_multi_empresa,
       g.cd_guia,
       g.nr_guia,
       sysdate+2 dt_prev_inter,
       ac.sn_uti,
       g.tp_guia,
       g.ds_justificativa,
       g.cd_aviso_cirurgia,
       g.cd_atendimento,
       g.cd_paciente,
       ac.nm_paciente,
       ac.nr_carteira nr_carteira_av,
       cpac.nr_carteira nr_carteira_pac,
      case when ac.nr_carteira
       --cpac.nr_carteira,
       trunc(g.dt_solicitacao) dt_solicitacao,
       g.dt_autorizacao,
       g.cd_senha,
       g.tp_situacao,
       ca.cd_convenio,
       c.nm_convenio,
       c.nr_cgc,
       c.nr_registro_operadora_ans,
       p.cd_prestador,
       p.nm_prestador,
       con.ds_conselho,
       con.cd_uf,
       p.ds_codigo_conselho nr_crm,
       ac.ds_a_seguir cred_prestador,
    -- nvl(fc_ovmd_tuss(ac.cd_multi_empresa,it.cd_pro_fat,ca.cd_convenio,'COD'),it.cd_pro_fat)cd_pro_fat,
    --  nvl(fc_ovmd_tuss(ac.cd_multi_empresa,it.cd_pro_fat,ca.cd_convenio,'DESC'),pro.ds_pro_fat)ds_pro_fat,
  
       it.qt_autorizado,
       especialid.cd_cbos,
       especialid.ds_especialid,
       (select 'X' from dbamv.pro_fat profat
       where profat.cd_pro_Fat = it.cd_pro_fat
       and   profat.cd_gru_pro = 1) diaria,
       case  g.cd_tip_acom when 3 then 'S' when 4 then 'S' when 61 then 'S' else 'N' end as hospital_dia
from dbamv.guia g,
     dbamv.it_guia it,
     dbamv.aviso_cirurgia ac,
     dbamv.cirurgia_aviso ca,
     dbamv.prestador_aviso pa,
     dbamv.prestador p,
     dbamv.convenio c,
     dbamv.conselho con,
     dbamv.pro_fat pro,
     dbamv.especialid especialid,
     dbamv.carteira cpac 
where g.cd_guia = it.cd_guia
and   g.cd_aviso_cirurgia = ac.cd_aviso_cirurgia
and   ac.cd_aviso_cirurgia = ca.cd_aviso_cirurgia
and   ac.cd_aviso_cirurgia = pa.cd_aviso_cirurgia
and   ca.cd_cirurgia_aviso = pa.cd_cirurgia_aviso
and   ca.cd_especialid = especialid.cd_especialid (+)
and   ca.cd_cirurgia = pa.cd_cirurgia
and   pa.cd_prestador = p.cd_prestador
and   ca.cd_convenio = c.cd_convenio
and   cpac.cd_paciente(+) = ac.cd_paciente
and   cpac.cd_paciente(+) = g.cd_paciente
and   cpac.cd_convenio(+) = g.cd_convenio
and   cpac.cd_con_pla(+) = ca.cd_con_pla
and   p.cd_conselho = con.cd_conselho
and   it.cd_pro_fat = pro.cd_pro_fat
and   pa.cd_ati_med = '01'
and   pa.sn_principal = 'S'
and   ca.sn_principal = 'S'
--and   g.tp_situacao in ('S','G')
and   g.tp_guia = 'I'
and   ac.cd_multi_empresa =7
--and   g.dt_solicitacao >= trunc(sysdate - 1)
and   g.cd_convenio in (3,5,6,7,8,9,10,11,12,13,14,15,16,22,23,24,25,29,30,32,
33,34,35,38,39,41,42,46,48,50,51,52,53,55,56,57,58,59,213,214,464,501,641)
--and   ca.cd_cirurgia in (1466,2229,2257)
--and   g.cd_convenio in (41,42)
--and   g.ds_justificativa is not null
--and g.nr_guia = 590938
and   g.cd_aviso_cirurgia in (/*359840,*/358322,339946,359840)
---and   ac.nr_carteira is not null
--and   ac.ds_a_seguir is not null
AND   g.nm_autorizador_conv = 'OVMD'


--select * from aviso_cirurgia where cd_aviso_cirurgia = 358322

--select * from carteira x where x.cd_paciente = 3465091
