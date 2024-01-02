--select * from dbamv.reg_Fat a where a.cd_remessa in (114504,114465,114363,114061,113956,113632,113550,114437)
select b.cd_remessa ,c.CD_CONVENIO, b.cd_remessa_pai , c.CD_MULTI_EMPRESA , c.DT_COMPETENCIA
from dbamv.remessa_fatura b ,
     dbamv.fatura c
where b.cd_remessa in (114511)--(114504,113632,114061,113956,113550,114363,114465)--(114504,114465,114363,114061,113956,113632,113550,114437)
and b.cd_fatura = c.CD_FATURA

--(114504,113632,114061,113956,114437,113550,114363,114465)
select reg_fat.cd_reg_fat ,reg_fat.cd_atendimento, reg_Fat.Cd_Remessa ,reg_Fat.Cd_Multi_Empresa from dbamv.reg_Fat where reg_Fat.Cd_Remessa in (113550)--113547

-- reg_fat(1493238,1495742,1497188

select reg_fat.cd_atendimento ,reg_fat.cd_reg_fat , reg_Fat.Cd_Remessa ,reg_Fat.Cd_Multi_Empresa 
from dbamv.reg_Fat where reg_Fat.Cd_Remessa in(114511)--,113632,113956,114061,114363,114437,114465,114504)

--select * from dbamv.itreg_fat where itreg_fat.cd_reg_fat in (1493238,1493065)
