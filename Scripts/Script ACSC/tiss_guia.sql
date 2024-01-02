select 
ID,ID_PAI,NM_XML,NR_REGISTRO_OPERADORA_ANS,CD_PRESTADOR_NA_OPERADORA,NR_GUIA,NR_GUIA_OPERADORA,NR_ID_BENEFICIARIO,DT_EMISSAO,NR_GUIA_PRINCIPAL,
DT_EMISSAO_PRINCIPAL,NR_CARTEIRA,DT_VALIDADE,NM_PACIENTE,DS_CON_PLA,NM_TITULAR,NR_CNS,CD_CGC_CPF_SOL,NM_PRESTADOR_SOL,DS_CODIGO_CONSELHO_SOL,
DS_CONSELHO_SOL,UF_CONSELHO_SOL,CD_CBOS_SOL,CD_CGC_SOL,CD_CPF_SOL,CD_OPERADORA_SOL,CD_TIPO_LOGRADOURO_SOL,DS_ENDERECO_SOL,NR_ENDERECO_SOL,
CD_IBGE_SOL,UF_SOL,NR_CEP_SOL,CD_CNES_SOL,DS_COMPLEMENTO_SOL,CD_CGC_CPF_EXE,NM_PRESTADOR_EXE,CD_CNES_EXE,CD_TIPO_LOGRADOURO_EXE,DS_ENDERECO_EXE,
NR_ENDERECO_EXE,NM_BAIRRO_EXE,CD_IBGE_EXE,UF_EXE,NR_CEP_EXE,CD_CGC_EXE,CD_CPF_EXE,CD_OPERADORA_EXE,DS_CONSELHO_EXE,DS_CODIGO_CONSELHO_EXE,
UF_CONSELHO_EXE,DS_COMPLEMENTO_EXE,NM_CIDADE_EXE,CD_CBOS_EXE,CD_ATI_MED_EXE,DS_HDA,CD_CARATER_SOLICITACAO,DH_ATENDIMENTO,TP_SAIDA,TP_ATENDIMENTO,
TP_FATURAMENTO,TP_CID,CD_CID,DS_CID,DT_AUTORIZACAO,CD_SENHA,DT_VALIDADE_AUTORIZADA,NM_AUTORIZADOR_CONV,VL_TOT_SERVICOS,VL_TOT_DIARIAS,VL_TOT_TAXAS,
VL_TOT_MATERIAIS,VL_TOT_MEDICAMENTOS,VL_TOT_GASES,VL_TOT_GERAL,CD_TIP_ACOM,DH_ALTA,CD_TIPO_INTERNACAO,TP_DOENCA,NR_TEMPO_DOENCA,TP_TEMPO_DOENCA
,DS_OBSERVACAO,NR_GUIA_SOL,TP_REGIME_INTERNACAO,SN_GESTACAO,SN_ABORTO,SN_TRANSTORNO,SN_COMPLICACAO,SN_ATEND_SL_PARTO,SN_COMPLICACAO_NEO
,SN_BAIXO_PESO,SN_CESAREO,SN_NORMAL,CD_DECL_NASCIDOS_VIVOS,QT_NASCIDOS_VIVOS,QT_NASCIDOS_PREMATUROS,QT_NASCIDOS_MORTOS,TP_OBITO_MULHER
,QT_OBITO_PRECOCE,QT_OBITO_TARDIO,TP_ACIDENTE,CD_MOTIVO_ALTA,CD_SUS,NR_DIARIAS_UTI,TP_CID_OBITO,CD_CID_OBITO,DS_CID_OBITO,NR_DECLARACAO_OBITO
,CD_TIPO_FATURAMENTO,VL_TOTAL_GERAL_PROC,VL_TOTAL_GERAL_OPME,VL_TOTAL_GERAL_OUTRAS,VL_TOTAL_GERAL_HONO,NR_LOTE,SN_TRATOU_RETORNO,CD_SEQ_TRANSACAO
,CD_REMESSA,CD_ATENDIMENTO,CD_REG_FAT,CD_REG_AMB,CD_CONVENIO,CD_GUIA,NM_PRESTADOR_EXE_COMPL,CD_CGC_EXE_COMPL,CD_CPF_EXE_COMPL,CD_OPERADORA_EXE_COMPL
,NM_CIDADE_SOL,CD_STATUS_CANCELAMENTO,NM_PRESTADOR_CONTRATADO,CD_CGC_CONTRATADO,CD_CPF_CONTRATADO,CD_OPERADORA_CONTRATADO,CD_REMESSA_GLOSA
,DS_CONSELHO_CONTRATADO,DS_COD_CONSELHO_CONTRATADO,UF_CONSELHO_CONTRATADO,CD_FONTE_PAGADORA,SN_ATENDIMENTO_RN,DT_INICIO_FATURAMENTO,HR_INICIO_FATURAMENTO
,DT_FINAL_FATURAMENTO,HR_FINAL_FATURAMENTO,VL_TOT_OPME,TP_CONSULTA,TP_TAB_FAT_CO,CD_PROCEDIMENTO_CO,VL_PROCEDIMENTO_CO,DS_INCONSISTENCIAS,CD_VERSAO_TISS_GERADA
,SN_GUIA_ALTERADA,DS_HIST_REAPRESENTACAO,CD_AUSENCIA_VALIDACAO,CD_VALIDACAO,TP_ETAPA_AUTORIZACAO,TP_IDENT_BENEFICIARIO,DS_TEMPLATE_IDENT_BENEFICIARIO
, ''hr_inicio, ''hr_fim, ''tp_tab_fat, ''cd_procedimento, ''ds_procedimento, ''qt_realizada, ''cd_via_acesso, ''tp_tecnica_utilizada, ''vl_percentual_multipla
, ''vl_unitario, ''vl_total, ''dt_realizado, ''qt_autorizada, ''cd_pro_fat, ''tp_pagamento, ''ds_justificativa_revisao, ''dt_final, ''cd_motivo_glosa
, ''cd_ati_med, ''sq_item, ''nr_pagina, ''nr_linha, ''cd_mvto, ''tp_mvto, ''cd_itmvto, ''sn_principal, ''sq_Ref, ''nr_autorizacao, ''TP_DESPESA, ''dt_realizado
from
dbamv.tiss_Guia

