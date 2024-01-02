select distinct
n.nr_id_nota_fiscal RPS,
decode(c.tp_atendimento,'I','Internado','U','Urgencia','A','Ambulatorio','E','Externo') tp_atendimento,
n.CD_atendimento,
c.dt_atendimento,
n.cd_reg_amb Conta,
n.nm_cliente,
n.vl_total_nota,
n.dt_emissao,
n.hr_emissao_Nfe,
nvl(to_date(n.hr_emissao_nfe),to_Date(sysdate)) - to_date(n.dt_emissao) dif_dias,
n.ds_retorno_nfe,
n.dt_integra,
n.cd_nota_fiscal

from nota_fiscal n
inner join atendime c on n.cd_atendimento = c.cd_atendimento

where n.cd_multi_empresa = 7
and Trunc(n.dt_emissao) between to_date('01/11/2021'/*$datainicio$*/,'dd/mm/yyyy') and to_date('06/06/2022'/*$datafim$*/,'dd/mm/yyyy')
and n.cd_atendimento is not null
and n.hr_emissao_nfe is null
and n.cd_status = 'E'
and n.cd_convenio in (40,37,4,54,207,208,485,822,862)


union all

select distinct
b.nr_id_nota_fiscal RPS,
decode(c.tp_atendimento,'I','Internado','U','Urgencia','A','Ambulatorio','E','Externo') tp_atendimento,
c.CD_atendimento,
c.dt_atendimento,
a.cd_reg_amb,
d.nm_paciente,
a.vl_total_conta,
b.dt_emissao,
b.hr_emissao_Nfe,
nvl(to_date(b.hr_emissao_nfe),to_Date(sysdate)) - to_date(b.dt_emissao) dif_dias,
b.ds_retorno_nfe,
b.dt_integra,
b.cd_nota_fiscal

from reg_amb a
inner join itreg_amb e on a.cd_reg_amb = e.cd_reg_amb
inner join atendime c on e.cd_atendimento = c.cd_atendimento
inner join paciente d on c.cd_paciente = d.cd_paciente
left join nota_fiscal b on a.cd_reg_amb = b.cd_reg_amb

where a.cd_multi_empresa = 7
and Trunc(a.dt_lancamento) between to_date('01/11/2021'/*$datainicio$*/,'dd/mm/yyyy') and to_date('06/06/2022'/*$datafim$*/,'dd/mm/yyyy')
and a.sn_fechada = 'S'
and b.cd_reg_amb is null
and a.cd_convenio in (40,37,4,54,207,208,485,822,862)
and b.dt_integra is null

union all

select distinct
b.nr_id_nota_fiscal RPS,
decode(c.tp_atendimento,'I','Internado','U','Urgencia','A','Ambulatorio','E','Externo') tp_atendimento,
a.CD_atendimento,
c.dt_atendimento,
a.cd_reg_fat,
d.nm_paciente,
a.vl_total_conta,
b.dt_emissao,
b.hr_emissao_Nfe,
nvl(to_date(b.hr_emissao_nfe),to_Date(sysdate)) - to_date(b.dt_emissao) dif_dias,
b.ds_retorno_nfe,
b.dt_integra,
b.cd_nota_fiscal

from reg_fat a
inner join atendime c on a.cd_atendimento = c.cd_atendimento
inner join paciente d on c.cd_paciente = d.cd_paciente
left join nota_fiscal b on a.cd_reg_fat = b.cd_reg_fat

where a.cd_multi_empresa = 7
and Trunc(a.dt_fechamento) between to_date('01/11/2021'/*$datainicio$*/,'dd/mm/yyyy') and to_date('06/06/2022'/*$datafim$*/,'dd/mm/yyyy')
and a.sn_fechada = 'S'
and b.cd_reg_fat is null
and a.tp_classificacao_conta <> 'O'
and a.cd_convenio in (40,37,4,54,207,208,485,822,862)
and b.dt_integra is null

order by 4
