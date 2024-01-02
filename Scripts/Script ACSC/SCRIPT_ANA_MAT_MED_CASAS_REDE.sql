select 
distinct 
casas,
cd_pro_fat,
cd_convenio,
nm_convenio,
cd_produto,
ds_produto,
cd_especie,
ds_especie,
cd_pro_fat,
ds_pro_fat,
cd_gru_pro,
ds_gru_pro,
vl_unitario,
sum(qt_lancamento)qtd,
sum(vl_total)valor,
sn_pertence_pacote
--count(*)

from

(

select 
distinct 
decode (econv.cd_multi_empresa,'3','CSSJ','4','HST','7','HSC','10','HSJ','11','HMRP','25','HCNSC')CASAS,
conv.cd_convenio,
conv.nm_convenio,
pd.cd_produto,
pd.ds_produto,
pd.cd_especie,
esp.ds_especie,
pf.cd_pro_fat,
pf.ds_pro_fat,
gp.cd_gru_pro,
gp.ds_gru_pro,
to_Date(irf.dt_lancamento,'dd/mm/rrrr')dt_lancamento,
irf.qt_lancamento,
irf.vl_unitario,
irf.vl_total_conta vl_total,
irf.sn_pertence_pacote

from 
dbamv.convenio conv 
inner join empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
inner join atendime atd on atd.cd_convenio = conv.cd_convenio and atd.cd_multi_empresa = econv.cd_multi_empresa 
inner join reg_fat rf on rf.cd_atendimento = atd.cd_atendimento and rf.cd_convenio = conv.cd_convenio
AND rf.sn_fechada = 'S' and rf.cd_remessa is not null --and rf.cd_multi_empresa in (3,4,7,10,11,25)
inner join itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat and irf.sn_pertence_pacote = 'N'
inner join pro_fat pf on pf.cd_pro_fat = irf.cd_pro_fat and pf.sn_ativo = 'S' 
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro and gp.cd_gru_pro in (7,8,9,12,15,43,44,71,89,91,92,95,96)
inner join produto pd on pd.cd_produto = pf.cd_pro_fat and pd.sn_movimentacao = 'S'
inner join especie esp on esp.cd_especie = pd.cd_especie
where to_date(irf.dt_lancamento,'DD/MM/RRRR')between to_date('01/11/2022','DD/MM/RRRR') and TO_DATE('30/11/2023','DD/MM/RRRR')
/*and conv.cd_convenio in 
(661,73,377,156,641,7,662,116,
303,308,663,190,5,68,112,152,
189,313,12,80,120,160,194,310,
51,52,53,107,108,149,187,205,
206,281,287,306,48,104,147,185,
204,213,215,216,217,218,13)*/
/*--and atd.cd_multi_empresa = 4 
union all 

select 
distinct
decode (econv1.cd_multi_empresa,'3','CSSJ','4','HST','7','HSC','10','HSJ','11','HMRP','25','HCNSC')CASAS,
conv1.cd_convenio,
conv1.nm_convenio,
pd1.cd_produto,
pd1.ds_produto,
pd1.cd_especie,
esp1.ds_especie,
pf1.cd_pro_fat,
pf1.ds_pro_fat,
gp1.cd_gru_pro,
gp1.ds_gru_pro,
to_Date(iramb.hr_lancamento,'dd/mm/rrrr')dt_lancamento,
iramb.qt_lancamento,
iramb.vl_unitario,
iramb.vl_total_conta vl_total,
iramb.sn_pertence_pacote

from 
dbamv.convenio conv1 
inner join empresa_convenio econv1 on econv1.cd_convenio = conv1.cd_convenio
inner join atendime atd1 on atd1.cd_convenio = conv1.cd_convenio and atd1.cd_multi_empresa = econv1.cd_multi_empresa 
inner join itreg_amb iramb on iramb.cd_atendimento = iramb.cd_atendimento and iramb.cd_convenio = atd1.cd_convenio 
and iramb.sn_pertence_pacote = 'N' and iramb.sn_fechada = 'S'
inner join reg_amb ramb on ramb.cd_reg_amb = iramb.cd_reg_amb and ramb.cd_convenio = iramb.cd_convenio 
and ramb.cd_remessa is not null --and ramb.cd_multi_empresa  in (3,4,7,10,11,25)
inner join pro_fat pf1 on pf1.cd_pro_fat = iramb.cd_pro_fat and pf1.sn_ativo = 'S' 
inner join gru_pro gp1 on gp1.cd_gru_pro = pf1.cd_gru_pro and gp1.cd_gru_pro in (7,8,9,12,15,43,44,71,89,91,92,95,96)
inner join produto pd1 on pd1.cd_produto = pf1.cd_pro_fat and pd1.sn_movimentacao = 'S'
inner join especie esp1 on esp1.cd_especie = pd1.cd_especie
where to_date(iramb.hr_lancamento,'DD/MM/RRRR') between to_date('01/10/2022','DD/MM/RRRR') and TO_DATE('31/10/2023','DD/MM/RRRR')*/
/*and conv1.cd_convenio in 
(661,73,377,156,641,7,662,116,
303,308,663,190,5,68,112,152,
189,313,12,80,120,160,194,310,
51,52,53,107,108,149,187,205,
206,281,287,306,48,104,147,185,
204,213,215,216,217,218,13*/
--and atd1.cd_multi_empresa = 4 
--order by casas,cd_convenio
)where 
cd_convenio in (661,73,377,156,641,7,662,116,
303,308,663,190,5,68,112,152,
189,313,12,80,120,160,194,310,
51,52,53,107,108,149,187,205,
206,281,287,306,48,104,147,185,
204,213,215,216,217,218,13)
--AND cd_pro_fat = '02038738'
group by 
casas,
cd_pro_fat,
cd_convenio,
nm_convenio,
cd_produto,
ds_produto,
cd_especie,
ds_especie,
cd_pro_fat,
ds_pro_fat,
cd_gru_pro,
ds_gru_pro,
vl_unitario,
sn_pertence_pacote

