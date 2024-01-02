--Internação

SELECT reg_fat.cd_multi_empresa
      ,convenio.cd_convenio
      ,convenio.nm_convenio
      ,atendime.cd_atendimento
      ,atendime.dt_atendimento
      ,reg_fat.cd_reg_fat --conta
      ,reg_fat.dt_inicio  --conta
      ,reg_fat.dt_final   --conta
      ,reg_fat.dt_fechamento  --faturista que fechou a conta
      ,ori_ate.cd_ori_ate
      ,ori_ate.ds_ori_ate
      ,itreg_fat.cd_gru_fat
      ,gru_fat.ds_gru_fat
      ,itreg_fat.cd_pro_fat
      ,pro_fat.ds_pro_fat
      ,itreg_fat.tp_mvto
      ,itreg_fat.cd_usuario
      --,pro_fat.cd_gru_pro
      --,gru_pro.ds_gru_pro
      --,itreg_fat.vl_total_conta --null (falta recalcular) / '0' (sem preço)

FROM pro_fat
    ,gru_pro
    ,gru_fat
    ,convenio
    ,atendime
    ,ori_ate
    ,reg_fat  --Interno
    ,itreg_fat

WHERE pro_fat.cd_pro_fat = itreg_fat.cd_pro_fat
AND convenio.cd_convenio = reg_fat.cd_convenio
AND reg_fat.cd_atendimento = atendime.cd_atendimento
AND atendime.cd_ori_ate  = ori_ate.cd_ori_ate
AND gru_fat.cd_gru_fat = itreg_fat.cd_gru_fat
AND reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat
AND reg_fat.cd_multi_empresa = ori_ate.cd_multi_empresa
AND pro_fat.cd_gru_pro = gru_pro.cd_gru_pro

AND atendime.dt_atendimento BETWEEN  To_Date ('01/01/2020','dd/mm/yyyy') AND To_Date ('16/03/2020','dd/mm/yyyy')
AND itreg_fat.cd_pro_fat IN ('40314618','40314340','28458697','28458696')  --corona

ORDER BY 14

---UNION all
--ambulatorial

SELECT reg_amb.cd_multi_empresa
      ,convenio.cd_convenio
      ,convenio.nm_convenio
      ,atendime.cd_atendimento
      ,reg_amb.cd_reg_amb --conta
      ,reg_amb.dt_lancamento
      ,reg_amb.dt_remessa --faturista que fechou a conta
      ,ori_ate.cd_ori_ate
      ,ori_ate.ds_ori_ate
      ,itreg_amb.cd_gru_fat
      ,gru_fat.ds_gru_fat
      ,itreg_amb.cd_pro_fat
      ,pro_fat.ds_pro_fat
      ,itreg_amb.tp_mvto
      ,itreg_amb.cd_usuario
      --,pro_fat.cd_gru_pro
      --,gru_pro.ds_gru_pro
      --,itreg_amb.vl_unitario --null (falta recalcular) / '0' (sem preço)

FROM pro_fat
    ,gru_pro
    ,gru_fat
    ,convenio
    ,atendime
    ,ori_ate
    ,reg_amb  --Enterno
    ,itreg_amb

WHERE pro_fat.cd_pro_fat = itreg_amb.cd_pro_fat
AND atendime.cd_atendimento = itreg_amb.cd_atendimento
AND convenio.cd_convenio = reg_amb.cd_convenio
AND atendime.cd_ori_ate  = ori_ate.cd_ori_ate
AND gru_fat.cd_gru_fat = itreg_amb.cd_gru_fat
AND reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
AND reg_amb.cd_multi_empresa = ori_ate.cd_multi_empresa
AND pro_fat.cd_gru_pro = gru_pro.cd_gru_pro

AND atendime.dt_atendimento BETWEEN  To_Date ('01/01/2020','dd/mm/yyyy') AND To_Date ('16/03/2020','dd/mm/yyyy')
AND itreg_amb.cd_pro_fat IN ('40314618','40314340','28458697','28458696')  --corona

ORDER BY 14



