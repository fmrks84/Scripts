SELECT 
C.CD_TAB_FAT,
C.DS_TAB_FAT,
A.CD_PRO_FAT,
B.DS_PRO_FAT,
TRUNC(A.DT_VIGENCIA)DT_VIGENCIA,
A.VL_HONORARIO,
A.VL_OPERACIONAL,
A.VL_TOTAL
--E.VL_PORTE
FROM
VAL_PRO A 
INNER JOIN PRO_FAT B ON B.CD_PRO_FAT = A.CD_PRO_FAT
INNER JOIN TAB_FAT C ON C.CD_TAB_FAT = A.CD_TAB_FAT
INNER JOIN GRU_PRO D ON D.CD_GRU_PRO = B.CD_GRU_PRO
LEFT JOIN VAL_PORTE E ON E.CD_POR_ANE = B.CD_POR_ANE AND E.CD_TAB_FAT = A.CD_TAB_FAT
WHERE A.DT_VIGENCIA = (SELECT MAX(X.DT_VIGENCIA) FROM VAL_PRO X WHERE X.CD_PRO_FAT = A.CD_PRO_FAT
                                                                AND X.CD_TAB_FAT = A.CD_TAB_FAT)
--AND A.CD_PRO_FAT IN ('00258304')    
--and c.ds_tab_fat like 'HSC%'
AND A.cd_tab_fat in (822)                                                      
                                                          
                                                                

/*SELECT 
A.CD_PRO_FAT,
C.CD_TAB_FAT,
C.DS_TAB_FAT,
TRUNC(A.DT_VIGENCIA)DT_VIGENCIA,
A.VL_HONORARIO,
A.VL_OPERACIONAL,
A.VL_TOTAL,
a.sn_ativo

FROM
VAL_PRO A 
INNER JOIN PRO_FAT B ON B.CD_PRO_FAT = A.CD_PRO_FAT
INNER JOIN TAB_FAT C ON C.CD_TAB_FAT = A.CD_TAB_FAT
INNER JOIN GRU_PRO D ON D.CD_GRU_PRO = B.CD_GRU_PRO
LEFT JOIN VAL_PORTE E ON E.CD_POR_ANE = B.CD_POR_ANE AND E.CD_TAB_FAT = A.CD_TAB_FAT
WHERE A.DT_VIGENCIA = (SELECT MAX(X.DT_VIGENCIA) FROM VAL_PRO X WHERE X.CD_TAB_FAT = A.CD_TAB_FAT AND X.CD_PRO_FAT = A.CD_PRO_FAT)
AND C.DS_TAB_FAT LIKE '%HSC%'--A.CD_TAB_FAT IN (2)
and  A.CD_PRO_FAT IN ('00277451'
,'00299109'
,'00314824'
,'02040923'
,'00325336'
,'00332721')
AND B.SN_ATIVO = 'S'
;
select * from pro_Fat where cd_pro_fat = '00258304'
;
select * from itregra x2 where x2.cd_regra IN (41) 
and x2.cd_gru_pro = 89
;
select * from gru_pro where cd_gru_pro = 96
select  * from produto where cd_pro_fat = 00253581


select cd_guia, tp_guia, cd_paciente, cd_aviso_cirurgia, cd_atendimento from guia where cd_aviso_cirurgia = 288577
select * from aviso_cirurgia where \*cd_aviso_cirurgia = 288539*\ cd_atendimento = 3838478

--- PADRAO REFERENCIA COBRANÇA OPME
SELECT CONV.CD_CONVENIO||' - '||CONV.NM_CONVENIO NM_CONVENIO,
       ECONV.TP_OPME_VL_REFERENCIA
       FROM 
Empresa_Convenio ECONV
INNER JOIN CONVENIO CONV ON CONV.CD_CONVENIO = ECONV.CD_CONVENIO
WHERE ECONV.CD_MULTI_EMPRESA = 7
AND CONV.TP_CONVENIO = 'C'


SELECT * FROM VAL_PRO WHERE CD_TAB_fAT = 822*/
