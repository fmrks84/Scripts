Select P.Cd_Atendimento, P.Dt_Atendimento, P.Tp_Atendimento, P.Nr_Carteira, P.Cd_Convenio, p.cd_multi_empresa
From Dbamv.Tb_Atendime P 
Where P.Cd_Paciente In (Select X.Cd_Paciente From Dbamv.Paciente X Where X.Cd_Paciente In (512165))
Order By P.Dt_Atendimento;

select * From Dbamv.Carteira C Where C.Cd_Paciente In (512165);

