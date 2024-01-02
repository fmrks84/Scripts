Select Produto.Cd_Produto                                                                                       "Produto"
     , Produto.Ds_Produto                                                                                       "Descrição do Produto"
     , Est_Pro.Qt_Estoque_Atual                                                                                 "Estoque Atual"
     , Uni_Pro.Ds_Unidade                                                                                       "Unidade"
     , Dbamv.Verif_Vl_Custo_Medio(Produto.Cd_Produto, To_Date('14/12/2009 12:00', 'dd/mm/yyyy hh24:mi'),'H',
                                  Produto.Vl_Custo_Medio,To_Date('14/12/2009 12:00', 'dd/mm/yyyy hh24:mi'),1)   "Vl Cm Santa Joana"
     , Dbamv.Verif_Vl_Custo_Medio(Produto.Cd_Produto, To_Date('14/12/2009 12:00', 'dd/mm/yyyy hh24:mi'),'H',
                                  Produto.Vl_Custo_Medio,To_Date('14/12/2009 12:00', 'dd/mm/yyyy hh24:mi'),2)   "Vl Cm Promatre"
     , Est_Pro.Cd_Estoque

 From  Dbamv.Produto, Dbamv.Uni_Pro , Dbamv.Est_Pro

 Where Produto.Cd_Produto = Uni_Pro.Cd_Produto
 And   Uni_Pro.Tp_Relatorios = 'R'
 And   Produto.Cd_Produto = Est_Pro.Cd_Produto
 And   Produto.Sn_Mestre = 'N'
 And   Produto.Sn_Movimentacao = 'S'
 And   Produto.Sn_Kit = 'N'
 And   Est_Pro.Cd_Estoque = 82
-- And   Produto.Cd_Especie in (1,2,19)
 And   Produto.Sn_Consignado = 'N'
 And   Est_Pro.Qt_Estoque_Atual > 0
-- And   Produto.Cd_produto in (51868,51869)
 Order By Produto.Ds_Produto

--Select * from Uni_Pro where Tp_Relatorios = 'R'
--Select * from Produto
--select sum(qt_estoque_atual)from est_pro where cd_produto = 168
--select * from dbamv.estoque
