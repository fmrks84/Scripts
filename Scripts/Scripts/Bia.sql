--alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss' -- alterar o formato da hora.
--1 - select * from aviso_cirurgia
--2 - select * from cirurgia_aviso
--3 - select * from cirurgia
--4 - select * from prestador_aviso
--5 - select * from prestador
--6 - select * from tip_anest
--7 - select * from convenio
--8 - select * from age_cir

select ca.cd_aviso_cirurgia    Aviso
      ,ag.dt_inicio_age_cir    Data
      ,c.ds_cirurgia           Cirurgia
      ,av.nm_paciente          Paciente
      ,co.nm_convenio          Convenio
      ,ta.ds_tip_anest         Anestesia
      ,av.nr_telefone_contato  Tel
      ,p.nm_prestador          Cirurgião
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
and    ca.cd_aviso_cirurgia =  103
and    p.sn_cirurgiao       =  'S'
and    av.tp_situacao       =  'A'
