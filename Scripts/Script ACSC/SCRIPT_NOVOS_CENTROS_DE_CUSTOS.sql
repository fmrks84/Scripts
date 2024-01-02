select s.cd_multi_empresa, S.CD_SETOR, S.NM_SETOR, G.CD_GRUPO_DE_CUSTO, G.DS_GRUPO_DE_CUSTO, s.sn_ativo
from setor S, grupo_de_custo G
WHERE S.CD_GRUPO_DE_CUSTO = G.CD_GRUPO_DE_CUSTO
AND S.CD_SETOR = 793
--AND s.cd_grupo_de_custo = 1
and s.cd_multi_empresa = 7
ORDER BY 3 
;
--4525912
 

--select * from dbamv.CONFIGU_IMPORTACAO_GRU_FAT where cd_setor in (171)--324 registros 3325
