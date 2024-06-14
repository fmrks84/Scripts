
select * from remessa_fatura where cd_remessa = 139404
select * from fatura where cd_fatura = 18276
select * from audit_dbamv.remessa_fatura where cd_remessa = 139404

select 
*
from
audit_dbamv.reg_fat
where cd_reg_fat = 668761
order by 1 desc 
;
select * from sys.reg_fat_audit where cd_Reg_Fat = 668761 order by dt_aud desc 
;
select rf.cd_reg_fat,rf.cd_atendimento,atd.dt_atendimento,rf.vl_total_conta from reg_Fat rf
inner join atendime atd on atd.cd_atendimento = rf.cd_atendimento
where cd_remessa = 139404
and to_char(atd.dt_atendimento,'rrrr') in ('2023','2024')
;
select distinct inf.cd_remessa , 
inf.cd_reg_fat , 
icr.tp_quitacao,
atd.dt_atendimento,
 rft.cd_convenio, 
 ft.cd_fatura,
 ft.dt_competencia,
 nf.nr_id_nota_fiscal,
 nf.nr_nota_fiscal_nfe,
 nf.dt_emissao,
 atd.tp_atendimento
from itfat_nota_fiscal inf 
inner join reg_fat rft on rft.cd_reg_fat = inf.cd_reg_Fat
inner join atendime atd on atd.cd_atendimento = rft.cd_atendimento
inner join remessa_Fatura rm on rm.cd_remessa = inf.cd_remessa
inner join fatura ft on ft.cd_fatura = rm.cd_fatura
inner join nota_fiscal nf on nf.cd_nota_fiscal = inf.cd_nota_fiscal
inner join con_Rec cr on cr.cd_reg_fat = rft.cd_reg_fat
inner join itcon_Rec icr on icr.cd_con_rec =  cr.cd_con_rec
where inf.cd_reg_Fat in (select rf.cd_reg_fat/*,rf.cd_atendimento,atd.dt_atendimento,rf.vl_total_conta*/ from reg_Fat rf
inner join atendime atd on atd.cd_atendimento = rf.cd_atendimento
where inf.cd_remessa = 139404
and to_char(atd.dt_atendimento,'rrrr') in ('2021','2023','2024')
)
order by 4

;

select cd_Remessa, dt_fechamento from remessa_fatura where cd_Fatura in (
select cd_Fatura from fatura where cd_convenio = 102 and cd_multi_empresa = 3)
and cd_remessa = 432365-- and cd_Fatura = 18276

;

