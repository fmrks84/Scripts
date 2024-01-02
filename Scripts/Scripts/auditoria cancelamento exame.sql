SELECT log_exclusao_agendamento . cd_log_exclusao_agendamento,
       log_exclusao_agendamento . cd_mot_canc cd_mot_canc,
       mot_canc . ds_mot_canc ds_mot_canc,
       log_exclusao_agendamento . dt_agendado,
       log_exclusao_agendamento . dt_exclusao,
     --  trunc(log_exclusao_agendamento . dt_exclusao) dt_exclusao,
       log_exclusao_agendamento . nm_usuario_exclusao usuario_exclusao,
       log_exclusao_agendamento . cd_paciente cd_paciente,
       log_exclusao_agendamento . nm_paciente nm_paciente,
       
       --trunc(log_exclusao_agendamento . dt_agendado) dt_Agendado,
     /*  log_exclusao_agendamento . cd_it_marcacao cd_it_marcacao,
       log_exclusao_exa_rx . ds_regiao,*/
       exa_rx . ds_exa_rx
  FROM dbamv . log_exclusao_agendamento,
       dbamv . mot_canc,
       dbamv . marcacao,
       dbamv . log_exclusao_exa_rx,
       dbamv . exa_rx
 WHERE log_exclusao_agendamento.cd_paciente = 502187
   AND log_exclusao_agendamento.cd_marcacao = marcacao.cd_marcacao(+)
   AND log_exclusao_agendamento.cd_mot_canc = mot_canc.cd_mot_canc(+)
   AND log_exclusao_agendamento.cd_log_exclusao_agendamento =
       log_Exclusao_Exa_Rx.cd_log_exclusao_agendamento
   AND log_exclusao_exa_rx.cd_exa_rx = exa_rx.cd_exa_rx
   AND cd_sistema = 'PSDI'
 GROUP BY log_exclusao_agendamento.cd_log_exclusao_agendamento,
          log_exclusao_agendamento.cd_mot_canc,
          mot_canc.ds_mot_canc,
          log_exclusao_agendamento . dt_exclusao,
         -- trunc(log_exclusao_agendamento.dt_exclusao),
          log_exclusao_agendamento.nm_usuario_exclusao,
          log_exclusao_agendamento.cd_paciente,
          log_exclusao_agendamento.nm_paciente,
          log_exclusao_agendamento . dt_agendado,
         -- trunc(log_exclusao_agendamento.dt_agendado),
          log_exclusao_agendamento.cd_it_marcacao,
          log_exclusao_exa_rx.ds_regiao,
          exa_rx.ds_exa_rx
 ORDER BY 2 ASC,
          3 ASC,
          4 ASC,
          5 ASC,
          1 ASC,
          6 ASC,
          7 ASC,
          8 ASC,
          9 ASC,
          trunc(log_exclusao_agendamento.dt_exclusao),
          log_exclusao_agendamento.cd_mot_canc
