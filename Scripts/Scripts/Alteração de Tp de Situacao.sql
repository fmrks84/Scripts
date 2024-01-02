select * from paciente where cd_paciente = 81380
select * from atendime where cd_paciente in (select cd_paciente from paciente where tp_situacao = 'O')
and cd_tip_res = 103

update paciente
set tp_situacao = 'N'
where cd_paciente in (select cd_paciente
          from atendime
          where cd_tip_res = 103)
and tp_situacao = 'O'

Begin
  Pkg_Mv2000.Atribui_Empresa( 2 );  -->> Trocar a empresa e rodar uma vez para cada empresa
End;
