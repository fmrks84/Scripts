/*select 
cd_atendimento,
cd_reg_fat,
tp_classificacao_conta,
cd_convenio,
case when x is not null then 'N'
     else tp_classificacao_conta
       end tp_classificacao_conta_new
from
(*/
select 
atd.dt_atendimento,
atd.dt_alta,
rf.cd_atendimento,
RF.CD_REG_FAT,
trunc(rf.dt_inicio)dt_inicio,
trunc(rf.dt_final)dt_final,
rf.cd_convenio,
rf.tp_classificacao_conta,
conv.tp_convenio,
case when rf.dt_inicio = rf.dt_inicio 
     and rf.dt_final = rf.dt_final
     and conv.tp_convenio <> 'P'
     then min(rf.cd_reg_fat)
     end x
from 
dbamv.reg_fat rf
inner join dbamv.reg_Fat rfx on rfx.cd_atendimento = rf.cd_atendimento
inner join dbamv.atendime atd on atd.cd_atendimento = rf.cd_atendimento 
inner join dbamv.convenio conv on conv.cd_convenio = rf.cd_convenio 
where  rf.cd_multi_empresa = 7 
and rf.tp_classificacao_conta <> 'C'
and trunc(atd.dt_atendimento) > = '01/04/2024'  
and rf.dt_inicio = rfx.dt_inicio
and rf.dt_final = rfx.dt_final
and rf.cd_reg_fat <> rfx.cd_reg_fat
and rf.cd_atendimento = 6013327         
group by 
atd.dt_atendimento,
atd.dt_alta,
rf.cd_atendimento,
RF.CD_REG_FAT,
rf.dt_inicio,
rf.dt_final,
rf.cd_convenio,
conv.tp_convenio,
rf.tp_classificacao_conta
order by 
rf.cd_atendimento,
rf.dt_inicio
--)

--select * from reg_Fat where cd_atendimento = 6013327
