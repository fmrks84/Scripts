/*
C1902/6246
C1907/12955
C2106/7087
C2106/12553
*/

SELECT V.*, ATENDIME.TP_ATENDIMENTO

FROM (

SELECT PRO_FAT.CD_PRO_FAT              CD_PRO_FAT
        ,PRO_FAT.DS_PRO_FAT              DS_PRO_FAT
        ,ITREG_FAT.DT_LANCAMENTO         DT_LANCAMENTO
        ,ATENDIME.CD_ATENDIMENTO         CD_ATENDIMENTO
        ,ATENDIME.CD_PACIENTE            CD_PACIENTE
        ,CONVENIO.NM_CONVENIO            CONVENIO
        ,REG_FAT.CD_REG_FAT              CONTA
      --  ,PACIENTE.NM_PACIENTE            NM_PACIENTE

        , CASE WHEN PACIENTE.SN_UTILIZA_NOME_SOCIAL = 'S' 
     AND PACIENTE.NM_SOCIAL_PACIENTE IS NOT NULL THEN 'SOCIAL: '||PACIENTE.NM_SOCIAL_PACIENTE 
ELSE PACIENTE.NM_PACIENTE END NM_PACIENTE

        ,ITREG_FAT.QT_LANCAMENTO         QT_LANCAMENTO
        ,ITREG_FAT.VL_UNITARIO           VL_UNITARIO
        ,ITREG_FAT.SN_REPASSADO          REPASSE
        ,ITREG_FAT.VL_TOTAL_CONTA         VALOR_TOTAL
        ,Decode(dbamv.fnc_ffcv_tem_filho_distribui(itreg_fat.cd_reg_fat ,itreg_fat.cd_lancamento, 'H'),'N',ITREG_FAT.VL_TOTAL_CONTA,
                                                                                                            (ITREG_FAT.VL_TOTAL_CONTA + ITREG_FAT.VL_DESCONTO_CONTA))VALOR_TOTAL
              ,ITREG_FAT.CD_LANCAMENTO         CD_LANCAMENTO
FROM    DBAMV.REG_FAT               REG_FAT
         ,DBAMV.CONVENIO                   CONVENIO
         ,DBAMV.ITREG_FAT                  ITREG_FAT
         ,DBAMV.PRO_FAT                     PRO_FAT
         ,DBAMV.REMESSA_FATURA    REMESSA
         ,DBAMV.FATURA                       FATURA
         ,DBAMV.ATENDIME                   ATENDIME
         ,DBAMV.PACIENTE                    PACIENTE
       ,dbamv.empresa_convenio
Where Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
And Empresa_Convenio.Cd_Multi_Empresa = {cdMultiEmpresa}
and REG_FAT.CD_REG_FAT         = ITREG_FAT.CD_REG_FAT
AND    REG_FAT.CD_ATENDIMENTO   = ATENDIME.CD_ATENDIMENTO
AND    ATENDIME.CD_PACIENTE         = PACIENTE.CD_PACIENTE
AND    REG_FAT.CD_CONVENIO          = CONVENIO.CD_CONVENIO
AND    REG_FAT.CD_REMESSA           = REMESSA.CD_REMESSA(+)
AND    REMESSA.CD_FATURA             = FATURA.CD_FATURA(+)
AND    ITREG_FAT.CD_PRO_FAT         = PRO_FAT.CD_PRO_FAT
AND    NVL(REG_FAT.SN_DIAGNO, 'N') = 'N'
--AND    ITREG_FAT.SN_PERTENCE_PACOTE = 'N'
AND   REG_FAT.CD_CONVENIO NOT IN (5,9) -- Incluir 
AND   NVL(ITREG_FAT.TP_PAGAMENTO,'X') <> 'C'
AND   REG_FAT.CD_MULTI_EMPRESA =  {cdMultiEmpresa}
AND   CONVENIO.TP_CONVENIO NOT IN ('H', 'A')
AND   ITREG_FAT.CD_SETOR  = 39
ITREG_FAT.DT_LANCAMENTO >= TO_DATE
AND ('01/07/2021'/*@DT_INI*/,'DD/MM/RRRR HH24:MI:SS')
AND ITREG_FAT.DT_LANCAMENTO <  TO_DATE('27/07/2021'/*@DT_FIM*/,'DD/MM/RRRR HH24:MI:SS') + 1
AND ATENDIME.CD_CONVENIO IN ({CD_CONVENIO_AUX})
AND NVL(ITREG_FAT.CD_PRESTADOR,0) = NVL('{NM_PRESTADOR}',NVL(ITREG_FAT.CD_PRESTADOR,0)) --C2106/7087
AND ATENDIME.TP_ATENDIMENTO IN ({V_TP_ATEND_AUX}) --C2106/12553

/*OP 40082/41754 - nao exibir itens distribuicao*/
/*'fQuebrGuia' essa opção nao entra pois é uma nova conta com os itens originais*/
AND   ITREG_FAT.cd_lancamento NOT IN (SELECT i.cd_lancamento
                                          FROM dbamv.reg_fat r,
                                               dbamv.itreg_fat i
                                          WHERE r.cd_reg_fat = i.cd_reg_Fat
                                            AND r.cd_reg_fat = REG_FAT.cd_reg_fat
                                            AND r.tp_mvto IN ('fDistribui','fQuebraDis')
                                            AND i.cd_reg_fat_pai IS NOT null
                                            )
/*OP 40082/41754 - nao exibir itens distribuicao*/

UNION ALL

SELECT  PRO_FAT.CD_PRO_FAT                   CD_PRO_FAT
        ,PRO_FAT.DS_PRO_FAT                    DS_PRO_FAT
        ,ATENDIME.DT_ATENDIMENTO           DT_LANCAMENTO
        ,ATENDIME.CD_ATENDIMENTO        CD_ATENDIMENTO
        ,ATENDIME.CD_PACIENTE            CD_PACIENTE
        ,CONVENIO.NM_CONVENIO            CONVENIO
        ,REG_AMB.CD_REG_AMB                  CONTA
--,PACIENTE.NM_PACIENTE                 NM_PACIENTE

         , CASE WHEN PACIENTE.SN_UTILIZA_NOME_SOCIAL = 'S' 
     AND PACIENTE.NM_SOCIAL_PACIENTE IS NOT NULL THEN 'SOCIAL: '||PACIENTE.NM_SOCIAL_PACIENTE 
ELSE PACIENTE.NM_PACIENTE END NM_PACIENTE


        ,ITREG_AMB.QT_LANCAMENTO       QT_LANCAMENTO
        ,ITREG_AMB.VL_UNITARIO                VL_UNITARIO
        ,ITREG_AMB.SN_REPASSADO              REPASSE
        ,ITREG_AMB.VL_TOTAL_CONTA       VALOR_TOTAL
        ,Decode(dbamv.fnc_ffcv_tem_filho_distribui(itreg_amb.cd_reg_amb ,itreg_amb.cd_lancamento, 'A'),'N',ITREG_AMB.VL_TOTAL_CONTA,
                                                                                                    (ITREG_AMB.VL_TOTAL_CONTA + ITREG_AMB.VL_DESCONTO_CONTA))VALOR_TOTAL
        ,0 CD_LANCAMENTO
FROM          DBAMV.REG_AMB                     REG_AMB
             ,DBAMV.CONVENIO                    CONVENIO
             ,DBAMV.ITREG_AMB                  ITREG_AMB
             ,DBAMV.PRO_FAT                      PRO_FAT
             ,DBAMV.REMESSA_FATURA     REMESSA
             ,DBAMV.FATURA                        FATURA
             ,DBAMV.ATENDIME                    ATENDIME
             ,DBAMV.PACIENTE                     PACIENTE
       ,dbamv.empresa_convenio
Where Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
And Empresa_Convenio.Cd_Multi_Empresa = {cdMultiEmpresa}
and REG_AMB.CD_REG_AMB           = ITREG_AMB.CD_REG_AMB
AND    ITREG_AMB.CD_ATENDIMENTO  = ATENDIME.CD_ATENDIMENTO
AND    ATENDIME.CD_PACIENTE             = PACIENTE.CD_PACIENTE
AND    ITREG_AMB.CD_CONVENIO          = CONVENIO.CD_CONVENIO
AND    REG_AMB.CD_REMESSA               = REMESSA.CD_REMESSA(+)
AND    REMESSA.CD_FATURA                  = FATURA.CD_FATURA(+)
AND    ITREG_AMB.CD_PRO_FAT             = PRO_FAT.CD_PRO_FAT
AND    NVL(REG_AMB.SN_DIAGNO, 'N') = 'N'
--AND    ITREG_AMB.SN_PERTENCE_PACOTE = 'N'
AND   REG_AMB.CD_CONVENIO NOT IN (5,9) -- Incluir 
AND   NVL(ITREG_AMB.TP_PAGAMENTO,'X') <> 'C'
AND   REG_AMB.CD_MULTI_EMPRESA = {cdMultiEmpresa}
AND   CONVENIO.TP_CONVENIO NOT IN ('H', 'A')
AND   ITREG_AMB.CD_SETOR = 39

AND ATENDIME.DT_ATENDIMENTO >= TO_DATE(@DT_INI,'DD/MM/RRRR HH24:MI:SS')
AND ATENDIME.DT_ATENDIMENTO <  TO_DATE(@DT_FIM,'DD/MM/RRRR HH24:MI:SS') + 1
AND ATENDIME.CD_CONVENIO IN ({CD_CONVENIO_AUX})
AND NVL(ITREG_AMB.CD_PRESTADOR,0) = NVL('{NM_PRESTADOR}',NVL(ITREG_AMB.CD_PRESTADOR,0)) --C2106/7087
AND ATENDIME.TP_ATENDIMENTO IN ({V_TP_ATEND_AUX})  --C2106/12553

/*OP 40082/41754 - nao exibir itens distribuicao*/
/*'fQuebrGuia' essa opção nao entra pois é uma nova conta com os itens originais*/
AND   ITREG_AMB.cd_lancamento NOT IN (SELECT cd_lancamento
                                          FROM dbamv.reg_amb r,
                                               dbamv.itreg_amb i
                                          WHERE r.cd_reg_amb = i.cd_reg_amb
                                            AND r.cd_reg_amb = REG_AMB.cd_reg_amb
                                            AND i.tp_mvto_desconto IN ('fDistribui','fQuebraDis')
                                            AND i.cd_reg_amb_pai IS NOT null
                                            )
/*OP 40082/41754 - nao exibir itens distribuicao*/


-- INICIO union para trazer somente o convenio Cabesp e Amil item SN_PERTENCE_PACOTE = 'N'
UNION ALL

SELECT         PRO_FAT.CD_PRO_FAT              CD_PRO_FAT
              ,PRO_FAT.DS_PRO_FAT              DS_PRO_FAT
              ,ITREG_FAT.DT_LANCAMENTO         DT_LANCAMENTO
              ,ATENDIME.CD_ATENDIMENTO         CD_ATENDIMENTO
              ,ATENDIME.CD_PACIENTE            CD_PACIENTE
              ,CONVENIO.NM_CONVENIO            CONVENIO
              ,REG_FAT.CD_REG_FAT              CONTA
             -- ,PACIENTE.NM_PACIENTE            NM_PACIENTE


               ,CASE WHEN PACIENTE.SN_UTILIZA_NOME_SOCIAL = 'S' 
     AND PACIENTE.NM_SOCIAL_PACIENTE IS NOT NULL THEN 'SOCIAL: '||PACIENTE.NM_SOCIAL_PACIENTE 
ELSE PACIENTE.NM_PACIENTE END NM_PACIENTE


              ,ITREG_FAT.QT_LANCAMENTO         QT_LANCAMENTO
              ,ITREG_FAT.VL_UNITARIO           VL_UNITARIO
              ,ITREG_FAT.SN_REPASSADO          REPASSE
              /*,ITREG_FAT.VL_TOTAL_CONTA         VALOR_TOTAL*/
        ,Decode(dbamv.fnc_ffcv_tem_filho_distribui(itreg_fat.cd_reg_fat ,itreg_fat.cd_lancamento, 'H'),'N',ITREG_FAT.VL_TOTAL_CONTA,
                                                                                                            (ITREG_FAT.VL_TOTAL_CONTA + ITREG_FAT.VL_DESCONTO_CONTA))VALOR_TOTAL
              ,ITREG_FAT.CD_LANCAMENTO         CD_LANCAMENTO
FROM    DBAMV.REG_FAT               REG_FAT
         ,DBAMV.CONVENIO                   CONVENIO
         ,DBAMV.ITREG_FAT                  ITREG_FAT
         ,DBAMV.PRO_FAT                     PRO_FAT
         ,DBAMV.REMESSA_FATURA    REMESSA
         ,DBAMV.FATURA                       FATURA
         ,DBAMV.ATENDIME                   ATENDIME
         ,DBAMV.PACIENTE                    PACIENTE
       ,dbamv.empresa_convenio
Where Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
And Empresa_Convenio.Cd_Multi_Empresa = {cdMultiEmpresa}
and REG_FAT.CD_REG_FAT         = ITREG_FAT.CD_REG_FAT
AND    REG_FAT.CD_ATENDIMENTO   = ATENDIME.CD_ATENDIMENTO
AND    ATENDIME.CD_PACIENTE         = PACIENTE.CD_PACIENTE
AND    REG_FAT.CD_CONVENIO          = CONVENIO.CD_CONVENIO
AND    REG_FAT.CD_REMESSA           = REMESSA.CD_REMESSA(+)
AND    REMESSA.CD_FATURA             = FATURA.CD_FATURA(+)
AND    ITREG_FAT.CD_PRO_FAT         = PRO_FAT.CD_PRO_FAT
AND    NVL(REG_FAT.SN_DIAGNO, 'N') = 'N'
AND    ITREG_FAT.SN_PERTENCE_PACOTE = 'N'-- habilitar 
AND   NVL(ITREG_FAT.TP_PAGAMENTO,'X') <> 'C'
AND   REG_FAT.Cd_Multi_Empresa = {cdMultiEmpresa}
AND   CONVENIO.TP_CONVENIO NOT IN ('H', 'A')
AND   ITREG_FAT.CD_SETOR  = 39
AND   reg_fat.cd_convenio in (5,9) --incluir 

AND ITREG_FAT.DT_LANCAMENTO >= TO_DATE(@DT_INI,'DD/MM/RRRR HH24:MI:SS')
AND ITREG_FAT.DT_LANCAMENTO <  TO_DATE(@DT_FIM,'DD/MM/RRRR HH24:MI:SS') + 1
AND ATENDIME.CD_CONVENIO IN ({CD_CONVENIO_AUX})
AND NVL(ITREG_FAT.CD_PRESTADOR,0) = NVL('{NM_PRESTADOR}',NVL(ITREG_FAT.CD_PRESTADOR,0)) --C2106/7087
AND ATENDIME.TP_ATENDIMENTO IN ({V_TP_ATEND_AUX}) --C2106/12553

/*OP 40082/41754 - nao exibir itens distribuicao*/
/*'fQuebrGuia' essa opção nao entra pois é uma nova conta com os itens originais*/
AND   ITREG_FAT.cd_lancamento NOT IN (SELECT i.cd_lancamento
                                          FROM dbamv.reg_fat r,
                                               dbamv.itreg_fat i
                                          WHERE r.cd_reg_fat = i.cd_reg_Fat
                                            AND r.cd_reg_fat = REG_FAT.cd_reg_fat
                                            AND r.tp_mvto IN ('fDistribui','fQuebraDis')
                                            AND i.cd_reg_fat_pai IS NOT null
                                            )
/*OP 40082/41754 - nao exibir itens distribuicao*/

UNION ALL

SELECT  PRO_FAT.CD_PRO_FAT                   CD_PRO_FAT
              ,PRO_FAT.DS_PRO_FAT                    DS_PRO_FAT
              ,ATENDIME.DT_ATENDIMENTO           DT_LANCAMENTO
              ,ATENDIME.CD_ATENDIMENTO        CD_ATENDIMENTO
              ,ATENDIME.CD_PACIENTE            CD_PACIENTE
              ,CONVENIO.NM_CONVENIO            CONVENIO
              ,REG_AMB.CD_REG_AMB                  CONTA
            --  ,PACIENTE.NM_PACIENTE                 NM_PACIENTE

                ,CASE WHEN PACIENTE.SN_UTILIZA_NOME_SOCIAL = 'S' 
     AND PACIENTE.NM_SOCIAL_PACIENTE IS NOT NULL THEN 'SOCIAL: '||PACIENTE.NM_SOCIAL_PACIENTE 
ELSE PACIENTE.NM_PACIENTE END NM_PACIENTE


              ,ITREG_AMB.QT_LANCAMENTO       QT_LANCAMENTO
              ,ITREG_AMB.VL_UNITARIO                VL_UNITARIO
              ,ITREG_AMB.SN_REPASSADO              REPASSE
              ,ITREG_AMB.VL_TOTAL_CONTA       VALOR_TOTAL
        ,Decode(dbamv.fnc_ffcv_tem_filho_distribui(itreg_amb.cd_reg_amb ,itreg_amb.cd_lancamento, '{V_TP_ATEND}'),'N',ITREG_AMB.VL_TOTAL_CONTA,
                                                                                                            (ITREG_AMB.VL_TOTAL_CONTA + ITREG_AMB.VL_DESCONTO_CONTA))VALOR_TOTAL
              ,0 CD_LANCAMENTO
FROM          DBAMV.REG_AMB                     REG_AMB
             ,DBAMV.CONVENIO                    CONVENIO
             ,DBAMV.ITREG_AMB                  ITREG_AMB
             ,DBAMV.PRO_FAT                      PRO_FAT
             ,DBAMV.REMESSA_FATURA     REMESSA
             ,DBAMV.FATURA                        FATURA
             ,DBAMV.ATENDIME                    ATENDIME
             ,DBAMV.PACIENTE                     PACIENTE
       ,dbamv.empresa_convenio
Where Empresa_Convenio.Cd_Convenio = Convenio.Cd_Convenio
And Empresa_Convenio.Cd_Multi_Empresa = {cdMultiEmpresa}
and REG_AMB.CD_REG_AMB           = ITREG_AMB.CD_REG_AMB
AND    ITREG_AMB.CD_ATENDIMENTO  = ATENDIME.CD_ATENDIMENTO
AND    ATENDIME.CD_PACIENTE             = PACIENTE.CD_PACIENTE
AND    ITREG_AMB.CD_CONVENIO          = CONVENIO.CD_CONVENIO
AND    REG_AMB.CD_REMESSA               = REMESSA.CD_REMESSA(+)
AND    REMESSA.CD_FATURA                  = FATURA.CD_FATURA(+)
AND    ITREG_AMB.CD_PRO_FAT             = PRO_FAT.CD_PRO_FAT
AND    NVL(REG_AMB.SN_DIAGNO, 'N') = 'N'
AND    ITREG_AMB.SN_PERTENCE_PACOTE = 'N' -- habilitar
AND    NVL(ITREG_AMB.TP_PAGAMENTO,'X') <> 'C'
AND   REG_AMB.Cd_Multi_Empresa = {cdMultiEmpresa}
AND   CONVENIO.TP_CONVENIO NOT IN ('H', 'A')
AND   ITREG_AMB.CD_SETOR = 39
AND   reg_amb.cd_convenio  IN (5,9) -- Incluir 

AND ATENDIME.DT_ATENDIMENTO >= TO_DATE(@DT_INI,'DD/MM/RRRR HH24:MI:SS')
AND ATENDIME.DT_ATENDIMENTO <  TO_DATE(@DT_FIM,'DD/MM/RRRR HH24:MI:SS') + 1
AND ATENDIME.CD_CONVENIO IN ({CD_CONVENIO_AUX})
AND NVL(ITREG_AMB.CD_PRESTADOR,0) = NVL('{NM_PRESTADOR}',NVL(ITREG_AMB.CD_PRESTADOR,0)) --C2106/7087
AND ATENDIME.TP_ATENDIMENTO IN ({V_TP_ATEND_AUX}) --C2106/12553

/*OP 40082/41754 - nao exibir itens distribuicao*/
/*'fQuebrGuia' essa opção nao entra pois é uma nova conta com os itens originais*/
AND   ITREG_AMB.cd_lancamento NOT IN (SELECT cd_lancamento
                                          FROM dbamv.reg_amb r,
                                               dbamv.itreg_amb i
                                          WHERE r.cd_reg_amb = i.cd_reg_amb
                                            AND r.cd_reg_amb = REG_AMB.cd_reg_amb
                                            AND i.tp_mvto_desconto IN ('fDistribui','fQuebraDis')
                                            AND i.cd_reg_amb_pai IS NOT null
                                            )
/*OP 40082/41754 - nao exibir itens distribuicao*/
-- FIM union para trazer somente o convenio Cabesp e Amil item SN_PERTENCE_PACOTE = 'N'


) V, DBAMV.ATENDIME
WHERE V.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO
AND V.DT_LANCAMENTO >= TO_DATE(@DT_INI,'DD/MM/RRRR HH24:MI:SS')
AND V.DT_LANCAMENTO <  TO_DATE(@DT_FIM,'DD/MM/RRRR HH24:MI:SS') + 1
--AND ROWNUM <= 50
AND v.cd_pro_fat IN ('10000274','10000275')

ORDER BY V.CONVENIO, V.CD_ATENDIMENTO
