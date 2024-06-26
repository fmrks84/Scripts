---- ACRESC / DESCONTO REGRA 84 
select 
ac.cd_regra,
ac.dt_inicio_vigencia,
ac.dt_final_vigencia,
ac.cd_gru_pro,
gp.ds_gru_pro,
ac.vl_perc_acrescimo,
ac.vl_perc_desconto,
ac.tp_atend_ambulatorial,
ac.tp_atend_externo,
ac.tp_atend_internacao,
ac.tp_atend_urgeme,
ac.ds_desconto,
ac.ds_acrescimo,
ac.sn_vl_filme,
ac.sn_vl_operacional,
ac.sn_vl_honorario,
ac.tp_atend_homecare,
ac.sn_destacar_na_fatura
from 
regra rg 
inner join acresc_descontos ac on ac.cd_regra = rg.cd_regra
inner join gru_pro gp on gp.cd_gru_pro = ac.cd_gru_pro
where rg.cd_regra = 126

---- EXCECÇÕES ACRESC / DESCONTO REGRA 84 
;
select 
AEX.CD_REGRA,
AEX.CD_PRO_FAT,
AEX.DT_INICIO_VIGENCIA,
AEX.DT_FINAL_VIGENCIA,
AEX.VL_PERC_ACRESCIMO,
AEX.DS_ACRESCIMO,
AEX.VL_PERC_DESCONTO,
AEX.DS_DESCONTO,
AEX.VL_PERC_ACRESCIMO_EXAME,
AEX.DS_ACRESCIMO_EXAME,
AEX.SN_DESTACAR_NA_FATURA,
AEX.TP_ATEND_AMBULATORIAL,
AEX.TP_ATEND_EXTERNO,
AEX.TP_ATEND_INTERNACAO,
AEX.TP_ATEND_URGEME,
AEX.TP_ATEND_HOMECARE,
AEX.SN_VL_FILME,
AEX.SN_VL_OPERACIONAL,
AEX.SN_VL_HONORARIO

FROM
regra rg 
inner join ACRESC_DESCONTOS_PROC AEX ON AEX.CD_REGRA = RG.CD_REGRA
where rg.cd_regra = 126
--AND AEX.CD_PRO_FAT = '00268932'
----Extração dos materiais disponíveis ativos 
--para casa 3 com seguintes informações CD PRODUTO, CD.PROFAT, 
--DS PRO FAT, CD.ATIVIDADE, DS ATIVIDADE, CD ESPECIE, DS  ESPECIE, CD GRU PRO, DS GRU PRO,
-- CD REFERENCIA, REGISTRO ANVISA.
