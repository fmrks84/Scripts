select a.cd_atendimento,
       a.id,
       a.id_pai,
       a.nr_guia,
       a.cd_senha,
       a.nm_xml,
       a.nm_prestador_contratado,
       a.vl_total_geral_hono,
       a.vl_tot_geral
from dbamv.tiss_guia a where a.cd_atendimento = 1368793

--NM_XML guiaHonorarioIndividual - (NM_PRESTADOR_CONTRATADO) 'SANA SERVICOS ANESTESICOS AVANCADOS S/C LTDA'          - VL_TOTAL_GERAL_HONO
--NM_XML guiaResumoInternacao    - (NM_PRESATDOR_CONTRATADO)                                                         - VL_TOT_GERAL
--NM_XML guiaHonorarioIndividual - (NM_PRESTADOR_CONTRATADO) 'SERVICO VANGUARDA DE PEDIATRIA E OBSTETRICIA S/S LTDA' - VL_TOTAL_GERAL_HONO 
--NM_XML guiaSP_SADT             - (NM_PRESTADOR_CONTRATADO)                                                         - VL_TOT_GERAL 
