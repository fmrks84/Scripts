select 
*
from
(
select 
'INTERNADO'Tipo_conta,
atd.cd_atendimento,
rf.cd_reg_fat conta,
conv.cd_convenio,
conv.nm_convenio,
pd.cd_produto,
pd.ds_produto,
irf.cd_pro_fat,
pf.ds_pro_fat,
gp.cd_gru_pro,
gp.ds_gru_pro,
TO_DATE(IRF.DT_LANCAMENTO,'DD/MM/RRRR')DT_LANCAMENTO,
irf.qt_lancamento,
irf.vl_unitario,
irf.vl_total_conta
from 
dbamv.gru_pro gp 
inner join pro_Fat pf on pf.cd_gru_pro = gp.cd_gru_pro
inner join produto pd on pd.cd_pro_fat = pf.cd_pro_fat
inner join empresa_produto epd on epd.cd_produto = pd.cd_produto and epd.cd_multi_empresa = 4 
inner join itreg_fat irf on irf.cd_pro_fat = pf.cd_pro_fat and irf.sn_pertence_pacote = 'N'
inner join reg_fat rf on rf.cd_reg_fat = irf.cd_reg_fat 
inner join atendime atd on atd.cd_atendimento = rf.cd_atendimento and atd.cd_multi_empresa = 4 
inner join convenio conv on conv.cd_convenio = atd.cd_convenio and conv.sn_ativo = 'S' 
and conv.tp_convenio in ('C')
WHERE (to_date(irf.dt_lancamento, 'dd/mm/rrrr') between '01/01/2023' and '01/11/2023'
AND(gp.ds_gru_pro LIKE '%MATERI%'OR gp.ds_gru_pro LIKE '%MEDICA%'OR gp.ds_gru_pro LIKE '%ORTESES%'))

union all 

select 
'AMB/EXT/URG'Tipo_conta,
atd1.cd_atendimento,
ramb.cd_reg_amb conta,
conv1.cd_convenio,
conv1.nm_convenio,
pd1.cd_produto,
pd1.ds_produto,
iramb.cd_pro_fat,
pf1.ds_pro_fat,
gp1.cd_gru_pro,
gp1.ds_gru_pro,
TO_DATE(iramb.hr_lancamento,'DD/MM/RRRR')DT_LANCAMENTO,
iramb.qt_lancamento,
iramb.vl_unitario,
iramb.vl_total_conta
from 
dbamv.gru_pro gp1
inner join pro_Fat pf1 on pf1.cd_gru_pro = gp1.cd_gru_pro
inner join produto pd1 on pd1.cd_pro_fat = pf1.cd_pro_fat
inner join empresa_produto epd1 on epd1.cd_produto = pd1.cd_produto and epd1.cd_multi_empresa = 4 
inner join itreg_amb iramb on iramb.cd_pro_fat = pf1.cd_pro_fat and iramb.sn_pertence_pacote = 'N'
inner join reg_amb ramb on ramb.cd_reg_amb = iramb.cd_reg_amb
inner join atendime atd1 on atd1.cd_atendimento = iramb.cd_atendimento and atd1.cd_multi_empresa = 4 
inner join convenio conv1 on conv1.cd_convenio = atd1.cd_convenio and conv1.sn_ativo = 'S' 
and conv1.tp_convenio in ('C')

WHERE (to_date(iramb.hr_lancamento, 'dd/mm/rrrr') between '01/01/2023' and '01/11/2023'
AND(gp1.ds_gru_pro LIKE '%MATERI%'OR gp1.ds_gru_pro LIKE '%MEDICA%'OR gp1.ds_gru_pro LIKE '%ORTESES%'))

) where 1 = 1 

order by dt_lancamento,cd_convenio , conta


