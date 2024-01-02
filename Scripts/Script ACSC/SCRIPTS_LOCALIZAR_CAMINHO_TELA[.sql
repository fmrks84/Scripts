SELECT m.CD_MODULO,
       m.CD_MENU,
       m.SN_MIGRADO,
       LTrim(SYS_CONNECT_BY_PATH(m.nm_menu, ' > '), ' > ') NM_MENU,
       m.NR_ORDEM,
       m.CD_MENU_PAI
  FROM dbasgu.menu m
WHERE cd_modulo LIKE Upper('%G_CIH_A%')
START WITH cd_menu_pai IS NULL
CONNECT BY NOCYCLE PRIOR CD_MENU = CD_MENU_PAI
order by nr_ordem ASC
