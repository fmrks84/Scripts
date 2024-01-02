select trunc(dt_auditoria) dt_auditoria,
       auditoria_conta.cd_motivo_auditoria CD_MOTIVO,
       motivo_auditoria.ds_motivo_auditoria nome_motivo,
       cd_usuario_aud,
       reg_fat.cd_reg_fat CONTA ,
       paciente.cd_paciente || ' - ' || paciente.nm_paciente paciente,
       atendime.cd_atendimento,
       convenio.cd_convenio   cd_convenio,
       convenio.nm_convenio nome_convenio,
       auditoria_conta.cd_con_pla,
       auditoria_conta.cd_gru_fat,
       auditoria_conta.cd_pro_fat || ' - ' || pro_fat.ds_pro_fat procedimento,
       auditoria_conta.vl_percentual_multipla_ant     PERC_ANTERIOR,
       auditoria_conta.vl_percentual_multipla         PERC_ATUAL ,            
       sum(qt_lancamento_ant) qt_lancamento_ant, sum(auditoria_conta.qt_lancamento) qt_lancamento,
       auditoria_conta.cd_setor CD_SETOR,
       setor.nm_setor NOME_SETOR,
       auditoria_conta.cd_setor_produziu || ' - ' ||  setor_produziu.nm_setor setor_produziu,
       auditoria_conta.cd_prestador,
       (case when sum(qt_lancamento_ant - qt_lancamento)<0 then 0
             when sum(qt_lancamento_ant - qt_lancamento)>0 then sum(qt_lancamento_ant - qt_lancamento) end) qt_glosa,
       sum(auditoria_conta.vl_unitario) vl_unitario,
       sum(vl_unitario_ant) vl_unitario_ant,
       sum(auditoria_conta.vl_total_conta_ant)           TOTAL_ANTERIOR,
       sum(auditoria_conta.vl_total_conta)               TOTAL_ATUAL,              
      (case when (sum(auditoria_conta.qt_lancamento)<sum(qt_lancamento_ant))or
                     (auditoria_conta.vl_percentual_multipla < auditoria_conta.vl_percentual_multipla_ant)or
                 (sum(auditoria_conta.vl_unitario) < sum(auditoria_conta.vl_unitario_ant)) then 0
            when  sum(auditoria_conta.qt_lancamento)>=sum(qt_lancamento_ant) then sum(auditoria_conta.vl_total_conta) end) vl_inclusao,
      (case when  sum(auditoria_conta.vl_total_conta_ant - auditoria_conta.vl_total_conta)<0 then 0
            when  sum(auditoria_conta.vl_total_conta_ant - auditoria_conta.vl_total_conta)>0 then
                  sum(auditoria_conta.vl_total_conta_ant - auditoria_conta.vl_total_conta) end) vl_glosa,
       sum(vl_total_conta_ant) vl_total_conta_ant,
       reg_fat.vl_total_conta vl_conta_faturada,
       (select sum(vl_total_conta)
               from dbamv.itreg_fat_original
               where nvl(itreg_fat_original.sn_paciente_paga, 'N') = 'N'
               and itreg_fat_original.sn_pertence_pacote = 'N'
               and nvl(itreg_fat_original.tp_pagamento, 'P') <> 'C'
               and itreg_fat_original.cd_reg_fat = reg_fat.cd_reg_fat) total_conta_auditada,
       auditoria_conta.tp_pagamento,
       atendime.cd_multi_empresa empresa

from  dbamv.auditoria_conta, dbamv.motivo_auditoria, dbamv.reg_fat,
      dbamv.convenio, dbamv.paciente, dbamv.atendime, dbamv.pro_fat,
      dbamv.setor, dbamv.setor setor_produziu

where auditoria_conta.cd_reg_fat           =  reg_fat.cd_reg_fat
and   auditoria_conta.cd_motivo_auditoria  =  motivo_auditoria.cd_motivo_auditoria
and   auditoria_conta.cd_convenio          =  convenio.cd_convenio
and   auditoria_conta.cd_atendimento       =  atendime.cd_atendimento
and   paciente.cd_paciente                 =  atendime.cd_paciente
and   auditoria_conta.cd_pro_fat           =  pro_fat.cd_pro_fat
and   auditoria_conta.cd_setor             =  setor.cd_setor
and   auditoria_conta.cd_setor_produziu    =  setor_produziu.cd_setor
and   auditoria_conta.dt_cancelou          is null
and   reg_fat.cd_reg_fat                   = 307153

group by
trunc(dt_auditoria),
auditoria_conta.cd_motivo_auditoria,
ds_motivo_auditoria,
cd_usuario_aud,
reg_fat.cd_reg_fat,
paciente.cd_paciente,
paciente.nm_paciente,
atendime.cd_atendimento,
convenio.cd_convenio,
convenio.nm_convenio,
auditoria_conta.cd_con_pla,
auditoria_conta.cd_gru_fat,
auditoria_conta.cd_pro_fat,
pro_fat.ds_pro_fat,
auditoria_conta.cd_setor,
setor.nm_setor,
auditoria_conta.cd_setor_produziu,
setor_produziu.nm_setor,
auditoria_conta.cd_prestador,
auditoria_conta.tp_pagamento,
atendime.cd_multi_empresa,
reg_fat.vl_total_conta,
auditoria_conta.vl_percentual_multipla,
auditoria_conta.vl_percentual_multipla_ant

