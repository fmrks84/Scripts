select 
*
from
(
select
to_char(atd.dt_atendimento,'RRRR')ANO,
decode(atd.cd_multi_empresa,'3','CSSJ','4','HST','7','HSC','11','HMRP','25','HCNSC')CASA,
decode(atd.tp_atendimento,'A','AMBULATORIO','U','URGENCIA','I','INTERNADO','E','EXTERNO')TP_ATENDIMENTO,
--atd.dt_atendimento,
to_CHAR(atd.dt_atendimento,'MM')NR_MES,
case when to_char(atd.dt_atendimento,'MM')= '01' THEN 'JANEIRO'
  when to_char(atd.dt_atendimento,'MM')= '02' THEN 'FEVEREIO'
    when to_char(atd.dt_atendimento,'MM')= '03' THEN 'MARCO'
      when to_char(atd.dt_atendimento,'MM')= '04' THEN 'ABRIL'
        when to_char(atd.dt_atendimento,'MM')= '05' THEN 'MAIO'
          when to_char(atd.dt_atendimento,'MM')= '06' THEN 'JUNHO'
            when to_char(atd.dt_atendimento,'MM')= '07' THEN 'JULHO'
              when to_char(atd.dt_atendimento,'MM')= '08' THEN 'AGOSTO'
                when to_char(atd.dt_atendimento,'MM')= '09' THEN 'SETEMBRO'
                  when to_char(atd.dt_atendimento,'MM')= '10' THEN 'OUTUBRO'
                    when to_char(atd.dt_atendimento,'MM')= '11' THEN 'NOVEMBRO'
                      when to_char(atd.dt_atendimento,'MM')= '12' THEN 'DEZEMBRO'
                        END MES

from
dbamv.atendime atd 
where to_date(atd.dt_atendimento,'DD/MM/RRRR') between '01/01/2022' and '31/10/2023'
and atd.cd_multi_empresa IN (3,7) 
order by to_CHAR(atd.dt_atendimento,'MM'), atd.tp_atendimento
)
pivot
(COUNT(casa) 
 for casa IN ('CSSJ'AS CSSJ,'HSC' AS HSC)

)
order by ANO,NR_MES,TP_ATENDIMENTO


select trunc(sysdate + 1) +30/1440  from dual --- ORDER BY 1 desc 

