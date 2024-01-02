select b.inst_id inst_id_l,
       b.sid sid_l,
       b.serial# serial_l,
       b.username username_l,
       substr(c.nm_usuario, 1, 60) nm_usuario_l,
       substr(c.ds_observacao, 1, 30) setor_l,
       b.machine machine_l,
       substr(b.action, 1, 30) action_l,
       b.osuser osuser_l,
       a.blocking_session,
       a.inst_id,
       a.sid,
       a.seconds_in_wait,
       a.username,
       substr(d.nm_usuario, 1, 60) nm_usuario,
       substr(d.ds_observacao, 1, 30) setor,
       a.machine,
       substr(a.action, 1, 30) action,
       a.osuser,
       a.terminal,
       a.module,
       a.blocking_session_status,
       a.wait_class,
       a.state,
       a.lockwait,
       a.plsql_object_id
  from gv$session a, gv$session b, dbasgu.usuarios c, dbasgu.usuarios d
 where a.status = 'ACTIVE'
   and a.username is not null
   and nvl(a.blocking_session, 0) = b.sid(+)
   and nvl(a.blocking_instance, 0) = b.inst_id(+)
   and c.cd_usuario(+) = b.username
   and d.cd_usuario(+) = a.username
 order by a.seconds_in_wait desc
