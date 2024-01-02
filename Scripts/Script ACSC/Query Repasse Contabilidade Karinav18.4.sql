-- v16 Ajutes em glosas para trazer a ultima dt_glosa registrada - correção de duplicidade
-- v16.1 Inclução do tp_atendimento
-- v18.2 Correção da Função do pct sem prestador grupo 11
-- v18.3 Correção vl_glosa na Reg_amb
-- v18.4 Alteração no a_repassar retirada a função de grupo


BEGIN
  dbamv.pkg_mv2000.atribui_empresa(4);
END;
/
    select
      tipo,
      cd_multi_empresa,
      tp_atendimento,
      cd_remessa,
      conta,
      cd_lancamento,
      cd_atendimento,
      cd_paciente,
      nm_paciente,
      qt_lancamento,
      dt_lancamento,
      competencia,
      cd_pro_fat,
      ds_pro_fat,
      cd_gru_pro,
      ds_gru_pro,
      cd_gru_fat,
      ds_gru_fat,
      cd_convenio,
      nm_convenio,
      cd_reg_repasse,
      cd_prestador,
      nm_prestador,
      cd_prestador_repasse cod_grupo_repasse,
      nm_prestador_grupo,
      sn_pertence_pacote,
      vl_total_conta,
      nvl(a_repassar, 0) a_repassar,
      to_char(perc)||' %' perc,
      nvl(vl_glosa, 0)vl_glosa,
      nvl(aceite, 0) aceite,
      nvl(repassado, 0) repassado,
      nvl(vl_reapresentado, 0)vl_reapresentado,
      nvl(vl_recebido,0)vl_recebido_rec,
      nvl(recurso_repassado, 0) recurso_repassado,
      nvl(vl_pago,0) pago,
      contas_a_pagar,
      TO_CHAR(competencia, 'YYYY') ano,
      TO_CHAR(competencia, 'MM') mes,
      TO_CHAR(competencia, 'MM')
      || '/'
      || TO_CHAR(competencia, 'YYYY') mes_ano,
      cd_setor_produziu,
      nm_setor
