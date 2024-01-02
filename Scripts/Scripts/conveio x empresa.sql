select e.cd_convenio, 
       e.nm_convenio, 
       decode(f.cd_multi_empresa, '1','SANTA JOANA', 
                                  '2','PROMATRE', 
                                  '3','CENTRO DIAGNOSTICOS',
                                  '4','SERVIÇO VANGUARDA',
                                  '5','SANA SERVIÇOS ANESTESICOS')EMPRESA 
from dbamv.convenio e
inner join dbamv.Empresa_Convenio f on f.cd_convenio = e.cd_convenio
where 1=1
and e.Sn_Ativo = 'S'
and e.tp_convenio = 'C'
and e.cd_convenio not in (417,409)
order by e.cd_convenio
