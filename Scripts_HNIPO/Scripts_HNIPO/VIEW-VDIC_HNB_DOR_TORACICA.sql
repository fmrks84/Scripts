SELECT 
*

FROM 
(
SELECT DD2.CD_ATENDIMENTO,
       DD2.SAME,
       DD2.NM_PACIENTE,
       DD2.IDADE,
       DD2.SEXO,
       TO_DATE(DD2.DT_ABERTURA,'DD/MM/RRRR')DT_ABERTURA,
       (CASE WHEN DD2.LOCAL_ABERTURA = 'PA' THEN DD2.LOCAL_ABERTURA
             ELSE (SELECT UI.DS_UNID_INT FROM MOV_INT MI JOIN LEITO L ON L.CD_LEITO = MI.CD_LEITO
                     JOIN DBAMV.UNID_INT UI ON UI.CD_UNID_INT = L.CD_UNID_INT
                    WHERE MI.CD_ATENDIMENTO = DD2.CD_ATENDIMENTO
                      AND DD2.DATA_LOCAL_ABERTURA BETWEEN TO_DATE(TO_CHAR(MI.DT_MOV_INT, 'DD/MM/RRRR') ||
                                                          TO_CHAR(MI.HR_MOV_INT, 'HH24:MI:SS'), 'DD/MM/RRRR HH24:MI:SS')
                                                      AND NVL(TO_DATE(TO_CHAR(MI.DT_LIB_MOV, 'DD/MM/RRRR') ||
                                                          TO_CHAR(MI.HR_LIB_MOV, 'HH24:MI:SS'), 'DD/MM/RRRR HH24:MI:SS'), SYSDATE))
       END) LOCAL_ABERTURA,
       DD2.TIPO,
       DD2.PERIODO_ADMISSAO,
       DD2.PED_TROPONINA,
       DD2.DT_SOLICITACAO,
       DD2.DT_ENTREGA_AMOSTRA,
       DD2.DT_LAUDO,
       (CASE WHEN DD2.DT_ENTREGA_AMOSTRA IS NOT NULL AND DD2.DT_LAUDO IS NOT NULL THEN
                 round(((DD2.DT_LAUDO - DD2.DT_ENTREGA_AMOSTRA)*60)*24)
             ELSE NULL
       END)TMP_AMOSTRA_X_LAUDO,
       (CASE WHEN  (CASE WHEN DD2.DT_ENTREGA_AMOSTRA IS NOT NULL AND DD2.DT_LAUDO IS NOT NULL THEN
                             round(((DD2.DT_LAUDO - DD2.DT_ENTREGA_AMOSTRA)*60)*24)
                        ELSE NULL
                   END) <= 40 THEN 1
             ELSE 0
       END)ADESAO_META_40,
       (CASE WHEN DD2.DT_SOLICITACAO IS NOT NULL AND DD2.DT_LAUDO IS NOT NULL THEN
                  round(((DD2.DT_LAUDO - DD2.DT_SOLICITACAO)*60)*24)
             ELSE NULL
       END)TMP_SOLIC_X_LAUDO,
       (CASE WHEN  (CASE WHEN DD2.DT_SOLICITACAO IS NOT NULL AND DD2.DT_LAUDO IS NOT NULL THEN
                             round(((DD2.DT_LAUDO - DD2.DT_SOLICITACAO)*60)*24)
                        ELSE NULL
                   END) <= 70 THEN 1
             ELSE 0
       END)ADESAO_META_70,
       DD2.H_SOLIC_ECG,
       DD2.H_REALIZ_ECG,
       DD2.TMP_SOLIC_X_REALIZ_ECG,
       DD2.ADESAO_ECG_META_10,
       DD2.ECG_VISTO_MED,
       DD2.TMP_REALIZ_Z_X_VISTO_MED,
       DD2.DT_INICIO_TROMBOLITICO,
       DD2.TMP_TROMBOLISE,
       DD2.ADESAO_PORTAGUL_META_30,
       DD2.H_ABERTURA_ARTERIA,
       DD2.TMP_PORTA_BALAO,
       DD2.ADESAO_PORTBALAO_META_90,
       DD2.DIAGNOSTICO,
       DD2.P_ANTIPLAQ,
       DD2.P_BETA_BLOQUEADOR,
       DD2.P_IECA,
       DD2.ADESAO_PRESC_ALTA,
       DD2.DT_INTERNACAO,
       DD2.DT_ALTA,
       DD2.DIAS_INTERNACAO,
       DD2.ADESAO_DIAS_INTER,
       DD2.ADESAO_GLOBAL_MARCADORES,
       DD2.ECO,
       DD2.CONDUTA_HMD,
       DD2.DESTINO_FINAL,
       DD2.CONF_DIAGNOSTICO,
       DD2.MES,
       DD2.ANALISE,
       DD2.DOCUMENTO,
       /*(CASE WHEN SUBSTR(DD2.DT_ABERTURA,1,10) IS NOT NULL AND LENGTH(SUBSTR(DD2.DT_ABERTURA,1,10)) = 10 THEN
                  (CASE WHEN TO_NUMBER(SUBSTR(DD2.DT_ABERTURA,1,2)) BETWEEN 1 AND 31
                         AND TO_NUMBER(SUBSTR(DD2.DT_ABERTURA,1,2)) BETWEEN 1 AND 12
                         AND TO_NUMBER(SUBSTR(DD2.DT_ABERTURA,1,2)) BETWEEN 2000  AND TO_NUMBER(TO_CHAR(SYSDATE, 'RRRR')) THEN
                             TO_DATE(DD2.DT_ABERTURA, 'DD/MM/RRRR')
                        ELSE
                             TO_DATE(DD2.DT_REGISTRO, 'DD/MM/RRRR')
                  END)
             ELSE
                  TO_DATE(DD2.DT_REGISTRO, 'DD/MM/RRRR')
       END)*/
       (CASE WHEN SUBSTR(DT_ABERTURA,1,10) IS NOT NULL AND LENGTH(SUBSTR(DT_ABERTURA,1,10)) = 10 THEN
                  (CASE WHEN TO_NUMBER(SUBSTR(DT_ABERTURA,1,2)) BETWEEN 1 AND 31
                         AND TO_NUMBER(SUBSTR(DT_ABERTURA,4,2)) BETWEEN 1 AND 12
                         AND TO_NUMBER(SUBSTR(DT_ABERTURA,7,4)) BETWEEN 2000  AND TO_NUMBER(TO_CHAR(SYSDATE, 'RRRR')) THEN
                             TO_DATE(SUBSTR(DT_ABERTURA,1,10))
                        ELSE
                             TO_DATE(DT_REGISTRO,'DD/MM/RRRR')
                  END)
             ELSE
                  TO_DATE(DT_REGISTRO,'DD/MM/RRRR')
       END)DT_BUSCA_RELAT
  FROM (SELECT DD1.CD_ATENDIMENTO,
               DD1.SAME,
               DD1.NM_PACIENTE,
               DD1.IDADE,
               DD1.SEXO,
               DD1.DT_ABERTURA,
               (CASE WHEN TRIM(REPLACE(SUBSTR(DD1.DT_ABERTURA,1,10), '/',NULL)) IS NOT NULL AND
                          SUBSTR(DD1.DT_ABERTURA,1,2) BETWEEN 1 AND 31 AND
                          SUBSTR(DD1.DT_ABERTURA,4,2) BETWEEN 1 AND 12 AND
                          SUBSTR(DD1.DT_ABERTURA,7,4) BETWEEN 1900 AND 4000 THEN
                       (CASE WHEN DD1.LOCAL_ABERTURA = 'PA' THEN TO_DATE(DD1.DT_ABERTURA, 'DD/MM/RRRR HH24:MI:SS')
                             WHEN DD1.LOCAL_ABERTURA = 'INTERNACAO'
                                  AND TO_NUMBER(SUBSTR(DD1.DT_ABERTURA,12,2)) BETWEEN 0 AND 23
                                  AND TO_NUMBER(SUBSTR(DD1.DT_ABERTURA,15,2)) BETWEEN 0 AND 59 THEN
                                  TO_DATE(DD1.DT_ABERTURA, 'DD/MM/RRRR HH24:MI:SS')
                        END)
                     ELSE
                       DD1.DT_REGISTRO
                END)DATA_LOCAL_ABERTURA,
               DD1.LOCAL_ABERTURA,
               DD1.TIPO,
               --SUBSTR(DD1.DT_ABERTURA, 1,10) "DATA",
               --TO_NUMBER(SUBSTR(DD1.DT_ABERTURA, 12,2)) "HORA",
               (CASE
                 WHEN TO_NUMBER(SUBSTR(DD1.DT_ABERTURA, 12, 2)) IS NOT NULL THEN
                  (CASE
                    WHEN TO_NUMBER(SUBSTR(DD1.DT_ABERTURA, 12, 2)) BETWEEN 7 AND 12 THEN
                     'MANHA'
                    WHEN TO_NUMBER(SUBSTR(DD1.DT_ABERTURA, 12, 2)) BETWEEN 13 AND 18 THEN
                     'TARDE'
                    WHEN TO_NUMBER(SUBSTR(DD1.DT_ABERTURA, 12, 2)) BETWEEN 0 AND 6 OR
                         TO_NUMBER(SUBSTR(DD1.DT_ABERTURA, 12, 2)) BETWEEN 19 AND 23 THEN
                     'NOITE'
                  END)
                 ELSE
                  NULL
               END) PERIODO_ADMISSAO,
               DD1.PED_TROPONINA,
               DD1.DT_SOLICITACAO,
               (SELECT A.HR_CONFIRMA_LAB
                  FROM AMOSTRA A, AMOSTRA_EXA_LAB AE
                 WHERE A.CD_AMOSTRA IN
                       (SELECT DISTINCT (MAX(X.CD_AMOSTRA))
                          FROM PED_LAB         P,
                               ITPED_LAB       I,
                               AMOSTRA         X,
                               AMOSTRA_EXA_LAB AE,
                               RES_EXA         R
                         WHERE P.CD_PED_LAB = DD1.PED_TROPONINA
                           AND P.CD_PED_LAB = I.CD_PED_LAB
                           AND X.CD_AMOSTRA = AE.CD_AMOSTRA
                           AND AE.CD_ITPED_LAB = I.CD_ITPED_LAB
                           AND R.CD_PED_LAB = P.CD_PED_LAB
                           AND I.CD_EXA_LAB = 1208)

                   AND A.CD_AMOSTRA = AE.CD_AMOSTRA
                   AND AE.CD_ITPED_LAB IN
                       (SELECT MIN(I.CD_ITPED_LAB)
                          FROM PED_LAB P, ITPED_LAB I, RES_EXA R
                         WHERE P.CD_PED_LAB = DD1.PED_TROPONINA
                           AND P.CD_PED_LAB = I.CD_PED_LAB
                           AND R.CD_PED_LAB = P.CD_PED_LAB
                           AND I.CD_EXA_LAB = 1208)) DT_ENTREGA_AMOSTRA,
               (SELECT MIN(I.DT_LAUDO)
                  FROM PED_LAB P, ITPED_LAB I, RES_EXA R
                 WHERE P.CD_PED_LAB = DD1.PED_TROPONINA
                   AND I.CD_ITPED_LAB IN
                       (SELECT MIN(I.CD_ITPED_LAB)
                          FROM PED_LAB P, ITPED_LAB I, RES_EXA R
                         WHERE P.CD_PED_LAB = DD1.PED_TROPONINA
                           AND P.CD_PED_LAB = I.CD_PED_LAB
                           AND R.CD_PED_LAB = P.CD_PED_LAB
                           AND I.CD_EXA_LAB = 1208)
                   AND P.CD_PED_LAB = I.CD_PED_LAB
                   AND R.CD_PED_LAB = P.CD_PED_LAB
                   AND I.CD_EXA_LAB = 1208) DT_LAUDO,
               DD1.TMP_AMOSTRA_X_LAUDO,
               DD1.ADESAO_META_40,
               DD1.TMP_SOLIC_X_LAUDO,
               DD1.ADESAO_META_70,
               DD1.H_SOLIC_ECG,
               DD1.H_REALIZ_ECG,
               DD1.TMP_SOLIC_X_REALIZ_ECG,
               DD1.ADESAO_ECG_META_10,
               DD1.ECG_VISTO_MED,
               DD1.TMP_REALIZ_Z_X_VISTO_MED,
               DD1.DT_INICIO_TROMBOLITICO,
               DD1.TMP_TROMBOLISE,
               DD1.ADESAO_PORTAGUL_META_30,
               DD1.H_ABERTURA_ARTERIA,
               DD1.TMP_PORTA_BALAO,
               DD1.ADESAO_PORTBALAO_META_90,
               DD1.DIAGNOSTICO,
               DD1.P_ANTIPLAQ,
               DD1.P_BETA_BLOQUEADOR,
               DD1.P_IECA,
               DD1.ADESAO_PRESC_ALTA,
               DD1.DT_INTERNACAO,
               DD1.DT_ALTA,
               DD1.DIAS_INTERNACAO,
               DD1.ADESAO_DIAS_INTER,
               DD1.ADESAO_GLOBAL_MARCADORES,
               DD1.ECO,
               DD1.CONDUTA_HMD,
               DD1.DESTINO_FINAL,
               DD1.CONF_DIAGNOSTICO,
               DD1.MES,
               DD1.ANALISE,
               DD1.DOCUMENTO,
               DD1.DT_REGISTRO

          FROM (
                --PROTOCOLO DOR TORACICA PA 729
                SELECT ATE.CD_ATENDIMENTO,
                        PAC.CD_PACIENTE SAME,
                        PAC.NM_PACIENTE,
                        fnc_hnb_obter_idade(pac.dt_nascimento, dc.dh_referencia) idade,
                        decode(pac.tp_sexo,
                               'F',
                               'FEMININO',
                               'M',
                               'MASCULINO',
                               'I',
                               'INDEFINIDO') SEXO,
                        (CASE
                          WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                           (SELECT TO_CHAR(MIN(STP.DH_PROCESSO),
                                           'DD/MM/RRRR HH24:MI:SS')
                              FROM SACR_TEMPO_PROCESSO STP
                             WHERE STP.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                               AND STP.CD_TIPO_TEMPO_PROCESSO = 1)
                          WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                           (SELECT TO_CHAR(ERC.LO_VALOR)
                              FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                              JOIN DBAMV.EDITOR_CAMPO EDC
                                ON EDC.CD_CAMPO = ERC.CD_CAMPO
                              JOIN PW_EDITOR_CLINICO EC1
                                ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                              JOIN PW_DOCUMENTO_CLINICO DC1
                                ON DC1.CD_DOCUMENTO_CLINICO =
                                   EC1.CD_DOCUMENTO_CLINICO
                             WHERE EC1.CD_DOCUMENTO = 729
                               AND DC1.TP_STATUS = 'FECHADO'
                               AND EDC.DS_IDENTIFICADOR IN
                                   ('DT_PROT_TORA_CHEGADA_1')
                               AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO)
                        END) DT_ABERTURA,
                        (CASE
                          WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                           'PA'
                          WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                           'INTERNACAO'
                        END) LOCAL_ABERTURA,
                        (CASE
                          WHEN (SELECT TO_CHAR(ERC.LO_VALOR)
                                  FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                                  JOIN DBAMV.EDITOR_CAMPO EDC
                                    ON EDC.CD_CAMPO = ERC.CD_CAMPO
                                  JOIN PW_EDITOR_CLINICO EC1
                                    ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                                  JOIN PW_DOCUMENTO_CLINICO DC1
                                    ON DC1.CD_DOCUMENTO_CLINICO =
                                       EC1.CD_DOCUMENTO_CLINICO
                                 WHERE EC1.CD_DOCUMENTO = 729
                                   AND DC1.TP_STATUS = 'FECHADO'
                                   AND EDC.DS_IDENTIFICADOR IN
                                       ('CK_PROT_TORA_DIREC_C_1')
                                   AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO) =
                               'true' THEN
                           'TIPO C'
                          WHEN (SELECT TO_CHAR(ERC.LO_VALOR)
                                  FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                                  JOIN DBAMV.EDITOR_CAMPO EDC
                                    ON EDC.CD_CAMPO = ERC.CD_CAMPO
                                  JOIN PW_EDITOR_CLINICO EC1
                                    ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                                  JOIN PW_DOCUMENTO_CLINICO DC1
                                    ON DC1.CD_DOCUMENTO_CLINICO =
                                       EC1.CD_DOCUMENTO_CLINICO
                                 WHERE EC1.CD_DOCUMENTO = 729
                                   AND DC1.TP_STATUS = 'FECHADO'
                                   AND EDC.DS_IDENTIFICADOR IN
                                       ('CK_PROT_TORA_DIREC_B_1')
                                   AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO) =
                               'true' THEN
                           'TIPO B'
                          WHEN (SELECT TO_CHAR(ERC.LO_VALOR)
                                  FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                                  JOIN DBAMV.EDITOR_CAMPO EDC
                                    ON EDC.CD_CAMPO = ERC.CD_CAMPO
                                  JOIN PW_EDITOR_CLINICO EC1
                                    ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                                  JOIN PW_DOCUMENTO_CLINICO DC1
                                    ON DC1.CD_DOCUMENTO_CLINICO =
                                       EC1.CD_DOCUMENTO_CLINICO
                                 WHERE EC1.CD_DOCUMENTO = 729
                                   AND DC1.TP_STATUS = 'FECHADO'
                                   AND EDC.DS_IDENTIFICADOR IN
                                       ('CK_PROT_TORA_DIREC_A_1')
                                   AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO) =
                               'true' THEN
                           'TIPO A'
                          WHEN (SELECT TO_CHAR(ERC.LO_VALOR)
                                  FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                                  JOIN DBAMV.EDITOR_CAMPO EDC
                                    ON EDC.CD_CAMPO = ERC.CD_CAMPO
                                  JOIN PW_EDITOR_CLINICO EC1
                                    ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                                  JOIN PW_DOCUMENTO_CLINICO DC1
                                    ON DC1.CD_DOCUMENTO_CLINICO =
                                       EC1.CD_DOCUMENTO_CLINICO
                                 WHERE EC1.CD_DOCUMENTO = 729
                                   AND DC1.TP_STATUS = 'FECHADO'
                                   AND EDC.DS_IDENTIFICADOR IN
                                       ('CK_PROT_TORA_DIREC_D_1')
                                   AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO) =
                               'true' THEN
                           'TIPO D'
                        END) TIPO,
                        'AJUSTAR' PERIODO_ADMISSAO,
                        (CASE
                          WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                           NVL((SELECT MIN(PEL.CD_PED_LAB)
                                 FROM PED_LAB PEL
                                 JOIN ITPED_LAB IPEL
                                   ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                                WHERE PEL.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                                  AND IPEL.CD_EXA_LAB = 1208),
                               (SELECT MIN(PEL.CD_PED_LAB)
                                  FROM DBAMV.PED_LAB PEL
                                  JOIN DBAMV.ITPED_LAB IPEL
                                    ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                                  JOIN DBAMV.ATENDIME ATE2
                                    ON ATE2.CD_ATENDIMENTO = PEL.CD_ATENDIMENTO
                                 WHERE ATE2.CD_PACIENTE = ATE.CD_PACIENTE
                                   AND IPEL.CD_EXA_LAB = 1208
                                   AND TRUNC(PEL.DT_PEDIDO) BETWEEN
                                       (TRUNC(ATE.DT_ATENDIMENTO) - 24 / 24) AND
                                       NVL(TRUNC(ATE.DT_ALTA), SYSDATE)))
                          WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                           (SELECT MIN(PEL.CD_PED_LAB)
                              FROM PED_LAB PEL
                              JOIN ITPED_LAB IPEL
                                ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                             WHERE PEL.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                               AND IPEL.CD_EXA_LAB = 1208)
                        END) PED_TROPONINA,
                        (CASE
                          WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                           NVL((SELECT MIN(PEL.DT_PEDIDO)
                                 FROM DBAMV.PED_LAB PEL
                                 JOIN DBAMV.ITPED_LAB IPEL
                                   ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                                WHERE PEL.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                                  AND IPEL.CD_EXA_LAB = 1208),
                               (SELECT MIN(PEL.DT_PEDIDO)
                                  FROM DBAMV.PED_LAB PEL
                                  JOIN DBAMV.ITPED_LAB IPEL
                                    ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                                  JOIN DBAMV.ATENDIME ATE2
                                    ON ATE2.CD_ATENDIMENTO = PEL.CD_ATENDIMENTO
                                 WHERE ATE2.CD_PACIENTE = ATE.CD_PACIENTE
                                   AND IPEL.CD_EXA_LAB = 1208
                                   AND TRUNC(PEL.DT_PEDIDO) BETWEEN
                                       (TRUNC(ATE.DT_ATENDIMENTO) - 24 / 24) AND
                                       NVL(TRUNC(ATE.DT_ALTA), SYSDATE)))
                          WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                           (SELECT MIN(PEL.DT_PEDIDO)
                              FROM PED_LAB PEL
                              JOIN ITPED_LAB IPEL
                                ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                             WHERE PEL.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                               AND IPEL.CD_EXA_LAB = 1208)
                        END) DT_SOLICITACAO,
                        'AJUSTAR' DT_ENTREGA_AMOSTRA,
                        'AJUSTAR' DT_LAUDO,
                        'AJUSTAR' TMP_AMOSTRA_X_LAUDO,
                        'AJUSTAR' ADESAO_META_40,
                        'AJUSTAR' TMP_SOLIC_X_LAUDO,
                        'AJUSTAR' ADESAO_META_70,
                        (SELECT TO_CHAR(ERC.LO_VALOR)
                           FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                           JOIN DBAMV.EDITOR_CAMPO EDC
                             ON EDC.CD_CAMPO = ERC.CD_CAMPO
                           JOIN PW_EDITOR_CLINICO EC1
                             ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                           JOIN PW_DOCUMENTO_CLINICO DC1
                             ON DC1.CD_DOCUMENTO_CLINICO =
                                EC1.CD_DOCUMENTO_CLINICO
                          WHERE EC1.CD_DOCUMENTO = 729
                            
                            AND DC1.TP_STATUS = 'FECHADO'
                            AND EDC.DS_IDENTIFICADOR IN ('HR_PROT_TORA_ECG_1')
                            AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO) H_SOLIC_ECG,
                        NULL H_REALIZ_ECG,
                        NULL TMP_SOLIC_X_REALIZ_ECG,
                        NULL ADESAO_ECG_META_10,
                        (SELECT TO_CHAR(ERC.LO_VALOR)
                           FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                           JOIN DBAMV.EDITOR_CAMPO EDC
                             ON EDC.CD_CAMPO = ERC.CD_CAMPO
                           JOIN PW_EDITOR_CLINICO EC1
                             ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                           JOIN PW_DOCUMENTO_CLINICO DC1
                             ON DC1.CD_DOCUMENTO_CLINICO =
                                EC1.CD_DOCUMENTO_CLINICO
                          WHERE EC1.CD_DOCUMENTO = 729
                            AND DC1.TP_STATUS = 'FECHADO'
                            AND EDC.DS_IDENTIFICADOR IN ('HR_PROT_TORA_ELETRO_1')
                            AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO) ECG_VISTO_MED,
                        NULL TMP_REALIZ_Z_X_VISTO_MED,
                        (SELECT TO_CHAR(ERC.LO_VALOR)
                           FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                           JOIN DBAMV.EDITOR_CAMPO EDC
                             ON EDC.CD_CAMPO = ERC.CD_CAMPO
                          WHERE EDC.DS_IDENTIFICADOR IN ('HR_TROMBOLISE_1')
                            AND ERC.CD_REGISTRO =
                                (SELECT MAX(EC1.CD_EDITOR_REGISTRO)
                                   FROM PW_EDITOR_CLINICO EC1
                                   JOIN PW_DOCUMENTO_CLINICO DC1
                                     ON DC1.CD_DOCUMENTO_CLINICO =
                                        EC1.CD_DOCUMENTO_CLINICO
                                  WHERE EC1.CD_DOCUMENTO = 701
                                    AND DC1.TP_STATUS = 'FECHADO'
                                    AND DC1.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO)) DT_INICIO_TROMBOLITICO,
                        NULL TMP_TROMBOLISE,
                        NULL ADESAO_PORTAGUL_META_30,
                        (SELECT TO_CHAR(ERC.LO_VALOR) DS_RESPOSTA
                           FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                          INNER JOIN DBAMV.EDITOR_CAMPO EC
                             ON EC.CD_CAMPO = ERC.CD_CAMPO
                          WHERE ERC.CD_REGISTRO IN
                                (SELECT MIN(PE.CD_EDITOR_REGISTRO)
                                   FROM DBAMV.PW_EDITOR_CLINICO PE
                                  INNER JOIN DBAMV.PW_DOCUMENTO_CLINICO PE1
                                     ON PE1.CD_DOCUMENTO_CLINICO =
                                        PE.CD_DOCUMENTO_CLINICO
                                  WHERE PE1. CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                                    AND PE.CD_DOCUMENTO = 668
                                    AND PE1.TP_STATUS = 'FECHADO')
                            AND UPPER(EC.DS_IDENTIFICADOR) =
                                'DT_ABERTURA_PROTOCOLO_HEMO_1') H_ABERTURA_ARTERIA,
                        NULL TMP_PORTA_BALAO,
                        NULL ADESAO_PORTBALAO_META_90,
                        NULL DIAGNOSTICO,
                        NULL P_ANTIPLAQ,
                        NULL P_BETA_BLOQUEADOR,
                        NULL P_IECA,
                        NULL ADESAO_PRESC_ALTA,
                        (CASE
                          WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                           NULL
                          WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                           TRUNC(ATE.DT_ATENDIMENTO)
                        END) DT_INTERNACAO,
                        (CASE
                          WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                           NULL
                          WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                           TRUNC(ATE.DT_ALTA)
                        END) DT_ALTA,
                        (CASE
                          WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                           NULL
                          WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                           ROUND(TRUNC(ATE.DT_ALTA) - TRUNC(ATE.DT_ATENDIMENTO))
                        END) DIAS_INTERNACAO,
                        NULL ADESAO_DIAS_INTER,
                        NULL ADESAO_GLOBAL_MARCADORES,
                        NULL ECO,
                        NULL CONDUTA_HMD,
                        (CASE
                          WHEN ATE.TP_ATENDIMENTO = 'U' AND
                               ATE.DT_ALTA IS NOT NULL THEN
                           NVL((SELECT (CASE
                                        WHEN MA.CD_MOT_ALT IN
                                             (1, 2, 10, 11, 12, 13) THEN
                                         'ALTA PA'
                                        WHEN MA.CD_MOT_ALT IN
                                             (5, 6, 7, 14, 15, 16) THEN
                                         'OBITO'
                                        WHEN MA.CD_MOT_ALT IN (9, 17) THEN
                                         'ALTA ADM'
                                        WHEN MA.CD_MOT_ALT IN (3, 4) THEN
                                         'ALTA EVASAO/PEDIDO'
                                        WHEN MA.CD_MOT_ALT IN (8) THEN
                                         'TRANSFERENCIA'
                                        ELSE
                                         MA.DS_MOT_ALT
                                      END)
                                 FROM MOT_ALT MA
                                WHERE MA.CD_MOT_ALT = ATE.CD_MOT_ALT),
                               (SELECT (CASE
                                         WHEN TR.CD_TIP_RES IN (23, 24, 33) THEN
                                          'ALTA PA'
                                         WHEN TR.CD_TIP_RES IN (21) THEN
                                          'OBITO'
                                         WHEN TR.CD_TIP_RES IN (17) THEN
                                          'ALTA EVASAO/PEDIDO'
                                         WHEN TR.CD_TIP_RES IN (2) THEN
                                          'TRANSFERENCIA'
                                         ELSE
                                          TR.DS_TIP_RES
                                       END)
                                  FROM TIP_RES TR
                                 WHERE TR.CD_TIP_RES = ATE.CD_TIP_RES))

                          WHEN ATE.TP_ATENDIMENTO = 'I' AND
                               ATE.DT_ALTA IS NOT NULL THEN
                           NVL((SELECT (CASE
                                        WHEN MA.CD_MOT_ALT IN
                                             (1, 2, 10, 11, 12, 13) THEN
                                         'ALTA INTERNACAO'
                                        WHEN MA.CD_MOT_ALT IN
                                             (5, 6, 7, 14, 15, 16) THEN
                                         'OBITO'
                                        WHEN MA.CD_MOT_ALT IN (9, 17) THEN
                                         'ALTA ADM'
                                        WHEN MA.CD_MOT_ALT IN (3, 4) THEN
                                         'ALTA EVASAO/PEDIDO'
                                        WHEN MA.CD_MOT_ALT IN (8) THEN
                                         'TRANSFERENCIA'
                                        ELSE
                                         MA.DS_MOT_ALT
                                      END)
                                 FROM MOT_ALT MA
                                WHERE MA.CD_MOT_ALT = ATE.CD_MOT_ALT),
                               (SELECT (CASE
                                         WHEN TR.CD_TIP_RES IN (23, 24, 33) THEN
                                          'ALTA INTERNACAO'
                                         WHEN TR.CD_TIP_RES IN (21) THEN
                                          'OBITO'
                                         WHEN TR.CD_TIP_RES IN (17) THEN
                                          'ALTA EVASAO/PEDIDO'
                                         WHEN TR.CD_TIP_RES IN (2) THEN
                                          'TRANSFERENCIA'
                                         ELSE
                                          TR.DS_TIP_RES
                                       END)
                                  FROM TIP_RES TR
                                 WHERE TR.CD_TIP_RES = ATE.CD_TIP_RES))
                          WHEN ATE.TP_ATENDIMENTO = 'I' AND ATE.DT_ALTA IS NULL THEN
                           'INTERNADO'
                        END) DESTINO_FINAL,
                        NULL CONF_DIAGNOSTICO,
                        NULL MES,
                        NULL ANALISE,
                        'Protocolo de Dor Toracica PA' DOCUMENTO,
                        DC.DH_REFERENCIA DT_REGISTRO
                  FROM DBAMV.PW_DOCUMENTO_CLINICO DC
                  JOIN DBAMV.PW_EDITOR_CLINICO EC
                    ON EC.CD_DOCUMENTO_CLINICO = DC.CD_DOCUMENTO_CLINICO
                  JOIN DBAMV.ATENDIME ATE
                    ON ATE.CD_ATENDIMENTO = DC.CD_ATENDIMENTO
                  JOIN DBAMV.PACIENTE PAC
                    ON PAC.CD_PACIENTE = ATE.CD_PACIENTE
                 WHERE EC.CD_DOCUMENTO = 729
                   AND DC.TP_STATUS = 'FECHADO'
                   --
                   AND DC.DH_REFERENCIA BETWEEN
                       ADD_MONTHS(TRUNC(SYSDATE, 'Month'), -6) and
                       trunc(sysdate)

                UNION ALL
                --PROTOCOLO DOR TORACICA INTERNACAO 934
                SELECT ATE.CD_ATENDIMENTO,
                       PAC.CD_PACIENTE SAME,
                       PAC.NM_PACIENTE,
                       fnc_hnb_obter_idade(pac.dt_nascimento, dc.dh_referencia) idade,
                       decode(pac.tp_sexo,
                              'F',
                              'FEMININO',
                              'M',
                              'MASCULINO',
                              'I',
                              'INDEFINIDO') SEXO,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          (SELECT TO_CHAR(MIN(STP.DH_PROCESSO),
                                          'DD/MM/RRRR HH24:MI:SS')
                             FROM SACR_TEMPO_PROCESSO STP
                            WHERE STP.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                              AND STP.CD_TIPO_TEMPO_PROCESSO = 1)
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          (SELECT TO_CHAR(ERC.LO_VALOR)
                             FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                             JOIN DBAMV.EDITOR_CAMPO EDC
                               ON EDC.CD_CAMPO = ERC.CD_CAMPO
                             JOIN PW_EDITOR_CLINICO EC1
                               ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                             JOIN PW_DOCUMENTO_CLINICO DC1
                               ON DC1.CD_DOCUMENTO_CLINICO =
                                  EC1.CD_DOCUMENTO_CLINICO
                            WHERE EC1.CD_DOCUMENTO = 934
                              AND DC1.TP_STATUS = 'FECHADO'
                              AND EDC.DS_IDENTIFICADOR IN
                                  ('DT_PROT_TORA_CHEGADA_1')
                              AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO)
                       END) DT_ABERTURA,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          'PA'
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          'INTERNACAO'
                       END) LOCAL_ABERTURA,
                       (CASE
                         WHEN (SELECT TO_CHAR(ERC.LO_VALOR)
                                 FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                                 JOIN DBAMV.EDITOR_CAMPO EDC
                                   ON EDC.CD_CAMPO = ERC.CD_CAMPO
                                 JOIN PW_EDITOR_CLINICO EC1
                                   ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                                 JOIN PW_DOCUMENTO_CLINICO DC1
                                   ON DC1.CD_DOCUMENTO_CLINICO =
                                      EC1.CD_DOCUMENTO_CLINICO
                                WHERE EC1.CD_DOCUMENTO = 934
                                  AND DC1.TP_STATUS = 'FECHADO'
                                  AND EDC.DS_IDENTIFICADOR IN
                                      ('CK_PROT_TORA_DIREC_C_1')
                                  AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO) =
                              'true' THEN
                          'TIPO C'
                         WHEN (SELECT TO_CHAR(ERC.LO_VALOR)
                                 FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                                 JOIN DBAMV.EDITOR_CAMPO EDC
                                   ON EDC.CD_CAMPO = ERC.CD_CAMPO
                                 JOIN PW_EDITOR_CLINICO EC1
                                   ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                                 JOIN PW_DOCUMENTO_CLINICO DC1
                                   ON DC1.CD_DOCUMENTO_CLINICO =
                                      EC1.CD_DOCUMENTO_CLINICO
                                WHERE EC1.CD_DOCUMENTO = 934
                                  AND DC1.TP_STATUS = 'FECHADO'
                                  AND EDC.DS_IDENTIFICADOR IN
                                      ('CK_PROT_TORA_DIREC_B_1')
                                  AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO) =
                              'true' THEN
                          'TIPO B'
                         WHEN (SELECT TO_CHAR(ERC.LO_VALOR)
                                 FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                                 JOIN DBAMV.EDITOR_CAMPO EDC
                                   ON EDC.CD_CAMPO = ERC.CD_CAMPO
                                 JOIN PW_EDITOR_CLINICO EC1
                                   ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                                 JOIN PW_DOCUMENTO_CLINICO DC1
                                   ON DC1.CD_DOCUMENTO_CLINICO =
                                      EC1.CD_DOCUMENTO_CLINICO
                                WHERE EC1.CD_DOCUMENTO = 934
                                  AND DC1.TP_STATUS = 'FECHADO'
                                  AND EDC.DS_IDENTIFICADOR IN
                                      ('CK_PROT_TORA_DIREC_A_1')
                                  AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO) =
                              'true' THEN
                          'TIPO A'
                         WHEN (SELECT TO_CHAR(ERC.LO_VALOR)
                                 FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                                 JOIN DBAMV.EDITOR_CAMPO EDC
                                   ON EDC.CD_CAMPO = ERC.CD_CAMPO
                                 JOIN PW_EDITOR_CLINICO EC1
                                   ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                                 JOIN PW_DOCUMENTO_CLINICO DC1
                                   ON DC1.CD_DOCUMENTO_CLINICO =
                                      EC1.CD_DOCUMENTO_CLINICO
                                WHERE EC1.CD_DOCUMENTO = 934
                                  AND DC1.TP_STATUS = 'FECHADO'
                                  AND EDC.DS_IDENTIFICADOR IN
                                      ('CK_PROT_TORA_DIREC_D_1')
                                  AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO) =
                              'true' THEN
                          'TIPO D'
                       END) TIPO,
                       'AJUSTAR' PERIODO_ADMISSAO,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          NVL((SELECT MIN(PEL.CD_PED_LAB)
                                FROM PED_LAB PEL
                                JOIN ITPED_LAB IPEL
                                  ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                               WHERE PEL.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                                 AND IPEL.CD_EXA_LAB = 1208),
                              (SELECT MIN(PEL.CD_PED_LAB)
                                 FROM DBAMV.PED_LAB PEL
                                 JOIN DBAMV.ITPED_LAB IPEL
                                   ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                                 JOIN DBAMV.ATENDIME ATE2
                                   ON ATE2.CD_ATENDIMENTO = PEL.CD_ATENDIMENTO
                                WHERE ATE2.CD_PACIENTE = ATE.CD_PACIENTE
                                  AND IPEL.CD_EXA_LAB = 1208
                                  AND TRUNC(PEL.DT_PEDIDO) BETWEEN
                                      (TRUNC(ATE.DT_ATENDIMENTO) - 24 / 24) AND
                                      NVL(TRUNC(ATE.DT_ALTA), SYSDATE)))
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          (SELECT MIN(PEL.CD_PED_LAB)
                             FROM PED_LAB PEL
                             JOIN ITPED_LAB IPEL
                               ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                            WHERE PEL.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                              AND IPEL.CD_EXA_LAB = 1208)
                       END) PED_TROPONINA,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          NVL((SELECT MIN(PEL.DT_PEDIDO)
                                FROM PED_LAB PEL
                                JOIN ITPED_LAB IPEL
                                  ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                               WHERE PEL.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                                 AND IPEL.CD_EXA_LAB = 1208),
                              (SELECT MIN(PEL.DT_PEDIDO)
                                 FROM DBAMV.PED_LAB PEL
                                 JOIN DBAMV.ITPED_LAB IPEL
                                   ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                                 JOIN DBAMV.ATENDIME ATE2
                                   ON ATE2.CD_ATENDIMENTO = PEL.CD_ATENDIMENTO
                                WHERE ATE2.CD_PACIENTE = ATE.CD_PACIENTE
                                  AND IPEL.CD_EXA_LAB = 1208
                                  AND TRUNC(PEL.DT_PEDIDO) BETWEEN
                                      (TRUNC(ATE.DT_ATENDIMENTO) - 24 / 24) AND
                                      NVL(TRUNC(ATE.DT_ALTA), SYSDATE)))
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          (SELECT MIN(PEL.DT_PEDIDO)
                             FROM PED_LAB PEL
                             JOIN ITPED_LAB IPEL
                               ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                            WHERE PEL.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                              AND IPEL.CD_EXA_LAB = 1208)
                       END) DT_SOLICITACAO,
                       'AJUSTAR' DT_ENTREGA_AMOSTRA,
                       'AJUSTAR' DT_LAUDO,
                       'AJUSTAR' TMP_AMOSTRA_X_LAUDO,
                       'AJUSTAR' ADESAO_META_40,
                       'AJUSTAR' TMP_SOLIC_X_LAUDO,
                       'AJUSTAR' ADESAO_META_70,
                       (SELECT TO_CHAR(ERC.LO_VALOR)
                          FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                          JOIN DBAMV.EDITOR_CAMPO EDC
                            ON EDC.CD_CAMPO = ERC.CD_CAMPO
                          JOIN PW_EDITOR_CLINICO EC1
                            ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                          JOIN PW_DOCUMENTO_CLINICO DC1
                            ON DC1.CD_DOCUMENTO_CLINICO =
                               EC1.CD_DOCUMENTO_CLINICO
                         WHERE EC1.CD_DOCUMENTO = 934
                           AND DC1.TP_STATUS = 'FECHADO'
                           AND EDC.DS_IDENTIFICADOR IN ('HR_PROT_TORA_ECG_1')
                           AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO) H_SOLIC_ECG,
                       NULL H_REALIZ_ECG,
                       NULL TMP_SOLIC_X_REALIZ_ECG,
                       NULL ADESAO_ECG_META_10,
                       (SELECT TO_CHAR(ERC.LO_VALOR)
                          FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                          JOIN DBAMV.EDITOR_CAMPO EDC
                            ON EDC.CD_CAMPO = ERC.CD_CAMPO
                          JOIN PW_EDITOR_CLINICO EC1
                            ON EC1.CD_EDITOR_REGISTRO = ERC.CD_REGISTRO
                          JOIN PW_DOCUMENTO_CLINICO DC1
                            ON DC1.CD_DOCUMENTO_CLINICO =
                               EC1.CD_DOCUMENTO_CLINICO
                         WHERE EC1.CD_DOCUMENTO = 934
                           AND DC1.TP_STATUS = 'FECHADO'
                           AND EDC.DS_IDENTIFICADOR IN ('HR_PROT_TORA_ECG_1')
                           AND ERC.CD_REGISTRO = EC.CD_EDITOR_REGISTRO) ECG_VISTO_MED,
                       NULL TMP_REALIZ_Z_X_VISTO_MED,
                       (SELECT TO_CHAR(ERC.LO_VALOR)
                          FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                          JOIN DBAMV.EDITOR_CAMPO EDC
                            ON EDC.CD_CAMPO = ERC.CD_CAMPO
                         WHERE EDC.DS_IDENTIFICADOR IN ('HR_TROMBOLISE_1')
                           AND ERC.CD_REGISTRO =
                               (SELECT MAX(EC1.CD_EDITOR_REGISTRO)
                                  FROM PW_EDITOR_CLINICO EC1
                                  JOIN PW_DOCUMENTO_CLINICO DC1
                                    ON DC1.CD_DOCUMENTO_CLINICO =
                                       EC1.CD_DOCUMENTO_CLINICO
                                 WHERE EC1.CD_DOCUMENTO = 701
                                   AND DC1.TP_STATUS = 'FECHADO'
                                   AND DC1.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO)) DT_INICIO_TROMBOLITICO,
                       NULL TMP_TROMBOLISE,
                       NULL ADESAO_PORTAGUL_META_30,
                       (SELECT TO_CHAR(ERC.LO_VALOR) DS_RESPOSTA
                          FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                         INNER JOIN DBAMV.EDITOR_CAMPO EC
                            ON EC.CD_CAMPO = ERC.CD_CAMPO
                         WHERE ERC.CD_REGISTRO IN
                               (SELECT MIN(PE.CD_EDITOR_REGISTRO)
                                  FROM DBAMV.PW_EDITOR_CLINICO PE
                                 INNER JOIN DBAMV.PW_DOCUMENTO_CLINICO PE1
                                    ON PE1.CD_DOCUMENTO_CLINICO =
                                       PE.CD_DOCUMENTO_CLINICO
                                 WHERE PE1. CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                                   AND PE.CD_DOCUMENTO = 668
                                   AND PE1.TP_STATUS = 'FECHADO')
                           AND UPPER(EC.DS_IDENTIFICADOR) =
                               'DT_ABERTURA_PROTOCOLO_HEMO_1') H_ABERTURA_ARTERIA,
                       NULL TMP_PORTA_BALAO,
                       NULL ADESAO_PORTBALAO_META_90,
                       NULL DIAGNOSTICO,
                       NULL P_ANTIPLAQ,
                       NULL P_BETA_BLOQUEADOR,
                       NULL P_IECA,
                       NULL ADESAO_PRESC_ALTA,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          NULL
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          TRUNC(ATE.DT_ATENDIMENTO)
                       END) DT_INTERNACAO,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          NULL
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          TRUNC(ATE.DT_ALTA)
                       END) DT_ALTA,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          NULL
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          ROUND(TRUNC(ATE.DT_ALTA) - TRUNC(ATE.DT_ATENDIMENTO))
                       END) DIAS_INTERNACAO,
                       NULL ADESAO_DIAS_INTER,
                       NULL ADESAO_GLOBAL_MARCADORES,
                       NULL ECO,
                       NULL CONDUTA_HMD,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'U' AND
                              ATE.DT_ALTA IS NOT NULL THEN
                          NVL((SELECT (CASE
                                       WHEN MA.CD_MOT_ALT IN
                                            (1, 2, 10, 11, 12, 13) THEN
                                        'ALTA PA'
                                       WHEN MA.CD_MOT_ALT IN
                                            (5, 6, 7, 14, 15, 16) THEN
                                        'OBITO'
                                       WHEN MA.CD_MOT_ALT IN (9, 17) THEN
                                        'ALTA ADM'
                                       WHEN MA.CD_MOT_ALT IN (3, 4) THEN
                                        'ALTA EVASAO/PEDIDO'
                                       WHEN MA.CD_MOT_ALT IN (8) THEN
                                        'TRANSFERENCIA'
                                       ELSE
                                        MA.DS_MOT_ALT
                                     END)
                                FROM MOT_ALT MA
                               WHERE MA.CD_MOT_ALT = ATE.CD_MOT_ALT),
                              (SELECT (CASE
                                        WHEN TR.CD_TIP_RES IN (23, 24, 33) THEN
                                         'ALTA PA'
                                        WHEN TR.CD_TIP_RES IN (21) THEN
                                         'OBITO'
                                        WHEN TR.CD_TIP_RES IN (17) THEN
                                         'ALTA EVASAO/PEDIDO'
                                        WHEN TR.CD_TIP_RES IN (2) THEN
                                         'TRANSFERENCIA'
                                        ELSE
                                         TR.DS_TIP_RES
                                      END)
                                 FROM TIP_RES TR
                                WHERE TR.CD_TIP_RES = ATE.CD_TIP_RES))

                         WHEN ATE.TP_ATENDIMENTO = 'I' AND
                              ATE.DT_ALTA IS NOT NULL THEN
                          NVL((SELECT (CASE
                                       WHEN MA.CD_MOT_ALT IN
                                            (1, 2, 10, 11, 12, 13) THEN
                                        'ALTA INTERNACAO'
                                       WHEN MA.CD_MOT_ALT IN
                                            (5, 6, 7, 14, 15, 16) THEN
                                        'OBITO'
                                       WHEN MA.CD_MOT_ALT IN (9, 17) THEN
                                        'ALTA ADM'
                                       WHEN MA.CD_MOT_ALT IN (3, 4) THEN
                                        'ALTA EVASAO/PEDIDO'
                                       WHEN MA.CD_MOT_ALT IN (8) THEN
                                        'TRANSFERENCIA'
                                       ELSE
                                        MA.DS_MOT_ALT
                                     END)
                                FROM MOT_ALT MA
                               WHERE MA.CD_MOT_ALT = ATE.CD_MOT_ALT),
                              (SELECT (CASE
                                        WHEN TR.CD_TIP_RES IN (23, 24, 33) THEN
                                         'ALTA INTERNACAO'
                                        WHEN TR.CD_TIP_RES IN (21) THEN
                                         'OBITO'
                                        WHEN TR.CD_TIP_RES IN (17) THEN
                                         'ALTA EVASAO/PEDIDO'
                                        WHEN TR.CD_TIP_RES IN (2) THEN
                                         'TRANSFERENCIA'
                                        ELSE
                                         TR.DS_TIP_RES
                                      END)
                                 FROM TIP_RES TR
                                WHERE TR.CD_TIP_RES = ATE.CD_TIP_RES))
                         WHEN ATE.TP_ATENDIMENTO = 'I' AND ATE.DT_ALTA IS NULL THEN
                          'INTERNADO'
                       END) DESTINO_FINAL,
                       NULL CONF_DIAGNOSTICO,
                       NULL MES,
                       NULL ANALISE,
                       'Protocolo de Dor Toracica Internacao' DOCUMENTO,
                       DC.DH_REFERENCIA DT_REGISTRO
                  FROM DBAMV.PW_DOCUMENTO_CLINICO DC
                  JOIN DBAMV.PW_EDITOR_CLINICO EC
                    ON EC.CD_DOCUMENTO_CLINICO = DC.CD_DOCUMENTO_CLINICO
                  JOIN DBAMV.ATENDIME ATE
                    ON ATE.CD_ATENDIMENTO = DC.CD_ATENDIMENTO
                  JOIN PACIENTE PAC
                    ON PAC.CD_PACIENTE = ATE.CD_PACIENTE
                 WHERE EC.CD_DOCUMENTO = 934
                   AND DC.TP_STATUS = 'FECHADO'
                   AND DC.DH_REFERENCIA BETWEEN
                       ADD_MONTHS(TRUNC(SYSDATE, 'Month'), -6) and
                       trunc(sysdate)

                UNION ALL

                --SEM PROTOCOLOS ABERTOS MAS MARCADO NA ANAMNESE DE CARDIOLOGIA 701
                SELECT ATE.CD_ATENDIMENTO,
                       PAC.CD_PACIENTE SAME,
                       PAC.NM_PACIENTE,
                       fnc_hnb_obter_idade(pac.dt_nascimento,
                                           ATE.DT_ATENDIMENTO) idade,
                       decode(pac.tp_sexo,
                              'F',
                              'FEMININO',
                              'M',
                              'MASCULINO',
                              'I',
                              'INDEFINIDO') SEXO,
                       NVL((SELECT TO_CHAR(MIN(STP.DH_PROCESSO),
                                           'DD/MM/RRRR HH24:MI:SS')
                              FROM SACR_TEMPO_PROCESSO STP
                             WHERE STP.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                               AND STP.CD_TIPO_TEMPO_PROCESSO = 1)
                       ,TO_CHAR(TO_DATE(TO_CHAR(ATE.DT_ATENDIMENTO,
                                               'DD/MM/RRRR') ||
                                       TO_CHAR(ATE.HR_ATENDIMENTO,
                                               'HH24:MI:SS'),
                                       'DD/MM/RRRR HH24:MI:SS'),
                               'DD/MM/RRRR HH24:MI:SS')) DT_ABERTURA,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          'PA'
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          'INTERNACAO'
                       END) LOCAL_ABERTURA,
                       NULL TIPO,
                       'AJUSTAR' PERIODO_ADMISSAO,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          NVL((SELECT MIN(PEL.CD_PED_LAB)
                                FROM PED_LAB PEL
                                JOIN ITPED_LAB IPEL
                                  ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                               WHERE PEL.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                                 AND IPEL.CD_EXA_LAB = 1208),
                              (SELECT MIN(PEL.CD_PED_LAB)
                                 FROM DBAMV.PED_LAB PEL
                                 JOIN DBAMV.ITPED_LAB IPEL
                                   ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                                 JOIN DBAMV.ATENDIME ATE2
                                   ON ATE2.CD_ATENDIMENTO = PEL.CD_ATENDIMENTO
                                WHERE ATE2.CD_PACIENTE = ATE.CD_PACIENTE
                                  AND IPEL.CD_EXA_LAB = 1208
                                  AND TRUNC(PEL.DT_PEDIDO) BETWEEN
                                      (TRUNC(ATE.DT_ATENDIMENTO) - 24 / 24) AND
                                      NVL(TRUNC(ATE.DT_ALTA), SYSDATE)))
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          (SELECT MIN(PEL.CD_PED_LAB)
                             FROM PED_LAB PEL
                             JOIN ITPED_LAB IPEL
                               ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                            WHERE PEL.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                              AND IPEL.CD_EXA_LAB = 1208)
                       END) PED_TROPONINA,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          NVL((SELECT MIN(PEL.DT_PEDIDO)
                                FROM PED_LAB PEL
                                JOIN ITPED_LAB IPEL
                                  ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                               WHERE PEL.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                                 AND IPEL.CD_EXA_LAB = 1208),
                              (SELECT MIN(PEL.DT_PEDIDO)
                                 FROM DBAMV.PED_LAB PEL
                                 JOIN DBAMV.ITPED_LAB IPEL
                                   ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                                 JOIN DBAMV.ATENDIME ATE2
                                   ON ATE2.CD_ATENDIMENTO = PEL.CD_ATENDIMENTO
                                WHERE ATE2.CD_PACIENTE = ATE.CD_PACIENTE
                                  AND IPEL.CD_EXA_LAB = 1208
                                  AND TRUNC(PEL.DT_PEDIDO) BETWEEN
                                      (TRUNC(ATE.DT_ATENDIMENTO) - 24 / 24) AND
                                      NVL(TRUNC(ATE.DT_ALTA), SYSDATE)))
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          (SELECT MIN(PEL.DT_PEDIDO)
                             FROM PED_LAB PEL
                             JOIN ITPED_LAB IPEL
                               ON IPEL.CD_PED_LAB = PEL.CD_PED_LAB
                            WHERE PEL.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                              AND IPEL.CD_EXA_LAB = 1208)
                       END) DT_SOLICITACAO,
                       'AJUSTAR' DT_ENTREGA_AMOSTRA,
                       'AJUSTAR' DT_LAUDO,
                       'AJUSTAR' TMP_AMOSTRA_X_LAUDO,
                       'AJUSTAR' ADESAO_META_40,
                       'AJUSTAR' TMP_SOLIC_X_LAUDO,
                       'AJUSTAR' ADESAO_META_70,
                       NULL H_SOLIC_ECG,
                       NULL H_REALIZ_ECG,
                       NULL TMP_SOLIC_X_REALIZ_ECG,
                       NULL ADESAO_ECG_META_10,
                       NULL ECG_VISTO_MED,
                       NULL TMP_REALIZ_Z_X_VISTO_MED,
                       (SELECT TO_CHAR(ERC.LO_VALOR)
                          FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                          JOIN DBAMV.EDITOR_CAMPO EDC
                            ON EDC.CD_CAMPO = ERC.CD_CAMPO
                         WHERE EDC.DS_IDENTIFICADOR IN ('HR_TROMBOLISE_1')
                           AND ERC.CD_REGISTRO =
                               (SELECT MAX(EC1.CD_EDITOR_REGISTRO)
                                  FROM PW_EDITOR_CLINICO EC1
                                  JOIN PW_DOCUMENTO_CLINICO DC1
                                    ON DC1.CD_DOCUMENTO_CLINICO =
                                       EC1.CD_DOCUMENTO_CLINICO
                                 WHERE EC1.CD_DOCUMENTO = 701
                                   AND DC1.TP_STATUS = 'FECHADO'
                                   AND DC1.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO)) DT_INICIO_TROMBOLITICO,
                       NULL TMP_TROMBOLISE,
                       NULL ADESAO_PORTAGUL_META_30,
                       (SELECT TO_CHAR(ERC.LO_VALOR) DS_RESPOSTA
                          FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                         INNER JOIN DBAMV.EDITOR_CAMPO EC
                            ON EC.CD_CAMPO = ERC.CD_CAMPO
                         WHERE ERC.CD_REGISTRO IN
                               (SELECT MIN(PE.CD_EDITOR_REGISTRO)
                                  FROM DBAMV.PW_EDITOR_CLINICO PE
                                 INNER JOIN DBAMV.PW_DOCUMENTO_CLINICO PE1
                                    ON PE1.CD_DOCUMENTO_CLINICO =
                                       PE.CD_DOCUMENTO_CLINICO
                                 WHERE PE1. CD_ATENDIMENTO = ATE.CD_ATENDIMENTO
                                   AND PE.CD_DOCUMENTO = 668
                                   AND PE1.TP_STATUS = 'FECHADO')
                           AND UPPER(EC.DS_IDENTIFICADOR) =
                               'DT_ABERTURA_PROTOCOLO_HEMO_1') H_ABERTURA_ARTERIA,
                       NULL TMP_PORTA_BALAO,
                       NULL ADESAO_PORTBALAO_META_90,
                       NULL DIAGNOSTICO,
                       NULL P_ANTIPLAQ,
                       NULL P_BETA_BLOQUEADOR,
                       NULL P_IECA,
                       NULL ADESAO_PRESC_ALTA,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          NULL
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          TRUNC(ATE.DT_ATENDIMENTO)
                       END) DT_INTERNACAO,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          NULL
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          TRUNC(ATE.DT_ALTA)
                       END) DT_ALTA,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'U' THEN
                          NULL
                         WHEN ATE.TP_ATENDIMENTO = 'I' THEN
                          ROUND(TRUNC(ATE.DT_ALTA) - TRUNC(ATE.DT_ATENDIMENTO))
                       END) DIAS_INTERNACAO,
                       NULL ADESAO_DIAS_INTER,
                       NULL ADESAO_GLOBAL_MARCADORES,
                       NULL ECO,
                       NULL CONDUTA_HMD,
                       (CASE
                         WHEN ATE.TP_ATENDIMENTO = 'U' AND
                              ATE.DT_ALTA IS NOT NULL THEN
                          NVL((SELECT (CASE
                                       WHEN MA.CD_MOT_ALT IN
                                            (1, 2, 10, 11, 12, 13) THEN
                                        'ALTA PA'
                                       WHEN MA.CD_MOT_ALT IN
                                            (5, 6, 7, 14, 15, 16) THEN
                                        'OBITO'
                                       WHEN MA.CD_MOT_ALT IN (9, 17) THEN
                                        'ALTA ADM'
                                       WHEN MA.CD_MOT_ALT IN (3, 4) THEN
                                        'ALTA EVASAO/PEDIDO'
                                       WHEN MA.CD_MOT_ALT IN (8) THEN
                                        'TRANSFERENCIA'
                                       ELSE
                                        MA.DS_MOT_ALT
                                     END)
                                FROM MOT_ALT MA
                               WHERE MA.CD_MOT_ALT = ATE.CD_MOT_ALT),
                              (SELECT (CASE
                                        WHEN TR.CD_TIP_RES IN (23, 24, 33) THEN
                                         'ALTA PA'
                                        WHEN TR.CD_TIP_RES IN (21) THEN
                                         'OBITO'
                                        WHEN TR.CD_TIP_RES IN (17) THEN
                                         'ALTA EVASAO/PEDIDO'
                                        WHEN TR.CD_TIP_RES IN (2) THEN
                                         'TRANSFERENCIA'
                                        ELSE
                                         TR.DS_TIP_RES
                                      END)
                                 FROM TIP_RES TR
                                WHERE TR.CD_TIP_RES = ATE.CD_TIP_RES))

                         WHEN ATE.TP_ATENDIMENTO = 'I' AND
                              ATE.DT_ALTA IS NOT NULL THEN
                          NVL((SELECT (CASE
                                       WHEN MA.CD_MOT_ALT IN
                                            (1, 2, 10, 11, 12, 13) THEN
                                        'ALTA INTERNACAO'
                                       WHEN MA.CD_MOT_ALT IN
                                            (5, 6, 7, 14, 15, 16) THEN
                                        'OBITO'
                                       WHEN MA.CD_MOT_ALT IN (9, 17) THEN
                                        'ALTA ADM'
                                       WHEN MA.CD_MOT_ALT IN (3, 4) THEN
                                        'ALTA EVASAO/PEDIDO'
                                       WHEN MA.CD_MOT_ALT IN (8) THEN
                                        'TRANSFERENCIA'
                                       ELSE
                                        MA.DS_MOT_ALT
                                     END)
                                FROM MOT_ALT MA
                               WHERE MA.CD_MOT_ALT = ATE.CD_MOT_ALT),
                              (SELECT (CASE
                                        WHEN TR.CD_TIP_RES IN (23, 24, 33) THEN
                                         'ALTA INTERNACAO'
                                        WHEN TR.CD_TIP_RES IN (21) THEN
                                         'OBITO'
                                        WHEN TR.CD_TIP_RES IN (17) THEN
                                         'ALTA EVASAO/PEDIDO'
                                        WHEN TR.CD_TIP_RES IN (2) THEN
                                         'TRANSFERENCIA'
                                        ELSE
                                         TR.DS_TIP_RES
                                      END)
                                 FROM TIP_RES TR
                                WHERE TR.CD_TIP_RES = ATE.CD_TIP_RES))
                         WHEN ATE.TP_ATENDIMENTO = 'I' AND ATE.DT_ALTA IS NULL THEN
                          'INTERNADO'
                       END) DESTINO_FINAL,
                       NULL CONF_DIAGNOSTICO,
                       NULL MES,
                       NULL ANALISE,
                       'Anamnese Cardiologia' DOCUMENTO,
                       (SELECT MAX(DC1.DH_REFERENCIA)
                                  FROM PW_EDITOR_CLINICO EC1
                                  JOIN PW_DOCUMENTO_CLINICO DC1
                                    ON DC1.CD_DOCUMENTO_CLINICO =
                                       EC1.CD_DOCUMENTO_CLINICO
                                 WHERE EC1.CD_DOCUMENTO = 701
                                   AND DC1.TP_STATUS = 'FECHADO'
                                   AND DC1.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO) DT_REGISTRO
                  FROM DBAMV.ATENDIME ATE
                  JOIN DBAMV.PACIENTE PAC
                    ON PAC.CD_PACIENTE = ATE.CD_PACIENTE
                 WHERE ATE.DT_ATENDIMENTO BETWEEN
                       ADD_MONTHS(TRUNC(SYSDATE, 'Month'), -6) and
                       trunc(sysdate)
                       
                   AND ATE.TP_ATENDIMENTO = 'U'
                   AND ATE.CD_MULTI_EMPRESA = 1
                   AND NOT
                        EXISTS((SELECT 1
                                 FROM PW_EDITOR_CLINICO EC1
                                 JOIN PW_DOCUMENTO_CLINICO DC1
                                   ON DC1.CD_DOCUMENTO_CLINICO =
                                      EC1.CD_DOCUMENTO_CLINICO
                                WHERE EC1.CD_DOCUMENTO IN (729, 934)
                                  AND DC1.TP_STATUS = 'FECHADO'
                                  AND DC1.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO))
                   AND EXISTS((SELECT 1
                                FROM PW_EDITOR_CLINICO EC1
                                JOIN PW_DOCUMENTO_CLINICO DC1
                                  ON DC1.CD_DOCUMENTO_CLINICO =
                                     EC1.CD_DOCUMENTO_CLINICO
                               WHERE EC1.CD_DOCUMENTO IN (701)
                                 AND DC1.TP_STATUS = 'FECHADO'
                                 AND DC1.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO))
                   AND 1 =
                       (SELECT SUBSTR(TO_CHAR(ERC.LO_VALOR), 1, 1)
                          FROM DBAMV.EDITOR_REGISTRO_CAMPO ERC
                          JOIN DBAMV.EDITOR_CAMPO EDC
                            ON EDC.CD_CAMPO = ERC.CD_CAMPO
                         WHERE EDC.DS_IDENTIFICADOR IN ('CB_DOR_TORXA_1')
                           AND ERC.CD_REGISTRO =
                               (SELECT MAX(EC1.CD_EDITOR_REGISTRO)
                                  FROM PW_EDITOR_CLINICO EC1
                                  JOIN PW_DOCUMENTO_CLINICO DC1
                                    ON DC1.CD_DOCUMENTO_CLINICO =
                                       EC1.CD_DOCUMENTO_CLINICO
                                 WHERE EC1.CD_DOCUMENTO = 701
                                   AND DC1.TP_STATUS = 'FECHADO'
                                   AND DC1.CD_ATENDIMENTO = ATE.CD_ATENDIMENTO))) DD1) DD2
)X
WHERE X.DT_BUSCA_RELAT BETWEEN @pDataIni AND @pDataFim
