
SELECT 
*
FROM
(
SELECT 
CONVENIO,
PROCED,
TOTAL,
QTD,
TICKET_MEDIO
FROM
(
SELECT 
CASE WHEN CD_CONVENIO = 5 THEN 'AMIL'
     WHEN CD_CONVENIO = 7 THEN 'BRADESCO SAUDE'
     WHEN CD_CONVENIO = 9 THEN 'SAUDE CAIXA'
     WHEN CD_CONVENIO = 12 THEN 'CASSI'
     WHEN CD_CONVENIO = 34 THEN 'NOTRE DAME'
     WHEN CD_CONVENIO = 41 THEN 'PORTO SEGURO SAUDE'
     WHEN CD_CONVENIO = 48 THEN 'SUL AMERICA SAUDE'
     END CONVENIO,
CD_PRO_FAT||' - '||DS_PRO_FAT PROCED,
SUM(VL_TOTAL_CONTA)TOTAL,
SUM(QT_LANCAMENTO)QTD,
ROUND((SUM(VL_TOTAL_CONTA) / SUM(QT_LANCAMENTO)),+2)TICKET_MEDIO
FROM
(
SELECT 
CASE WHEN RF.CD_CONVENIO IN (5,541) THEN 5 
     WHEN RF.CD_CONVENIO IN (7,641) THEN 7
     ELSE RF.CD_CONVENIO 
     END CD_CONVENIO,
RF.CD_ATENDIMENTO,
IRF.CD_PRO_FAT,
PFX.DS_PRO_FAT,
TO_DATE(IRF.HR_LANCAMENTO,'DD/MM/RRRR')DT_LANCAMENTO,
IRF.VL_TOTAL_CONTA,
IRF.QT_LANCAMENTO

FROM 
REG_FAT RF
INNER JOIN ITREG_FAT IRF ON IRF.CD_REG_FAT = RF.CD_REG_FAT
INNER JOIN PRO_FAT PFX ON PFX.CD_PRO_FAT = IRF.CD_PRO_FAT
WHERE RF.CD_CONVENIO IN (5,541,7,641,12,34,41,48,9)
AND TO_DATE(IRF.HR_LANCAMENTO,'DD/MM/RRRR') BETWEEN '01/01/2023' AND '31/05/2023'
AND IRF.CD_PRO_FAT IN('40201031', '40201058', '10000344', '10000345', '10000384', '40201082', 
'40202666', '40202704', '40201090', '40202135', '40202712', '10000278', 
'10000279', '10000346', '10000347', '10000348', '10000349', '10000383', 
'10000384', '10001519', '10001750', '10001751', '10001818', '10001825', 
'10002250', '40201147', '40201341', '40201104', '40201112', '40202240', 
'10000805', '40201120', '40202615', '40202038', '40201333', '10000276', 
'10000277', '10000333', '10000334', '10000335', '10000350', '10000351',
 '10000382', '10001518', '10001640', '10001683', '40202364', '40202410', 
 '40202437', '40202429', '40202399', '40202445', '40202488', '10002248',
  '10002249', '10000341', '10001827', '10001830', '40201171', '40202690',
   '40202682')
AND IRF.SN_PERTENCE_PACOTE = 'N'
AND RF.SN_FECHADA = 'S'
AND RF.CD_REMESSA IS NOT NULL

UNION ALL 

SELECT
CASE WHEN RAMB.CD_CONVENIO  IN (5,541) THEN 5 
     WHEN RAMB.CD_CONVENIO IN (7,641) THEN 7
     ELSE RAMB.CD_CONVENIO 
     END CD_CONVENIO,

IRAMB.CD_ATENDIMENTO,
IRAMB.CD_PRO_FAT,
PF.DS_PRO_FAT,
TO_DATE(IRAMB.HR_LANCAMENTO,'DD/MM/RRRR')DT_LANCAMENTO,
IRAMB.VL_TOTAL_CONTA,
IRAMB.QT_LANCAMENTO
FROM
REG_AMB RAMB 
INNER JOIN ITREG_AMB IRAMB ON IRAMB.CD_REG_AMB = RAMB.CD_REG_AMB
INNER JOIN PRO_FAT PF ON PF.CD_PRO_FAT = IRAMB.CD_PRO_FAT
WHERE RAMB.CD_CONVENIO IN (5,541,7,641,12,34,41,48,9)
AND TO_DATE(IRAMB.HR_LANCAMENTO,'DD/MM/RRRR') BETWEEN '01/01/2023' AND '31/05/2023'
AND IRAMB.CD_PRO_FAT IN ('40201031', '40201058', '10000344', '10000345', '10000384', '40201082', 
'40202666', '40202704', '40201090', '40202135', '40202712', '10000278', 
'10000279', '10000346', '10000347', '10000348', '10000349', '10000383', 
'10000384', '10001519', '10001750', '10001751', '10001818', '10001825', 
'10002250', '40201147', '40201341', '40201104', '40201112', '40202240', 
'10000805', '40201120', '40202615', '40202038', '40201333', '10000276', 
'10000277', '10000333', '10000334', '10000335', '10000350', '10000351',
 '10000382', '10001518', '10001640', '10001683', '40202364', '40202410', 
 '40202437', '40202429', '40202399', '40202445', '40202488', '10002248',
  '10002249', '10000341', '10001827', '10001830', '40201171', '40202690',
   '40202682')
AND IRAMB.SN_FECHADA = 'S'
AND IRAMB.SN_PERTENCE_PACOTE = 'N'
AND RAMB.CD_REMESSA IS NOT NULL
)
GROUP BY
CD_CONVENIO,
CD_PRO_FAT,
DS_PRO_FAT
ORDER BY CD_CONVENIO
))
PIVOT
(SUM(TOTAL)
 FOR (CONVENIO) IN ('AMIL' AS AMIL,
                    'BRADESCO SAUDE' AS BRADESCO ,
                    'SAUDE CAIXA' AS SAUDE_CAIXA,
                    'CASSI' AS CASSI,
                    'NOTRE DAME' AS NOTRE_DAME,
                    'PORTO SEGURO SAUDE' AS PORTO_SEGURO,
                    'SUL AMERICA SAUDE' AS SUL_AMERICA))