select * from reg_Fat where cd_reg_fat = 279889
update dbamv.reg_Fat  set cd_remessa = 432366 where cd_reg_fat in (274084,274641,276001); -- 192520
update dbamv.reg_Fat  set cd_remessa = 432367 where cd_reg_fat in (279389)
update dbamv.reg_Fat  set cd_remessa = 205737 where cd_reg_fat in (298070); -- 205737
--update dbamv.reg_Fat  set cd_remessa =  where cd_reg_fat in (299970); -- criar remessa 06/04/2021
update dbamv.reg_Fat  set cd_remessa = 210894 where cd_reg_fat in (307212) ;-- 210894
--update dbamv.reg_Fat  set cd_remessa =  where cd_reg_fat in (308561) -- criar remessa 06/05/2021
update dbamv.reg_Fat  set cd_remessa = 212821 where cd_reg_fat in (324255); -- 212821
update dbamv.reg_Fat  set cd_remessa = 218820 where cd_reg_fat in (319039); -- 218820
update dbamv.reg_Fat  set cd_remessa = 224172 where cd_reg_fat in (397032,327400);-- 224172
--update dbamv.reg_Fat  set cd_remessa = 225792 where cd_reg_fat in (329457) ;-- 225792
update dbamv.reg_Fat  set cd_remessa = 227936 where cd_reg_fat in (332659,332846); -- 227936
update dbamv.reg_Fat  set cd_remessa = 231072 where cd_reg_fat in (337436) ;-- 231072
update dbamv.reg_Fat  set cd_remessa = 340795 where cd_reg_fat in (504025); -- 340795
--update dbamv.reg_Fat  set cd_remessa =  where cd_reg_fat in (508980,511882) -- criar remessa 21/01/223 a 30/01/2023
update dbamv.reg_Fat  set cd_remessa = 339956 where cd_reg_fat in (516514) ;-- 339956
update dbamv.reg_Fat  set cd_remessa = 341224 where cd_reg_fat in (519493); -- 341224
--update dbamv.reg_Fat  set cd_remessa = 344036 where cd_reg_fat in (540145,521929); -- 3440436
--update dbamv.reg_Fat  set cd_remessa =  where cd_reg_fat in (523664) -- criar remessa 04/03/2023
update dbamv.reg_Fat  set cd_remessa = 344955 where cd_reg_fat in (543479,543945); -- 354955
update dbamv.reg_Fat  set cd_remessa = 359206 where cd_reg_fat in (551979,549976,549668) ;-- 359206
update dbamv.reg_Fat  set cd_remessa = 370217 where cd_reg_fat in (572017); -- 370217
update dbamv.reg_Fat  set cd_remessa = 380021 where cd_reg_fat in (589475) ;-- 380021
update dbamv.reg_Fat  set cd_remessa = 385497 where cd_reg_fat in (600708); -- 385497
update dbamv.reg_Fat  set cd_remessa = 395256 where cd_reg_fat in (613266) ;-- 395256
update dbamv.reg_Fat  set cd_remessa = 394348 where cd_reg_fat in (615662) ;-- 394348
--update dbamv.reg_Fat  set cd_remessa =  where cd_reg_fat in (619171) -- criar remessa 16/11/2023
update dbamv.reg_Fat  set cd_remessa = 414217 where cd_reg_fat in (649987,651501) ;-- 414217
update dbamv.reg_Fat  set cd_remessa = 416827 where cd_reg_fat in (655578,656626); -- 416827
update dbamv.reg_Fat  set cd_remessa = 419495 where cd_reg_fat in (660429,660495) ;-- 419495
--update dbamv.reg_Fat  set cd_remessa =  where cd_reg_fat in (668761) -- criar remessa 08/04/2024
commit;





select distinct inf.cd_remessa , 
inf.cd_reg_fat , 
icr.tp_quitacao,
atd.dt_atendimento,
 rft.cd_convenio, 
 ft.cd_fatura,
 ft.dt_competencia,
 nf.nr_id_nota_fiscal,
 nf.nr_nota_fiscal_nfe,
 nf.dt_emissao,
 atd.tp_atendimento
