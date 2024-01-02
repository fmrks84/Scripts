-- relat.1 - atend. pacientes partic.(contendo tipo de atendimento, data de início e término do atend, nome, etc).
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

FROM atendime a
    ,reg_fat r
    ,paciente p
    ,convenio c

Where a.cd_convenio = c.cd_convenio
and a.cd_paciente = p.cd_paciente
and a.cd_multi_empresa = r.cd_multi_empresa
and a.cd_atendimento = r.cd_atendimento
and a.dt_atendimento BETWEEN  To_Date ('01/01/2018','dd/mm/yyyy') AND To_Date ('17/05/2021','dd/mm/yyyy')
and c.tp_convenio = 'P'
and a.cd_multi_empresa = 3
and c.cd_convenio = 261
and a.tp_atendimento = 'I'

union all

select distinct
       decode (a.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa
      ,a.dt_atendimento
      ,a.cd_atendimento
      ,a.cd_paciente
      ,p.nm_paciente
      ,r1.cd_reg_amb conta
      ,Decode(a.tp_atendimento,'I','Internado'
                                ,'U','Urgencia'
                                ,'A','Ambulatorio'
                                ,'E','Externo') tp_atendimento
     ,r1.cd_convenio
     ,c.nm_convenio
     ,r1.dt_lancamento dt_inicio
     ,r1.dt_lancamento dt_final

FROM atendime a
    ,reg_amb r1
    ,paciente p
    ,convenio c
    ,itreg_amb d

Where a.cd_convenio = c.cd_convenio
and a.cd_paciente = p.cd_paciente
and a.cd_multi_empresa = r1.cd_multi_empresa
and a.cd_atendimento = d.cd_atendimento
and d.cd_reg_amb = r1.cd_reg_amb
and a.dt_atendimento BETWEEN  To_Date ('01/01/2018','dd/mm/yyyy') AND To_Date ('17/05/2021','dd/mm/yyyy')
and c.tp_convenio = 'P'
and a.cd_multi_empresa = 3
and c.cd_convenio = 261
and a.tp_atendimento in ('U','A','E')
order by 2
