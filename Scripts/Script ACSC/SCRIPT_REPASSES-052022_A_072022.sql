SELECT 
*
FROM
(
SELECT 
IRP.CD_PRESTADOR_REPASSE,
IRAMB.CD_PRESTADOR,
PREST.NM_PRESTADOR,
RP.CD_REPASSE,
RP.DS_REPASSE,
RP.DT_REPASSE,
TO_CHAR(RP.DT_COMPETENCIA,'MM/RRRR')COMP_REPASSE,
TO_CHAR(RP.DT_COMPETENCIA,'MM')MES_REPASSE,
TO_CHAR(RP.DT_COMPETENCIA,'RRRR')ANO_REPASSE,
CASE WHEN IRP.CD_REG_AMB IS NOT NULL THEN 'CNV_AMB' ELSE 'CNV_INT' END TIPO,
AMD.DS_ATI_MED,
ATEND.CD_CONVENIO,
CONV.NM_CONVENIO,
CPLA.DS_CON_PLA,
RAMB.DT_LANCAMENTO,
IRAMB.HR_LANCAMENTO,
IRAMB.CD_ATENDIMENTO,
RAMB.CD_REMESSA,
PCT.NM_PACIENTE,
IRAMB.QT_LANCAMENTO,
IRAMB.CD_PRO_FAT,
PF.DS_PRO_FAT,
PF.CD_GRU_PRO,
GP.DS_GRU_PRO,
ATEND.TP_ATENDIMENTO,
IRAMB.VL_UNITARIO,
NVL(IRAMB.VL_BASE_REPASSADO,0)VL_BASE_REPASSE,
NVL(IRP.VL_PERC_REPASSE,0)VL_PERC_REPASSE,
NVL(IRP.VL_REPASSE,0)VL_REPASSE,
IRAMB.SN_PERTENCE_PACOTE,
ATEND.DT_ATENDIMENTO,
IRAMB.CD_LANCAMENTO,
IRAMB.CD_GRU_FAT,
IRAMB.CD_SETOR_PRODUZIU,
ST.NM_SETOR,
REGREP.CD_REG_REPASSE,
REGREP.DS_REG_REPASSE,
DECODE (RP.TP_REPASSE,'C','Convenio','M','Manual','R','Recurso')tp_repasse,
IRAMB.CD_REG_AMB CONTA


FROM REPASSE RP 
INNER JOIN IT_REPASSE IRP ON IRP.CD_REPASSE = RP.CD_REPASSE
INNER JOIN REPASSE_PRESTADOR RPRES ON RPRES.CD_REPASSE = IRP.CD_REPASSE AND RPRES.CD_PRESTADOR = IRP.CD_PRESTADOR
INNER JOIN ITREG_AMB IRAMB ON IRAMB.CD_REG_AMB = IRP.CD_REG_AMB AND IRAMB.CD_LANCAMENTO = IRP.CD_LANCAMENTO_AMB
INNER JOIN REG_AMB RAMB ON RAMB.CD_REG_AMB = IRAMB.CD_REG_AMB
INNER JOIN PRO_FAT PF ON PF.CD_PRO_FAT = IRAMB.CD_PRO_FAT
INNER JOIN ATENDIME ATEND ON ATEND.CD_ATENDIMENTO = IRAMB.CD_ATENDIMENTO
INNER JOIN PRESTADOR PREST ON PREST.CD_PRESTADOR = IRAMB.CD_PRESTADOR
INNER JOIN ATI_MED AMD ON AMD.CD_ATI_MED = IRP.CD_ATI_MED
INNER JOIN CONVENIO CONV ON CONV.CD_CONVENIO = ATEND.CD_CONVENIO
INNER JOIN CON_PLA CPLA ON CPLA.CD_CON_PLA = ATEND.CD_CON_PLA AND CPLA.CD_CONVENIO = IRAMB.CD_CONVENIO
INNER JOIN PACIENTE PCT ON PCT.CD_PACIENTE = ATEND.CD_PACIENTE
INNER JOIN GRU_PRO GP ON GP.CD_GRU_PRO = PF.CD_GRU_PRO
INNER JOIN SETOR ST ON ST.CD_SETOR = IRAMB.Cd_Setor_Produziu
INNER JOIN EMPRESA_PRESTADOR EMPREST ON EMPREST.CD_PRESTADOR = IRAMB.CD_PRESTADOR
INNER JOIN REG_REPASSE REGREP ON REGREP.CD_REG_REPASSE = EMPREST.CD_REG_REPASSE
WHERE TO_CHAR(RP.DT_COMPETENCIA,'MM/RRRR') BETWEEN '05/2022'AND '07/2022'
AND IRP.CD_PRESTADOR_REPASSE = 3040

UNION ALL 

SELECT 
IRP1.CD_PRESTADOR_REPASSE,
IRP1.CD_PRESTADOR,
PREST.NM_PRESTADOR,
RP1.CD_REPASSE,
RP1.DS_REPASSE,
RP1.DT_REPASSE,
TO_CHAR(RP1.DT_COMPETENCIA,'MM/RRRR')COMP_REPASSE,
TO_CHAR(RP1.DT_COMPETENCIA,'MM')MES_REPASSE,
TO_CHAR(RP1.DT_COMPETENCIA,'RRRR')ANO_REPASSE,
CASE WHEN IRP1.CD_REG_FAT IS NOT NULL THEN 'CNV_INT' ELSE 'CNV_AMB' END TIPO,
AMD.DS_ATI_MED,
ATEND.CD_CONVENIO,
CONV.NM_CONVENIO,
CPLA.DS_CON_PLA,
IRFAT.DT_LANCAMENTO,
IRFAT.HR_LANCAMENTO,
RFAT.CD_ATENDIMENTO,
RFAT.CD_REMESSA,
PCT.NM_PACIENTE,
IRFAT.QT_LANCAMENTO,
IRFAT.CD_PRO_FAT,
PF.DS_PRO_FAT,
PF.CD_GRU_PRO,
GP.DS_GRU_PRO,
ATEND.TP_ATENDIMENTO,
IRFAT.VL_UNITARIO,
NVL(IRFAT.VL_UNITARIO,0)VL_BASE_REPASSADO,
--IRFAT.VL_BASE_REPASSADO,
NVL(IRP1.VL_PERC_REPASSE,0)VL_PERC_REPASSE,
NVL(IRP1.VL_REPASSE,0)VL_REPASSE,
IRFAT.SN_PERTENCE_PACOTE,
ATEND.DT_ATENDIMENTO,
IRFAT.CD_LANCAMENTO,
IRFAT.CD_GRU_FAT,
IRFAT.CD_SETOR_PRODUZIU,
ST.NM_SETOR,
REGREP.CD_REG_REPASSE,
REGREP.DS_REG_REPASSE,
DECODE (RP1.TP_REPASSE,'C','Convenio','M','Manual','R','Recurso')tp_repasse,
IRFAT.CD_REG_FAT CONTA
FROM
REPASSE RP1 
INNER JOIN IT_REPASSE IRP1 ON IRP1.CD_REPASSE = RP1.CD_REPASSE
INNER JOIN REPASSE_PRESTADOR RPRES1 ON RPRES1.CD_REPASSE = IRP1.CD_REPASSE AND RPRES1.CD_PRESTADOR = IRP1.CD_PRESTADOR
INNER JOIN ITREG_FAT IRFAT ON IRFAT.CD_REG_FAT = IRP1.CD_REG_FAT AND IRFAT.CD_LANCAMENTO = IRP1.CD_LANCAMENTO_FAT
INNER JOIN REG_FAT RFAT ON IRFAT.CD_REG_FAT = RFAT.CD_REG_FAT
INNER JOIN PRO_FAT PF ON PF.CD_PRO_FAT = IRFAT.CD_PRO_FAT
INNER JOIN ATENDIME ATEND ON ATEND.CD_ATENDIMENTO = RFAT.CD_ATENDIMENTO
LEFT JOIN PRESTADOR PREST ON PREST.CD_PRESTADOR = IRP1.CD_PRESTADOR
INNER JOIN ATI_MED AMD ON AMD.CD_ATI_MED = IRP1.CD_ATI_MED
INNER JOIN CONVENIO CONV ON CONV.CD_CONVENIO = ATEND.CD_CONVENIO
INNER JOIN CON_PLA CPLA ON CPLA.CD_CON_PLA = ATEND.CD_CON_PLA AND CPLA.CD_CONVENIO = RFAT.CD_CONVENIO
INNER JOIN PACIENTE PCT ON PCT.CD_PACIENTE = ATEND.CD_PACIENTE
INNER JOIN GRU_PRO GP ON GP.CD_GRU_PRO = PF.CD_GRU_PRO
INNER JOIN SETOR ST ON ST.CD_SETOR = IRFAT.Cd_Setor_Produziu
LEFT JOIN EMPRESA_PRESTADOR EMPREST ON EMPREST.CD_PRESTADOR = RPRES1.CD_PRESTADOR
LEFT JOIN REG_REPASSE REGREP ON REGREP.CD_REG_REPASSE = EMPREST.CD_REG_REPASSE
WHERE TO_CHAR(RP1.DT_COMPETENCIA,'MM/RRRR') BETWEEN '05/2022'AND '07/2022'
AND IRP1.CD_PRESTADOR_REPASSE = 3040
/*AND IRFAT.CD_PRO_FAT = 40202615
AND RFAT.CD_ATENDIMENTO = 3328919*/
)
/*WHERE CD_PRO_FAT = 40202615
AND CONTA = 394903*/
ORDER BY COMP_REPASSE


/*
--SELECT * FROM REPASSE WHERE CD_REPASSE = 14633

--SELECT * FROM VAL_PRO WHERE CD_TAB_FAT = 2406 AND CD_PRO_FAT = 40202615
;
SELECT * FROM ITLAN_MED WHERE CD_REG_FAT = 394903*/