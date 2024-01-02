select p.cd_produto, p.ds_produto, pf.cd_pro_fat , pf.ds_pro_fat, SubStr(p.ds_produto,instr(p.ds_produto,'REF'),50) CAMPO_REF
from produto p , pro_fat pf , val_pro v , empresa_produto ep
where p.cd_pro_fat = pf.cd_pro_fat
and p.cd_produto = ep.cd_produto
and pf.cd_pro_fat = v.cd_pro_fat
and p.cd_especie in (19,20)
and ep.cd_multi_empresa = 1
group by p.cd_produto, p.ds_produto, pf.cd_pro_fat , pf.ds_pro_fat

