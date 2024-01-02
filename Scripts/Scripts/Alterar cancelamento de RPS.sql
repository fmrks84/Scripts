select * from dbamv.itfat_nota_fiscal d where d.cd_nota_fiscal = 262093
select * from dbamv.nota_fiscal a where a.cd_nota_fiscal in (262093,262095)for update --110960,110962
select * from dbamv.con_Rec b where b.cd_con_rec in (436012,436010)for update 
select * from dbamv.itcon_rec c where c.cd_con_rec in (436012,436010)for update 
