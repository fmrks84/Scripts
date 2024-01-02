---Numero da Guia enviada / Atendimento / Conta / Paciente / Tipo de guia / Data

select
decode(atd.cd_multi_empresa,'3','CSSJ','4','HST','7','HSC','10','HSJ','11','HMRP','25','HCNSC')EMPRESA,
g.nr_guia,
g.nr_guia_operadora,
g.cd_atendimento,
--g.cd_reg_fat/*||''||*/,g.cd_reg_amb,
g.cd_reg_fat||''||g.cd_reg_amb CONTA,
g.nm_paciente,
g.nm_xml tipo_guia,
trunc(atd.dt_atendimento)dt_atendimento,
decode(atd.tp_atendimento,'A','Ambulatorio','E','Externo','U','Urgencia','I','Internado')tp_atendimento
from
tiss_guia g
inner join atendime atd on atd.cd_atendimento = g.cd_atendimento
where
trunc(atd.dt_atendimento) between '01/01/2021' and '28/02/2023'
--and g.cd_atendimento in (2780217,2796404)
--g.nr_guia = '864409'
and g.cd_convenio IN (104,218,185,217,48,213,147,215,204,216)
order by ATD.DT_ATENDIMENTO,atd.cd_atendimento
