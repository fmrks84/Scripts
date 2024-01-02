select DISTINCT
       A.Cd_Atendimento,
       h.nm_paciente,
       A.CD_AVISO_CIRURGIA,
       f.nm_convenio,
       a.dt_inicio_cirurgia DT_CIRURGIA,
   --    A.DT_REALIZACAO,
       C.CD_CIRURGIA,
       C.DS_CIRURGIA,
     --  C.CD_PRO_FAT,
       D.CD_PRESTADOR,
       E.NM_PRESTADOR
       

from 
dbamv.aviso_cirurgia a 
inner join dbamv.cirurgia_aviso b on b.cd_aviso_cirurgia = a.cd_aviso_cirurgia
inner join dbamv.prestador_aviso d on d.cd_aviso_cirurgia = b.cd_aviso_cirurgia
inner join dbamv.prestador e on e.cd_prestador = D.CD_PRESTADOR
inner join dbamv.cirurgia c on c.cd_cirurgia = b.cd_cirurgia
inner join dbamv.convenio f on f.cd_convenio = b.cd_convenio
inner join dbamv.atendime g on g.cd_atendimento = a.cd_atendimento
inner join dbamv.paciente h on h.cd_paciente = g.cd_paciente
where c.cd_pro_fat in ('31403026','30726077','30713064','30713137',
                       '40811026','30726204','31403034','31403212','40813363')
and D.CD_PRESTADOR IN (1354,849,542,1268)
and a.cd_multi_empresa = 7
and f.tp_convenio = 'C'
and a.dt_inicio_cirurgia between '01/08/2020' and sysdate  --sysdate 
ORDER BY 
          E.NM_PRESTADOR,
          a.dt_inicio_cirurgia

