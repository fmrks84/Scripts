select DISTINCT 
      (CASE WHEN b.CD_AVISO_CIRURGIA IS NOT NULL THEN
       1 ELSE
       0 END) TOTAL,
      a.DT_ATENDIMENTO,
       a.CD_ATENDIMENTO ,
       g.nm_paciente,
       decode (A.CD_PRESTADOR,'7926','SERVICO VANGUARDA',
                              '9257','SERVIÇO VANGUARDA 2',
                              '9812','SERVIÇO VANGUARDA 3')PREST_INTERN,
       b.CD_AVISO_CIRURGIA,
       b.DT_REALIZACAO,
       d.ds_cirurgia ,
       f.cd_prestador,
       e.nm_prestador Prest_Aviso
             
from          dbamv.atendime a,
              dbamv.aviso_cirurgia b,
              dbamv.cirurgia_aviso c,
              dbamv.cirurgia d,
              dbamv.prestador e,
              dbamv.prestador_aviso f,
              dbamv.paciente g
                         
where a.CD_PRESTADOR in (7926,9257,9812)
and a.CD_ATENDIMENTO = b.CD_ATENDIMENTO
and b.CD_AVISO_CIRURGIA = c.cd_aviso_cirurgia
and d.cd_cirurgia = c.cd_cirurgia
and e.cd_prestador = f.cd_prestador--a.CD_PRESTADOR 
and f.cd_aviso_cirurgia = c.cd_aviso_cirurgia
and a.CD_PACIENTE = g.cd_paciente 
and b.CD_CEN_CIR = 1
and b.TP_SITUACAO NOT IN ('C')
--and f.sn_principal = 'S'
and f.cd_ati_med = '01'
and a.DT_ATENDIMENTO between '01/01/2016' and '31/12/2016'
order by a.DT_ATENDIMENTO
