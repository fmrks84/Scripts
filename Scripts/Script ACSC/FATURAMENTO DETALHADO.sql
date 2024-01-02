/*
C1810/10543
C1909/14471
C2101/9038
C2101/10821
C2101/11775
*/

CONTA_INT AS
(
    SELECT R.CD_ATENDIMENTO,
           R.CD_REG_FAT CONTA,
           R.CD_CONVENIO,
           I.CD_PRO_FAT,
           I.CD_SETOR,
           I.CD_SETOR_PRODUZIU,
           I.CD_GRU_FAT,
           A.CD_ORI_ATE,
           A.CD_PACIENTE,
           A.TP_ATENDIMENTO,
           A.DT_ATENDIMENTO,
           A.CD_TIPO_INTERNACAO,
           
           R.DT_FECHAMENTO,
           I.VL_UNITARIO,
           I.QT_LANCAMENTO,
           I.VL_NOTA,
           I.DT_LANCAMENTO, 
           I.SN_PERTENCE_PACOTE,
           I.VL_FILME_UNITARIO,
           R.VL_FILME_CONTA
        
    FROM DBAMV.REG_FAT R, 
         DBAMV.ITREG_FAT I,
         DBAMV.ATENDIME A
    WHERE R.CD_REG_FAT = I.CD_REG_FAT
    AND R.CD_ATENDIMENTO = A.CD_ATENDIMENTO
    AND R.DT_FECHAMENTO BETWEEN TO_DATE(@DT_INI,'DD/MM/RRRR') AND TO_DATE(@DT_FIM,'DD/MM/RRRR')+1
    AND A.CD_ATENDIMENTO = NVL('{CD_ATENDIMENTO}',A.CD_ATENDIMENTO)
    AND I.CD_PRO_FAT = NVL('{CD_PRO_FAT}',I.CD_PRO_FAT)
    AND I.CD_REG_FAT = NVL('{CD_CONTA}',I.CD_REG_FAT)
    AND A.CD_CONVENIO IN ({CD_CONVENIO_AUX})
    AND I.CD_GRU_FAT IN ({CD_GRU_FAT_AUX})
    --AND ROWNUM <= 9
)
,
CONTA_AMB AS
(
    SELECT I.CD_ATENDIMENTO,
           R.CD_REG_AMB CONTA,
           R.CD_CONVENIO,
           I.CD_PRO_FAT,
           I.CD_SETOR,
           I.CD_SETOR_PRODUZIU,
           I.CD_GRU_FAT,
           A.CD_ORI_ATE,
           A.CD_PACIENTE,
           A.TP_ATENDIMENTO,
           A.DT_ATENDIMENTO,
           A.CD_TIPO_INTERNACAO,
           
           I.DT_FECHAMENTO,
           I.VL_UNITARIO,
           I.QT_LANCAMENTO,
           I.VL_NOTA,
           I.HR_LANCAMENTO, 
           I.SN_PERTENCE_PACOTE,
           I.VL_FILME_UNITARIO,
           R.VL_FILME_CONTA

    FROM DBAMV.REG_AMB R, 
         DBAMV.ITREG_AMB I,
         DBAMV.ATENDIME A
         
    WHERE R.CD_REG_AMB = I.CD_REG_AMB
    AND I.CD_ATENDIMENTO = A.CD_ATENDIMENTO
    AND I.DT_FECHAMENTO BETWEEN TO_DATE(@DT_INI,'DD/MM/RRRR') AND TO_DATE(@DT_FIM,'DD/MM/RRRR')+1
    AND A.CD_ATENDIMENTO = NVL('{CD_ATENDIMENTO}',A.CD_ATENDIMENTO)
    AND I.CD_PRO_FAT = NVL('{CD_PRO_FAT}',I.CD_PRO_FAT)
    AND I.CD_REG_AMB = NVL('{CD_CONTA}',I.CD_REG_AMB)
    AND A.CD_CONVENIO IN ({CD_CONVENIO_AUX})
    AND I.CD_GRU_FAT IN ({CD_GRU_FAT_AUX})
    --AND ROWNUM <= 9
)

SELECT Q.*,
       T.DS_TIPO_INTERNACAO, 
       DECODE(T.TP_INTERNACAO,'CL','CLINICA'
                             ,'CU','CIRURGICA'
                             ,'OB','OBSTETRICIA'
                             ,'UE','URGENCIA E EMERGENCIA',T.TP_INTERNACAO) TP_INTERNACAO
