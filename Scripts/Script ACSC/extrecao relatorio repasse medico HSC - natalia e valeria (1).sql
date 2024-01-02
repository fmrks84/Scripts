SELECT * FROM (
SELECT
       Nvl(cd_lancamento_fat, cd_lancamento_amb) cd_lancamento
      ,EMPRESA_PRESTADOR.cd_prestador cd_gru_rep
      ,EMPRESA_PRESTADOR.cd_multi_empresa
		  ,gru_rep.nm_prestador ds_gru_rep
		  ,prestador.cd_prestador CD_PRESTADOR
		  ,prestador.NM_PRESTADOR nm_prestador
		  ,v.cd_repasse cd_repasse
      ,v.sn_pertence_pacote
      ,To_Char(v.dt_competencia,'mm/yyyy') competencia_repasse
      ,To_Char(v.COMPETENCIA_FATURAMENTO, 'mm/yyyy') COMPETENCIA_FATURAMENTO
      ,v.dt_repasse dt_repasse
		  ,v.ds_repasse ds_repasse
		  ,0 vl_total
		  ,v.cd_pro_fat cd_pro_fat
		  ,Nvl(Nvl(Nvl(Nvl(rp_c.ds_pro_fat, rp_sih.ds_procedimento), rp_sia.ds_procedimento),pro_fat.ds_pro_fat),procedimento_sus.ds_procedimento) ds_pro_fat
		  ,Nvl(v.cd_reg_fat, v.cd_reg_amb) conta
		  ,DECODE(nvl('R$','R$'),'R$',v.VL_REPASSE,dbamv.fnc_moeda_depara('R$','R$',NULL,v.VL_REPASSE, TO_DATE('R$', 'dd/mm/yyyy'))) VL_REPASSE
		  ,v.DT_LANCAMENTO
		  ,v.HR_LANCAMENTO
		  ,v.qt_lancamento qt_lancamento
		  ,Nvl(rp_c.vl_total_conta, rp_sih.vl_total_conta) vl_total_conta
		  ,Nvl(Nvl(rp_c.cd_remessa, rp_sih.cd_remessa),rp_sia.cd_fat_sia) cd_remessa
		  ,convenio.nm_convenio nm_convenio
      ,CON_PLA.ds_con_pla PLANO
 		  ,Nvl(paciente.nm_paciente,rp_sia.nm_paciente) nm_paciente
		  ,Nvl(Nvl(Nvl(rp_c.cd_gru_pro,rp_sih.cd_gru_pro),rp_sia.cd_gru_pro),gru_pro.cd_gru_pro) cd_gru_pro
		  ,Nvl(Nvl(Nvl(rp_c.DS_GRU_PRO,rp_sih.DS_GRU_PRO),rp_sia.DS_GRU_PRO),gru_pro.ds_gru_pro) ds_gru_pro
		  ,v.tipo tipo
		  ,0 vl_faturado
		  ,v.CD_CONVENIO cd_convenio
		  ,rp_sia.cd_reg_repasse_sia cd_reg_repasse_sia
		  ,atendime.cd_especialid cd_especialid
		  ,rp_c.cd_tip_ate cd_tip_ate
		  ,atendime.cd_ori_ate cd_ori_ate
		  ,rp_sia.sn_medico sn_medico
		  ,DECODE(nvl('R$','R$'),'R$',rp_sia.vl_anestesista,dbamv.fnc_moeda_depara('R$','R$',NULL,rp_sia.vl_anestesista, TO_DATE('R$', 'dd/mm/yyyy'))) vl_anestesista
      ,DECODE(nvl('R$','R$'),'R$',rp_sia.vl_outros,dbamv.fnc_moeda_depara('R$','R$',NULL,rp_sia.vl_outros, TO_DATE('R$', 'dd/mm/yyyy'))) vl_outros
		  ,DECODE(nvl('R$','R$'),'R$',rp_sia.vl_auxiliar,dbamv.fnc_moeda_depara('R$','R$',NULL,rp_sia.vl_auxiliar, TO_DATE('R$', 'dd/mm/yyyy'))) vl_auxiliar
		  ,DECODE(nvl('R$','R$'),'R$',rp_sia.vl_geral,dbamv.fnc_moeda_depara('R$','R$',NULL,rp_sia.vl_geral, TO_DATE('R$', 'dd/mm/yyyy'))) vl_geral
		  ,DECODE(nvl('R$','R$'),'R$',v.vl_base_repassado,dbamv.fnc_moeda_depara('R$','R$',NULL,v.vl_base_repassado, TO_DATE('R$', 'dd/mm/yyyy'))) vl_base_repassado
		  ,atendime.tp_atendimento tp_atendimento
      ,ati_med.ds_ati_med ds_ati_med
 		  ,DECODE(nvl('R$','R$'),'R$',rp_c.vl_filme,dbamv.fnc_moeda_depara('R$','R$',NULL,rp_c.vl_filme, TO_DATE('R$', 'dd/mm/yyyy'))) vl_filme
		  ,v.cd_atendimento cd_atendimento
      ,v.vl_perc_repasse vl_perc_repasse
		  ,rp_c.qt_ch_unitario qt_ch
		  ,Nvl(v.cd_reg_fat, v.cd_reg_amb) num_conta
		  ,v.cd_atendimento num_atend
		  ,Nvl(cd_lancamento_fat, cd_lancamento_amb) cd_lanca
		  ,v.cd_ati_med cd_ati_med
		  ,DECODE(nvl('R$','R$'),'R$',rp_c.VL_RECEBIDO,dbamv.fnc_moeda_depara('R$','R$',NULL,rp_c.VL_RECEBIDO, TO_DATE('R$', 'dd/mm/yyyy'))) vl_recebido
		  ,DECODE(substr(v.tipo,1,3),'REC','G',
                                     'GLO','G',
                                     'MAN','RP',
                                     'CNV', rp_c.sn_horario_contratado,'N') sn_horario_contratado
		  ,Decode (v.tp_repasse,'M','Manual','C','Convenio','F','FIXO','R', 'Recurso','I','SUS INTERNACAO','A','SUS AMB')tp_repasse
      ,Decode(lr.tp_remessa,'C','*','R','+','') e_conciliado
      ,ATENDIME.DT_ATENDIMENTO
      ,ATENDIME.HR_ATENDIMENTO
      ,gru_fat.cd_gru_fat
      ,v.grupo
      ,v.cd_Setor
      ,(select setor.nm_setor from setor where setor.cd_setor = v.cd_setor ) nm_setor
      ,reg_repasse.cd_reg_repasse regra_repasse

	FROM
       dbamv.convenio,
       dbamv.EMPRESA_PRESTADOR ,
       dbamv.prestador gru_rep,
       dbamv.prestador ,
       dbamv.repasse ,
       dbamv.paciente,
       dbamv.ati_med ,
       dbamv.atendime,
       dbamv.log_repasse lr,
       gru_fat,
       (
            SELECT 'CNV_AMB' tipo, r.tp_repasse,(SELECT DT_FECHAMENTO FROM remessa_fatura where CD_REMESSA = reg.CD_REMESSA) COMPETENCIA_FATURAMENTO, r.dt_competencia dt_competencia, itc.sn_pertence_pacote, r.dt_repasse, r.ds_repasse, itr.cd_repasse, itr.cd_prestador, itr.cd_prestador_repasse, itr.cd_reg_fat, itr.cd_lancamento_fat, itr.cd_reg_amb, itr.cd_lancamento_amb, itc.vl_base_repassado, itr.vl_repasse
                  , itc.cd_atendimento, reg.cd_convenio
                  , dt_lancamento DT_LANCAMENTO
                  , hr_lancamento HR_LANCAMENTO
                  , itc.cd_pro_fat,gf.ds_gru_fat grupo , itc.qt_lancamento, itc.cd_ati_med, itr.cd_it_repasse, to_number(null) CD_IT_REPASSE_SIH, to_number(null)CD_IT_REPASSE_SIA, itr.vl_perc_repasse , to_number(null) cd_glosas, itc.cd_setor_produziu cd_setor
              FROM dbamv.repasse r
                  , dbamv.it_repasse itr
                  , dbamv.itreg_amb itc
                  , dbamv.reg_amb reg
                  , dbamv.gru_fat gf
              WHERE r.cd_repasse = itr.cd_repasse
                AND itr.cd_reg_amb = itc.cd_reg_amb
                AND itr.cd_lancamento_amb = itc.cd_lancamento
                AND reg.cd_reg_amb = itc.cd_reg_amb
                AND gf.cd_gru_fat = itc.cd_gru_fat
                AND r.tp_repasse = 'C'
                AND itr.cd_reg_fat is null

              UNION ALL

            SELECT 'CNV_INT' tipo, r.tp_repasse, (SELECT DT_FECHAMENTO FROM remessa_fatura where CD_REMESSA = reg.CD_REMESSA) COMPETENCIA_FATURAMENTO, r.dt_competencia dt_competencia,itc.sn_pertence_pacote, r.dt_repasse, r.ds_repasse, itr.cd_repasse, itr.cd_prestador, itr.cd_prestador_repasse, itr.cd_reg_fat, itr.cd_lancamento_fat, itr.cd_reg_amb, itr.cd_lancamento_amb, itc.vl_base_repassado, itr.vl_repasse
                  , reg.cd_atendimento, reg.cd_convenio
                  , dt_lancamento DT_LANCAMENTO
                  , hr_lancamento HR_LANCAMENTO
                  , itc.cd_pro_fat,gf.ds_gru_fat grupo, itc.qt_lancamento, itc.cd_ati_med, itr.cd_it_repasse, to_number(null) CD_IT_REPASSE_SIH, to_number(null) CD_IT_REPASSE_SIA, itr.vl_perc_repasse , to_number(null) cd_glosas, itc.cd_setor_produziu cd_setor
              FROM dbamv.repasse r
                  , dbamv.it_repasse itr
                  , dbamv.itreg_fat itc
                  , dbamv.reg_fat reg
                  , dbamv.gru_fat gf
              WHERE r.cd_repasse = itr.cd_repasse
                AND itr.cd_reg_fat = itc.cd_reg_fat
                AND itr.cd_lancamento_fat = itc.cd_lancamento
                AND reg.cd_reg_fat = itc.cd_reg_fat
                AND itc.cd_gru_fat = gf.cd_gru_fat
                AND r.tp_repasse = 'C'
                AND itr.cd_reg_amb is null
                and not exists(select 'X' from dbamv.itlan_med where cd_reg_fat = itc.cd_reg_fat and cd_lancamento = itc.cd_lancamento)

              UNION ALL

            SELECT 'CNV_EQP' tipo, r.tp_repasse,(SELECT DT_FECHAMENTO FROM remessa_fatura where CD_REMESSA = reg.CD_REMESSA) COMPETENCIA_FATURAMENTO, r.dt_competencia dt_competencia,itc.sn_pertence_pacote, r.dt_repasse, r.ds_repasse, itr.cd_repasse, itr.cd_prestador, itr.cd_prestador_repasse, itr.cd_reg_fat, itr.cd_lancamento_fat, itr.cd_reg_amb, itr.cd_lancamento_amb, itl.vl_base_repassado, itr.vl_repasse
                  , reg.cd_atendimento, reg.cd_convenio
                  , dt_lancamento DT_LANCAMENTO
                  , hr_lancamento HR_LANCAMENTO
                  , itc.cd_pro_fat,gf.ds_gru_fat grupo, itc.qt_lancamento, itl.cd_ati_med, itr.cd_it_repasse , to_number(null) CD_IT_REPASSE_SIH, to_number(null) CD_IT_REPASSE_SIA, itr.vl_perc_repasse, to_number(null) cd_glosas, itc.cd_setor_produziu cd_setor
              FROM dbamv.repasse r
                  , dbamv.it_repasse itr
                  , dbamv.itreg_fat itc
                  , dbamv.itlan_med itl
                  , dbamv.reg_fat reg
                  , dbamv.gru_fat gf
              WHERE r.cd_repasse = itr.cd_repasse
                AND itr.cd_reg_fat = itc.cd_reg_fat
                AND itr.cd_lancamento_fat = itc.cd_lancamento
                AND itc.cd_reg_fat = itl.cd_reg_fat
                AND itc.cd_lancamento = itl.cd_lancamento
                AND itr.cd_ati_med = itl.cd_ati_med
                AND itc.cd_gru_fat = gf.cd_gru_fat
                AND reg.cd_reg_fat = itc.cd_reg_fat
                AND itr.cd_reg_amb is null
                AND r.tp_repasse = 'C'

              UNION ALL

             SELECT 'SUS_AMB' tipo, r.tp_repasse, (SELECT DT_FECHAMENTO FROM remessa_fatura where CD_REMESSA = eve.CD_REMESSA) COMPETENCIA_FATURAMENTO, r.dt_competencia dt_competencia, NULL sn_pertence_pacote, r.dt_repasse, r.ds_repasse, itr.cd_repasse, itr.cd_prestador, itr.cd_prestador_repasse, TO_NUMBER(null) cd_reg_fat, TO_NUMBER(null) cd_lancamento_fat, eve.cd_eventos cd_reg_amb, TO_NUMBER(null) cd_lancamento_amb, eve.vl_base_repassado, itr.vl_repasse
                  , eve.cd_atendimento, eve.cd_convenio
                  , eve.dt_eve_siasus DT_LANCAMENTO
                  , eve.dt_eve_siasus HR_LANCAMENTO
                  , eve.cd_procedimento cd_pro_fat,gp.ds_grupo_procedimento grupo, eve.qt_lancada qt_lancamento, TO_CHAR(null) cd_ati_med, to_number(null) cd_it_repasse, to_number(null) CD_IT_REPASSE_SIH ,itr.cd_it_repasse_sia, itr.vl_perc_repasse, to_number(null) cd_glosas, eve.cd_setor_produziu cd_setor
              FROM dbamv.repasse r
                  , dbamv.it_repasse_sia itr
                  , dbamv.eve_siasus eve
                  , dbamv.procedimento_sus ps
                  , dbamv.grupo_procedimentos gp
              WHERE r.cd_repasse = itr.cd_repasse
                AND itr.cd_eventos = eve.cd_eventos
                AND eve.cd_procedimento = ps.cd_procedimento
                AND ps.cd_grupo_procedimento = gp.cd_grupo_procedimento
                AND r.tp_repasse = 'A'

              UNION ALL

            SELECT 'SUS_INT' tipo, r.tp_repasse, (SELECT DT_FECHAMENTO FROM remessa_fatura where CD_REMESSA = reg.CD_REMESSA)COMPETENCIA_FATURAMENTO, r.dt_competencia dt_competencia,itc.sn_pertence_pacote, r.dt_repasse, r.ds_repasse,itr.cd_repasse, itr.cd_prestador, itr.cd_prestador_repasse, itr.cd_reg_fat, itr.cd_lancamento cd_lancamento_fat, TO_NUMBER(null) cd_reg_amb, TO_NUMBER(null) cd_lancamento_amb, itc.vl_base_repassado, itr.vl_repasse
                  , reg.cd_atendimento, reg.cd_convenio
                  , dt_lancamento DT_LANCAMENTO
                  , hr_lancamento HR_LANCAMENTO
                  , itc.cd_procedimento cd_pro_fat,gp.ds_grupo_procedimento grupo, itc.qt_lancamento, itc.cd_ati_med, to_number(null) cd_it_repasse, itr.cd_it_repasse_sih, to_number(null)CD_IT_REPASSE_SIA, itr.vl_perc_repasse, to_number(null) cd_glosas, itc.cd_setor_produziu cd_setor
              FROM dbamv.repasse r
                  , dbamv.it_repasse_sih itr
                  , dbamv.itreg_fat itc
                  , dbamv.reg_fat reg
                  , dbamv.procedimento_sus ps
                  , dbamv.grupo_procedimentos gp
              WHERE r.cd_repasse = itr.cd_repasse
                AND itr.cd_reg_fat = itc.cd_reg_fat
                AND itr.cd_lancamento = itc.cd_lancamento
                AND reg.cd_reg_fat = itc.cd_reg_fat
                AND itc.cd_procedimento = ps.cd_procedimento
                AND ps.cd_grupo_procedimento = gp.cd_grupo_procedimento
                AND r.tp_repasse = 'I'
                AND not exists(select cd_reg_fat,cd_lancamento
                                 from dbamv.itlan_med
                                where cd_reg_fat = itc.cd_reg_fat
                                  and cd_lancamento = itc.cd_lancamento)

              UNION ALL

            SELECT 'SUS_EQP' tipo, r.tp_repasse, (SELECT DT_FECHAMENTO FROM remessa_fatura where CD_REMESSA = reg.CD_REMESSA)COMPETENCIA_FATURAMENTO, r.dt_competencia dt_competencia,itc.sn_pertence_pacote, r.dt_repasse, r.ds_repasse, itr.cd_repasse, itr.cd_prestador, itr.cd_prestador_repasse, itr.cd_reg_fat, itr.cd_lancamento cd_lancamento_fat, TO_NUMBER(null) cd_reg_amb, TO_NUMBER(null) cd_lancamento_amb, itl.vl_base_repassado, itr.vl_repasse
                  , reg.cd_atendimento, reg.cd_convenio
                  , dt_lancamento DT_LANCAMENTO
                  , hr_lancamento HR_LANCAMENTO
                  , itc.cd_procedimento cd_pro_fat,gp.ds_grupo_procedimento grupo, itc.qt_lancamento, itl.cd_ati_med, to_number(null) cd_it_repasse, itr.cd_it_repasse_sih, to_number(null)CD_IT_REPASSE_SIA, itr.vl_perc_repasse, to_number(null) cd_glosas, itc.cd_setor_produziu cd_setor
              FROM dbamv.repasse r
                  , dbamv.it_repasse_sih itr
                  , dbamv.itreg_fat itc
                  , dbamv.itlan_med itl
                  , dbamv.reg_fat reg
                  , dbamv.procedimento_sus ps
                  , dbamv.grupo_procedimentos gp
              WHERE r.cd_repasse = itr.cd_repasse
                AND itr.cd_reg_fat = itc.cd_reg_fat
                AND itr.cd_lancamento = itc.cd_lancamento
                AND itc.cd_reg_fat = itl.cd_reg_fat
                AND itc.cd_lancamento = itl.cd_lancamento
                AND itr.cd_ati_med = itl.cd_ati_med
                AND itr.cd_prestador(+) = itl.cd_prestador
                AND reg.cd_reg_fat = itc.cd_reg_fat
                AND itc.cd_procedimento = ps.cd_procedimento
                AND ps.cd_grupo_procedimento = gp.cd_grupo_procedimento
                AND r.tp_repasse = 'I'

              UNION ALL

            SELECT 'GLO_INT' tipo, r.tp_repasse, (SELECT DT_FECHAMENTO FROM remessa_fatura where CD_REMESSA = reg.CD_REMESSA)COMPETENCIA_FATURAMENTO, r.dt_competencia dt_competencia,itc.sn_pertence_pacote, r.dt_repasse, r.ds_repasse, itr.cd_repasse, itr.cd_prestador, itr.cd_prestador_repasse, g.cd_reg_fat, g.cd_lancamento_fat, g.cd_reg_amb, g.cd_lancamento_amb, g.vl_base_repassado, itr.vl_glosa*(-1) vl_repasse
                  , reg.cd_atendimento, reg.cd_convenio
                  , dt_lancamento DT_LANCAMENTO
                  , hr_lancamento HR_LANCAMENTO
                  , itc.cd_pro_fat,gf.ds_gru_fat grupo,itc.qt_lancamento, itc.cd_ati_med, itr.cd_it_repasse , to_number(null)CD_IT_REPASSE_SIH, to_number(null)CD_IT_REPASSE_SIA, itr.vl_perc_repasse, g.cd_glosas, itc.cd_setor_produziu cd_setor
              FROM dbamv.repasse r
                  , dbamv.it_repasse itr
                  , dbamv.itreg_fat itc
                  , dbamv.glosas g
                  , dbamv.reg_fat reg
                  , dbamv.gru_fat gf
              WHERE r.cd_repasse = itr.cd_repasse
                AND g.cd_glosas = itr.cd_glosas
                AND g.cd_reg_fat = itc.cd_reg_fat
                AND g.cd_lancamento_fat = itc.cd_lancamento
                AND reg.cd_reg_fat = itc.cd_reg_fat
                AND itc.cd_gru_fat = gf.cd_gru_fat
                AND g.cd_reg_amb IS NULL
                AND r.tp_repasse = 'G'
                and not exists(select 'X' from dbamv.itlan_med where cd_reg_fat = itc.cd_reg_fat and cd_lancamento = itc.cd_lancamento)

              UNION ALL

            SELECT 'GLO_INT' tipo, r.tp_repasse, (SELECT DT_FECHAMENTO FROM remessa_fatura where CD_REMESSA = reg.CD_REMESSA)COMPETENCIA_FATURAMENTO, r.dt_competencia dt_competencia,itc.sn_pertence_pacote, r.dt_repasse, r.ds_repasse, itr.cd_repasse, itr.cd_prestador, itr.cd_prestador_repasse, g.cd_reg_fat, g.cd_lancamento_fat, g.cd_reg_amb, g.cd_lancamento_amb, g.vl_base_repassado, itr.vl_glosa*(-1) vl_repasse
                  , reg.cd_atendimento, reg.cd_convenio
                  , dt_lancamento DT_LANCAMENTO
                  , hr_lancamento HR_LANCAMENTO
                  , itc.cd_pro_fat,gf.ds_gru_fat grupo,itc.qt_lancamento, itc.cd_ati_med, itr.cd_it_repasse , to_number(null)CD_IT_REPASSE_SIH, to_number(null)CD_IT_REPASSE_SIA, itr.vl_perc_repasse, g.cd_glosas, itc.cd_setor_produziu cd_setor
              FROM dbamv.repasse r
                  , dbamv.it_repasse itr
                  , dbamv.itreg_fat itc
                  , dbamv.glosas g
                  , dbamv.reg_fat reg
                  , dbamv.gru_fat gf
              WHERE r.cd_repasse = itr.cd_repasse
                AND g.cd_glosas = itr.cd_glosas
                AND g.cd_reg_fat = itc.cd_reg_fat
                AND g.cd_lancamento_fat = itc.cd_lancamento
                AND reg.cd_reg_fat = itc.cd_reg_fat
                AND itc.cd_gru_fat = gf.cd_gru_fat
                AND g.cd_reg_amb IS NULL
                AND r.tp_repasse = 'G'
                and not exists(select 'X' from dbamv.itlan_med where cd_reg_fat = itc.cd_reg_fat and cd_lancamento = itc.cd_lancamento)

              UNION ALL

            SELECT 'GLO_AMB' tipo, r.tp_repasse, (SELECT DT_FECHAMENTO FROM remessa_fatura where CD_REMESSA = reg.CD_REMESSA)COMPETENCIA_FATURAMENTO, r.dt_competencia dt_competencia,itc.sn_pertence_pacote, r.dt_repasse, r.ds_repasse, itr.cd_repasse, itr.cd_prestador, itr.cd_prestador_repasse, g.cd_reg_fat, g.cd_lancamento_fat, g.cd_reg_amb, g.cd_lancamento_amb, g.vl_base_repassado, itr.vl_glosa*(-1) vl_repasse
                  , itc.cd_atendimento, reg.cd_convenio
                  , dt_lancamento DT_LANCAMENTO
                  , hr_lancamento HR_LANCAMENTO
                  , itc.cd_pro_fat,gf.ds_gru_fat grupo, itc.qt_lancamento, itc.cd_ati_med, itr.cd_it_repasse, to_number(null)CD_IT_REPASSE_SIH, to_number(null)CD_IT_REPASSE_SIA, itr.vl_perc_repasse, g.cd_glosas, itc.cd_setor_produziu cd_setor
              FROM dbamv.repasse r
                  , dbamv.it_repasse itr
                  , dbamv.itreg_amb itc
                  , dbamv.glosas g
                  , dbamv.reg_amb reg
                  , dbamv.gru_fat gf
              WHERE r.cd_repasse = itr.cd_repasse
                AND g.cd_glosas = itr.cd_glosas
                AND g.cd_reg_amb = itc.cd_reg_amb
                AND g.cd_lancamento_amb = itc.cd_lancamento
                AND reg.cd_reg_amb = itc.cd_reg_amb
                AND itc.cd_gru_fat = gf.cd_gru_fat
                AND g.cd_reg_fat IS NULL
                AND r.tp_repasse = 'G'

              UNION ALL

            SELECT 'REC_INT' tipo, r.tp_repasse, (SELECT DT_FECHAMENTO FROM remessa_fatura where CD_REMESSA = reg.CD_REMESSA)COMPETENCIA_FATURAMENTO, r.dt_competencia dt_competencia,itc.sn_pertence_pacote, r.dt_repasse, r.ds_repasse, itr.cd_repasse, itr.cd_prestador, itr.cd_prestador_repasse, g.cd_reg_fat, g.cd_lancamento_fat, g.cd_reg_amb, g.cd_lancamento_amb, g.vl_recebido vl_base_repassado, itr.vl_repasse
                  , reg.cd_atendimento, reg.cd_convenio
                  , dt_lancamento DT_LANCAMENTO
                  , hr_lancamento HR_LANCAMENTO
                  , itc.cd_pro_fat,gf.ds_gru_fat grupo, itc.qt_lancamento, itc.cd_ati_med, itr.cd_it_repasse, to_number(null)CD_IT_REPASSE_SIH, to_number(null)CD_IT_REPASSE_SIA, itr.vl_perc_repasse, g.cd_glosas, itc.cd_setor_produziu cd_setor
              FROM dbamv.repasse r
                  , dbamv.it_repasse itr
                  , dbamv.itreg_fat itc
                  , dbamv.glosas g
                  , dbamv.reg_fat reg
                  , dbamv.gru_fat gf
              WHERE r.cd_repasse = itr.cd_repasse
                AND g.cd_glosas = itr.cd_glosas
                AND g.cd_reg_fat = itc.cd_reg_fat
                AND g.cd_lancamento_fat = itc.cd_lancamento
                AND reg.cd_reg_fat = itc.cd_reg_fat
                AND itc.cd_gru_fat = gf.cd_gru_fat
                AND g.cd_reg_amb IS NULL
                AND r.tp_repasse = 'R'

              UNION ALL

            SELECT 'REC_AMB' tipo, r.tp_repasse, (SELECT DT_FECHAMENTO FROM remessa_fatura where CD_REMESSA = reg.CD_REMESSA)COMPETENCIA_FATURAMENTO, r.dt_competencia dt_competencia,itc.sn_pertence_pacote, r.dt_repasse, r.ds_repasse, itr.cd_repasse, itr.cd_prestador, itr.cd_prestador_repasse, g.cd_reg_fat, g.cd_lancamento_fat, g.cd_reg_amb, g.cd_lancamento_amb, g.vl_recebido vl_base_repassado, itr.vl_repasse
                  , itc.cd_atendimento, reg.cd_convenio
                  , dt_lancamento DT_LANCAMENTO
                  , hr_lancamento HR_LANCAMENTO
                  , itc.cd_pro_fat,gf.ds_gru_fat grupo, itc.qt_lancamento, itc.cd_ati_med, itr.cd_it_repasse, to_number(null)CD_IT_REPASSE_SIH, to_number(null)CD_IT_REPASSE_SIA, itr.vl_perc_repasse, g.cd_glosas, itc.cd_setor_produziu cd_setor
              FROM dbamv.repasse r
                  , dbamv.it_repasse itr
                  , dbamv.itreg_amb itc
                  , dbamv.glosas g
                  , dbamv.reg_amb reg
                  , dbamv.gru_fat gf
              WHERE r.cd_repasse = itr.cd_repasse
                AND g.cd_glosas = itr.cd_glosas
                AND g.cd_reg_amb = itc.cd_reg_amb
                AND g.cd_lancamento_amb = itc.cd_lancamento
                AND reg.cd_reg_amb = itc.cd_reg_amb
                AND itc.cd_gru_fat = gf.cd_gru_fat
                AND g.cd_reg_fat IS NULL
                AND r.tp_repasse = 'R'

              UNION ALL

            SELECT  DECODE(r.tp_repasse,'F','FIXO','MANUAL') tipo
                  , DECODE(r.tp_repasse,'F','F','M') tp_repasse
                  , null COMPETENCIA_FATURAMENTO, r.dt_competencia dt_competencia, NULL sn_pertence_pacote, r.dt_repasse, r.ds_repasse, itr.cd_repasse, itr.cd_prestador, itr.cd_prestador_repasse, TO_NUMBER(null) cd_reg_fat, TO_NUMBER(null) cd_lancamento_fat, TO_NUMBER(null) cd_reg_amb, TO_NUMBER(null) cd_lancamento_amb, itr.vl_faturado vl_base_repassado, (Nvl(itr.vl_repasse,0)-Nvl(itr.vl_desconto,0)) vl_repasse
                  , TO_NUMBER(null) cd_atendimento,TO_NUMBER(null) cd_convenio
                  , r.dt_repasse DT_LANCAMENTO
                  , r.dt_repasse HR_LANCAMENTO
                  , TO_CHAR(null) cd_pro_fat,'' grupo, TO_NUMBER(null) qt_lancamento, TO_CHAR(null) cd_ati_med, to_number(null) cd_it_repasse, to_number(null) CD_IT_REPASSE_SIH, to_number(null) CD_IT_REPASSE_SIA, to_number(null) vl_perc_repasse, to_number(null) cd_glosas, itr.cd_setor cd_setor
              FROM dbamv.repasse r
                  , dbamv.repasse_prestador itr
             WHERE r.cd_repasse = itr.cd_repasse
               AND r.tp_repasse IN ('F','M','N','U','S','P')
       ) v,
       (SELECT * FROM dbamv.repasse_consolidado WHERE cd_it_repasse IS NOT NULL) rp_c,
       (SELECT * FROM dbamv.repasse_consolidado WHERE cd_it_repasse_sih IS NOT NULL) rp_sih,
       (SELECT * FROM dbamv.repasse_consolidado WHERE cd_it_repasse_sia IS NOT NULL) rp_sia,
       dbamv.pro_fat,
       dbamv.procedimento_sus,
       DBAMV.gru_pro,
       DBAMV.CON_PLA,
       setor,
       ori_ate,
       reg_repasse

 WHERE v.cd_convenio = convenio.cd_convenio (+)
   AND CON_PLA.cd_convenio(+) = convenio.CD_convenio
   AND ATENDIME.cd_CON_PLA = CON_PLA.CD_CON_PLA(+)
   AND gru_pro.cd_gru_fat = gru_fat.cd_gru_fat(+)
   AND atendime.cd_ori_ate = ori_Ate.cd_ori_ate (+)
   AND setor.cd_setor(+) = ori_ate.cd_setor
   AND setor.cd_setor(+) = v.cd_setor
   AND v.cd_prestador_repasse = EMPRESA_PRESTADOR.cd_prestador
   AND v.cd_prestador = prestador.cd_prestador
   AND EMPRESA_PRESTADOR.cd_reg_repasse = reg_repasse.cd_reg_repasse(+)
   AND v.cd_repasse = repasse.cd_repasse
   AND v.cd_atendimento = atendime.cd_atendimento(+)
   AND atendime.cd_paciente = paciente.cd_paciente(+)
   AND v.cd_ati_med = ati_med.cd_ati_med(+)
   AND rp_c.cd_it_repasse(+) = v.cd_it_repasse
   AND rp_sih.cd_it_repasse_sih(+) = v.cd_it_repasse_sih
   AND rp_sia.cd_it_repasse_sia(+) = v.cd_it_repasse_sia
   AND v.cd_pro_fat = pro_fat.cd_pro_fat(+)
   AND pro_fat.cd_gru_pro = gru_pro.cd_gru_pro(+)
   AND v.cd_pro_fat = procedimento_sus.cd_procedimento(+)
   AND v.cd_repasse = lr.cd_repasse
   AND EMPRESA_PRESTADOR.cd_prestador = gru_rep.CD_PRESTADOR
   AND EMPRESA_PRESTADOR.cd_multi_empresa = REPASSE.CD_MULTI_EMPRESA
   --AND v.dt_competencia BETWEEN to_date('01/05/2022','dd/mm/rrrr') AND to_date('31/05/2022','dd/mm/rrrr')
   AND REPASSE.CD_MULTI_EMPRESA = 7
   --AND EMPRESA_PRESTADOR.cd_prestador = 9814

   --ORDER BY 9
)
WHERE cd_gru_rep = 9814
AND competencia_repasse = '05/2022'