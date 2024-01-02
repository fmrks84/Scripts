select c.nm_prestador,
       a.cd_repasse,
       a.DT_REPASSE,
       d.cd_con_pag,
       b.vl_repasse,
       g.vl_pago,
       g.dt_pagamento
       

from dbamv.repasse a,
              dbamv.repasse_prestador b,
              dbamv.prestador c,
              dbamv.repasse_prestador_con_pag d,
              dbamv.con_pag e,
              dbamv.itcon_pag f,
              dbamv.pagcon_pag g
where b.cd_prestador = 65
and a.cd_repasse = b.cd_repasse
and b.cd_prestador = c.cd_prestador 
and d.cd_repasse = a.CD_REPASSE
and b.cd_repasse = d.cd_repasse
and d.cd_prestador = b.cd_prestador
and e.cd_con_pag = f.cd_con_pag
and f.cd_itcon_pag = g.cd_itcon_pag
and e.cd_con_pag = d.cd_con_pag
order by a.CD_REPASSE ;

--- 
/*select a.cd_con_pag , 
       c.dt_pagamento, 
       c.vl_pago , 
       c.ds_pagcon_pag 
       from   dbamv.con_pag a , 
              dbamv.itcon_pag b,
              dbamv.pagcon_pag c 
          
           
where 1 = 1 
and a.cd_con_pag = b.cd_con_pag
and b.cd_itcon_pag = c.cd_itcon_pag
and a.cd_fornecedor = 630
order by  c.dt_pagamento*/


----- PRESCRITAS 

select a.cd_atendimento,
       c.DT_ATENDIMENTO,
       a.cd_pre_med,
       a.dt_pre_med,
       c.CD_MULTI_EMPRESA,
       count(*) 
        from dbamv.pre_med a,
              dbamv.itpre_med b,
              dbamv.atendime c,
              dbamv.paciente d
where 1 = 1
and a.cd_pre_med = b.cd_pre_med
and a.cd_atendimento = c.cd_atendimento
and c.cd_paciente = d.cd_paciente
and a.cd_prestador = b.cd_prestador
and b.sn_cancelado = 'N'
and b.cd_prestador = 65
group by 
      a.cd_atendimento,
      c.DT_ATENDIMENTO,
      a.cd_pre_med,
      a.dt_pre_med,
      c.CD_MULTI_EMPRESA
order by c.DT_ATENDIMENTO  

----------- prescrição com nr repasse 

select distinct (a.cd_atendimento) ATENDIMENTO,
       d.nm_paciente PACIENTE,
       c.dt_Atendimento DATA_ATENDIMENTO,
       e.cd_reg_fat CONTA,
       a.cd_pre_med NR_PRESCRICAO,
       a.dt_pre_med DATA_PRESCRICAO ,
       DECODE (c.CD_MULTI_EMPRESA,'1','SANTA JOANA','2','PROMATRE' )EMPRESA,
       i.cd_repasse 
      
      
        from dbamv.pre_med a,
              dbamv.itpre_med b,
              dbamv.atendime c,
              dbamv.paciente d,
              dbamv.reg_fat e,
              dbamv.itreg_fat f,
              dbamv.repasse h,
              dbamv.it_repasse i,
              dbamv.repasse_prestador_con_pag j
             
where 1 = 1
and a.cd_pre_med = b.cd_pre_med
and c.cd_paciente = d.cd_paciente
and a.cd_atendimento = c.cd_atendimento
and c.cd_atendimento = e.cd_atendimento
and a.cd_prestador = b.cd_prestador
and b.cd_prestador = f.cd_prestador
and f.cd_prestador = i.cd_prestador 
and i.cd_prestador = j.cd_prestador
and j.cd_repasse = h.CD_REPASSE
and h.cd_repasse = i.cd_repasse
and e.cd_reg_fat = f.cd_conta_pai
and f.cd_conta_pai = i.cd_reg_fat
--and a.cd_pre_med = f.cd_mvto
--and c.cd_multi_empresa = f.cd_multi_empresa
and b.cd_prestador = 65

order by a.cd_atendimento, 
         e.cd_reg_fat, 
         a.dt_pre_med
