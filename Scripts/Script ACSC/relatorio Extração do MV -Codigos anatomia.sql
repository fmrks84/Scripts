select 
distinct
pf.cd_pro_fat,
pf.ds_pro_fat,
ts.cd_tuss,
ts.ds_tuss,
conv.cd_convenio,
conv.nm_convenio,
vp.cd_tab_fat,
tf.ds_tab_fat,
vp.dt_vigencia,
vp.vl_total


from pro_Fat pf
left join tuss ts on ts.cd_pro_fat = pf.cd_pro_fat
left join val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat
inner join itregra irg on irg.cd_tab_fat = vp.cd_tab_fat
inner join regra rg on rg.cd_regra = irg.cd_regra
inner join empresa_con_pla ecpla on ecpla.cd_regra = irg.cd_regra and ecpla.cd_multi_empresa = ts.cd_multi_empresa
inner join convenio conv on conv.cd_convenio = ecpla.cd_convenio 
inner join tab_fat tf on tf.cd_tab_fat = vp.cd_tab_fat
where trunc  (vp.dt_vigencia) =
(select max(trunc(vp1.dt_vigencia)) from val_pro vp1 where vp1.cd_pro_fat = vp.cd_pro_fat and vp1.cd_tab_fat = vp.cd_tab_fat)
and pf.cd_pro_fat in ('70301051','70301061','70301181','70301301','70603053','70603064'
,'40501248','40501256','40503100','40503143','40503496','40503518'
,'40503780','40503798','40503798','40503801','70301071','70301191
','70301211','70302062','70303113','40314022','40314154','40314170
','40314170','40314243','40314278','40314324','40314324','40314324
','40314359','40314359','40314375','40314405','40501159','40501159
','40501159','40501205','40503585','40503585','40503593','40503763
','40503771','40601021','40601030','40601056','40601064','40601110
','40601129','40601137','40601145','40601153','40601161','40601170
','40601188','40601188','40601196','40601200','40601218','40601226
','40601234','40601242','40601250','40601269','40601277','40601285
','40601285','40601293','40601323','40601323','40601439')
--('40601439','70301071')
and ecpla.cd_multi_empresa = 7
order by 
cd_pro_fat,
cd_convenio, 
cd_Tab_Fat
--select * from pro_Fat where cd_pro_Fat = '70301051'
