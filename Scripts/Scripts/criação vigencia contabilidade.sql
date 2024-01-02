select * from dbamv.ano_fech_cont a where a.CD_MULTI_EMPRESA = 4
order by 2
for update 
;

select * from dbamv.mes_ano_fech_cont b where b.cd_multi_empresa = 4
and b.dt_ano = '01/01/2005'
--and b.dt_mes = '1'
order by 1,4
for update 
