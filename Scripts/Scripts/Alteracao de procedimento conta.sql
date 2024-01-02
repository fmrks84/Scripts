select cd_reg_fat, cd_lancamento, cd_pro_fat, cd_gru_fat, cd_multi_empresa, cd_conta_pai 
from dbamv.itreg_fat
where cd_reg_fat in ( select cd_reg_fat
                      from reg_fat
                      where nvl (cd_conta_pai, cd_reg_fat) = 302658)
And cd_gru_fat in (7,6)
Order by  2,1            

--delete from dbamv.tiss_nr_guia where cd_atendimento =  337648     