;
select 
ID,ID_PAI,''nm_xml,''nr_registro_operadora_ans,''cd_prestador_na_operadora,'' nr_guia ,''nr_guia_operadora ,''nr_id_beneficiario ,'' dt_emissao
 ,''nr_Guia_principal,''dt_emissao_principal,'' nr_carteira,'' dt_validade,'' nm_paciente,'' ds_con_pla,''nm_titular,''nr_cns,''cd_cgc_cpf_sol
 ,''nm_prestador_sol,''ds_codigo_conselho_sol,''ds_conselho_sol,''uf_conselho_sol,''cd_cbos_sol,''cd_cgc_sol,''cd_cpf_sol,''cd_operadora_sol
 ,''cd_tipo_logradouro_sol ,'' ds_endereco_sol ,''nr_endereco_sol ,''cd_ibge_sol ,''uf_sol ,''nr_cep_sol ,''cd_cnes_sol ,''ds_complemento_sol
 ,''cd_cgc_cpf_exe ,''nm_prestador_exe ,''cd_cnes_exe ,''cd_tipo_logradouro_exe ,''ds_endereco_exe ,''nr_endereco_exe ,''nm_bairro_exe
 ,''cd_ibge_exe ,''uf_exe ,''nr_cep_exe ,''cd_cgc_exe ,''cd_cpf_exe ,''cd_operadora_exe ,''ds_conselho_exe ,''ds_codigo_conselho_exe ,''uf_conselho_exe
 ,''ds_complemento_exe ,''nm_cidade_exe ,''cd_cbos_exe ,''cd_ati_med_exe ,''ds_hda ,''cd_carater_solicitacao ,''dh_atendimento ,''tp_saida ,''tp_atendimento
 ,''tp_faturamento ,''tp_cid ,''cd_cid ,''ds_cid ,''dt_autorizacao ,''cd_senha ,''dt_validade_autorizada ,''nm_autorizador_conv ,''vl_tot_servicos
 ,''vl_tot_diarias ,''vl_tot_taxas ,''vl_tot_materiais ,''vl_tot_medicamentos ,''vl_tot_gases ,''vl_tot_geral ,''cd_tip_acom ,''dh_alta ,''cd_tipo_internacao
 ,''tp_doenca ,''nr_tempo_doenca ,''tp_tempo_doenca ,''ds_observacao ,''nr_guia_sol ,''tp_regime_internacao ,''sn_gestacao ,''sn_aborto ,''sn_transtorno
 ,''sn_complicacao ,''sn_atend_sl_parto ,''sn_complicacao_neo ,''sn_baixo_peso ,''sn_cesareo ,''sn_normal ,''cd_decl_nascidos_vivos ,''qt_nascidos_vivos
 ,''qt_nascidos_prematuros ,''qt_nascidos_mortos ,''tp_obito_mulher ,''qt_obito_precoce ,''qt_obito_tardio ,''tp_acidente ,''cd_motivo_alta ,''cd_sus
 ,''nr_diarias_uti ,''tp_cid_obito ,''cd_cid_obito ,''ds_cid_obito ,''nr_declaracao_obito ,''cd_tipo_faturamento ,''vl_total_geral_proc ,''vl_total_geral_opme
 ,''vl_total_geral_outras ,''vl_total_geral_hono ,''nr_lote ,''sn_tratou_retorno ,''cd_seq_transacao ,''cd_remessa ,''cd_atendimento ,''cd_reg_fat
 ,''cd_reg_amb ,''cd_convenio ,''cd_guia ,''nm_prestador_exe_compl ,''cd_cgc_exe_compl ,''cd_cpf_exe_compl ,''cd_operadora_exe_compl ,''nm_cidade_sol
 ,''cd_status_cancelamento ,''nm_prestador_contratado ,''cd_cgc_contratado ,''cd_cpf_contratado ,''cd_operadora_contratado ,''cd_remessa_glosa ,''ds_conselho_contratado
 ,''ds_cod_conselho_contratado ,''uf_conselho_contratado ,''cd_fonte_pagadora ,''sn_atendimento_rn ,''dt_inicio_faturamento ,''hr_inicio_faturamento
 ,''dt_final_faturamento ,''hr_final_faturamento ,''vl_tot_opme ,''tp_consulta ,''tp_tab_fat_co ,''cd_procedimento_co ,''vl_procedimento_co ,''ds_inconsistencias
 ,''cd_versao_tiss_gerada ,''sn_guia_alterada ,''ds_hist_reapresentacao ,''cd_ausencia_validacao ,''cd_validacao ,''tp_etapa_autorizacao ,''tp_ident_beneficiario
 ,''ds_template_ident_beneficiario,HR_INICIO,HR_FIM,TP_TAB_FAT,CD_PROCEDIMENTO,DS_PROCEDIMENTO,QT_REALIZADA,CD_VIA_ACESSO,TP_TECNICA_UTILIZADA
