/*SELECT 
A.CD_REG_FAT,
SUM(B.VL_TOTAL_CONTA)TOTAL_CONTA,
A.VL_DESCONTO_CONTA||''||D.VL_DESCONTO||''||F.VL_DESCONTO VL_DESCONTO,
E.VL_DUPLICATA TOTAL_DUPLICATA,
E.VL_SOMA_RECEBIDO

FROM 
DBAMV.REG_FAT A 
INNER JOIN ITREG_FAT B ON A.CD_REG_FAT = B.CD_REG_FAT
INNER JOIN ATENDIME C ON C.CD_ATENDIMENTO = A.CD_ATENDIMENTO
INNER JOIN CON_REC D ON D.CD_ATENDIMENTO = A.CD_ATENDIMENTO AND D.CD_REG_FAT = B.CD_REG_FAT
INNER JOIN ITCON_REC E ON E.CD_CON_REC = D.CD_CON_REC
INNER JOIN RECCON_REC F ON F.CD_ITCON_REC = E.CD_ITCON_REC
WHERE C.DT_ATENDIMENTO BETWEEN '01/03/2022' AND SYSDATE
AND A.SN_FECHADA = 'S'
AND C.CD_CONVENIO = 40
AND B.SN_PERTENCE_PACOTE = 'N'
GROUP BY 
A.CD_REG_FAT,
A.VL_DESCONTO_CONTA,
D.VL_DESCONTO,
F.VL_DESCONTO,
E.VL_DUPLICATA,
E.VL_SOMA_RECEBIDO
*/

SELECT 
A1.CD_REG_AMB,
A1.VL_TOTAL_CONTA,
--SUM(A2.VL_TOTAL_CONTA),
A1.VL_DESCONTO_CONTA,
A4.VL_DESCONTO,
A6.VL_DESCONTO,
A5.VL_DUPLICATA,
A5.VL_SOMA_RECEBIDO


FROM
REG_AMB A1
INNER JOIN ITREG_AMB A2 ON A2.CD_REG_AMB = A1.CD_REG_AMB
INNER JOIN ATENDIME A3 ON A3.CD_ATENDIMENTO = A2.CD_ATENDIMENTO
INNER JOIN CON_REC A4 ON A4.CD_ATENDIMENTO = A2.CD_ATENDIMENTO AND A4.CD_REG_AMB = A2.CD_REG_AMB
INNER JOIN ITCON_REC A5 ON A5.CD_CON_REC = A4.CD_CON_REC
INNER JOIN RECCON_REC A6 ON A6.CD_ITCON_REC = A5.CD_ITCON_REC
WHERE A3.DT_ATENDIMENTO BETWEEN '01/04/2022' AND SYSDATE 
AND A3.CD_MULTI_EMPRESA = 1 
AND A2.SN_PERTENCE_PACOTE = 'N'
AND A2.SN_FECHADA = 'S'
AND A2.CD_CONVENIO = 40
GROUP BY 
A1.CD_REG_AMB,
A1.VL_TOTAL_CONTA,
A1.VL_DESCONTO_CONTA,
A4.VL_DESCONTO,
A6.VL_DESCONTO,
A5.VL_DUPLICATA,
A5.VL_SOMA_RECEBIDO
