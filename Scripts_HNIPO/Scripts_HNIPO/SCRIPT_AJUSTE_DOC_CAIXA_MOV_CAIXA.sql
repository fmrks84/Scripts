

SELECT * FROM 
DOC_CAIXA A 
WHERE A.NR_DOCUMENTO = 'MD-172006'; --and A.CD_DOC_CAIXA = 347717 --FOR UPDATE ;


SELECT * FROM RECCON_REC H WHERE H.CD_DOC_CAIXA IN (347717,347592,347601);
SELECT * FROM ITCON_REC HI WHERE HI.CD_ITCON_REC = 1220204;
SELECT * FROM CON

SELECT * FROM MOV_CAIXA B WHERE b.cd_lote_caixa = 62614 and b.dt_cancelamento is null order by b.dt_movimentacao--B.CD_DOC_CAIXA = 347717 --FOR UPDATE 
--1640101

/*D - DEVOLVIDO
E - ENVIADO
P - PROTESTADO
U - DEP.ANTEC
C -  CUSTODIADO
X - CAIXA
P - PRE-DATADO
R - ????
O - 
S -
*/
