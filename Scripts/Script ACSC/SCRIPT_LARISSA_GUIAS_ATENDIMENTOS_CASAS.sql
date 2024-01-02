
---Numero da Guia enviada / Atendimento / Conta / Paciente / Tipo de guia / Data

select 
decode(atd.cd_multi_empresa,'3','CSSJ','4','HST','7','HSC','10','HSJ','11','HMRP','25','HCNSC')EMPRESA,
g.nr_guia,
g.nr_guia_operadora,
g.cd_atendimento,
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
;
--select * from tiss_guia where cd_atendimento = 2839876


/*select 
*
from
(
select 
distinct
g.nr_guia,
g.cd_atendimento,
iramb.cd_reg_amb conta,
g.cd_paciente,
pct.nm_paciente,
--g.tp_guia,
decode(g.tp_guia,'R','Prorrogacao','O','OPME','I','Internacao',
'P','Procedimento','S','SADT', 'C','Consulta',
'T','Materiais','M','Medicamentos',
'Q','Quimioterapia',
'D','Radioterapia')tp_guia,
g.dt_solicitacao,
atd.dt_atendimento,
decode(atd.tp_atendimento,'A','Ambulatorio','E','Externo','U','Urgencia','I','Internado')tp_atendimento,
decode(atd.cd_multi_empresa,'3','CSSJ','4','HST','7','HSC','10','HSJ','11','HMRP','25','HCNSC')EMPRESA

from 
guia g 
inner join paciente pct on pct.cd_paciente = g.cd_paciente 
inner join atendime atd on atd.cd_atendimento = g.cd_atendimento
inner join itreg_amb iramb on iramb.cd_atendimento = g.cd_atendimento
where \*to_date(atd.dt_atendimento,'dd/mm/rrrr') between '01/07/2021' and '31/01/2023'
and *\ATD.CD_CONVENIO IN (218,
104,
185,
213,
48,
215,
147,
216,
204,
217)
--AND g.cd_atendimento = 2909950
--group by g.tp_guia
--order by g.cd_atendimento

UNION ALL 
select 
--distinct
g.nr_guia,
g.cd_atendimento,
rf.cd_reg_Fat conta,
g.cd_paciente,
pct.nm_paciente,
--g.tp_guia,
decode(g.tp_guia,'R','Prorrogacao','O','OPME','I','Internacao',
'P','Procedimento','S','SADT', 'C','Consulta',
'T','Materiais','M','Medicamentos',
'Q','Quimioterapia',
'D','Radioterapia')tp_guia,
g.dt_solicitacao,
atd.dt_atendimento,
decode(atd.tp_atendimento,'A','Ambulatorio','E','Externo','U','Urgencia','I','Internado')tp_atendimento,
decode(atd.cd_multi_empresa,'3','CSSJ','4','HST','7','HSC','10','HSJ','11','HMRP','25','HCNSC')EMPRESA
--g.tp_guia,

from 
guia g 
inner join paciente pct on pct.cd_paciente = g.cd_paciente 
inner join atendime atd on atd.cd_atendimento = g.cd_atendimento
inner join reg_fat rf on rf.cd_atendimento = g.cd_atendimento
where \*to_date(atd.dt_atendimento,'dd/mm/rrrr') between '01/07/2021' and '31/01/2023'
and*\ ATD.CD_CONVENIO IN (218,
104,
185,
213,
48,
215,
147,
216,
204,
217)
--AND g.cd_atendimento = 2909950
--group by g.tp_guia
)
where nr_Guia = '850294249'
order by dt_atendimento,cd_atendimento

select * from tiss_guia tg where tg.nr_guia = '850294249'
select * from guia n where n.cd_atendimento = 2839876-n.nr_guia = '864409'
--select * from reg_amb where cd_reg_amb = 864409

--select * from convenio where cd_convenio = 180*/
