select atendime.cd_atendimento                     Atendimento
     , atendime.dt_atendimento                     Dt_Atendimento
     , To_Char(atendime.hr_atendimento, 'HH24:MI') Hr_Atendimento
     , atendime.dt_alta                            Dt_Alta
     , To_Char(atendime.hr_alta, 'HH24:MI')        Hr_Alta
     , atendime.dt_alta_medica                     Dt_Alta
     , To_Char(atendime.hr_alta_medica, 'HH24:MI') Hr_Alta_Medica
     , reg_fat.cd_reg_fat                          Conta
     , reg_fat.dt_inicio                           Dt_Inicio
     , To_char(reg_fat.dt_inicio,'HH24:MI')        Hr_Incio
     , reg_fat.dt_final                            Dt_Final
     , To_char(reg_fat.dt_final, 'HH24:MI')        Hr_Final
     , reg_fat.cd_multi_empresa                    Empresa
     , reg_fat.cd_convenio                         Convênio
   
from  Dbamv.Atendime, Dbamv.Reg_Fat
where Atendime.Cd_Atendimento =  385394 
and   Atendime.Cd_Atendimento =  Reg_Fat.Cd_Atendimento
and   Atendime.Cd_Convenio    =  Reg_Fat.Cd_Convenio
and   Reg_Fat.Cd_Reg_Fat      =  (Select   Nvl(Conta.Cd_Conta_Pai,Conta.Cd_Reg_Fat)
                                  From     Dbamv.Reg_Fat Conta
                                  Where    Conta.Cd_Atendimento = Atendime.Cd_Atendimento)


