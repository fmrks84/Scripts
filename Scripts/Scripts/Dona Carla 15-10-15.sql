select * from dbamv.itreg_Fat a where a.cd_reg_fat = 1131936 
and a.cd_pro_fat = '00014002'

--1251829 / 1254837 / 1236655 / 1245288 / 1242912 / 1248262 / 1251006 / 1251829 hmsj
-- 1250031 / 1238667 pmp
select B.CD_ATENDIMENTO, B.NM_INCLUSAO, B.DT_INCLUSAO from Dbamv.Hmsj_Contr_Lanchonete b where b.cd_atendimento = 1238667   order by 3
