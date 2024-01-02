/*CREATE OR REPLACE VIEW dbamv.vw_quality_contas_amb
(ds_multi_empresa,
 cd_atendimento,
 conta,
 cd_convenio,
 status,
 cd_remessa,
 cd_agrupamento,
 dt_entrega,
 dt_pagamento
) 
as*/
select distinct m.ds_multi_empresa, 
                i.cd_atendimento, 
                r.cd_reg_amb conta, 
                r.cd_convenio, 
                r.sn_fechada status, 
                r.cd_remessa, 
                ag.cd_agrupamento, 
                sysdate dt_entrega, 
                (sysdate+30) dt_pagamento
  from dbamv.reg_amb          r,
       dbamv.itreg_amb        i,
       dbamv.atendime         a,
       dbamv.protocolo_doc    p,
       dbamv.it_protocolo_doc it,
       dbamv.agrupamento ag,
       dbamv.itagrupamento ia,
       dbamv.multi_empresas m
 where r.cd_reg_amb = i.cd_reg_amb
   and i.cd_atendimento = a.cd_atendimento
   and a.cd_Atendimento = it.cd_atendimento
   and it.cd_protocolo_doc = p.cd_protocolo_doc
   and a.cd_convenio = ia.cd_convenio
   and a.cd_ori_ate = ia.cd_ori_ate
   and ia.cd_agrupamento = ag.cd_agrupamento
   and r.cd_multi_empresa = m.cd_multi_empresa
   and r.cd_convenio in (7, 641) -- (7 - bradesco saude , 641 - bradesco operadora de planos s/a)
  and r.cd_remessa is null
 --and r.sn_fechada = 'N'
   and r.cd_remessa is null
  -- and r.dt_lancamento <= (sysdate - 1)
   and p.cd_setor_destino = 51 -- setor: faturamento 
   and ag.cd_agrupamento not in (1,2)
   and r.cd_reg_amb = 2030783
 --  and i.Cd_Atendimento = 198715  -- (1- Contas de internados - Adulto HSC) , (2 - Contas Internados - Pediatra - HSC)
/*;
   
GRANT SELECT ON dbamv.vw_quality_contas_amb TO dbamv;
GRANT SELECT ON dbamv.vw_quality_contas_amb TO acsc_afonso_Faria;
GRANT SELECT ON dbamv.vw_quality_contas_amb TO rpa.fat; -- usuário quality 
GRANT SELECT ON dbamv.vw_quality_contas_amb TO mvintegra;
GRANT SELECT ON dbamv.vw_quality_contas_amb TO mv2000;
GRANT SELECT ON dbamv.vw_quality_contas_amb TO dbaps;  
commit;
*/




