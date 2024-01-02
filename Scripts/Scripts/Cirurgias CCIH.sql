/*CREATE OR REPLACE VIEW VDIC_HMSJ_CIR_PART
AS(

SELECT DISTINCT  
       AC.CD_AVISO_CIRURGIA NR_AVISO,
       AC.CD_ATENDIMENTO ATENDIMENTO,
       AC.DT_REALIZACAO DT_CIRURGIA,
       --AC.DT_INICIO_CIRURGIA,
       --AC.DT_FIM_CIRURGIA,
       P.NM_PACIENTE NM_PACIENTE,
       --CA.CD_CIRURGIA,
       C.DS_CIRURGIA CIRURGIA,
       --CA.CD_CONVENIO,
       --CON.NM_CONVENIO,
       --PA.CD_PRESTADOR,
       P.NM_PRESTADOR
      -- A.CD_PRESTADOR
       --USER AS USUARIO
  FROM DBAMV.AVISO_CIRURGIA AC,
       DBAMV.CIRURGIA_AVISO CA,
       DBAMV.CIRURGIA       C,
       DBAMV.ATENDIME       A,
       DBAMV.PACIENTE       P,
       DBAMV.CONVENIO       CON,
       --DBAMV.PRESTADOR_AVISO PA,
       DBAMV.PRESTADOR P
 WHERE CA.CD_AVISO_CIRURGIA = AC.CD_AVISO_CIRURGIA
   AND CA.CD_CIRURGIA = C.CD_CIRURGIA
   AND AC.CD_ATENDIMENTO = A.CD_ATENDIMENTO
   AND A.CD_PACIENTE = P.CD_PACIENTE
   AND A.CD_CONVENIO = CON.CD_CONVENIO
   AND CA.CD_CONVENIO = CON.CD_CONVENIO
   AND A.CD_PRESTADOR = P.CD_PRESTADOR
  -- AND PA.CD_AVISO_CIRURGIA = AC.CD_AVISO_CIRURGIA
  -- AND PA.CD_CIRURGIA = CA.CD_CIRURGIA
   --AND PA.CD_PRESTADOR = P.CD_PRESTADOR
   AND P.CD_PRESTADOR IN (7926,9257)
   AND CA.CD_CIRURGIA IN (896,899,5084,5047,5087)
   AND AC.CD_CEN_CIR = 02
   AND AC.TP_SITUACAO = 'R'
   AND TRUNC(AC.DT_REALIZACAO) BETWEEN '01/10/2015' AND '31/10/2015'
   order by 3 ASC , 4 ASC
   --AND CA.CD_CONVENIO IN(352,379)
   --AND PA.CD_ATI_MED = 01
   --AND PA.SN_PRINCIPAL = 'S')
   --ORDER BY TRUNC(AC.DT_REALIZACAO, AC.CD_AVISO_CIRURGIA)
-- Grants for VDIC_rel_presta_ame

GRANT DELETE,INSERT,SELECT,UPDATE ON dbamv.VDIC_HMSJ_CIR_PART TO dbaps
/
GRANT DELETE,INSERT,SELECT,UPDATE ON dbamv.VDIC_HMSJ_CIR_PART TO dbasgu
/
GRANT DELETE,INSERT,SELECT,UPDATE ON dbamv.VDIC_HMSJ_CIR_PART TO mvintegra
/
GRANT DELETE,INSERT,SELECT,UPDATE ON dbamv.VDIC_HMSJ_CIR_PART TO mv2000

*/
---------------------------------------------------------------------------
---------------------------NOVO 15/12/2015 --------------------------------
---------------------------------------------------------------------------
CREATE OR REPLACE VIEW VDIC_HMSJ_CIR_VANGUARDA
AS(SELECT DISTINCT  
       AC.CD_AVISO_CIRURGIA NR_AVISO,
       AC.CD_ATENDIMENTO ATENDIMENTO,
       AC.DT_REALIZACAO DT_CIRURGIA,
       P.NM_PACIENTE NM_PACIENTE,
       C.DS_CIRURGIA CIRURGIA,
       P.NM_PRESTADOR NM_PRESTADOR,
       AC.CD_MULTI_EMPRESA
       
FROM DBAMV.AVISO_CIRURGIA AC,
       DBAMV.CIRURGIA_AVISO CA,
       DBAMV.CIRURGIA       C,
       DBAMV.ATENDIME       A,
       DBAMV.PACIENTE       P,
       DBAMV.CONVENIO       CON,
       DBAMV.PRESTADOR P
WHERE CA.CD_AVISO_CIRURGIA = AC.CD_AVISO_CIRURGIA
   AND CA.CD_CIRURGIA = C.CD_CIRURGIA
   AND AC.CD_ATENDIMENTO = A.CD_ATENDIMENTO
   AND A.CD_PACIENTE = P.CD_PACIENTE
   AND A.CD_CONVENIO = CON.CD_CONVENIO
   AND CA.CD_CONVENIO = CON.CD_CONVENIO
   AND A.CD_PRESTADOR = P.CD_PRESTADOR
   AND P.CD_PRESTADOR IN (7926,9257,9812)
   AND CA.CD_CIRURGIA IN (896,899,5084,5047,5087)
   AND AC.CD_CEN_CIR = 04  -- 04 CC/CO PMP , 02 CO HMSJ
   --AND AC.CD_MULTI_EMPRESA = 1  -- 1 HMSJ , 2 PMP
   AND AC.TP_SITUACAO = 'R'
   AND TRUNC(AC.DT_REALIZACAO) BETWEEN '01/03/2016' AND '31/03/2016'
   order by 3 ASC , 4 ASC
   
GRANT DELETE,INSERT,SELECT,UPDATE ON dbamv.VDIC_HMSJ_CIR_VANGUARDA TO dbaps
/
GRANT DELETE,INSERT,SELECT,UPDATE ON dbamv.VDIC_HMSJ_CIR_VANGUARDA TO dbasgu
/
GRANT DELETE,INSERT,SELECT,UPDATE ON dbamv.VDIC_HMSJ_CIR_VANGUARDA TO mvintegra
/
GRANT DELETE,INSERT,SELECT,UPDATE ON dbamv.VDIC_HMSJ_CIR_VANGUARDA TO mv2000
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------