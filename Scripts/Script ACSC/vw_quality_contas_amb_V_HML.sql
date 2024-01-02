select distinct m.ds_multi_empresa, 
                pc.nm_paciente,
                i.cd_atendimento, 
                r.cd_reg_amb conta, 
                r.cd_convenio, 
                i.sn_fechada status,
              --  r.sn_fechada status, 
                r.cd_remessa, 
                ag.cd_agrupamento,
                ag.ds_agrupamento, 
                sysdate dt_entrega, 
                (sysdate+30) dt_pagamento
  from dbamv.reg_amb          r,
       dbamv.itreg_amb        i,
       dbamv.atendime         a,
       dbamv.protocolo_doc    p,
       dbamv.it_protocolo_doc it,
       dbamv.agrupamento ag,
       dbamv.itagrupamento ia,
       dbamv.multi_empresas m,
       dbamv.paciente pc 
 where r.cd_reg_amb = i.cd_reg_amb
   and i.cd_atendimento = a.cd_atendimento
   and a.cd_Atendimento = it.cd_atendimento
   and it.cd_protocolo_doc = p.cd_protocolo_doc
   and a.cd_convenio = ia.cd_convenio
   and a.cd_ori_ate = ia.cd_ori_ate
   and ia.cd_agrupamento = ag.cd_agrupamento
   and r.cd_multi_empresa = m.cd_multi_empresa
   and pc.cd_paciente = a.cd_paciente
   and r.cd_convenio in (7, 641) -- (7 - bradesco saude , 641 - bradesco operadora de planos s/a)
   and r.cd_remessa is null
 -- and i.sn_fechada = 'N'
   and r.dt_lancamento <= (sysdate - 1)
   and p.cd_setor_destino = 51 -- setor: faturamento 
   and ag.cd_agrupamento not in (1,2)
   and r.vl_filme_conta <> '0'
   order by pc.nm_paciente


select * from dbamv.reg_amb where cd_Reg_amb = 519767
select * from dbamv.itreg_amb where cd_Reg_amb = 519767
select * from dbamv.canc_itreg_amb where cd_reg_amb = 519767