--      NVL(A_REPASSAR2, 0) A_REPASSAR2,
--      NVL(RECEITA, 0) RECEITA,
    FROM
 (SELECT
          TIPO,
          CD_MULTI_EMPRESA,
          decode (tp_atendimento, 'A','AMBULATORIO','E','EXTERNO','U','PRONTO SOCORRO','I','INTERNACAO') tp_atendimento,
          CD_REMESSA,
          DT_LANCAMENTO,
          CONTA,
          CD_LANCAMENTO,
          CD_ATENDIMENTO,
          QT_LANCAMENTO,
          VL_TOTAL_CONTA,
          A_REPASSAR,
          CASE
            WHEN Nvl(A_REPASSAR,0) > 1 THEN Round((A_REPASSAR/nullif(VL_TOTAL_CONTA,0))*100,1) ELSE 0 END PERC,
          CASE
            WHEN VL_TOTAL_CONTA - NVL(REPASSADO, 0) - NVL( RECURSO_REPASSADO, 0
              )                 - DECODE(SIGN(NVL(VL_TOTAL_CONTA, 0) - NVL(
              A_REPASSAR, 0)),  -1, 0, NVL(VL_TOTAL_CONTA, 0) - NVL( A_REPASSAR
              , 0)) < 0
            THEN 0
            ELSE VL_TOTAL_CONTA - NVL(REPASSADO, 0) - NVL( RECURSO_REPASSADO, 0
              )                 - DECODE(SIGN(NVL(VL_TOTAL_CONTA, 0) - NVL(
              A_REPASSAR, 0)),  -1, 0, NVL(VL_TOTAL_CONTA, 0) - NVL( A_REPASSAR
              , 0))
          END A_REPASSAR2,
--          CASE
--            WHEN NVL(VL_TOTAL_CONTA,0) - NVL(A_REPASSAR,0) - NVL(REPASSADO,0) -
--              NVL(VL,0) < 0
--            THEN 0
--            ELSE NVL(VL_TOTAL_CONTA,0) - NVL(A_REPASSAR,0) - NVL(REPASSADO,0) -
--              NVL(VL,0)
--          END RECEITA,
          REPASSADO,
          vl_pago,
          cd_con_pag Contas_a_pagar,
          cd_prestador_repasse,
          nm_prestador_grupo,
          RECURSO_REPASSADO,
          VL ACEITE,
          vl_glosa,
          vl_reapresentado,
          vl_recebido,
          CD_CONVENIO,
          NM_CONVENIO,
          CD_REG_REPASSE,
          CD_PRO_FAT,
          DS_PRO_FAT,
          CD_GRU_PRO,
          DS_GRU_PRO,
          CD_GRU_FAT,
          DS_GRU_FAT,
          CD_PACIENTE,
          NM_PACIENTE,
          CD_PRESTADOR,
          NM_PRESTADOR,
          COMPETENCIA,
          SN_PERTENCE_PACOTE,
          CD_SETOR_PRODUZIU,
          NM_SETOR,
          TP_PAGAMENTO
        FROM
(

SELECT
-- LANCAMENTO HOSPITALAR 1
 'INT_CVN' TIPO
-- dados do atendimento
,ate.cd_multi_empresa
,ate.cd_atendimento
,ate.cd_ori_ate
,ate.tp_atendimento
,rf.cd_convenio
,co.nm_convenio
,ate.dt_atendimento
-- fim dados do atendimento
-- dado do paciente
,ate.cd_paciente
,pac.nm_paciente
--dados da conta
,rf.cd_remessa
,rf.cd_reg_fat conta
,it.cd_lancamento
,it.cd_pro_fat
,pf.ds_pro_fat
,it.cd_gru_fat
,gf.ds_gru_fat
,pf.cd_gru_pro
,gp.ds_gru_pro
,it.qt_lancamento
,it.cd_setor_produziu
,sr.nm_setor
,it.sn_pertence_pacote
,it.dt_lancamento
,it.hr_lancamento
,it.qt_ch_unitario
,it.tp_pagamento
,it.vl_filme_unitario
,ep.cd_reg_repasse
,notafiscal.competencia
,nvl(it.vl_total_conta,0)vl_total_conta
--dado do repasse
,dbamv.pkg_repasse.fn_calcula(rf.cd_convenio
                             ,ate.cd_ori_ate
                             ,pf.cd_gru_pro
                             ,it.cd_pro_fat
                             ,it.sn_pertence_pacote
                             ,rf.cd_tip_acom
                             ,it.cd_setor_produziu
                             ,it.cd_prestador
                             ,it.vl_filme_unitario
                             ,nvl(it.vl_total_conta,0)
                             ,it.qt_lancamento
                             ,ep.cd_reg_repasse
                             ,notafiscal.competencia
                             ,NULL
                             ,ate.tp_atendimento
                             ,it.qt_ch_unitario
                             ,rf.cd_reg_fat
                             ,it.hr_lancamento
                             ,it.dt_lancamento
                             ,it.cd_lancamento
                             ,NULL
                             ,it.cd_gru_fat) a_repassar
,glosa.vl_glosa
,aceite.vl
,repasse.vl_repasse repassado
,glosa.vl_reapresentado
,glosa.vl_recebido
,recurso.vl_rec_repasse recurso_repassado
,case when Nvl(repasse.cd_con_pag,recurso.cd_con_pag)  is not null then Nvl(repasse.vl_repasse,0) + Nvl(recurso.vl_rec_repasse,0)  else 0 end vl_pago
,repasse.cd_con_pag || ' / ' || recurso.cd_con_pag cd_con_pag
-- fim dadso da conta
,it.cd_prestador
,pr.nm_prestador
,dbamv.pkg_repasse.fnc_fnrm_retorna_grupo_repasse ( it.cd_prestador,
                                                    ate.cd_multi_empresa,
                                                    rf.cd_convenio,
                                                    pf.cd_gru_pro,
                                                    it.cd_pro_fat,
                                                    ate.cd_ori_ate,
                                                    it.cd_setor_produziu,
                                                    null, --servico,
                                                    null, --cdatimed,
                                                    ate.tp_atendimento,
                                                    it.dt_lancamento,
                                                    it.hr_lancamento ) cd_prestador_repasse
,gpr.nm_prestador nm_prestador_grupo

from
 dbamv.atendime ate
,dbamv.paciente pac
,dbamv.itreg_fat it
,dbamv.reg_fat rf
,dbamv.pro_fat pf
,dbamv.gru_fat gf
,dbamv.gru_pro gp
,dbamv.prestador gpr
,dbamv.prestador pr
,dbamv.convenio co
,dbamv.setor sr
,dbamv.empresa_prestador ep
,(select reme.cd_remessa codigo,
         fat.dt_competencia competencia
     from dbamv.remessa_fatura reme, dbamv.fatura fat
      where reme.cd_fatura = fat.cd_fatura
-----------------------
       and to_char(fat.dt_competencia, 'YYYY') IN (2021)--1 aqui

--        and to_char(fat.dt_competencia, 'MM') IN (7)  --
--------------------------------
        )notafiscal
,(select r.cd_multi_empresa,
         re.cd_reg_fat codigo,
         re.cd_lancamento_fat cd,
         re.cd_prestador,
         re.vl_repasse,
         pr.cd_con_pag,
         re.cd_prestador_repasse
      from dbamv.it_repasse re,dbamv.repasse r,dbamv.repasse_prestador pr
       WHERE re.cd_reg_fat    is not null
         and re.cd_repasse   = r.cd_repasse
         and pr.cd_repasse   = r.cd_repasse
         and pr.cd_prestador = re.cd_prestador
         and pr.cd_prestador_repasse = re.cd_prestador_repasse
         and r.tp_repasse    = 'C'
        )repasse
,(select gl.cd_atendimento,
         gl.cd_reg_fat codigo,
         gl.cd_lancamento_fat cd,
         re.cd_prestador,
         re.vl_repasse vl_rec_repasse,
         rp.cd_con_pag
      FROM dbamv.repasse r, dbamv.it_repasse re,dbamv.glosas gl,dbamv.reg_fat rf,dbamv.remessa_fatura reme,dbamv.fatura fat,dbamv.repasse_prestador rp
       where r.cd_repasse   = re.cd_repasse
        and  re.cd_reg_fat  = rf.cd_reg_fat
        and re.cd_glosas    = gl.cd_glosas
        and rf.cd_remessa   = reme.cd_remessa
        and reme.cd_fatura  = fat.cd_fatura
        and r.cd_repasse    = rp.cd_repasse
        and re.cd_prestador = rp.cd_prestador
        and r.tp_repasse    = 'R'
       )recurso
,(select gl.cd_reg_fat codigo,
         gl.cd_lancamento_fat cd,
         gl.cd_prestador,
         itmov.vl_glosa vl
     from dbamv.itmov_glosas itmov, dbamv.glosas gl
      where itmov.cd_itfat_nf  = gl.cd_itfat_nf
        and gl.cd_reg_fat   is not null
        and gl.cd_prestador is not null
        )aceite
,(select
         glo.cd_reg_fat codigo,
         glo.cd_lancamento_fat cd,
         glo.cd_prestador,
         glo.vl_glosa,
         glo.vl_reapresentado,
         glo.vl_recebido,
         glo.dt_glosa
      from dbamv.glosas glo
       where glo.cd_reg_fat  is not NULL
         AND glo.dt_glosa  IN (SELECT  Max(dt_glosa) FROM dbamv.glosas
                                      WHERE cd_reg_fat = glo.cd_reg_fat
                                        AND cd_lancamento_fat = glo.cd_lancamento_fat )
        )glosa

where rf.cd_atendimento    = ate.cd_atendimento
  and ate.cd_paciente      = pac.cd_paciente
  and it.cd_reg_fat        = rf.cd_reg_fat
  and it.cd_pro_fat        = pf.cd_pro_fat
  and it.cd_gru_fat        = gf.cd_gru_fat
  and pf.cd_gru_pro        = gp.cd_gru_pro
  and it.cd_prestador      = pr.cd_prestador
  and rf.cd_convenio       = co.cd_convenio
  and it.cd_setor_produziu = sr.cd_setor
-- nota fiscal
  and rf.cd_remessa        = notafiscal.codigo
-- Fim da nota fiscal
-- repasse
  and it.cd_reg_fat        = repasse.codigo(+)
  and it.cd_lancamento     = repasse.cd(+)
  and ate.cd_multi_empresa = repasse.cd_multi_empresa(+)
-- Fim repasse
-- recurso
  and it.cd_reg_fat        = recurso.codigo(+)
  and it.cd_lancamento     = recurso.cd(+)
  and it.cd_prestador      = recurso.cd_prestador(+)
-- fim recurso
--Aceite
  and it.cd_reg_fat        = aceite.codigo(+)
  and it.cd_lancamento     = aceite.cd(+)
-- fim aceite
-- glosa
  and it.cd_reg_fat        = glosa.codigo(+)
  and it.cd_lancamento     = glosa.cd(+)
-- Fim glosa
-- grupo prestado
 and  ate.cd_multi_empresa = ep.cd_multi_empresa
 and ep.cd_prestador = dbamv.fnc_acsc_retorna_grupo_repasse (   it.cd_prestador,
                                                                ate.cd_multi_empresa,
                                                                rf.cd_convenio,
                                                                pf.cd_gru_pro,
                                                                it.cd_pro_fat,
                                                                ate.cd_ori_ate,
                                                                it.cd_setor_produziu,
                                                                null, --servico,
                                                                null, --cdatimed,
                                                                ate.tp_atendimento,
                                                                it.dt_lancamento,
                                                                it.hr_lancamento )

 and gpr.cd_prestador = dbamv.pkg_repasse.fnc_fnrm_retorna_grupo_repasse (  it.cd_prestador,
                                                                            ate.cd_multi_empresa,
                                                                            rf.cd_convenio,
                                                                            pf.cd_gru_pro,
                                                                            it.cd_pro_fat,
                                                                            ate.cd_ori_ate,
                                                                            it.cd_setor_produziu,
                                                                            null, --servico,
                                                                            null, --cdatimed,
                                                                            ate.tp_atendimento,
                                                                            it.dt_lancamento,
                                                                            it.hr_lancamento )
--fim grupo repasse
  and not exists (select 1 from dbamv.itlan_med itlan
                      where itlan.cd_reg_fat      = it.cd_reg_fat
                        and itlan.cd_lancamento = it.cd_lancamento)
  and (it.tp_pagamento  <> 'C' or it.tp_pagamento is null)

--  and  it.sn_repassado <> 'X'

  and rf.cd_convenio not in (1,2) -- SUS
  and it.cd_gru_fat   in (16) -- honorario filtro
  and ate.cd_multi_empresa  = 4  --1 aqui

 --   AND rf.cd_reg_fat = 34679


  UNION ALL
---- LANCAMENTO HOSPITALAR 2 SEM PRESTADOR
SELECT
'SEM_INT' tipo
--dados do atendimento
,ate.cd_multi_empresa
,ate.cd_atendimento
,ate.cd_ori_ate
,ate.tp_atendimento
,rf.cd_convenio
,co.nm_convenio
,ate.dt_atendimento
-- fim dados do atendimento
-- Dados do paciente
,ate.cd_paciente
,pac.nm_paciente
-- fim dados do atendimento
-- dadod da conta
,rf.cd_remessa
,rf.cd_reg_fat conta
,it.cd_lancamento
,it.cd_pro_fat
,pf.ds_pro_fat
,it.cd_gru_fat
,gf.ds_gru_fat
,pf.cd_gru_pro
,gp.ds_gru_pro
,it.qt_lancamento
,it.cd_setor_produziu
,sr.nm_setor
,it.sn_pertence_pacote
,it.dt_lancamento
,it.hr_lancamento
,it.qt_ch_unitario
,it.tp_pagamento
,it.vl_filme_unitario
,ep.cd_reg_repasse
,notafiscal.competencia
,nvl(it.vl_total_conta,0) vl_total_conta
--dados do repasse
,dbamv.pkg_repasse.fn_calcula( rf.cd_convenio
                              ,ate.cd_ori_ate
                              ,pf.cd_gru_pro
                              ,it.cd_pro_fat
                              ,it.sn_pertence_pacote
                              ,rf.cd_tip_acom
                              ,it.cd_setor_produziu
                              ,Nvl(repasse.cd_prestador_repasse,dbamv.fn_acsc_regra_prestador_sp(it.cd_pro_fat,pf.cd_gru_pro,it.cd_setor_produziu,null))
                              ,it.vl_filme_unitario
                              ,nvl(it.vl_total_conta,0)
                              ,it.qt_lancamento
                              ,ep.cd_reg_repasse
                              ,notafiscal.competencia
                              ,null
                              ,ate.tp_atendimento
                              ,it.qt_ch_unitario
                              ,rf.cd_reg_fat
                              ,it.hr_lancamento
                              ,it.dt_lancamento
                              ,it.cd_lancamento
                              ,null
                              ,it.cd_gru_fat)a_repassar
,glosa.vl_glosa
,aceite.vl
,repasse.vl_repasse repassado
,glosa.vl_reapresentado
,glosa.vl_recebido
,recurso.vl_rec_repasse recurso_repassado
,case when Nvl(repasse.cd_con_pag,recurso.cd_con_pag) is not null then Nvl(repasse.vl_repasse,0) + Nvl(recurso.vl_rec_repasse,0) else 0 end vl_pago
,repasse.cd_con_pag || ' / ' || recurso.cd_con_pag cd_con_pag
-- fim dados do repasse
-- dados do prestador
,pr.cd_prestador
,pr.nm_prestador
,dbamv.pkg_repasse.fnc_fnrm_retorna_grupo_repasse (Nvl(repasse.cd_prestador_repasse,dbamv.fn_acsc_regra_prestador_sp(it.cd_pro_fat,pf.cd_gru_pro,it.cd_setor_produziu,null)),
                                                    ate.cd_multi_empresa,
                                                    rf.cd_convenio,
                                                    pf.cd_gru_pro,
                                                    it.cd_pro_fat,
                                                    ate.cd_ori_ate,
                                                    it.cd_setor_produziu,
                                                    null, --servico,
                                                    null, --cdatimed,
                                                    ate.tp_atendimento,
                                                    it.dt_lancamento,
                                                    it.hr_lancamento ) cd_prestador_repasse
,gpr.nm_prestador nm_prestador_grupo
FROM
 dbamv.atendime ate
,dbamv.paciente pac
,dbamv.itreg_fat it
,dbamv.reg_fat rf
,dbamv.pro_fat pf
,dbamv.gru_fat gf
,dbamv.gru_pro gp
,dbamv.prestador pr
,dbamv.prestador gpr
,dbamv.convenio co
,dbamv.setor sr
,dbamv.empresa_prestador ep
,(select reme.cd_remessa codigo,
         fat.dt_competencia competencia
     from dbamv.remessa_fatura reme, dbamv.fatura fat
      where reme.cd_fatura = fat.cd_fatura
----------------------
        and to_char(fat.dt_competencia, 'yyyy') in (2021) --2 aqui
-------------------------------------
         )notafiscal
,(select r.cd_multi_empresa,
         re.cd_reg_fat codigo,
         re.cd_lancamento_fat cd,
         re.cd_prestador,
         re.vl_repasse,
         pr.cd_con_pag,
         re.cd_prestador_repasse
      from dbamv.it_repasse re, dbamv.repasse r,dbamv.repasse_prestador pr
       where re.cd_reg_fat    is not null
         and re.cd_repasse   = r.cd_repasse
         and pr.cd_repasse   = r.cd_repasse
         and pr.cd_prestador = re.cd_prestador
         and pr.cd_prestador_repasse = re.cd_prestador_repasse
         and r.tp_repasse    = 'C'
         )repasse
,(select gl.cd_atendimento,
         gl.cd_reg_fat codigo,
         gl.cd_lancamento_fat cd,
         re.cd_prestador,
         re.vl_repasse vl_rec_repasse,
         rp.cd_con_pag
       from dbamv.repasse r,dbamv.it_repasse re,dbamv.glosas gl,dbamv.reg_fat rf,dbamv.remessa_fatura reme,dbamv.fatura fat,dbamv.repasse_prestador rp
        where r.cd_repasse    = re.cd_repasse
          and re.cd_reg_fat   = rf.cd_reg_fat
          and re.cd_glosas    = gl.cd_glosas
          and rf.cd_remessa   = reme.cd_remessa
          and reme.cd_fatura  = fat.cd_fatura
          and r.cd_repasse    = rp.cd_repasse
          and re.cd_prestador = rp.cd_prestador
          and r.tp_repasse    = 'R'
         )recurso
,(select gl.cd_reg_fat codigo,
         gl.cd_lancamento_fat cd,
         gl.cd_prestador,
         itmov.vl_glosa vl
      from dbamv.itmov_glosas itmov,dbamv.glosas gl
       where itmov.cd_itfat_nf  = gl.cd_itfat_nf
         and gl.cd_reg_fat   is not null
         and gl.cd_prestador is not null
         )aceite
,(select
         glo.cd_reg_fat codigo,
         glo.cd_lancamento_fat cd,
         glo.cd_prestador,
         glo.vl_glosa,
         glo.vl_reapresentado,
         glo.vl_recebido,
         glo.dt_glosa
      from dbamv.glosas glo
       where glo.cd_reg_fat  is not NULL
         AND glo.dt_glosa  IN (SELECT  Max(dt_glosa) FROM dbamv.glosas
                                      WHERE cd_reg_fat = glo.cd_reg_fat
                                        AND cd_lancamento_fat = glo.cd_lancamento_fat )
        )glosa

WHERE rf.cd_atendimento    = ate.cd_atendimento
  and ate.cd_paciente      = pac.cd_paciente
  and it.cd_reg_fat        = rf.cd_reg_fat
  and it.cd_pro_fat        = pf.cd_pro_fat
  and it.cd_gru_fat        = gf.cd_gru_fat
  and pf.cd_gru_pro        = gp.cd_gru_pro
  and pr.cd_prestador      = Nvl(repasse.cd_prestador_repasse,dbamv.fn_acsc_regra_prestador_sp(it.cd_pro_fat,pf.cd_gru_pro,it.cd_setor_produziu,null))
  and rf.cd_convenio       = co.cd_convenio
  and it.cd_setor_produziu = sr.cd_setor
-- nota fiscal
  and rf.cd_remessa        = notafiscal.codigo
-- fim nota fiscal
-- repasse
 and it.cd_reg_fat         = repasse.codigo(+)
 and it.cd_lancamento      = repasse.cd(+)
 and ate.cd_multi_empresa  = repasse.cd_multi_empresa(+)
-- fim repasse
-- recurso
 and it.cd_reg_fat        = recurso.codigo(+)
 and it.cd_lancamento     = recurso.cd(+)
 and it.cd_prestador      = recurso.cd_prestador(+)
-- fim recurso
--aceite
 and it.cd_reg_fat        = aceite.codigo(+)
 and it.cd_lancamento     = aceite.cd(+)
-- fim aceite
-- Glosa
 and it.cd_reg_fat        = glosa.codigo(+)
 and it.cd_lancamento     = glosa.cd(+)
-- Fim Glosa
-- Glupo repasse
 and ate.cd_multi_empresa = ep.cd_multi_empresa
 and ep.cd_prestador = Nvl(repasse.cd_prestador_repasse,dbamv.fn_acsc_regra_prestador_sp(it.cd_pro_fat,pf.cd_gru_pro,it.cd_setor_produziu,null))
-- dbamv.fnc_acsc_retorna_grupo_repasse (Nvl(repasse.cd_prestador_repasse,dbamv.fn_acsc_regra_prestador_sp(it.cd_pro_fat,pf.cd_gru_pro,it.cd_setor_produziu,null)),
--                                                       ate.cd_multi_empresa,
--                                                       rf.cd_convenio,
--                                                       pf.cd_gru_pro,
--                                                       it.cd_pro_fat,
--                                                       ate.cd_ori_ate,
--                                                       it.cd_setor_produziu,
--                                                       null, --servico,
--                                                       null, --cdatimed,
--                                                       ate.tp_atendimento,
--                                                       it.dt_lancamento,
--                                                       it.hr_lancamento )
 and gpr.cd_prestador = dbamv.pkg_repasse.fnc_fnrm_retorna_grupo_repasse (Nvl(repasse.cd_prestador_repasse,dbamv.fn_acsc_regra_prestador_sp(it.cd_pro_fat,pf.cd_gru_pro,it.cd_setor_produziu,null)),
                                                                          ate.cd_multi_empresa,
                                                                          rf.cd_convenio,
                                                                          pf.cd_gru_pro,
                                                                          it.cd_pro_fat,
                                                                          ate.cd_ori_ate,
                                                                          it.cd_setor_produziu,
                                                                          null, --servico,
                                                                          null, --cdatimed,
                                                                          ate.tp_atendimento,
                                                                          it.dt_lancamento,
                                                                          it.hr_lancamento )
 and not exists ( select 1 from dbamv.itlan_med itlan
                              where  itlan.cd_reg_fat = it.cd_reg_fat
                                and itlan.cd_lancamento = it.cd_lancamento)
 and it.cd_prestador is null
 and (it.tp_pagamento  <> 'C' or it.tp_pagamento is null)

 -- and it.sn_repassado <> 'X'
 -- AND it.sn_repassado IS NOT NULL

 and rf.cd_convenio not in (1,2) -- SUS
 and it.cd_gru_fat       in (16)
 and ate.cd_multi_empresa  = 4 --aqui 2


UNION ALL
--- LANCAMENTO EQUIPE MEDICA ITLAN_MED 3
SELECT
 'ITL_CVN' tipo
-- dados do atendimento
,ate.cd_multi_empresa
,ate.cd_atendimento
,ate.cd_ori_ate
,ate.tp_atendimento
,rf.cd_convenio
,co.nm_convenio
,ate.dt_atendimento
--fim dados do atendimento
--dados do paciente
,ate.cd_paciente
,pac.nm_paciente
-- dados da conta
,rf.cd_remessa
,rf.cd_reg_fat conta
,itlan.cd_lancamento
,it.cd_pro_fat
,pf.ds_pro_fat
,it.cd_gru_fat
,gf.ds_gru_fat
,pf.cd_gru_pro
,gp.ds_gru_pro
,it.qt_lancamento
,it.cd_setor_produziu
,sr.nm_setor
,it.sn_pertence_pacote
,it.dt_lancamento
,it.hr_lancamento
,it.qt_ch_unitario
,itlan.tp_pagamento
,it.vl_filme_unitario
,ep.cd_reg_repasse
,notafiscal.competencia
,nvl(((itlan.vl_ato - itlan.vl_desconto + itlan.vl_acrescimo)*it.qt_lancamento),0)   VL_TOTAL_CONTA
-- dado do repasse
,dbamv.pkg_repasse.fn_calcula( rf.cd_convenio
                              ,ate.cd_ori_ate
                              ,pf.cd_gru_pro
                              ,it.cd_pro_fat
                              ,it.sn_pertence_pacote
                              ,rf.cd_tip_acom
                              ,it.cd_setor_produziu
                              ,dbamv.pkg_repasse.fnc_fnrm_repassa_auxiliar(itlan.cd_lancamento,itlan.cd_reg_fat,itlan.cd_prestador,itlan.cd_ati_med)
                              ,it.vl_filme_unitario
                              ,nvl((itlan.vl_ato - itlan.vl_desconto + itlan.vl_acrescimo)*it.qt_lancamento,0)
                              ,it.qt_lancamento
                              ,ep.cd_reg_repasse
                              ,notafiscal.competencia
                              ,itlan.cd_ati_med
                              ,ate.tp_atendimento
                              ,it.qt_ch_unitario
                              ,rf.cd_reg_fat
                              ,it.hr_lancamento
                              ,it.dt_lancamento
                              ,it.cd_lancamento
                              ,NULL
                              ,it.cd_gru_fat)a_repassar
,glosa.vl_glosa
,aceite.vl
,repasse.vl_repasse repassado
,glosa.vl_reapresentado
,glosa.vl_recebido
,recurso.vl_rec_repasse recurso_repassado
,case when Nvl(repasse.cd_con_pag,recurso.cd_con_pag) is not null then Nvl(repasse.vl_repasse,0) + Nvl(recurso.vl_rec_repasse,0) else 0 end vl_pago
,repasse.cd_con_pag ||' / '|| recurso.cd_con_pag cd_con_pag
-- dados do prestador repasse
,pr.cd_prestador
,pr.nm_prestador
,dbamv.pkg_repasse.fnc_fnrm_retorna_grupo_repasse (dbamv.pkg_repasse.fnc_fnrm_repassa_auxiliar(itlan.cd_lancamento,itlan.cd_reg_fat,itlan.cd_prestador,itlan.cd_ati_med),
                                                    ate.cd_multi_empresa,
                                                    rf.cd_convenio,
                                                    pf.cd_gru_pro,
                                                    it.cd_pro_fat,
                                                    ate.cd_ori_ate,
                                                    it.cd_setor_produziu,
                                                    null, --servico,
                                                    null, --cdatimed,
                                                    ate.tp_atendimento,
                                                    it.dt_lancamento,
                                                    it.hr_lancamento)cd_prestador_repasse
,gpr.nm_prestador nm_prestador_grupo
FROM
 dbamv.atendime ate
,dbamv.paciente pac
,dbamv.reg_fat rf
,dbamv.itreg_fat it
,dbamv.pro_fat pf
,dbamv.gru_fat gf
,dbamv.gru_pro gp
,dbamv.itlan_med itlan
,dbamv.prestador pr
,dbamv.prestador gpr
,dbamv.convenio co
,dbamv.setor sr
,dbamv.empresa_prestador ep
,(select reme.cd_remessa codigo,
        fat.dt_competencia competencia
        from dbamv.remessa_fatura reme, dbamv.fatura fat
         where reme.cd_fatura = fat.cd_fatura
---------------------------------------
               and to_char(fat.dt_competencia, 'YYYY') in (2021)-- 3  aqui  ,
----               and to_char(fat.dt_competencia, 'MM') in (7)
-----------------------------------
         )notafiscal
,(select r.cd_multi_empresa,
         re.cd_reg_fat codigo,
         re.cd_lancamento_fat cd,
         re.cd_prestador,
         re.vl_repasse,
         pr.cd_con_pag,
         re.cd_prestador_repasse
      from dbamv.it_repasse re,dbamv.repasse r,dbamv.repasse_prestador pr
       where re.cd_reg_fat    is not null
         and re.cd_repasse   = r.cd_repasse
         and pr.cd_repasse   = r.cd_repasse
         and pr.cd_prestador = re.cd_prestador
         and pr.cd_prestador_repasse = re.cd_prestador_repasse
         and r.tp_repasse    = 'C'
         )repasse
,(select  gl.cd_atendimento,
          gl.cd_reg_fat codigo,
          gl.cd_lancamento_fat cd,
          re.cd_prestador,
          re.vl_repasse vl_rec_repasse,
          rp.cd_con_pag
       from dbamv.repasse r,dbamv.it_repasse re,dbamv.glosas gl,dbamv.reg_fat rf, dbamv.remessa_fatura reme,dbamv.fatura fat,dbamv.repasse_prestador rp
         where r.cd_repasse    = re.cd_repasse
           and re.cd_reg_fat   = rf.cd_reg_fat
           and re.cd_glosas    = gl.cd_glosas
           and rf.cd_remessa   = reme.cd_remessa
           and reme.cd_fatura  = fat.cd_fatura
           and r.cd_repasse    = rp.cd_repasse
           and re.cd_prestador = rp.cd_prestador
           and r.tp_repasse = 'R'
          )recurso
,(select gl.cd_reg_fat codigo,
         gl.cd_lancamento_fat cd,
         gl.cd_prestador,
         itmov.vl_glosa vl
      from dbamv.itmov_glosas itmov,dbamv.glosas gl
       where itmov.cd_itfat_nf = gl.cd_itfat_nf
         and gl.cd_reg_fat  is not null
        -- group by gl.cd_reg_fat,gl.cd_lancamento_fat,itmov.vl_glosa,gl.cd_prestador
          )aceite
,(select
         glo.cd_reg_fat codigo,
         glo.cd_lancamento_fat cd,
         glo.cd_prestador,
         glo.vl_glosa,
         glo.vl_reapresentado,
         glo.vl_recebido,
         glo.dt_glosa
      from dbamv.glosas glo
       where glo.cd_reg_fat  is not NULL
         AND glo.dt_glosa  IN (SELECT  Max(dt_glosa) FROM dbamv.glosas
                                      WHERE cd_reg_fat = glo.cd_reg_fat
                                        AND cd_lancamento_fat = glo.cd_lancamento_fat )
        )glosa


WHERE ate.cd_atendimento   = rf.cd_atendimento
  and ate.cd_paciente      = pac.cd_paciente
  and rf.cd_reg_fat        = it.cd_reg_fat
  and it.cd_reg_fat        = itlan.cd_reg_fat
  and it.cd_lancamento     = itlan.cd_lancamento
  and it.cd_pro_fat        = pf.cd_pro_fat
  and it.cd_gru_fat        = gf.cd_gru_fat
  and  pf.cd_gru_pro       = gp.cd_gru_pro
  and rf.cd_convenio       = co.cd_convenio
  and it.cd_setor_produziu = sr.cd_setor
  and it.cd_prestador  is null
  and(itlan.tp_pagamento  <> 'C' or itlan.tp_pagamento is null)

--  and itlan.sn_repassado <> 'X'

  and pr.cd_prestador = dbamv.pkg_repasse.fnc_fnrm_repassa_auxiliar(itlan.cd_lancamento,itlan.cd_reg_fat,itlan.cd_prestador,itlan.cd_ati_med)
-- nota fiscal
  and rf.cd_remessa        = notafiscal.codigo
-- fim nota fiscal
--repasse
  and itlan.cd_reg_fat     = repasse.codigo(+)
  and itlan.cd_lancamento  = repasse.cd(+)
  and itlan.cd_prestador   = repasse.cd_prestador(+)
  and ate.cd_multi_empresa = repasse.cd_multi_empresa(+)
--fim repasse
--recurso
  and itlan.cd_reg_fat     = recurso.codigo(+)
  and itlan.cd_lancamento  = recurso.cd(+)
  and itlan.cd_prestador   = recurso.cd_prestador(+)
--fim recurso
-- aceite
  and itlan.cd_reg_fat     = aceite.codigo(+)
  and itlan.cd_lancamento  = aceite.cd(+)
  and itlan.cd_prestador   = aceite.cd_prestador(+)
--fim aceite
--glosa
  and itlan.cd_reg_fat     = glosa.codigo(+)
  and itlan.cd_lancamento  = glosa.cd(+)
  and itlan.cd_prestador   = glosa.cd_prestador(+)
--fim glosa
--grupo de repasse
 and  ate.cd_multi_empresa = ep.cd_multi_empresa
 and  ep.cd_prestador  = dbamv.fnc_acsc_retorna_grupo_repasse (dbamv.pkg_repasse.fnc_fnrm_repassa_auxiliar(itlan.cd_lancamento,itlan.cd_reg_fat,itlan.cd_prestador,itlan.cd_ati_med),
                                                         ate.cd_multi_empresa,
                                                         rf.cd_convenio,
                                                         pf.cd_gru_pro,
                                                         it.cd_pro_fat,
                                                         ate.cd_ori_ate,
                                                         it.cd_setor_produziu,
                                                         null, --servico,
                                                         null, --cdatimed,
                                                         ate.tp_atendimento,
                                                         it.dt_lancamento,
                                                         it.hr_lancamento)
 and gpr.cd_prestador   =  dbamv.pkg_repasse.fnc_fnrm_retorna_grupo_repasse (dbamv.pkg_repasse.fnc_fnrm_repassa_auxiliar(itlan.cd_lancamento,itlan.cd_reg_fat,itlan.cd_prestador,itlan.cd_ati_med),
                                                                              ate.cd_multi_empresa,
                                                                              rf.cd_convenio,
                                                                              pf.cd_gru_pro,
                                                                              it.cd_pro_fat,
                                                                              ate.cd_ori_ate,
                                                                              it.cd_setor_produziu,
                                                                              null, --servico,
                                                                              null, --cdatimed,
                                                                              ate.tp_atendimento,
                                                                              it.dt_lancamento,
                                                                              it.hr_lancamento)
-- fim grupo repasse
 --and it.sn_repassado <> 'X'

  and rf.cd_convenio not in (1,2) -- SUS
  and it.cd_gru_fat        in (16) -- honorario filtro
  and ate.cd_multi_empresa = 4   --aqui 3

--- FIM LANCAMENTO EQUIPE MEDICA ITLAN_MED 3
UNION ALL
---- CONSULTA DE AMBULATORIO 4 LANÇAMENTO SEm PRESTADOR
SELECT
'SEM_AMB' TIPO
-- dados do atendimeto
,ate.cd_multi_empresa
,ate.cd_atendimento
,ate.cd_ori_ate
,ate.tp_atendimento
,ra.cd_convenio
,co.nm_convenio
,ate.dt_atendimento
-- fim dados do atendimento
-- Dados do paciente
,pac.cd_paciente
,pac.nm_paciente
-- fim dados do paciente
--dados da conta
,ra.cd_remessa
,ra.cd_reg_amb conta
,ita.cd_lancamento
,ita.cd_pro_fat
,pf.ds_pro_fat
,ita.cd_gru_fat
,gf.ds_gru_fat
,pf.cd_gru_pro
,gp.ds_gru_pro
,ita.qt_lancamento
,ita.cd_setor_produziu
,sr.nm_setor
,ita.sn_pertence_pacote
,ra.dt_lancamento
,ita.hr_lancamento
,ita.qt_ch_unitario
,ita.tp_pagamento
,ita.vl_filme_unitario
,ep.cd_reg_repasse
,notafiscal.competencia
,nvl(ita.vl_total_conta,0)vl_total_conta
--fim dados da conta
--dados do repasse
,dbamv.pkg_repasse.fn_calcula( ra.cd_convenio
                             ,ate.cd_ori_ate
                             ,pf.cd_gru_pro
                             ,ita.cd_pro_fat
                             ,ita.sn_pertence_pacote
                             ,NULL
                             ,ita.cd_setor_produziu
                             ,Nvl(repasse.cd_prestador_repasse,dbamv.fn_acsc_regra_prestador_sp(ita.cd_pro_fat,pf.cd_gru_pro,ita.cd_setor_produziu,null))
                             ,ita.vl_filme_unitario
                             ,(nvl(ita.vl_total_conta,0))
                             ,ita.qt_lancamento
                             ,ep.cd_reg_repasse
                             ,notafiscal.competencia
                             ,NULL
                             ,ate.tp_atendimento
                             ,ita.qt_ch_unitario
                             ,ra.cd_reg_amb
                             ,ita.hr_lancamento
                             ,ate.dt_atendimento
                             ,ita.cd_lancamento
                             ,NULL
                             ,ita.cd_gru_fat)a_repassar
,glosa.vl_glosa
,aceite.vl
,repasse.vl_repasse repassado
,glosa.vl_reapresentado
,glosa.vl_recebido
,recurso.vl_rec_repasse
,case when Nvl(repasse.cd_con_pag,recurso.cd_con_pag) is not null then Nvl(repasse.vl_repasse,0) + Nvl(recurso.vl_rec_repasse,0) else 0 end vl_pago
,repasse.cd_con_pag ||' / '|| recurso.cd_con_pag cd_con_pag
-- fim dados do repasse
-- dados do prestador
,pr.cd_prestador
,pr.nm_prestador
,dbamv.pkg_repasse.fnc_fnrm_retorna_grupo_repasse(Nvl(repasse.cd_prestador_repasse,dbamv.fn_acsc_regra_prestador_sp(ita.cd_pro_fat,pf.cd_gru_pro,ita.cd_setor_produziu,null)),
                                                  ate.cd_multi_empresa,
                                                  ra.cd_convenio,
                                                  pf.cd_gru_pro,
                                                  ita.cd_pro_fat,
                                                  ate.cd_ori_ate,
                                                  ita.cd_setor_produziu,
                                                  null, --servico,
                                                  null, --cdatimed,
                                                  ate.tp_atendimento,
                                                  ra.dt_lancamento,
                                                  ita.hr_lancamento ) cd_prestador_repasse
,gpr.nm_prestador nm_prestador_grupo

FROM
 dbamv.atendime ate
,dbamv.paciente pac
,dbamv.itreg_amb ita
,dbamv.reg_amb ra
,dbamv.pro_fat pf
,dbamv.gru_fat gf
,dbamv.gru_pro gp
,dbamv.prestador pr
,dbamv.prestador gpr
,dbamv.convenio co
,dbamv.setor    sr
,dbamv.empresa_prestador ep
,(select reme.cd_remessa codigo,
         fat.dt_competencia competencia
      from dbamv.remessa_fatura reme, dbamv.fatura fat
       where reme.cd_fatura = fat.cd_fatura
----------------------------------
        and to_char(fat.dt_competencia, 'YYYY') IN (2021) ----4  aqui
----        and to_char(fat.dt_competencia, 'MM') IN (7)--
---------------------------------------
         )notafiscal
,(select r.cd_multi_empresa,
         re.cd_reg_amb codigo,
         re.cd_lancamento_amb cd,
         re.cd_prestador,
         re.vl_repasse,
         pr.cd_con_pag,
         re.cd_prestador_repasse
     from dbamv.it_repasse re,dbamv.repasse r,dbamv.repasse_prestador pr
      WHERE re.cd_reg_amb    is not null
       and re.cd_repasse   = r.cd_repasse
       and pr.cd_repasse   = r.cd_repasse
       and pr.cd_prestador = re.cd_prestador
       and pr.cd_prestador_repasse = re.cd_prestador_repasse
       and r.tp_repasse    = 'C'
         )repasse
,(select gl.cd_reg_amb codigo,
         gl.cd_lancamento_amb cd,
         re.cd_prestador,
         re.vl_repasse vl_rec_repasse,
         rp.cd_con_pag
     from dbamv.repasse r, dbamv.it_repasse RE, dbamv.glosas gl, dbamv.reg_amb ra, dbamv.remessa_fatura reme, dbamv.fatura fat, dbamv.repasse_prestador rp
      where r.cd_repasse    = re.cd_repasse
        and re.cd_reg_amb   = ra.cd_reg_amb
        and re.cd_glosas    = gl.cd_glosas
        and ra.cd_remessa   = reme.cd_remessa
        and reme.cd_fatura  = fat.cd_fatura
        and r.cd_repasse    = rp.cd_repasse
        and re.cd_prestador = rp.cd_prestador
        and r.tp_repasse    = 'R'
        )recurso
,(select gl.cd_reg_amb codigo,
         gl.cd_lancamento_amb cd,
         gl.cd_prestador,
         itmov.vl_glosa vl
      from dbamv.itmov_glosas itmov, dbamv.glosas gl
       where itmov.cd_itfat_nf = gl.cd_itfat_nf
         and gl.cd_reg_amb  is not null
        )aceite
,(select
         glo.cd_reg_amb codigo,
         glo.cd_lancamento_amb cd,
         glo.cd_prestador,
         glo.vl_glosa,
         glo.vl_reapresentado,
         glo.vl_recebido,
         glo.dt_glosa
      from dbamv.glosas glo
       where glo.cd_reg_amb  is not NULL
         AND glo.dt_glosa  IN (SELECT  Max(dt_glosa) FROM dbamv.glosas
                                      WHERE cd_reg_amb = glo.cd_reg_amb
                                        AND cd_lancamento_amb = glo.cd_lancamento_amb )
        )glosa


WHERE ate.cd_atendimento    = ita.cd_atendimento
  and ate.cd_paciente       = pac.cd_paciente
  and ita.cd_reg_amb        = ra.cd_reg_amb
  and ita.cd_pro_fat        = pf.cd_pro_fat
  and ita.cd_gru_fat        = gf.cd_gru_fat
  and pf.cd_gru_pro         = gp.cd_gru_pro
  and pr.cd_prestador       = Nvl(repasse.cd_prestador_repasse,dbamv.fn_acsc_regra_prestador_sp(ita.cd_pro_fat,pf.cd_gru_pro,ita.cd_setor_produziu,null))
  and ita.cd_convenio       = co.cd_convenio
  and ita.cd_setor_produziu = sr.cd_setor(+)
  and ra.cd_remessa         = notafiscal.codigo
-- repassado
  and ita.cd_reg_amb        = repasse.codigo(+)
  and ita.cd_lancamento     = repasse.cd(+)
  and ate.cd_multi_empresa  = repasse.cd_multi_empresa(+)
-- fim repassado
-- recurso
  and ita.cd_reg_amb        = recurso.codigo(+)
  and ita.cd_lancamento     = recurso.cd(+)
  and ita.cd_prestador      = recurso.cd_prestador(+)
-- fim recurso
--aceite
  and ita.cd_reg_amb        = aceite.codigo(+)
  and ita.cd_lancamento     = aceite.cd(+)
-- fim aceite
-- glosa
  and ita.cd_reg_amb        = glosa.codigo(+)
  and ita.cd_lancamento     = glosa.cd(+)
--fim glosa
-- Regra de reapasse
  and ate.cd_multi_empresa = ep.cd_multi_empresa
  and pr.cd_prestador   = ep.cd_prestador
  and ep.cd_prestador = Nvl(repasse.cd_prestador_repasse,dbamv.fn_acsc_regra_prestador_sp(ita.cd_pro_fat,pf.cd_gru_pro,ita.cd_setor_produziu,null))
--  dbamv.fnc_acsc_retorna_grupo_repasse (Nvl(repasse.cd_prestador_repasse,dbamv.fn_acsc_regra_prestador_sp(ita.cd_pro_fat,pf.cd_gru_pro,ita.cd_setor_produziu,null)),
--                                                        ate.cd_multi_empresa,
--                                                        ra.cd_convenio,
--                                                        pf.cd_gru_pro,
--                                                        ita.cd_pro_fat,
--                                                        ate.cd_ori_ate,
--                                                        ita.cd_setor_produziu,
--                                                        null, --servico,
--                                                        null, --cdatimed,
--                                                        ate.tp_atendimento,
--                                                        ra.dt_lancamento,
--                                                        ita.hr_lancamento)
  and gpr.cd_prestador = dbamv.pkg_repasse.fnc_fnrm_retorna_grupo_repasse (Nvl(repasse.cd_prestador_repasse,dbamv.fn_acsc_regra_prestador_sp(ita.cd_pro_fat,pf.cd_gru_pro,ita.cd_setor_produziu,null)),
                                                                            ate.cd_multi_empresa,
                                                                            ra.cd_convenio,
                                                                            pf.cd_gru_pro,
                                                                            ita.cd_pro_fat,
                                                                            ate.cd_ori_ate,
                                                                            ita.cd_setor_produziu,
                                                                            null, --servico,
                                                                            null, --cdatimed,
                                                                            ate.tp_atendimento,
                                                                            ra.dt_lancamento,
                                                                            ita.hr_lancamento)

  and ita.cd_prestador is NULL
  and(ita.tp_pagamento  <> 'C' or ita.tp_pagamento is null)

 -- and ita.sn_repassado <> 'X'
 --and ita.sn_repassado IS NOT null


  and ita.cd_convenio not in (1,2) -- SUS
  and ita.cd_gru_fat       in (16)
  and ate.cd_multi_empresa  = 4 --  aqui  4

-- FIM CONSULTA DE AMBULATORIO 4
UNION ALL

-- CONSULTA DE AMBULATORIO 5
SELECT
  'AMB_CNV' TIPO
-- Dados do atendimento
,ate.cd_multi_empresa
,ate.cd_atendimento
,ate.cd_ori_ate
,ate.tp_atendimento
,ra.cd_convenio
,co.nm_convenio
,ate.dt_atendimento
-- fim dados do atendimento
-- Dado do paciente
,pac.cd_paciente
,pac.nm_paciente
-- fim dado paciente
-- Dados da conta
,ra.cd_remessa
,ra.cd_reg_amb conta
,ita.cd_lancamento
,ita.cd_pro_fat
,pf.ds_pro_fat
,ita.cd_gru_fat
,gf.ds_gru_fat
,pf.cd_gru_pro
,gp.ds_gru_pro
,ita.qt_lancamento
,ita.cd_setor_produziu
,sr.nm_setor
,ita.sn_pertence_pacote
,ra.dt_lancamento
,ita.hr_lancamento
,ita.qt_ch_unitario
,ita.tp_pagamento
,ita.vl_filme_unitario
,ep.cd_reg_repasse
,notafiscal.competencia
,ita.vl_total_conta
-- Dados do repasse
,dbamv.pkg_repasse.fn_calcula( ra.cd_convenio,
                               ate.cd_ori_ate,
                               pf.cd_gru_pro,
                               ita.cd_pro_fat,
                               ita.sn_pertence_pacote,
                               null,
                               ita.cd_setor_produziu,
                               ita.cd_prestador,
                               ita.vl_filme_unitario,
                               nvl(ita.vl_total_conta,0),
                               ita.qt_lancamento,
                               ep.cd_reg_repasse,
                               notafiscal.competencia,
                               NULL,
                               ate.tp_atendimento,
                               ita.qt_ch_unitario,
                               ra.cd_reg_amb,
                               ita.hr_lancamento,
                               ate.dt_atendimento,
                               ita.cd_lancamento,
                               null,
                               ita.cd_gru_fat) a_repassar
 ,glosa.vl_glosa
 ,aceite.vl
,Nvl(repasse.vl_repasse,0) repassado
 ,glosa.vl_reapresentado
 ,glosa.vl_recebido
 ,recurso.vl_rec_repasse
,case when Nvl(repasse.cd_con_pag,recurso.cd_con_pag)  is not null then Nvl(repasse.vl_repasse,0) + Nvl(recurso.vl_rec_repasse,0) else 0 end vl_pago
,repasse.cd_con_pag ||' / '|| recurso.cd_con_pag cd_con_pag
-- Dados do prestador e repasse
 ,ita.cd_prestador
 ,pr.nm_prestador
 ,dbamv.pkg_repasse.fnc_fnrm_retorna_grupo_repasse (ita.cd_prestador,
                                                    ate.cd_multi_empresa,
                                                    ra.cd_convenio,
                                                    pf.cd_gru_pro,
                                                    ita.cd_pro_fat,
                                                    ate.cd_ori_ate,
                                                    ita.cd_setor_produziu,
                                                    null, --servico,
                                                    null, --cdatimed,
                                                    ate.tp_atendimento,
                                                    ra.dt_lancamento,
                                                    ita.hr_lancamento)cd_prestador_repasse
,gpr.nm_prestador nm_prestador_grupo


FROM
 dbamv.atendime  ate
,dbamv.paciente  pac
,dbamv.itreg_amb ita
,dbamv.reg_amb   ra
,dbamv.pro_fat   pf
,dbamv.gru_fat   gf
,dbamv.gru_pro   gp
,dbamv.setor     sr
,dbamv.prestador pr
,dbamv.prestador gpr
,dbamv.convenio  co
,dbamv.empresa_prestador ep
,(select reme.cd_remessa codigo,
         fat.dt_competencia competencia
                FROM dbamv.remessa_fatura reme,dbamv.fatura fat
                WHERE reme.cd_fatura = fat.cd_fatura
------------------
               AND TO_CHAR(fat.dt_competencia, 'YYYY') IN (2021) --  5  alterar aqui
--               AND TO_CHAR(fat.dt_competencia, 'MM') IN (7)
--------------------------
             )notafiscal
,(select r.cd_multi_empresa,
         re.cd_reg_amb codigo,
         re.cd_lancamento_amb cd,
         re.cd_prestador,
         re.vl_repasse,
         pr.cd_con_pag,
         re.cd_prestador_repasse
                from dbamv.it_repasse re, dbamv.repasse r, dbamv.repasse_prestador pr
                WHERE re.cd_reg_amb    is not null
                  and re.cd_repasse   = r.cd_repasse
                  and pr.cd_repasse   = r.cd_repasse
                  and pr.cd_prestador = re.cd_prestador
                  and pr.cd_prestador_repasse = re.cd_prestador_repasse
                  and r.tp_repasse    = 'C'
              )repasse
,(select  gl.cd_reg_amb codigo,
          gl.cd_lancamento_amb cd,
          re.cd_prestador,
          re.vl_repasse vl_rec_repasse,
          rp.cd_con_pag
                from dbamv.repasse r, dbamv.it_repasse re, dbamv.glosas gl, dbamv.reg_amb ra, dbamv.remessa_fatura reme, dbamv.fatura fat, dbamv.repasse_prestador rp
                where r.cd_repasse  = re.cd_repasse
                and re.cd_reg_amb   = ra.cd_reg_amb
                and re.cd_glosas    = gl.cd_glosas
                and ra.cd_remessa   = reme.cd_remessa
                and reme.cd_fatura  = fat.cd_fatura
                and r.cd_repasse    = rp.cd_repasse
                and re.cd_prestador = rp.cd_prestador
                and r.tp_repasse    = 'R'
              )recurso
,(SELECT  gl.cd_reg_amb codigo,
          gl.cd_lancamento_amb cd,
          gl.cd_prestador,
          itmov.vl_glosa vl
                from dbamv.itmov_glosas itmov, dbamv.glosas gl
                where itmov.cd_itfat_nf = gl.cd_itfat_nf
                and gl.cd_reg_amb  is not null
              )aceite
,(select
         glo.cd_reg_amb codigo,
         glo.cd_lancamento_amb cd,
         glo.cd_prestador,
         glo.vl_glosa,
         glo.vl_reapresentado,
         glo.vl_recebido,
         glo.dt_glosa
      from dbamv.glosas glo
       where glo.cd_reg_amb  is not NULL
         AND glo.dt_glosa  IN (SELECT  Max(dt_glosa) FROM dbamv.glosas
                                      WHERE cd_reg_amb = glo.cd_reg_amb
                                        AND cd_lancamento_amb = glo.cd_lancamento_amb )
        )glosa

WHERE ate.cd_paciente       = pac.cd_paciente
 AND  ate.cd_atendimento    = ita.cd_atendimento
 AND  ita.cd_reg_amb        = ra.cd_reg_amb
 AND  ita.cd_pro_fat        = pf.cd_pro_fat
 AND  ita.cd_gru_fat        = gf.cd_gru_fat
 AND  pf.cd_gru_pro         = gp.cd_gru_pro
 AND  ita.cd_setor_produziu = sr.cd_setor(+)
 AND  ita.cd_prestador      = pr.cd_prestador --(+)
 AND  ra.cd_convenio        = co.cd_convenio
 AND  ra.cd_remessa         = notafiscal.codigo
 -- repassado
 AND  ita.cd_reg_amb        = repasse.codigo(+)
 AND  ita.cd_lancamento     = repasse.cd(+)
 AND  ate.cd_multi_empresa  = repasse.cd_multi_empresa(+)
-- fim repassado
-- recurso
 and ita.cd_reg_amb        = recurso.codigo(+)
 and ita.cd_lancamento     = recurso.cd(+)
 and ita.cd_prestador      = recurso.cd_prestador(+)
-- fim recurso
-- aceite
 and ita.cd_reg_amb        = aceite.codigo(+)
 and ita.cd_lancamento     = aceite.cd(+)
-- fim aceite
-- glosa
 and ita.cd_reg_amb        = glosa.codigo(+)
 and ita.cd_lancamento     = glosa.cd(+)
--fim glosa
-- Grupo de repasse
 AND  ate.cd_multi_empresa = ep.cd_multi_empresa
 AND  ep.cd_prestador  = dbamv.fnc_acsc_retorna_grupo_repasse (ita.cd_prestador,
                                                         ate.cd_multi_empresa,
                                                         ra.cd_convenio,
                                                         pf.cd_gru_pro,
                                                         ita.cd_pro_fat,
                                                         ate.cd_ori_ate,
                                                         ita.cd_setor_produziu,
                                                         null, --servico,
                                                         null, --cdatimed,
                                                         ate.tp_atendimento,
                                                         ra.dt_lancamento,
                                                         ita.hr_lancamento)
 AND gpr.cd_prestador   = dbamv.pkg_repasse.fnc_fnrm_retorna_grupo_repasse (ita.cd_prestador,
                                                                            ate.cd_multi_empresa,
                                                                            ra.cd_convenio,
                                                                            pf.cd_gru_pro,
                                                                            ita.cd_pro_fat,
                                                                            ate.cd_ori_ate,
                                                                            ita.cd_setor_produziu,
                                                                            null, --servico,
                                                                            null, --cdatimed,
                                                                            ate.tp_atendimento,
                                                                            ra.dt_lancamento,
                                                                            ita.hr_lancamento)
-- fim grupo de repasse
 AND(ita.tp_pagamento  <> 'C' or ita.tp_pagamento is null)

-- and ita.sn_repassado <> 'X'
-----------------
 and ita.cd_convenio not in (1,2) -- SUS
 and ita.cd_gru_fat      in (16)
 and ate.cd_multi_empresa  = 4 --  aqui    5

  )
 )A

 --  WHERE a.cd_prestador_repasse = 3023

;


