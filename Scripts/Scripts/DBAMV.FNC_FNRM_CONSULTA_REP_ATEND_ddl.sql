-- Start of DDL Script for Function DBAMV.FNC_FNRM_CONSULTA_REP_ATEND
-- Generated 2-dez-2011 15:34:12 from DBAMV@producao

-- Drop the old instance of FNC_FNRM_CONSULTA_REP_ATEND
DROP FUNCTION fnc_fnrm_consulta_rep_atend
/

CREATE OR REPLACE 
FUNCTION fnc_fnrm_consulta_rep_atend
  ( P_CD_ATENDIMENTO IN NUMBER ) RETURN number IS
CURSOR C_Atendimento IS
Select atendime.tp_atendimento,
       convenio.tp_convenio
from dbamv.atendime,
     dbamv.convenio
where atendime.cd_atendimento = P_CD_ATENDIMENTO
  and atendime.cd_convenio = convenio.cd_convenio;
CURSOR C_Convenio_Ambulatorial IS
SELECT SUM(VL_REPASSE)
FROM (
SELECT dbamv.Pkg_Repasse.Fn_Calcula(
              	                        atendime.cd_convenio
              		                     ,atendime.cd_ori_ate
              		                     ,pro_fat.cd_gru_pro
              		                     ,itreg_amb.cd_pro_fat
              		                     ,itreg_amb.sn_pertence_pacote
              		                     ,atendime.cd_tip_acom
              		                     ,itreg_amb.cd_setor
              		                     ,itreg_amb.cd_prestador
              		                     ,nvl(itreg_amb.vl_filme_unitario * itreg_amb.qt_lancamento, 0)
              		                     ,nvl(itreg_amb.vl_base_repassado, itreg_amb.vl_total_conta)
              		                     ,itreg_amb.qt_lancamento
              		                     ,empresa_prestador.cd_reg_repasse
              		                     ,sysdate
              		                     ,itreg_amb.cd_ati_med
              		                     ,atendime.tp_atendimento
              		                     ,itreg_amb.qt_ch_unitario
              		                     ,itreg_amb.cd_reg_amb
              		                     ,itreg_amb.hr_lancamento
              		                     ,atendime.dt_atendimento) 	vl_REPASSE
  FROM       dbamv.reg_amb reg_amb
            ,dbamv.itreg_amb itreg_amb
			,dbamv.pro_fat pro_fat
			,dbamv.atendime atendime
            ,dbamv.empresa_prestador empresa_prestador
	 WHERE  reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb 
        AND itreg_amb.cd_prestador IS NOT NULL
	    AND reg_amb.cd_remessa IS NOT NULL    
		AND itreg_amb.cd_pro_fat = pro_fat.cd_pro_fat
		AND itreg_amb.cd_atendimento = atendime.cd_atendimento
        AND nvl(itreg_amb.tp_pagamento,'P') = 'P'
        and itreg_amb.cd_prestador = empresa_prestador.cd_prestador
        and empresa_prestador.CD_MULTI_EMPRESA = DBAMV.PKG_MV2000.LE_EMPRESA
        AND ATENDIME.CD_ATENDIMENTO = P_CD_ATENDIMENTO
  -- PDA 271463 - Jamerson Nunes Delfino - 05/02/2009
  UNION ALL
    SELECT dbamv.Pkg_Repasse.Fn_Calcula(
              	                        atendime.cd_convenio
              		                     ,atendime.cd_ori_ate
              		                     ,pro_fat.cd_gru_pro
              		                     ,itreg_amb.cd_pro_fat
              		                     ,itreg_amb.sn_pertence_pacote
              		                     ,atendime.cd_tip_acom
              		                     ,itreg_amb.cd_setor
              		                     ,dbamv.pkg_repasse.Fn_cd_prestador
              		                     ,nvl(itreg_amb.vl_filme_unitario * itreg_amb.qt_lancamento, 0)
              		                     ,nvl(itreg_amb.vl_base_repassado, itreg_amb.vl_total_conta)
              		                     ,itreg_amb.qt_lancamento
              		                     ,dbamv.pkg_repasse.fn_reg_repasse
              		                     ,sysdate
              		                     ,itreg_amb.cd_ati_med
              		                     ,atendime.tp_atendimento
              		                     ,itreg_amb.qt_ch_unitario
              		                     ,itreg_amb.cd_reg_amb
              		                     ,itreg_amb.hr_lancamento
              		                     ,atendime.dt_atendimento) 	vl_REPASSE
  FROM       dbamv.reg_amb reg_amb
            ,dbamv.itreg_amb itreg_amb
			,dbamv.pro_fat pro_fat
			,dbamv.atendime atendime
	 WHERE  reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
        AND itreg_amb.cd_prestador IS NULL
        AND reg_amb.cd_remessa IS NOT NULL 
		AND itreg_amb.cd_pro_fat = pro_fat.cd_pro_fat
		AND itreg_amb.cd_atendimento = atendime.cd_atendimento
        AND nvl(itreg_amb.tp_pagamento,'P') = 'P'
        AND ATENDIME.CD_ATENDIMENTO = P_CD_ATENDIMENTO
    AND    ( exists (select cd_pro_fat from dbamv.pro_fat_sem_prestador
                      where cd_pro_fat is not null
                        and cd_pro_fat = itreg_amb.cd_pro_fat)
     OR      exists (select cd_gru_pro from dbamv.pro_fat_sem_prestador
                      where cd_gru_pro is not null
                        and cd_gru_pro = pro_fat.cd_gru_pro)
     OR      exists (select cd_servico from dbamv.pro_fat_sem_prestador
                      where cd_servico is not null
                        and cd_servico = atendime.cd_servico)
                        )
    AND    'V' = (dbamv.pkg_repasse.fn_regras(
                                        itreg_amb.cd_pro_fat
                                       ,pro_fat.cd_gru_pro
                                       ,itreg_amb.cd_setor
                                       ,atendime.cd_servico
                                       ,itreg_amb.cd_convenio
                                       ,atendime.cd_ori_ate
                                       ,itreg_amb.cd_ati_med
                                       ,atendime.tp_atendimento))
  -- PDA 271463 (Fim)
         );
