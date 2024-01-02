select 
CONVENIO,
PRESTADOR,
VL_UNITARIO,
HSC TOTAL_LANCAMENTO,
HSC * VL_UNITARIO TOTAL_PRESTADOR
from
(
select 
*
from
(
select 
CASA,
CONVENIO,
PRESTADOR,
QT_LANCAMENTO,
VL_UNITARIO
from
(
select 
case when b.tp_atendimento = 'A' then 'AMBULATORIO'
     when b.tp_atendimento = 'E' then 'EXTERNO'
     when b.tp_atendimento = 'U' then 'URGENCIA'
     end TIPO_CONTA,
decode(b.cd_multi_empresa,'3','CSSJ','4','HST','7','HSC','10','HSJ','11','HMRP','25','HCNSC')CASA,
a.cd_convenio||' - '||c.nm_convenio convenio,
b.cd_atendimento,
to_date(b.dt_atendimento,'dd/mm/rrrr')dt_atendimento,
to_Date(a.hr_lancamento,'dd/mm/rrrr')dt_lancamento,
a.cd_prestador||' - '||d.nm_prestador prestador,
a.cd_pro_fat||' - '||e.ds_pro_fat procedimento,
a.qt_lancamento,
a.vl_unitario,
a.vl_total_conta

from 
dbamv.itreg_amb a 
inner join dbamv.atendime b on b.cd_atendimento = a.cd_atendimento
and b.cd_convenio = a.cd_convenio
inner join dbamv.convenio c on c.cd_convenio = a.cd_convenio
inner join dbamv.prestador d on d.cd_prestador = a.cd_prestador
inner join dbamv.pro_fat e on e.cd_pro_fat = a.cd_pro_fat
where to_date(a.hr_lancamento,'dd/mm/rrrr') between '01/01/2023' and '31/12/2023'
and a.cd_pro_fat = '10101012' 
and b.cd_multi_empresa = 7
and a.cd_prestador = 5461 
and a.cd_convenio = 3
order by a.hr_lancamento,a.cd_convenio
)
)
pivot (
   sum(qt_lancamento)
   for casa in ('HSC' AS HSC)
))
