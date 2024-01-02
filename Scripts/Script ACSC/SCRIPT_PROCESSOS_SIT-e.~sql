select /*x.dt_evento,x.cd_site_acao_evento,x.cd_usuario,x.ds_versao,x.ds_host, x.ds_ip_host, x.ds_local_site */ *
from site_evento x where to_date(x.dt_evento,'dd/mm/rrrr') = to_date(sysdate,'dd/mm/rrrr')
and x.cd_site_acao_evento in (2,3,5,7)
order by x.dt_evento desc  --order by x.cd_site_evento desc ;
;
-- aqui é log da elegibilidade 
--select * from site_xml order by 1 desc 
