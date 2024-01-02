select cd_atendimento_mae, sang_tp_mae, sang_rh_mae, sang_ci_mae,
       cd_atendimento_filho, sang_tp_rn,  sang_rh_rn,  sang_cd_rn
from dbamv.inf_recem_nascido
where cd_atendimento_mae = 261193
order by cd_atendimento_mae  


Select     Sang_tp_mae,
           Sang_rh_mae, 
           Sang_ci_mae
From Dbamv.Inf_Recem_Nascido
Where Cd_Atendimento_mae = 261193


Select     Sang_tp_rn,
           Sang_rh_rn, 
           Sang_cd_rn
From Dbamv.Inf_Recem_Nascido
Where Cd_Atendimento_filho = 261273

