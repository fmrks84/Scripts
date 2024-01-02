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
     ,r.cd_con_pla
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
and r.cd_con_pla in (1)
and a.tp_atendimento in ('I')
--and r.cd_reg_fat = 251966 --(pac. internou como conv. e teve uma subconta Plano Covid.)

union all

select 
       decode (c1.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
       c1.dt_atendimento,
       c1.cd_atendimento,
       c1.cd_paciente,
       d1.nm_paciente,
       a1.cd_reg_amb conta,
       Decode(c1.tp_atendimento,'I','Internado'
                                ,'U','Urgencia'
                                ,'A','Ambulatorio'
                                ,'E','Externo') tp_atendimento,
       a1.cd_convenio,
       e1.nm_convenio,
       b1.cd_con_pla,
       a1.dt_lancamento dt_inicio,
       a1.dt_lancamento dt_final,
       b1.vl_total_conta
    

from reg_amb a1

inner join itreg_amb b1 on a1.cd_reg_amb = b1.cd_reg_amb
inner join atendime c1 on c1.cd_atendimento = b1.cd_atendimento
inner join paciente d1 on d1.cd_paciente = c1.cd_paciente
inner join convenio e1 on e1.cd_convenio = a1.cd_convenio
where c1.dt_atendimento BETWEEN  To_Date ('01/01/2018','dd/mm/yyyy') AND To_Date ('31/05/2021','dd/mm/yyyy')
and c1.cd_multi_empresa = 3
and a1.cd_convenio in (742)
and b1.cd_con_pla in (1)
and c1.tp_atendimento in ('U','A','E')
order by 2,5

