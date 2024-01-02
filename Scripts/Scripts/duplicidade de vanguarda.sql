Select cd_atendimento, Cd_Reg_Fat, Cd_Conta_Pai, cd_convenio, cd_con_pla ,Cd_Multi_Empresa, Sn_Fechada, Dt_Inicio, Dt_Final, DT_fECHAMENTO ,Vl_Total_Conta, cd_remessa 
From Dbamv.Reg_Fat Where Nvl(Cd_Conta_Pai, Cd_Reg_Fat) in (255244)--(1493065,1494741,1496700,1493646,1493651,1501566,1494756,1494758,1499326,1501664,1497052,1501666,1501670,1490692,1499085,1493634,1500756,1491990,1490585)
for update 
Order By 1 

select cd_conta_pai from dbamv.reg_Fat where cd_Reg_fat = 1469839--1469837
--delete from dbamv.auditoria_conta ct where ct.Cd_Atendimento = 1648807--ct.cd_reg_fat in (1425749,1425868)

1319245,


select x.cd_reg_fat, x.dt_inicio, x.dt_final, X.CD_CONVENIO, x.cd_conta_pai, x.cd_multi_empresa, x.cd_remessa 
from dbamv.reg_Fat x where x.cd_atendimento  in(2322073)  
and x.cd_multi_empresa = 4 --for update

---------------------

Select distinct
rf.cd_conta_pai CONTA_MAE,
it.cd_conta_pai CONTA_PAI,
it.cd_reg_fat   CONTA 
from dbamv.reg_fat rf,
     dbamv.itreg_fat it
where
rf.cd_remessa =  108853  and
it.cd_reg_fat = rf.cd_reg_fat and
it.cd_conta_pai = it.cd_reg_fat


Select ff.cd_reg_fat, ff.dt_lancamento,ff.dt_integra,ff.cd_pro_fat, ff.cd_conta_pai , ff.cd_lancamento , ff.cd_gru_fat , ff.cd_usuario, ff.sn_repassado
from dbamv.itreg_fat ff 
where ff.cd_reg_Fat in (1673050,1673051)
/*and ff.dt_lancamento >= '17/11/2016'
order by 2*/
for update --and ff.cd_gru_fat in (7) order by 3 for update

update dbamv.itreg_fat it set it.cd_conta_pai = 1335942 where it.cd_conta_pai = 1336054 --> o que sera alterado


select * from dbamv.itreg_Fat x5 where x5.cd_reg_fat = 1319245
and x5.cd_prestador in (2780,9992)

select * from dbamv.it_repasse a where a.cd_reg_fat = 1150336
select * from dbamv.repa
-------------------

select * from dbamv.it_repasse ac where ac.cd_reg_fat = 255244 --for update --ac.cd_repasse iN (9735)-- 1º
select * from dbamv.repasse_prestador zz where zz.cd_prestador = 209 and zz.cd_repasse In (18963)  -- 2º
select * from dbamv.repasse rr where  rr.CD_REPASSE in(18963)-- 3º

delete from dbamv.Reg_Fat x where x.cd_reg_fat = 1231953 --for update

----- problemas para apagar remessas 
select reg_fat.cd_atendimento ,reg_fat.cd_reg_fat , reg_Fat.Cd_Remessa ,reg_Fat.Cd_Multi_Empresa 
from dbamv.reg_Fat where reg_Fat.Cd_Remessa in(114511)

------ retirar conta de remessa

select cd_remessa, cd_reg_fat, Cd_Conta_Pai, Cd_Multi_Empresa from dbamv.reg_fat where cd_reg_Fat in 1504230 for update

delete from dbamv.reg_fat where cd_reg_Fat in 1504230 

select * from dbamv.remessa_fatura where remessa_fatura.cd_remessa = 114511






/* ---- 09/03/2018
select r.cd_reg_fat, r.cd_conta_pai, r.cd_convenio, r.dt_inicio, r.dt_final, r.dt_remessa,r.dt_fechamento,r.cd_Multi_Empresa 
from dbamv.reg_fat r where (r.cd_reg_fat) in(1460248
,1497895
,1495069
,1494029
,1484144
,1494322
,1487092
,1484631
,1478981
,1491955
,1494162
,1494163
,1498417
,1498418
,1468472
,1494172
,1496138
,1494040
,1496950
,1496951
,1491954
,1499884
,1481873
,1497310
,1500875
,1500876
,1478694
,1498145
,1498146
,1499827
,1496816
,1484684
,1496722
,1481876
,1494724
,1498268
,1502120
,1500615
,1494541
,1500852
,1500853
,1499573
,1495772
,1504352
,1499821
,1485834
,1501215
,1493203
,1493204
,1487109
,1496490
,1495417
,1495418
,1496576
,1500022
,1498565
,1498566
,1484042
,1497991
,1496595
,1496596
,1485494
,1495769
,1494318
,1499537
,1499556
,1464811
,1497199
,1496135
,1475248
,1497361
,1497362
,1499671
,1499672
,1499732
,1499733
,1499738
,1499739
,1481455
,1493103
,1481847
,1500584
,1500023
,1499848
,1499849
,1498316
,1494698) 
order by 7*/
