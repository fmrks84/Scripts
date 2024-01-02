select 
*
from
(
select length (A.CD_IBGE)IBGE,
       a.cd_uf,
       A.CD_CIDADE,
       A.NM_CIDADE,
       A.CD_IBGE
from dbamv.CIDADE a
where  a.cd_uf in ('SP','RJ')
--a.cd_paciente = 2548803-- from dual -- = (9)
)where IBGE < 07

order by 1
