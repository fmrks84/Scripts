select 
pd.cd_produto,
pd.ds_produto,
pd.cd_pro_fat,
imp.cd_tab_fat
from imp_simpro imp
inner join pro_fat pf on pf.cd_pro_fat = imp.cd_pro_fat
inner join produto pd on pd.cd_pro_fat = pf.cd_pro_fat
where pf.cd_gru_pro = 89
and pf.sn_opme = 'S'
and pd.sn_movimentacao = 'S'
AND PD.SN_CONSIGNADO = 'S'
and pd.cd_pro_fat = 00250531
--and pd.cd_produto = 1293

select * from pro_Fat where cd_pro_fat in ('00250531','00002007','00001965');
select * from val_pro vp where vp.cd_tab_fat in (25,2,525,823,871,2325) and vp.cd_pro_fat = '00002007'
select * from regra_lancamento


select * from val_pro where cd_pro_Fat = '00250531'
select cd_produto , cd_pro_fat from produto where cd_pro_Fat in (00001965,00002007,00250531)
