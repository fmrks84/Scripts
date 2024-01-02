Select R.Cd_Reg_Fat, R.Cd_Multi_Empresa From Dbamv.Reg_Fat  R Where R.Cd_Atendimento = 746527 
Select I.Cd_Reg_Fat, I.Cd_Conta_Pai, I.Cd_Lancamento, I.Cd_Lancamento_Rel, I.Cd_Pro_Fat, I.Dt_Lancamento, I.Tp_Mvto, I.Cd_Mvto, I.Cd_Multi_Empresa, I.Cd_Usuario 
From   Dbamv.Itreg_Fat I Where I.Cd_Reg_Fat IN (682118,682051) And I.Cd_Gru_Fat = 7 Order by I.Cd_Lancamento 
