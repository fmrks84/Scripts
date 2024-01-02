SELECT p.cd_produto,
       p.ds_produto,
       p.cd_especie,
       e.ds_especie,
       p.cd_classe,
       c.ds_classe,
       p.vl_ultima_entrada,
       pf.cd_pro_fat,
       pf.ds_unidade,
       gp.cd_gru_pro,
       gp.ds_gru_pro,
       s.cd_medicamento,
       b.ds_medicamento,
       s.cd_apresentacao,
       a.ds_apresentacao,
       a.qt_produto,
       s.cd_laboratorio,
       t.cd_tip_tuss,
       t.cd_tuss,
       t.ds_tuss,
       s.cd_tuss tuss_brasindice,
       s.cd_tiss tiss_brasindice,
       t.cd_multi_empresa,
       c.cd_convenio,
       c.nm_convenio,
       MAX(t.dt_inicio_vigencia) vigencia --, s.cd_tab_fat
  FROM produto         p,
       especie         e,
       classe          c,
       empresa_produto ep,
       pro_fat         pf,
       gru_pro         gp,
    imp_bra         s,
       tuss            t,
       convenio        c,
       b_medicame      b,
       b_apres         a
 WHERE p.cd_especie IN (60,17,18,63,23,61,19,20)
 AND ep.cd_multi_empresa IN (3,4,7,10,11,25) AND
 p.cd_produto = ep.cd_produto AND p.cd_especie = e.cd_especie
AND e.cd_especie = c.cd_especie AND
 p.cd_classe = c.cd_classe AND p.cd_pro_fat = pf.cd_pro_fat
 AND p.cd_pro_fat = t.cd_pro_fat(+) AND
 t.cd_convenio = c.cd_convenio(+) AND
 pf.cd_pro_fat = s.cd_pro_fat(+) and
 s.cd_medicamento = b.cd_medicamento(+) and
 s.cd_apresentacao = a.cd_apresentacao(+) aND
 pf.cd_gru_pro = gp.cd_gru_pro
 GROUP BY p.cd_produto,
          p.ds_produto,
          p.cd_especie,
          e.ds_especie,
          p.cd_classe,
          c.ds_classe,
          p.vl_ultima_entrada,
          pf.cd_pro_fat,
          pf.ds_unidade,
          gp.cd_gru_pro,
          gp.ds_gru_pro,
          s.cd_medicamento,
          b.ds_medicamento,
          s.cd_apresentacao,
          a.ds_apresentacao,
          a.qt_produto,
          s.cd_laboratorio,
          t.cd_tip_tuss,
          t.cd_tuss,
          t.ds_tuss,
          s.cd_tuss,
          s.cd_tiss,
          t.cd_multi_empresa,
          c.cd_convenio,
          c.nm_convenio
          
          
          
    --      select * from especie
