select distinct b.nm_prestador , d.ds_pro_fat,c.cd_pro_fat, c.dt_lancamento , c.vl_unitario , a.vl_repasse from dbamv.it_repasse a
inner join dbamv.prestador b on b.cd_prestador = a.cd_prestador 
inner join dbamv.itreg_fat c on c.cd_reg_fat = a.cd_reg_fat
inner join dbamv.pro_fat d on d.cd_pro_fat = c.cd_pro_fat
where a.cd_reg_fat = 1342138
and c.dt_lancamento between '01/01/2017' and '05/01/2017'
and c.cd_pro_fat = 00105072
order by 4
