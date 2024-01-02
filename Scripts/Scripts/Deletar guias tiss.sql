DELETE
from dbamv.tiss_nr_guia
where cd_reg_fat in (
select cd_reg_fat from dbamv.reg_fat
where nvl (cd_conta_pai, cd_reg_fat) IN (789668,792979,801906,804330,805099))

--SELECT CD_CONTA_PAI FROM DBAMV.REG_FAT WHERE CD_REG_FAT = 311983


SELECT * FROM DBAMV.ITREG_FAT WHERE CD_REG_FAT IN (SELECT CD_REG_FAT FROM REG_FAT WHERE CD_ATENDIMENTO IN (347051))
AND CD_GRU_FAT = 7

select d.cd_atendimento , d.cd_reg_fat ,d.cd_conta_pai, d.cd_multi_empresa from dbamv.reg_fat d where d.cd_remessa in (96380,96382)
select * from dbamv.
delete from dbamv.tiss_nr_guia where tiss_nr_guia.cd_atendimento in (1494852
,1497755
,1499304
,1492506
,1506863
,1504497
,1506390
,1505186
,1504129
,1504631
,1500419
,1506769
,1510327
,1502649
,1494852
,1497755
,1492506
,1500419
,1505186
,1504129
,1502649
,1504497
,1506769
,1506390
,1506863
,1504631
,1499304
,1510327
)

