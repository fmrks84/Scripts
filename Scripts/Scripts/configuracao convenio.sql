select cd_multi_empresa, cd_convenio_fat_extra, cd_con_pla_fat_extra, nm_convenio, ds_con_pla
from dbamv.config_ffcv cf, dbamv.convenio c, dbamv.con_pla p
where c.cd_convenio = cf.cd_convenio_fat_extra
and   cf.cd_convenio_fat_extra = p.cd_convenio
order by 1


--select cd_multi_empresa, cd_convenio_fat_extra, cd_con_pla_fat_extra from config_ffcv

--select * from convenio
--select * from con_pla
