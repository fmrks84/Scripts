create or replace view hmsj_vdic_rel_rem_senha as
(select distinct
       a.cd_reg_fat,
       a.Cd_Atendimento, 
       b.nm_paciente,
       c.nr_guia,
       b.cd_senha,
       a.dt_inicio, 
       a.dt_final , 
       a.dt_fechamento , 
       a.vl_total_conta
       
from dbamv.reg_Fat a ,
      dbamv.tiss_guia b,
      dbamv.guia c
where a.cd_remessa = 83715
and a.cd_atendimento = b.Cd_Atendimento
and b.cd_senha = c.cd_senha
and a.vl_total_conta is not null
order by 3);



