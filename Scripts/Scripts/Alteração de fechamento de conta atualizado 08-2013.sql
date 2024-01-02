select r.cd_reg_fat, r.cd_conta_pai, r.dt_inicio, r.dt_final, r.dt_fechamento, r.Cd_Multi_Empresa, r.vl_total_conta, r.nm_usuario_fechou
 from dbamv.reg_fat r where nvl(r.cd_conta_pai, r.cd_reg_fat) in (810094)
 order by r.cd_reg_fat, r.cd_conta_pai for update;
------------------------- retornar contas convênio mês anterior--------------
select r.cd_reg_fat, r.cd_conta_pai, r.dt_inicio, r.dt_final, r.dt_remessa,r.dt_fechamento,r.cd_Multi_Empresa 
from dbamv.reg_fat r where (r.cd_reg_fat) in (1454838
,1453748
,1461336
,1460430
,1454426
,1451274
,1454429
,1447387
,1462172
,1465834
,1461973
,1462220
,1456498
,1454516
)for update;

select * from dbamv.itreg_amb a where a.cd_reg_amb = 709414 for update
-------------------------------------------------------------------------------------------
select * from dbamv.remessa_fatura where cd_remessa = 72977 for update 
select * from dbamv.fatura where cd_Fatura = 20995cd_convenio = 378 and dt_competencia = '01/11/2014'
select * from dbamv.fatura where cd_convenio = 378 and dt_competencia = '01/10/2014' for update

-------------------- retirar remessa de atendimento----------------(não esquecer de tirar as remessas e solcitar para o fatur.entrar em contato para vc inclui-las denovo)
select cd_remessa, cd_reg_fat, Cd_Conta_Pai, Cd_Multi_Empresa from dbamv.reg_fat where cd_reg_Fat in (1138205)for update;--(67485 - 05-02-2015)--where nvl(cd_conta_pai, cd_reg_Fat) in 988236 for update;
select cd_remessa, cd_reg_fat, Cd_Conta_Pai, Cd_Multi_Empresa from dbamv.reg_fat where nvl(cd_conta_pai, cd_reg_Fat) in (1126091) for update-- (945957,962120,968606,972621,983405) for update;

--------------------
select cd_remessa , cd_reg_amb , cd_multi_empresa from dbamv.reg_amb where cd_reg_amb IN (745279)for update
select * from dbamv.remessa_fatura where cd_remessa iN (76534)for update
select * from dbamv.itreg_amb x where x.cd_atendimento = 1160120
select * from dbamv.itfat_nota_fiscal nf where nf.cd_remessa iN (76534)--71805,71806,71485,71487,72974,72975,72976,72422,72423,70675,70676,70677,72977,72978,72979,71480,71481,70234,70235,70241,70242)
-----------------------
Select Cd_Reg_Fat, Cd_Conta_Pai, Cd_Multi_Empresa, Sn_Fechada, Dt_Inicio, Dt_Final, Vl_Total_Conta, cd_remessa 
From Dbamv.Reg_Fat Where Nvl(Cd_Conta_Pai, Cd_Reg_Fat) =1051517--1070399--1057729 
Order By 1 for update;

select cd_reg_Fat , cd_conta_pai, cd_multi_empresa  from dbamv.reg_Fat where cd_Atendimento IN (1225862) for update
------------------------------------------------repasse
select * from dbamv.itreg_fat f where f.cd_reg_fat = 1041690  and f.cd_gru_fat = 6 for update
DELETE from dbamv.it_repasse where cd_reg_fat IN (1106211,1106212,1106096)--for update--repasse_prestador --37720149 f
select distinct cd_reg_fat , cd_conta_pai, cd_multi_empresa from dbamv.itreg_fat where cd_reg_Fat = 1160700 order by 3
-----------------------------------
delete from dbamv.auditoria_conta a where a.cd_reg_fat in (1089900,1089901)
DELETE from dbamv.it_repasse rp where rp.cd_repasse = 17131

71482,71483,70236,70237,72412,72413,72420,72421,71804
