SELECT 
*
FROM
(
-- TAXAS --
SELECT 
A.SN_ATIVO PRO_FAT_ATIVO_SN,
A.DS_PRO_FAT DS_PRO_FAT,
A.CD_GRU_PRO CD_GRU_PRO,
B.DS_GRU_PRO DS_GRU_PRO,
nvl(C.CD_TIP_PRESC,0) CD_TIP_PRESC,
nvl(A.CD_PRO_FAT,0) PRO_FAT_TAB_PROCEDIMENTOS,
nvl(PCT.CD_PRO_FAT_PACOTE,0)PRO_FAT_PACOTE,
nvl(C.CD_PRO_FAT,0) PRO_FAT_ITEM_PRESCR,
TO_NUMBER(NVL('',0),'9999')EXA_LAB_ITEM_PRESCR,
TO_NUMBER(NVL('',0),9999)EXA_LAB_LABORATORIO,
TO_NUMBER(NVL('',0),9999)EXA_RX_ITEM_PRESC,
TO_NUMBER(NVL('',0),9999)EXA_RX_DIAGNOSTICO,
TO_NUMBER(NVL('',0),9999999999)PRODUTO_ITEM_PRESC,
TO_NUMBER(NVL('',0),9999999999)PRODUTO_TAB_PRODUTO,
TO_NUMBER(NVL('',0),9999)CD_CIRURGIA,
TO_CHAR (NVL('',0))PRO_FAT_TAB_CIRURGIA,
VP.DT_VIGENCIA,
VP.CD_TAB_FAT,
VP.VL_TOTAL
FROM
PRO_FAT A
inner JOIN GRU_PRO B ON B.CD_GRU_PRO = A.CD_GRU_PRO
LEFT JOIN TIP_PRESC C ON C.CD_PRO_FAT = A.CD_PRO_FAT
INNER JOIN VAL_PRO VP ON VP.CD_PRO_FAT = A.CD_PRO_FAT
LEFT JOIN  PACOTE PCT ON PCT.CD_PRO_FAT = VP.CD_PRO_FAT 
WHERE VP.DT_VIGENCIA = (SELECT MAX(X.DT_VIGENCIA)FROM VAL_PRO X WHERE X.CD_PRO_FAT = VP.CD_PRO_FAT 
                                                                AND X.CD_TAB_FAT = VP.CD_TAB_FAT)
AND A.SN_ATIVO = 'S'
AND B.CD_GRU_FAT IN (2)
--AND A.CD_PRO_FAT = 02000002
--AND VP.CD_TAB_FAT = 15

UNION ALL
-- CIRURGIA --
SELECT
A.SN_ATIVO PRO_FAT_ATIVO_SN, 
A.DS_PRO_FAT DS_PRO_FAT,
nvl(A.CD_GRU_PRO,0)CD_GRU_PRO,
B.DS_GRU_PRO DS_GRU_PRO,
nvl(C.CD_TIP_PRESC,0) CD_TIP_PRESC,
nvl(A.CD_PRO_FAT,0) PRO_FAT_TAB_PROCEDIMENTOS,
nvl(PCT.CD_PRO_FAT_PACOTE,0)PRO_FAT_PACOTE,
nvl(C.CD_PRO_FAT,0) PRO_FAT_ITEM_PRESCR,
TO_NUMBER(NVL('',0),9999)EXA_LAB_ITEM_PRESCR,
TO_NUMBER(NVL('',0),9999)EXA_LAB_LABORATORIO,
TO_NUMBER(NVL('',0),9999)EXA_RX_ITEM_PRESC,
TO_NUMBER(NVL('',0),9999)EXA_RX_DIAGNOSTICO,
TO_NUMBER(NVL('',0),9999999999)PRODUTO_ITEM_PRESC,
TO_NUMBER(NVL('',0),9999999999)PRODUTO_TAB_PRODUTO,
nvl(D.CD_CIRURGIA,0)CD_CIRURGIA,
nvl(D.CD_PRO_FAT,0)PRO_FAT_TAB_CIRURGIA,
VP.DT_VIGENCIA,
VP.CD_TAB_FAT,
VP.VL_TOTAL
FROM
PRO_FAT A 
INNER JOIN GRU_PRO B ON B.CD_GRU_PRO = A.CD_GRU_PRO
LEFT JOIN TIP_PRESC C ON C.CD_PRO_FAT = A.CD_PRO_FAT
LEFT JOIN CIRURGIA D ON D.CD_PRO_FAT = A.CD_PRO_FAT
INNER JOIN VAL_PRO VP ON VP.CD_PRO_FAT = A.CD_PRO_FAT
LEFT JOIN  PACOTE PCT ON PCT.CD_PRO_FAT = VP.CD_PRO_FAT 
WHERE VP.DT_VIGENCIA = (SELECT MAX(X.DT_VIGENCIA)FROM VAL_PRO X WHERE X.CD_PRO_FAT = VP.CD_PRO_FAT 
                                                                AND X.CD_TAB_FAT = VP.CD_TAB_FAT)
AND A.SN_ATIVO = 'S'
AND B.CD_GRU_FAT = 7
---AND A.CD_PRO_FAT IN ('45080194','32010044')


UNION ALL

-- EXA_RX 
SELECT 
A.SN_ATIVO PRO_FAT_ATIVO_SN,
A.DS_PRO_FAT,
A.CD_GRU_PRO,
B.DS_GRU_PRO,
nvl(C.CD_TIP_PRESC,0)CD_TIP_PRESC,
nvl(A.CD_PRO_FAT,0)PRO_FAT_TAB_PROCEDIMENTOS,
nvl(PCT.CD_PRO_FAT_PACOTE,0)PRO_FAT_PACOTE,
nvl(C.CD_PRO_FAT,0)PRO_FAT_ITEM_PRESCR,
nvl(C.CD_EXA_LAB,0)EXA_LAB_ITEM_PRESCR,
TO_NUMBER(NVL('',0),'9999')EXA_LAB_LABORATORIO,
nvl(C.CD_EXA_RX,0)  EXA_RX_ITEM_PRESC,
nvl(RX.CD_EXA_RX,0) EXA_RX_DIAGNOSTICO,
TO_NUMBER(NVL('',0),9999999999)PRODUTO_ITEM_PRESC,
TO_NUMBER(NVL('',0),9999999999)PRODUTO_TAB_PRODUTO,
TO_NUMBER(NVL('',0),9999)CD_CIRURGIA,
TO_CHAR (NVL('',0))PRO_FAT_TAB_CIRURGIA,
VP.DT_VIGENCIA,
VP.CD_TAB_FAT,
VP.VL_TOTAL
FROM 
PRO_FAT A
LEFT JOIN  EXA_RX RX ON RX.EXA_RX_CD_PRO_FAT = A.CD_PRO_FAT
INNER JOIN  GRU_PRO B ON B.CD_GRU_PRO = A.CD_GRU_PRO
LEFT JOIN   TIP_PRESC C ON C.CD_EXA_RX = RX.CD_EXA_RX 
INNER JOIN VAL_PRO VP ON VP.CD_PRO_FAT = A.CD_PRO_FAT
LEFT JOIN  PACOTE PCT ON PCT.CD_PRO_FAT = VP.CD_PRO_FAT 
WHERE VP.DT_VIGENCIA = (SELECT MAX(X.DT_VIGENCIA)FROM VAL_PRO X WHERE X.CD_PRO_FAT = VP.CD_PRO_FAT 
                                                                AND X.CD_TAB_FAT = VP.CD_TAB_FAT)
AND A.CD_GRU_PRO in (32,33,34,36,39,30,49,16,17)
AND A.SN_ATIVO = 'S'

UNION ALL

-- EXA_LAB
SELECT 
A.SN_ATIVO PRO_FAT_ATIVO_SN,
A.DS_PRO_FAT,
A.CD_GRU_PRO,
B.DS_GRU_PRO,
nvl(C.CD_TIP_PRESC,0)CD_TIP_PRESC,
nvl(A.CD_PRO_FAT,0)PRO_FAT_TAB_PROCEDIMENTOS,
nvl(PCT.CD_PRO_FAT_PACOTE,0)PRO_FAT_PACOTE,
nvl(C.CD_PRO_FAT,0)PRO_FAT_ITEM_PRESCR,
nvl(C.CD_EXA_LAB,0)EXA_LAB_ITEM_PRESCR,
nvl(LAB.CD_EXA_LAB,0)EXA_LAB_LABORATORIO,
TO_NUMBER(NVL('',0),9999)EXA_RX_ITEM_PRESC,
TO_NUMBER(NVL('',0),9999)EXA_RX_DIAGNOSTICO,
TO_NUMBER(NVL('',0),9999999999)PRODUTO_ITEM_PRESC,
TO_NUMBER(NVL('',0),9999999999)PRODUTO_TAB_PRODUTO,
TO_NUMBER(NVL('',0),9999)CD_CIRURGIA,
TO_CHAR (NVL('',0))PRO_FAT_TAB_CIRURGIA,
VP.DT_VIGENCIA,
VP.CD_TAB_FAT,
VP.VL_TOTAL
FROM 
PRO_FAT A
INNER JOIN  EXA_LAB LAB ON LAB.CD_PRO_FAT = A.CD_PRO_FAT
INNER JOIN  GRU_PRO B ON B.CD_GRU_PRO = A.CD_GRU_PRO
LEFT JOIN   TIP_PRESC C ON C.CD_EXA_LAB = LAB.CD_EXA_LAB 
INNER JOIN VAL_PRO VP ON VP.CD_PRO_FAT = A.CD_PRO_FAT
LEFT JOIN  PACOTE PCT ON PCT.CD_PRO_FAT = VP.CD_PRO_FAT 
WHERE VP.DT_VIGENCIA = (SELECT MAX(X.DT_VIGENCIA)FROM VAL_PRO X WHERE X.CD_PRO_FAT = VP.CD_PRO_FAT 
                                                                AND X.CD_TAB_FAT = VP.CD_TAB_FAT)
AND B.CD_GRU_PRO in(14,26,27,28,63,65)
AND A.SN_ATIVO = 'S'

UNION ALL
-- MAT/MED
SELECT 
A.SN_ATIVO PRO_FAT_ATIVO_SN,
A.DS_PRO_FAT,
A.CD_GRU_PRO,
B.DS_GRU_PRO,
nvl(C.CD_TIP_PRESC,0)CD_TIP_PRESC,
nvl(A.CD_PRO_FAT,0) PRO_FAT_TAB_PROCEDIMENTOS,
nvl(PCT.CD_PRO_FAT_PACOTE,0)PRO_FAT_PACOTE,
TO_CHAR (NVL('',0))PRO_FAT_ITEM_PRESCR,
TO_NUMBER(NVL('',0),9999)EXA_LAB_ITEM_PRESCR,
TO_NUMBER(NVL('',0),9999)EXA_LAB_LABORATORIO,
TO_NUMBER(NVL('',0),9999)EXA_RX_ITEM_PRESC,
TO_NUMBER(NVL('',0),9999)EXA_RX_DIAGNOSTICO,
nvl(C.CD_PRODUTO,0) PRODUTO_ITEM_PRESC,
nvl(P.CD_PRODUTO,0) PRODUTO_TAB_PRODUTO,
TO_NUMBER(NVL('',0),9999)CD_CIRURGIA,
TO_CHAR (NVL('',0))PRO_FAT_TAB_CIRURGIA,
VP.DT_VIGENCIA,
VP.CD_TAB_FAT,
VP.VL_TOTAL
FROM
PRO_FAT A
INNER JOIN GRU_PRO B ON B.CD_GRU_PRO = A.CD_GRU_PRO
INNER JOIN PRODUTO P ON P.CD_PRO_FAT = A.CD_PRO_FAT
LEFT JOIN TIP_PRESC C ON C.CD_PRODUTO = P.CD_PRODUTO
INNER JOIN VAL_PRO VP ON VP.CD_PRO_FAT = A.CD_PRO_FAT
LEFT JOIN  PACOTE PCT ON PCT.CD_PRO_FAT = VP.CD_PRO_FAT 
WHERE VP.DT_VIGENCIA = (SELECT MAX(X.DT_VIGENCIA)FROM VAL_PRO X WHERE X.CD_PRO_FAT = VP.CD_PRO_FAT 
                                                                AND X.CD_TAB_FAT = VP.CD_TAB_FAT)
AND A.SN_ATIVO = 'S'
AND B.CD_GRU_FAT IN (5,4) -- GRUPO  FAT MAT/MED
)X
ORDER BY X.DS_PRO_FAT