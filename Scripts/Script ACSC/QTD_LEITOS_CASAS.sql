
SELECT 
CASAS,
SUM(QTD_LEITOS)QTD_LEITOS
FROM
(
SELECT 
S.CD_MULTI_EMPRESA||' - '||MP.DS_MULTI_EMPRESA CASAS,
COUNT(*)QTD_LEITOS

FROM 
LEITO L
INNER JOIN UNID_INT U ON U.CD_UNID_INT = L.CD_UNID_INT
INNER JOIN SETOR S ON S.CD_SETOR = U.CD_SETOR
INNER JOIN MULTI_EMPRESAS MP ON MP.CD_MULTI_EMPRESA = S.CD_MULTI_EMPRESA
WHERE L.DT_DESATIVACAO IS NULL
AND S.CD_MULTI_EMPRESA IN(3,4,7,10,11,25)
AND L.SN_EXTRA = 'N' -- AO COMENTAR SER� CALCULADO OS LEITOS QUE S�O EXTRAS 
GROUP BY S.CD_MULTI_EMPRESA,L.SN_EXTRA,MP.DS_MULTI_EMPRESA
ORDER BY S.CD_MULTI_EMPRESA
)GROUP BY CASAS
