UPDATE dbasgu.modulos 
set sn_html5 = 'N' -- S


SELECT * FROM dbasgu.modulos where cd_modulo = 'M_CON_REC_PART' FOR UPDATE


SELECT * FROM ORD_COM A ORDER BY A.DT_ORD_COM DESC 
