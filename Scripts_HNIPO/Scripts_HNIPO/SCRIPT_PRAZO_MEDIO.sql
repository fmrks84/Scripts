/*--- PMR -------

select 
cd_con_rec,
nr_documento,
dt_emissao,
--dt_vencimento,
sum(prazo)PRAZO,
sum(vl_recebido)VALOR,
sum(valor_ponderado)VALOR_PONDERADO,
round(sum(valor_ponderado) / sum(vl_recebido))MEDIA_PONDERADA
from
(
select 
b.cd_con_rec,
b.nr_documento,
to_date(b.dt_emissao,'dd/mm/rrrr')dt_emissao,
to_date(d.dt_recebimento,'dd/mm/rrrr') dt_vencimento,
c.vl_duplicata,
sum(d.vl_recebido)vl_recebido,
sum(d.vl_recebido) - c.vl_duplicata vl_a_receber,
to_date(d.dt_recebimento,'dd/mm/rrrr') - to_date(b.dt_emissao,'dd/mm/rrrr') prazo,
(to_date(d.dt_recebimento,'dd/mm/rrrr') - to_date(b.dt_emissao,'dd/mm/rrrr')) * sum(d.vl_recebido)valor_ponderado

from 
atendime a 
inner join con_rec b on b.cd_atendimento = a.cd_atendimento
inner join itcon_rec c on c.cd_con_rec = b.cd_con_rec
left join reccon_rec d on d.cd_itcon_rec = c.cd_itcon_rec
inner join nota_fiscal e on e.cd_nota_fiscal = b.cd_nota_fiscal and e.cd_atendimento = b.cd_atendimento
where A.DT_ATENDIMENTO BETWEEN '01/07/2022' AND '30/07/2022' 
AND a.cd_convenio = 40
and c.tp_quitacao in ('C','Q','P')
and b.cd_con_rec = 1231488
group by
b.cd_con_rec,
b.nr_documento,
to_date(b.dt_emissao,'dd/mm/rrrr'),
to_date(d.dt_recebimento,'dd/mm/rrrr'),
c.vl_duplicata
order by 1
)
group by 
cd_con_rec,
nr_documento,
dt_emissao
--dt_vencimento
;
*/
--------

------------ PMF 
/*select 
sum(prazo) * sum(vl_duplicata) / sum(vl_duplicata) Prazo_medio_faturamento
from
(*/
select 
b.cd_con_rec,
b.nr_documento,
to_date(b.dt_emissao,'dd/mm/rrrr')dt_emissao,
C.DT_PREVISTA_RECEBIMENTO,
to_date(d.dt_recebimento,'dd/mm/rrrr') dt_vencimento,
c.vl_duplicata,
sum(d.vl_recebido)vl_recebido,
sum(d.vl_recebido) - c.vl_duplicata vl_a_receber,
to_date(d.dt_recebimento,'dd/mm/rrrr') - to_date(b.dt_emissao,'dd/mm/rrrr') prazo,
(to_date(d.dt_recebimento,'dd/mm/rrrr') - to_date(b.dt_emissao,'dd/mm/rrrr')) * sum(d.vl_recebido)valor_ponderado

from 
atendime a 
inner join con_rec b on b.cd_atendimento = a.cd_atendimento
inner join itcon_rec c on c.cd_con_rec = b.cd_con_rec
left join reccon_rec d on d.cd_itcon_rec = c.cd_itcon_rec
inner join nota_fiscal e on e.cd_nota_fiscal = b.cd_nota_fiscal and e.cd_atendimento = b.cd_atendimento
where A.DT_ATENDIMENTO BETWEEN '01/07/2022' AND '30/07/2022' 
AND a.cd_convenio = 40
and c.tp_quitacao in ('C','Q','P')
and b.cd_con_rec = 1234445
group by
b.cd_con_rec,
b.nr_documento,
to_date(b.dt_emissao,'dd/mm/rrrr'),
to_date(d.dt_recebimento,'dd/mm/rrrr'),
c.vl_duplicata,
C.DT_PREVISTA_RECEBIMENTO
order by 1
--)
/*group by 
prazo ,vl_duplicata*/
--dt_vencimento
