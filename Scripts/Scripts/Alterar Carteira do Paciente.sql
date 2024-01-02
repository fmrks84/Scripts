-------------------------------------------------------------------------------------------------------------------------

Begin
  Pkg_Mv2000.Atribui_Empresa( 1 );  -->> Trocar a empresa e rodar uma vez para cada empresa
End;

--------------------------------------------------------------------------------------------------------------------------
Select Atendime.Cd_paciente, atendime.cd_atendimento, atendime.nr_carteira carteira_atendimento, atendime.cd_convenio
     , Atendime.Cd_Con_Pla, atendime.cd_sub_plano, nm_paciente , carteira.nr_carteira carteira_paciente, cd_atendimento_pai
     , Atendime.dt_atendimento
  From Atendime, Paciente, Carteira
  Where Paciente.Cd_Paciente = Atendime.Cd_Paciente
  And   Atendime.Cd_Paciente = Carteira.Cd_Paciente
  And   Atendime.Cd_Convenio = Carteira.Cd_Convenio
  And   Atendime.Nr_Carteira <> Carteira.Nr_Carteira
--  And   Carteira.Cd_Convenio = 322
  And   Atendime.Cd_Paciente = 152764 --- informar o atendimento do paciente (CD_ATENDIMENTO)
--  And   Atendime.Dt_Atendimento >= '01/01/09'
  Order By Dt_Atendimento Desc
----------------------------------------------------Carteira p/Carteira-------------------------------------------

Select cd_paciente, nr_carteira, cd_convenio, cd_con_pla, cd_sub_plano, dt_validade, nm_titular
From   Carteira
Where  cd_paciente in (152764) --- informar o numero do paciente (CD_PACIENTE)

----------------------------------------------------Carteira p/Atendimento-----------------------------------------
Select cd_paciente, cd_atendimento, tp_atendimento
     , nr_carteira, cd_convenio, cd_con_pla
     , cd_sub_plano, dt_atendimento
From   Atendime
Where  cd_paciente in (152764) --- informar o numero do paciente (CD_PACIENTE)
----------------------------------------------------Plano da Conta---------------------------------------------------
Select cd_reg_fat, sn_fechada, vl_total_conta
     , cd_atendimento, cd_convenio, cd_con_pla
     , cd_multi_empresa, cd_regra, cd_conta_pai
From   Reg_Fat
Where  cd_atendimento = 182834
---------------------------------------------------------------------------------------------------------------------
DELETE  from DBAMV.carteira WHERE CD_PACIENTE = 157297
select * from atendime
