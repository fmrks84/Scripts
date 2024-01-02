
-- Start of DDL script for VDIC_DELBONI_PZ_HMSJ
-- Generated 4-jan-07  11:57:55 am
-- from PRODUCAO-DBAMV:1

-- View VDIC_DELBONI_PZ_HMSJ

CREATE OR REPLACE VIEW vdic_delboni_pz_hmsj (
   prescricao,
   atendimento,
   nome_paciente,
   codigo_convenio,
   nome_convenio,
   itpre_med,
   tipo_prescricao,
   cd_ped_lab,
   cd_exa_lab,
   cd_itped_lab,
   cd_reg_fat,
   laboratorio,
   cd_conta_pai,
   reg_fat_multi_empresa,
   proced_cobrado,
   proced_solicitado,
   data_lancamento,
   atendime_cd_multi_empresa,
   nome_procedimento )
AS
Select Pre_Med.Cd_Pre_Med                                                        PRESCRICAO
     , Ped_Lab.Cd_Atendimento                                                    ATENDIMENTO
     , Paciente.Nm_Paciente                                                      NOME_PACIENTE
     , Reg_Fat.Cd_Convenio                                                       CODIGO_CONVENIO
     , Convenio.Nm_Convenio                                                      NOME_CONVENIO
     , ItPre_Med.Cd_ItPre_Med                                                    ITPRE_MED
     , ItPre_Med.Cd_Tip_Presc                                                    TIPO_PRESCRICAO
     , Ped_Lab.Cd_Ped_Lab                                                        CD_PED_LAB
     , ItPed_Lab.Cd_Exa_Lab                                                      CD_EXA_LAB
     , ItPed_Lab.Cd_ItPed_Lab                                                    CD_ITPED_LAB
     , Reg_Fat.Cd_Reg_Fat                                                        CD_REG_FAT
     , ItPed_Lab.Cd_Laboratorio                                                  LABORATORIO
     , Reg_Fat.Cd_Conta_Pai                                                      CD_CONTA_PAI
     , Reg_Fat.Cd_Multi_Empresa                                                  REG_FAT_MULTI_EMPRESA
     , Exa_Lab.Cd_Pro_Fat                                                        PROCED_COBRADO
     , '281404168'                                                               PROCED_SOLICITADO
     , trunc(itreg_fat.dt_lancamento)                                            DATA_LANCAMENTO
     , Atendime.Cd_Multi_Empresa                                                 ATENDIME_CD_MULTI_EMPRESA
     , Pro_Fat.Ds_Pro_Fat                                                        NOME_PROCEDIMENTO

From   Pre_Med
     , ItPre_Med
     , Ped_Lab
     , ItPed_Lab
     , Reg_Fat
     , ItReg_Fat
     , Exa_Lab
     , Atendime
     , Paciente
     , Convenio
     , Pro_Fat

Where Pre_Med.Cd_Pre_Med          =   ItPre_Med.Cd_Pre_Med
And   Atendime.Cd_Atendimento     =   Ped_Lab.Cd_Atendimento
And   Paciente.Cd_Paciente        =   Atendime.Cd_Paciente
And   Pre_Med.Cd_Pre_Med          =   Ped_Lab.Cd_Pre_Med
And   Pre_Med.Cd_Atendimento      =   Ped_Lab.Cd_Atendimento
And   Ped_Lab.Cd_Ped_Lab          =   ItPed_Lab.Cd_Ped_Lab
And   ItPed_Lab.Cd_Ped_Lab        =   ItReg_Fat.Cd_Mvto
And   ItPed_Lab.Cd_ItPed_Lab      =   ItReg_Fat.Cd_ItMvto
And   Reg_Fat.Cd_Multi_Empresa    =   ItReg_Fat.Cd_Multi_Empresa
And   Reg_Fat.Cd_Conta_Pai        =   ItReg_Fat.Cd_Conta_Pai
And   Reg_Fat.Cd_Conta_Pai      =   18629
And   Reg_Fat.Cd_Multi_Empresa    =    4
And   ItPre_Med.Cd_Tip_Esq        =   'LAB'
And   ItPre_Med.Cd_Tip_Presc      In  (66195,65802)
And   Reg_Fat.Cd_Conta_Pai        Is Not Null
And   Exa_Lab.Cd_Pro_Fat          =    ItReg_Fat.Cd_Pro_Fat
And   Pro_fat.Cd_Pro_Fat          =    Exa_Lab.Cd_Pro_Fat
And   Exa_Lab.Cd_Exa_Lab          =    ItPed_Lab.Cd_Exa_Lab
And   Convenio.Cd_Convenio        =    Reg_Fat.Cd_Convenio
And   Atendime.Cd_Multi_Empresa   =    1 --Santa Joana--
And   Pre_Med.Cd_Atendimento      =    50640
And   ItPed_Lab.Cd_Laboratorio    in   50  
/

-- Grants for DELBONI_PZ_HMSJ

GRANT SELECT ON vdic_delboni_pz_hmsj TO dbaps
/
GRANT SELECT ON vdic_delboni_pz_hmsj TO dbasgu
/
GRANT SELECT ON vdic_delboni_pz_hmsj TO mvintegra
/
GRANT SELECT ON vdic_delboni_pz_hmsj TO mv2000
/

-- End of DDL script for DELBONI_PZ_HMSJ
