select  
distinct
pct.cd_pro_fat||' - '||pf.ds_pro_fat proced_subordinado,
pct.cd_pro_fat_pacote||' - '||pf1.ds_pro_fat proced_pacote,
pf1.cd_gru_pro||' - '||gp.ds_gru_pro grupo_proced,
pct.cd_convenio||' - '||conv.nm_convenio convenio,
irg.cd_regra||' - '||rg.ds_regra regra,
irg.cd_tab_fat||' - '||tf.ds_tab_fat tab_faturamento,
vp.dt_vigencia ultima_vigencia,
vp.vl_total,
vp.vl_operacional,
vp.vl_honorario


from pacote pct 
inner join convenio conv on conv.cd_convenio = pct.cd_convenio
inner join pro_Fat pf on pf.cd_pro_fat = pct.cd_pro_fat
inner join pro_Fat pf1 on pf1.cd_pro_fat = pct.cd_pro_fat_pacote
inner join itregra irg on irg.cd_gru_pro = pf1.cd_gru_pro
inner join gru_pro gp on gp.cd_gru_pro = pf1.cd_gru_pro
inner join con_pla cpla on cpla.cd_convenio = conv.cd_convenio and cpla.cd_regra = irg.cd_regra
inner join regra rg on rg.cd_regra = irg.cd_regra
inner join tab_fat tf on tf.cd_tab_fat = irg.cd_tab_fat
inner join val_pro vp on vp.cd_tab_fat = irg.cd_tab_fat and vp.cd_pro_fat = pf1.cd_pro_fat
where vp.dt_vigencia = (select max(x.dt_vigencia) from val_pro x where x.cd_tab_fat = vp.cd_tab_fat and x.cd_pro_fat = vp.cd_pro_fat)
and pf1.ds_pro_fat like '%PACOTE%ENDOSCOPIA%'
--and pct.cd_pro_fat_pacote = 10000276 
and pct.cd_multi_empresa = 7
and pct.dt_vigencia_final is null
and conv.tp_convenio not in ('P')
--and conv.cd_convenio = 8 
order by convenio, proced_subordinado

;

--select * from pro_Fat where ds_pro_fat like '%PACOTE%ENDOSCOPIA%'
