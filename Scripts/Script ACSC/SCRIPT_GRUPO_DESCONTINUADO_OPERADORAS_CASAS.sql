select
distinct 
decode(econv.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',11,'HMRP',25,'HCNSC')CASA,
cpla.cd_convenio,
conv.nm_convenio,
pd.cd_produto,
pd.ds_produto,
pf.cd_pro_fat,
pf.ds_pro_fat,
ts.cd_tip_tuss,
tip.ds_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
ts.cd_multi_empresa,
ts.cd_convenio,
gp.cd_gru_pro,
gp.ds_gru_pro,
rg.cd_regra,
rg.ds_regra


from 
gru_pro gp 
inner join itregra irg on irg.cd_gru_pro = gp.cd_gru_pro 
inner join regra rg on rg.cd_regra = irg.cd_regra
inner join con_pla cpla on cpla.cd_regra = rg.cd_regra 
inner join convenio conv on conv.cd_convenio  = cpla.cd_convenio 
inner join empresa_convenio econv on econv.cd_convenio = conv.cd_convenio 
inner join pro_fat pf on pf.cd_gru_pro = irg.cd_gru_pro 
inner join produto pd on pd.cd_pro_fat = pf.cd_pro_fat
inner join empresa_produto epd on epd.cd_produto = pd.cd_produto 
and epd.cd_multi_empresa = econv.cd_multi_empresa
left join tuss ts on ts.cd_pro_fat = pd.cd_pro_fat and (ts.cd_convenio = econv.cd_convenio
or ts.cd_convenio is null) 
and (ts.cd_multi_empresa = econv.cd_multi_empresa or ts.cd_multi_empresa is null)
and ts.cd_tip_tuss in (18,22,20,00)
inner join tip_tuss tip on tip.cd_tip_tuss = ts.cd_tip_tuss
where gp.ds_gru_pro like '%DESCONTIN%'
and conv.nm_convenio LIKE '%CASSI%'
and pf.sn_ativo = 'S'
and econv.cd_multi_empresa in (3,4,7,10,11,25)
and pd.sn_movimentacao = 'S'
and ts.dt_fim_vigencia is null
order by 
casa,
pd.cd_produto
--)group by casa


--SELECT * FROM GRU_PRO WHERE DS_GRU_PRO like '%DESCONTIN%'
