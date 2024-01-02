select C.CD_CONVENIO,
       c.nm_convenio CONVENIO,
       t.cd_versao_tiss VERSAO_TISS
from dbamv.convenio_conf_tiss t
inner join dbamv.convenio c on c.cd_convenio = t.cd_convenio
inner join dbamv.empresa_convenio d on d.cd_convenio = c.cd_convenio
where c.sn_ativo = 'S'
and d.cd_multi_empresa = 3
and c.tp_convenio = 'C'
order by 1