ORDER BY PROCED

/*;

SELECT 
CASE WHEN CD_CONVENIO = 5 THEN 'AMIL'
     WHEN CD_CONVENIO = 7 THEN 'BRADESCO SAUDE'
     WHEN CD_CONVENIO = 9 THEN 'SAUDE CAIXA'
     WHEN CD_CONVENIO = 12 THEN 'CASSI'
     WHEN CD_CONVENIO = 34 THEN 'NOTRE DAME'
     WHEN CD_CONVENIO = 41 THEN 'PORTO SEGURO SAUDE'
     WHEN CD_CONVENIO = 48 THEN 'SUL AMERICA SAUDE'
     END CONVENIO,
CD_PRO_FAT||' - '||DS_PRO_FAT PROCED,
SUM(VL_TOTAL_CONTA)TOTAL,
SUM(QT_LANCAMENTO)QTD,
ROUND((SUM(VL_TOTAL_CONTA) / SUM(QT_LANCAMENTO)),+2)TICKET_MEDIO
FROM
(
SELECT 
RF.CD_CONVENIO,
RF.CD_ATENDIMENTO,
IRF.CD_PRO_FAT,
PFX.DS_PRO_FAT,
TO_DATE(IRF.HR_LANCAMENTO,'DD/MM/RRRR')DT_LANCAMENTO,
IRF.VL_TOTAL_CONTA,
IRF.QT_LANCAMENTO

FROM 
REG_FAT RF
INNER JOIN ITREG_FAT IRF ON IRF.CD_REG_FAT = RF.CD_REG_FAT
INNER JOIN PRO_FAT PFX ON PFX.CD_PRO_FAT = IRF.CD_PRO_FAT
WHERE RF.CD_CONVENIO IN (5)--,7,12,34,41,48,9)
AND TO_DATE(IRF.HR_LANCAMENTO,'DD/MM/RRRR') BETWEEN '01/01/2023' AND '31/05/2023'
AND IRF.CD_PRO_FAT IN('40201031', '40201058', '10000344', '10000345', '10000384', '40201082', 
'40202666', '40202704', '40201090', '40202135', '40202712', '10000278', 
'10000279', '10000346', '10000347', '10000348', '10000349', '10000383', 
'10000384', '10001519', '10001750', '10001751', '10001818', '10001825', 
'10002250', '40201147', '40201341', '40201104', '40201112', '40202240', 
'10000805', '40201120', '40202615', '40202038', '40201333', '10000276', 
'10000277', '10000333', '10000334', '10000335', '10000350', '10000351',
 '10000382', '10001518', '10001640', '10001683', '40202364', '40202410', 
 '40202437', '40202429', '40202399', '40202445', '40202488', '10002248',
  '10002249', '10000341', '10001827', '10001830', '40201171', '40202690',
   '40202682')
AND IRF.SN_PERTENCE_PACOTE = 'N'
AND RF.SN_FECHADA = 'S'
AND RF.CD_REMESSA IS NOT NULL

UNION ALL 

SELECT
RAMB.CD_CONVENIO, 
IRAMB.CD_ATENDIMENTO,
IRAMB.CD_PRO_FAT,
PF.DS_PRO_FAT,
TO_DATE(IRAMB.HR_LANCAMENTO,'DD/MM/RRRR')DT_LANCAMENTO,
IRAMB.VL_TOTAL_CONTA,
IRAMB.QT_LANCAMENTO
FROM
REG_AMB RAMB 
INNER JOIN ITREG_AMB IRAMB ON IRAMB.CD_REG_AMB = RAMB.CD_REG_AMB
INNER JOIN PRO_FAT PF ON PF.CD_PRO_FAT = IRAMB.CD_PRO_FAT
WHERE RAMB.CD_CONVENIO IN (5)--,7,12,34,41,48,9)
AND TO_DATE(IRAMB.HR_LANCAMENTO,'DD/MM/RRRR') BETWEEN '01/01/2023' AND '31/05/2023'
AND IRAMB.CD_PRO_FAT IN ('40201031', '40201058', '10000344', '10000345', '10000384', '40201082', 
'40202666', '40202704', '40201090', '40202135', '40202712', '10000278', 
'10000279', '10000346', '10000347', '10000348', '10000349', '10000383', 
'10000384', '10001519', '10001750', '10001751', '10001818', '10001825', 
'10002250', '40201147', '40201341', '40201104', '40201112', '40202240', 
'10000805', '40201120', '40202615', '40202038', '40201333', '10000276', 
'10000277', '10000333', '10000334', '10000335', '10000350', '10000351',
 '10000382', '10001518', '10001640', '10001683', '40202364', '40202410', 
 '40202437', '40202429', '40202399', '40202445', '40202488', '10002248',
  '10002249', '10000341', '10001827', '10001830', '40201171', '40202690',
   '40202682')
AND IRAMB.SN_FECHADA = 'S'
AND IRAMB.SN_PERTENCE_PACOTE = 'N'
AND RAMB.CD_REMESSA IS NOT NULL
)
GROUP BY
CD_CONVENIO,
CD_PRO_FAT,
DS_PRO_FAT
ORDER BY CD_CONVENIO*/

/*SELECT CONV.CD_CONVENIO, CONV.NM_CONVENIO FROM CONVENIO CONV 
INNER JOIN EMPRESA_CONVENIO ECONV ON ECONV.CD_CONVENIO = CONV.CD_CONVENIO
WHERE ECONV.CD_MULTI_EMPRESA =7
ORDER BY CONV.NM_CONVENIO */


--SELECT * FROM CONVENIO WHERE NM_CONVENIO LIKE '%CAIXA%'