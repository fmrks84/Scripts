select a.cd_convenio                   , 
       a.nm_convenio                   , 
       a.cd_cidade CIDADE              , 
       a.cd_fornecedor COD_FORNECEDOR  , 
       a.nm_razao_social RAZAO_SOCIAL  
       
from   dbamv.convenio a                ,  
       dbamv.fornecedor b
where  a.sn_ativo = 'S'

and    a.cd_fornecedor = b.cd_fornecedor
and    a.cd_cidade = b.cd_cidade
and    a.sn_ativo = b.sn_ativo
--and    a.cd_cidade not in (9627)-- (CONVENIOS FORA DO MUNICIPIO DE SÃO PAULO)
and    a.cd_cidade = 9627 
and    a.tp_convenio = 'C'
order by 1,2






