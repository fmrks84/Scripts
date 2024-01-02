select 'Material', p.cd_produto, p.ds_produto, p.cd_especie, e.ds_especie, p.cd_classe, c.ds_classe, pf.cd_pro_fat, gp.cd_gru_pro,pf.ds_unidade,

gp.ds_gru_pro,s.cd_simpro, t.cd_tip_tuss, t.cd_tuss, t.ds_tuss,t.cd_multi_empresa, c.cd_convenio , c.nm_convenio, max(t.dt_inicio_vigencia) vigencia--, s.cd_tab_fat

from produto p, especie e, classe c, empresa_produto ep, pro_fat pf, gru_pro gp, imp_simpro s , tuss t , convenio c

where p.cd_especie in(61,19,20)

and ep.cd_multi_empresa in (10) -- produto de estoque liberado por casa

and t.cd_multi_empresa = 10 -- tuss da empresa

and p.cd_produto = ep.cd_produto

and p.cd_especie = e.cd_especie

and e.cd_especie = c.cd_especie

and p.cd_classe = c.cd_classe

and p.cd_pro_fat = pf.cd_pro_fat

and p.cd_pro_fat = t.cd_pro_fat (+)

and t.cd_convenio = c.cd_convenio (+)

and pf.cd_pro_fat = s.cd_pro_fat(+)

and pf.cd_gru_pro = gp.cd_gru_pro

group by p.cd_produto, p.ds_produto, p.cd_especie, e.ds_especie, p.cd_classe, c.ds_classe, pf.cd_pro_fat, pf.ds_unidade,

gp.cd_gru_pro, gp.ds_gru_pro,s.cd_simpro, t.cd_tip_tuss, t.cd_tuss, t.ds_tuss, t.cd_multi_empresa,c.cd_convenio , c.nm_convenio

;

select 'Medicamento',p.cd_produto, p.ds_produto, p.cd_especie, e.ds_especie, p.cd_classe, c.ds_classe, p.vl_ultima_entrada,pf.cd_pro_fat, gp.cd_gru_pro, gp.ds_gru_pro,s.cd_medicamento, s.cd_apresentacao, s.cd_laboratorio, t.cd_tip_tuss, t.cd_tuss, t.ds_tuss, t.cd_multi_empresa,c.cd_convenio

, c.nm_convenio, max(t.dt_inicio_vigencia) vigencia--, s.cd_tab_fat

from produto p, especie e, classe c, empresa_produto ep, pro_fat pf, gru_pro gp, imp_bra s , tuss t , convenio c

where p.cd_especie in(60,17,18)

and ep.cd_multi_empresa in (10)

and p.cd_produto = ep.cd_produto

and p.cd_especie = e.cd_especie

and e.cd_especie = c.cd_especie

and p.cd_classe = c.cd_classe

and p.cd_pro_fat = pf.cd_pro_fat

and p.cd_pro_fat = t.cd_pro_fat (+)

and t.cd_convenio = c.cd_convenio (+)

and pf.cd_pro_fat = s.cd_pro_fat(+)

and pf.cd_gru_pro = gp.cd_gru_pro

group by p.cd_produto, p.ds_produto, p.cd_especie, e.ds_especie, p.cd_classe, c.ds_classe, p.vl_ultima_entrada, pf.cd_pro_fat, gp.cd_gru_pro, gp.ds_gru_pro,s.cd_medicamento, s.cd_apresentacao, s.cd_laboratorio, t.cd_tip_tuss, t.cd_tuss, t.ds_tuss,t.cd_multi_empresa, c.cd_convenio

, c.nm_convenio
