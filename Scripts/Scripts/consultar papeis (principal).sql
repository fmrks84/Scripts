select p.cd_papel, l.ds_papel, count(*)
  from dbasgu.papel_usuarios p, dbasgu.papel l
 where p.cd_papel = l.cd_papel
   and p.tp_papel = 'P'
 group by p.cd_papel, l.ds_papel