FROM 
(
    SELECT DECODE(CONTA_AMB.TP_ATENDIMENTO,'A','Ambulatorial','E','Externo','I','Internado','U','Urgência',CONTA_AMB.TP_ATENDIMENTO) TP_ATENDIMENTO,
           CONTA_AMB.CD_ATENDIMENTO,
           PP.NM_PACIENTE,
           ROUND(((CONTA_AMB.DT_ATENDIMENTO - PP.DT_NASCIMENTO) / 365), 0) IDADE,
           CONTA_AMB.CD_CONVENIO,
           CONTA_AMB.CONTA,
           CONTA_AMB.DT_FECHAMENTO,
           CONTA_AMB.VL_UNITARIO,
           CONTA_AMB.QT_LANCAMENTO,
           CONTA_AMB.CD_PRO_FAT,
           P.DS_PRO_FAT,
           CONTA_AMB.VL_NOTA,
           G.DS_GRU_PRO,
           F.DS_GRU_FAT,
           O.DS_ORI_ATE,
           CONTA_AMB.CD_SETOR CD_SET_SOLIC,
           S.NM_SETOR SET_SOLIC,
           CONTA_AMB.CD_SETOR_PRODUZIU CD_SET_EXEC,
           S2.NM_SETOR SET_EXEC,
           CONTA_AMB.CD_TIPO_INTERNACAO,
           HR_LANCAMENTO DT_LANCAMENTO, 
           SN_PERTENCE_PACOTE,
           VL_FILME_UNITARIO,
           VL_FILME_CONTA
        
      FROM CONTA_AMB,
           --ITREG_AMB I,
           --ATENDIME  A,
           PACIENTE  PP,
           PRO_FAT   P,
           GRU_PRO   G,
           GRU_FAT   F,
           ORI_ATE   O,
           --REG_AMB   R,
           SETOR     S,
           SETOR     S2
           
     WHERE CONTA_AMB.CD_PACIENTE = PP.CD_PACIENTE
       AND CONTA_AMB.CD_PRO_FAT = P.CD_PRO_FAT
       AND CONTA_AMB.CD_SETOR = S.CD_SETOR
       AND CONTA_AMB.CD_SETOR_PRODUZIU = S2.CD_SETOR
       AND P.CD_GRU_PRO = G.CD_GRU_PRO
       AND CONTA_AMB.CD_GRU_FAT = F.CD_GRU_FAT
       AND CONTA_AMB.CD_ORI_ATE = O.CD_ORI_ATE
    
    UNION ALL
    
    SELECT DECODE(CONTA_INT.TP_ATENDIMENTO,'A','Ambulatorial','E','Externo','I','Internado','U','Urgência',CONTA_INT.TP_ATENDIMENTO) TP_ATENDIMENTO,
           CONTA_INT.CD_ATENDIMENTO,
           PP.NM_PACIENTE,
           ROUND(((CONTA_INT.DT_ATENDIMENTO - PP.DT_NASCIMENTO) / 365), 0) IDADE,
           CONTA_INT.CD_CONVENIO,
           CONTA_INT.CONTA,
           CONTA_INT.DT_FECHAMENTO,
           
           CONTA_INT.VL_UNITARIO,
           CONTA_INT.QT_LANCAMENTO,
           CONTA_INT.CD_PRO_FAT,
           P.DS_PRO_FAT,
           CONTA_INT.VL_NOTA,
           G.DS_GRU_PRO,
           F.DS_GRU_FAT,
           O.DS_ORI_ATE,
           CONTA_INT.CD_SETOR CD_SET_SOLIC,
           S.NM_SETOR SET_SOLIC,
           CONTA_INT.CD_SETOR_PRODUZIU CD_SET_EXEC,
           S2.NM_SETOR SET_EXEC,
           CONTA_INT.CD_TIPO_INTERNACAO,
           DT_LANCAMENTO, 
           SN_PERTENCE_PACOTE,
           VL_FILME_UNITARIO,
           VL_FILME_CONTA   
            
      FROM CONTA_INT,
           --ITREG_FAT I,
           --ATENDIME  A,
           PACIENTE  PP,
           PRO_FAT   P,
           GRU_PRO   G,
           GRU_FAT   F,
           ORI_ATE   O,
           --REG_FAT   R,
           SETOR     S,
           SETOR     S2           
    
     WHERE CONTA_INT.CD_PACIENTE = PP.CD_PACIENTE
       AND CONTA_INT.CD_PRO_FAT = P.CD_PRO_FAT
       AND CONTA_INT.CD_SETOR = S.CD_SETOR
       AND CONTA_INT.CD_SETOR_PRODUZIU = S2.CD_SETOR
       AND P.CD_GRU_PRO = G.CD_GRU_PRO
       AND CONTA_INT.CD_GRU_FAT = F.CD_GRU_FAT
       AND CONTA_INT.CD_ORI_ATE = O.CD_ORI_ATE

) Q
LEFT JOIN DBAMV.TIPO_INTERNACAO T ON Q.CD_TIPO_INTERNACAO = T.CD_TIPO_INTERNACAO