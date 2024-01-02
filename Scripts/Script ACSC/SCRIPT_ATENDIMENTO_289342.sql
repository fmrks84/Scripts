
select * from atendime a where a.cd_atendimento = 289342;
select 
rf.cd_atendimento atendimento,
rf.cd_convenio||' - '||conv.nm_convenio convenio_conta,
rf.cd_reg_fat CONTA,
to_char(irf.dt_lancamento,'dd/mm/rrrr')||'  '||to_char(irf.hr_lancamento,'hh24:mi')dthora_lanc,
irf.cd_pro_fat||' - '||pf.ds_pro_fat ds_procedimento,
irf.qt_lancamento,
irf.vl_total_conta vl_total
from 
reg_Fat rf
inner join itreg_Fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join pro_Fat pf on pf.cd_pro_fat = irf.cd_pro_fat
inner join atendime atd on  atd.cd_atendimento = rf.cd_atendimento
inner join convenio conv on conv.cd_convenio = rf.cd_convenio
where trunc(irf.dt_lancamento) between '29/07/2018' and '30/06/2022'  
And rf.cd_atendimento = 289342
and rf.cd_convenio = 281 
and irf.Cd_Gru_Fat = 1 
and irf.sn_pertence_pacote = 'N'
order by 2,3,4




--select distinct cd_convenio from reg_Fat where cd_atendimento = 289342
--select * from convenio where cd_convenio in (261,281,68)
