with horarios (horario) as (
  select trunc(sysdate) + interval '7' hour
  from dual
  union all
  select horario + interval '30' minute
  from horarios
  where horario + interval '30' minute <= trunc(sysdate) + interval '23' hour
)
select  to_char(hr.horario,'hh24:mi')hora,
        hora_agend,
        x.nm_paciente,
        x.cd_agenda_central
       -- acx.nm_paciente
    from horarios hr, (
select 
to_char(iac.hr_agenda,'hh24:mi')hora_agend,
iac.cd_agenda_central,
iac.nm_paciente
from agenda_central ac
inner join it_agenda_central iac on iac.cd_agenda_central = ac.cd_agenda_central
and ac.dt_agenda between '01/02/2024' and '01/02/2024'
--and ac.cd_agenda_central = 688922
) x
--inner join it_agenda_central acx on acx.cd_agenda_central = x.cd_agenda_central
where hora_agend(+) = to_char(hr.horario,'hh24:mi')
order by 1
;
select * from it_agenda_central o where o.cd_agenda_central >= 671458
