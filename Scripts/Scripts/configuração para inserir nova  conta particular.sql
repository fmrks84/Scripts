select n.cd_convenio_fat_extra, n.cd_con_pla_fat_extra , n.cd_multi_empresa from dbamv.config_ffcv  n where cd_multi_empresa in (1,2) for update
