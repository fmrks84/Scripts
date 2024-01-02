select 
dbamv.fc_acsc_tuss(pct.cd_multi_empresa,
                    pct.cd_pro_fat_pacote,
                    pct.cd_convenio,
                    'COD')
||' - '||dbamv.fc_acsc_tuss(pct.cd_multi_empresa,
                    pct.cd_pro_fat_pacote,
                    pct.cd_convenio,
                    'DESC')DS_TUSS_PACOTE,                    
pct.cd_pro_fat_pacote||' - '||pf.ds_pro_fat PRO_FAT_PACOTE,
dbamv.fc_acsc_tuss(pct.cd_multi_empresa,
                    pct.cd_pro_fat,
                    pct.cd_convenio,
                    'COD')
||' - '||dbamv.fc_acsc_tuss(pct.cd_multi_empresa,
                    pct.cd_pro_fat,
                    pct.cd_convenio,
                    'DESC')DS_TUSS_PRO_FAT,  
pct.cd_pro_fat||' - '||(select x.ds_pro_fat from pro_fat x where x.cd_pro_fat = pct.cd_pro_fat)PRO_FAT

from 
pacote pct 

inner join pro_fat pf on pf.cd_pro_fat = pct.cd_pro_fat_pacote
where pct.cd_convenio = 212
and pct.dt_vigencia_final is null

