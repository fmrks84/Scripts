DELETE FROM DBAMV.TISS_ITSOL_GUIA WHERE ID_PAI IN 
    (SELECT ID FROM DBAMV.TISS_SOL_GUIA
     WHERE CD_ATENDIMENTO IS NULL
    AND DT_EMISSAO < TO_DATE ('13/10/2008', 'DD/MM/YYYY'))


DELETE FROM DBAMV.TISS_SOL_GUIA
     WHERE CD_ATENDIMENTO IS NULL
AND DT_EMISSAO < TO_DATE ('13/10/2008', 'DD/MM/YYYY')



SELECT CD_PACIENTE, CD_ATENDIMENTO, DT_EMISSAO FROM DBAMV.TISS_SOL_GUIA
     WHERE CD_ATENDIMENTO IS NULL
AND DT_EMISSAO >= TO_DATE ('12/10/2008', 'DD/MM/YYYY')
ORDER BY DT_EMISSAO



SELECT * FROM DBAMV.TISS_ITSOL_GUIA WHERE ID_PAI = 341475
SELECT * FROM DBAMV.TISS_SOL_GUIA WHERE ID= 341475


