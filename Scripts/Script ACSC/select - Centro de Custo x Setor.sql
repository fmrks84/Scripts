select s.cd_multi_empresa, S.CD_SETOR, S.NM_SETOR, G.CD_GRUPO_DE_CUSTO, G.DS_GRUPO_DE_CUSTO, s.sn_ativo, s.tp_setor
from setor S, grupo_de_custo G
WHERE S.CD_GRUPO_DE_CUSTO = G.CD_GRUPO_DE_CUSTO
AND S.CD_SETOR IN (3941)
and s.sn_ativo = 'S'

ORDER BY tp_setor
;

select * from dbamv.CONFIGU_IMPORTACAO_GRU_FAT where cd_setor  IN (3941)--324 registros
;

delete CONFIGU_IMPORTACAO_GRU_FAT where cd_setor IN (3949,3950)


select MAX(cd_conf_import) from configu_importacao_gru_fat -- a ultima 5958813
;

select * from ori_ate o where o.cd_multi_empresa = 25 and o.sn_ativo = 'S'






