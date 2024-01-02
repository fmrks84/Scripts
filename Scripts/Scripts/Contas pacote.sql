select cd_reg_fat, cd_pro_fat, qt_lancamento, vl_total_conta, sn_pertence_pacote
from dbamv.itreg_fat
where cd_reg_fat in (select cd_reg_fat
                     from reg_fat
                     where cd_atendimento = 202276)
and sn_pertence_pacote = 'S'
order by  cd_pro_fat, cd_lancamento


