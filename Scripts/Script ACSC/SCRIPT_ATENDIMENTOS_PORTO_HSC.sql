with unimed as (
select 
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
spla.cd_sub_plano,
spla.ds_sub_plano
from 
dbamv.convenio conv 
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio
inner join dbamv.sub_plano spla on spla.cd_convenio = conv.cd_convenio
and spla.cd_con_pla = cpla.cd_con_pla
where conv.cd_convenio = 53
and cpla.cd_con_pla = 20
and spla.cd_sub_plano in (07)
union all 
select 
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
spla.cd_sub_plano,
spla.ds_sub_plano
from 
dbamv.convenio conv 
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio
inner join dbamv.sub_plano spla on spla.cd_convenio = conv.cd_convenio
and spla.cd_con_pla = cpla.cd_con_pla
where conv.cd_convenio = 53
and cpla.cd_con_pla = 2
and spla.cd_sub_plano in (06)
union all
select 
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
spla.cd_sub_plano,
spla.ds_sub_plano
from 
dbamv.convenio conv 
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio
inner join dbamv.sub_plano spla on spla.cd_convenio = conv.cd_convenio
and spla.cd_con_pla = cpla.cd_con_pla
where conv.cd_convenio = 53
and cpla.cd_con_pla = 5
and spla.cd_sub_plano in (9)
--order by cd_con_pla , cd_sub_plano
union all
select 
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
spla.cd_sub_plano,
spla.ds_sub_plano
from 
dbamv.convenio conv 
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio
inner join dbamv.sub_plano spla on spla.cd_convenio = conv.cd_convenio
and spla.cd_con_pla = cpla.cd_con_pla
where conv.cd_convenio = 53
and cpla.cd_con_pla = 129
and spla.cd_sub_plano in (1,2,3,4,5,6)
--order by cd_con_pla , cd_sub_plano
union all
select 
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
spla.cd_sub_plano,
spla.ds_sub_plano
from 
dbamv.convenio conv 
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio
inner join dbamv.sub_plano spla on spla.cd_convenio = conv.cd_convenio
and spla.cd_con_pla = cpla.cd_con_pla
where conv.cd_convenio = 53
and cpla.cd_con_pla = 132
and spla.cd_sub_plano in (1)
--order by cd_con_pla , cd_sub_plano
union all
select 
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
spla.cd_sub_plano,
spla.ds_sub_plano
from 
dbamv.convenio conv 
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio
inner join dbamv.sub_plano spla on spla.cd_convenio = conv.cd_convenio
and spla.cd_con_pla = cpla.cd_con_pla
where conv.cd_convenio = 53
and cpla.cd_con_pla = 133
and spla.cd_sub_plano in (1)
order by cd_con_pla , cd_sub_plano

)

select 
decode (atd.tp_atendimento,'I','INTERNADO')TP_ATENDIMENTO,
atd.cd_atendimento,
prt.nm_convenio,
prt.ds_con_pla,
prt.ds_sub_plano,
pc.nm_paciente,
atd.dt_atendimento,
rf.cd_reg_fat conta,
rf.vl_total_conta,
rf.sn_fechada
from 
dbamv.atendime atd
inner join dbamv.reg_fat rf on rf.cd_atendimento = atd.cd_atendimento 
inner join dbamv.paciente pc on pc.cd_paciente = atd.cd_paciente
inner join unimed prt on prt.cd_convenio = atd.cd_convenio
and prt.cd_con_pla = rf.cd_con_pla
and prt.cd_sub_plano = atd.Cd_Sub_Plano
where atd.dt_atendimento between '01/03/2023' and '31/12/2023'

union all 

select 
distinct
decode (atdx.tp_atendimento,'U','URGENCIA','A','AMBULATORIO','E','EXTERNO')TP_ATENDIMENTO,
atdx.cd_atendimento,
prt.nm_convenio,
prt.ds_con_pla,
prt.ds_sub_plano,
pcx.nm_paciente,
atdx.dt_atendimento,
ramb.cd_reg_amb conta,
ramb.vl_total_conta,
iramb.sn_fechada
from 
dbamv.atendime atdx
inner join dbamv.itreg_amb iramb on iramb.cd_atendimento = atdx.cd_atendimento
and iramb.cd_convenio = atdx.cd_convenio 
and iramb.cd_con_pla = atdx.cd_con_pla
inner join dbamv.reg_Amb ramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.paciente pcx on pcx.cd_paciente = atdx.cd_paciente
inner join unimed prt on prt.cd_convenio = atdx.cd_convenio
and prt.cd_con_pla = iramb.cd_con_pla
and prt.cd_sub_plano = atdx.Cd_Sub_Plano
where atdx.dt_atendimento between '01/03/2023' and '31/12/2023'
order by tp_atendimento, cd_atendimento
