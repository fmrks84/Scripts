Select * From (
Select Tabela.*
     , Versao_730.Vl_Medicamento Versao_730
     , Versao_739.Vl_Medicamento Versao_739
     , Round((Nvl(Versao_739.Vl_Medicamento, 0) - Nvl(Versao_730.Vl_Medicamento, 0)), 2) Vl_Diferenca
  From (SELECT B_PRECOS.cd_medicamento
             , B_MEDICAME.ds_medicamento 
             , B_PRECOS.cd_apresentacao
             , B_APRES.ds_apresentacao
             , B_PRECOS.cd_laboratorio
             , B_LABORA.ds_laboratorio
          FROM DBAMV.B_PRECOS
             , DBAMV.B_APRES
             , B_LABORA
             , B_MEDICAME
             , DBAMV.LOG_BRASINDICE
         WHERE B_PRECOS.CD_IMPORT In ( 98 )
           AND B_PRECOS.cd_apresentacao = B_APRES.cd_apresentacao
           AND B_PRECOS.cd_laboratorio  = B_LABORA.cd_laboratorio
           AND B_PRECOS.cd_medicamento  = B_MEDICAME.cd_medicamento
           AND B_PRECOS.cd_import       = LOG_BRASINDICE.cd_import ) Tabela
     , (SELECT B_PRECOS.cd_medicamento
             , B_MEDICAME.ds_medicamento 
             , B_PRECOS.cd_apresentacao
             , B_APRES.ds_apresentacao
             , B_PRECOS.cd_laboratorio
             , B_LABORA.ds_laboratorio
             , B_PRECOS.vl_medicamento
          FROM DBAMV.B_PRECOS
             , DBAMV.B_APRES
             , B_LABORA
             , B_MEDICAME
             , DBAMV.LOG_BRASINDICE
         WHERE B_PRECOS.CD_IMPORT = 90
           AND B_PRECOS.cd_apresentacao = B_APRES.cd_apresentacao
           AND B_PRECOS.cd_laboratorio  = B_LABORA.cd_laboratorio
           AND B_PRECOS.cd_medicamento  = B_MEDICAME.cd_medicamento
           AND B_PRECOS.cd_import       = LOG_BRASINDICE.cd_import ) Versao_730
     , (SELECT B_PRECOS.cd_medicamento
             , B_MEDICAME.ds_medicamento 
             , B_PRECOS.cd_apresentacao
             , B_APRES.ds_apresentacao
             , B_PRECOS.cd_laboratorio
             , B_LABORA.ds_laboratorio
             , B_PRECOS.vl_medicamento
          FROM DBAMV.B_PRECOS
             , DBAMV.B_APRES
             , B_LABORA
             , B_MEDICAME
             , DBAMV.LOG_BRASINDICE
         WHERE B_PRECOS.CD_IMPORT = 98
           AND B_PRECOS.cd_apresentacao = B_APRES.cd_apresentacao
           AND B_PRECOS.cd_laboratorio  = B_LABORA.cd_laboratorio
           AND B_PRECOS.cd_medicamento  = B_MEDICAME.cd_medicamento
           AND B_PRECOS.cd_import       = LOG_BRASINDICE.cd_import) Versao_739
  Where Tabela.cd_medicamento  = Versao_739.cd_medicamento(+)
    And Tabela.cd_apresentacao = Versao_739.cd_apresentacao(+)
    And Tabela.cd_laboratorio  = Versao_739.cd_laboratorio(+)
    And Tabela.cd_medicamento  = Versao_730.cd_medicamento(+)
    And Tabela.cd_apresentacao = Versao_730.cd_apresentacao(+)
    And Tabela.cd_laboratorio  = Versao_730.cd_laboratorio(+)
) Tabela2
Where Vl_Diferenca <> 0