CURSOR C_Convenio_Hospitalar IS
SELECT SUM(VL_REPASSE)
FROM (
select    dbamv.Pkg_Repasse.Fn_Calcula(
              	                        reg_fat.cd_convenio
              		                     ,atendime.cd_ori_ate
              		                     ,pro_fat.cd_gru_pro
              		                     ,itreg_fat.cd_pro_fat
              		                     ,itreg_fat.sn_pertence_pacote
              		                     ,reg_fat.cd_tip_acom
              		                     ,itreg_fat.cd_setor
              		                     ,itreg_fat.cd_prestador
              		                     ,nvl(itreg_fat.vl_filme_unitario * itreg_fat.qt_lancamento, 0)
              		                     ,nvl(itreg_fat.vl_base_repassado,itreg_fat.vl_total_conta)
              		                     ,itreg_fat.qt_lancamento
              		                     ,empresa_prestador.cd_reg_repasse
              		                     ,sysdate
              		                     ,itreg_fat.cd_ati_med
              		                     ,atendime.tp_atendimento
              		                     ,itreg_fat.qt_ch_unitario
              		                     ,itreg_fat.cd_reg_fat
              		                     ,itreg_fat.hr_lancamento
              		                     ,itreg_fat.dt_lancamento
                                       )	vl_repasse
  FROM dbamv.itreg_fat itreg_fat
			,dbamv.pro_fat pro_fat
			,dbamv.atendime atendime
            ,dbamv.reg_fat reg_fat
            ,dbamv.convenio convenio
            ,dbamv.empresa_prestador empresa_prestador
	 WHERE itreg_fat.cd_prestador IS NOT NULL
	    AND reg_fat.cd_remessa IS NOT NULL   
		AND itreg_fat.cd_pro_fat = pro_fat.cd_pro_fat
		AND reg_fat.cd_atendimento = atendime.cd_atendimento
        AND nvl(itreg_fat.tp_pagamento,'P') = 'P'
        AND reg_fat.cd_convenio = convenio.cd_convenio
        and reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat
        and convenio.tp_convenio <> 'H'
        and itreg_fat.cd_prestador = empresa_prestador.cd_prestador
        and empresa_prestador.CD_MULTI_EMPRESA = DBAMV.PKG_MV2000.LE_EMPRESA
        aND ATENDIME.CD_ATENDIMENTO = P_CD_ATENDIMENTO
-- PDA 271463 - Jamerson Nunes Delfino - 05/02/2009
  UNION ALL
   select    dbamv.Pkg_Repasse.Fn_Calcula(
              	                        reg_fat.cd_convenio
              		                     ,atendime.cd_ori_ate
              		                     ,pro_fat.cd_gru_pro
              		                     ,itreg_fat.cd_pro_fat
              		                     ,itreg_fat.sn_pertence_pacote
              		                     ,reg_fat.cd_tip_acom
              		                     ,itreg_fat.cd_setor
              		                     ,dbamv.pkg_repasse.Fn_cd_prestador
              		                     ,nvl(itreg_fat.vl_filme_unitario * itreg_fat.qt_lancamento, 0)
              		                     ,nvl(itreg_fat.vl_base_repassado,itreg_fat.vl_total_conta)
              		                     ,itreg_fat.qt_lancamento
              		                     ,dbamv.pkg_repasse.fn_reg_repasse
              		                     ,sysdate
              		                     ,itreg_fat.cd_ati_med
              		                     ,atendime.tp_atendimento
              		                     ,itreg_fat.qt_ch_unitario
              		                     ,itreg_fat.cd_reg_fat
              		                     ,itreg_fat.hr_lancamento
              		                     ,itreg_fat.dt_lancamento
                                       )	vl_repasse
  FROM dbamv.itreg_fat itreg_fat
			,dbamv.pro_fat pro_fat
			,dbamv.atendime atendime
            ,dbamv.reg_fat reg_fat
            ,dbamv.convenio convenio
	 WHERE itreg_fat.cd_prestador IS NULL
        AND reg_fat.cd_remessa IS NOT NULL
		AND itreg_fat.cd_pro_fat = pro_fat.cd_pro_fat
		AND reg_fat.cd_atendimento = atendime.cd_atendimento
    AND nvl(itreg_fat.tp_pagamento,'P') = 'P'
    AND reg_fat.cd_convenio = convenio.cd_convenio
    and reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat
    and convenio.tp_convenio <> 'H'
    aND ATENDIME.CD_ATENDIMENTO = P_CD_ATENDIMENTO
    AND not exists ( select 1 from dbamv.itlan_med where cd_lancamento = itreg_fat.cd_lancamento and cd_reg_fat = itreg_fat.cd_reg_fat)
    AND ( exists (select 1 from dbamv.pro_fat_sem_prestador where cd_pro_fat is not null
                                                            and cd_pro_fat = itreg_fat.cd_pro_fat)
        OR exists (select 1 from dbamv.pro_fat_sem_prestador where cd_gru_pro is not null
                                                             and cd_gru_pro = pro_fat.cd_gru_pro)
        OR exists (select 1 from dbamv.pro_fat_sem_prestador where cd_servico is not null
                                                             and cd_servico = atendime.cd_servico) )
     AND   'V' = (dbamv.pkg_repasse.fn_regras(itreg_fat.cd_pro_fat
                                       ,pro_fat.cd_gru_pro
                                       ,itreg_fat.cd_setor
                                       ,atendime.cd_servico
              												 ,reg_fat.cd_convenio
                                       ,atendime.cd_ori_ate
                                       ,itreg_fat.cd_ati_med
                                       ,atendime.tp_atendimento)
				          )
-- PDA 271463 (Fim)
	UNION ALL
   SELECT distinct dbamv.Pkg_Repasse.Fn_Calcula(
              	                        reg_fat.cd_convenio
              		                     ,atendime.cd_ori_ate
              		                     ,pro_fat.cd_gru_pro
              		                     ,itreg_fat.cd_pro_fat
              		                     ,itreg_fat.sn_pertence_pacote
              		                     ,reg_fat.cd_tip_acom
              		                     ,itreg_fat.cd_setor
              		                     ,itlan_med.cd_prestador
                                         -- PDA 244530 (Inicio) - Henrique Antunes - 19/09/2008
              		                     --,nvl(itreg_fat.vl_filme_unitario * itreg_fat.qt_lancamento, 0)
              		                     --,nvl(itreg_fat.vl_total_conta, 0)
              		                     ,0
              		                     ,nvl(itlan_med.vl_base_repassado, itreg_fat.vl_total_conta)
                                         -- PDA 244530 (Fim)
              		                     ,itreg_fat.qt_lancamento
              		                     ,empresa_prestador.cd_reg_repasse
              		                     ,sysdate
              		                     ,itlan_med.cd_ati_med
              		                     ,atendime.tp_atendimento
              		                     ,itreg_fat.qt_ch_unitario
              		                     ,itreg_fat.cd_reg_fat
              		                     ,itreg_fat.hr_lancamento
              		                     ,itreg_fat.dt_lancamento
                                       )	vl_repasse
  FROM dbamv.itreg_fat itreg_fat
			,dbamv.itlan_med itlan_med
			,dbamv.pro_fat pro_fat
			,dbamv.atendime atendime
            ,dbamv.reg_fat reg_fat
            ,dbamv.convenio convenio
            ,dbamv.empresa_prestador empresa_prestador
	 WHERE itreg_fat.cd_prestador IS NULL
        AND reg_fat.cd_remessa IS NOT NULL
		AND itreg_fat.cd_pro_fat = pro_fat.cd_pro_fat
		AND reg_fat.cd_atendimento = atendime.cd_atendimento
        -- PDA 244530 (Inicio) - Henrique Antunes - 19/09/2008
        --AND    nvl(itreg_fat.tp_pagamento,'P') = 'P'
        AND    nvl(itlan_med.tp_pagamento,'P') = 'P'
        -- PDA 244530 (Fim)
        AND reg_fat.cd_convenio = convenio.cd_convenio
        and reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat
        and convenio.tp_convenio <> 'H'
		AND reg_fat.cd_reg_fat = itlan_med.cd_reg_fat
		AND itreg_fat.cd_lancamento = itlan_med.cd_lancamento
        and itlan_med.cd_prestador = empresa_prestador.cd_prestador
        and empresa_prestador.CD_MULTI_EMPRESA = DBAMV.PKG_MV2000.LE_EMPRESA
        aND ATENDIME.CD_ATENDIMENTO = P_CD_ATENDIMENTO );
