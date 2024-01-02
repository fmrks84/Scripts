declare
cursor usu is
select distinct cd_id_usuario from
dbamv.usuario_unid_int
where
cd_unid_int in (41,42,59)
and cd_id_usuario not in ('DBAMV','FMELLO')
group by cd_id_usuario
order by cd_id_usuario;
BEGIN
    for x in usu loop
    insert into dbamv.usuario_unid_int(cd_unid_int,cd_id_usuario,cd_setor) values
    (60,x.cd_id_usuario,362);
    insert into dbamv.usuario_unid_int(cd_unid_int,cd_id_usuario,cd_setor) values
    (61,x.cd_id_usuario,363);
    insert into dbamv.usuario_unid_int(cd_unid_int,cd_id_usuario,cd_setor) values
    (62,x.cd_id_usuario,364);
    end loop;
end;
    