order by casas,cd_convenio,qtd desc 
/*
;

select 
distinct 
casas,
cd_pro_fat,
cd_convenio,
nm_convenio,
cd_produto,
ds_produto,
cd_especie,
ds_especie,
cd_pro_fat,
ds_pro_fat,
cd_gru_pro,
ds_gru_pro,
vl_unitario,
sum(qt_lancamento)qtd,
sum(vl_total)valor,
sn_pertence_pacote
from
(
select 
distinct
decode (econv1.cd_multi_empresa,'3','CSSJ','4','HST','7','HSC','10','HSJ','11','HMRP','25','HCNSC')CASAS,
conv1.cd_convenio,
conv1.nm_convenio,
pd1.cd_produto,
pd1.ds_produto,
pd1.cd_especie,
esp1.ds_especie,
pf1.cd_pro_fat,
pf1.ds_pro_fat,
gp1.cd_gru_pro,
gp1.ds_gru_pro,
to_Date(iramb.hr_lancamento,'dd/mm/rrrr')dt_lancamento,
iramb.qt_lancamento,
iramb.vl_unitario,
iramb.vl_total_conta vl_total,
iramb.sn_pertence_pacote

from 
dbamv.convenio conv1 
inner join empresa_convenio econv1 on econv1.cd_convenio = conv1.cd_convenio
inner join atendime atd1 on atd1.cd_convenio = conv1.cd_convenio and atd1.cd_multi_empresa = econv1.cd_multi_empresa 
inner join itreg_amb iramb on iramb.cd_atendimento = iramb.cd_atendimento and iramb.cd_convenio = atd1.cd_convenio 
and iramb.sn_pertence_pacote = 'N' and iramb.sn_fechada = 'S'
inner join reg_amb ramb on ramb.cd_reg_amb = iramb.cd_reg_amb and ramb.cd_convenio = iramb.cd_convenio 
and ramb.cd_remessa is not null --and ramb.cd_multi_empresa  in (3,4,7,10,11,25)
inner join pro_fat pf1 on pf1.cd_pro_fat = iramb.cd_pro_fat and pf1.sn_ativo = 'S' 
inner join gru_pro gp1 on gp1.cd_gru_pro = pf1.cd_gru_pro and gp1.cd_gru_pro in (7,8,9,12,15,43,44,71,89,91,92,95,96)
inner join produto pd1 on pd1.cd_produto = pf1.cd_pro_fat and pd1.sn_movimentacao = 'S'
inner join especie esp1 on esp1.cd_especie = pd1.cd_especie
where to_date(iramb.hr_lancamento,'DD/MM/RRRR') between to_date('01/10/2022','DD/MM/RRRR') and TO_DATE('31/10/2023','DD/MM/RRRR')
\*and conv1.cd_convenio in 
(661,73,377,156,641,7,662,116,
303,308,663,190,5,68,112,152,
189,313,12,80,120,160,194,310,
51,52,53,107,108,149,187,205,
206,281,287,306,48,104,147,185,
204,213,215,216,217,218,13*\
--and atd1.cd_multi_empresa = 4 
--order by casas,cd_convenio
)
where 
cd_convenio in (661,73,377,156,641,7,662,116,
303,308,663,190,5,68,112,152,
189,313,12,80,120,160,194,310,
51,52,53,107,108,149,187,205,
206,281,287,306,48,104,147,185,
204,213,215,216,217,218,13)
--AND cd_pro_fat = '02038738'
group by 
casas,
cd_pro_fat,
cd_convenio,
nm_convenio,
cd_produto,
ds_produto,
cd_especie,
ds_especie,
cd_pro_fat,
ds_pro_fat,
cd_gru_pro,
ds_gru_pro,
vl_unitario,
sn_pertence_pacote
*/
