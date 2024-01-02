Select cd_tab_fat, dt_vigencia, sn_ativo From Dbamv.Val_Pro
Where Cd_Pro_Fat In '28140176' 
order by dt_vigencia desc for update;