union all

select trunc(dt_auditoria) dt_auditoria,
       auditoria_conta.cd_motivo_auditoria CD_MOTIVO,
       motivo_auditoria.ds_motivo_auditoria NOME_MOTIVO,
       cd_usuario_aud,
       reg_amb.cd_reg_amb CONTA ,
       paciente.cd_paciente || ' - ' || paciente.nm_paciente paciente,
       atendime.cd_atendimento,
       convenio.cd_convenio cd_convenio,
       convenio.nm_convenio nome_convenio,
       auditoria_conta.cd_con_pla,
       auditoria_conta.cd_gru_fat,
       auditoria_conta.cd_pro_fat || ' - ' ||pro_fat.ds_pro_fat procedimento,
       auditoria_conta.vl_percentual_multipla_ant PERC_ANTERIOR,       
       auditoria_conta.vl_percentual_multipla     PERC_ATUAL,
       sum(qt_lancamento_ant) qt_lancamento_ant, sum(auditoria_conta.qt_lancamento) qt_lancamento,
       auditoria_conta.cd_setor CD_SETOR,
       setor.nm_setor NOME_SETOR,
       auditoria_conta.cd_setor_produziu || ' - ' ||  setor_produziu.nm_setor setor_produziu,
       auditoria_conta.cd_prestador,
       (case when sum(qt_lancamento_ant - qt_lancamento)<0 then 0
             when sum(qt_lancamento_ant - qt_lancamento)>0 then sum(qt_lancamento_ant - qt_lancamento) end) qt_glosa,       
       sum(auditoria_conta.vl_unitario) vl_unitario, sum(vl_unitario_ant) vl_unitario_ant,
       sum(auditoria_conta.vl_total_conta_ant)     TOTAL_ANTERIOR,
       sum(auditoria_conta.vl_total_conta)         TOTAL_ATUAL,   
       (case when(sum(auditoria_conta.qt_lancamento)<sum(qt_lancamento_ant)) or
                     (auditoria_conta.vl_percentual_multipla < auditoria_conta.vl_percentual_multipla_ant) or
                 (sum(auditoria_conta.vl_unitario) < sum(auditoria_conta.vl_unitario_ant)) then 0
             when sum(auditoria_conta.qt_lancamento)>=sum(qt_lancamento_ant) then sum(auditoria_conta.vl_total_conta) end) vl_inclusao,
       (case when sum(auditoria_conta.vl_total_conta_ant - auditoria_conta.vl_total_conta)<0 then 0
             when sum(auditoria_conta.vl_total_conta_ant - auditoria_conta.vl_total_conta)>0 then
                  sum(auditoria_conta.vl_total_conta_ant - auditoria_conta.vl_total_conta) end) vl_glosa,
       sum(vl_total_conta_ant) vl_total_conta_ant,
       reg_amb.vl_total_conta vl_conta_faturada, 
      (select     sum(vl_total_conta)
                  from dbamv.itreg_amb_original
                  where nvl(itreg_amb_original.sn_paciente_paga, 'N') = 'N'
                  and itreg_amb_original.sn_pertence_pacote = 'N'
                  and nvl(itreg_amb_original.tp_pagamento, 'P') <> 'C'
                  and itreg_amb_original.cd_reg_amb = reg_amb.cd_reg_amb) vl_conta_auditada,
       auditoria_conta.tp_pagamento,
       atendime.cd_multi_empresa empresa

from   dbamv.auditoria_conta, dbamv.motivo_auditoria, dbamv.reg_amb,
       dbamv.convenio, dbamv.paciente, dbamv.atendime, dbamv.pro_fat,
       dbamv.setor, dbamv.setor setor_produziu

where  auditoria_conta.cd_reg_amb          =     reg_amb.cd_reg_amb
and    auditoria_conta.cd_motivo_auditoria =     motivo_auditoria.cd_motivo_auditoria
and    auditoria_conta.cd_convenio         =     convenio.cd_convenio
and    auditoria_conta.cd_atendimento      =     atendime.cd_atendimento
and    paciente.cd_paciente                =     atendime.cd_paciente
and    auditoria_conta.cd_pro_fat          =     pro_fat.cd_pro_fat
and    auditoria_conta.cd_setor            =     setor.cd_setor
and    auditoria_conta.cd_setor_produziu   =     setor_produziu.cd_setor
and    auditoria_conta.dt_cancelou         is null
and    reg_amb.cd_reg_amb = 744

group by
trunc(dt_auditoria),
auditoria_conta.cd_motivo_auditoria,
ds_motivo_auditoria,
cd_usuario_aud,
reg_amb.cd_reg_amb,
paciente.cd_paciente,
paciente.nm_paciente,
atendime.cd_atendimento,
convenio.cd_convenio,
convenio.nm_convenio,
auditoria_conta.cd_con_pla,
auditoria_conta.cd_gru_fat,
auditoria_conta.cd_pro_fat,
pro_fat.ds_pro_fat,
auditoria_conta.cd_setor,
setor.nm_setor,
auditoria_conta.cd_setor_produziu,
setor_produziu.nm_setor,
auditoria_conta.cd_prestador,
auditoria_conta.tp_pagamento,
atendime.cd_multi_empresa,
reg_amb.vl_total_conta,
auditoria_conta.vl_percentual_multipla,
auditoria_conta.vl_percentual_multipla_ant

order by conta, procedimento




