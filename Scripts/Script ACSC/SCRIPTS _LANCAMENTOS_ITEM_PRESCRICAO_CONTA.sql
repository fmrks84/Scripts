WITH TPRES AS (
SELECT PM.CD_PRE_MED,
       IPM.CD_ITPRE_MED,
       IPM.CD_TIP_PRESC,
       (SELECT TIP_PRESC.DS_TIP_PRESC FROM TIP_PRESC WHERE TIP_PRESC.CD_TIP_PRESC = IPM.CD_TIP_PRESC)DS_TIP_PRESC,
       IPM.QT_ITPRE_MED,
       IPM.CD_TIP_FRE,
       FREQ.DS_TIP_FRE,
       PM.CD_ATENDIMENTO
       
FROM PRE_MED PM
INNER JOIN ITPRE_MED IPM ON IPM.CD_PRE_MED = PM.CD_PRE_MED
INNER JOIN TIP_FRE FREQ ON FREQ.CD_TIP_FRE = IPM.CD_TIP_FRE
WHERE PM.CD_ATENDIMENTO = 5032720 -- COLOCAR ATENDIMENTO
AND IPM.CD_TIP_PRESC IN (SELECT CD_TIP_PRESC FROM TIP_PRESC WHERE CD_PRO_FAT = 10102019) -- INSERIR O PROCEDIMENTO DO ITEM PRESC
--AND IPM.CD_PRE_MED IN (13684040)
)


SELECT 
RF.CD_ATENDIMENTO,
IRF.CD_REG_FAT,
IRF.CD_LANCAMENTO,
IRF.CD_PRO_FAT,
IRF.CD_MVTO,
IRF.CD_ITMVTO,
IRF.TP_MVTO,
IRF.QT_LANCAMENTO,
TPRS.CD_PRE_MED,
TPRS.CD_TIP_PRESC,
TPRS.DS_TIP_FRE,
TPRS.DS_TIP_PRESC
FROM 
ITREG_FAT IRF 
INNER JOIN REG_FAT RF ON RF.CD_REG_FAT = IRF.CD_REG_FAT
INNER JOIN TPRES TPRS ON TPRS.CD_ATENDIMENTO = RF.CD_ATENDIMENTO
AND TPRS.CD_ITPRE_MED = IRF.CD_ITMVTO
WHERE RF.CD_REG_FAT = 556204
--AND IRF.CD_LANCAMENTO IN (63,64)
AND CD_GRU_FAT = 7
ORDER BY TPRS.CD_PRE_MED
;


SELECT * FROM ITREG_fAT WHERE CD_rEG_fAT =  556204 AND CD_MVTO = 13684040
;

SELECT * FROM ITPRE_MED WHERE CD_PRE_MED = 13684040 AND CD_ITPRE_MED IN (94429516,94429597);
SELECT * FROM HRITPRE_MED XP WHERE XP.CD_ITPRE_MED IN (SELECT CD_ITPRE_MED FROM ITPRE_MED WHERE CD_PRE_MED = 13684040 AND CD_ITPRE_MED IN (94429516,94429597))