from itfat_nota_fiscal inf 
inner join reg_fat rft on rft.cd_reg_fat = inf.cd_reg_Fat
inner join atendime atd on atd.cd_atendimento = rft.cd_atendimento
inner join remessa_Fatura rm on rm.cd_remessa = inf.cd_remessa
inner join fatura ft on ft.cd_fatura = rm.cd_fatura
inner join nota_fiscal nf on nf.cd_nota_fiscal = inf.cd_nota_fiscal
inner join con_Rec cr on cr.cd_reg_fat = rft.cd_reg_fat
inner join itcon_Rec icr on icr.cd_con_rec =  cr.cd_con_rec
where inf.cd_reg_Fat in (select rf.cd_reg_fat  from reg_Fat rf
inner join atendime atd on atd.cd_atendimento = rf.cd_atendimento
where rf.cd_remessa = 139404
and to_char(atd.dt_atendimento,'rrrr') in ('2020','2021','2022','2023')--,'2023','2024')
)
order by 4
;
cd_reg_fat in (274084, 274641, 276001, 279389, 298070, 299970, 307212, 308561, 324255, 319039, 397032, 327400, 329457, 332659, 332846, 337436, 504025, 508980, 511882, 516514, 519493, 520145, 521929, 523664, 543479, 543945, 549668, 549976, 551979, 572017, 589475, 600708, 607789, 613266, 615662, 619171, 649987, 651501, 655578, 656626, 660429, 660495, 668761)
;
update dbamv.reg_Fat set cd_remessa = 433596  where cd_reg_Fat in (274084,274641);
update dbamv.reg_Fat set cd_remessa =  192520 where cd_reg_Fat in (276001,279389);
update dbamv.reg_Fat set cd_remessa =  205737 where cd_reg_Fat in (298070);
update dbamv.reg_Fat set cd_remessa =  433598 where cd_reg_Fat in (299970);
update dbamv.reg_Fat set cd_remessa =  210894 where cd_reg_Fat in (307212);
update dbamv.reg_Fat set cd_remessa =  433599 where cd_reg_Fat in (308561);
update dbamv.reg_Fat set cd_remessa =  212821 where cd_reg_Fat in (324255);
update dbamv.reg_Fat set cd_remessa =  218820 where cd_reg_Fat in (319039);
update dbamv.reg_Fat set cd_remessa =  224172 where cd_reg_Fat in (397032,327400);
update dbamv.reg_Fat set cd_remessa =  225292 where cd_reg_Fat in (329457);
update dbamv.reg_Fat set cd_remessa =  433601 where cd_reg_Fat in (332659,332846);
update dbamv.reg_Fat set cd_remessa =  231072 where cd_reg_Fat in (337436);
update dbamv.reg_Fat set cd_remessa =  336356 where cd_reg_Fat in (504025,508980);
update dbamv.reg_Fat set cd_remessa =  433604 where cd_reg_Fat in (511882);
update dbamv.reg_Fat set cd_remessa = 339956  where cd_reg_Fat in (516514);
update dbamv.reg_Fat set cd_remessa =  341224 where cd_reg_Fat in (519493);
update dbamv.reg_Fat set cd_remessa =  344043 where cd_reg_Fat in (520145,521929);
update dbamv.reg_Fat set cd_remessa =  433607 where cd_reg_Fat in (523664);
update dbamv.reg_Fat set cd_remessa =  354955 where cd_reg_Fat in (543479,543945);
update dbamv.reg_Fat set cd_remessa =  359206 where cd_reg_Fat in (549668,549976,551979);
update dbamv.reg_Fat set cd_remessa = 370217  where cd_reg_Fat in (572017);
update dbamv.reg_Fat set cd_remessa =  380021 where cd_reg_Fat in (589475);
update dbamv.reg_Fat set cd_remessa =  385497 where cd_reg_Fat in (600708);
update dbamv.reg_Fat set cd_remessa = 390497  where cd_reg_Fat in (607789);
update dbamv.reg_Fat set cd_remessa = 395256  where cd_reg_Fat in (613266);
update dbamv.reg_Fat set cd_remessa = 394348  where cd_reg_Fat in (615662);
update dbamv.reg_Fat set cd_remessa =  433618 where cd_reg_Fat in (619171);
update dbamv.reg_Fat set cd_remessa =  414217 where cd_reg_Fat in (649987,651501);
update dbamv.reg_Fat set cd_remessa =  416827 where cd_reg_Fat in (655578,656626);
update dbamv.reg_Fat set cd_remessa =  433622 where cd_reg_Fat in (660429,660495);
update dbamv.reg_Fat set cd_remessa =  433624 where cd_reg_Fat in (668761);
update dbamv.reg_Fat set cd_remessa =  262236 where cd_reg_Fat in (384481)--
update dbamv.reg_Fat set cd_remessa =  275509 where cd_reg_Fat in (405438,406641)--
update dbamv.reg_Fat set cd_remessa =  293876 where cd_reg_Fat in (428974,446463,437085)--
update dbamv.reg_Fat set cd_remessa =  301474 where cd_reg_Fat in (443789,446599)--
update dbamv.reg_Fat set cd_remessa =  306963 where cd_reg_Fat in (456294) --
update dbamv.reg_Fat set cd_remessa =  312625 where cd_reg_Fat in (461272,472785)
update dbamv.reg_Fat set cd_remessa =  433691 where cd_reg_Fat in (487979) --
update dbamv.reg_Fat set cd_remessa =  331498 where cd_reg_Fat in (501777)

commit;

select cd_remessa 
from reg_Fat 
where cd_reg_fat in (274084, 274641, 276001, 279389, 298070, 
299970, 307212, 308561, 324255, 319039, 397032, 327400, 329457, 
332659, 332846, 337436, 504025, 508980, 511882, 516514, 519493, 
520145, 521929, 523664, 543479, 543945, 549668, 549976, 551979,
 572017, 589475, 600708, 607789, 613266, 615662, 619171, 649987, 
 651501, 655578, 656626, 660429, 660495, 668761)









