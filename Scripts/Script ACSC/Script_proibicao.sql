SELECT decode(p.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC') empresa
      ,p.cd_convenio
      ,c.nm_convenio
      ,p.cd_con_pla
      ,p.cd_multi_empresa
      ,p.cd_pro_fat
      ,f.ds_pro_fat
      ,p.tp_proibicao
      ,p.tp_atendimento
      ,p.dt_inicial_proibicao
      ,p.dt_fim_proibicao
FROM proibicao p
    ,pro_fat f
    ,convenio c
WHERE p.cd_pro_fat = f.cd_pro_fat
AND p.cd_convenio = c.cd_convenio
AND f.cd_pro_fat = '60023406'
AND p.cd_multi_empresa IN ('7','10')
--AND p.cd_convenio = 7
AND p.dt_fim_proibicao IS NULL
ORDER BY 1,9
