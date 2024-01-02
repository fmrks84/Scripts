SELECT CONVENIO.cd_convenio, CONVENIO.nm_convenio, EMPRESA_CON_PLA.cd_con_pla, CON_PLA.ds_con_pla
FROM   DBAMV.CONVENIO, DBAMV.EMPRESA_CON_PLA, DBAMV.CON_PLA
WHERE  CONVENIO.cd_convenio = CON_PLA.cd_convenio
AND    CONVENIO.cd_convenio = EMPRESA_CON_PLA.cd_convenio
AND    EMPRESA_CON_PLA.cd_con_pla = CON_PLA.cd_con_pla
AND    CONVENIO.sn_ativo = 'S'
AND    EMPRESA_CON_PLA.cd_multi_empresa = 2
AND    EMPRESA_CON_PLA.sn_ativo = 'S'
AND    CON_PLA.sn_ativo = 'S'
ORDER BY 1,3
