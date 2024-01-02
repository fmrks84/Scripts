select 
nm_usuario,
cd_usuario,
total,
total_geral,
round(((total / total_geral)*100),2)percentual
from
(
select  
u.nm_usuario,
ac.cd_usuario,
count(*)total,
(select 
count(*)total_geral
from age_cir AG, AVISO_CIRURGIA AC, USUARIOS U
where ag.cd_aviso_cirurgia = ac.cd_aviso_cirurgia
AND AC.CD_USUARIO = u.cd_usuario
AND AG.dt_inicio_age_cir > '01/08/2022'
and ac.tp_cirurgias = 'E')total_geral

from age_cir AG, AVISO_CIRURGIA AC, USUARIOS U
where ag.cd_aviso_cirurgia = ac.cd_aviso_cirurgia
AND AC.CD_USUARIO = u.cd_usuario
AND AG.dt_inicio_age_cir > '01/08/2022'
and ac.tp_cirurgias = 'E'
group by
u.nm_usuario,
ac.cd_usuario
)






