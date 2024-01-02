--select A.CD_GRU_FAT, A.CD_PRO_FAT,A.CD_GUIA, A.HR_LANCAMENTO, A.QT_LANCAMENTO ,A.VL_PERCENTUAL_MULTIPLA,A.CD 

SELECT A.CD_GRU_FAT, A.CD_PRO_FAT,A.CD_GUIA, A.DT_LANCAMENTO,A.HR_LANCAMENTO,A.QT_LANCAMENTO,
A.VL_PERCENTUAL_MULTIPLA,A.CD_SETOR, A.CD_SETOR_PRODUZIU, A.CD_PRESTADOR  from dbamv.itreg_Fat a where a.cd_reg_fat = 1240287
and a.sn_pertence_pacote = 'N'
--AND A.CD_PRO_FAT = 51010194

select * from dbamv.itlan_med b where b.cd_reg_fat in (1240287,1240371)

select  c.cd_ati_med from dbamv.itreg_Fat c where c.cd_reg_fat = 1291816
and c.cd_prestador = 1344 for update 
