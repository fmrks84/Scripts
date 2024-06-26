DELETE
FROM PROIBICAO X 
WHERE X.CD_PRO_FAT IN (
SELECT 
PF.CD_PRO_FAT
FROM
GRU_PRO GP 
INNER JOIN PRO_FAT PF ON PF.CD_GRU_PRO = GP.CD_GRU_PRO
INNER JOIN PROIBICAO PB ON PB.CD_PRO_FAT = PF.CD_PRO_FAT
WHERE GP.TP_GRU_PRO IN ('MT')
AND PB.CD_CONVENIO = 304 
AND PB.CD_MULTI_EMPRESA = 11)
AND X.CD_CONVENIO = 304
AND X.CD_MULTI_EMPRESA = 11;
COMMIT;
