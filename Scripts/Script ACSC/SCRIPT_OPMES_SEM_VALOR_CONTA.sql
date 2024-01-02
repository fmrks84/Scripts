select 
*
from
(
select 
casas,
cd_convenio,
nm_convenio,
cd_pro_fat,
ds_pro_fat,
mes,
ano
--qt_lancamento
from
(
select 
decode(atd.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',11,'HMRP',25,'HCNSC')CASAS,
rf.cd_convenio,
conv.nm_convenio,
rf.cd_atendimento,
rf.Cd_Reg_Fat,
irf.cd_pro_fat,
pf.ds_pro_fat,
to_char(irf.dt_lancamento,'mm')mes,
to_char(irf.dt_lancamento,'rrrr')ano,
--irf.qt_lancamento,
irf.vl_unitario,
decode(irf.sn_pertence_pacote,'S','SIM','N','NAO') pert_pacote
from 
dbamv.itreg_fat irf 
inner join dbamv.reg_Fat rf on rf.cd_reg_fat = irf.cd_reg_fat
inner join atendime atd on atd.cd_atendimento = rf.cd_atendimento
inner join convenio conv on conv.cd_convenio = rf.cd_convenio
inner join pro_fat pf on pf.cd_pro_fat = irf.cd_pro_fat
where irf.cd_gru_fat in (5,9)
and to_char(irf.dt_lancamento,'RRRR') BETWEEN '2022' AND '2023'
and irf.vl_unitario = '0,00' 
and rf.cd_multi_empresa in (3,4,7,11,25)
--and irf.cd_pro_fat = 09032697
--and rf.cd_convenio = 5 
--and irf.sn_pertence_pacote = 'N'
order by to_char(irf.dt_lancamento,'rrrr'),ATD.CD_MULTI_EMPRESA,rf.cd_convenio,rf.cd_reg_fat
)
)pivot 
(count(mes)
      for(ano) in (2022,2023))
order by casas,cd_convenio,nm_convenio

;

select 
decode(atd.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',11,'HMRP',25,'HCNSC')CASAS,
rf.cd_convenio,
conv.nm_convenio,
rf.cd_atendimento,
rf.Cd_Reg_Fat,
rf.cd_remessa,
to_char(ft.dt_competencia,'mm/rrrr')comp_remessa,
irf.cd_pro_fat,
pf.ds_pro_fat,
to_char(irf.dt_lancamento,'mm')mes,
to_char(irf.dt_lancamento,'rrrr')ano,
--irf.qt_lancamento,
irf.vl_unitario,
decode(irf.sn_pertence_pacote,'S','SIM','N','NAO') pert_pacote,
decode(rf.tp_classificacao_conta,'O','Cancelada','Nao cancelada')status_Conta
from 
dbamv.itreg_fat irf 
inner join dbamv.reg_Fat rf on rf.cd_reg_fat = irf.cd_reg_fat
inner join atendime atd on atd.cd_atendimento = rf.cd_atendimento
inner join convenio conv on conv.cd_convenio = rf.cd_convenio
inner join pro_fat pf on pf.cd_pro_fat = irf.cd_pro_fat
left join  remessa_fatura rm on rm.cd_remessa = rf.cd_remessa
left join  fatura ft on ft.cd_fatura = rm.cd_fatura and rf.cd_convenio = ft.cd_convenio
where irf.cd_gru_fat in (5,9)
and to_char(irf.dt_lancamento,'RRRR') BETWEEN '2022' AND '2023'
and irf.vl_unitario = '0,00' 
and rf.cd_multi_empresa in (3,4,7,11,25)
--and irf.cd_pro_fat = 09032697
--and rf.cd_convenio = 5 
--and irf.sn_pertence_pacote = 'N'
order by to_char(irf.dt_lancamento,'rrrr') ,ATD.CD_MULTI_EMPRESA,rf.cd_convenio,rf.cd_reg_fat


