select 
count(*)
from
(

select  nf.cd_atendimento,
        decode(atd.tp_atendimento,'A','AMBULATORIO','E','EXTERNO','U','URGENCIA','I','INTERNADO')TP_ATENDIMENTO,
        nf.dt_emissao EMISSAO,
        nf.nm_cliente CLIENTE,
        nf.nr_id_nota_fiscal RPS,
        NF.HR_EMISSAO_NFE,
        nvl(TO_CHAR(nf.nr_nota_fiscal_nfe),'SEM CONVERTER') NFE,
        nf.ds_retorno_nfe,
        nf.cd_multi_empresa empresa
from nota_fiscal nf
left join atendime atd on atd.cd_atendimento = nf.cd_atendimento
where nf.dt_emissao between '01/03/2022' and '21/03/2022'
and nf.nr_nota_fiscal_nfe is null
--AND NF.HR_EMISSAO_NFE > '10/03/2022'
and nf.cd_multi_empresa = 1
--and nf.cd_atendimento is null
--AND nf.ds_retorno_nfe is not null
--and nf.cd_atendimento = 8432759
order by 2
)
;

select  nf.cd_atendimento,
        NF.CD_REG_FAT,
        NF.CD_REG_AMB,
        decode(atd.tp_atendimento,'A','AMBULATORIO','E','EXTERNO','U','URGENCIA','I','INTERNADO')TP_ATENDIMENTO,
        nf.dt_emissao EMISSAO,
        nf.nm_cliente CLIENTE,
        nf.nr_id_nota_fiscal RPS,
        nvl(TO_CHAR(nf.nr_nota_fiscal_nfe),'SEM CONVERTER') NFE,
        nf.ds_retorno_nfe,
        nf.cd_multi_empresa empresa
from nota_fiscal nf
left join atendime atd on atd.cd_atendimento = nf.cd_atendimento
where nf.dt_emissao between '01/03/2022' and '21/03/2022'
and nf.nr_nota_fiscal_nfe is null
and nf.cd_multi_empresa = 1
--and nf.cd_atendimento is null
--AND nf.ds_retorno_nfe is not null
--and nf.cd_atendimento = 8432759
order by 7

;
-----

SELECT * FROM NOTA_FISCAL X WHERE X.CD_NOTA_FISCAL IN (707911) ;---FOR UPDATE ;
SELECT * 
---SELECT * FROM CON_REC Y WHERE Y.CD_NOTA_FISCAL = 702710
--SELECT * FROM LCTO_CONTABIL Z WHERE Z.CD_LCTO_MOVIMENTO = 31187739
--SELECT * FROM CON_REC X1 WHERE X1.NR_DOCUMENTO in ('859721','864196');
---SELECT * FROM CIDADE Y WHERE Y.CD_CIDADE IN (888) --FOR UPDATE 
--SELECT * FROM 

---select * from 
