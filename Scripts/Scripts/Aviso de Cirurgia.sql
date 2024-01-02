select ca.cd_aviso_cirurgia                          Aviso
      ,TO_CHAR(av.dt_prev_inter,'DD/MM/YYYY')        Data
      ,TO_CHAR(av.dt_prev_inter,'HH:MM')             Hora
      ,c.ds_cirurgia                                 Cirurgia
      ,av.nm_paciente                                Paciente
      ,co.nm_convenio                                Convenio
      ,ta.ds_tip_anest                               Anestesia
      ,av.nr_telefone_contato                        Telefone
      ,p.nm_prestador                                Cirurgiao
from age_cir ag, aviso_cirurgia av, cirurgia_aviso ca, cirurgia c, prestador_aviso pa, tip_anest ta, convenio co, prestador p
where  ca.cd_aviso_cirurgia = av.cd_aviso_cirurgia
and    ca.cd_cirurgia       =  c.cd_cirurgia
and    ca.cd_convenio       =  co.cd_convenio
and    ca.cd_cirurgia_aviso =  pa.cd_cirurgia_aviso
and    av.cd_tip_anest      =  ta.cd_tip_anest
and    p.cd_prestador       =  pa.cd_prestador (+)
and    pa.cd_cirurgia       =  c.cd_cirurgia
and    pa.cd_aviso_cirurgia =  pa.cd_aviso_cirurgia
and    ca.cd_cirurgia_aviso =  ag.cd_aviso_cirurgia
and    ca.cd_cirurgia       =  pa.cd_cirurgia
and    p.sn_cirurgiao       =  'S'
and    pa.cd_ati_med        =  '01'
and    av.tp_situacao       =  'G'
and    ca.sn_principal      =  'S'
