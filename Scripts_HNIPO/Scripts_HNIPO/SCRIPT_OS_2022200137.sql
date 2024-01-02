SELECT
TO_CHAR(F.DT_VENCIMENTO,'YYYY')ANO,
SUM(NVL(G.VL_DESCONTO,0))VL_DESCONTO,
G.VL_RECEBIDO

FROM 
REMESSA_FATURA A 
INNER JOIN FATURA B ON B.CD_FATURA = A.CD_FATURA
INNER JOIN ITFAT_NOTA_FISCAL C ON C.CD_REMESSA = A.CD_REMESSA 
INNER JOIN NOTA_FISCAL D ON D.CD_NOTA_FISCAL = C.CD_NOTA_FISCAL 
INNER JOIN CON_REC E ON E.CD_NOTA_FISCAL = D.CD_NOTA_FISCAL
INNER JOIN ITCON_REC F ON F.CD_CON_REC = E.CD_CON_REC 
INNER JOIN RECCON_REC G ON G.CD_ITCON_REC = F.CD_ITCON_REC 
WHERE B.CD_CONVENIO = 6
AND TO_CHAR(F.DT_VENCIMENTO,'YYYY') ='2018' 
--AND D.NR_ID_NOTA_FISCAL = 675161
GROUP BY 
TO_CHAR(F.DT_VENCIMENTO,'YYYY'),
G.VL_RECEBIDO

;


SELECT
E.CD_CON_REC,
E.CD_FORNECEDOR,
E.DT_EMISSAO,
E.DT_LANCAMENTO,
E.NR_DOCUMENTO,
F.DT_VENCIMENTO,
F.DT_PREVISTA_RECEBIMENTO,
DECODE(F.TP_QUITACAO,'Q','Quitado','P','Parc.Recebido','C','Comprometido','G','Quitado com Glosa')Tipo_quitacao,
NVL(G.VL_DESCONTO,0)VL_DESCONTO,
G.VL_RECEBIDO,
G.DT_RECEBIMENTO

FROM 
REMESSA_FATURA A 
INNER JOIN FATURA B ON B.CD_FATURA = A.CD_FATURA
INNER JOIN ITFAT_NOTA_FISCAL C ON C.CD_REMESSA = A.CD_REMESSA 
INNER JOIN NOTA_FISCAL D ON D.CD_NOTA_FISCAL = C.CD_NOTA_FISCAL 
INNER JOIN CON_REC E ON E.CD_NOTA_FISCAL = D.CD_NOTA_FISCAL
INNER JOIN ITCON_REC F ON F.CD_CON_REC = E.CD_CON_REC 
INNER JOIN RECCON_REC G ON G.CD_ITCON_REC = F.CD_ITCON_REC 
WHERE B.CD_CONVENIO = 6
AND F.DT_VENCIMENTO BETWEEN '01/01/2018' AND '31/12/2018'
--AND D.NR_ID_NOTA_FISCAL = 675161
GROUP BY 
E.CD_CON_REC,
E.CD_FORNECEDOR,
E.DT_EMISSAO,
E.DT_LANCAMENTO,
E.NR_DOCUMENTO,
F.DT_VENCIMENTO,
F.DT_PREVISTA_RECEBIMENTO,
F.TP_QUITACAO,
G.VL_DESCONTO,
G.VL_RECEBIDO,
G.DT_RECEBIMENTO
ORDER BY E.CD_CON_REC


