select remessa_conta.cd_remessa
     , remessa_conta.dt_entrega_remessa
     , remessa_financeiro.vl_total_nota
     , sum(remessa_conta.vl_remessa) vl_remessa
     , remessa_financeiro.nr_id_nota_fiscal
     , remessa_financeiro.cd_serie
     , remessa_financeiro.dt_emissao
     , remessa_financeiro.vl_imposto_recebimento
  from (SELECT remessa_fatura.cd_remessa
             , remessa_fatura.dt_entrega_da_fatura dt_entrega_remessa
             , nota_fiscal.vl_total_nota
             , nota_fiscal.nr_id_nota_fiscal
             , nota_fiscal.cd_serie
             , nota_fiscal.dt_emissao
             , sum(Nvl(reccon_rec.vl_imposto_retido, 0)) vl_imposto_recebimento
          FROM dbamv.fatura,
               dbamv.remessa_fatura,
               dbamv.nota_fiscal,
               dbamv.con_rec,
               dbamv.itcon_rec,
               dbamv.reccon_rec
         WHERE fatura.cd_convenio = 3 --:nCdConvenioRef
           AND To_Char(fatura.dt_competencia, 'MM/YYYY') = '11/2008' --To_Char(:dDtCompetenciaRef, 'MM/YYYY')
           AND fatura.cd_multi_empresa = 1 --:nCdMultiEmpresaRef
           AND remessa_fatura.cd_fatura = fatura.cd_fatura
           AND nota_fiscal.cd_nota_fiscal IN (SELECT itfat_nota_fiscal.cd_nota_fiscal
                                                FROM dbamv.itfat_nota_fiscal
                                               WHERE itfat_nota_fiscal.cd_remessa = remessa_fatura.cd_remessa)
           and nvl(nota_fiscal.cd_status, 'X') <> 'C'
           AND con_rec.cd_nota_fiscal = nota_fiscal.cd_nota_fiscal
           AND con_rec.cd_con_rec = itcon_rec.cd_con_rec
           AND itcon_rec.cd_itcon_rec = reccon_rec.cd_itcon_rec (+)
           AND itcon_rec.tp_quitacao IN ('P', 'G', 'Q')
         GROUP BY remessa_fatura.cd_remessa
             , remessa_fatura.dt_entrega_da_fatura
             , nota_fiscal.vl_total_nota
             , nota_fiscal.nr_id_nota_fiscal
             , nota_fiscal.cd_serie
             , nota_fiscal.dt_emissao) remessa_financeiro,

       (SELECT remessa_fatura.cd_remessa
             , remessa_fatura.dt_entrega_da_fatura dt_entrega_remessa
             , sum(nvl(itlan_med.vl_liquido, nvl(itreg_fat.vl_total_conta, 0))) vl_remessa
          FROM dbamv.fatura,
               dbamv.remessa_fatura,
               dbamv.itreg_fat,
               dbamv.itlan_med,
               dbamv.reg_fat
         WHERE fatura.cd_convenio = 3  --:nCdConvenioRef
           AND To_Char(fatura.dt_competencia, 'MM/YYYY') = '11/2008' --To_Char(:dDtCompetenciaRef, 'MM/YYYY')
           AND fatura.cd_multi_empresa = 1 --:nCdMultiEmpresaRef
           AND remessa_fatura.cd_fatura = fatura.cd_fatura
           and reg_fat.cd_remessa = remessa_fatura.cd_remessa
           and reg_fat.cd_multi_empresa = fatura.cd_multi_empresa
           and reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat
           and itreg_fat.cd_reg_fat = itlan_med.cd_reg_fat(+)
           and itreg_fat.cd_lancamento = itlan_med.cd_lancamento(+)
           and nvl(itlan_med.tp_pagamento, nvl(itreg_fat.tp_pagamento, 'X')) <> 'C'
           and nvl(itreg_fat.sn_pertence_pacote, 'N') = 'N'
         GROUP BY remessa_fatura.cd_remessa
                , remessa_fatura.dt_entrega_da_fatura
         union
        SELECT remessa_fatura.cd_remessa
             , remessa_fatura.dt_entrega_da_fatura dt_entrega_remessa
             , sum(itreg_amb.vl_total_conta) vl_remessa
          FROM dbamv.fatura,
               dbamv.remessa_fatura,
               dbamv.itreg_amb,
               dbamv.reg_amb
         WHERE fatura.cd_convenio = 3 ---:nCdConvenioRef
           AND To_Char(fatura.dt_competencia, 'MM/YYYY') = '11/2008' --To_Char(:dDtCompetenciaRef, 'MM/YYYY')
           AND fatura.cd_multi_empresa = 1 ---:nCdMultiEmpresaRef
           AND remessa_fatura.cd_fatura = fatura.cd_fatura
           and reg_amb.cd_remessa = remessa_fatura.cd_remessa
           and reg_amb.cd_multi_empresa = fatura.cd_multi_empresa
           and itreg_amb.cd_reg_amb = reg_amb.cd_reg_amb
           and nvl(itreg_amb.tp_pagamento, 'P') <> 'C'
           and nvl(itreg_amb.sn_pertence_pacote, 'N') = 'N'
         GROUP BY remessa_fatura.cd_remessa
             , remessa_fatura.dt_entrega_da_fatura ) remessa_conta

 where remessa_financeiro.cd_remessa = remessa_conta.cd_remessa
group by remessa_conta.cd_remessa
     , remessa_conta.dt_entrega_remessa
     , remessa_financeiro.vl_total_nota
     , remessa_financeiro.nr_id_nota_fiscal
     , remessa_financeiro.cd_serie
     , remessa_financeiro.dt_emissao
     , remessa_financeiro.vl_imposto_recebimento
 order by nr_id_nota_fiscal, cd_remessa
