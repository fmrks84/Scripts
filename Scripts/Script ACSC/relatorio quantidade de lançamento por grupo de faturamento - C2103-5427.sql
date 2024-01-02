----- Relatorio onde é apresentado a quantidade de procedimentos lançados no grupo de faturamento 

select
'INTERNADO'TIPO_CONTA,
rf.cd_convenio,
conv.nm_convenio,
RF.CD_REG_FAT NR_CONTA,
irf.cd_gru_fat,
gf.ds_gru_fat,
count(irf.cd_gru_fat)QTD_LANC_GRU_FAT,
sum(irf.vl_total_conta)VL_TOTAL_GRU_FAT
from
dbamv.reg_fat rf
inner join dbamv.itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join dbamv.convenio conv on conv.cd_convenio = rf.cd_convenio
inner join dbamv.gru_Fat gf on gf.cd_gru_fat = irf.cd_gru_fat
where rf.cd_multi_empresa = 3
and trunc (irf.dt_lancamento) between '01/01/2020' and '31/12/2020'
and irf.sn_pertence_pacote = 'N'
and conv.tp_convenio = 'C'
group by rf.cd_convenio,
conv.nm_convenio,
RF.CD_REG_FAT,
irf.cd_gru_fat,
gf.ds_gru_fat
order by 3
;
select 
'AMBULATORIO'TIPO_CONTA,
itramb.cd_convenio,
conv1.nm_convenio,
itramb.cd_reg_amb NR_CONTA,
itramb.cd_gru_fat,
gf1.ds_gru_fat,
count(itramb.cd_gru_fat)QTD_LANC_GRU_FAT,
sum(itramb.vl_total_conta)VL_TOTAL_GRU_FAT
from
dbamv.reg_amb ramb 
inner join dbamv.itreg_amb itramb on itramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.convenio conv1 on conv1.cd_convenio = itramb.cd_convenio
inner join dbamv.gru_Fat gf1 on gf1.cd_gru_fat = itramb.cd_gru_fat
where ramb.cd_multi_empresa = 3
and itramb.hr_lancamento  between '01/01/2020' and '31/12/2020'
and itramb.sn_pertence_pacote = 'N'
and conv1.tp_convenio = 'C'
group by 
itramb.cd_convenio,
conv1.nm_convenio,
itramb.cd_reg_amb,
itramb.cd_gru_fat,
gf1.ds_gru_fat

order by 3
