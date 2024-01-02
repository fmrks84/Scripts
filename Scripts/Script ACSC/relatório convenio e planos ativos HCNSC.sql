select 
c.cd_convenio,
c.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
decode(ecp.sn_permite_internacao,'S','SIM','N','NÃO')Permite_internacao,
decode(ecp.sn_permite_urgencia,'S','SIM','N','NÃO')Permite_urgencia,
decode(ecp.sn_permite_hoca,'S','SIM','N','NÃO') Permite_HomeCare,
decode(ecp.sn_permite_ambulatorio,'S','SIM','N','NÃO') Permite_ambulatorio,
decode(ecp.sn_permite_externo,'S','SIM','N','NÃO')Permite_Externo
from 
convenio c 
inner join empresa_convenio ec on ec.cd_convenio = c.cd_convenio
inner join empresa_con_pla ecp on ecp.cd_convenio = ec.cd_convenio and ec.cd_multi_empresa = ecp.cd_multi_empresa
inner join con_pla cpla on cpla.cd_con_pla = ecp.cd_con_pla and cpla.cd_convenio = ecp.cd_convenio
where ec.cd_multi_empresa = 25
and c.Sn_Ativo = 'S'
and ecp.sn_ativo = 'S'
and cpla.sn_ativo = 'S'
--and cpla.cd_con_pla = 1
--and ec.cd_convenio = 197
order by c.nm_convenio,
          cpla.cd_con_pla
