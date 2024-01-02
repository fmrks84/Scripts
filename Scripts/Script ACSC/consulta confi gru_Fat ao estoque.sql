select 
a.cd_especie,
a.cd_classe,
a.cd_gru_fat,
a.cd_setor,
a.cd_estoque,
a.cd_conf_import,
a.cd_sub_cla,
a.cd_produto
from 
dbamv.configu_importacao_gru_fat a 
inner join dbamv.setor b on b.cd_setor = a.cd_setor
where b.cd_multi_empresa = 3
and b.cd_setor = 3744 -- 3744
--and b.sn_ativo = 'S'
order by 1,2
--order by 1
select  a.cd_conf_import  from dbamv.configu_importacao_gru_fat a 
order by a.cd_conf_import desc --where a.cd_setor = 3693

select * from setor where cd_multi_empresa = 3 and sn_Ativo = 'S'
ORDER BY 2

select * from unid_int z where z.cd_unid_int in (924,1084,3701)--z.cd_setor = 3697

select cd_setor, nm_setor , cd_multi_empresa from setor where cd_setor in (805,3700,3701) 

select cd_conf_import from dbamv.configu_importacao_gru_fat order by cd_conf_import desc 
