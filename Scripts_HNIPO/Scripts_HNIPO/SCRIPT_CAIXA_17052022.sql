SELECT * FROM LOTE_CAIXA A WHERE A.CD_LOTE_CAIXA = 62645;
SELECT * FROM MOV_CAIXA B WHERE B.CD_LOTE_CAIXA = 62645 AND B.CD_MOV_CAIXA IN --(1644227,1641697,1644221,1644223,1644225,1641360,1641695)
(1644224,1641694,1641104,1644222,1641689,1641362,1644227,1641697,1644219,1641103,1641693,1641688,1644221,1644223,1644225,1641360,1641695,1644218)
B.CD_DOC_CAIXA IN (348168,348169);--B.CD_LOTE_CAIXA = 62645; --AND ;
SELECT * FROM DOC_CAIXA C WHERE  C.CD_DOC_CAIXA in (348005,348006,348168,348169,348981,348982,348983,348984)--C.NR_DOCUMENTO = 'VC-912194';
SELECT * FROM MOV_CAIXA B WHERE B.CD_DOC_CAIXA IN (348006,348005);
62645
SELECT * FROM ALL_CONSTRAINTS CNT WHERE CNT.constraint_name LIKE '%MOV_CX_MOV_CX_FK%'
SELECT * FROM DOC_HISTORICO HIST WHERE HIST.CD_DOC_CAIXA IN (348005,348006,348168,348169,348981,348982,348983,348984)--HIST.CD_MOV_CAIXA IN (1644224,1641694,1641104,1644222,1641689,1641362,1644227,1641697,1644219,1641103,1641693,1641688,1644221,1644223,1644225,1641360,1641695,1644218)--HIST.CD_DOC_CAIXA IN (348168,348169,348005,348006,348005,348006)
SELECT * FROM RECCON_REC D WHERE D.NR_DOCUMENTO = 'VC-912194'; --1534975,1534976
SELECT(* FROM MOV_CAIXA B WHERE B.CD_DOC_CAIXA IN (348006,348005);
SELECT * FROM DOC_CAIXA B1 WHERE B1.CD_DOC_CAIXA IN (348006,34)
SELECT * FROM MOV_CAIXA B WHERE b.cd_lote_caixa = 62645--B.CD_DOC_CAIXA IN (348168,348169)
SELECT * FROM ITCON_REC E WHERE E.CD_ITCON_REC IN (1221112);
SELECT * FROM CON_REC F WHERE F.CD_CON_REC IN (1217876)--1218005,1217876)


SELECT * FROM RECCON_REC XX WHERE XX.CD_RECCON_REC IN (1534975,1534976)--FOR UPDATE; 
SELECT * FROM ITCON_REC XXX WHERE XXX.CD_ITCON_REC IN (1220983)
--select * from multi_empresas x where x.cd_multi_empresa = 1
