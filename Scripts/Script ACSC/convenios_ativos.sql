select 
decode (econv.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') CASA,
conv.cd_convenio,
conv.nm_convenio
from convenio conv 
inner join empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
where conv.sn_ativo = 'S'
and econv.sn_ativo = 'S'
and conv.tp_convenio = 'C'
ORDER BY 1, 2
