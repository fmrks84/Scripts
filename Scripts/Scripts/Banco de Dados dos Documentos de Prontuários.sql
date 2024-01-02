--SELECT * FROM DBAMV.GRUPO_PERGUNTA  WHERE GRUPO_PERGUNTA.CD_GRUPO_PERGUNTA = 11628
--SELECT * FROM DBAMV.RESPOSTA_POSSIVEL
--SELECT * FROM DBAMV.DOCUMENTO WHERE TP_USO_DOCUMENTO = 'U' ORDER BY CD_DOCUMENTO
--SELECT * FROM DBAMV.GRUPO_PERGUNTA_DOC WHERE SN_OBRIGATORIO = 'S' AND CD_GRUPO_PERGUNTA = 11628
--SELECT * FROM DBAMV.PERGUNTA_DOC WHERE CD_PERGUNTA_DOC = 4521

SELECT G.ds_grupo_pergunta, P.sn_editavel EDITA, P.sn_obrigatorio OBRIGA, P.tamanho_resposta TAM, D.ds_documento, P.ds_query_busca

FROM   
        DBAMV.GRUPO_PERGUNTA                 G
      , DBAMV.DOCUMENTO                      D
      , DBAMV.GRUPO_PERGUNTA_DOC             P

WHERE   G.cd_grupo_pergunta    =   P.cd_grupo_pergunta
AND     G.cd_documento         =   D.cd_documento
--AND     P.sn_editavel          =   'S'        
--AND     P.sn_obrigatorio       =   'S'
AND     D.tp_uso_documento     =   'U'
AND     P.ds_query_busca IS NOT NULL
AND     P.ds_query_busca LIKE '%mm_docpro%'
ORDER BY 5
