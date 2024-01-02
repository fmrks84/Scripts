select 
tipo_atend,
cd_repasse,
cd_atendimento,
cd_convenio,
cd_con_pla,
conta,
cd_remessa,
qt_lancamento,
tp_mvto,
cd_usuario,
vl_total_conta vl_total_lancamento,
cd_pro_fat,
ds_pro_fat,
vl_repasse
from
(
select
'PS/AMB/EXT'TIPO_ATEND,
x1.cd_repasse,
amb.cd_atendimento,
amb.cd_convenio,
amb.cd_con_pla,
x1.cd_reg_amb conta,
ramb.cd_remessa,
AMB.QT_LANCAMENTO,
amb.tp_mvto,
amb.cd_usuario,
amb.vl_total_conta,
amb.cd_pro_fat,
pf.ds_pro_fat,
amb.cd_lancamento,
x1.vl_repasse,
x1.vl_perc_repasse,
x1.cd_prestador,
prest.nm_prestador,
eprest.cd_reg_repasse
from 
it_repasse x1 
inner join repasse x on x1.cd_repasse = x.CD_REPASSE 
inner join itreg_amb amb on amb.cd_reg_amb = x1.cd_reg_amb and amb.cd_lancamento = x1.cd_lancamento_amb
inner join reg_amb ramb on ramb.cd_reg_amb = amb.cd_reg_amb
inner join empresa_prestador eprest on eprest.cd_prestador = x1.cd_prestador 
inner join prestador prest on prest.cd_prestador = x1.cd_prestador
inner join pro_Fat pf on pf.cd_pro_fat = amb.cd_pro_fat
where  x.DT_COMPETENCIA = '01/12/2021' and x.CD_MULTI_EMPRESA = 1
--and amb.cd_atendimento in (8175435,8166177,8213420,8172013,8191026,8160347)
and x1.cd_prestador = 1762
and amb.qt_lancamento >= 80
--order by amb.cd_atendimento,amb.cd_pro_fat
union all 
select 
'HOSPITALAR'TIPO_ATEND,
x1.cd_repasse,
rf.cd_atendimento,
rf.cd_convenio,
rf.cd_con_pla,
x1.cd_reg_fat conta,
rf.cd_remessa,
IRF.QT_LANCAMENTO,
irf.tp_mvto,
irf.cd_usuario,
irf.vl_total_conta,
irf.cd_pro_fat,
pf.ds_pro_fat,
irf.cd_lancamento,
x1.vl_repasse,
x1.vl_perc_repasse,
x1.cd_prestador,
prest.nm_prestador,
eprest.cd_reg_repasse
from 
it_repasse x1 
inner join repasse x on x1.cd_repasse = x.CD_REPASSE 
inner join itreg_Fat irf on irf.cd_reg_fat = x1.cd_reg_fat and irf.cd_lancamento = x1.cd_lancamento_fat
inner join reg_fat rf on rf.cd_reg_fat = irf.cd_reg_fat
inner join empresa_prestador eprest on eprest.cd_prestador = x1.cd_prestador 
inner join prestador prest on prest.cd_prestador = x1.cd_prestador
inner join pro_Fat pf on pf.cd_pro_fat = irf.cd_pro_fat
where  x.DT_COMPETENCIA = '01/12/2021' and x.CD_MULTI_EMPRESA = 1
and x1.cd_prestador = 1762
and irf.qt_lancamento > = 30
)order by ds_pro_fat



/*select 
* from atendime where cd_atendimento in (8175435,8166177,8213420,8172013,8191026,8160347)*/


/*;
select sum(inf.vl_itfat_nf)vl_total_nota,
       inf.cd_remessa ,
       nf.dt_emissao,
       nf.nr_id_nota_fiscal,
       nf.nr_nota_fiscal_nfe
from itfat_nota_fiscal inf
inner join nota_fiscal nf on nf.cd_nota_fiscal = inf.cd_nota_fiscal      
where inf.cd_remessa in(
471208,
474737,
472727,
471696,
470800,
471048,
473558,
472715,
471713,
472649,
474072,
471711,
474198)
group by inf.cd_remessa,
          nf.dt_emissao,
       nf.nr_id_nota_fiscal,
       nf.nr_nota_fiscal_nfe
       */
       
    
--select * from itreg_amb where cd_reg_amb = 7452009 and cd_pro_fat = 74009144
   

