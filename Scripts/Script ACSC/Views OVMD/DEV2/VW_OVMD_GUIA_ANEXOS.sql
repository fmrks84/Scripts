CREATE OR REPLACE VIEW ENSEMBLE.VW_OVMD_GUIA_ANEXOS AS
SELECT
a.CD_ANEXOS_GUIA,
a.CD_GUIA,
a.TP_DOCUMENTO TP_DOCUMENTO,
a.NM_DOCUMENTO,
a.NM_DOCUMENTO_ANEXO,
UPPER(substr(regexp_substr(a.NM_DOCUMENTO_ANEXO, '\.[^\.]*$'), 2)) EXTENSAO_ANEXO,
a.lo_anexo_guia,
a.DT_EFETIVACAO,
a.NM_USUARIO,
g.cd_atendimento ,
g.CD_AVISO_CIRURGIA,
g.nr_guia,
at.cd_multi_empresa
FROM
dbamv.anexos_guia a,
dbamv.guia g,
dbamv.empresa_convenio at
where g.cd_convenio = at.cd_convenio
and   g.cd_guia = a.cd_guia
and   g.tp_situacao = 'S'
and   g.tp_guia in ('I','O')
and   g.dt_solicitacao >= trunc(sysdate - 7)
--and g.cd_guia = 633652
--and   g.cd_atendimento = 655015
and   at.CD_MULTI_EMPRESA = 7;
