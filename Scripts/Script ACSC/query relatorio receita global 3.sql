SELECT tp_gru_fat,
       SUM(vl_total_conta) vl_gru_fat,
       SUM(vl_tot_amb) vl_tot_amb,
       SUM(vl_tot_interna) vl_tot_interna
  FROM (SELECT reg_fat . cd_convenio cd_convenio,
               itreg_fat . cd_gru_fat cd_gru_fat,
               gru_fat . tp_gru_fat tp_gru_fat,
               SUM(nvl(itlan_med . vl_liquido, itreg_fat . vl_total_conta)) vl_total_conta,
               0 vl_tot_amb,
               SUM(nvl(itlan_med . vl_liquido, itreg_fat . vl_total_conta)) vl_tot_interna
          FROM dbamv . itreg_fat itreg_fat,
               dbamv . reg_fat reg_fat,
               dbamv . gru_fat gru_fat,
               dbamv . convenio convenio,
               dbamv . ori_ate ori_ate,
               dbamv . atendime atendime,
               dbamv . remessa_fatura remessa,
               dbamv . servico servico,
               dbamv . empresa_convenio,
               dbamv . itlan_med,
               dbamv . pro_fat
         WHERE empresa_convenio . cd_convenio = convenio .
         cd_convenio
           AND empresa_convenio .
         cd_multi_empresa = :p_cd_multi_empresa
           AND itreg_fat . cd_reg_fat = reg_fat . cd_reg_fat
           AND itreg_fat . cd_gru_fat = gru_fat . cd_gru_fat
           AND atendime . cd_ori_ate = ori_ate . cd_ori_ate
           AND itreg_fat .
         dt_lancamento BETWEEN TO_DATE(:p_dt_inicio, 'dd/mm/yyyy') AND
               (TO_DATE(:p_dt_final, 'dd/mm/yyyy') + 0.99999)
           and nvl(itlan_med . tp_pagamento,
                   nvl(itreg_fat . tp_pagamento, 'P')) <> 'C'
           AND itlan_med . cd_reg_fat(+) = itreg_fat . cd_reg_fat
           AND itlan_med . cd_lancamento(+) = itreg_fat .
         cd_lancamento
           AND reg_fat . cd_convenio = convenio . cd_convenio
           AND reg_fat .
         sn_fechada =
               DECODE(:p_conta, 'T', reg_fat . sn_fechada, :p_conta)
           AND remessa . cd_remessa(+) = reg_fat .
         cd_remessa
           AND NVL(remessa . sn_fechada, 'N') =
               DECODE(:p_situacao,
                      'T',
                      NVL(remessa . sn_fechada, 'N'),
                      'A',
                      'N',
                      'F',
                      'S',
                      'P',
                      'S')
           AND convenio . tp_convenio <> 'H'
           AND reg_fat . cd_atendimento = atendime . cd_atendimento
           AND atendime . cd_servico = servico . cd_servico(+)
           and atendime . cd_multi_empresa = :p_cd_multi_empresa
           and itreg_fat . cd_pro_fat = pro_fat . cd_pro_fat
         GROUP BY reg_fat   . cd_convenio,
                  itreg_fat . cd_gru_fat,
                  gru_fat   . tp_gru_fat
        UNION ALL
        SELECT reg_amb . cd_convenio cd_convenio,
               itreg_amb . cd_gru_fat cd_gru_fat,
               gru_fat . tp_gru_fat tp_gru_fat,
               SUM(itreg_amb . vl_total_conta) vl_total_conta,
               SUM(itreg_amb . vl_total_conta) vl_tot_amb,
               0 vl_tot_interna
          FROM dbamv . itreg_amb itreg_amb,
               dbamv . reg_amb reg_amb,
               dbamv . atendime atendime,
               dbamv . ori_ate ori_ate,
               dbamv . gru_fat gru_fat,
               dbamv . remessa_fatura remessa,
               dbamv . convenio convenio,
               dbamv . servico servico,
               dbamv . empresa_convenio,
               dbamv . pro_fat
         WHERE empresa_convenio . cd_convenio = convenio .
         cd_convenio
           AND empresa_convenio .
         cd_multi_empresa = :p_cd_multi_empresa
           AND itreg_amb . cd_reg_amb = reg_amb . cd_reg_amb
           AND itreg_amb . cd_atendimento = atendime . cd_atendimento
           and atendime . cd_multi_empresa = :p_cd_multi_empresa
           AND itreg_amb . cd_gru_fat = gru_fat . cd_gru_fat
           AND atendime . cd_ori_ate = ori_ate .
         cd_ori_ate
           AND NVL(itreg_amb . tp_pagamento, 'X') <> 'C'
           AND atendime .
         dt_atendimento BETWEEN TO_DATE(:p_dt_inicio, 'dd/mm/yyyy') AND
               (TO_DATE(:p_dt_final, 'dd/mm/yyyy') + 0.99999)
           AND reg_amb . cd_multi_empresa = :p_cd_multi_empresa
           AND itreg_amb . cd_convenio = convenio . cd_convenio
           AND itreg_amb .
         sn_fechada =
               DECODE(:p_conta, 'T', itreg_amb . sn_fechada, :p_conta)
           AND remessa . cd_remessa(+) = reg_amb .
         cd_remessa
           AND NVL(remessa . sn_fechada, 'N') =
               DECODE(:p_situacao,
                      'T',
                      NVL(remessa . sn_fechada, 'N'),
                      'A',
                      'N',
                      'F',
                      'S',
                      'P',
                      'S')
           AND convenio . tp_convenio <> 'H'
           AND atendime . cd_servico = servico . cd_servico(+)
           and itreg_amb . cd_pro_fat = pro_fat . cd_pro_fat
         GROUP BY reg_amb   . cd_convenio,
                  itreg_amb . cd_gru_fat,
                  gru_fat   . tp_gru_fat) convenio
 GROUP BY tp_gru_fat
 ORDER BY vl_gru_fat DESC
