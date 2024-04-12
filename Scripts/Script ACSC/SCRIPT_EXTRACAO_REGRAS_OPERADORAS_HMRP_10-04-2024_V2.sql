select
distinct
decode(econv.cd_multi_empresa,'3','CSSJ','4','HST','7','HSC','11','HMRP','25','HCNSC')CASA,
       conv.cd_convenio,
       conv.nm_convenio,
       cpla.cd_con_pla cod_plano,
       cpla.ds_con_pla desc_plano,
       cpla.cd_regra,
       rg.ds_regra,
      -- pf.cd_pro_fat,
     --  upper(ltrim(pf.ds_pro_fat))ds_pro_fat,
       irg.cd_gru_pro,
       gp.ds_gru_pro,
       gp.cd_gru_fat,
       gf.ds_gru_fat,
       irg.cd_tab_fat,
       tf.ds_tab_fat,
       irg.vl_percetual_pago
     --  vp.dt_vigencia,
       --vp.vl_total
       


from dbamv.convenio conv
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
inner join dbamv.con_pla cpla on cpla.cd_convenio = econv.cd_convenio
inner join dbamv.Empresa_Con_Pla ecpla on ecpla.cd_con_pla = cpla.cd_con_pla and ecpla.cd_convenio = econv.cd_convenio
--left join dbamv.sub_plano spla on spla.cd_convenio = ecpla.cd_convenio and spla.cd_con_pla = ecpla.cd_con_pla
inner join regra rg on rg.cd_regra = ecpla.cd_regra
inner join itregra irg on irg.cd_regra = rg.cd_regra and rg.cd_regra = irg.cd_regra
inner join tab_fat tf on tf.cd_tab_fat = irg.cd_tab_fat
inner join gru_pro gp on gp.cd_gru_pro = irg.cd_gru_pro
inner join gru_fat gf on gf.cd_gru_fat = gp.cd_gru_fat
inner join pro_Fat pf on pf.cd_gru_pro = gp.cd_gru_pro and pf.sn_ativo = 'S'
--inner join val_pro vp on vp.cd_tab_fat = irg.cd_tab_fat and vp.cd_pro_fat = pf.cd_pro_fat
where /*trunc(vp.dt_vigencia) = (select max(x.dt_vigencia) from val_pro x where x.cd_tab_fat = vp.cd_tab_fat
and vp.cd_pro_fat = x.cd_pro_fat)
and */ econv.cd_multi_empresa IN (3,4,10,11,25)--(3,4,7,10,11,25)
--and conv.nm_convenio like '%AMIL%'
and conv.cd_convenio not in (421,742,381,762,43)
AND conv.tp_convenio IN ('C','P')
--AND irg.cd_gru_pro in (1,2,3,4,5,10)
and conv.sn_ativo = 'S'
and econv.sn_ativo = 'S'
and ecpla.sn_ativo = 'S'
order by
CASA,
conv.cd_convenio,
cpla.cd_con_pla,
irg.cd_gru_pro
--pf.cd_pro_fat
--vp.dt_vigencia
/*


select * from gru_pro gp where gp.ds_gru_pro like '%DIAR%';
select * from gru_pro gp where gp.ds_gru_pro like '%TAXAS%';
select * from gru_pro gp where gp.ds_gru_pro like '%PACOTES%'*/