,VL_PERCENTUAL_MULTIPLA,VL_UNITARIO,VL_TOTAL,DT_REALIZADO,QT_AUTORIZADA,CD_PRO_FAT,TP_PAGAMENTO,DS_JUSTIFICATIVA_REVISAO,DT_FINAL,CD_MOTIVO_GLOSA
,CD_ATI_MED,SQ_ITEM,NR_PAGINA,NR_LINHA,CD_MVTO,TP_MVTO,CD_ITMVTO,SN_PRINCIPAL,''sq_Ref,''nr_autorizacao,''TP_DESPESA,''dt_realizado
from
dbamv.tiss_itguia

;
select 
''ID ,''ID_PAI ,''nm_xml ,''nr_registro_operadora,''cd_prestador_na_operadora ,'' nr_guia ,''nr_guia_operadora ,''nr_id_beneficiario ,'' dt_emissao
 ,''nr_Guia_principal ,''dt_emissao_principal ,'' nr_carteira ,'' dt_validade ,'' nm_paciente ,'' ds_con_pla ,''nm_titular ,''nr_cns ,''cd_cgc_cpf_sol
 ,''nm_prestador_sol ,''ds_codigo_conselho_sol ,''ds_conselho_sol ,''uf_conselho_sol ,''cd_cbos_sol ,''cd_cgc_sol ,''cd_cpf_sol ,''cd_operadora_sol
 ,''cd_tipo_logradouro_sol ,'' ds_endereco_sol ,''nr_endereco_sol ,''cd_ibge_sol ,''uf_sol ,''nr_cep_sol ,''cd_cnes_sol ,''ds_complemento_sol ,''cd_cgc_cpf_exe ,''nm_prestador_exe
 ,''cd_cnes_exe ,''cd_tipo_logradouro_exe ,''ds_endereco_exe ,''nr_endereco_exe ,''nm_bairro_exe,''cd_ibge_exe ,''uf_exe ,''nr_cep_exe ,''cd_cgc_exe
 ,''cd_cpf_exe ,''cd_operadora_exe ,''ds_conselho_exe ,''ds_codigo_conselho_exe ,''uf_conselho_exe ,''ds_complemento_exe ,''nm_cidade_exe ,''cd_cbos_exe
 ,''cd_ati_med_exe ,''ds_hda ,''cd_carater_solicitacao ,''dh_atendimento ,''tp_saida ,''tp_atendimento ,''tp_faturamento ,''tp_cid ,''cd_cid ,''ds_cid
 ,''dt_autorizacao ,''cd_senha ,''dt_validade_autorizada ,''nm_autorizador_conv ,''vl_tot_servicos ,''vl_tot_diarias ,''vl_tot_taxas ,''vl_tot_materiais
 ,''vl_tot_medicamentos ,''vl_tot_gases ,''vl_tot_geral ,''cd_tip_acom ,''dh_alta ,''cd_tipo_internacao ,''tp_doenca ,''nr_tempo_doenca ,''tp_tempo_doenca
 ,''ds_observacao ,''nr_guia_sol ,''tp_regime_internacao ,''sn_gestacao ,''sn_aborto ,''sn_transtorno ,''sn_complicacao ,''sn_atend_sl_parto ,''sn_complicacao_neo ,''sn_baixo_peso
 ,''sn_cesareo ,''sn_normal ,''cd_decl_nascidos_vivos ,''qt_nascidos_vivos ,''qt_nascidos_prematuros ,''qt_nascidos_mortos ,''tp_obito_mulher ,''qt_obito_precoce
 ,''qt_obito_tardio ,''tp_acidente ,''cd_motivo_alta ,''cd_sus ,''nr_diarias_uti ,''tp_cid_obito ,''cd_cid_obito ,''ds_cid_obito ,''nr_declaracao_obito
 ,''cd_tipo_faturamento ,''vl_total_geral_proc ,''vl_total_geral_opme ,''vl_total_geral_outras ,''vl_total_geral_hono ,''nr_lote ,''sn_tratou_retorno ,''cd_seq_transacao
 ,''cd_remessa ,''cd_atendimento ,''cd_reg_fat ,''cd_reg_amb ,''cd_convenio ,''cd_guia ,''nm_prestador_exe_compl ,''cd_cgc_exe_compl ,''cd_cpf_exe_compl
 ,''cd_operadora_exe_compl ,''nm_cidade_sol ,''cd_status_cancelamento ,''nm_prestador_contratado ,''cd_cgc_contratado ,''cd_cpf_contratado ,''cd_operadora_contratado
 ,''cd_remessa_glosa ,''ds_conselho_contratado ,''ds_cod_conselho_contratado ,''uf_conselho_contratado ,''cd_fonte_pagadora ,''sn_atendimento_rn
 ,''dt_inicio_faturamento ,''hr_inicio_faturament ,''dt_final_faturamento ,''hr_final_faturamento ,''vl_tot_opme ,''tp_consulta ,''tp_tab_fat_co
 ,''cd_procedimento_co ,''vl_procedimento_co ,''ds_inconsistencias ,''cd_versao_tiss_gerada ,''sn_guia_alterada ,''ds_hist_reapresentacao ,''cd_ausencia_validacao
 ,''cd_validacao ,''tp_etapa_autorizacao ,''tp_ident_beneficiario ,''ds_template_ident_beneficiario,HR_INICIO,HR_FIM,TP_TAB_FAT,CD_PROCEDIMENTO,DS_PROCEDIMENTO
,QT_REALIZADA,''cd_via_acesso,''tp_tecnica_utilizada,VL_PERCENTUAL_MULTIPLA,VL_UNITARIO,VL_TOTAL,''dt_realizado,QT_AUTORIZADA,CD_PRO_FAT,''tp_pagamento
,DS_JUSTIFICATIVA_REVISAO,CD_UNIDADE_MEDIDA,CD_REGISTRO_ANVISA,CD_CODIGO_FABRICANTE,SQ_ITEM,NR_PAGINA,NR_LINHA ,''cd_mvto,''tp_mvto,''cd_itmvto,''sn_principal
,SQ_REF,NR_AUTORIZACAO,TP_DESPESA,DT_REALIZADO
from 
dbamv.tiss_itguia_out
