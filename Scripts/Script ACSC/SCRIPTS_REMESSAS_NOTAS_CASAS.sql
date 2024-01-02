SELECT * FROM (

 SELECT DISTINCT 
    'INTERNACAO' TP_CONTA, 
    RF.CD_MULTI_EMPRESA AS CD_MULTI_EMPRESA, 
    ME.DS_MULTI_EMPRESA AS DS_MULTI_EMPRESA,
    RF.CD_ATENDIMENTO AS CD_ATENDIMENTO,
    A.DT_ATENDIMENTO  AS DT_ATENDIMENTO,
    RF.CD_REG_FAT   AS CD_CONTA, 
    RF.CD_CONVENIO    AS CD_CONVENIO, 
    C.NM_CONVENIO   AS NM_CONVENIO,
    RF.SN_FECHADA   AS SN_FECHADA, 
    RF.VL_TOTAL_CONTA AS VL_TOTAL_CONTA, 
    INF1.CD_REMESSA   AS CD_REMESSA_ANT,
    INF1.CD_NOTA_FISCAL AS CD_NOTA_FISCAL_ANT,
    NF1.DT_EMISSAO    AS DT_EMISSAO_NF_ANT,
    NF1.VL_TOTAL_NOTA   AS VL_TOTAL_NF_ANT,
    NF1.NM_CLIENTE    AS NM_CLIENTE_NF_ANT
   FROM DBAMV.REG_FAT RF
  INNER JOIN DBAMV.ATENDIME A         ON A.CD_ATENDIMENTO   = RF.CD_ATENDIMENTO 
  INNER JOIN DBAMV.MULTI_EMPRESAS ME    ON ME.CD_MULTI_EMPRESA  = RF.CD_MULTI_EMPRESA 
  INNER JOIN DBAMV.CONVENIO C         ON C.CD_CONVENIO      = RF.CD_CONVENIO 
  INNER JOIN DBAMV.ITFAT_NOTA_FISCAL INF1   ON INF1.CD_REG_FAT    = RF.CD_REG_FAT
  INNER JOIN DBAMV.NOTA_FISCAL NF1      ON NF1.CD_NOTA_FISCAL   = INF1.CD_NOTA_FISCAL 
  WHERE rf.CD_REMESSA IS NULL 
   AND EXISTS (SELECT * 
          FROM DBAMV.NOTA_FISCAL NF2    
           WHERE NF2.CD_REG_FAT = RF.CD_REG_FAT 
             AND NF2.CD_STATUS = 'E') 
    
UNION 

 SELECT DISTINCT 
    --'TIPO 2 - ITEM NF' INCIDENTE,
    'INTERNACAO' TP_CONTA, 
    RF.CD_MULTI_EMPRESA AS CD_MULTI_EMPRESA, 
    ME.DS_MULTI_EMPRESA AS DS_MULTI_EMPRESA,
    RF.CD_ATENDIMENTO AS CD_ATENDIMENTO,
    A.DT_ATENDIMENTO  AS DT_ATENDIMENTO,
    RF.CD_REG_FAT   AS CD_CONTA, 
    RF.CD_CONVENIO    AS CD_CONVENIO, 
    C.NM_CONVENIO   AS NM_CONVENIO,
    RF.SN_FECHADA   AS SN_FECHADA, 
    RF.VL_TOTAL_CONTA AS VL_TOTAL_CONTA, 
    INF1.CD_REMESSA   AS CD_REMESSA_ANT,
    INF1.CD_NOTA_FISCAL AS CD_NOTA_FISCAL_ANT,
    NF1.DT_EMISSAO    AS DT_EMISSAO_NF_ANT ,
    NF1.VL_TOTAL_NOTA   AS VL_TOTAL_NF_ANT,
    NF1.NM_CLIENTE    AS NM_CLIENTE_NF_ANT
  FROM DBAMV.REG_FAT RF
  INNER JOIN DBAMV.ATENDIME A         ON A.CD_ATENDIMENTO   = RF.CD_ATENDIMENTO 
  INNER JOIN DBAMV.MULTI_EMPRESAS ME    ON ME.CD_MULTI_EMPRESA  = RF.CD_MULTI_EMPRESA 
  INNER JOIN DBAMV.CONVENIO C         ON C.CD_CONVENIO      = RF.CD_CONVENIO 
  INNER JOIN DBAMV.ITFAT_NOTA_FISCAL INF1   ON INF1.CD_REG_FAT    = RF.CD_REG_FAT
  INNER JOIN DBAMV.NOTA_FISCAL NF1      ON NF1.CD_NOTA_FISCAL   = INF1.CD_NOTA_FISCAL 
  WHERE rf.CD_REMESSA IS NULL 
  AND EXISTS (SELECT * 
          FROM DBAMV.NOTA_FISCAL NF2 
          INNER JOIN DBAMV.ITFAT_NOTA_FISCAL INF2 ON NF2.CD_NOTA_FISCAL = INF2.CD_NOTA_FISCAL 
          WHERE INF2.CD_REG_FAT = RF.CD_REG_FAT
            AND NF2.CD_STATUS = 'E') 
UNION 

SELECT DISTINCT 
    --'TIPO 1 - NF' INCIDENTE,
    'AMBULATORIAL'    AS TP_CONTA, 
    RF.CD_MULTI_EMPRESA AS CD_MULTI_EMPRESA, 
    ME.DS_MULTI_EMPRESA AS DS_MULTI_EMPRESA,
    IA.CD_ATENDIMENTO AS CD_ATENDIMENTO,
    A.DT_ATENDIMENTO  AS DT_ATENDIMENTO,
    RF.CD_REG_AMB     AS CD_CONTA, 
    RF.CD_CONVENIO    AS CD_CONVENIO, 
    C.NM_CONVENIO   AS NM_CONVENIO,
    RF.SN_FECHADA   AS SN_FECHADA, 
    RF.VL_TOTAL_CONTA AS VL_TOTAL_CONTA, 
    INF1.CD_REMESSA   AS CD_REMESSA_ANT,
    INF1.CD_NOTA_FISCAL AS CD_NOTA_FISCAL_ANT,
    NF1.DT_EMISSAO    AS DT_EMISSAO_NF_ANT ,
    NF1.VL_TOTAL_NOTA   AS VL_TOTAL_NF_ANT,
    NF1.NM_CLIENTE    AS NM_CLIENTE_NF_ANT
  FROM DBAMV.REG_AMB RF
  INNER JOIN DBAMV.ITREG_AMB      IA    ON IA.CD_REG_AMB      = RF.CD_REG_AMB 
  INNER JOIN DBAMV.ATENDIME       A     ON A.CD_ATENDIMENTO   = IA.CD_ATENDIMENTO 
  INNER JOIN DBAMV.MULTI_EMPRESAS     ME    ON ME.CD_MULTI_EMPRESA  = RF.CD_MULTI_EMPRESA 
  INNER JOIN DBAMV.CONVENIO       C     ON C.CD_CONVENIO      = RF.CD_CONVENIO 
  INNER JOIN DBAMV.ITFAT_NOTA_FISCAL  INF1  ON INF1.CD_REG_AMB    = RF.CD_REG_AMB
  INNER JOIN DBAMV.NOTA_FISCAL      NF1   ON NF1.CD_NOTA_FISCAL   = INF1.CD_NOTA_FISCAL 
  WHERE rf.CD_REMESSA IS NULL 
   AND EXISTS (SELECT * 
          FROM DBAMV.NOTA_FISCAL NF2    
           WHERE NF2.CD_REG_AMB = RF.CD_REG_AMB 
             AND NF2.CD_STATUS = 'E') 
    
UNION 

SELECT DISTINCT 
    --'TIPO 1 - NF' INCIDENTE,
    'AMBULATORIAL'    AS TP_CONTA, 
    RF.CD_MULTI_EMPRESA AS CD_MULTI_EMPRESA, 
    ME.DS_MULTI_EMPRESA AS DS_MULTI_EMPRESA,
    IA.CD_ATENDIMENTO AS CD_ATENDIMENTO,
    A.DT_ATENDIMENTO  AS DT_ATENDIMENTO,
    RF.CD_REG_AMB     AS CD_CONTA, 
    RF.CD_CONVENIO    AS CD_CONVENIO, 
    C.NM_CONVENIO   AS NM_CONVENIO,
    RF.SN_FECHADA   AS SN_FECHADA, 
    RF.VL_TOTAL_CONTA AS VL_TOTAL_CONTA, 
    INF1.CD_REMESSA   AS CD_REMESSA_ANT,
    INF1.CD_NOTA_FISCAL AS CD_NOTA_FISCAL_ANT,
    NF1.DT_EMISSAO    AS DT_EMISSAO_NF_ANT ,
    NF1.VL_TOTAL_NOTA   AS VL_TOTAL_NF_ANT,
    NF1.NM_CLIENTE    AS NM_CLIENTE_NF_ANT
  FROM DBAMV.REG_AMB RF
  INNER JOIN DBAMV.ITREG_AMB      IA    ON IA.CD_REG_AMB      = RF.CD_REG_AMB 
  INNER JOIN DBAMV.ATENDIME       A     ON A.CD_ATENDIMENTO   = IA.CD_ATENDIMENTO 
  INNER JOIN DBAMV.MULTI_EMPRESAS     ME    ON ME.CD_MULTI_EMPRESA  = RF.CD_MULTI_EMPRESA 
  INNER JOIN DBAMV.CONVENIO       C     ON C.CD_CONVENIO      = RF.CD_CONVENIO 
  INNER JOIN DBAMV.ITFAT_NOTA_FISCAL  INF1  ON INF1.CD_REG_AMB    = RF.CD_REG_AMB
  INNER JOIN DBAMV.NOTA_FISCAL      NF1   ON NF1.CD_NOTA_FISCAL   = INF1.CD_NOTA_FISCAL 
  WHERE rf.CD_REMESSA IS NULL 
  AND EXISTS (SELECT * 
          FROM DBAMV.NOTA_FISCAL NF2 
          INNER JOIN DBAMV.ITFAT_NOTA_FISCAL INF2 ON NF2.CD_NOTA_FISCAL = INF2.CD_NOTA_FISCAL 
          WHERE INF2.CD_REG_AMB = RF.CD_REG_AMB
            AND NF2.CD_STATUS = 'E') 

)       
--WHERE CD_ATENDIMENTO = 5027455

ORDER BY CD_MULTI_EMPRESA, TP_CONTA DESC, CD_ATENDIMENTO
;
--select * from itfat_nota_fiscal nf where 

/*select * from itfat_nota_fiscal nf where nf.cd_reg_amb = 4301421;
select * from itfat_nota_fiscal nf where nf.cd_Reg_fat = 129035;
select * from reg_amb where cd_Reg_amb = 4301421;
select * from reg_fat where cd_Reg_fat = 129035;

update reg_amb set cd_remessa = 371890 where cd_Reg_amb = 4301421
update reg_fat set cd_remessa = 89212 where cd_Reg_fat = 129035*/