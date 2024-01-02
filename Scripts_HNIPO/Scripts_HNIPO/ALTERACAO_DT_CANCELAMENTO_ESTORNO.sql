select * from mov_caixa t 
where t.cd_lote_caixa = 62006  
and trunc(t.dt_movimentacao) between '25/03/2022' and '25/03/2022'
for update --order by 4 desc --for update 



/*update reccon_rec a set a.dt_estorno = '07/03/2022'
where a.cd_reccon_rec in (1516489,
1516490,
1516491,
1516492,
1516493,
1516494,
1516495,
1516496,
1516497,
1516498,
1516499,
1516500,
1516501,
1516502,
1517156)

select * from reccon_rec a where a.cd_reccon_rec in (1516489,
1516490,
1516491,
1516492,
1516493,
1516494,
1516495,
1516496,
1516497,
1516498,
1516499,
1516500,
1516501,
1516502,
1517156)
;
*/

/*select * from itcon_rec b where b.cd_itcon_rec in (
1211111,
1211111,
1211111,
1211116,
1211116,
1211116,
1211116,
1206848,
1206848,
1206848,
1206848,
1206866,
1206866,
1206866,
1211297)

update 
itcon_rec b set b.dt_cancelamento = '07/03/2022'
where b.cd_itcon_rec in (
1211111,
1211111,
1211111,
1211116,
1211116,
1211116,
1211116,
1206848,
1206848,
1206848,
1206848,
1206866,
1206866,
1206866,
1211297)
;*/


/*
update con_rec c set c.dt_cancelamento = '07/03/2022'
where c.cd_con_rec in (1203729,
1203747,
1207997,
1208002,
1208183
)

select * from con_rec c where c.cd_con_rec in (1203729,
1203747,
1207997,
1208002,
1208183)*/
