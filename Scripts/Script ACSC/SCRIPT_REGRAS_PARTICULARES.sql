SELECT
CONV.CD_CONVENIO||' - '||CONV.NM_CONVENIO CONVENIO,
CPLA.CD_CON_PLA||' - '||CPLA.DS_CON_PLA PLANO,
RG.CD_REGRA,
RG.DS_REGRA ,
IRG.CD_TAB_FAT,
TF.DS_TAB_FAT,
IRG.CD_GRU_PRO,
GP.DS_GRU_PRO,
GP.CD_GRU_FAT,
GF.DS_GRU_FAT,
IRG.VL_PERCETUAL_PAGO

FROM 
REGRA RG
INNER JOIN ITREGRA IRG ON IRG.CD_REGRA = RG.CD_REGRA
INNER JOIN TAB_FAT TF ON TF.CD_TAB_FAT = IRG.CD_TAB_FAT
INNER JOIN GRU_PRO GP ON GP.CD_GRU_PRO = IRG.CD_GRU_PRO
INNER JOIN GRU_FAT GF ON GF.CD_GRU_FAT = GP.CD_GRU_FAT
INNER JOIN CON_PLA CPLA ON CPLA.CD_REGRA = IRG.CD_REGRA
INNER JOIN CONVENIO CONV ON CONV.CD_CONVENIO = CPLA.CD_CONVENIO
WHERE RG.DS_REGRA LIKE '%HSC%PARTICULAR%'
--AND RG.CD_REGRA = 35
AND CONV.TP_CONVENIO = 'P'
--AND CONV.CD_CONVENIO = 40
ORDER BY CONV.CD_CONVENIO,CPLA.CD_CON_PLA,RG.CD_REGRA,IRG.CD_GRU_PRO