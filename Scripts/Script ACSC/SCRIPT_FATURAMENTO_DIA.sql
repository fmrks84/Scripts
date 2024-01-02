•  Número (quantidade) de contas faturadas diariamente 
R: Para trazer estes dados qual filtro aplicar : pela data de entrega da remessa, data fechamento da conta ou data emissao da nota ?, lebrando
•  Número remessa;
•  Número Nota fiscal correspondente a(s) remessa(s);
•  Convênio;
•  Tipo de conta (ambulatorial, externo, internado);
•  Origem conta (PA, internação urgência, internação eletiva, CDI, laboratório, etc)

select 
dt_Fechamento,
count(*)qtd
from
(
select 
DISTINCT
--ATD.CD_ATENDIMENTO,
to_Char(rm.dt_fechamento,'dd/mm/rrrr')dt_fechamento,
rf.cd_remessa,
atd.cd_convenio,
conv.nm_convenio,
decode(atd.tp_atendimento,'I','INTERNADO')TP_CONTA,
atd.cd_ori_ate,
ort.ds_ori_ate,
NF.NR_ID_NOTA_FISCAL
from 
reg_Fat rf
inner join atendime atd on atd.cd_atendimento = rf.cd_atendimento
and rf.cd_convenio = atd.cd_Convenio
left join remessa_fatura rm on rm.cd_remessa = rf.cd_remessa
left join itfat_nota_fiscal itnf on itnf.cd_remessa = rf.cd_remessa
left join nota_fiscal nf on nf.cd_nota_fiscal = itnf.cd_nota_fiscal
inner join ori_ate ort on ort.cd_ori_ate = atd.cd_ori_ate
inner join convenio conv on conv.cd_convenio = atd.cd_convenio
where to_Char(rm.dt_fechamento,'dd/mm/rrrr') between to_date('01/03/2023','dd/mm/rrrr') and to_date('31/03/2023','dd/mm/rrrr')
and nf.cd_status = 'E'
and conv.tp_convenio = 'C'
and rf.cd_multi_empresa = 7
--order by to_Char(rm.dt_fechamento,'dd/mm/rrrr')

union all

select 
distinct
to_Char(rmx.dt_fechamento,'dd/mm/rrrr')dt_fechamento,
ramb.cd_remessa,
atdx.cd_convenio,
convx.nm_convenio,
decode(atdx.tp_atendimento,'A','AMBULATORIO','E','EXTERNO','U','URGENCIA')TP_CONTA,
atdx.cd_ori_ate,
ortx.ds_ori_ate,
NFx.NR_ID_NOTA_FISCAL
from 
reg_amb ramb
inner join itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join atendime atdx on atdx.cd_atendimento = iramb.cd_atendimento
and atdx.cd_convenio = iramb.cd_convenio
left join remessa_fatura rmx on rmx.cd_remessa = ramb.cd_remessa
left join itfat_nota_fiscal itfx on itfx.cd_remessa = rmx.cd_remessa
left join nota_fiscal nfx on nfx.cd_nota_fiscal = itfx.cd_nota_fiscal
inner join ori_ate ortx on ortx.cd_ori_ate = atdx.cd_ori_ate
inner join convenio convx on convx.cd_convenio = atdx.cd_convenio
where to_Char(rmx.dt_fechamento,'dd/mm/rrrr') between to_date('01/03/2023','dd/mm/rrrr') and to_date('31/03/2023','dd/mm/rrrr')
and nfx.cd_status = 'E'
and convx.tp_convenio = 'C'
and ramb.cd_multi_empresa = 7 
)
group by 
dt_Fechamento
order by dt_fechamento
