--Select sum (Vl_Total_Conta) from (
Select r1.Cd_Atendimento, r1.Cd_Reg_Fat, r1.Sn_Fechada, r1.Vl_Total_Conta, r1.Cd_Remessa, r1.Cd_Convenio, r1.Dt_Inicio, r1.Dt_Final
     , r1.Dt_Fechamento, r1.Nm_Usuario_Fechou, r1.Cd_Multi_Empresa
  From Dbamv.Reg_Fat r1
 Where r1.Sn_Fechada = 'S'
   And r1.Cd_Multi_Empresa In (1,2)
   And r1.Cd_Convenio Not In (351,352,378,379)
   And Exists (Select 1
                 From Dbamv.Reg_Fat r2
                Where r2.Cd_Atendimento = r1.Cd_Atendimento
                  And r2.Cd_Conta_Pai = r1.Cd_Reg_Fat
                  And r2.Cd_Multi_Empresa = 4
                  And r2.Sn_Fechada = 'N'
               Union
               Select 1
                 From Dbamv.Reg_Fat r3
                Where r3.Cd_Atendimento = r1.Cd_Atendimento
                  And r3.Cd_Multi_Empresa = 5
                  And r3.Cd_Conta_Pai = r1.Cd_Reg_Fat
                  And r3.Sn_Fechada = 'N')
--                 )
Order By Cd_Reg_Fat

--alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss'
--- Dia 10/11/2008 34 Contas.

/* Begin
  Pkg_Mv2000.Atribui_Empresa( 2 );  -->> Trocar a empresa e rodar uma vez para cada empresa (Caso seja Multi-Empresa
End;*/

--select cd_reg_fat, cd_multi_empresa, sn_fechada, cd_convenio, cd_remessa, sn_fatura_impressa from reg_fat where cd_atendimento = 91098

--select * from remessa_fatura where cd_remessa = 6219

/* select cd_reg_fat, sn_fechada, cd_atendimento, vl_total_conta, dt_inicio, dt_final, cd_convenio, cd_multi_empresa, dt_fechamento, nm_usuario_fechou
 from reg_fat
 where cd_remessa is null
 and vl_total_conta > 0
 and cd_multi_empresa = 2
 order by cd_reg_fat */

--Select sum (Vl_Total_Conta) from (
/*Select Cd_Reg_fat, Cd_Atendimento, Cd_Conta_Pai, Cd_Multi_Empresa, Vl_Total_Conta, Dt_Inicio, Dt_Final, Cd_Convenio
From Reg_Fat
Where Sn_Fechada = 'S'
And Cd_Remessa Is Null
And Cd_Convenio Not In (351,352,378,379)
Order By Cd_Reg_Fat*/
--)


--select * from atendime where cd_atendimento = 100089
--alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss' --- Alterar o formato da data.
--select * from itreg_fat where cd_reg_fat = 60011
--delete from reg_fat where cd_reg_fat = 60011
--delete from itreg_fat where cd_reg_fat = 60011
--delete from it_repasse where cd_reg_fat = 35034
----------------------------------------------Contas Zeradas e Fechadas-----------------------------------------------------------------------------
select cd_reg_fat, dt_inicio, dt_final, cd_atendimento, cd_convenio, cd_remessa, cd_conta_pai, vl_total_conta, cd_multi_empresa, sn_fechada, sn_fatura_impressa
from reg_fat
where cd_multi_empresa in (4,5)
and vl_total_conta < '0,01'
and cd_convenio not in (348,352,379,351)
--and sn_fechada = 'N'
--and sn_fatura_impressa = 'S'
order by 2,4,1
----------------------------------------------------------------------------------------------------------------------------------------------------
Select Cd_Atendimento, Cd_Reg_Fat, Sn_Fechada, Vl_Total_Conta, Cd_Remessa, Cd_Convenio, Dt_Inicio, Dt_Final, Cd_Conta_Pai
     , Dt_Fechamento, Nm_Usuario_Fechou, Cd_Multi_Empresa
From Reg_Fat
Where Cd_Remessa is null
And Vl_Total_Conta > '0'
Order By Cd_Convenio, Cd_Atendimento

