select         a.cd_aviso_cirurgia,
               a.ds_cirurgia,
               a.amb,
               a.dt_inicio_age_cir,
               a.nm_paciente,
               b.DS_IDADE,
               a.nm_convenio,
               a.anestesista,
               a.nm_prestador,
               a.cd_cen_cir,
               a.ds_cen_cir,
               a.observacao,
               a.dias,
               a.mail,
               a.status,
               a.data_log,
               a.horario_cadastro,
               a.data_cadastro,
               a.nm_usuario        
from           dbasms.mail_cirurgia a ,
               dbamv.aviso_cirurgia b
where b.DS_IDADE < = 10 --(a.nm_paciente like 'RN%' OR a.nm_paciente like 'AD %')
and a.cd_aviso_cirurgia = b.cd_aviso_cirurgia
and b.NM_PACIENTE = a.nm_paciente
and b.TP_NATUREZA not in ('C')
and b.TP_SITUACAO not in ('C')
and trunc(a.dt_inicio_age_cir) > = '01/12/2017'
and a.cd_cen_cir in (1,4)
order by a.nm_paciente
 
