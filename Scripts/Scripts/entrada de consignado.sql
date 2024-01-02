select * from dbamv.ent_pro a 
inner join dbamv.itent_pro b on b.cd_ent_pro = a.cd_ent_pro
where b.cd_produto = 54973
and a.cd_fornecedor = 40276--127--40276
and a.cd_estoque = 1
order by 4 desc 
for update;

--3,00003,0000
select * from dbamv.ord_com z where z.cd_ord_com = 156752 for update 
select * from dbamv.produto z2 where z2.cd_produto = 54973
Begin
  Pkg_Mv2000.Atribui_Empresa(1);  -->> Trocar a empresa e rodar uma vez para cada empresa
End;
select * from dbamv.itent_pro z1 where z1.cd_itent_pro = 1051980 for update 
