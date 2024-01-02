SELECT *
  FROM DBAMV.VAL_PRO
 WHERE cd_pro_fat in
       (select cd_pro_fat from dbamv.pro_fat where cd_sus is null)
   and CD_TAB_FAT = 279--280 p/448  279 p/449
 
 
 ----------------

update dbamv.val_pro  set cd_tab_fat = 280 -- nova
where cd_tab_fat = 448 -- atual 
-----

select * from dbamv.hmsj_acesso_wifi where cd_atendimento = 1278998
