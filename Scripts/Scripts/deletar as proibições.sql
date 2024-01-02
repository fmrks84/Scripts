Select P.Cd_Pro_Fat, Cd_Con_Pla, P.Cd_Convenio, C.Nm_Convenio, Cd_Multi_Empresa, Tp_Proibicao
From   Dbamv.Proibicao P, Dbamv.Convenio C
Where  P.Cd_Pro_Fat in ('00050015')
And    P.Cd_Convenio(+) = C.Cd_Convenio
Order by nm_convenio

---Delete from Proibicao where cd_convenio = 355


Select Cd_Convenio, Nm_Convenio, Sn_Ativo, Tp_Convenio From Dbamv.Convenio Where Cd_Convenio = 33
