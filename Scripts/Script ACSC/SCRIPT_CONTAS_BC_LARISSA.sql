select 
case when atd.tp_atendimento = 'I' then 'Internado'
     when atd.tp_atendimento = 'U' then 'Urgencia'
     when atd.tp_atendimento = 'E' then 'Externo'
     when atd.tp_atendimento = 'A' then 'Ambulatorio'
end tp_conta,
rf.cd_atendimento,
pct.nm_paciente,
ortt.ds_ori_ate origem_atendimento,
rf.cd_reg_fat conta,
decode (rf.sn_fechada,'S','Sim','N','Não')conta_fechada,
nf.dt_emissao,
decode(nf.cd_status,'E','Emitada',null,'Não Emitda')cd_status,
nf.nr_id_nota_fiscal RPS,
nf.nr_nota_fiscal_nfe NFE,
to_date(irf.dt_lancamento,'dd/mm/rrrr')dt_lancamento,
irf.cd_pro_fat cod_procedimento,
pf.ds_pro_fat ds_procedimento,
irf.qt_lancamento qtd,
nvl(irf.vl_total_conta,0)vl_total
--nvl(nf.vl_total_nota,0)vl_total_nota



 from 
dbamv.reg_Fat rf 
left join dbamv.nota_fiscal nf on nf.cd_reg_fat = rf.cd_reg_fat
and nf.cd_atendimento = rf.cd_atendimento
inner join dbamv.itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat
and irf.sn_pertence_pacote = 'N'
inner join atendime atd on atd.cd_atendimento = rf.cd_atendimento
inner join ori_Ate ortt on ortt.cd_ori_ate = atd.cd_ori_ate
inner join paciente pct on pct.cd_paciente = atd.cd_paciente
inner join pro_Fat pf on pf.cd_pro_fat = irf.cd_pro_fat
where rf.cd_reg_fat in 
(538279  ,538373  ,539778  ,542744  ,543523  ,555711  ,
556965  ,559906  ,561362  ,563644  ,573364  ,573366  ,
573358  ,573359  ,573362  ,573361  ,565478  ,581147  ,
581161  ,573352  ,581156  ,581150  ,587384  ,601202  ,
601200  ,588636  ,591301  ,611187  ,591992  ,612466  ,
620778  ,612122  ,609368  ,597156  ,598490  ,609369  ,
598377  ,611624  ,611180  ,599417  ,599424  ,611626  ,
612038  ,609330  ,611629  ,612027  ,620779  ,600696  ,
612033  ,600936  ,603699  ,611179  ,604937  ,621026  ,
606365  ,607164  ,621033  ,620776  ,608389  ,617741  ,
608653  ,611200  ,609639  ,621029  ,611112  ,621013  ,
612031  ,613804  ,616293  ,615530  ,616143  ,617341  ,
618129  ,619104  ,619620  ,619782  ,619820  ,620292  ,
620707  ,621668  ,622403  ,622859  ,626973  ,625806  ,
626227  ,626571  ,628621  ,628732  ,629259  ,633723  ,
634720  ,634756  ,635213  ,636393 ,
479874, 526127, 541395, 541404, 541367, 541366, 
540641, 554527, 553240, 549964, 578620, 578591, 578625, 
591769, 591778, 592405, 601527, 601540, 63794, 601523, 
601201, 601516, 601515, 62751, 601510, 601033, 603725, 
612030, 594719, 609383, 617807, 617794, 617783, 617786)
and atd.cd_multi_empresa = 7 

union all 

select 
case when atdx.tp_atendimento = 'I' then 'Internado'
     when atdx.tp_atendimento = 'U' then 'Urgencia'
     when atdx.tp_atendimento = 'E' then 'Externo'
     when atdx.tp_atendimento = 'A' then 'Ambulatorio'
end tp_conta,
iramb.cd_atendimento atendimento,
pcx.nm_paciente,
ort.ds_ori_ate origem_atendimento,
ramb.cd_reg_amb conta,
decode (iramb.sn_fechada,'S','Sim','N','Não')conta_fechada,
nfx.dt_emissao,
decode(nfx.cd_status,'E','Emitada',null,'Não Emitda')cd_status,
--nfx.cd_status,
nfx.nr_id_nota_fiscal rps ,
nfx.nr_nota_fiscal_nfe nfe ,
to_date(iramb.hr_lancamento,'dd/mm/rrrr')dt_lancamento,
iramb.cd_pro_fat cod_procedimento,
pfx.ds_pro_fat ds_procedimento,
iramb.qt_lancamento qtd,
nvl(iramb.vl_total_conta,0)vl_total
--nfx.cd_multi_empresa

from 
dbamv.reg_amb ramb
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.atendime atdx on atdx.cd_atendimento = iramb.cd_atendimento
inner join dbamv.ori_ate ort on ort.cd_ori_ate = atdx.cd_ori_ate
left join dbamv.nota_fiscal nfx on nfx.cd_reg_amb = ramb.cd_reg_amb
and nfx.cd_atendimento = iramb.cd_atendimento
inner join dbamv.paciente pcx on pcx.cd_paciente = atdx.cd_paciente
inner join dbamv.pro_fat pfx on pfx.cd_pro_fat = iramb.cd_pro_fat
where ramb.cd_reg_amb in (3384630, 3552339, 3452354, 3544822, 3563167, 3639684, 
3627608, 3708230, 4013195, 4137876, 4039096, 4070183, 4141521, 4143253, 
4158519, 4158851, 4223182, 4287762, 4301241, 4318603, 472228, 494699,
 508786, 4420385, 564015, 4456541, 4419107, 613814, 637144, 474686, 
 475023, 486115, 4413206, 491187, 4272112, 651037, 4328974, 4559195,
  4605092, 747277, 4677283)
and iramb.sn_pertence_pacote = 'N'
and atdx.cd_multi_empresa =  7

order by nm_paciente,cd_Atendimento 