CURSOR C_SUS_Ambulatorial IS
SELECT SUM(VL_REPASSE)
FROM (	SELECT atendime.cd_atendimento cd_atendimento,
           NVL (dbamv.pkg_repasse.fnc_fnrm_retorna_repasse_sia, 0) vl_repasse
	  FROM dbamv.eve_siasus eve_siasus
			,dbamv.val_tab_siasus val_tab
			,dbamv.atendime atendime
			,dbamv.empresa_prestador empresa_prestador
            ,dbamv.prestador prestador
            ,dbamv.tab_siasus tab_siasus
	 WHERE empresa_prestador.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
        and eve_siasus.cd_ssm = tab_siasus.cd_ssm
		AND tab_siasus.cd_ssm = val_tab.cd_ssm
        aND eve_siasus.cd_prestador IS NOT NULL
        and eve_siasus.cd_prestador = prestador.cd_prestador
		AND eve_siasus.cd_prestador_pode_ter IS NULL
		AND tab_siasus.cd_ssm = val_tab.cd_ssm
		AND val_tab.dt_vigencia = (SELECT MAX (val_sia.dt_vigencia)
											  FROM dbamv.val_tab_siasus val_sia
											 WHERE val_sia.cd_ssm = val_tab.cd_ssm
												AND val_sia.dt_vigencia < sysdate)
        AND    eve_siasus.cd_atendimento  = atendime.cd_atendimento
		AND prestador.cd_prestador = empresa_prestador.cd_prestador
        AND NVL(prestador.tp_vinculo, 'X') != 'U'
		AND eve_siasus.qt_lancada > 0
        aND ATENDIME.CD_ATENDIMENTO = P_CD_ATENDIMENTO
        AND 0 =	 dbamv.pkg_repasse.fnc_fnrm_calcula_repasse_sia (empresa_prestador.cd_reg_repasse_sia, prestador.cd_prestador
																				,eve_siasus.cd_convenio, eve_siasus.cd_ori_ate, eve_siasus.cd_tip_ate
																				,eve_siasus.cd_especialid, eve_siasus.cd_ssm, atendime.tp_atendimento
																				,eve_siasus.qt_lancada, NVL (atendime.hr_atendimento, SYSDATE)
																				,eve_siasus.dt_eve_siasus, 'M'
																				, NVL (eve_siasus.qt_lancada, 0) * NVL (val_tab.vl_geral, 0)
																				, NVL (eve_siasus.qt_lancada, 0) * NVL (val_tab.vl_auxiliar, 0)
																				, NVL (eve_siasus.qt_lancada, 0) * NVL (val_tab.vl_outros, 0)
																				,	 NVL (eve_siasus.qt_lancada, 0))
	UNION ALL
	SELECT atendime.cd_atendimento cd_atendimento,
           NVL (dbamv.pkg_repasse.fnc_fnrm_retorna_repasse_sia, 0) vl_repasse
	  FROM dbamv.eve_siasus eve_siasus
			,dbamv.val_tab_siasus val_tab
			,dbamv.atendime atendime
			,dbamv.empresa_prestador empresa_prestador
            ,dbamv.prestador prestador
            ,dbamv.tab_siasus tab_siasus
	 WHERE empresa_prestador.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
        and eve_siasus.cd_ssm = tab_siasus.cd_ssm
		AND tab_siasus.cd_ssm = val_tab.cd_ssm
        aND eve_siasus.cd_prestador IS NULL
        and eve_siasus.cd_prestador_pode_ter = prestador.cd_prestador
		AND eve_siasus.cd_prestador_pode_ter IS NOT NULL
		AND tab_siasus.cd_ssm = val_tab.cd_ssm
		AND val_tab.dt_vigencia = (SELECT MAX (val_sia.dt_vigencia)
											  FROM dbamv.val_tab_siasus val_sia
											 WHERE val_sia.cd_ssm = val_tab.cd_ssm
												AND val_sia.dt_vigencia < sysdate)
        AND    eve_siasus.cd_atendimento  = atendime.cd_atendimento
		AND prestador.cd_prestador = empresa_prestador.cd_prestador
        AND NVL(prestador.tp_vinculo, 'X') != 'U'
		AND eve_siasus.qt_lancada > 0
        aND ATENDIME.CD_ATENDIMENTO = P_CD_ATENDIMENTO
        AND 0 =	 dbamv.pkg_repasse.fnc_fnrm_calcula_repasse_sia (empresa_prestador.cd_reg_repasse_sia, prestador.cd_prestador
																				,eve_siasus.cd_convenio, eve_siasus.cd_ori_ate, eve_siasus.cd_tip_ate
																				,eve_siasus.cd_especialid, eve_siasus.cd_ssm, atendime.tp_atendimento
																				,eve_siasus.qt_lancada, NVL (atendime.hr_atendimento, SYSDATE)
																				,eve_siasus.dt_eve_siasus, 'A'
																				, NVL (eve_siasus.qt_lancada, 0) * NVL (val_tab.vl_geral, 0)
																				, NVL (eve_siasus.qt_lancada, 0) * NVL (val_tab.vl_auxiliar, 0)
																				, NVL (eve_siasus.qt_lancada, 0) * NVL (val_tab.vl_outros, 0)
																				,	 NVL (eve_siasus.qt_lancada, 0)));
