select a.cd_convenio,
       a.nm_convenio,
       b.cd_multi_empresa,
       c.cd_con_pla,
       d.ds_con_pla,
       c.cd_regra,
       c.cd_indice,
       c.sn_permite_internacao,
       c.sn_permite_ambulatorio,
       c.sn_permite_urgencia,
       c.sn_permite_externo,
       c.sn_permite_hoca,
       c.sn_obriga_senha,
       c.sn_valida_nr_guia,
       d.ds_observacao
       
from   dbamv.convenio a ,
       dbamv.empresa_convenio b,
       dbamv.empresa_con_pla c ,
       dbamv.con_pla d


where a.cd_convenio = b.cd_convenio
and   b.cd_convenio = c.cd_convenio
and   c.cd_multi_empresa = b.cd_multi_empresa
and    d.cd_con_pla = c.cd_con_pla
and    d.cd_convenio = b.cd_convenio
--and    a.cd_convenio = &cd_convenio

order by a.cd_convenio,
         b.cd_multi_empresa,
         c.cd_con_pla


--select * from dbamv.con_pla_pendencia a1 where a1.cd_convenio = 3
