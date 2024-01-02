SELECT 
'insert into dbamv.val_pro (cd_tab_fat,cd_pro_fat,dt_vigencia,vl_honorario,vl_operacional,vl_total,sn_ativo)
values(',
'3431',--vp.cd_tab_fat,
',',
vp.cd_pro_fat,
',',
vp.dt_vigencia,
',',
nvl(vp.vl_honorario,0)vl_honorario,
',',
nvl(vp.vl_operacional,0)vl_operacional,
',',
nvl(vp.vl_total,0)vl_total,
',',
vp.sn_ativo,
');'
FROM
VAL_PRO VP
WHERE VP.DT_VIGENCIA = (SELECT MAX(X.DT_VIGENCIA)FROM VAL_PRO X WHERE X.CD_PRO_FAT = VP.CD_PRO_FAT
                                                                AND X.CD_TAB_FAT = VP.CD_TAB_FAT)
AND VP.SN_ATIVO = 'S'
AND VP.CD_TAB_FAT IN (181)

ORDER BY 1

/*
insert into dbamv.val_pro (cd_tab_fat,cd_pro_fat,dt_vigencia,vl_honorario,vl_operacional,vl_total,sn_ativo)
values*/


-- tabela 2 replicar para tabela 3433
-- tabela 1 replicar para tabela 3432
-- tabela 181 replicar para tabela 3431
