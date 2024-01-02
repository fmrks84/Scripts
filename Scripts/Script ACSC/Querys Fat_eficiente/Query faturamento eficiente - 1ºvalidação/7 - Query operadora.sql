select 
conv.cd_convenio id_Operadora,
conv.nr_registro_operadora_ans registro_Ans,
conv.nm_convenio nm_operadora,
conv.nr_cgc cnpj,
forn.nm_fornecedor razao_social,
''data_Cadastro,
''responsavel_cadastro,
''data_atualizacao,
''responsavel_atualizacao


from 
dbamv.convenio conv
inner join dbamv.Empresa_Convenio econv on econv.cd_convenio = conv.cd_convenio
inner join dbamv.fornecedor forn on forn.cd_fornecedor = conv.cd_fornecedor
where econv.cd_multi_empresa in (3,4,7,10,25)
and conv.tp_convenio = 'C'
order by conv.nm_convenio
         
