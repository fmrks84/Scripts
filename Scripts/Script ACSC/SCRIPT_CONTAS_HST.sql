SELECT 
*
FROM 
(
SELECT 
ATD.CD_ATENDIMENTO ATENDIMENTO,
ATD.DT_ATENDIMENTO,
PC.NM_PACIENTE,
ATD.CD_CONVENIO||' - '||(SELECT X.NM_CONVENIO FROM CONVENIO X WHERE X.CD_CONVENIO = ATD.CD_CONVENIO)CONVENIO_ATEND,
RF.CD_REG_FAT CONTA,
DECODE(ATD.TP_ATENDIMENTO,'I','INTERNADO')TIPO_ATEND,
RF.CD_CONVENIO||' - '||CONV.NM_CONVENIO CONVENIO_CONTA,
RF.VL_TOTAL_CONTA,
IRF.CD_PRO_FAT||' - '||PF.DS_PRO_FAT DESC_PROCED,
IRF.QT_LANCAMENTO,
IRF.VL_TOTAL_CONTA VL_TOTAL_PROCED
FROM 
ATENDIME ATD 
INNER JOIN REG_FAT RF ON RF.CD_ATENDIMENTO = ATD.CD_ATENDIMENTO
INNER JOIN CONVENIO CONV ON CONV.CD_CONVENIO = RF.CD_CONVENIO
INNER JOIN PACIENTE PC ON PC.CD_PACIENTE = ATD.CD_PACIENTE
INNER JOIN ITREG_FAT IRF ON IRF.CD_REG_FAT = RF.CD_REG_FAT 
INNER JOIN PRO_FAT PF ON PF.CD_PRO_FAT = IRF.CD_PRO_FAT
WHERE ATD.DT_ATENDIMENTO BETWEEN TO_DATE('01/02/2023','DD/MM/RRRR') AND TO_DATE('27/02/2023','DD/MM/RRRR') -- FILTRO
AND RF.SN_FECHADA = 'S'
AND CONV.TP_CONVENIO = 'P'
AND IRF.SN_PERTENCE_PACOTE = 'N'
AND ATD.CD_MULTI_EMPRESA = 4


UNION ALL 

SELECT 
ATDM.CD_ATENDIMENTO ATENDIMENTO,
ATDM.DT_ATENDIMENTO,
PC1.NM_PACIENTE,
ATDM.CD_CONVENIO||' - '||(SELECT XX.NM_CONVENIO FROM CONVENIO XX WHERE XX.CD_CONVENIO = ATDM.CD_CONVENIO )CONVENIO_ATEND,
RAMB.CD_REG_AMB CONTA,
DECODE(ATDM.TP_ATENDIMENTO,'E','EXTERNO','U','URGENCIA','A','AMBULATORIO')TIPO_ATEND,
RAMB.CD_CONVENIO||' - '||CONV1.NM_CONVENIO CONVENIO_CONTA,
RAMB.VL_TOTAL_CONTA,
IRAMB.CD_PRO_FAT||' - '||PF1.DS_PRO_FAT DESC_PROCED,
IRAMB.QT_LANCAMENTO,
IRAMB.VL_TOTAL_CONTA VL_TOTAL_PROCED
FROM 
ATENDIME ATDM
INNER JOIN ITREG_AMB IRAMB ON IRAMB.CD_ATENDIMENTO = ATDM.CD_ATENDIMENTO
INNER JOIN REG_AMB RAMB ON RAMB.CD_REG_AMB = IRAMB.CD_REG_AMB 
INNER JOIN CONVENIO CONV1 ON CONV1.CD_CONVENIO = RAMB.CD_CONVENIO
INNER JOIN PRO_FAT PF1 ON PF1.CD_PRO_FAT = IRAMB.CD_PRO_FAT
INNER JOIN PACIENTE PC1 ON PC1.CD_PACIENTE = ATDM.CD_PACIENTE 
WHERE ATDM.DT_ATENDIMENTO BETWEEN TO_DATE('01/02/2023','DD/MM/RRRR') AND TO_DATE('27/02/2023','DD/MM/RRRR') -- FILTRO
AND CONV1.TP_CONVENIO = 'P'
AND IRAMB.SN_PERTENCE_PACOTE = 'N'
AND IRAMB.SN_FECHADA = 'S'
AND ATDM.CD_MULTI_EMPRESA = 4

ORDER BY ATENDIMENTO
)--where atendimento = 4633568