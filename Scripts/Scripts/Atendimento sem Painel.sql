SELECT P.cd_paciente, P.nm_paciente, A.cd_atendimento, A.nr_chamada_painel, A.dt_atendimento,  A.hr_atendimento, A.cd_multi_empresa
FROM  DBAMV.ATENDIME A, DBAMV.PACIENTE P
WHERE A.CD_PACIENTE    = P.CD_PACIENTE 
AND   A.TP_ATENDIMENTO = 'U'
AND   A.nr_chamada_painel IS NULL
AND   A.dt_atendimento >= '01-JUL-2011'
AND   A.dt_atendimento < '01-AGO-2011'
AND   A.cd_multi_empresa = '1'
ORDER BY A.cd_multi_empresa, A.dt_atendimento, A.hr_atendimento
