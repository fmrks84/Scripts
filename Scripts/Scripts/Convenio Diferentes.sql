SELECT CD_REG_FAT, CD_REMESSA, CD_ATENDIMENTO, CD_CONVENIO, CD_CON_pLA FROM DBAMV.REG_FAT
WHERE NVL(CD_CONTA_PAI, CD_REG_FAT) = 297621
