select 
pf.cd_pro_fat,
pf.ds_pro_fat,
pf.cd_gru_pro,
pd.cd_produto,
pd.ds_produto,
pd.vl_fator_pro_fat fator_divisor
from
pro_fat pf 
inner join produto pd on pd.cd_pro_fat = pf.cd_pro_fat
inner join empresa_produto ep on ep.cd_produto = pd.cd_produto
where pf.cd_gru_pro in (92,94)
and pd.sn_bloqueio_de_compra = 'N'
and pf.sn_ativo = 'S'
and ep.cd_multi_empresa = 10
order by pf.cd_pro_fat
--and pd.cd_produto = 2035181
;

select 
pf.cd_pro_fat,
pf.ds_pro_fat,
pf.cd_gru_pro,
ts.cd_tip_tuss tabela_tuss, 
ts.cd_tuss,
ts.ds_tuss,
ts.cd_convenio,
ts.cd_multi_empresa
from
pro_fat pf 
left join tuss ts on ts.cd_pro_fat = pf.cd_pro_fat 
and ts.cd_tip_tuss in (00,20)
and ts.cd_convenio in (147,215)
where pf.cd_gru_pro in (92,94)
and pf.sn_ativo = 'S'
order by pf.cd_pro_fat
