
-- Start of DDL script for VDIC_ATEN_EXAMES
-- Generated 4-jan-07  11:57:55 am
-- from PRODUCAO-DBAMV:1

-- View VDIC_ATEN_EXAMES

CREATE OR REPLACE VIEW VDIC_ATEN_EXAMES (
   ATENDIMENTO,
   DT_ATENDIMENTO,
   PEDIDO,
   DT_PEDIDO,
   CD_PACIENTE,
   NOME,
   DT_NASCIMENTO,
   CD_SETOR,
   SETOR_EXECUTANTE,
   TP_ATEN,
   CD_CONVENIO,
   NM_CONVENIO,
   USUARIO,
   EMPRESA)
AS
SELECT 
       ATENDIME.CD_ATENDIMENTO                                                  ATENDIMENTO
     , ATENDIME.DT_ATENDIMENTO                                                  DT_ATENDIMENTO     
     , PED_RX.CD_PED_RX                                                         PEDIDO
     , PED_RX.DT_PEDIDO                                                         DT_PEDIDO
     , PACIENTE.CD_PACIENTE                                                     CD_PACIENTE
     , PACIENTE.NM_PACIENTE                                                     NOME 
     , PACIENTE.DT_NASCIMENTO                                                   DT_NASCIMENTO
     , SET_EXA.CD_SET_EXA                                                       CD_SETOR    
     , SET_EXA.NM_SET_EXA                                                       SETOR_EXECUTANTE
     , ATENDIME.TP_ATENDIMENTO                                                  TP_ATEN
     , PED_RX.CD_CONVENIO                                                       CD_CONVENIO
     , CONVENIO.NM_CONVENIO                                                     NM_CONVENIO
     , PED_RX.NM_USUARIO                                                        USUARIO
     , ATENDIME.CD_MULTI_EMPRESA                                                EMPRESA
      
     
FROM   DBAMV.PED_RX
     , DBAMV.ATENDIME
     , DBAMV.PACIENTE
     , DBAMV.SET_EXA
     , DBAMV.CONVENIO

     
WHERE  ATENDIME.CD_MULTI_EMPRESA    In (1,3)
AND    ATENDIME.CD_PACIENTE         =        PACIENTE.CD_PACIENTE
AND    ATENDIME.CD_ATENDIMENTO      =        PED_RX.CD_ATENDIMENTO
AND    ATENDIME.TP_ATENDIMENTO      =        'E'
AND    ATENDIME.CD_CONVENIO         =        CONVENIO.CD_CONVENIO
AND    SET_EXA.TP_SETOR             =        'R'
AND    PED_RX.CD_SET_EXA            =        SET_EXA.CD_SET_EXA
AND    TO_DATE(trunc(PED_RX.DT_PEDIDO),'dd/mm/yyyy') BETWEEN TO_DATE('01/03/2011','dd/mm/yyyy') AND TO_DATE('31/03/2011','dd/mm/yyyy')
ORDER BY  NOME, ATENDIMENTO DESC

/

-- Grants for VDIC_ATEN_EXAMES

GRANT SELECT ON VDIC_ATEN_EXAMES TO dbaps
/
GRANT SELECT ON VDIC_ATEN_EXAMES TO dbasgu
/
GRANT SELECT ON VDIC_ATEN_EXAMES TO mvintegra
/
GRANT SELECT ON VDIC_ATEN_EXAMES TO mv2000
/

-- End of DDL script for VDIC_ATEN_EXAMES
