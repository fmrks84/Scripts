--select * from dbamv.estrutura_srv a1 where a1.cd_id_estrutura_srv in (1072)--for update --;
--select * from dbamv.config_proto b1  where b1.cd_id_estrutura_srv IN (1072)

update
dbamv.config_proto c 
set c.ds_query_alternativa = 'select observacao from dbamv.acsc_obser_pac where cd_atendimento = :par1'
where c.cd_id_estrutura_srv in
from 
(
select 
b.cd_id_estrutura_srv

from dbamv.convenio_conf_tiss a
inner join dbamv.config_proto b on a.nr_registro_operadora_ans = b.ds_id_cliente
inner join dbamv.estrutura_srv c on c.cd_id_estrutura_srv = b.cd_id_estrutura_srv
where a.cd_convenio not in (147) -- convenio
and b.cd_multi_empresa = 4 -- empresa 
and b.cd_id_estrutura_srv = 1521  -- tag_xml

)
and  c.cd_multi_empresa = 4 
and c. cd_id_estrutura_srv = 1521
--and c.ds_id_cliente not in ('000000')
;
commit;


select 
*
from dbamv.convenio_conf_tiss a
inner join dbamv.config_proto b on a.nr_registro_operadora_ans = b.ds_id_cliente
inner join dbamv.estrutura_srv c on c.cd_id_estrutura_srv = b.cd_id_estrutura_srv
where a.cd_convenio not in (147) -- convenio
and b.cd_multi_empresa = 4 -- empresa 
and b.cd_id_estrutura_srv = 1521 
