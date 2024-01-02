select decode (a.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa
      ,a.dt_atendimento
      ,a.cd_atendimento
      ,a.cd_paciente
      ,p.nm_paciente
      ,r.cd_reg_fat conta
      ,Decode(a.tp_atendimento,'I','Internado'
                                ,'U','Urgencia'
                                ,'A','Ambulatorio'
                                ,'E','Externo') tp_atendimento
     ,r.cd_convenio
     ,c.nm_convenio
     ,r.dt_inicio dt_inicio
     ,r.dt_final dt_final
     ,r.vl_total_conta

FROM atendime a
    ,reg_fat  r
    ,paciente p
    ,convenio c


Where r.cd_convenio = c.cd_convenio
and a.cd_paciente = p.cd_paciente
and a.cd_multi_empresa = r.cd_multi_empresa
and a.cd_atendimento = r.cd_atendimento
and a.dt_atendimento BETWEEN  To_Date ('01/01/2018','dd/mm/yyyy') AND To_Date ('31/05/2021','dd/mm/yyyy')
and a.cd_multi_empresa = 3
and r.cd_convenio in (742)
and a.tp_atendimento = 'I'
--and r.cd_reg_fat = 251966 --(pac. internou como conv. e teve uma subconta Plano Covid.)

union all

select distinct
       decode (c.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
       c.dt_atendimento,
       c.cd_atendimento,
       c.cd_paciente,
       d.nm_paciente,
       a.cd_reg_amb conta,
       Decode(c.tp_atendimento,'I','Internado'
                                ,'U','Urgencia'
                                ,'A','Ambulatorio'
                                ,'E','Externo') tp_atendimento,
       a.cd_convenio,
       e.nm_convenio,
       a.dt_lancamento dt_inicio,
       a.dt_lancamento dt_final,
       a.vl_total_conta                         
                                

from reg_amb a

inner join itreg_amb b on a.cd_reg_amb = b.cd_reg_amb
inner join atendime c on c.cd_atendimento = b.cd_atendimento
inner join paciente d on d.cd_paciente = c.cd_paciente
inner join convenio e on e.cd_convenio = a.cd_convenio
where c.dt_atendimento BETWEEN  To_Date ('01/01/2018','dd/mm/yyyy') AND To_Date ('31/05/2021','dd/mm/yyyy')
and c.cd_multi_empresa = 3
and a.cd_convenio in (742)  

order by 2
