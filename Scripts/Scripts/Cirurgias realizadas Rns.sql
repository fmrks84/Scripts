select a.cd_aviso_cirurgia,
       d.CD_ATENDIMENTO,
       e.nm_paciente,
       B.DS_CIRURGIA,
       decode (b.tp_cirurgia ,'M','MEDIO','P','PEQUENA','G','GRANDE','E','ESPECIAL')PORTE_CIRURGIA,
       c.DT_REALIZACAO
       from dbamv.cirurgia_aviso a
inner join dbamv.cirurgia b on a.cd_cirurgia = b.cd_cirurgia
inner join dbamv.aviso_cirurgia c on c.CD_AVISO_CIRURGIA = a.cd_aviso_cirurgia
inner join dbamv.atendime d on d.CD_ATENDIMENTO = c.CD_ATENDIMENTO
inner join dbamv.paciente e on e.cd_paciente = d.CD_PACIENTE
where Trunc (c.dt_realizacao) between '01/01/2017' and '17/05/2017'
  and c.TP_SITUACAO = 'R'
-- a.CD_AVISO_CIRURGIA = 399498
and (e.nm_paciente LIKE 'RN %' OR e.nm_paciente LIKE 'AD %')
order by c.DT_REALIZACAO
