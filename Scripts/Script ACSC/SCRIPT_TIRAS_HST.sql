with tiras as (
select pr.cd_produto,
pr.ds_produto, 
pr.cd_pro_fat from produto pr 
inner join empresa_produto epr on epr.cd_produto = pr.cd_produto
where pr.ds_produto like 'TIRA%GLICEM%'
and epr.cd_multi_empresa = 4 
and pr.sn_movimentacao = 'S'
)

select 
*
from
(
select 
'INTERNADO'TIPO_CONTA,
rf.cd_convenio,
conv.nm_convenio,
rf.cd_atendimento,
rf.cd_reg_fat,
irf.cd_pro_fat,
pf.ds_pro_fat,
irf.tp_mvto,
irf.cd_mvto,
ipm.cd_tip_presc,
tpx.ds_tip_presc,
trunc(irf.dt_lancamento)dt_lancamento,
irf.qt_lancamento
from 
itreg_Fat irf 
inner join reg_fat rf on rf.cd_reg_fat = irf.cd_reg_fat and rf.cd_multi_empresa = 4 
inner join tiras tr on tr.cd_pro_Fat = irf.cd_pro_fat
inner join convenio conv on conv.cd_convenio = rf.cd_convenio 
inner join pro_fat pf on pf.cd_pro_fat = irf.cd_pro_fat
left join itpre_med ipm on ipm.cd_itpre_med = irf.cd_mvto  and irf.tp_mvto in ('Componente') 
left join tip_presc tpx on tpx.cd_tip_presc = ipm.cd_tip_presc
where trunc(irf.dt_lancamento) between to_date('01/08/2023','dd/mm/rrrr') and to_date('25/08/2023','dd/mm/rrrr')
--order by rf.cd_convenio, irf.dt_lancamento;
UNION ALL 
select 
'AMBULATORIO' TIPO_CONTA,
ramb.cd_convenio,
conv.nm_convenio,
iramb.cd_atendimento,
ramb.cd_reg_amb,
iramb.cd_pro_fat,
pf.ds_pro_fat,
iramb.tp_mvto,
iramb.cd_mvto,
ipmx.cd_tip_presc,
tp.ds_tip_presc,
--irf.cd_mvto,
to_DATE(iramb.hr_lancamento,'DD/MM/RRRR')dt_lancamento,
iramb.qt_lancamento
from 
itreg_amb iramb
inner join reg_amb ramb on ramb.cd_reg_amb = iramb.cd_reg_amb and ramb.cd_multi_empresa = 4 
inner join tiras tr on tr.cd_pro_Fat = iramb.cd_pro_fat
inner join convenio conv on conv.cd_convenio = ramb.cd_convenio 
inner join pro_fat pf on pf.cd_pro_fat = iramb.cd_pro_fat
left join itpre_med ipmx on ipmx.cd_itpre_med = iramb.cd_mvto  and iramb.tp_mvto in ('Componente') 
left join tip_presc tp on tp.cd_tip_presc = ipmx.cd_tip_presc
where to_char(iramb.hr_lancamento,'DD/MM/RRRR') between to_date('01/07/2023','dd/mm/rrrr') and to_date('25/08/2023','dd/mm/rrrr')
)
--where cd_reg_fat = 582034
---group by tp_mvto
--order by tIpo_conta,cd_convenio, dt_lancamento;

/*
select * from itreg_fat where cd_reg_fat = 582034 and cd_pro_Fat in (00245867);
98510499
98466893
98566397
98634796
98694979
98786606

--select 
select * from pre_med pm 
inner join itpre_med ipm on ipm.cd_pre_med = pm.cd_pre_med
where pm.cd_atendimento = 5255932 
and ipm.cd_itpre_med in (98510499,
98466893,
98566397,
98634796,
98694979,
98786606)

select * from tip_presc where cd_tip_presc = 81299*/

