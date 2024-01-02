      SELECT  'A Receber' AS TIPO,
                DECODE(TP_CON_REC,'P', 999999, CD_FORNECEDOR) CD_FORNECEDOR,
                NM_FORNECEDOR,
                NM_CLIENTE,
                TIPO_CLIENTE,
                DECODE(TP_CON_REC,'P', 999999, NVL( CD_CONVENIO, CD_FORNECEDOR )) CD_CONVENIO,
                NM_CONVENIO,
                CD_NOTA_FISCAL,
                NR_DOCUMENTO,
                NR_SERIE,
                DT_EMISSAO,
                CD_CON_REC,
                TP_CON_REC,
                TIPO_DOCUMENTO,
                DT_PREVISTA_RECEBIMENTO,
                DT_VENCIMENTO,
                CD_REMESSA,
                DT_REMESSA,
                VL_DUPLICATA,
                NVL(VL_RECEBIDO_PRINCIPAL,0) VL_RECEBIDO_PRINCIPAL,
                NVL(VL_ACRESCIMO,0) VL_ACRESCIMO,
                NVL(VL_DESCONTO,0) VL_DESCONTO,
                NVL(VL_IMPOSTO_RETIDO,0) VL_IMPOSTO_RETIDO,
                NVL(VL_GLOSA,0) VL_GLOSA,
                NVL(VL_RECURSO_GLO,0) VL_RECURSO_GLOSA,
                NVL(VL_RECEBIDO_GLOSA,0) VL_RECEBIDO_GLOSA,
                NVL(VL_ACEITE,0) VL_ACEITE,
                (  VL_DUPLICATA 
                 - NVL(VL_RECEBIDO_PRINCIPAL,0)
                 - NVL(VL_GLOSA,0)
                 + NVL(VL_RECURSO_GLO,0)
                 - NVL(VL_RECEBIDO_GLOSA,0)) VL_A_RECEBER
                 
          FROM (SELECT CON_REC.CD_FORNECEDOR,
                       FORNECEDOR.NM_FORNECEDOR,
                       CON_REC.NM_CLIENTE,
                       CASE CON_REC.TP_CON_REC WHEN 'P' THEN 'PESSOA FISICA'
                                               ELSE NVL(CE.DS_CONSTITUICAO_EMPRESA,'NÃO IDENTIFICADO') 
                       END TIPO_CLIENTE,
                       NOTA_FISCAL.CD_CONVENIO,
                       CONVENIO.NM_CONVENIO,
                       CON_REC.CD_NOTA_FISCAL,
                       CON_REC.NR_DOCUMENTO,
                       CON_REC.NR_SERIE,
                       CON_REC.DT_EMISSAO,
                       ITCON_REC.CD_CON_REC,
                       CON_REC.TP_CON_REC,
                       CON_REC.CD_TIP_DOC TIPO_DOCUMENTO,
                       ITCON_REC.DT_PREVISTA_RECEBIMENTO,
                       ITCON_REC.DT_VENCIMENTO,
                       (SELECT MAX(ITFAT_NOTA_FISCAL.CD_REMESSA) 
                          FROM DBAMV.ITFAT_NOTA_FISCAL
                         WHERE ITFAT_NOTA_FISCAL.CD_NOTA_FISCAL = CON_REC.CD_NOTA_FISCAL) CD_REMESSA,
                       (SELECT MAX(DT_ENTREGA_DA_FATURA)
                          FROM DBAMV.REMESSA_FATURA WHERE CD_REMESSA =  (SELECT MAX(ITFAT_NOTA_FISCAL.CD_REMESSA) 
                                                                           FROM DBAMV.ITFAT_NOTA_FISCAL
                                                                          WHERE ITFAT_NOTA_FISCAL.CD_NOTA_FISCAL = CON_REC.CD_NOTA_FISCAL)) DT_REMESSA,
                       ITCON_REC.VL_DUPLICATA,
                       RECEBIMENTO.VL_RECEBIDO_PRINCIPAL,
                       RECEBIMENTO.VL_ACRESCIMO,
                       RECEBIMENTO.VL_DESCONTO,
                       RECEBIMENTO.VL_IMPOSTO_RETIDO,
                       RECEBIMENTO.VL_RECEBIDO_LIQUIDO,
                       RECEBIMENTO.VL_RECEBIDO_GLOSA,
        
                       NVL((SELECT SUM(IT_RECEBIMENTO.VL_GLOSA)
                                FROM DBAMV.IT_RECEBIMENTO
                                JOIN DBAMV.RECCON_REC RC ON RC.CD_RECCON_REC = IT_RECEBIMENTO.CD_RECCON_REC
                              WHERE RC.CD_ITCON_REC = ITCON_REC.CD_ITCON_REC),ITCON_REC.VL_GLOSA) VL_GLOSA,
                       
                       (SELECT SUM(VL_TOTAL_REMESSA)
                          FROM DBAMV.REMESSA_GLOSA
                         WHERE CD_MULTI_EMPRESA = :pCd_MultiEmpresa
                           AND REMESSA_GLOSA.CD_CON_REC = ITCON_REC.CD_CON_REC
                           and REMESSA_GLOSA.CD_REMESSA_GLOSA_PAI IS NULL
                           
                           ) VL_RECURSO_GLO,
                     
                        (SELECT SUM(MG.VL_MOVIMENTACAO) VL_ACEITE
                           FROM DBAMV.MOV_GLOSAS MG
                           JOIN DBAMV.PROCESSO PR ON PR.CD_PROCESSO = MG.CD_PROCESSO
                          WHERE MG.CD_REMESSA_GLOSA IS NULL
                            AND PR.CD_ESTRUTURAL = '3.1.2.1.2'
                            AND MG.CD_ITCON_REC = ITCON_REC.CD_ITCON_REC ) VL_ACEITE
                       
                  FROM DBAMV.CON_REC
                  JOIN DBAMV.ITCON_REC ON ITCON_REC.CD_CON_REC = CON_REC.CD_CON_REC
                  JOIN DBAMV.FORNECEDOR ON FORNECEDOR.CD_FORNECEDOR = CON_REC.CD_FORNECEDOR
                  LEFT JOIN DBAMV.CONSTITUICAO_EMPRESA CE ON CE.CD_CONSTITUICAO_EMPRESA = FORNECEDOR.CD_CONSTITUICAO_EMPRESA
                  LEFT JOIN DBAMV.NOTA_FISCAL ON NOTA_FISCAL.CD_NOTA_FISCAL = CON_REC.CD_NOTA_FISCAL
                  LEFT JOIN DBAMV.CONVENIO    ON CONVENIO.CD_CONVENIO = NOTA_FISCAL.CD_CONVENIO
        
                  LEFT JOIN (SELECT CD_ITCON_REC,
                                    SUM(VL_RECEBIDO_LIQUIDO) VL_RECEBIDO_LIQUIDO,
                                    SUM(VL_ACRESCIMO) VL_ACRESCIMO,
                                    SUM(VL_DESCONTO) VL_DESCONTO,
                                    SUM(VL_IMPOSTO_RETIDO) VL_IMPOSTO_RETIDO,
                                    SUM(VL_RECEBIDO_PRINCIPAL) VL_RECEBIDO_PRINCIPAL,
                                    SUM(VL_RECEBIDO_GLOSA) VL_RECEBIDO_GLOSA
                              FROM (     SELECT  RECCON_REC.CD_ITCON_REC,
                                                 SUM(NVL(RECCON_REC.VL_RECEBIDO,0))       VL_RECEBIDO_LIQUIDO,
                                                 SUM(NVL(RECCON_REC.VL_ACRESCIMO,0))      VL_ACRESCIMO,
                                                 SUM(NVL(RECCON_REC.VL_DESCONTO,0))       VL_DESCONTO,
                                                 SUM(NVL(RECCON_REC.VL_IMPOSTO_RETIDO,0)) VL_IMPOSTO_RETIDO,
                                                 SUM((  NVL(RECCON_REC.VL_RECEBIDO,0)
                                                     - NVL(RECCON_REC.VL_ACRESCIMO,0)      
                                                     + NVL(RECCON_REC.VL_DESCONTO,0)       
                                                     + NVL(RECCON_REC.VL_IMPOSTO_RETIDO,0))) VL_RECEBIDO_PRINCIPAL,
                                                 0 VL_RECEBIDO_GLOSA
                                           FROM RECCON_REC
                                           JOIN ITCON_REC ON ITCON_REC.CD_ITCON_REC = RECCON_REC.CD_ITCON_REC
                                           WHERE NVL(RECCON_REC.SN_RECURSO,'N') = 'N'
                                             AND RECCON_REC.DT_ESTORNO IS NULL
                                           GROUP BY RECCON_REC.CD_ITCON_REC
                                           
                                       UNION
                                       
                                         SELECT  RECCON_REC.CD_ITCON_REC,
                                                 SUM(NVL(RECCON_REC.VL_RECEBIDO,0))       VL_RECEBIDO_LIQUIDO,
                                                 SUM(NVL(RECCON_REC.VL_ACRESCIMO,0))      VL_ACRESCIMO,
                                                 SUM(NVL(RECCON_REC.VL_DESCONTO,0))       VL_DESCONTO,
                                                 SUM(NVL(RECCON_REC.VL_IMPOSTO_RETIDO,0)) VL_IMPOSTO_RETIDO,
                                                 0 AS VL_BRUTO_RECEBIDO,
                                                 SUM((  NVL(RECCON_REC.VL_RECEBIDO,0)
                                                     - NVL(RECCON_REC.VL_ACRESCIMO,0)      
                                                     + NVL(RECCON_REC.VL_DESCONTO,0)       
                                                     + NVL(RECCON_REC.VL_IMPOSTO_RETIDO,0))) VL_RECEBIDO_GLOSA
                                           FROM RECCON_REC
                                           JOIN ITCON_REC ON ITCON_REC.CD_ITCON_REC = RECCON_REC.CD_ITCON_REC
                                           WHERE NVL(RECCON_REC.SN_RECURSO,'N') = 'S'
                                             AND RECCON_REC.DT_ESTORNO IS NULL
                                           GROUP BY RECCON_REC.CD_ITCON_REC) REC
                              GROUP BY CD_ITCON_REC  ) RECEBIMENTO ON RECEBIMENTO.CD_ITCON_REC = ITCON_REC.CD_ITCON_REC
                                                
                 WHERE CON_REC.CD_PREVISAO IS NULL
                   AND CON_REC.CD_MULTI_EMPRESA = :pCd_MultiEmpresa
                   AND ITCON_REC.CD_CON_REC_AGRUP IS NULL
                   AND CON_REC.TP_CON_REC IN ('C','P')
                   AND NVL(NOTA_FISCAL.CD_STATUS,' ') <> 'C'
                   AND ITCON_REC.TP_QUITACAO IN ('V', 'P', 'C')
                   aND CON_REC.cd_con_rec = 380417
                   
              ) CONTA_A_RECEBER
              
         WHERE (  VL_DUPLICATA 
                 - NVL(VL_RECEBIDO_PRINCIPAL,0)
                 - NVL(VL_GLOSA,0)
                 + NVL(VL_RECURSO_GLO,0)
                 - NVL(VL_RECEBIDO_GLOSA,0)) > 0
            OR ( NVL(VL_GLOSA,0) - NVL(VL_RECURSO_GLO,0) - NVL(VL_ACEITE,0) ) > 0
