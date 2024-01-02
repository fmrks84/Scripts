select 
c.cd_usuario,
e.nm_usuario,
a.cd_modulo,
b.cd_papel,
d.ds_papel
from dbasgu.modulos a
inner join dbasgu.papel_mod b on b.cd_modulo = a.cd_modulo
inner join dbasgu.papel_usuarios c on c.cd_papel = b.cd_papel
inner join dbasgu.papel d on d.cd_papel = c.cd_papel
inner join dbasgu.usuarios e on e.cd_usuario = c.cd_usuario
where a.CD_modulo = 'M_CONFIGURA'


select * from dbasgu.usuarios x where x.cd_usuario = 'RANJOS'
