/*Base: 2019 e 2020
Casa; CNPJ; Razão Social; Mês; Ano; Quantidade; Valor unitário; Valor total e Prazo de pagamento.*/

select 

/*decode(nf.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC')CASA,
nf.nr_cgc_cpf CNPJ,
NF.NM_CLIENTE Razao_Social,
to_char(nf.dt_emissao,'MM')MES,
to_char(nf.dt_emissao,'YYYY')ANO,
inf.vl_itfat_nf valor_unitario,
nf.vl_total_nota Valor_total ,
rm.dt_prevista_para_pgto prazo_pagamento,
nf.nr_id_nota_fiscal NR_RPS,
NF.NR_NOTA_FISCAL_NFE NR_NFE*/
*
from 
dbamv.itfat_nota_fiscal inf
inner join dbamv.nota_fiscal nf on nf.cd_nota_fiscal = inf.cd_nota_fiscal
inner join dbamv.Remessa_Fatura rm on rm.cd_remessa = inf.cd_remessa
inner join dbamv.atendime atend on atend.cd_atendimento = inf.cd_atendimento
inner join dbamv.convenio conv on conv.cd_convenio = atend.cd_convenio
where to_char(nf.dt_emissao,'yyyy') = '2019'
and conv.tp_convenio = 'C'
and NF.DT_CANCELAMENTO is null
and nf.nr_id_nota_fiscal in (116912,117005)
and rm.dt_prevista_para_pgto is not null
order by nf.cd_multi_empresa,
         NF.NM_CLIENTE ,
         nf.nr_id_nota_fiscal
         

