select * from dbamv.estrutura_srv a where a.cd_id_estrutura_srv in (1154,1155)for update --;
select * from dbamv.config_proto b  order by b.cd_config_proto desc -b.cd_id_estrutura_srv IN (1455) 
 for update 
select c.cd_config_proto  from dbamv.config_proto c where 1=1 -- c.cd_multi_empresa = 1
and c.cd_id_estrutura_srv = 11
order by c.cd_config_proto desc 
2429

select * from dbamv.config_proto 
where cd_hospital = 719
and cd_id_estrutura_srv in (1153,1154,1155)
and cd_multi_empresa = 1
and ds_id_cliente = 414492
order by cd_config_proto desc  -- 2780
--for update 


