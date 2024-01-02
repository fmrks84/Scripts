--- VALORES GERADOS NO XML

select g.nm_paciente ,
       g.nm_prestador_exe, 
       g.cd_reg_fat,
       g.cd_reg_amb ,
       g.vl_tot_geral , 
       g.vl_total_geral_hono 
from dbamv.tiss_guia g where g.cd_remessa in (86307) order by 1 --for update

------------- CONTAS HOSPITALARES (INTERNAÇÃO)--------

select a.dt_inicio,
       a.dt_final,
       a.cd_reg_fat,
       a.cd_atendimento,         
       a.vl_total_conta
       
              from dbamv.reg_fat a, 
              dbamv.remessa_fatura c,
              dbamv.fatura d
              
              
              
where c.cd_remessa = 86305
and a.cd_remessa = c.cd_remessa
and c.cd_fatura = d.CD_FATURA

------------- CONTAS AMBULATORIO (URGENCIA)

select a1.dt_lancamento,
       a1.dt_lancamento_final,
       a1.cd_reg_amb,
       a1.vl_total_conta
     
from dbamv.reg_amb a1,
     dbamv.remessa_fatura b1,
     dbamv.fatura c1
where b1.cd_remessa = 86400
and a1.cd_remessa = b1.cd_remessa
and b1.cd_fatura = c1.CD_FATURA

