select a.cd_convenio, a.cd_multi_empresa,b.nm_convenio, a.ds_url from SITE_INTEGRA_CONVENIO A 
Inner join convenio b on b.cd_convenio = a.cd_convenio
WHERE A.CD_MULTI_EMPRESA IN (3,4,7,11,25)
AND A.CD_CONVENIO  in (7, 73, 116, 156, 190, 303, 308, 377, 641, 661, 662, 663)
AND A.CD_SITE_SERVICO = 661
ORDER BY 2

;

select a.cd_convenio, a.cd_multi_empresa,b.nm_convenio, a.ds_url from SITE_INTEGRA_CONVENIO A 
Inner join convenio b on b.cd_convenio = a.cd_convenio
WHERE A.CD_MULTI_EMPRESA IN (3,4,7,11,25)
AND A.CD_CONVENIO  in (93, 200, 32, 132, 174)
AND A.CD_SITE_SERVICO = 661
ORDER BY 2
;

select
c.cd_convenio,
c.tp_opme_vl_referencia
update 

--from 
empresa_convenio c set c.tp_opme_vl_referencia = 'NOTAF-TABELA-SIMPRO'
where c.cd_multi_empresa = 3 
and c.cd_convenio in (73,93,661)
order by c.cd_convenio
