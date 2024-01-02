with exames as (
select 
pd.cd_ped_rx,
rx.cd_exa_rx,
rx.ds_exa_rx ds_exame,
rx.exa_rx_cd_pro_fat cd_pro_Fat
from 
exa_rx rx 
inner join itped_rx ipx on ipx.cd_exa_rx = rx.cd_exa_rx
inner join ped_rx pd on pd.cd_ped_rx = ipx.cd_ped_rx
where rx.cd_exa_rx in ('108','1082','1144','1145','1146','1161',
'1163','1164','1166','1265','1267','1268','1269','1270','1385','1388','1696','1697',
'1718','1964','2120','2139','2188','2259','2267','2453','2516','2574','2729',
'2730','2734','2746','2758','2759','2761','2762','2763','2764','2765','2766',
'2767','2768','2769','2770','2771','2772','2773','2774','2775','2776','2777',
'2778','2779','2780','2781','2782','2783','2784','2785','2786','2787','2789',
'2790','2791','2792','2793','2794','2795','2796','2797','2798','2799','2800',
'2801','2802','2803','2804','2805','2806','2807','2813')
)

select 
*
from
(
select 

convenio,
plano,
ds_exame,
mes,
qtd,
ticket_medio,
ano,
total

from 
(


select 
sum(qtd)qtd,
convenio,
plano,
ds_exame,
mes,
ano,
--total
sum(total)total,
round((sum(total) / sum(qtd)),+2)ticket_medio
from 
(
select 
--rf.cd_reg_fat conta,
rf.cd_convenio||' - '||conv.nm_convenio convenio,
rf.cd_con_pla||' - '||cpla.ds_con_pla plano,
ex.cd_exa_rx||' - '||ex.ds_exame ds_exame,
to_char(irf.hr_lancamento,'mm')mes,
to_char(irf.hr_lancamento,'rrrr')ano,
irf.qt_lancamento qtd,
irf.vl_total_conta total
--sum(irf.vl_total_conta)TOTAL

from 
dbamv.reg_Fat rf 
inner join itreg_Fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join exames ex on irf.cd_mvto = ex.cd_ped_rx
inner join convenio conv on conv.cd_convenio = rf.cd_convenio
inner join empresa_convenio emp on emp.cd_convenio = rf.cd_convenio
inner join con_pla cpla on cpla.cd_convenio = rf.cd_convenio and cpla.cd_con_pla = rf.cd_con_pla
where to_date(irf.hr_lancamento,'dd/mm/rrrr') between '01/01/2022' and '31/05/2023'
and rf.cd_multi_empresa = 7
and irf.cd_gru_fat not in (11)
and irf.tp_mvto = 'Imagem'
and conv.tp_convenio = 'C'
AND rf.sn_fechada = 'S'
and irf.sn_pertence_pacote = 'N'
--and rf.cd_convenio = 8
--and rf.cd_con_pla = 1
--and ex.cd_exa_rx = 1164

/*group by 
rf.cd_convenio,
rf.cd_con_pla,
cpla.ds_con_pla,
conv.nm_convenio,
ex.cd_exa_rx,
ex.ds_exame,
irf.hr_lancamento*/

union all 

select 
--ramb.cd_reg_amb conta,
ramb.cd_convenio||' - '||conv1.nm_convenio convenio,
iramb.cd_con_pla||' - '||cplax.ds_con_pla plano,
rx1.cd_exa_rx||' - '||rx1.ds_exame ds_exame,
to_char(iramb.hr_lancamento,'mm')mes,
to_char(iramb.hr_lancamento,'rrrr')ano,
iramb.qt_lancamento qtd,
iramb.vl_total_conta total
--sum(iramb.vl_total_conta)TOTAL
from 
dbamv.reg_amb ramb 
inner join itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join exames rx1 on rx1.cd_ped_rx = iramb.cd_mvto
inner join convenio conv1 on conv1.cd_convenio = ramb.cd_convenio
inner join empresa_convenio empx on empx.cd_convenio = ramb.cd_convenio
inner join con_pla cplax on cplax.cd_convenio = ramb.cd_convenio and cplax.cd_con_pla = iramb.cd_con_pla
where to_date(iramb.hr_lancamento,'dd/mm/rrrr') between '01/01/2022' and '31/05/2023' 
and iramb.sn_pertence_pacote = 'N'
and iramb.cd_gru_fat not in (11)
and iramb.tp_mvto  = 'Imagem'
and conv1.tp_convenio = 'C'
and iramb.sn_fechada = 'S'
and ramb.cd_multi_empresa = 7
--AND ramb.cd_convenio = 8
--and iramb.cd_con_pla = 1
--and rx1.cd_exa_rx = 1164
/*group by
ramb.cd_convenio,
iramb.cd_con_pla,
cplax.ds_con_pla,
conv1.nm_convenio,
rx1.cd_exa_rx,
rx1.ds_exame,
iramb.hr_lancamento*/
order by convenio, ds_exame
)
group by convenio,
plano,
ds_exame,
mes,
ano
order by convenio,ds_exame,mes

)
)
pivot
 (SUM(total)
 for (mes) in (
                  '01'AS JANEIRO,
                  '02'AS FEVEREIRO,
                  '03'AS MARÇO,
                  '04'AS ABRIL,
                  '05'AS MAIO,
                  '06'AS JUNHO,
                  '07'AS JULHO,
                  '08'AS AGOSTO,
                  '09'AS SETEMBRO,
                  '10'AS OUTUBRO,
                  '11'AS NOVEMBRO,
                  '12'AS DEZEMBRO)
)
ORDER BY ANO,CONVENIO,DS_EXAME
;
/*----select * from empresa_convenio where cd_convenio = 100
select * from exa_Rx where cd_exa_Rx = 1164

;
select * from itreg_Fat where cd_reg_fat = 451149 and cd_pro_fat in (40809161,98320025)*/
