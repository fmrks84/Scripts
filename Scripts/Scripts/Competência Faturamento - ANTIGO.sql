SELECT REG_FAT.CD_REG_FAT                                                         Conta
     , REG_FAT.CD_ATENDIMENTO                                                     Atendimento
     , REG_FAT.cd_convenio                                                        Convenio
     , TO_CHAR(FATURA.DT_COMPETENCIA,'MM/YYYY')                                   Comp_R
     , FATURA.CD_MULTI_EMPRESA, 'HOSP.'                                           Tipo
     , REG_FAT.VL_TOTAL_CONTA                                                     Tt_Conta
     , REG_FAT.DT_FECHAMENTO                                                      Dt_Fecha
     , REG_FAT.nm_usuario_fechou                                                  Usuario
     , TO_CHAR(REG_FAT.DT_FECHAMENTO,'MM/YYYY')                                   Comp_F
     , REMESSA_FATURA.CD_REMESSA                                                  Remessa
     , REG_FAT.SN_FECHADA                                                         Fec

FROM DBAMV.REG_FAT,
     DBAMV.REMESSA_FATURA,
     DBAMV.FATURA

WHERE
TO_CHAR(REG_FAT.DT_FECHAMENTO,'MM/YYYY') = '01/2014'  --- Competencias das Contas
--TO_CHAR(FATURA.DT_COMPETENCIA,'MM/YYYY') = '10/2013' --- Competencia das Remessas
AND REG_FAT.CD_REMESSA = REMESSA_FATURA.CD_REMESSA (+)
AND REMESSA_FATURA.CD_FATURA = FATURA.CD_FATURA(+)
AND REG_FAT.CD_CONVENIO NOT IN (352,379,378)
AND REG_FAT.VL_TOTAL_CONTA > '0,0'
--AND REG_FAT.SN_FECHADA = 'S'
--AND TO_CHAR(FATURA.DT_COMPETENCIA,'MM/YYYY') <> TO_CHAR(REG_FAT.DT_FECHAMENTO,'MM/YYYY')

UNION ALL

SELECT ITREG_AMB.CD_REG_AMB                                                       Conta
     , ITREG_AMB.CD_ATENDIMENTO                                                   Atendimento
     , REG_AMB.cd_convenio                                                        Convenio
     , TO_CHAR(FATURA.DT_COMPETENCIA,'MM/YYYY')                                   Comp_R
     , FATURA.CD_MULTI_EMPRESA, 'AMBU.'                                           Tipo
     , SUM(ITREG_AMB.VL_TOTAL_CONTA)                                              Tt_Conta
     , ITREG_AMB.DT_FECHAMENTO                                                    Dt_Fecha
     , ITREG_AMB.nm_usuario_fechou                                                Usuario
     , TO_CHAR(ITREG_AMB.DT_FECHAMENTO,'MM/YYYY')                                 Comp_F
     , REMESSA_FATURA.CD_REMESSA                                                  Remessa
     , REG_AMB.SN_FECHADA                                                         Fec

FROM DBAMV.REG_AMB,
     DBAMV.ITREG_AMB,
     DBAMV.REMESSA_FATURA,
     DBAMV.FATURA
WHERE
TO_CHAR(ITREG_AMB.DT_FECHAMENTO,'MM/YYYY') = '01/2014'  --- Competencias das Contas
--TO_CHAR(FATURA.DT_COMPETENCIA,'MM/YYYY') = '10/2013'  --- Competencia das Remessas
AND  REG_AMB.CD_REMESSA = REMESSA_FATURA.CD_REMESSA (+)
AND  ITREG_AMB.CD_REG_AMB = REG_AMB.CD_REG_AMB
AND  REMESSA_FATURA.CD_FATURA = FATURA.CD_FATURA
AND  REG_AMB.CD_CONVENIO NOT IN (352,379,378)
--AND  REG_AMB.VL_TOTAL_CONTA > '0,0'
--AND  REG_AMB.SN_FECHADA  = 'S'
--AND  TO_CHAR(FATURA.DT_COMPETENCIA,'MM/YYYY') <> TO_CHAR(ITREG_AMB.DT_FECHAMENTO,'MM/YYYY')

GROUP BY ITREG_AMB.CD_REG_AMB
       , ITREG_AMB.CD_ATENDIMENTO
       , REG_AMB.cd_convenio
       , FATURA.CD_MULTI_EMPRESA
       , ITREG_AMB.DT_FECHAMENTO
       , ITREG_AMB.nm_usuario_fechou
       , REMESSA_FATURA.CD_REMESSA
       , TO_CHAR(FATURA.DT_COMPETENCIA,'MM/YYYY')
       , REG_AMB.sn_fechada
ORDER BY 8 DESC
