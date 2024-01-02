select ent.dt_entrada                               " Data de Entrada "
      ,pro.cd_produto                               " Codigo do Produto "
      ,pro.ds_produto                               " Descrição do Produto "
      ,max(ent.dt_entrada)                          " Ultima Entrada "
      ,max(ite.vl_unitario)                         " Valor Unitario "
      ,max(ite.qt_entrada)                          " Qtd Entrada  "
      ,max(ite.vl_total)                            " Valor Total  "
  from dbamv.produto    pro
      ,dbamv.itent_pro  ite
      ,dbamv.ent_pro    ent
 where ite.cd_produto = pro.cd_produto
   and ent.cd_ent_pro = ite.cd_ent_pro
   and ent.cd_estoque in (1)
   and pro.cd_especie = 2
   and pro.cd_classe  = 4
   and pro.cd_sub_cla = 1
   and pro.sn_movimentacao = 'S'
/*
   and ite.cd_itent_pro = (select max(it2.cd_itent_pro)
                             from dbamv.itent_pro it2
                                 ,dbamv.ent_pro   en2
                            where it2.cd_produto = pro.cd_produto
                              and en2.cd_ent_pro = it2.cd_ent_pro
                              and en2.cd_estoque = ent.cd_estoque)
*/
Group by ent.dt_entrada
        ,pro.cd_produto
        ,pro.ds_produto
Order By Ds_Produto
