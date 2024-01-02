select 
distinct
tp_Atendimento,
cd_multi_empresa,
cd_atendimento,
conta,
cd_convenio,
nm_convenio,
cd_con_pla,
Cd_Regra,
cd_tab_fat,
cd_pro_fat,
SN_PERTENCE_PACOTE,
dt_lancamento,
vl_unitario,
qt_lancamento,
vl_total_Geral,
vl_comercial,
(vl_comercial - vl_total_geral)diferenca
from
(
select 
'internado'tp_Atendimento,
b.cd_multi_empresa,
b.cd_atendimento,
b.cd_reg_fat conta,
b.cd_convenio,
c1.nm_convenio,
b.cd_con_pla,
b.Cd_Regra,
e.cd_tab_fat,
a.cd_pro_fat,
A.SN_PERTENCE_PACOTE,
trunc(a.dt_lancamento)dt_lancamento,
a.vl_unitario,
a.qt_lancamento,
(a.vl_unitario * a.qt_lancamento)vl_total_Geral,
'6,20'vl_comercial
from 
itreg_Fat a
inner join reg_fat b on b.cd_reg_fat = a.cd_reg_fat 
inner join empresa_con_pla c on c.cd_con_pla = b.cd_con_pla and b.cd_regra = c.cd_regra
inner join convenio c1 on c1.cd_convenio = b.cd_convenio
inner join pro_fat d on d.cd_pro_fat = a.cd_pro_fat 
inner join itregra e on e.cd_regra = c.cd_regra and e.cd_gru_pro = d.cd_gru_pro
where 1 =1 

union all 

select 
'amb/urg/ext'tp_Atendimento,
b1.cd_multi_empresa,
a1.cd_atendimento,
b1.cd_reg_amb conta,
b1.cd_convenio,
c1.nm_convenio,
a1.cd_con_pla,
b1.Cd_Regra,
e.cd_tab_fat,
a1.cd_pro_fat,
A1.SN_PERTENCE_PACOTE,
trunc(a1.hr_lancamento)dt_lancamento,
a1.vl_unitario,
a1.qt_lancamento,
(a1.vl_unitario * a1.qt_lancamento)vl_total_Geral,
'6,20'vl_comercial
from 
itreg_amb a1
inner join reg_amb b1 on b1.cd_reg_amb = a1.cd_reg_amb
inner join empresa_con_pla c on c.cd_con_pla = a1.cd_con_pla and b1.cd_regra = c.cd_regra
inner join convenio c1 on c1.cd_convenio = a1.cd_convenio
inner join pro_fat d1 on d1.cd_pro_fat = a1.cd_pro_fat 
inner join itregra e on e.cd_regra = c.cd_regra and e.cd_gru_pro = d1.cd_gru_pro
where 1 = 1 
)
where dt_lancamento between '01/01/2019' AND '31/12/2019'--'&DT_LANC_INI' and '&DT_LANC_FIM'
and cd_Tab_fat IN (59)--(&CD_TAB_fAT)
and cd_pro_Fat = 40202135--'&CD_PRO_FAT'
and vl_unitario = '6,20'--'&VL_UNITARIO'
and cd_convenio = 41--&CD_CONVENIO

;

SELECT 
A.CD_PRO_FAT,
C.CD_TAB_FAT,
A.DT_VIGENCIA,
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
WHERE A.CD_TAB_FAT IN (59)
AND A.CD_PRO_FAT IN (40202135)
AND B.SN_ATIVO = 'S'
ORDER BY 3

;
select * from reg_Fat where cd_reg_fat in 
(select cd_reg_fat from  itreg_fat where Cd_reg_fat = 935589
 and cd_pro_Fat = 40202135);
;
select * from reg_amb where cd_Reg_amb = 935589 
; 
 select * from itreg_amb where cd_pro_Fat = 40202135 and
 cd_reg_amb in (select cd_REg_amb from reg_amb where cd_Reg_amb = 935589 ) 
 
;
select * from itregra x2 where x2.cd_regra in (233,8) and x2.cd_gru_pro = 24


