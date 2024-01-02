SELECT TO_CHAR(Q.DT_ATENDIMENTO, 'MM/RRRR') COMPETENCIA,
       Q.CD_PACIENTE,
       Q.NM_PACIENTE,
       Q.CD_CONVENIO,
       Q.NM_CONVENIO,
       Q.ATE_PA,
       Q.ATE_H24_INT,
       Q.LEITO,
       L.DS_LEITO,
       L.CD_TIP_ACOM,
       (CASE
         WHEN TP.DS_TIP_ACOM LIKE '%APART%' THEN
          'APARTAMENTO'
         WHEN TP.DS_TIP_ACOM LIKE '%ENF%' THEN
          'ENFERMARIA'
         WHEN TP.DS_TIP_ACOM LIKE '%UTI%' THEN
          'UTI'
         ELSE
          NULL
       END) DS_ACOMODACAO

 

  FROM (SELECT A.DT_ATENDIMENTO,
               A.CD_PACIENTE,
               P.NM_PACIENTE,
               A.CD_CONVENIO,
               C.NM_CONVENIO,
               A.CD_ATENDIMENTO ATE_PA,
               (SELECT MAX(X.CD_ATENDIMENTO)
                  FROM DBAMV.ATENDIME X
                 WHERE X.CD_PACIENTE = A.CD_PACIENTE
                   AND X.TP_ATENDIMENTO = 'I'
                   AND X.DT_ATENDIMENTO BETWEEN A.DT_ATENDIMENTO AND
                       TO_DATE(TO_CHAR(A.DT_ATENDIMENTO, 'DD/MM/YYYY hh24:mi'),
                               'DD/MM/YYYY hh24:mi') + 24 / 24) ATE_H24_INT,

               (SELECT M.CD_LEITO
                  FROM DBAMV.MOV_INT M
                 WHERE M.CD_ATENDIMENTO =
                       (SELECT MAX(X.CD_ATENDIMENTO)
                          FROM DBAMV.ATENDIME X
                         WHERE X.CD_PACIENTE = A.CD_PACIENTE
                           AND X.TP_ATENDIMENTO = 'I'
                           AND X.DT_ATENDIMENTO BETWEEN A.DT_ATENDIMENTO AND
                               TO_DATE(TO_CHAR(A.DT_ATENDIMENTO,
                                               'DD/MM/YYYY hh24:mi'),'DD/MM/YYYY hh24:mi') + 24 / 24)
                   AND M.CD_MOV_INT =
                       (SELECT MAX(X.CD_MOV_INT)
                          FROM MOV_INT X
                         WHERE X.CD_ATENDIMENTO = M.CD_ATENDIMENTO)) LEITO

          FROM DBAMV.ATENDIME A
         INNER JOIN DBAMV.PACIENTE P
            ON P.CD_PACIENTE = A.CD_PACIENTE
         INNER JOIN DBAMV.CONVENIO C
            ON C.CD_CONVENIO = A.CD_CONVENIO
         INNER JOIN DBAMV.EMPRESA_CONVENIO E
            ON E.CD_CONVENIO = A.CD_CONVENIO
           AND E.CD_MULTI_EMPRESA = A.CD_MULTI_EMPRESA
         WHERE A.TP_ATENDIMENTO = 'U'
           AND TO_CHAR(A.DT_ATENDIMENTO, 'MM/RRRR') = '02/2023'
           AND E.CD_MULTI_EMPRESA = 7
           AND A.CD_ORI_ATE IN (9, 10, 101)) Q
  LEFT JOIN LEITO L
    ON L.CD_LEITO = Q.LEITO
  LEFT JOIN TIP_ACOM TP
    ON TP.CD_TIP_ACOM = L.CD_TIP_ACOM
WHERE 1 = 1 --Q.ATE_H24_INT = 4666088
ORDER BY 4
