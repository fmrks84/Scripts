SELECT * FROM NOTA_FISCAL X WHERE X.NR_ID_NOTA_FISCAL IN (861573,862577)--for update --,861573,862577) ;---FOR UPDATE ;
select * from formulario_nf a where a.cd_formulario_nf = 3 --for update
select * from nota_Fiscal  where nota_fiscal.cd_formulario_nf = 3  order by 2 desc 
SELECT * FROM CON_REC Y WHERE Y.CD_NOTA_FISCAL = 705926 ---for update 
SELECT * FROM ITCON_REC YY WHERE YY.CD_CON_REC = 1193076
SELECT * FROM RECCON_REC YYY WHERE YYY.CD_ITCON_REC = 1196236
SELECT * FROM LCTO_CONTABIL Z WHERE Z.CD_LCTO_MOVIMENTO = 31187739 --for update



select * from nota_Fiscal  where nota_fiscal.cd_formulario_nf = 3  order by 2 desc 

select * from formulario_nf a where a.cd_formulario_nf = 3 --for update
/*
UPDATE NOTA_FISCAL X SET X.NR_ID_NOTA_FISCAL = 864675
WHERE X.NR_ID_NOTA_FISCAL IN (862577);
UPDATE  formulario_nf a SET  A.NR_ID_SEQUENCIA_NOTA_FISCAL = 864675
where a.cd_formulario_nf = 3 ;
COMMIT*/
