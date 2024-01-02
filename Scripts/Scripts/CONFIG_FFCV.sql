SELECT F.cd_multi_empresa, F.cd_convenio_fat_extra, C.nm_convenio, F.cd_con_pla_fat_extra, P.ds_con_pla, F.cd_convenio_rep_dif, F.* 
FROM   DBAMV.CONFIG_FFCV F, DBAMV.CONVENIO C, DBAMV.CON_PLA P
WHERE  F.cd_convenio_fat_extra =  C.cd_convenio
AND    F.cd_con_pla_fat_extra  =  P.cd_con_pla
AND    P.cd_convenio           =  C.cd_convenio
ORDER BY f.CD_MULTI_EMPRESA



SELECT cd_convenio_fat_extra, cd_con_pla_fat_extra, cd_multi_empresa FROM DBAMV.CONFIG_FFCV Order by cd_multi_empresa for update
select * from dbamv.
