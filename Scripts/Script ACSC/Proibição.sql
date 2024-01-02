select 
      count(*)QTD,
      a.cd_convenio,
      b.nm_convenio,
      a.tp_proibicao,
      a.cd_con_pla,  
      a.cd_pro_fat,
      a.tp_atendimento,
      a.cd_multi_empresa
from 
dbamv.proibicao a
inner join dbamv.convenio b on b.cd_convenio = a.cd_convenio
where a.cd_pro_fat in ('00280696','00256579')
and a.tp_proibicao in ('FC','NA')
and a.cd_convenio = 16
group by a.cd_convenio, 
         a.tp_proibicao, 
         a.cd_pro_fat,
         a.cd_con_pla,
         b.nm_convenio,
         a.tp_atendimento,
         a.cd_multi_empresa


order by 2,3,4,5
