select Paciente.Cd_Paciente  
         ,Atendime.Cd_Atendimento
         ,Paciente.Nm_Paciente
         ,Decode(Paciente.Tp_Sexo, 'F','FEMININO'
                                 , 'M', 'MASCULINO'
                                 , 'I','INDEFINIDO') Tp_Sexo
         ,Decode(Ped_Rx.Tp_Motivo, 'R','ROTINA'
                                 , 'U','URGENCIA') Motivo
         ,To_Char(Atendime.Dt_Atendimento, 'dd/mm/yyyy' ) Dt_Atendimento
        ,(Select Fn_Idade (Paciente.Dt_Nascimento, 'a A / m M / d D' ) From Dual) IDADE
        ,Convenio.Nm_Convenio                            Nm_Convenio
        ,Ped_Rx.nm_prestador
        ,Ped_Rx.cd_ped_rx
        ,Ped_Rx.dt_pedido
        ,Set_Exa.nm_set_exa
        ,Set_Exa.cd_setor
        ,Setor.Nm_setor                                 Setor_Solicitante
        ,Itped_Rx.Cd_Itped_rx
        ,Ped_Rx.Nr_Controle
        ,Exa_Rx.Cd_Exa_Rx
        ,Exa_Rx.Ds_Exa_Rx
        ,Ped_Rx.Dt_Entrega
        ,Prestador.Ds_Codigo_Conselho                    CRM
        ,Leito.Ds_Leito
        ,Carteira.Nr_Carteira
        ,Guia.Cd_Senha
 from Dbamv.Paciente
     ,Dbamv.Atendime
     ,Dbamv.Prestador
     ,Dbamv.Convenio
     ,Dbamv.Leito
     ,Dbamv.Carteira
     ,Dbamv.Guia
     ,Dbamv.Ped_rx
     ,Dbamv.Itped_rx
     ,Dbamv.Exa_rx
     ,Dbamv.Set_exa
     ,Dbamv.Setor
 where Paciente.Cd_Paciente     = Atendime.Cd_Paciente
   And Atendime.Cd_Atendimento  = Ped_Rx.Cd_Atendimento
   And Prestador.Cd_Prestador   = Atendime.Cd_Prestador
   And Itped_Rx.Cd_Ped_Rx       = Ped_Rx.Cd_Ped_Rx
   And Ped_Rx.Cd_Setor          = Setor.Cd_Setor
   And Itped_Rx.Cd_Exa_Rx       = Exa_Rx.Cd_Exa_Rx
   And Ped_Rx.Cd_Set_Exa        = Set_Exa.Cd_Set_Exa
   And Convenio.Cd_Convenio     = Atendime.Cd_Convenio
   And Atendime.Cd_Leito        = Leito.Cd_Leito            (+)
   And Carteira.Cd_Paciente (+) = Atendime.Cd_Paciente
   And Guia.Cd_Atendimento  (+) = Atendime.Cd_Atendimento
   And Carteira.Cd_Convenio (+) = Atendime.Cd_Convenio
   And Carteira.Cd_Con_Pla  (+) = Atendime.Cd_Con_Pla
   And Guia.Cd_Guia_Pai is null
   And Atendime.Cd_Atendimento in (Select Dbamv.Pkg_Mv_Atendimento.Get_Cdatendimento From Sys.Dual)
   
   
   --select * from ped_rx where cd_ped_rx = 33123
