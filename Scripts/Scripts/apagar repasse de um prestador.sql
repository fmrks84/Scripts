delete from dbamv.it_repasse ap , dbamv.reg_Fat pa  
where pa.cd_reg_fat = 1290202---pa.cd_remessa in (92725,92726,92727)--N  (73242,73241,73240,78254,77794,78623,78622,78621,78623,78622,78256,78621,80584,77795,77796,80585)
and ap.cd_reg_fat = pa.cd_reg_fat 
order by 2

select * from dbamv.it_repasse a
inner join dbamv.reg_fat b on a.cd_reg_fat = b.cd_reg_fat
and b.cd_reg_fat = 1290202

delete from dbamv.it_repasse c where c.cd_it_repasse in (7207101,
7205092,
7205091,
7207102)
and c.cd_prestador in (7888,450)
