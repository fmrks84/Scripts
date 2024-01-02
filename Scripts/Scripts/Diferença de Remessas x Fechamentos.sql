select atendime.cd_atendimento, paciente.nm_paciente, reg_fat.dt_inicio, reg_fat.dt_final
     , dt_fechamento, nm_usuario_fechou
     , cd_reg_fat, reg_fat.cd_convenio
     , vl_total_conta, cd_remessa
     , reg_fat.cd_multi_empresa
     , sn_fechada
from   dbamv.reg_fat, dbamv.atendime, dbamv.paciente
where  paciente.cd_paciente                     =  atendime.cd_paciente
and    atendime.cd_atendimento                  =  reg_fat.cd_atendimento
and    TO_CHAR(REG_FAT.DT_FECHAMENTO,'MM/YYYY') =  '07/2012'
and    reg_fat.cd_convenio                      not in (352,379,378)
and    vl_total_conta                            > '0,0'
order by  vl_total_conta desc



