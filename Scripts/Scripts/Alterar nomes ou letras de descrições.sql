SELECT * FROM CON_PAG WHERE DS_CON_PAG LIKE '%CONTA DE FUNCIONARIO DE%'
SELECT * FROM CON_PAG WHERE DS_CON_PAG LIKE '%CT FUNC%'


SELECT * FROM 


UPDATE CON_PAG SET DS_CON_PAG = REPLACE(DS_CON_PAG,'CT FNC', 'CT FUNC ') WHERE DS_CON_PAG LIKE '%CT FNC%'
