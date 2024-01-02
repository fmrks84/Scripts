select 
nm_convenio,
sum(PROTOCOLO_CONF)TOTAL_PROTOCOLO_CONF,
sum(PROTOCOLO_PEND)TOTAL_PROTOCOLO_PEND
from
(
select 
c.cd_convenio||' - '||c.nm_convenio nm_convenio,
case when b.ds_protocolo_receb_tiss is null then 1 end PROTOCOLO_CONF,
case when b.ds_protocolo_receb_tiss is not null then 1 end PROTOCOLO_PEND
---b.ds_protocolo_receb_tiss
from fatura a 
inner join remessa_fatura b on b.cd_fatura = a.cd_fatura
inner join convenio c on c.cd_convenio = a.cd_convenio
where a.cd_multi_empresa = 7
and a.cd_convenio in (12,48,5,7)
and b.dt_fechamento is not null
and a.dt_competencia = '01/11/2021'
and c.tp_convenio = 'C'
order by c.cd_convenio
)
group by nm_convenio

--13:14 16/11
/*NM_CONVENIO	TOTAL_PROTOCOLO_CONF	TOTAL_PROTOCOLO_PEND
5 - AMIL ASSIST. MED - GRUPO AMIL	8	100
7 - BRADESCO SAÚDE	281	2
12 - CASSI	121	48
48 - SUL AMÉRICA SAÚDE	76	24*/

--
