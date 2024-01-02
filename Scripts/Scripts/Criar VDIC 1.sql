-- Start of DDL script for VDIC_INTER_CIRURGIA
-- Generated 4-jan-07  11:57:55 am
-- from PRODUCAO-DBAMV:1

-- View VDIC_INTER_CIRURGIA

CREATE OR REPLACE VIEW VDIC_INTER_CIRURGIA (
   ENFERMARIA,
   LEITO,
   ATENDIMENTO,
   PACIENTE,
   DT_ATENDIMENTO,
   HR_ATENDIMENTO,
   CID,
   DIAGNOSTICO,
   CD_PRO_FAT,
   PRO_FAT,
   DT_CIRURGIA,
   HR_CIRURGIA,
   CIRURGIA)

AS

SELECT   LEITO.ds_enfermaria                                                    ENFERMARIA
       , LEITO.ds_leito                                                         LEITO
       , ATENDIME.cd_atendimento                                                ATENDIMENTO
       , PACIENTE.nm_paciente                                                   PACIENTE
       , To_Char(ATENDIME.dt_atendimento, 'dd/mm/yyyy')                         DT_ATENDIMENTO
       , To_Char(ATENDIME.hr_atendimento, 'HH24:mi')                            HR_ATENDIMENTO
       , ATENDIME.cd_cid                                                        CID
       , CID.ds_cid                                                             DIAGNOSTICO
       , ATENDIME.cd_pro_int                                                    CD_PRO_FAT
       , PRO_FAT.ds_pro_fat                                                     PRO_FAT    
       , To_Char(AVISO_CIRURGIA.dt_realizacao, 'dd/mm/yyyy')                    DT_CIRURGIA  
       , To_Char(AVISO_CIRURGIA.dt_realizacao, 'HH24:mi')                       HR_CIRURGIA
       , CIRURGIA.ds_cirurgia                                                   CIRURGIA

FROM   DBAMV.ATENDIME, DBAMV.PACIENTE, DBAMV.CID, DBAMV.LEITO, DBAMV.PRO_FAT, DBAMV.AVISO_CIRURGIA, DBAMV.CIRURGIA_AVISO, DBAMV.CIRURGIA  

WHERE  PACIENTE.cd_paciente             =     ATENDIME.cd_paciente
AND    ATENDIME.cd_leito                =     LEITO.cd_leito
AND    ATENDIME.cd_cid                  =     CID.cd_cid
AND    ATENDIME.cd_pro_int              =     PRO_FAT.cd_pro_fat
AND    ATENDIME.cd_atendimento_pai      IS NULL
AND    ATENDIME.tp_atendimento          =     'I' 
AND    ATENDIME.cd_prestador            =     1824
AND    ATENDIME.cd_atendimento          =     AVISO_CIRURGIA.cd_atendimento
AND    AVISO_CIRURGIA.cd_aviso_cirurgia =     CIRURGIA_AVISO.cd_aviso_cirurgia 
AND    CIRURGIA_AVISO.cd_cirurgia       =     CIRURGIA.cd_cirurgia
AND    AVISO_CIRURGIA.tp_situacao       =     'R'
--AND    Trunc(ATENDIME.dt_atendimento) Between To_Date('01/12/2011','dd/mm/yyyy') And To_Date('31/12/2011','dd/mm/yyyy')

/

-- Grants for VDIC_INTER_CIRURGIA

GRANT DELETE,INSERT,SELECT,UPDATE ON VDIC_INTER_CIRURGIA TO dbaps
/
GRANT DELETE,INSERT,SELECT,UPDATE ON VDIC_INTER_CIRURGIA TO dbasgu
/
GRANT DELETE,INSERT,SELECT,UPDATE ON VDIC_INTER_CIRURGIA TO mvintegra
/
GRANT DELETE,INSERT,SELECT,UPDATE ON VDIC_INTER_CIRURGIA TO mv2000
/
GRANT SELECT ON VDIC_INTER_CIRURGIA TO public
/

-- End of DDL script for VDIC_INTER_CIRURGIA
