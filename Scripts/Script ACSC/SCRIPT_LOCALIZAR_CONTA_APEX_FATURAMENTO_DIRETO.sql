select  
distinct
l.cd_reg_fat,
u.cd_produto,
pf.cd_pro_fat,
u.dt_gravacao,
e.dt_mvto_estoque,
e.hr_mvto_estoque,
vop.cd_guia,
vop.vl_total,
ig.sn_fatura_direto 
from  itmvto_estoque u 
inner join mvto_estoque e on e.cd_mvto_estoque = u.cd_mvto_estoque 
inner join log_falha_importacao l on l.cd_mvto_falha = e.cd_mvto_estoque 
inner join produto pd on pd.cd_produto = u.cd_produto
inner join pro_fat pf on pf.cd_pro_fat = pd.cd_pro_fat
inner join guia g on g.cd_atendimento = e.cd_atendimento and g.tp_guia = 'O'
inner join it_guia ig on ig.cd_guia = g.cd_guia and ig.cd_pro_fat = pf.cd_pro_fat
inner join val_opme_it_guia vop on vop.cd_it_guia = ig.cd_it_guia and vop.cd_guia = g.cd_guia
inner join lot_pro lpro on lpro.cd_produto = u.cd_produto
--inner join 
and l.cd_atendimento = e.cd_atendimento
where e.cd_atendimento = 4782885
;
--select * from itcob_pre p where p.cd_reg_fat = 529021
