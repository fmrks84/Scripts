select cd_lancamento, cd_reg_fat, cd_conta_pai, cd_multi_empresa, cd_pro_fat
from dbamv.itreg_fat i where i.cd_reg_fat in (924942,925651) order by 1 for update;

select * FROM DBAMV.REG_FAT WHERE CD_rEG_fAT  in (924942,925651)for update
