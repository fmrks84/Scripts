--alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss'
---------------------------------------------------------Select das Guias sem Atendimentos-------------------------------------------------
SELECT ID, T.NR_GUIA guia, T.CD_ATENDIMENTO atendimento , T.CD_PACIENTE pct , T.NM_PACIENTE paciente
     , decode (TP_ATENDIMENTO, 'A', 'Ambulatorial', 'I', 'Internação', 'E', 'Externo', 'U', 'Urgência')        Tipo
     , T.CD_CONVENIO cv, C.NM_CONVENIO convenio, DH_SOLICITADO dt_hr_solicitacao
     , decode (T.CD_MULTI_EMPRESA, '1', '1 - Santa Joana', '2', '2 - Pro Matre', '3', '3 - Centro Diagnostico') LOCAL
FROM  DBAMV.TISS_SOL_GUIA T, DBAMV.PACIENTE P, DBAMV.CONVENIO C
WHERE T.CD_ATENDIMENTO IS NULL
--AND T.CD_MULTI_EMPRESA =1
--AND TP_ATENDIMENTO = 'I'
AND TO_DATE (DH_SOLICITADO, 'dd/mm/yyyy hh24:mi:ss') <  '27/03/2011 23:59:59'
AND T.CD_PACIENTE = P.CD_PACIENTE
AND T.CD_CONVENIO = C.CD_CONVENIO
ORDER BY 10,9,8 DESC

------------------------------------------------- Select dos Itens das Guias sem Atendimentos-----------------------------------------
SELECT *
FROM DBAMV.TISS_ITSOL_GUIA
WHERE ID_PAI IN   -- ALTERAR O SELECT P/ DELETE
 (SELECT ID
   FROM DBAMV.TISS_SOL_GUIA
   WHERE CD_ATENDIMENTO IS NULL
   AND TO_DATE (DH_SOLICITADO, 'dd/mm/yyyy hh24:mi:ss') <  '27/03/2011 23:59:59')
--------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------Deletar os itens das Guias sem Atendimentos---------------------------------------------------
DELETE
FROM DBAMV.TISS_ITSOL_GUIA
WHERE ID_PAI IN   -- ALTERAR O SELECT P/ DELETE
 (SELECT ID
   FROM DBAMV.TISS_SOL_GUIA
   WHERE CD_ATENDIMENTO IS NULL
   AND TO_DATE (DH_SOLICITADO, 'dd/mm/yyyy hh24:mi:ss') <  '27/03/2011 23:59:59')
-------------------------------------------------Deletar as Guias sem Atendimentos------------------------------------------------------
DELETE
FROM DBAMV.TISS_SOL_GUIA
WHERE CD_ATENDIMENTO IS NULL
AND TO_DATE (DH_SOLICITADO, 'dd/mm/yyyy hh24:mi:ss') <  '27/03/2011 23:59:59'

----------------------------------------------------------------------------------------------------------------------------------------
--SELECT ID, NR_GUIA, CD_ATENDIMENTO, CD_CONVENIO, DT_EMISSAO, DH_SOLICITACAO, DH_SOLICITADO FROM DBAMV.TISS_SOL_GUIA WHERE CD_ATENDIMENTO IS NULL
--SELECT * FROM DBAMV.TISS_SOL_GUIA WHERE ID = 619736
--SELECT * FROM DBAMV.TISS_ITSOL_GUIA WHERE ID_PAI = 619736
--SELECT * FROM DBAMV.GUIA WHERE NR_GUIA = '400396002'
--SELECT * FROM DBAMV.IT_GUIA WHERE CD_GUIA = 313146

SELECT * FROM DBAMV.GUIA WHERE NR_GUIA LIKE '%0000000%'

