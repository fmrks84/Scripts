--select sum( vl_total_conta ) vl_total_ambulatorial from (
select r.cd_reg_amb, sum(i.vl_total_conta) vl_total_conta, r.cd_remessa, f.dt_competencia, r.cd_multi_empresa, i.dt_fechamento, i.sn_fechada
  from dbamv.itreg_amb i,
       dbamv.reg_amb r,
       dbamv.remessa_fatura m,
       dbamv.fatura f,
       (
-- produção operacional
select DISTINCT itreg_amb.cd_reg_amb
         from dbamv.atendime,
              dbamv.itreg_amb,
              dbamv.reg_amb,
              dbamv.pro_fat,
              dbamv.tipo_internacao,
              dbamv.pro_fat pro_int,
              dbamv.convenio,
              dbamv.remessa_fatura,
              dbamv.fatura
        where itreg_amb.cd_atendimento = atendime.cd_atendimento
          and reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
          and itreg_amb.cd_pro_fat = pro_fat.cd_pro_fat
          and nvl(itreg_amb.tp_pagamento,'X') <> 'C'
          and itreg_amb.sn_pertence_pacote = 'N'
          and itreg_amb.sn_fechada = 'S'
          and atendime.cd_tipo_internacao = tipo_internacao.cd_tipo_internacao(+)
          and atendime.cd_pro_int = pro_int.cd_pro_fat(+)
          and reg_amb.cd_convenio = convenio.cd_convenio
          and reg_amb.cd_remessa = remessa_fatura.cd_remessa(+)
          and remessa_fatura.cd_fatura = fatura.cd_fatura(+)
          and to_char(itreg_amb.dt_fechamento,'mm/yyyy') =  '11/2009'
          and convenio.cd_convenio not in (352,351)
          AND convenio.tp_convenio = 'C'

minus

-- remessa por convênio
select  DISTINCT reg_amb.cd_reg_amb
 from
    dbamv.remessa_fatura,
    dbamv.fatura,
    dbamv.reg_amb,
    dbamv.itreg_amb,
    dbamv.convenio
    ,dbamv.agrupamento --pda 258096 - Francisco Morais - 06/11/2008
where remessa_fatura.cd_fatura = fatura.cd_fatura
and remessa_fatura.cd_remessa = reg_amb.cd_remessa
and reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
and itreg_amb.cd_convenio = convenio.cd_convenio
and convenio.tp_convenio not in ('H','A')
and nvl(itreg_amb.tp_pagamento,'X') <> 'C'
and nvl(itreg_amb.sn_pertence_pacote,'N') = 'N'
and agrupamento.cd_agrupamento(+) = remessa_fatura.cd_agrupamento     -- pda 258915 - Francisco Morais - 13/11/2008
and to_char(fatura.dt_competencia, 'MM/YYYY') = '11/2009'
and convenio.cd_convenio not in (352,351)
   ) rg
  where r.cd_reg_amb = i.cd_reg_amb
    and r.cd_reg_amb = rg.cd_reg_amb
    and m.cd_remessa(+) = r.cd_remessa
    and f.cd_fatura(+)  = m.cd_fatura
  group by r.cd_reg_amb, r.cd_remessa, f.dt_competencia, r.cd_multi_empresa, i.dt_fechamento, i.sn_fechada

--  )
