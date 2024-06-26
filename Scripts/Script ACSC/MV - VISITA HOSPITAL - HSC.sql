﻿SELECT T.*

FROM (

SELECT 'INTERNACAO' AS TP_CONTA,

ATENDIME.CD_MULTI_EMPRESA AS CD_MULTI_EMPRESA,

TRUNC(ITREG_FAT.DT_LANCAMENTO) AS DT_LANCAMENTO,

ITREG_FAT.CD_PRESTADOR AS CD_PRESTADOR,

PRESTADOR.NM_PRESTADOR AS NM_PRESTADOR,

ITREG_FAT.CD_PRO_FAT AS CD_PRO_FAT,

PRO_FAT.DS_PRO_FAT AS DS_PRO_FAT,

SUM(ITREG_FAT.QT_LANCAMENTO) AS QT_LANCAMENTO,

to_char(ROUND(AVG(ITREG_FAT.VL_UNITARIO),2), '9999999999D99')   AS VL_UNITARIO_MEDIO,

to_char(SUM(ITREG_FAT.QT_LANCAMENTO * ITREG_FAT.VL_UNITARIO), '9999999999D99')   AS VL_TOTAL

FROM DBAMV.REG_FAT REG_FAT

INNER JOIN DBAMV.ITREG_FAT ITREG_FAT ON REG_FAT.CD_REG_FAT = ITREG_FAT.CD_REG_FAT

INNER JOIN DBAMV.ATENDIME ATENDIME ON ATENDIME.CD_ATENDIMENTO = REG_FAT.CD_ATENDIMENTO

INNER JOIN DBAMV.CONVENIO CONVENIO ON REG_FAT.CD_CONVENIO = CONVENIO.CD_CONVENIO

INNER JOIN DBAMV.PRESTADOR PRESTADOR ON ITREG_FAT.CD_PRESTADOR = PRESTADOR.CD_PRESTADOR

INNER JOIN DBAMV.PRO_FAT PRO_FAT ON ITREG_FAT.CD_PRO_FAT = PRO_FAT.CD_PRO_FAT

WHERE NVL(ITREG_FAT.TP_PAGAMENTO,'K') <> ('C')

AND ATENDIME.CD_MULTI_EMPRESA IN (7)

AND ITREG_FAT.CD_PRO_FAT IN ('10102019')

AND EXTRACT( YEAR FROM ITREG_FAT.DT_LANCAMENTO) IN (2022,2023)

AND TRUNC(ITREG_FAT.DT_LANCAMENTO,'MONTH') BETWEEN TO_DATE('01/01/2022','DD/MM/RRRR') AND TO_DATE('30/06/2023','DD/MM/RRRR')

 

GROUP BY

ATENDIME.CD_MULTI_EMPRESA ,

TRUNC(ITREG_FAT.DT_LANCAMENTO) ,

ITREG_FAT.CD_PRESTADOR ,

PRESTADOR.NM_PRESTADOR ,

ITREG_FAT.CD_PRO_FAT ,

PRO_FAT.DS_PRO_FAT

 

 

UNION ALL

 

 

SELECT 'AMBULATORIAL' AS TP_CONTA,

ATENDIME.CD_MULTI_EMPRESA AS CD_MULTI_EMPRESA,

TRUNC(ITREG_AMB.HR_LANCAMENTO) AS DT_LANCAMENTO,

ITREG_AMB.CD_PRESTADOR AS CD_PRESTADOR,

PRESTADOR.NM_PRESTADOR AS NM_PRESTADOR,

ITREG_AMB.CD_PRO_FAT AS CD_PRO_FAT,

PRO_FAT.DS_PRO_FAT AS DS_PRO_FAT,

SUM(ITREG_AMB.QT_LANCAMENTO) AS QT_LANCAMENTO,

to_char (ROUND(AVG(ITREG_AMB.VL_UNITARIO),2), '9999999999D99')   AS VL_UNITARIO_MEDIO,

to_char (SUM(ITREG_AMB.QT_LANCAMENTO * ITREG_AMB.VL_UNITARIO), '9999999999D99')   AS VL_TOTAL

 

FROM DBAMV.REG_AMB REG_AMB

INNER JOIN DBAMV.ITREG_AMB ITREG_AMB ON REG_AMB.CD_REG_AMB = ITREG_AMB.CD_REG_AMB

INNER JOIN DBAMV.ATENDIME ATENDIME ON ATENDIME.CD_ATENDIMENTO = ITREG_AMB.CD_ATENDIMENTO

INNER JOIN DBAMV.CONVENIO CONVENIO ON REG_AMB.CD_CONVENIO = CONVENIO.CD_CONVENIO

INNER JOIN DBAMV.PRESTADOR PRESTADOR ON ITREG_AMB.CD_PRESTADOR = PRESTADOR.CD_PRESTADOR

INNER JOIN DBAMV.PRO_FAT PRO_FAT ON ITREG_AMB.CD_PRO_FAT = PRO_FAT.CD_PRO_FAT

WHERE NVL(ITREG_AMB.TP_PAGAMENTO,'K') <> ('C')

AND ATENDIME.CD_MULTI_EMPRESA IN (7)

AND ITREG_AMB.CD_PRO_FAT IN ('10102019')

AND EXTRACT( YEAR FROM ITREG_AMB.HR_LANCAMENTO) IN (2022,2023)

AND TRUNC(ITREG_AMB.HR_LANCAMENTO,'MONTH') BETWEEN TO_DATE('01/01/2022','DD/MM/RRRR') AND TO_DATE('30/06/2023','DD/MM/RRRR')

 

 

 

GROUP BY

ATENDIME.CD_MULTI_EMPRESA ,

TRUNC(ITREG_AMB.HR_LANCAMENTO) ,

ITREG_AMB.CD_PRESTADOR ,

PRESTADOR.NM_PRESTADOR ,

ITREG_AMB.CD_PRO_FAT ,

PRO_FAT.DS_PRO_FAT

) T

ORDER BY 1,2,3
