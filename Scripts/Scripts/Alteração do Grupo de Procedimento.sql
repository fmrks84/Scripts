SELECT * FROM TAB_FAT WHERE CD_TAB_FAT = 355

SELECT PRO_FAT.CD_PRO_FAT, PRO_FAT.DS_PRO_FAT, CD_TAB_FAT, VL_TOTAL, CD_GRU_PRO FROM VAL_PRO, PRO_FAT
WHERE CD_TAB_FAT = 355
AND VAL_PRO.CD_PRO_FAT = PRO_FAT.CD_PRO_FAT
AND CD_GRU_PRO = 62

UPDATE DBAMV.PRO_FAT SET CD_GRU_PRO = 62 WHERE CD_GRU_PRO <> 62 AND CD_PRO_FAT IN (SELECT PRO_FAT.CD_PRO_FAT FROM VAL_PRO, PRO_FAT
                                                                WHERE CD_TAB_FAT = 355
                                                                AND   VAL_PRO.CD_PRO_FAT = PRO_FAT.CD_PRO_FAT
                                                                AND   CD_GRU_PRO <> 62)
