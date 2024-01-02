-- Select para retornar cirurgias realizadas com lançamento em conta
SELECT DISTINCT ac.cd_aviso_cirurgia Aviso, ac.dt_aviso_cirurgia Dt_aviso, ac.dt_realizacao Realizacao, Decode (ac.tp_situacao,'G','Agendado','R','Realizada') Situacao,
       ac.cd_atendimento Codigo, p.nm_paciente Paciente, ca.cd_cirurgia C_C, c.ds_cirurgia N_Cirurgia, Decode (ca.sn_principal,'S','Pincipal','N','Secundaria') Posicao,
       ca.cd_convenio Cod_Con, co.nm_convenio Convenio, pa.cd_prestador Cod_Pre, pr.nm_prestador Nome, Decode (pa.tp_pagamento,'P','Producao','C','Credenciado','N','Nao Faturado') Faturamento, pa.cd_ati_med,
       am.ds_ati_med, pa.sn_principal, i.vl_total_conta
  FROM dbamv.aviso_cirurgia  ac
     , dbamv.cirurgia_aviso  ca
     , dbamv.cirurgia        c
     , dbamv.convenio        co
     , dbamv.atendime        a
     , dbamv.paciente        p
     , dbamv.prestador_aviso pa
     , dbamv.prestador       pr
     , dbamv.ati_med         am
     , dbamv.reg_fat         r
     , dbamv.itreg_fat       i
     , dbamv.pro_fat         pf
 WHERE ac.cd_aviso_cirurgia  = ca.cd_aviso_cirurgia
   AND ca.cd_cirurgia        = c.cd_cirurgia
   AND ca.cd_convenio        = co.cd_convenio
   AND a.cd_paciente         = p.cd_paciente
   AND ac.cd_atendimento     = a.cd_atendimento
   AND ca.cd_cirurgia_aviso  = pa.cd_cirurgia_aviso
   AND pa.cd_prestador       = pr.cd_prestador
   AND pa.cd_cirurgia        = ca.cd_cirurgia
   AND pa.cd_ati_med         = am.cd_ati_med
   AND ac.cd_atendimento     = r.cd_atendimento
   AND i.cd_reg_fat          = r.cd_reg_fat
   AND i.cd_mvto             = ac.cd_aviso_cirurgia
   AND i.cd_pro_fat (+)      = c.cd_pro_fat
   AND ac.sn_ambulatorial    = 'N'
   AND a.cd_multi_empresa    = 4
 ORDER BY 3, 1, 5, 9, 15