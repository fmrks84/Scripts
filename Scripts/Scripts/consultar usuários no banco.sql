select rownum,
       nvl(s.username, 'Internal') username,
       c.nm_usuario nome,
       nvl(s.terminal, 'None') terminal,
       s.osuser,
       l.sid,
       s.serial# serial,
       u1.name || '.' || substr(t1.name, 1, 20) tab,
       decode(l.lmode
             ,1
             ,'No Lock'
             ,2
             ,'Row Share'
             ,3
             ,'Row Exclusive'
             ,4
             ,'Share'
             ,5
             ,'Share Row Exclusive'
             ,6
             ,'Exclusive'
             ,null) lmode,
       decode(l.request
             ,1
             ,'No Lock'
             ,2
             ,'Row Share'
             ,3
             ,'Row Exclusive'
             ,4
             ,'Share'
             ,5
             ,'Share Row Exclusive'
             ,6
             ,'Exclusive'
             ,null) request,
       to_char(trunc(sysdate) + l.ctime * (1 / (24 * 60 * 60))
              ,'hh24:mi:ss') tempo
  from sys.v_$lock     l,
       sys.v_$session  s,
       sys.user$       u1,
       sys.obj$        t1,
       dbasgu.usuarios c
 where l.sid = s.sid
   and c.cd_usuario(+) = s.username
   and t1.obj# = decode(l.id2, 0, l.id1, l.id2)
   and u1.user# = t1.owner#
   and s.type != 'BACKGROUND'
   and s.username != 'SYS'
   and l.ctime > 900
