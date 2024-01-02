select cd_log_transf,
       cd_convenio,
       To_Number(Substr(cd_prestador, 1, 12)) Cd_Prestador,
       To_Number(Substr(cd_prestador, 1, 12)) Cd_Prestador,
       dt_transf,
       cd_atendimento_origem,
       cd_atendimento,
       cd_paciente,
       cd_pro_fat,
       cd_ori_ate,
       cd_motivo,
       ds_observacao,
       tp_transf,
       cd_usuario_trasf
       
  from dbamv . log_transferencia
 where cd_paciente = 2214811
    -- cd_Atendimento in (4362771)
   --trunc(dt_transf) between to_date(:P_DT_INICIO, 'dd/mm/yyyy') and to_date(:P_DT_FIM, 'dd/mm/yyyy')
  -- and log_transferencia.cd_convenio = '10'
 order by dt_transf, cd_convenio
