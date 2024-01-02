Select g.cd_guia, g.tp_guia From Dbamv.Guia G Where G.Cd_Atendimento = 971384
Begin
  Pkg_Mv2000.Atribui_Empresa( 1); 
End;
Select t.cd_guia From Dbamv.Tb_Atendime T Where T.Cd_Atendimento = 971384 for update


