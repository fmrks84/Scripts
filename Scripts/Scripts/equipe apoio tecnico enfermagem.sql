SELECT  NM_USUARIO,
        SUM(TOTAL)TOTAL

FROM
(
SELECT  A.NM_USUARIO,
        CASE 
        WHEN A.CD_OS IS NOT NULL 
         THEN 1
         ELSE 0  
         END TOTAL
FROM
DBAMV.SOLICITACAO_OS A ,
dbamv.itsolicitacao_os b 
where a.CD_OS = b.cd_os
and b.cd_servico in (5331,5332)
AND A.NM_USUARIO NOT IN ('WLIMA','TSFERREIRA','GAVIEIRA','CGISLAINE')
) GROUP BY NM_USUARIO
