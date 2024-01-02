Select R.Cd_Reg_Fat, R.Cd_Conta_Pai, R.Vl_Total_Conta, R.Cd_Multi_Empresa From Dbamv.Reg_Fat R Where nvl(R.Cd_Conta_Pai, R.Cd_Reg_Fat) in '1017993'

Select cd_pro_fat, cd_reg_fat, cd_conta_pai, cd_multi_empresa, vl_total_conta From Dbamv.Itreg_Fat Where Cd_reg_Fat = 1017994

select * from dbamv.tiss_guia where cd_atendimento = 1086589 and cd_reg_fat = 1017993


select * From dbamv.itreg_fat r where r.cd_reg_fat = 1021391
