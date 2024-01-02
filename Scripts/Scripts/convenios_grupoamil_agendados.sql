select a.CD_AVISO_CIRURGIA ,a.NM_PACIENTE, a.DT_PREV_INTER,a.CD_CEN_CIR, c.cd_convenio , c.cd_con_pla , a.TP_SITUACAO , a.CD_MULTI_EMPRESA
from dbamv.aviso_cirurgia a, dbamv.cirurgia_aviso c , dbamv.age_cir b
where c.cd_convenio in (21,39,321,354,394)
and a.CD_AVISO_CIRURGIA = c.cd_aviso_cirurgia
and c.cd_aviso_cirurgia = b.cd_aviso_cirurgia
--and a.CD_MULTI_EMPRESA = '1'
and a.DT_PREV_INTER between '06/08/2015' and '30/09/2015'
order by 3


-- Tipo G = AGENDADA
-- Tipo R = REALIZADA
-- Tipo A = EM ABERTO
-- Tipo C = CANCELADA
