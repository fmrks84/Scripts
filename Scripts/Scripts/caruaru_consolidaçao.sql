        Select C_Conest.Cd_Produto,
               Produto.sn_consignado,
               Sum( Nvl( C_Conest.Qt_Estoque_Final             , 0 )) Qt_Estoque_Final,
               Sum( Nvl( C_conest.Qt_Estoque_Final_Sem_Transf  , 0 )) Qt_Estoque_Final_Sem_Transf
          From Dbamv.C_Conest,
               Dbamv.Produto
         Where C_conest.Cd_Produto = Produto.Cd_Produto
--           And C_conest.Cd_Produto in (53524, 52874, 52460, 13453 )
           And Produto.Sn_Consignado in ( 'N', 'R', 'S' )  /* PDA - 191674 */
           And C_Conest.Cd_Mes = 01
           And C_conest.Cd_Ano = 2007
        Having(( Sum( Nvl( C_Conest.Qt_Estoque_Final           , 0 )) <  0   And
                  Produto.Sn_Consignado in ( 'N', 'R' ) ) Or
               ( Sum( Nvl( C_Conest.Qt_Estoque_Final_Sem_Transf, 0 )) <  0   And
                  Produto.Sn_Consignado in ( 'N', 'R' ) ) Or
                  Produto.Sn_Consignado = 'S' )
      Group By C_Conest.Cd_Produto
             , Produto.sn_consignado

