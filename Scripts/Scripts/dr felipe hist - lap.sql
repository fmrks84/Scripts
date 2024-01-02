select a.DT_REALIZACAO,
       f.nm_convenio,
       a.CD_AVISO_CIRURGIA,
       c.cd_pro_fat,
       c.ds_cirurgia,
       a.NM_PACIENTE,
       
       d.nm_prestador
       from dbamv.aviso_cirurgia a, 
              dbamv.cirurgia_aviso b,
              dbamv.cirurgia c,
              dbamv.prestador d,
              dbamv.prestador_aviso e,
              dbamv.convenio f
where c.cd_cirurgia in (154,2041,5085,2355,901,5169,154,2041,5085,900,5156)-- Histeroscopia // 2355,901,5169,154,2041,5085,900,5156 -- LAPOROSCOPIA
and a.CD_AVISO_CIRURGIA = b.cd_aviso_cirurgia
and b.cd_aviso_cirurgia = e.cd_aviso_cirurgia
and b.cd_cirurgia = c.cd_cirurgia
and c.cd_cirurgia = e.cd_cirurgia
and d.cd_prestador = e.cd_prestador
and b.cd_convenio = f.cd_convenio
and a.CD_MULTI_EMPRESA = 1
and e.sn_principal = 'S'
and a.TP_SITUACAO = 'R'
and a.DT_REALIZACAO between '01/01/2015' and '31/12/2015'
order by a.DT_REALIZACAO 
