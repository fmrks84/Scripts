
select
'Material',
a.audit_dt_registro,
a.cd_produto,
p.ds_produto,
b.cd_laborator,
b.cd_registro,
a.cd_multi_empresa,
p.cd_pro_fat,
f.ds_pro_fat,
f.cd_gru_pro,
g.ds_gru_pro,
s.cd_simpro
from audit_dbamv.empresa_produto a, dbamv.produto p, dbamv.lab_pro b, dbamv.pro_fat f, gru_pro g, dbamv.imp_simpro s
where a.cd_produto = p.cd_produto
and a.cd_produto = b.cd_produto
and p.cd_pro_fat = f.cd_pro_fat
and f.cd_gru_pro = g.cd_gru_pro
and p.cd_pro_fat = s.cd_pro_fat
and a.audit_tp_acao = 'I'
and a.cd_multi_empresa in (3, 10)--4, 7, 10, 25)
and f.cd_gru_pro in (8, 89, 95, 96)
and s.cd_tab_fat = 2325
order by 1 desc
;

select
'medicamento',
a.audit_dt_registro,
a.cd_produto,
p.ds_produto,
b.cd_laborator,
b.cd_registro,
a.cd_multi_empresa,
p.cd_pro_fat,
f.ds_pro_fat,
f.cd_gru_pro,
g.ds_gru_pro
from audit_dbamv.empresa_produto a, dbamv.produto p, dbamv.lab_pro b, dbamv.pro_fat f, gru_pro g
where a.cd_produto = p.cd_produto
and a.cd_produto = b.cd_produto
and p.cd_pro_fat = f.cd_pro_fat
and f.cd_gru_pro = g.cd_gru_pro
and a.audit_tp_acao = 'I'
and a.cd_multi_empresa in (3, 10)--4, 7, 10, 25)
and f.cd_gru_pro in (43, 44, 55, 94)
order by 1 desc

