Select nm_usuario, cd_atendimento, cd_paciente from dbamv.atendime where cd_atendimento = 245989
Select nm_usuario from dbamv.paciente where cd_paciente = 115082
Select * from dbasgu.usuarios where cd_usuario in ('KALMEIDA', 'DBAMV')




Begin
  Pkg_Mv2000.Atribui_Empresa( 1 );  -->> Trocar a empresa e rodar uma vez para cada empresa
End;
