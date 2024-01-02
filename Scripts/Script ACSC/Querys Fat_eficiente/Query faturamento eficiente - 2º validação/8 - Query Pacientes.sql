select 
pct.cd_paciente id_paciente,
pct.nm_paciente nm_paciente,
pct.nr_cns numero_cns,
pct.dt_nascimento data_nascimento,
decode(pct.tp_sexo,'M','MASCULINO','F','FEMININO','I','INDEFINIDO','G','IGNORADO')SEXO,
pct.dt_cadastro,
pct.nm_usuario responsavel_cadastro,
pct.dt_ultima_atualizacao data_atualizacao,
pct.nm_usuario_ultima_atualizacao responsavel_atualizacao
 from 
dbamv.paciente pct
WHERE  pct.nm_paciente NOT IN('RN %') OR pct.nm_paciente NOT IN ('AD %')
order by 2