CURSOR C_SUS_Hospitalar IS
SELECT SUM(VL_REPASSE)
FROM (	SELECT atendime.cd_atendimento cd_atendimento,
           NVL (dbamv.pkg_repasse.fnc_fnrm_retorna_repasse_siH, 0) vl_repasse
	  FROM dbamv.reg_fat reg_fat
			,dbamv.itreg_fat itreg_fat
			,dbamv.pro_fat pro_fat
			,dbamv.atendime atendime
			,dbamv.prestador prestador
			,dbamv.glosas_sus glosas_sus
			,dbamv.config_ffcv config_ffcv
			,dbamv.v_vl_ponto_aih v_vl_ponto_aih
			,dbamv.config_ffis config_ffis
			,dbamv.pres_con pres_con
			,dbamv.itens_sd_ffis itens_sd_ffis
			,dbamv.empresa_prestador empresa_prestador
            ,DBAMV.CONVENIO CONVENIO
	 WHERE Config_Ffcv.Cd_Multi_Empresa = Dbamv.Pkg_Mv2000.Le_Empresa
        AND itreg_fat.cd_prestador IS NOT NULL
		AND itreg_fat.cd_reg_fat = reg_fat.cd_reg_fat
		AND convenio.cd_convenio = config_ffis.cd_convenio
		AND itreg_fat.cd_pro_fat = pro_fat.cd_pro_fat
		AND prestador.cd_prestador = pres_con.cd_prestador
		AND convenio.cd_convenio = pres_con.cd_convenio
        aND ATENDIME.CD_ATENDIMENTO = P_CD_ATENDIMENTO
		AND itreg_fat.cd_reg_fat = itens_sd_ffis.cd_reg_fat(+)
		AND itreg_fat.cd_lancamento = itens_sd_ffis.cd_lancamento(+)
		AND reg_fat.cd_atendimento = atendime.cd_atendimento
		AND itreg_fat.cd_prestador = prestador.cd_prestador
		AND v_vl_ponto_aih.cd_reg_fat = reg_fat.cd_reg_fat
		AND reg_fat.cd_reg_fat = glosas_sus.cd_reg_fat(+)
		AND ( 	(	  glosas_sus.cd_glosas_sus IS NOT NULL
					 AND config_ffcv.sn_repassa_glosa_sih = 'N')
			  OR (glosas_sus.cd_glosas_sus IS NULL)
			 )
		AND itreg_fat.cd_tipo_vinculo NOT IN (6, 7, 8, 17, 21, 23, 29, 40, 44)
		AND NVL(prestador.tp_vinculo, 'X') != 'U'
		AND prestador.cd_prestador = empresa_prestador.cd_prestador
		AND empresa_prestador.cd_multi_empresa = reg_fat.cd_multi_empresa
				  AND 0 =
							dbamv.pkg_repasse.fnc_fnrm_calcula_repasse_sih (empresa_prestador.cd_reg_repasse_sih, atendime.cd_ori_ate
																						  ,pro_fat.cd_sus, reg_fat.cd_espec_sus
																						  ,itreg_fat.hr_lancamento, itreg_fat.dt_lancamento
																						  ,prestador.cd_prestador, NULL, itreg_fat.qt_pontos
																							,NVL (  DECODE (config_ffcv.sn_repassa_glosa_sih
																												,'N', itens_sd_ffis.vl_sd
																												,NVL (itens_sd_ffis.vl_sd_sem_glosa
																													  ,itens_sd_ffis.vl_sd)
																												)
																									/ DECODE (NVL (itreg_fat.qt_pontos, 0)
																												,0, 1
																												,itreg_fat.qt_pontos
																												)
																								  ,v_vl_ponto_aih.valor_ponto)
																							,itreg_fat.vl_sh, itreg_fat.vl_sp
																						  ,DECODE (config_ffcv.sn_repassa_glosa_sih
																									 ,'N', itens_sd_ffis.vl_sd
																									 ,NVL (itens_sd_ffis.vl_sd_sem_glosa
																											,itens_sd_ffis.vl_sd)
																									 )
																						  ,itreg_fat.vl_ato)
	UNION ALL
	SELECT atendime.cd_atendimento cd_atendimento,
           NVL (dbamv.pkg_repasse.fnc_fnrm_retorna_repasse_siH, 0) vl_repasse
	  FROM dbamv.reg_fat reg_fat
			,dbamv.itreg_fat itreg_fat
			,dbamv.pro_fat pro_fat
			,dbamv.atendime atendime
			,dbamv.prestador prestador
			,dbamv.glosas_sus glosas_sus
			,dbamv.config_ffcv config_ffcv
			,dbamv.v_vl_ponto_aih v_vl_ponto_aih
			,dbamv.config_ffis config_ffis
			,dbamv.pres_con pres_con
			,dbamv.itens_sd_ffis itens_sd_ffis
			,dbamv.empresa_prestador empresa_prestador
            ,DBAMV.CONVENIO CONVENIO
			,dbamv.itlan_med itlan_med
	 WHERE Config_Ffcv.Cd_Multi_Empresa = Dbamv.Pkg_Mv2000.Le_Empresa
        AND itreg_fat.cd_reg_fat = reg_fat.cd_reg_fat
		AND reg_fat.cd_convenio = convenio.cd_convenio
		AND convenio.cd_convenio = config_ffis.cd_convenio
		AND itreg_fat.cd_pro_fat = pro_fat.cd_pro_fat
        aND ATENDIME.CD_ATENDIMENTO = P_CD_ATENDIMENTO
		AND prestador.cd_prestador = pres_con.cd_prestador
		AND convenio.cd_convenio = pres_con.cd_convenio
		AND itreg_fat.cd_reg_fat = itens_sd_ffis.cd_reg_fat(+)
		AND itreg_fat.cd_lancamento = itens_sd_ffis.cd_lancamento(+)
		AND reg_fat.cd_atendimento = atendime.cd_atendimento
		AND itlan_med.cd_prestador = prestador.cd_prestador
		AND itlan_med.cd_reg_fat = itreg_fat.cd_reg_fat
		AND itlan_med.cd_lancamento = itreg_fat.cd_lancamento
		AND v_vl_ponto_aih.cd_reg_fat = reg_fat.cd_reg_fat
		AND reg_fat.cd_reg_fat = glosas_sus.cd_reg_fat(+)
		AND ( 	(	  glosas_sus.cd_glosas_sus IS NOT NULL
					 AND config_ffcv.sn_repassa_glosa_sih = 'N')
			  OR (glosas_sus.cd_glosas_sus IS NULL)
			 )
		AND itlan_med.cd_tipo_vinculo NOT IN (6, 7, 8, 17, 21, 23, 29, 40, 44)
		AND NVL(prestador.tp_vinculo, 'X') != 'U'
		AND prestador.cd_prestador = empresa_prestador.cd_prestador
		AND empresa_prestador.cd_multi_empresa = reg_fat.cd_multi_empresa
				  AND 0 =
							dbamv.pkg_repasse.fnc_fnrm_calcula_repasse_sih (empresa_prestador.cd_reg_repasse_sih, atendime.cd_ori_ate
																						  ,pro_fat.cd_sus, reg_fat.cd_espec_sus
																						  ,itreg_fat.hr_lancamento, itreg_fat.dt_lancamento
																						  ,prestador.cd_prestador, itlan_med.cd_ati_med
																						  ,itlan_med.qt_pontos
																							,NVL (  DECODE (config_ffcv.sn_repassa_glosa_sih
																												,'N', itens_sd_ffis.vl_sd
																												,NVL (itens_sd_ffis.vl_sd_sem_glosa
																													  ,itens_sd_ffis.vl_sd)
																												)
																									/ DECODE (NVL (itreg_fat.qt_pontos, 0)
																												,0, 1
																												,itreg_fat.qt_pontos
																												)
																								  ,v_vl_ponto_aih.valor_ponto)
																							,0, 0, 0
																						  ,NVL (NVL (itlan_med.vl_liquido, itlan_med.vl_ato), 0) ));
 v_tp_atendimento varchar2(1);
 v_tp_convenio    varchar2(1);
 nvl_repasse      dbamv.it_repasse.vl_repasse%type;
 BEGIN
   OPEN C_Atendimento ;
   FETCH C_Atendimento INTO v_tp_atendimento,v_tp_convenio ;
   CLOSE C_Atendimento ;
   IF v_tp_atendimento in ('A','E','U') and v_tp_convenio IN ('C','P') then
      OPEN C_Convenio_Ambulatorial ;
      FETCH C_Convenio_Ambulatorial INTO nvl_repasse ;
      CLOSE C_Convenio_Ambulatorial ;
   ELSIF v_tp_atendimento = 'I' and v_tp_convenio IN ('C','P') then
      OPEN C_Convenio_Hospitalar ;
      FETCH C_Convenio_Hospitalar INTO nvl_repasse ;
      CLOSE C_Convenio_Hospitalar ;
   ELSIF v_tp_atendimento in ('A','E','U') and v_tp_convenio = 'A' then
      OPEN C_SUS_Ambulatorial ;
      FETCH C_SUS_Ambulatorial INTO nvl_repasse ;
      CLOSE C_SUS_Ambulatorial ;
   ELSIF v_tp_atendimento = 'I' and v_tp_convenio = 'H' then
      OPEN C_SUS_Hospitalar ;
      FETCH C_SUS_Hospitalar INTO nvl_repasse ;
      CLOSE C_SUS_Hospitalar ;
   END IF;
   RETURN nvl(nvl_repasse,0) ;
END;
/

-- Grants for Function
GRANT EXECUTE ON fnc_fnrm_consulta_rep_atend TO mv2000
/
GRANT EXECUTE ON fnc_fnrm_consulta_rep_atend TO dbaps
/
GRANT EXECUTE ON fnc_fnrm_consulta_rep_atend TO dbasgu
/
GRANT EXECUTE ON fnc_fnrm_consulta_rep_atend TO mvintegra
/


-- End of DDL Script for Function DBAMV.FNC_FNRM_CONSULTA_REP_ATEND

