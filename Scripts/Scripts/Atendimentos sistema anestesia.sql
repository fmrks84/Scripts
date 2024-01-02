--create or replace view vdic_prescr_anest_pmp as
select mm_ane_fcp.cd_atendimento,
       paciente.nm_paciente,
       mm_ane_fcp.ab1_datavisita Data_visita,
        (CASE WHEN mm_ane_fcp.cd_atendimento IS NOT NULL THEN
         1 ELSE
         0 END) TOTAL,
       decode(mm_ane_fcp.ab1_rpp,1,'SIM',2,'NAO')PRESCRICAO_PADRAO
        from
              dbamv.mm_ane_fcp,
              dbamv.tb_atendime,
              dbamv.paciente
where mm_ane_fcp.cd_atendimento = tb_atendime.cd_atendimento
    and mm_ane_fcp.ab1_datavisita >= '01/05/2016'
     and mm_ane_fcp.ab1_datavisita <= '31/05/2016'
     and tb_atendime.cd_multi_empresa = 2    
     and mm_ane_fcp.ab1_rpp = '2'  
     and tb_atendime.cd_paciente = paciente.cd_paciente        
