select CD_ESPECIE  ,
       CD_CLASSE  ,
       CD_GRU_FAT  ,
       CD_SETOR  ,
       'null'CD_ESTOQUE  ,
       CD_CONF_IMPORT  ,
       CD_SUB_CLA  ,
       CD_PRODUTO ,
       cd_gru_fat_gru_pro


from
(
/*select distinct p.cd_especie,
                p.cd_classe,
                c.cd_gru_fat,
                c.cd_setor,
                c.cd_estoque,
                ''CD_CONF_IMPORT,
                p.cd_sub_cla,
                p.cd_produto,
                gf.cd_gru_fat cd_gru_fat_gru_pro
  from configu_importacao_gru_fat c,
       setor                      s,
       empresa_produto            e,
       produto                    p,
       pro_fat                    pf,
       gru_pro                    g,
       gru_fat                    gf
 where c.cd_setor = s.cd_setor
   and p.cd_produto = e.cd_produto
   and p.cd_pro_fat = pf.cd_pro_fat
   and pf.cd_gru_pro = g.cd_gru_pro
   and g.cd_gru_fat = gf.cd_gru_fat
   and p.cd_classe = c.cd_classe
   and p.cd_especie = c.cd_especie
   and pf.cd_gru_pro = 9
   and c.cd_gru_fat <> 5
   and e.cd_multi_empresa = 7
   and s.cd_multi_empresa = 7
   and pf.sn_ativo = 'S'
   and p.sn_movimentacao = 'S'*/

--union all

select distinct p.cd_especie,
                p.cd_classe,
                c.cd_gru_fat,
                c.cd_setor,
                c.cd_estoque,
                ''CD_CONF_IMPORT,
                p.cd_sub_cla,
                p.cd_produto,
                gf.cd_gru_fat cd_gru_fat_gru_pro
  from configu_importacao_gru_fat c,
       setor                      s,
       empresa_produto            e,
       produto                    p,
       pro_fat                    pf,
       gru_pro                    g,
       gru_fat                    gf
 where c.cd_setor = s.cd_setor
   and p.cd_produto = e.cd_produto
   and p.cd_pro_fat = pf.cd_pro_fat
   and pf.cd_gru_pro = g.cd_gru_pro
   and g.cd_gru_fat = gf.cd_gru_fat
   and p.cd_classe = c.cd_classe
   and p.cd_especie = c.cd_especie
   and pf.cd_gru_pro in (89, 96)
   and c.cd_gru_fat <> 9
   and e.cd_multi_empresa = 7
   and s.cd_multi_empresa = 7
   and pf.sn_ativo = 'S'
   and p.sn_movimentacao = 'S'


union all ------------

/*select distinct p.cd_especie,
                p.cd_classe,
                c.cd_gru_fat,
                c.cd_setor,
                c.cd_estoque,
                ''CD_CONF_IMPORT,
                p.cd_sub_cla,
                p.cd_produto,        
                gf.cd_gru_fat cd_gru_fat_gru_pro
  from configu_importacao_gru_fat c,
       setor                      s,
       empresa_produto            e,
       produto                    p,
       pro_fat                    pf,
       gru_pro                    g,
       gru_fat                    gf
 where c.cd_setor = s.cd_setor
   and p.cd_produto = e.cd_produto
   and p.cd_pro_fat = pf.cd_pro_fat
   and pf.cd_gru_pro = g.cd_gru_pro
   and g.cd_gru_fat = gf.cd_gru_fat
   and p.cd_classe = c.cd_classe
   and p.cd_especie = c.cd_especie
   and pf.cd_gru_pro = 9
   and c.cd_gru_fat <> 5
   and e.cd_multi_empresa = 3
   and s.cd_multi_empresa = 3
   and pf.sn_ativo = 'S'
   and p.sn_movimentacao = 'S'*/

--union all

select distinct p.cd_especie,
                p.cd_classe,
                c.cd_gru_fat,
                c.cd_setor,
                c.cd_estoque,
                ''CD_CONF_IMPORT,
                p.cd_sub_cla,
                p.cd_produto,
                gf.cd_gru_fat cd_gru_fat_gru_pro
  from configu_importacao_gru_fat c,
       setor                      s,
       empresa_produto            e,
       produto                    p,
       pro_fat                    pf,
       gru_pro                    g,
       gru_fat                    gf
 where c.cd_setor = s.cd_setor
   and p.cd_produto = e.cd_produto
   and p.cd_pro_fat = pf.cd_pro_fat
   and pf.cd_gru_pro = g.cd_gru_pro
   and g.cd_gru_fat = gf.cd_gru_fat
   and p.cd_classe = c.cd_classe
   and p.cd_especie = c.cd_especie
   and pf.cd_gru_pro in (89, 96)
   and c.cd_gru_fat <> 9
   and e.cd_multi_empresa = 3
   and s.cd_multi_empresa = 3
   and pf.sn_ativo = 'S'
   and p.sn_movimentacao = 'S'

union all ----------------------

/*select distinct p.cd_especie,
                p.cd_classe,
                c.cd_gru_fat,
                c.cd_setor,
                c.cd_estoque,
                ''CD_CONF_IMPORT,
                p.cd_sub_cla,
                p.cd_produto,
                gf.cd_gru_fat cd_gru_fat_gru_pro
  from configu_importacao_gru_fat c,
       setor                      s,
       empresa_produto            e,
       produto                    p,
       pro_fat                    pf,
       gru_pro                    g,
       gru_fat                    gf
 where c.cd_setor = s.cd_setor
   and p.cd_produto = e.cd_produto
   and p.cd_pro_fat = pf.cd_pro_fat
   and pf.cd_gru_pro = g.cd_gru_pro
   and g.cd_gru_fat = gf.cd_gru_fat
   and p.cd_classe = c.cd_classe
   and p.cd_especie = c.cd_especie
   and pf.cd_gru_pro = 9
   and c.cd_gru_fat <> 5
   and e.cd_multi_empresa = 4
   and s.cd_multi_empresa = 4
   and pf.sn_ativo = 'S'
   and p.sn_movimentacao = 'S'
*/
--union all

select distinct p.cd_especie,
                p.cd_classe,
                c.cd_gru_fat,
                c.cd_setor,
                c.cd_estoque,
                ''CD_CONF_IMPORT,
                p.cd_sub_cla,
                p.cd_produto,
                gf.cd_gru_fat cd_gru_fat_gru_pro
  from configu_importacao_gru_fat c,
       setor                      s,
       empresa_produto            e,
       produto                    p,
       pro_fat                    pf,
       gru_pro                    g,
       gru_fat                    gf
 where c.cd_setor = s.cd_setor
   and p.cd_produto = e.cd_produto
   and p.cd_pro_fat = pf.cd_pro_fat
   and pf.cd_gru_pro = g.cd_gru_pro
   and g.cd_gru_fat = gf.cd_gru_fat
   and p.cd_classe = c.cd_classe
   and p.cd_especie = c.cd_especie
   and pf.cd_gru_pro in (89, 96)
   and c.cd_gru_fat <> 9
   and e.cd_multi_empresa = 4
   and s.cd_multi_empresa = 4
   and pf.sn_ativo = 'S'
   and p.sn_movimentacao = 'S'

--union all ---------------------

/*select distinct p.cd_especie,
                p.cd_classe,
                c.cd_gru_fat,
                c.cd_setor,
                c.cd_estoque,
                ''CD_CONF_IMPORT,
                p.cd_sub_cla,
                p.cd_produto,
                gf.cd_gru_fat cd_gru_fat_gru_pro
  from configu_importacao_gru_fat c,
       setor                      s,
       empresa_produto            e,
       produto                    p,
       pro_fat                    pf,
       gru_pro                    g,
       gru_fat                    gf
 where c.cd_setor = s.cd_setor
   and p.cd_produto = e.cd_produto
   and p.cd_pro_fat = pf.cd_pro_fat
   and pf.cd_gru_pro = g.cd_gru_pro
   and g.cd_gru_fat = gf.cd_gru_fat
   and p.cd_classe = c.cd_classe
   and p.cd_especie = c.cd_especie
   and pf.cd_gru_pro = 9
   and c.cd_gru_fat <> 5
   and e.cd_multi_empresa = 10
   and s.cd_multi_empresa = 10
   and pf.sn_ativo = 'S'
   and p.sn_movimentacao = 'S'*/

union all

select distinct p.cd_especie,
                p.cd_classe,
                c.cd_gru_fat,
                c.cd_setor,
                c.cd_estoque,
                ''CD_CONF_IMPORT,
                p.cd_sub_cla,
                p.cd_produto,
                gf.cd_gru_fat cd_gru_fat_gru_pro
  from configu_importacao_gru_fat c,
       setor                      s,
       empresa_produto            e,
       produto                    p,
       pro_fat                    pf,
       gru_pro                    g,
       gru_fat                    gf
 where c.cd_setor = s.cd_setor
   and p.cd_produto = e.cd_produto
   and p.cd_pro_fat = pf.cd_pro_fat
   and pf.cd_gru_pro = g.cd_gru_pro
   and g.cd_gru_fat = gf.cd_gru_fat
   and p.cd_classe = c.cd_classe
   and p.cd_especie = c.cd_especie
   and pf.cd_gru_pro in (89, 96)
   and c.cd_gru_fat <> 9
   and e.cd_multi_empresa = 10
   and s.cd_multi_empresa = 10
   and pf.sn_ativo = 'S'
   and p.sn_movimentacao = 'S'

--union all ---------------

/*select distinct p.cd_especie,
                p.cd_classe,
                c.cd_gru_fat,
                c.cd_setor,
                c.cd_estoque,
                ''CD_CONF_IMPORT,
                p.cd_sub_cla,
                p.cd_produto,
                gf.cd_gru_fat cd_gru_fat_gru_pro
  from configu_importacao_gru_fat c,
       setor                      s,
       empresa_produto            e,
       produto                    p,
       pro_fat                    pf,
       gru_pro                    g,
       gru_fat                    gf
 where c.cd_setor = s.cd_setor
   and p.cd_produto = e.cd_produto
   and p.cd_pro_fat = pf.cd_pro_fat
   and pf.cd_gru_pro = g.cd_gru_pro
   and g.cd_gru_fat = gf.cd_gru_fat
   and p.cd_classe = c.cd_classe
   and p.cd_especie = c.cd_especie
   and pf.cd_gru_pro = 9
   and c.cd_gru_fat <> 5
   and e.cd_multi_empresa = 25
   and s.cd_multi_empresa = 25
   and pf.sn_ativo = 'S'
   and p.sn_movimentacao = 'S'*/

union all

select distinct p.cd_especie,
                p.cd_classe,
                c.cd_gru_fat,
                c.cd_setor,
                c.cd_estoque,
                ''CD_CONF_IMPORT,
                p.cd_sub_cla,
                p.cd_produto,
                gf.cd_gru_fat cd_gru_fat_gru_pro
  from configu_importacao_gru_fat c,
       setor                      s,
       empresa_produto            e,
       produto                    p,
       pro_fat                    pf,
       gru_pro                    g,
       gru_fat                    gf
 where c.cd_setor = s.cd_setor
   and p.cd_produto = e.cd_produto
   and p.cd_pro_fat = pf.cd_pro_fat
   and pf.cd_gru_pro = g.cd_gru_pro
   and g.cd_gru_fat = gf.cd_gru_fat
   and p.cd_classe = c.cd_classe
   and p.cd_especie = c.cd_especie
   and pf.cd_gru_pro in (89, 96)
   and c.cd_gru_fat <> 9
   and e.cd_multi_empresa = 25
   and s.cd_multi_empresa = 25
   and pf.sn_ativo = 'S'
   and p.sn_movimentacao = 'S'
)
order by cd_produto
--order by cd_gru_fat_gru_pro
--cd_gru_Fat 
