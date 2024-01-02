select 
spla.cd_sub_plano id_subplano,
spla.ds_sub_plano nm_sub_plano,
conv.cd_convenio id_operadora,
conv.nm_convenio nm_operadora,
''data_Cadastro,
''responsavel_cadastro,
''data_atualizacao,
''responsavel_atualizacao
from 
dbamv.sub_plano spla
inner join dbamv.convenio conv on conv.cd_convenio = spla.cd_convenio
inner join dbamv.empresa_con_pla ecpla on ecpla.cd_convenio = conv.cd_convenio
                                      and ecpla.cd_con_pla = spla.cd_con_pla
inner join dbamv.con_pla cpla on cpla.cd_con_pla = ecpla.cd_con_pla 
                              and cpla.cd_convenio = ecpla.cd_convenio
where ecpla.cd_multi_empresa in (3,4,7,10,25)
and conv.tp_convenio = 'C'
order by conv.cd_convenio
