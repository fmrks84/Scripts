--------------------------
------ BRASINDICE --------
--------------------------

select a.cd_tab_fat,
       a.cd_pro_fat,
       b.ds_pro_fat,
       a.cd_tiss CD_BRASINDICE,
       a.cd_tuss
from dbamv.imp_bra a ,
              dbamv.Pro_Fat b
 where a.cd_tab_fat = a.cd_tab_fat
and a.cd_pro_fat = b.cd_pro_fat
and a.cd_tab_fat = 1

----------------------
------ SIMPRO --------
----------------------
select c.cd_tab_fat,
       c.cd_pro_fat,
       d.ds_pro_fat,
       c.cd_simpro,
       c.cd_tuss
       
       
from dbamv.imp_simpro c,
              dbamv.pro_FAT d
where c.cd_tab_fat = c.cd_tab_fat
and c.cd_pro_fat = d.cd_pro_fat

             
