--select * from dbamv.estrutura_srv a1 where a1.cd_id_estrutura_srv in (1072)--for update --;
--select * from dbamv.config_proto b1  where b1.cd_id_estrutura_srv IN (1072)

select a.cd_convenio,
b.ds_id_cliente,
b.cd_multi_empresa,
a.cd_versao_tiss,
b.cd_id_estrutura_srv,
c.ds_estrutura_srv,
b.ds_query_alternativa

from dbamv.convenio_conf_tiss a
inner join dbamv.config_proto b on a.nr_registro_operadora_ans = b.ds_id_cliente
inner join dbamv.estrutura_srv c on c.cd_id_estrutura_srv = b.cd_id_estrutura_srv
where a.cd_convenio = 147 -- convenio
and b.cd_multi_empresa = 10 -- empresa 
--and b.cd_id_estrutura_srv = 1072  -- tag_xml


---select * from all_tab_columns z where Z.column_name like '%CD_CONDICAO1%'
