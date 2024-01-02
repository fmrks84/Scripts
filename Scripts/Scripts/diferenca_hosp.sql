
--select dt_fechamento, cd_remessa from dbamv.reg_fat where cd_reg_fat = 175629

--select sum( vl_total_conta ) vl_total_hospitalar from (
select r.cd_reg_fat, sum(nvl(l.vl_liquido,i.vl_total_conta)) vl_total_conta, r.cd_remessa, f.dt_competencia,
       r.cd_multi_empresa, r.dt_fechamento, r.sn_fechada
  from dbamv.reg_fat r,
       dbamv.itreg_fat i,
       dbamv.itlan_med l,
       dbamv.remessa_fatura m,
       dbamv.fatura f,
       (
-- producao_operacional
SELECT cd_reg_fat from
( select DISTINCT reg_fat.cd_reg_fat
              from dbamv.itreg_fat
                     ,dbamv.reg_fat reg_fat_filha
                     ,dbamv.reg_fat
                     ,dbamv.pro_fat
                     ,dbamv.atendime
                     ,dbamv.convenio,
                      dbamv.remessa_fatura,
                      dbamv.fatura,
                      dbamv.itlan_med
              where reg_fat_filha.cd_multi_empresa in (4,5)
                and reg_fat_filha.cd_reg_fat = itreg_fat.cd_reg_fat
                and itreg_fat.cd_reg_fat = itlan_med.cd_reg_fat(+)
                and itreg_fat.cd_lancamento = itlan_med.cd_lancamento(+)
                and itreg_fat.sn_pertence_pacote = 'N'
                and pro_fat.cd_pro_fat = itreg_fat.cd_pro_fat
                and nvl(nvl(itlan_med.tp_pagamento,itreg_fat.tp_pagamento),'X') <> 'C'
                and reg_fat.cd_convenio = convenio.cd_convenio
                and reg_fat_filha.cd_conta_pai = reg_fat.cd_reg_fat
                and reg_fat.cd_atendimento = atendime.cd_atendimento
                and reg_fat.sn_fechada = 'S'
                and reg_fat.cd_remessa = remessa_fatura.cd_remessa(+)
                and remessa_fatura.cd_fatura = fatura.cd_fatura(+)
                and to_char(reg_fat.dt_fechamento,'mm/yyyy') =  '11/2009'
                and convenio.cd_convenio not in (352,351)
                AND convenio.tp_convenio = 'C'
UNION ALL
select DISTINCT reg_fat.cd_reg_fat
         from dbamv.atendime,
              dbamv.reg_fat,
              dbamv.itreg_fat,
              dbamv.pro_fat,
              dbamv.tipo_internacao,
              dbamv.pro_fat pro_int,
              dbamv.convenio,
              dbamv.remessa_fatura,
              dbamv.fatura,
              dbamv.itlan_med
        where reg_fat.cd_atendimento = atendime.cd_atendimento
          and itreg_fat.cd_reg_fat = reg_fat.cd_reg_fat
          and itreg_fat.cd_reg_fat = itlan_med.cd_reg_fat(+)
          and itreg_fat.cd_lancamento = itlan_med.cd_lancamento(+)
          and pro_fat.cd_pro_fat = itreg_fat.cd_pro_fat
          and nvl(nvl(itlan_med.tp_pagamento,itreg_fat.tp_pagamento),'X') <> 'C'
          and itreg_fat.sn_pertence_pacote = 'N'
          and reg_fat.sn_fechada = 'S'
          and atendime.cd_pro_int = pro_int.cd_pro_fat(+)
          and atendime.cd_tipo_internacao = tipo_internacao.cd_tipo_internacao
          and reg_fat.cd_convenio = convenio.cd_convenio
          and reg_fat.cd_remessa = remessa_fatura.cd_remessa(+)
          and remessa_fatura.cd_fatura = fatura.cd_fatura(+)
          and to_char(reg_fat.dt_fechamento,'mm/yyyy') =  '11/2009'
          and convenio.cd_convenio not in (352,351)
          AND convenio.tp_convenio = 'C'
          )

minus

-- remessa por convênio
select DISTINCT reg_fat.cd_reg_fat
 from
    dbamv.remessa_fatura,
    dbamv.fatura,
    dbamv.reg_fat,
    dbamv.itreg_fat,
    dbamv.itlan_med,
    dbamv.convenio
    ,dbamv.agrupamento --pda 258096 - Francisco Morais - 06/11/2008
where remessa_fatura.cd_fatura = fatura.cd_fatura
and remessa_fatura.cd_remessa = reg_fat.cd_remessa
and reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat
and reg_fat.cd_convenio = convenio.cd_convenio
and itreg_fat.cd_reg_fat = itlan_med.cd_reg_fat(+)
and itreg_fat.cd_lancamento = itlan_med.cd_lancamento(+)
and convenio.tp_convenio not in ('H','A')
and nvl(nvl(itlan_med.tp_pagamento,itreg_fat.tp_pagamento),'X') <> 'C'
and nvl(itreg_fat.sn_pertence_pacote,'N') = 'N'
and agrupamento.cd_agrupamento(+) = remessa_fatura.cd_agrupamento     -- pda 258915 - Francisco Morais - 13/11/2008
and to_char(fatura.dt_competencia, 'MM/YYYY') = '11/2009'
and convenio.cd_convenio not in (352,351)
   ) rg
  where r.cd_reg_fat = rg.cd_reg_fat
    and i.cd_reg_fat = r.cd_reg_fat
    and l.cd_reg_fat(+) = i.cd_reg_fat
    and l.cd_lancamento(+) = i.cd_lancamento
    and nvl(nvl(l.tp_pagamento,i.tp_pagamento),'X') <> 'C'
    and nvl(i.sn_pertence_pacote,'N') = 'N'
    and m.cd_remessa(+) = r.cd_remessa
    and f.cd_fatura(+)  = m.cd_fatura

  group by r.cd_reg_fat, r.cd_remessa, f.dt_competencia, r.cd_multi_empresa, r.dt_fechamento, r.sn_fechada

--  )
