delete from
it_guia a1 where a1.cd_guia in 
(
select 
a.cd_guia
--b.cd_pro_fat
from 
guia a 
inner join it_Guia b on b.cd_guia = a.cd_guia
where a.cd_aviso_cirurgia = 348222
and a.tp_guia = 'O'
and b.cd_pro_fat is not null)
and a1.cd_pro_fat is not null


