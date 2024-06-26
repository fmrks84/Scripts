select 
distinct
pd.cd_produto,
pd.ds_produto,
lpro.cd_registro anvisa,
pd.cd_especie,
esp.ds_especie,
pd.cd_classe,
cls.ds_classe,
pd.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade,
imp.cd_simpro simpro,
ibra.cd_tiss brasindice,
case when pd.ds_produto not like '%REF%' then null
     else substr(pd.ds_produto,instr(pd.ds_produto,' REF')+5,50)
     end referencia,

pf.cd_gru_pro,
gp.ds_gru_pro,
ts.cd_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
irg.cd_tab_fat,
tf.ds_tab_fat,
vp.vl_total,
decode(ecpla.cd_multi_empresa,'3','CSSJ','4','HST','7','HSC','10','HSJ','11','HMRP','25','HCNSC')Empresa,
ts.cd_multi_empresa,
ts.cd_convenio,
conv.nm_convenio

from
dbamv.pro_fat pf 
inner join dbamv.produto pd on pd.cd_pro_fat = pf.cd_pro_fat and pd.sn_movimentacao = 'S'
inner join dbamv.especie esp on esp.cd_especie = pd.cd_especie 
inner join dbamv.classe cls on cls.cd_especie = esp.cd_especie and cls.cd_classe = pd.cd_classe
inner join dbamv.empresa_produto epd on epd.cd_produto = pd.cd_produto --and epd.cd_multi_empresa = 7
inner join dbamv.empresa_con_pla ecpla on ecpla.cd_multi_empresa = epd.cd_multi_empresa
inner join dbamv.con_pla cpla on cpla.cd_con_pla = ecpla.cd_con_pla and cpla.cd_convenio = ecpla.cd_convenio
and cpla.sn_ativo = 'S' and ecpla.sn_ativo = 'S'
inner join dbamv.itregra irg on irg.cd_regra = cpla.cd_regra 
and irg.cd_regra = ecpla.cd_regra
and pf.cd_gru_pro = irg.cd_gru_pro
inner join dbamv.tab_fat tf on tf.cd_tab_fat = irg.cd_tab_fat
inner join dbamv.gru_pro gp on gp.cd_gru_pro = irg.cd_gru_pro
inner join dbamv.val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat and vp.cd_tab_fat = irg.cd_tab_fat
left join dbamv.imp_simpro imp on imp.cd_pro_fat = vp.cd_pro_fat and imp.cd_tab_fat = vp.cd_tab_fat
left join dbamv.imp_bra ibra on ibra.cd_pro_fat = vp.cd_pro_fat and ibra.cd_tab_fat = vp.cd_tab_fat
inner join dbamv.lab_pro lpro on lpro.cd_produto = pd.cd_produto
left join dbamv.tuss ts on ts.cd_pro_fat = pf.cd_pro_fat  and ts.cd_multi_empresa = ecpla.cd_multi_empresa 
--and ts.cd_convenio = ecpla.cd_convenio
and ts.cd_tip_tuss in (00,19,20)
and ts.dt_fim_vigencia is null
left join dbamv.convenio conv on conv.cd_convenio = ts.cd_convenio
/*left join dbamv.empresa_convenio econv on econv.cd_convenio = cpla.cd_convenio 
and econv.cd_multi_empresa = ecpla.cd_multi_empresa*/
where trunc(vp.dt_vigencia) = (select max(vpx.dt_vigencia)from dbamv.val_pro vpx where vpx.cd_pro_fat = vp.cd_pro_fat and vpx.cd_tab_fat = vp.cd_tab_fat)
and  pf.cd_gru_pro in (7,8,9,12,43,44,55,89,91,92,94,95,96)
--and ts.cd_multi_empresa = 7
and ecpla.cd_multi_empresa = 7
and ecpla.cd_convenio = 5
--and pd.cd_produto in (2018990/*,2018990*/)
--and ts.cd_convenio = 5
order by pd.cd_produto

;
--select * from tuss where cd_pro_fat = 90220641 and cd_tip_tuss in (00,19,20) and cd_multi_empresa = 7 
