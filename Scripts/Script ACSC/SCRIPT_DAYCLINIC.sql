
SELECT 

CD_UNID_INT||' - '||DS_UNIDADE UNID_INTER,
CD_CONVENIO||' - '||NM_CONVENIO CONVENIO,
DS_CON_PLA PLANO,
PAC_INT_00H,
ENT_INTERNADOS INTERNADOS,
ENT_TRANSF TRASF_DE,
SAI_ALTAS ALTAS,
SAI_TRANSFPARA TRASF_PARA,
SAI_OBITOS,
HOSP_DIA,
(PAC_INT_00H + ENT_INTERNADOS + ENT_TRANSF) - (SAI_ALTAS + SAI_TRANSFPARA + SAI_OBITOS)PAC_DIA
FROM
(
SELECT UNID_INT . CD_UNID_INT CD_UNID_INT,
               UNID_INT . DS_UNID_INT DS_UNIDADE,
               CONVENIO . TP_CONVENIO TP_CONVENIO,
               CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
               ATENDIME . CD_CON_PLA,
               CON_PLA  .DS_CON_PLA,
               COUNT(*) PAC_INT_00H,
               0 ENT_INTERNADOS,
               0 ENT_TRANSF,
               0 SAI_ALTAS,
               0 SAI_TRANSFPARA,
               0 SAI_OBITOS,
               0 SAI_OBITOS48,
               0 SAI_OBITOS24,
               0 HOSP_DIA,
               0 OBITO_DIA
          From DBAMV . MOV_INT,
               DBAMV . UNID_INT,
               DBAMV . LEITO,
               DBAMV . ATENDIME,
               DBAMV . CONVENIO,
               DBAMV .CON_PLA,
               (SELECT ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM DATA FROM DBAMV . CID
                WHERE ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM <= (to_Date('&data_fim','dd/mm/rrrr'))) CONTADOR
         WHERE Trunc(DT_MOV_INT) <= CONTADOR .DATA - 1
          And TRUNC(NVL(DT_LIB_MOV, SYSDATE)) > CONTADOR .DATA - 1
           And TP_MOV IN ('O', 'I')
           And LEITO . CD_UNID_INT = UNID_INT . CD_UNID_INT
           And MOV_INT . CD_ATENDIMENTO = ATENDIME .CD_ATENDIMENTO
           And (ATENDIME . TP_ATENDIMENTO IN ('I', 'H', 'U'))
           And MOV_INT . CD_LEITO = LEITO . CD_LEITO
           And ATENDIME . CD_CONVENIO = CONVENIO . CD_CONVENIO
           AND CON_PLA.CD_CONVENIO = ATENDIME.CD_CONVENIO 
           AND CON_PLA.CD_CON_PLA = ATENDIME.CD_CON_PLA 
           AND ATENDIME . CD_MULTI_EMPRESA = 7
           AND UNID_INT.TP_UNID_INT = 'I'
           AND NVL(UNID_INT.SN_HOSPITAL_DIA, 'N') = 'N'
           AND Atendime.CD_MULTI_EMPRESA = '7'
           AND ATENDIME.CD_ATENDIMENTO_PAI IS NULL
         Group BY UNID_INT . CD_UNID_INT,
                  UNID_INT . DS_UNID_INT,
                  CONVENIO . TP_CONVENIO,
                  CONVENIO . CD_CONVENIO,
                  CONVENIO . NM_CONVENIO,
                   ATENDIME . CD_CON_PLA,
                   CON_PLA  . DS_CON_PLA
             

        Union
        Select UNID_INT . CD_UNID_INT CD_UNID_INT,
               UNID_INT . DS_UNID_INT DS_UNIDADE,
               CONVENIO . TP_CONVENIO TP_CONVENIO,
               CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
                ATENDIME . CD_CON_PLA,
                CON_PLA  . DS_CON_PLA,
              
               0 PAC_INT_00H,
               Count(*) ENT_INTERNADOS,
               0 ENT_TRANSF,
               0 SAI_ALTAS,
               0 SAI_TRANSFPARA,
               0 SAI_OBITOS,
               0 SAI_OBITOS48,
               0 SAI_OBITOS24,
               0 HOSP_DIA,
               0 OBITO_DIA
          From DBAMV . ATENDIME,
               DBAMV . UNID_INT,
               DBAMV . LEITO,
               DBAMV . MOV_INT,
               DBAMV . CONVENIO,
                DBAMV .CON_PLA,
               (SELECT ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM DATA FROM DBAMV . CID
                WHERE ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM <= (to_Date('&data_fim','dd/mm/rrrr'))) CONTADOR
         WHERE LEITO . CD_UNID_INT = UNID_INT . CD_UNID_INT
           And LEITO . CD_LEITO = MOV_INT .CD_LEITO
           And TRUNC(DT_MOV_INT) = TRUNC(CONTADOR . DATA)
           And MOV_INT . TP_MOV = 'I'
           And ATENDIME . CD_ATENDIMENTO = MOV_INT .CD_ATENDIMENTO
           And (ATENDIME . TP_ATENDIMENTO IN ('I', 'H', 'U'))
           and not exists
         (select 'X'
                  from dbamv . mov_int mi
                 where mi . cd_atendimento = mov_int .cd_atendimento
                   AND TRUNC(mi . dt_mov_int) +
                       (mi . hr_mov_int - TRUNC(mi . hr_mov_int)) <
                       TRUNC(mov_int . dt_mov_int) +
                       (mov_int . hr_mov_int - TRUNC(mov_int . hr_mov_int))
                   and mi . cd_leito = mov_int . cd_leito
                   and mi . cd_tip_acom <> mov_int . cd_tip_acom
                   and mi .tp_mov <> 'R'
                   and nvl(mi . cd_leito_anterior, mi . cd_leito) = nvl(mov_int . cd_leito_anterior, mov_int . cd_leito))
           And ATENDIME . CD_CONVENIO = CONVENIO .CD_CONVENIO
            AND CON_PLA.CD_CONVENIO = ATENDIME.CD_CONVENIO 
           AND CON_PLA.CD_CON_PLA = ATENDIME.CD_CON_PLA 
           AND ATENDIME . CD_MULTI_EMPRESA = 7
           AND UNID_INT.TP_UNID_INT = 'I'
           AND NVL(UNID_INT.SN_HOSPITAL_DIA, 'N') = 'N'
           AND Atendime.CD_MULTI_EMPRESA = '7'
           AND ATENDIME.CD_ATENDIMENTO_PAI IS NULL
         Group By UNID_INT . CD_UNID_INT,
                  UNID_INT . DS_UNID_INT,
                  CONVENIO . TP_CONVENIO,
                  CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
                ATENDIME . CD_CON_PLA,
                   CON_PLA  . DS_CON_PLA
               
        UNION
        Select UNID_INT . CD_UNID_INT CD_UNID_INT,
               UNID_INT . DS_UNID_INT DS_UNIDADE,
               CONVENIO . TP_CONVENIO TP_CONVENIO,
               CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
                ATENDIME . CD_CON_PLA,
                   CON_PLA  . DS_CON_PLA,
               
               0 PAC_INT_00H,
               0 ENT_INTERNADOS,
               Count(*) ENT_TRANSF,
               0 SAI_ALTAS,
               0 SAI_TRANSFPARA,
               0 SAI_OBITOS,
               0 SAI_OBITOS48,
               0 SAI_OBITOS24,
               0 HOSP_DIA,
               0 OBITO_DIA
          From DBAMV . MOV_INT,
               DBAMV . UNID_INT,
               DBAMV . UNID_INT UNID_INT1,
               DBAMV . LEITO,
               DBAMV . LEITO LEITO1,
               DBAMV . ATENDIME,
               DBAMV . CONVENIO,
                DBAMV .CON_PLA,
               (SELECT ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM DATA
                  FROM DBAMV . CID
                 WHERE ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM <= (to_Date('&data_fim','dd/mm/rrrr'))) CONTADOR
         Where MOV_INT . TP_MOV = 'O'
           And Trunc(MOV_INT . DT_MOV_INT) = CONTADOR . DATA
           And MOV_INT . CD_LEITO = LEITO . CD_LEITO
           And MOV_INT . CD_LEITO_ANTERIOR = LEITO1 . CD_LEITO
           And LEITO1 . CD_UNID_INT = UNID_INT1 . CD_UNID_INT
           And UNID_INT . CD_UNID_INT <> UNID_INT1 . CD_UNID_INT
           And LEITO . CD_UNID_INT = UNID_INT . CD_UNID_INT
           And ATENDIME . CD_ATENDIMENTO = MOV_INT .CD_ATENDIMENTO
           And (ATENDIME . TP_ATENDIMENTO IN ('I', 'H', 'U'))
           and not exists
         (select 'X'
                  from dbamv . mov_int mi
                 where mi . cd_atendimento = mov_int .
                 cd_atendimento
                   AND TRUNC(mi . dt_mov_int) +
                       (mi . hr_mov_int - TRUNC(mi . hr_mov_int)) < TRUNC(mov_int . dt_mov_int) +
                       (mov_int . hr_mov_int - TRUNC(mov_int . hr_mov_int))
                   and mi . cd_leito = mov_int . cd_leito
                   and mi . cd_tip_acom <> mov_int . cd_tip_acom
                   and mi . tp_mov <> 'R'
                   and nvl(mi . cd_leito_anterior, mi . cd_leito) = nvl(mov_int . cd_leito_anterior, mov_int . cd_leito))
           And ATENDIME . CD_CONVENIO = CONVENIO .CD_CONVENIO
            AND CON_PLA.CD_CONVENIO = ATENDIME.CD_CONVENIO 
           AND CON_PLA.CD_CON_PLA = ATENDIME.CD_CON_PLA 
           AND ATENDIME . CD_MULTI_EMPRESA = 7
           AND UNID_INT.TP_UNID_INT = 'I'
           AND NVL(UNID_INT.SN_HOSPITAL_DIA, 'N') = 'N'
           AND Atendime.CD_MULTI_EMPRESA = '7'
           AND ATENDIME.CD_ATENDIMENTO_PAI IS NULL
         Group By UNID_INT . CD_UNID_INT,
                  UNID_INT . DS_UNID_INT,
                  CONVENIO . TP_CONVENIO,
                  CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
                ATENDIME . CD_CON_PLA,
                   CON_PLA  . DS_CON_PLA
                 
        UNION
        Select UNID_INT . CD_UNID_INT CD_UNID_INT,
               UNID_INT . DS_UNID_INT DS_UNIDADE,
               CONVENIO . TP_CONVENIO TP_CONVENIO,
               CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
                ATENDIME . CD_CON_PLA,
                   CON_PLA  . DS_CON_PLA,
               
               0 PAC_INT_00H,
               0 ENT_INTERNADOS,
               0 ENT_TRANSF,
               Count(*) SAI_ALTAS,
               0 SAI_TRANSFPARA,
               0 SAI_OBITOS,
               0 SAI_OBITOS48,
               0 SAI_OBITOS24,
               0 HOSP_DIA,
               0 OBITO_DIA
          From DBAMV . ATENDIME,
               DBAMV . UNID_INT,
               DBAMV . LEITO,
               DBAMV . CONVENIO,
                DBAMV .CON_PLA,
               (SELECT ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM DATA
                  FROM DBAMV . CID
                 WHERE ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM <= (to_Date('&data_fim','dd/mm/rrrr'))) CONTADOR
         WHERE LEITO . CD_LEITO = ATENDIME . CD_LEITO
           And UNID_INT . CD_UNID_INT = LEITO .CD_UNID_INT
           And Trunc(ATENDIME . DT_ALTA) = CONTADOR . DATA
           And ATENDIME . TP_ATENDIMENTO IN ('I', 'U')
           And ATENDIME . CD_CONVENIO = CONVENIO .CD_CONVENIO
           AND CON_PLA.CD_CONVENIO = ATENDIME.CD_CONVENIO 
           AND CON_PLA.CD_CON_PLA = ATENDIME.CD_CON_PLA 
           AND ATENDIME . CD_MULTI_EMPRESA = 7
           AND ATENDIME .CD_LEITO IS NOT NULL
           AND (EXISTS (SELECT CD_MOT_ALT
                          FROM DBAMV . MOT_ALT
                         WHERE CD_MOT_ALT = ATENDIME . CD_MOT_ALT
                           AND MOT_ALT . TP_MOT_ALTA <> 'O') OR EXISTS
                (SELECT CD_TIP_RES
                   FROM DBAMV . TIP_RES
                  WHERE CD_TIP_RES = ATENDIME . CD_TIP_RES
                    AND TIP_RES . SN_OBITO <> 'S'))
           AND UNID_INT.TP_UNID_INT = 'I'
           AND NVL(UNID_INT.SN_HOSPITAL_DIA, 'N') = 'N'
           AND Atendime.CD_MULTI_EMPRESA = '7'
           AND ATENDIME.CD_ATENDIMENTO_PAI IS NULL
         Group By UNID_INT . CD_UNID_INT,
                  UNID_INT . DS_UNID_INT,
                  CONVENIO . TP_CONVENIO,
                  CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
                 ATENDIME . CD_CON_PLA,
                   CON_PLA  . DS_CON_PLA
                
        UNION
        Select UNID_INT . CD_UNID_INT CD_UNID_INT,
               UNID_INT . DS_UNID_INT DS_UNIDADE,
               CONVENIO . TP_CONVENIO TP_CONVENIO,
               CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
                 ATENDIME . CD_CON_PLA,
                   CON_PLA  . DS_CON_PLA,
              
               0 PAC_INT_00H,
               0 ENT_INTERNADOS,
               0 ENT_TRANSF,
               0 SAI_ALTAS,
               Count(*) SAI_TRANSFPARA,
               0 SAI_OBITOS,
               0 SAI_OBITOS48,
               0 SAI_OBITOS24,
               0 HOSP_DIA,
               0 OBITO_DIA
          From DBAMV . MOV_INT,
               dbamv . unid_int,
               dbamv . unid_int unid_int1,
               dbamv . leito,
               dbamv . leito leito1,
               dbamv . atendime,
               dbamv . convenio,
                DBAMV .CON_PLA,
               (SELECT ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM DATA
                  FROM DBAMV . CID
                 WHERE ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM <= (to_Date('&data_fim','dd/mm/rrrr'))) CONTADOR
         Where TRUNC(MOV_INT . DT_MOV_INT) = CONTADOR . DATA
           AND MOV_INT . TP_MOV = 'O'
           AND MOV_INT . CD_LEITO_ANTERIOR = LEITO . CD_LEITO
           AND MOV_INT . CD_LEITO = LEITO1 . CD_LEITO
           AND LEITO1 . CD_UNID_INT = UNID_INT1 . CD_UNID_INT
           AND UNID_INT . CD_UNID_INT <> UNID_INT1 . CD_UNID_INT
           AND LEITO . CD_UNID_INT = UNID_INT . CD_UNID_INT
           AND ATENDIME . CD_ATENDIMENTO = MOV_INT .CD_ATENDIMENTO
           AND (ATENDIME . TP_ATENDIMENTO IN ('I', 'H', 'U'))
           and not exists
         (select 'X'
                  from dbamv . mov_int mi
                 where mi . cd_atendimento = mov_int .
                 cd_atendimento
                   AND TRUNC(mi . dt_mov_int) +
                       (mi . hr_mov_int - TRUNC(mi . hr_mov_int)) <
                       TRUNC(mov_int . dt_mov_int) +
                       (mov_int . hr_mov_int - TRUNC(mov_int . hr_mov_int))
                   and mi . cd_leito = mov_int . cd_leito
                   and mi . tp_mov <> 'R'
                   and mi . cd_tip_acom <> mov_int .
                 cd_tip_acom
                   and nvl(mi . cd_leito_anterior, mi . cd_leito) =
                       nvl(mov_int . cd_leito_anterior, mov_int . cd_leito))
           AND ATENDIME . CD_CONVENIO = CONVENIO .CD_CONVENIO
            AND CON_PLA.CD_CONVENIO = ATENDIME.CD_CONVENIO 
           AND CON_PLA.CD_CON_PLA = ATENDIME.CD_CON_PLA 
           AND ATENDIME . CD_MULTI_EMPRESA = 7
           AND UNID_INT.TP_UNID_INT = 'I'
           AND NVL(UNID_INT.SN_HOSPITAL_DIA, 'N') = 'N'
           AND Atendime.CD_MULTI_EMPRESA = '7'
           AND ATENDIME.CD_ATENDIMENTO_PAI IS NULL
         Group By UNID_INT . CD_UNID_INT,
                  UNID_INT . DS_UNID_INT,
                  CONVENIO . TP_CONVENIO,
                  CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
                ATENDIME . CD_CON_PLA,
                   CON_PLA  . DS_CON_PLA
                
        UNION
        Select UNID_INT . CD_UNID_INT CD_UNID_INT,
               UNID_INT . DS_UNID_INT DS_UNIDADE,
               CONVENIO . TP_CONVENIO TP_CONVENIO,
               CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
                ATENDIME . CD_CON_PLA,
                   CON_PLA  . DS_CON_PLA,
              
               0 PAC_INT_00H,
               0 ENT_INTERNADOS,
               0 ENT_TRANSF,
               0 SAI_ALTAS,
               0 SAI_TRANSFPARA,
               Count(*) SAI_OBITOS,
               0 SAI_OBITOS48,
               0 SAI_OBITOS24,
               0 HOSP_DIA,
               0 OBITO_DIA
          From DBAMV . ATENDIME,
               DBAMV . UNID_INT,
               DBAMV . LEITO,
               DBAMV . CONVENIO,
                DBAMV .CON_PLA,
               (SELECT ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM DATA
                  FROM DBAMV . CID
                 WHERE ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM <= (to_Date('&data_fim','dd/mm/rrrr'))) CONTADOR
         Where LEITO . CD_LEITO = ATENDIME . CD_LEITO
           AND LEITO . CD_UNID_INT = UNID_INT . CD_UNID_INT
           AND TRUNC(ATENDIME . DT_ALTA) = CONTADOR . DATA
           AND ATENDIME . TP_ATENDIMENTO IN ('I', 'U')
           AND ATENDIME . CD_CONVENIO = CONVENIO .CD_CONVENIO
             AND CON_PLA.CD_CONVENIO = ATENDIME.CD_CONVENIO 
           AND CON_PLA.CD_CON_PLA = ATENDIME.CD_CON_PLA 
           AND ATENDIME . CD_MULTI_EMPRESA = 7
           AND ATENDIME . CD_LEITO IS NOT NULL
           AND (EXISTS (SELECT CD_MOT_ALT
                          FROM DBAMV . MOT_ALT
                         WHERE CD_MOT_ALT = ATENDIME . CD_MOT_ALT
                           AND MOT_ALT . TP_MOT_ALTA = 'O') OR EXISTS
                (SELECT CD_TIP_RES
                   FROM DBAMV . TIP_RES
                  WHERE CD_TIP_RES = ATENDIME . CD_TIP_RES
                    AND TIP_RES . SN_OBITO = 'S'))
           AND UNID_INT.TP_UNID_INT = 'I'
           AND NVL(UNID_INT.SN_HOSPITAL_DIA, 'N') = 'N'
           AND Atendime.CD_MULTI_EMPRESA = '7'
           AND ATENDIME.CD_ATENDIMENTO_PAI IS NULL
         Group By UNID_INT . CD_UNID_INT,
                  UNID_INT . DS_UNID_INT,
                  CONVENIO . TP_CONVENIO,
                  CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
               ATENDIME . CD_CON_PLA,
                   CON_PLA  . DS_CON_PLA
                 
        Union
        Select UNID_INT . CD_UNID_INT CD_UNID_INT,
               UNID_INT . DS_UNID_INT DS_UNIDADE,
               CONVENIO . TP_CONVENIO TP_CONVENIO,
               CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
               ATENDIME . CD_CON_PLA,
               CON_PLA  . DS_CON_PLA,
            
               0 PAC_INT_00H,
               0 ENT_INTERNADOS,
               0 ENT_TRANSF,
               0 SAI_ALTAS,
               0 SAI_TRANSFPARA,
               0 SAI_OBITOS,
               Count(*) SAI_OBITOS48,
               0 SAI_OBITOS24,
               0 HOSP_DIA,
               0 OBITO_DIA
          From DBAMV . ATENDIME,
               DBAMV . UNID_INT,
               DBAMV . LEITO,
               DBAMV . CONVENIO,
                DBAMV .CON_PLA,
               (SELECT ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM DATA
                  FROM DBAMV . CID
                 Where ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM <= (to_Date('&data_fim','dd/mm/rrrr'))) CONTADOR
         Where LEITO . CD_LEITO = ATENDIME . CD_LEITO
           AND LEITO . CD_UNID_INT = UNID_INT .CD_UNID_INT
           AND TRUNC(ATENDIME . DT_ALTA) = CONTADOR . DATA
           AND ATENDIME . TP_ATENDIMENTO IN ('I', 'U')
           AND ATENDIME . CD_CONVENIO = CONVENIO .CD_CONVENIO
           AND CON_PLA.CD_CONVENIO = ATENDIME.CD_CONVENIO 
           AND CON_PLA.CD_CON_PLA = ATENDIME.CD_CON_PLA 
           AND ATENDIME . CD_MULTI_EMPRESA = 7
           AND ATENDIME .CD_LEITO IS NOT NULL
           AND (EXISTS (SELECT CD_MOT_ALT
                          FROM DBAMV . MOT_ALT
                         WHERE CD_MOT_ALT = ATENDIME . CD_MOT_ALT
                           AND MOT_ALT . TP_MOT_ALTA = 'O') OR EXISTS
                (SELECT CD_TIP_RES
                   FROM DBAMV . TIP_RES
                  WHERE CD_TIP_RES = ATENDIME . CD_TIP_RES
                    AND TIP_RES . SN_OBITO = 'S'))
           AND UNID_INT.TP_UNID_INT = 'I'
           AND NVL(UNID_INT.SN_HOSPITAL_DIA, 'N') = 'N'
           AND Atendime.CD_MULTI_EMPRESA = '7'
           AND ATENDIME.CD_ATENDIMENTO_PAI IS NULL
         Group By UNID_INT . CD_UNID_INT,
                  UNID_INT . DS_UNID_INT,
                  CONVENIO . TP_CONVENIO,
                  CONVENIO . CD_CONVENIO,
                  CONVENIO . NM_CONVENIO,
                  ATENDIME . CD_CON_PLA,
                  CON_PLA  . DS_CON_PLA
               
        Union
        Select UNID_INT . CD_UNID_INT CD_UNID_INT,
               UNID_INT . DS_UNID_INT DS_UNIDADE,
               CONVENIO . TP_CONVENIO TP_CONVENIO,
               CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
               ATENDIME . CD_CON_PLA,
               CON_PLA  . DS_CON_PLA,
            
               0 PAC_INT_00H,
               0 ENT_INTERNADOS,
               0 ENT_TRANSF,
               0 SAI_ALTAS,
               0 SAI_TRANSFPARA,
               0 SAI_OBITOS,
               0 SAI_OBITOS48,
               Count(*) SAI_OBITOS24,
               0 HOSP_DIA,
               0 OBITO_DIA
          From DBAMV . ATENDIME,
               DBAMV . UNID_INT,
               DBAMV . LEITO,
               DBAMV . CONVENIO,
                DBAMV .CON_PLA,
               (SELECT ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM DATA
                  FROM DBAMV . CID
                 WHERE ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM <= (to_Date('&data_fim','dd/mm/rrrr'))) CONTADOR
         Where LEITO . CD_LEITO = ATENDIME . CD_LEITO
           AND LEITO . CD_UNID_INT = UNID_INT .CD_UNID_INT
           AND TRUNC(ATENDIME . DT_ALTA) = CONTADOR . DATA
           AND ATENDIME . TP_ATENDIMENTO IN ('I', 'U')
           AND ATENDIME . CD_CONVENIO = CONVENIO .CD_CONVENIO
            AND CON_PLA.CD_CONVENIO = ATENDIME.CD_CONVENIO 
           AND CON_PLA.CD_CON_PLA = ATENDIME.CD_CON_PLA 
           AND ATENDIME . CD_MULTI_EMPRESA = 7
           AND ATENDIME . CD_LEITO IS NOT NULL
           AND (EXISTS (SELECT CD_MOT_ALT
                          FROM DBAMV . MOT_ALT
                         WHERE CD_MOT_ALT = ATENDIME . CD_MOT_ALT
                           AND MOT_ALT . TP_MOT_ALTA = 'O') OR EXISTS
                (SELECT CD_TIP_RES
                   FROM DBAMV . TIP_RES
                  WHERE CD_TIP_RES = ATENDIME . CD_TIP_RES
                    AND TIP_RES . SN_OBITO = 'S'))
           AND UNID_INT.TP_UNID_INT = 'I'
           AND NVL(UNID_INT.SN_HOSPITAL_DIA, 'N') = 'N'
           AND Atendime.CD_MULTI_EMPRESA = '7'
           AND ATENDIME.CD_ATENDIMENTO_PAI IS NULL
         Group By UNID_INT . CD_UNID_INT,
                  UNID_INT . DS_UNID_INT,
                  CONVENIO . TP_CONVENIO,
                  CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
               ATENDIME . CD_CON_PLA,
               CON_PLA  . DS_CON_PLA
          
        Union
        Select UNID_INT . CD_UNID_INT CD_UNID_INT,
               UNID_INT . DS_UNID_INT DS_UNIDADE,
               CONVENIO . TP_CONVENIO TP_CONVENIO,
               CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
               ATENDIME . CD_CON_PLA,
               CON_PLA  . DS_CON_PLA,
           
               0 PAC_INT_00H,
               0 ENT_INTERNADOS,
               0 ENT_TRANSF,
               0 SAI_ALTAS,
               0 SAI_TRANSFPARA,
               0 SAI_OBITOS,
               0 SAI_OBITOS48,
               0 SAI_OBITOS24,
               Count(*) HOSP_DIA,
               0 OBITO_DIA
          From DBAMV . ATENDIME,
               DBAMV . LEITO,
               DBAMV . UNID_INT,
               DBAMV . CONVENIO,
               DBAMV . MOV_INT,
                DBAMV .CON_PLA,
               (SELECT ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM DATA
                  FROM DBAMV . CID
                 WHERE ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + Rownum <= (to_Date('&data_fim','dd/mm/rrrr'))) CONTADOR
         Where MOV_INT . TP_MOV = 'I'
           AND MOV_INT . CD_LEITO = LEITO . CD_LEITO
           AND LEITO . CD_UNID_INT = UNID_INT . CD_UNID_INT
           AND ATENDIME . CD_ATENDIMENTO = MOV_INT .CD_ATENDIMENTO
           AND (ATENDIME . TP_ATENDIMENTO IN ('I', 'H', 'U'))
           and not exists
         (select 'X'
                  from dbamv . mov_int mi
                 where mi . cd_atendimento = mov_int .
                 cd_atendimento
                   AND TRUNC(mi . dt_mov_int) +(mi . hr_mov_int - TRUNC(mi . hr_mov_int)) < TRUNC(mov_int . dt_mov_int) +(mov_int . hr_mov_int - TRUNC(mov_int . hr_mov_int))
                   and mi . cd_leito = mov_int . cd_leito
                   and mi . cd_tip_acom <> mov_int . cd_tip_acom
                   and mi . tp_mov <> 'R'
                   and nvl(mi . cd_leito_anterior, mi . cd_leito) = nvl(mov_int . cd_leito_anterior, mov_int . cd_leito))
           AND ATENDIME .DT_ALTA IS NOT NULL
           AND Trunc(ATENDIME . DT_ATENDIMENTO) = TRUNC(ATENDIME . DT_ALTA)
           AND Trunc(MOV_INT . DT_MOV_INT) = CONTADOR . DATA
           AND ATENDIME . CD_CONVENIO = CONVENIO .CD_CONVENIO
           AND CON_PLA.CD_CONVENIO = ATENDIME.CD_CONVENIO 
           AND CON_PLA.CD_CON_PLA = ATENDIME.CD_CON_PLA 
           AND ATENDIME . CD_MULTI_EMPRESA = 7
           AND UNID_INT.TP_UNID_INT = 'I'
           AND NVL(UNID_INT.SN_HOSPITAL_DIA, 'N') = 'N'
           AND Atendime.CD_MULTI_EMPRESA = '7'
           AND ATENDIME.CD_ATENDIMENTO_PAI IS NULL
         Group By UNID_INT . CD_UNID_INT,
                  UNID_INT . DS_UNID_INT,
                  CONVENIO . TP_CONVENIO,
                  CONVENIO . CD_CONVENIO,
                  CONVENIO . NM_CONVENIO,
                  ATENDIME . CD_CON_PLA,
               CON_PLA  . DS_CON_PLA
            
        Union
        Select UNID_INT . CD_UNID_INT CD_UNID_INT,
               UNID_INT . DS_UNID_INT DS_UNIDADE,
               CONVENIO . TP_CONVENIO TP_CONVENIO,
               CONVENIO . CD_CONVENIO,
               CONVENIO . NM_CONVENIO,
               ATENDIME . CD_CON_PLA,
               CON_PLA  . DS_CON_PLA,
             
               0 PAC_INT_00H,
               0 ENT_INTERNADOS,
               0 ENT_TRANSF,
               0 SAI_ALTAS,
               0 SAI_TRANSFPARA,
               0 SAI_OBITOS,
               0 SAI_OBITOS48,
               0 SAI_OBITOS24,
               0 HOSP_DIA,
               Count(*) OBITO_DIA
          From DBAMV . ATENDIME,
               DBAMV . LEITO,
               DBAMV . UNID_INT,
               DBAMV . CONVENIO,
                DBAMV .CON_PLA,
               (SELECT ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM DATA
                  FROM DBAMV . CID
                 WHERE ((to_Date('&data_ini','dd/mm/rrrr')) - 1) + ROWNUM <= (to_Date('&data_fim','dd/mm/rrrr'))) CONTADOR
         Where ATENDIME . TP_ATENDIMENTO IN ('I', 'U')
           And ATENDIME . CD_LEITO = LEITO . CD_LEITO
           And LEITO . CD_UNID_INT = UNID_INT .
         CD_UNID_INT
           And Trunc(ATENDIME . DT_ATENDIMENTO) = TRUNC(ATENDIME . DT_ALTA)
           And Trunc(ATENDIME . DT_ATENDIMENTO) = TRUNC(CONTADOR . DATA)
           And ATENDIME . CD_CONVENIO = CONVENIO . CD_CONVENIO
            AND CON_PLA.CD_CONVENIO = ATENDIME.CD_CONVENIO 
           AND CON_PLA.CD_CON_PLA = ATENDIME.CD_CON_PLA
           AND ATENDIME . CD_MULTI_EMPRESA = 7
           AND ATENDIME .CD_LEITO IS NOT NULL
           AND (EXISTS (SELECT CD_MOT_ALT
                          FROM DBAMV . MOT_ALT
                         WHERE CD_MOT_ALT = ATENDIME . CD_MOT_ALT
                           AND MOT_ALT . TP_MOT_ALTA = 'O') OR EXISTS
                (SELECT CD_TIP_RES FROM DBAMV . TIP_RES
                  WHERE CD_TIP_RES = ATENDIME . CD_TIP_RES
                    AND TIP_RES . SN_OBITO = 'S'))
           AND UNID_INT.TP_UNID_INT = 'I'
           AND NVL(UNID_INT.SN_HOSPITAL_DIA, 'N') = 'N'
           AND Atendime.CD_MULTI_EMPRESA = '7'
           AND ATENDIME.CD_ATENDIMENTO_PAI IS NULL
         Group By UNID_INT . CD_UNID_INT,
                  UNID_INT . DS_UNID_INT,
                  CONVENIO . TP_CONVENIO,
                  CONVENIO . CD_CONVENIO,
                  CONVENIO . NM_CONVENIO,
                  ATENDIME . CD_CON_PLA,
                  CON_PLA  . DS_CON_PLA
            
)
ORDER BY UNID_INTER,CONVENIO, PLANO


