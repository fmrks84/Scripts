SELECT distinct 
       C.cd_convenio, C.nm_convenio, CP.cd_con_pla, CP.ds_con_pla 
     , CP.cd_regra, R.ds_regra, T.cd_tab_fat, T.ds_tab_fat
     , P.cd_pro_fat, P.ds_pro_fat 
     , V.dt_vigencia, V.vl_honorario, V.vl_operacional, V.vl_total
      

FROM  DBAMV.VAL_PRO V
    , DBAMV.PRO_FAT P
    , DBAMV.TAB_FAT T
    , DBAMV.CONVENIO C
    , DBAMV.ITREGRA I
    , DBAMV.CON_PLA CP
    , DBAMV.REGRA    R

WHERE V.CD_PRO_FAT   =  P.CD_PRO_FAT
AND   V.CD_TAB_FAT   =  T.CD_TAB_FAT
AND   V.CD_TAB_FAT   =  I.CD_TAB_FAT
AND   I.CD_REGRA     =  R.CD_REGRA
AND   I.CD_REGRA     =  CP.CD_REGRA
AND   I.CD_GRU_PRO   =  P.CD_GRU_PRO
AND   CP.CD_CONVENIO =  C.CD_CONVENIO
AND   P.SN_ATIVO     =  'S'
AND   C.SN_ATIVO     =  'S'
AND   CP.SN_ATIVO    =  'S'

ORDER BY C.CD_CONVENIO


----TABELAS QUE SERÃO ENVOLVIDAS----------------
--SELECT * FROM DBAMV.ITREGRA
--SELECT * FROM DBAMV.REGRA
--SELECT * FROM DBAMV.VAL_PRO
--SELECT * FROM DBAMV.PRO_FAT
--SELECT * FROM DBAMV.TAB_FAT
--SELECT * FROM DBAMV.CON_PLA
--SELECT * FROM DBAMV.CONVENIO
-------------------------------------------------
