SELECT m.CD_MODULO,
m.CD_MENU,
m.SN_MIGRADO,
LTrim(SYS_CONNECT_BY_PATH(m.nm_menu, ' > '), ' > ') NM_MENU,
m.NR_ORDEM,
m.CD_MENU_PAI
FROM dbasgu.menu m
WHERE cd_modulo LIKE Upper('%M_TISS_CONFIG_ATEND%')
START WITH cd_menu_pai IS NULL
CONNECT BY NOCYCLE PRIOR CD_MENU = CD_MENU_PAI
order by nr_ordem ASC

SELECT * FROM DBASGU.MENU WHERE UPPER(NM_MENU) LIKE '%CONFIGURAÇÕES%TISS%'
SELECT * FROM dbasgu.menu WHERE cd_modulo = 'M_TISS_CONFIG_ATEND'
UPDATE DBASGU.MENU SET CD_MENU_PAI = 828 WHERE  CD_MODULO = 'M_TISS_CONFIG_ATEND';

 


--Faturamento > Faturamento de Convênios e Particulares > Configurações > De/Para Atendimento TISS
