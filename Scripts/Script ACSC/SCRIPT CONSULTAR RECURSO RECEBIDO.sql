Select reg_fat.cd_atendimento,
       reg_fat.cd_reg_fat cd_conta_ffcv,
       dbamv.pkg_rmi_traducao.extrair_proc_msg('MSG_1', 'V_CONTAS_FNFI_FFCV', 'Hospitalar') tp_conta,
       Decode( reg_fat.sn_fechada, 'S', dbamv.pkg_rmi_traducao.extrair_proc_msg('MSG_2', 'V_CONTAS_FNFI_FFCV', 'Fechada'), dbamv.pkg_rmi_traducao.extrair_proc_msg('MSG_3', 'V_CONTAS_FNFI_FFCV', 'Aberta')) status,
       reg_fat.sn_fechada sn_status,
       reg_fat.cd_convenio,
       reg_fat.cd_con_pla, -- Pda 92886
       reg_fat.cd_pro_fat_solicitado cd_pro_int_procedimento_entrad,
       reg_fat.cd_remessa,
       atendime.cd_paciente,
       paciente.nm_paciente,
       --guia2.nr_guia, -- Pda 92886
       reg_fat.vl_total_conta sum_vl_total_conta, -- Pda 92886
       remessa_fatura.dt_entrega_da_fatura,
       remessa_fatura.nr_remessa_convenio, --,
       reg_fat.tp_classificacao_conta,
       atendime.nr_guia_envio_principal,
       'H' tp_faturamento, -- OP 44023
     reg_fat.dt_inicio  data_abertura,
       reg_fat.dt_final    data_fechamento
  From dbamv.reg_fat,
       dbamv.atendime,
       dbamv.paciente,
       dbamv.remessa_fatura -- Pda 92886
 Where atendime.cd_atendimento = reg_fat.cd_atendimento
   --AND ATENDIME.CD_MULTI_EMPRESA = DBAMV.PKG_MV2000.LE_EMPRESA \\\ FVDS
   and paciente.cd_paciente = atendime.cd_paciente
   and remessa_fatura.cd_remessa (+) = reg_fat.cd_remessa
   and atendime.cd_atendimento = &atendimento
Union All
Select atendime.cd_atendimento,
       reg_amb.cd_reg_amb,
       'Ambulatorial' tp_conta,
       Decode( itreg_amb.sn_fechada, 'S', 'Fechada', 'Aberta' ) status,
       itreg_amb.sn_fechada sn_status,
       reg_amb.cd_convenio,
       atendime.cd_con_pla,--PDA 239489 - Marinita Kommers - 15/07/2008
       Null cd_pro_int_procedimento_entrad,
       reg_amb.cd_remessa,
       atendime.cd_paciente,
       paciente.nm_paciente,
       Sum( itreg_amb.vl_total_conta ) sum_vl_total_conta,
       remessa_fatura.dt_entrega_da_fatura,
       remessa_fatura.nr_remessa_convenio , --,
       to_char(null), --PDA 185183
       atendime.nr_guia_envio_principal,
       'A' tp_faturamento, -- OP 44023
     To_Date(to_char(atendime.dt_atendimento,'dd/mm/yyyy')||' '||to_char(atendime.hr_atendimento,'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')   data_abertura,
       To_Date(to_char(atendime.dt_atendimento,'dd/mm/yyyy')||' '||to_char(atendime.hr_atendimento,'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')   data_fechamento
  From dbamv.atendime,
       dbamv.reg_amb,
       dbamv.paciente,
       dbamv.itreg_amb,
       dbamv.remessa_fatura--,
 Where atendime.cd_atendimento = itreg_amb.cd_atendimento
   --AND ATENDIME.CD_MULTI_EMPRESA = DBAMV.PKG_MV2000.LE_EMPRESA
   and reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
   and paciente.cd_paciente = atendime.cd_paciente
   and remessa_fatura.cd_remessa (+) = reg_amb.cd_remessa
   and Nvl( itreg_amb.sn_pertence_pacote, 'N' ) = 'N'
   and Nvl( itreg_amb.tp_pagamento, 'P' ) <> 'C'
   and atendime.cd_atendimento = &atendimento
Group by atendime.cd_atendimento,
       reg_amb.cd_reg_amb,
       'Ambulatorial',
       itreg_amb.sn_fechada,
       reg_amb.cd_convenio,
       atendime.cd_con_pla,--PDA 239489 - Marinita Kommers - 15/07/2008
       reg_amb.cd_remessa,
       atendime.cd_paciente,
       paciente.nm_paciente,
       remessa_fatura.dt_entrega_da_fatura,
       remessa_fatura.nr_remessa_convenio,
       atendime.nr_guia_envio_principal,
       'A',
     To_Date(to_char(atendime.dt_atendimento,'dd/mm/yyyy')||' '||to_char(atendime.hr_atendimento,'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
;
