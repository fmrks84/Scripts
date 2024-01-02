-- Start of DDL script for VDIC_AVISO_USUARIOS
-- Generated 4-jan-07  11:57:55 am
-- from PRODUCAO-DBAMV:1

-- View VDIC_AVISO_USUARIOS

CREATE OR REPLACE VIEW VDIC_AVISO_USUARIOS (
   CD_AGENDA,
   AVISO,
   CD_BLOCO,
   BLOCO,
   CD_SALA,
   SALAS,
   PACIENTE,
   DT_CADASTRO,
   USUARIO_AGENDAMENTO,
   USUARIO_CONFIRMACAO,
   SITUACAO,
   STATUS,
   INICIO_CIRURGIA,
   FINAL_CIRURGIA)

AS

Select Age_Cir.Cd_Age_Cir                                            Cd_Agenda
     , Age_Cir.Cd_Aviso_Cirurgia                                     Aviso
     , Aviso_Cirurgia.Cd_Cen_Cir                                     Cd_Bloco
     , Cen_Cir.Ds_Cen_Cir                                            Bloco
     , Age_Cir.Cd_Sal_Cir                                            Cd_Sala
     , Sal_Cir.Ds_Sal_Cir                                            Salas
     , Aviso_Cirurgia.Nm_Paciente                                    Paciente
     , Aviso_Cirurgia.Dt_Aviso_Cirurgia                              Dt_Cadastro
     , Usuarios.Nm_Usuario                                   Usuario_Agendamento
     , Aviso_Cirurgia.Cd_Usuario_Confirma                    Usuario_Confirmacao
     , Aviso_Cirurgia.Tp_Situacao                                    Situacao
     , Decode(Aviso_Cirurgia.Tp_Situacao, 'R' , 'Realizada'
                                        , 'G' , 'Agendada')          Status 
     , Age_Cir.Dt_Inicio_Age_Cir                                 Inicio_Cirurgia
     , Age_Cir.Dt_Final_Age_Cir                                   Final_Cirurgia
      
From   Dbamv.Age_Cir
     , Dbamv.Aviso_Cirurgia
     , Dbasgu.Usuarios
     , Dbamv.Sal_Cir
     , Dbamv.Cen_Cir
     
Where  Age_Cir.Cd_Aviso_Cirurgia =  Aviso_Cirurgia.Cd_Aviso_Cirurgia
And    Aviso_Cirurgia.Cd_Usuario =  Usuarios.Cd_Usuario
And    Age_Cir.Cd_Sal_Cir        =  Sal_Cir.Cd_Sal_Cir
And    Aviso_Cirurgia.Cd_Cen_Cir =  Cen_Cir.Cd_Cen_Cir
And    Sal_Cir.Cd_Cen_Cir        =  Cen_Cir.Cd_Cen_Cir  
--And    Trunc(Aviso_Cirurgia.Dt_Aviso_Cirurgia) Between To_Date('16/05/2012','dd/mm/yyyy') And To_Date('16/05/2012','dd/mm/yyyy')

/

-- Grants for VDIC_AVISO_USUARIOS

GRANT DELETE,INSERT,SELECT,UPDATE ON VDIC_AVISO_USUARIOS TO dbaps
/
GRANT DELETE,INSERT,SELECT,UPDATE ON VDIC_AVISO_USUARIOS TO dbasgu
/
GRANT DELETE,INSERT,SELECT,UPDATE ON VDIC_AVISO_USUARIOS TO mvintegra
/
GRANT DELETE,INSERT,SELECT,UPDATE ON VDIC_AVISO_USUARIOS TO mv2000
/
GRANT SELECT ON VDIC_AVISO_USUARIOS TO public
/

-- End of DDL script for VDIC_AVISO_USUARIOS
