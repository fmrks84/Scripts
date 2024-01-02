select 
emp.cd_multi_empresa id_prestador,
emp.nr_cnes cnes,
emp.ds_multi_empresa nm_prestador,
emp.cd_cgc cnpj,
emp.ds_razao_social,
''data_Cadastro,
''responsavel_cadastro,
''data_atualizacao,
''responsavel_atualizacao
from 
dbamv.multi_empresas emp
where  emp.sn_ativo = 'S'
and emp.cd_multi_empresa in (3,4,7,10,25)
order by 1
