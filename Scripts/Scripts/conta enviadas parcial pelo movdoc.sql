select 
       A.CD_ATENDIMENTO,
       f.nm_paciente,
       e.cd_protocolo_doc,
       e.cd_reg_fat,
       a.vl_total_conta,
       b.dt_alta,
       d.cd_setor,
       d.dt_envio,
       d.cd_setor_destino,
       trunc (d.dt_envio - b.dt_alta ) Total_Dias
       
       
       
       
       
from          dbamv.reg_Fat       a,
              dbamv.atendime      b,
              dbamv.convenio      c,
              dbamv.protocolo_doc d,
              dbamv.it_protocolo_doc e,
              dbamv.paciente f,
              dbamv.setor g
             
              
where b.CD_MULTI_EMPRESA = '1'
and e.cd_documento_prot = 50
and a.cd_multi_empresa = b.CD_MULTI_EMPRESA
and a.cd_atendimento = b.CD_ATENDIMENTO
and a.cd_convenio = c.cd_convenio
and d.cd_protocolo_doc = e.cd_protocolo_doc
and a.cd_reg_fat = e.cd_reg_fat
and b.CD_PACIENTE = f.cd_paciente
and a.sn_fechada = 'S'
--and a.cd_remessa is not null
and b.DT_ATENDIMENTO between '02/04/2016' and '09/05/2016'
and a.cd_convenio = 10
order by 2
