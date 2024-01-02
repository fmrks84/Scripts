delete from dbamv.ent_pro a where a.cd_ent_pro = 275622
delete from dbamv.itent_pro b where b.cd_ent_pro = 275622

Begin
  Pkg_Mv2000.Atribui_Empresa(1);  -->> Trocar a empresa e rodar uma vez para cada empresa
End;
delete from dbamv.lot_pro c where c.cd_produto = 58432
and c.cd_estoque = 1

select * from dbamv.est_pro d where d.cd_produto = 58432
and d.cd_estoque = 1
