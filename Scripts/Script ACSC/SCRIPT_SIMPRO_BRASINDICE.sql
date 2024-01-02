select 
a.cd_tab_fat,
b.ds_tab_fat,
c.cd_gru_pro,
a.cd_pro_fat,
trunc(a.dt_vigencia)dt_vigencia,
a.vl_honorario,
a.vl_operacional,
a.vl_total
from val_pro a
inner join tab_Fat b on b.cd_tab_fat = a.cd_tab_fat
inner join pro_fat c on c.cd_pro_fat = a.cd_pro_fat
where a.cd_tab_fat in (2)
and c.cd_gru_pro IN (8,89,95,96) 
and a.dt_vigencia <= '07/11/2022' 
order by a.cd_pro_fat, a.dt_vigencia ;

select 
a.cd_tab_fat,
b.ds_tab_fat,
c.cd_gru_pro,
a.cd_pro_fat,
trunc(a.dt_vigencia)dt_vigencia,
a.vl_honorario,
a.vl_operacional,
a.vl_total
from val_pro a
inner join tab_Fat b on b.cd_tab_fat = a.cd_tab_fat
inner join pro_fat c on c.cd_pro_fat = a.cd_pro_fat
where a.cd_tab_fat in (1,181)
and c.cd_gru_pro IN (7, 12, 13, 15, 43, 44, 55, 91, 92 ,94)
and a.dt_vigencia <= '21/10/2022'
order by a.cd_tab_fat, a.cd_pro_fat ,a.dt_vigencia;




--select * from tab_fat x where x.cd_tab_fat in (525 ,526 ,581)
