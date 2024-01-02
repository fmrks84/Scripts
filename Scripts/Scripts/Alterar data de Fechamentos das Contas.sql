select * from reg_amb where cd_reg_amb in (23806,26664,28122,23958,25605,44064,44875,44829,43048,49078,50526,48990,46056)
select * from remessa_fatura where cd_remessa in (11503)

alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss' --- Alterar o formato da data.


SELECT * FROM REG_FAT WHERE VL_TOTAL_CONTA IS NULL  AND CD_MULTI_EMPRESA IN (4,5)
AND SN_FECHADA = 'S'

--select sum (total_conta) from (
---------------------------------------------------------Contas Hospitalares-----------------------------------------------------

Select cd_reg_fat conta, sn_fechada fechada, Reg_Fat.Cd_convenio convenio, cd_remessa remessa, dt_inicio inicio, dt_final final
    ,  vl_total_conta total_conta, reg_fat.cd_atendimento atendimento, paciente.nm_paciente paciente, dt_fechamento fechamento
    ,  nm_usuario_fechou usuario, reg_fat.cd_multi_empresa empresa, cd_conta_pai, sn_fechada
From   reg_fat, atendime, paciente
 Where cd_remessa in (
    Select cd_remessa
     From remessa_fatura
      Where cd_fatura in (Select Cd_fatura From Dbamv.Fatura Where to_char(fatura.dt_competencia, 'MM/YYYY') = '02/2012'))
--And   Trunc(reg_fat.Dt_fechamento) Between To_Date('01/12/2011','dd/mm/yyyy') And To_Date('31/12/2011','dd/mm/yyyy') 
--And Dt_fechamento > '31/01/2011 23:59:59'
--And Sn_Fechada = 'N'
And Reg_fat.Cd_Atendimento = Atendime.Cd_Atendimento
And Atendime.Cd_Paciente   = Paciente.Cd_Paciente
And Reg_Fat.Cd_Convenio   Not In (352,379)
--And Reg_Fat.Cd_Multi_Empresa in (1,4,5)
--And Cd_remessa in (31327,31326)
--And Atendime.Cd_Atendimento in (596639,598540,595333,593867,594056)
--And Nm_Usuario_fechou in ('HANANIAS')
Order By 10 Desc--)

Begin
  Pkg_Mv2000.Atribui_Empresa( 1 );  -->> Trocar a empresa e rodar uma vez para cada empresa
End;
--------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT dt_inicio, dt_final, cd_reg_fat, cd_conta_pai, dt_fechamento, cd_multi_empresa, cd_convenio
     , cd_remessa,vl_total_conta, cd_pro_fat_solicitado, cd_pro_fat_realizado, nm_usuario_fechou, sn_fechada
FROM   dbamv.REG_FAT
WHERE  nvl(cd_conta_pai,CD_REG_FAT) in (Select  Nvl(cd_conta_pai,CD_REG_FAT)
                                        From    Dbamv.Reg_Fat, dbamv.atendime, dbamv.paciente
                                        Where   Cd_Remessa in (Select Cd_Remessa
                                                               From   Dbamv.Remessa_Fatura
                                                               Where  Cd_Fatura in (Select Cd_Fatura 
                                                                                    From   Dbamv.Fatura 
                                                                                    Where  to_char(Fatura.Dt_Competencia, 'MM/YYYY') = '12/2011'
                                                                                    And    Cd_Multi_Empresa = 5)
                                                               --And    Cd_Remessa in (31327,31326))
--                                        And Dt_Fechamento > '31/01/2011 23:59:59'
                                        And Reg_Fat.Cd_Atendimento = Atendime.Cd_Atendimento
                                        And Atendime.Cd_Paciente   = Paciente.Cd_Paciente
                                        And Reg_Fat.Cd_Convenio not in(379,352)))
--And Reg_Fat.Cd_Multi_Empresa in (1,4,5)
--And Cd_remessa in (30618,30619,30620)
--And Nm_Usuario_fechou in ('HANANIAS')
Order By 5 Desc--)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------


select cd_convenio, cd_atendimento, dt_inicio, dt_final, cd_reg_fat, cd_conta_pai, dt_fechamento, cd_multi_empresa 
from dbamv.reg_fat where cd_atendimento = 708082



SELECT CD_REMESSA, CD_REG_FAT, DT_INICIO, DT_FINAL, DT_FECHAMENTO, NM_USUARIO_FECHOU
 FROM DBAMV.REG_FAT WHERE NM_USUARIO_FECHOU = 'DBAMV' And Dt_fechamento >= '01/02/2010 23:59:59'

select * from dbamv.fatura  where cd_fatura in (3487,3500)
select * from remessa_fatura where cd_remessa_pai in (18286)

----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------Contas Ambulatoriais----------------------------------------------------------

Select  distinct r.cd_reg_amb, r.sn_fechada, r.vl_total_conta, i.cd_atendimento, dt_fechamento, i.nm_usuario_fechou
 From reg_amb r, itreg_amb i
Where  r.cd_remessa = 19371
And r.cd_reg_amb = i.cd_reg_amb
And i.Dt_fechamento < '30/09/2009 23:59:59'
Order By 5 Desc
-----------------------------------------------------------------------------------------------------------------------------------

Update Reg_Fat Set Dt_fechamento = '30/09/2008 07:20:44' Where Dt_fechamento > '30/09/2008 23:59:59' And Cd_Remessa in (
        Select cd_remessa
     From remessa_fatura
      Where cd_remessa in (11513,11514,11515))

SELECT CD_ATENDIMENTO, CD_REG_FAT, CD_CONTA_PAI, DT_INICIO, DT_FINAL,  DT_FECHAMENTO, CD_MULTI_EMPRESA, SN_FECHADA
FROM DBAMV.REG_FAT WHERE CD_ATENDIMENTO IN (596639,598540,595333,593867,594056)
ORDER BY 1

alter trigger dbamv.trg_vl_total_rfat enable
alter trigger dbamv.trg_vl_total_rfat disable
alter trigger dbamv.trg_reg_fat_existe_nf enable
alter trigger dbamv.trg_reg_fat_existe_nf disable
alter trigger dbamv.trg_reg_fat_dt_inicio enable
alter trigger dbamv.trg_reg_fat_dt_inicio disable
alter trigger dbamv.trg_reg_fat_verifica_remessa enable
alter trigger dbamv.trg_reg_fat_verifica_remessa disable
