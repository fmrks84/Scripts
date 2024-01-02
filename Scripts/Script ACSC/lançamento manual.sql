SELECT decode(reg_fat.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC') empresa
      ,Decode(atendime.tp_atendimento,'I','Internado'
                                ,'U','Urgencia'
                                ,'A','Ambulatorio'
                                ,'E','Externo') tp_atendimento
      ,atendime.cd_atendimento AS ATENDIMENTO
      ,atendime.dt_atendimento
      ,reg_fat.cd_reg_fat AS CONTA
      ,convenio.cd_convenio
      ,convenio.nm_convenio  AS CONVENIO
      ,itreg_fat.dt_lancamento
      ,itreg_fat.cd_gru_fat
      ,gru_fat.ds_gru_fat
      ,itreg_fat.cd_pro_fat
      ,pro_fat.ds_pro_fat
      ,itreg_fat.qt_lancamento
      ,round (itreg_fat.vl_unitario, 2) AS VL_UNITARIO --null (falta recalcular) / '0' (sem preço)
      ,round (itreg_fat.vl_total_conta, 2) AS VL_TOTAL
      ,itreg_fat.tp_mvto

FROM pro_fat
    ,convenio
    ,atendime
    ,reg_fat
    ,itreg_fat
    ,gru_fat

WHERE pro_fat.cd_pro_fat = itreg_fat.cd_pro_fat
AND convenio.cd_convenio = reg_fat.cd_convenio
AND reg_fat.cd_atendimento = atendime.cd_atendimento
AND reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat
AND itreg_fat.cd_gru_fat = gru_fat.cd_gru_fat
AND itreg_fat.cd_pro_fat = pro_fat.cd_pro_fat
AND reg_fat.cd_multi_empresa IN ('7','10')
AND atendime.dt_atendimento BETWEEN  To_Date ('01/01/2020','dd/mm/yyyy') AND To_Date ('19/11/2020','dd/mm/yyyy')  --selecionar o período desejável
--AND itreg_fat.cd_gru_fat = 2
AND itreg_fat.cd_pro_fat = '60023406'
AND itreg_fat.tp_mvto = 'Faturamento'
--AND itreg_fat.cd_reg_fat = 184638

UNION ALL

SELECT decode(reg_amb.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC') empresa
      ,Decode(atendime.tp_atendimento,'I','Internado'
                                ,'U','Urgencia'
                                ,'A','Ambulatorio'
                                ,'E','Externo') tp_atendimento
      ,atendime.cd_atendimento AS ATENDIMENTO
      ,atendime.dt_atendimento
      ,reg_amb.cd_reg_amb AS CONTA
      ,convenio.cd_convenio
      ,convenio.nm_convenio  AS CONVENIO
      ,itreg_amb.hr_lancamento AS dt_lancamento
      ,itreg_amb.cd_gru_fat
      ,gru_fat.ds_gru_fat
      ,itreg_amb.cd_pro_fat
      ,pro_fat.ds_pro_fat
      ,itreg_amb.qt_lancamento
      ,round (itreg_amb.vl_unitario, 2) AS VL_UNITARIO --null (falta recalcular) / '0' (sem preço)
      ,round (itreg_amb.vl_total_conta, 2) AS VL_TOTAL
      ,itreg_amb.tp_mvto

FROM pro_fat
    ,convenio
    ,atendime
    ,reg_amb
    ,itreg_amb
    ,gru_fat

WHERE pro_fat.cd_pro_fat = itreg_amb.cd_pro_fat
AND convenio.cd_convenio = reg_amb.cd_convenio
AND itreg_amb.cd_atendimento = atendime.cd_atendimento
AND reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
AND itreg_amb.cd_gru_fat = gru_fat.cd_gru_fat
AND itreg_amb.cd_pro_fat = pro_fat.cd_pro_fat
AND reg_amb.cd_multi_empresa IN ('7','10')
AND atendime.dt_atendimento BETWEEN  To_Date ('01/01/2020','dd/mm/yyyy') AND To_Date ('19/11/2020','dd/mm/yyyy') --selecionar o período desejável
--AND itreg_amb.cd_gru_fat = 2
AND itreg_amb.cd_pro_fat = '60023406'
AND itreg_amb.tp_mvto = 'Faturamento'
--AND itreg_amb.cd_reg_amb = 1488013

ORDER BY 3,5
