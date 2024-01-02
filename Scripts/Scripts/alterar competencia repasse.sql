SELECT ROWID,
       DT_COMPETENCIA,
       CD_REPASSE,
       DT_REPASSE,
       DS_REPASSE,
       NM_USUARIO,
       CD_CONVENIO,
       CD_PRESTADOR,
       CD_REMESSA,
       TP_REMESSA,
       DT_COMPETENCIA_FAT,
       DT_LIMITE,
       CD_GRU_FAT,
       CD_GRU_PRO,
       CD_ESPECIALID,
       CD_FAT_SIA,
       DT_INICIAL_RECEB,
       DT_FINAL_RECEB,
       DT_COMPET_CUSTOS
  FROM dbamv.log_repasse
 WHERE cd_multi_empresa = 1
   and cd_repasse = 24214-- (24214)
 order by cd_repasse desc
 for update 

select * from dbamv.repasse a where a.cd_repasse = 24214
