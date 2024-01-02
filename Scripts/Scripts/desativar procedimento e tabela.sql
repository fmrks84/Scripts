Select * From Dbamv.Val_Pro
Where Cd_Tab_Fat in (269,392)--(333,382,425,240,367,241,224,227,207,211,407,243,257,208,359,202,399,218,221,264,217,334,342,388,259,265,254,348,383,245,222,223,212)---372,373,374)
and cd_pro_Fat IN (00017053) 
and SN_ATIVO = 'S'
for update;

---------

/*update Dbamv.Val_Pro 
set SN_ATIVO = 'N'
Where SN_ATIVO = 'S'
AND Cd_Tab_Fat in (392,269)--(333,382,425,240,367,241,224,227,207,211,407,243,257,208,359,202,399,218,221,264,217,334,342,388,259,265,254,348,383,245,222,223,212)---372,373,374)
and cd_pro_Fat IN (00017121,00017122) */




select * from dbamv.tab_fat t where t.cd_tab_fat in (299,372,373,374)
--And  Cd_Pro_Fat In (00017004,00017005) for update--,00015016,03010044) for update


select itregra.cd_gru_pro , 
       gru_pro.ds_gru_pro,
       itregra.cd_tab_fat, 
       tab_fat.ds_tab_fat
       from dbamv.itregra,
            dbamv.gru_pro ,
            dbamv.tab_fat
where itregra.cd_regra = 84
and itregra.cd_gru_pro = gru_pro.cd_gru_pro
and itregra.cd_tab_fat = tab_fat.cd_tab_fat
order by 1


select * from dbamv.
