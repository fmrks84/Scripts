select
*
from
(
select
       decode (a.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa
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
     ,r.cd_remessa
     ,nf2.nr_nota_fiscal_nfe

FROM atendime a
    ,reg_fat  r
    ,paciente p
    ,convenio c
    ,itfat_nota_fiscal inf2
    ,nota_fiscal nf2


Where r.cd_convenio = c.cd_convenio
and a.cd_paciente = p.cd_paciente
and a.cd_multi_empresa = r.cd_multi_empresa
and a.cd_atendimento = r.cd_atendimento
and inf2.cd_remessa(+) = r.cd_remessa
and inf2.cd_nota_fiscal= nf2.cd_nota_fiscal(+)
and inf2.cd_reg_fat(+) = r.cd_reg_fat
and a.dt_atendimento BETWEEN  To_Date ('01/01/2018','dd/mm/yyyy') AND To_Date ('31/05/2021','dd/mm/yyyy')
and a.cd_multi_empresa = 3
and r.cd_convenio in (742)

union all

select
      decode (a.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa
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
     ,r.cd_remessa
     ,nf2.nr_nota_fiscal_nfe


FROM atendime a
    ,reg_fat  r
    ,paciente p
    ,convenio c
    ,itfat_nota_fiscal inf2
    ,nota_fiscal nf2


Where r.cd_convenio = c.cd_convenio
and a.cd_paciente = p.cd_paciente
and a.cd_multi_empresa = r.cd_multi_empresa
and a.cd_atendimento = r.cd_atendimento
and inf2.cd_remessa(+) = r.cd_remessa
and inf2.cd_nota_fiscal = nf2.cd_nota_fiscal(+)
and inf2.cd_reg_fat(+) = r.cd_reg_fat
and a.dt_atendimento BETWEEN  To_Date ('01/01/2018','dd/mm/yyyy') AND To_Date ('31/05/2021','dd/mm/yyyy')
and a.cd_multi_empresa = 3
and r.cd_convenio in (261)
and r.cd_con_pla = 13

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
       a1.dt_lancamento dt_inicio,
       a1.dt_lancamento dt_final,
       b1.vl_total_conta,
       a1.cd_remessa ,
       nf.nr_nota_fiscal_nfe



from reg_amb a1

inner join itreg_amb b1 on a1.cd_reg_amb = b1.cd_reg_amb
inner join atendime c1 on c1.cd_atendimento = b1.cd_atendimento
inner join paciente d1 on d1.cd_paciente = c1.cd_paciente
inner join convenio e1 on e1.cd_convenio = a1.cd_convenio
left join itfat_nota_fiscal inf on inf.cd_remessa = a1.cd_remessa
left join nota_fiscal nf on nf.cd_nota_fiscal = inf.cd_nota_fiscal
where c1.dt_atendimento BETWEEN  To_Date ('01/01/2018','dd/mm/yyyy') AND To_Date ('31/05/2021','dd/mm/yyyy')
and c1.cd_multi_empresa = 3
and b1.cd_convenio in (742)

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
       a1.dt_lancamento dt_inicio,
       a1.dt_lancamento dt_final,
       b1.vl_total_conta,
       a1.cd_remessa,
       nf.nr_nota_fiscal_nfe



from reg_amb a1

inner join itreg_amb b1 on a1.cd_reg_amb = b1.cd_reg_amb
inner join atendime c1 on c1.cd_atendimento = b1.cd_atendimento
inner join paciente d1 on d1.cd_paciente = c1.cd_paciente
inner join convenio e1 on e1.cd_convenio = a1.cd_convenio
left join itfat_nota_fiscal inf on inf.cd_remessa = a1.cd_remessa
left join nota_fiscal nf on nf.cd_nota_fiscal = inf.cd_nota_fiscal
and  a1.cd_reg_amb = inf.cd_reg_amb
where c1.dt_atendimento BETWEEN  To_Date ('01/01/2018','dd/mm/yyyy') AND To_Date ('31/05/2021','dd/mm/yyyy')
and c1.cd_multi_empresa = 3
and b1.cd_convenio in (261)
and b1.cd_con_pla = 13
)REL
--where conta = 1885051
order by dt_Atendimento , nm_paciente
