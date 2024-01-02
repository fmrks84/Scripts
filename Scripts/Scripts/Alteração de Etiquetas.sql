select *from dbamv.repo_ate order by 1
select *from dbamv.gerador_etiqueta order by cd_repo_ate

select * from dbamv.repo_ate  order by 1

select * from dbamv.gerador_etiqueta  order by cd_repo_ate

select e.cd_etiqueta, e.ds_etiqueta, e.cd_repo_ate etiqueta
     , r.cd_repo_ate relatorio , r.nm_repo_ate, r.tp_objeto
from   dbamv.gerador_etiqueta e, dbamv.repo_ate r
where  e.cd_repo_ate = r.cd_repo_ate
Order by 4
