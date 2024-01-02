select 
cpl.cd_con_pla id_plano,
cpl.ds_con_pla nm_plano,
conv.cd_convenio id_operadora,
conv.nm_convenio nm_operadora
''data_Cadastro,
''responsavel_cadastro,
''data_atualizacao,
''responsavel_atualizacao
from 
dbamv.con_pla cpl
inner join dbamv.empresa_con_pla ecpla on ecpla.cd_con_pla = cpl.cd_con_pla
                                      and ecpla.cd_convenio = cpl.cd_convenio
inner join dbamv.convenio conv on ecpla.cd_convenio = conv.cd_convenio
where conv.tp_convenio = 'C'
and ecpla.cd_multi_empresa in (3,4,7,10,25)
order by conv.cd_convenio
