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
--TO_CHAR(REG_FAT.DT_FECHAMENTO,'MM/YYYY') = '10/2012'  --- Competencias das Contas
TO_CHAR(FATURA.DT_COMPETENCIA,'MM/YYYY') = '10/2012' --- Competencia das Remessas
AND REG_FAT.CD_REMESSA = REMESSA_FATURA.CD_REMESSA
AND REMESSA_FATURA.CD_FATURA = FATURA.CD_FATURA
--AND REG_FAT.CD_CONVENIO NOT IN (352,379,378)
AND REG_FAT.VL_TOTAL_CONTA > '0,0'
AND REG_FAT.SN_FECHADA = 'S'
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
--TO_CHAR(ITREG_AMB.DT_FECHAMENTO,'MM/YYYY') = '10/2012'  --- Competencias das Contas
TO_CHAR(FATURA.DT_COMPETENCIA,'MM/YYYY') = '10/2012'  --- Competencia das Remessas
AND  REG_AMB.CD_REMESSA = REMESSA_FATURA.CD_REMESSA
AND  ITREG_AMB.SN_PERTENCE_PACOTE = 'N'
AND  NVL(ITREG_AMB.TP_PAGAMENTO,'X') <> 'C'
AND  ITREG_AMB.CD_REG_AMB = REG_AMB.CD_REG_AMB
AND  REMESSA_FATURA.CD_FATURA = FATURA.CD_FATURA
--AND  REG_AMB.CD_CONVENIO NOT IN (352,379,378)
AND  REG_AMB.VL_TOTAL_CONTA > '0,0'
AND  REG_AMB.SN_FECHADA  = 'S'
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



--------------------------------------------------------------------------------
SELECT REG_FAT.CD_REMESSA, FATURA.dt_competencia, REG_FAT.SN_FECHADA, CD_REG_FAT, CD_CONTA_PAI, REG_FAT.CD_MULTI_EMPRESA, REG_FAT.CD_CONVENIO, DT_INICIO, DT_FINAL, REG_FAT.DT_FECHAMENTO, REG_FAT.vl_total_conta
FROM DBAMV.REG_FAT, DBAMV.REMESSA_FATURA, DBAMV.FATURA
WHERE REG_FAT.cd_remessa IS NOT NULL
AND   REMESSA_FATURA.cd_remessa = REG_FAT.cd_remessa
AND   REMESSA_FATURA.cd_fatura  = FATURA.cd_fatura
AND   FATURA.cd_convenio = REG_FAT.cd_convenio
AND REG_FAT.CD_CONVENIO NOT IN (352,379,378,351)
ORDER BY DT_FECHAMENTO DESC


SELECT DT_FECHAMENTO, SN_FECHADA, CD_MULTI_EMPRESA, CD_REG_FAT, DT_INICIO, DT_FINAL, VL_TOTAL_CONTA, CD_REMESSA, CD_CONTA_PAI 
FROM DBAMV.REG_FAT 
WHERE (CD_REG_FAT) IN (409162,409163,409164,409165,409166,409167,590814,592022,598388,598532,603401,603409
                                       ,604093,604207,605964,609818,609820)
--WHERE (CD_REG_FAT) IN (547188)


SELECT dt_fechamento FROM DBAMV.itREG_AMB
WHERE CD_REG_AMB IN (409167,409165,409164,409166,409162,409163)


SELECT * FROM DBAMV.REMESSA_FATURA WHERE nvl (CD_REMESSA_pai, cd_remessa) IN (38383,38347)

SELECT * FROM DBAMV.FATURA WHERE CD_FATURA IN ()
