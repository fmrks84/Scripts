select * from ord_com where cd_ord_com = 2341

select tp_situacao from ord_com where cd_ord_com = 2341

update ord_com set = tp_situacao = '' where cd_ord_com = 

Begin
  Pkg_Mv2000.Atribui_Empresa( 1 );  -->> Trocar a empresa e rodar uma vez para cada empresa
End;
