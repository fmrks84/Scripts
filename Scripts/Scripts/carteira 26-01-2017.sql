
select a.cd_paciente,
       a.cd_convenio,
       a.cd_con_pla,
       a.nr_carteira,
       a.dt_validade,
       a.sn_padrao,
       a.sn_carteira_ativo,
      max (a.dt_integra)
from dbamv.carteira a
inner join  dbamv.convenio b on b.cd_convenio = A.CD_CONVENIO
where 1=1--a.dt_integra >='01/01/2016'
and a.cd_paciente = 101288--509158 , 101288
and b.sn_ativo = 'S'

group by 
       a.cd_paciente,
       a.cd_convenio,
       a.cd_con_pla,
       a.nr_carteira,
       a.dt_validade,
       a.dt_integra,
       a.sn_padrao,
       a.sn_carteira_ativo



