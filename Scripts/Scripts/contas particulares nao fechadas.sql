select distinct
       decode (A.CD_MULTI_EMPRESA, '1','SANTA JOANA','2','PROMATRE','3','CD SANTA JOANA')EMPRESA,
       d.CD_ATENDIMENTO,
       a.cd_reg_fat,
       a.cd_convenio,
       a.cd_con_pla,
       decode (a.sn_fechada,'S','SIM','N','NÃO')FECHADA,
       d.DT_ATENDIMENTO,
       d.DT_ALTA,
       TO_CHAR (D.DT_ALTA - D.DT_ATENDIMENTO)DIAS,
       d.TP_ATENDIMENTO,
       b.cd_paciente,
       b.nm_paciente,
       sum (e.vl_total_conta),
       A.NM_USUARIO_FECHOU
  
from  
      dbamv.reg_fat   a,
      dbamv.paciente  b,
      dbamv.convenio  c,
      dbamv.atendime  d,
      dbamv.itreg_fat e
     
     
where 1=1

and   A.cd_convenio = C.CD_CONVENIO
and   a.cd_atendimento = d.CD_ATENDIMENTO
and   d.CD_PACIENTE = b.cd_paciente
and   a.cd_reg_fat = e.cd_reg_fat
and   a.sn_fechada = 'N'
and   C.CD_CONVENIO IN (352,378,379)
and   e.sn_pertence_pacote = 'N'
and   a.cd_reg_fat = 1055299
and   a.cd_multi_empresa = 1
--and   d.DT_ALTA between '01/01/2015' and '31/12/2015'

group by  

      A.CD_MULTI_EMPRESA,
      d.CD_ATENDIMENTO,
      a.cd_reg_fat,
      a.cd_convenio,
      a.cd_con_pla,
      a.sn_fechada,
      d.DT_ATENDIMENTO,
      d.DT_ALTA,
      d.TP_ATENDIMENTO,
      b.cd_paciente,
      b.nm_paciente,
      A.NM_USUARIO_FECHOU

order by   
      b.nm_paciente 
    


              
