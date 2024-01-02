Select Con_Pla.Cd_Convenio, Con_Pla.Cd_Con_Pla, Con_Pla.Cd_Regra, Regra.Ds_Regra, ItRegra.Cd_Gru_Pro, Gru_Pro.Ds_Gru_Pro, ItRegra.Cd_Tab_Fat, Tab_Fat.Ds_Tab_Fat   
From   Dbamv.Con_Pla, Dbamv.Regra, Dbamv.ItRegra, Dbamv.Gru_Pro, Dbamv.Tab_Fat
Where  Cd_Convenio in (21,18)
And    Con_Pla.Cd_Regra = Regra.Cd_Regra
And    Gru_Pro.Cd_Gru_Pro = 1
And    Regra.Cd_Regra   = ItRegra.Cd_Regra
And    ItRegra.Cd_Tab_Fat = Tab_Fat.Cd_Tab_Fat
And    ItRegra.Cd_Gru_Pro = Gru_Pro.Cd_Gru_Pro
And    Con_Pla.Sn_Ativo = 'S'
Order By Cd_Convenio, Con_Pla.Cd_Con_Pla
