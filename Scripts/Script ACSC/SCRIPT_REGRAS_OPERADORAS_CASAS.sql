select 
distinct
decode(econv.cd_multi_empresa, '3','CSSJ','4','HST','7','HSC','10','HSJ','11','HMRP','25','HCNSC')CASA,
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
irg.cd_regra,
rg.ds_regra,
irg.cd_gru_pro,
gp.ds_gru_pro,
gp.tp_gru_pro,
--trunc (max(vp.dt_vigencia))dt_vigencia,
tf.cd_tab_fat,
tf.ds_tab_fat,
irg.vl_percetual_pago,
case when irg.vl_percetual_pago < =100 then (100-irg.vl_percetual_pago)
  else 0
  end deflator_perc,
  case when irg.vl_percetual_pago > =100 then ((irg.vl_percetual_pago)-100)
  else 0
  end inflator_perc,
econv.tp_opme_vl_referencia
--nvl(vp.vl_total,0)VL_TOTAL
--(irg.vl_percetual_pago * nvl(vp.vl_total,0))/100 VL_A_COBRAR

from 
dbamv.convenio conv
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio 
inner join dbamv.empresa_con_pla ecpla on ecpla.cd_con_pla = cpla.cd_con_pla and ecpla.cd_convenio = conv.cd_convenio
inner join dbamv.regra rg on rg.cd_regra = ecpla.cd_regra
inner join dbamv.itregra irg on irg.cd_regra = rg.cd_regra
inner join dbamv.pro_Fat pf on pf.cd_gru_pro = irg.cd_gru_pro and pf.sn_ativo = 'S'
--left join dbamv.val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat and vp.cd_tab_fat = irg.cd_tab_fat
left join gru_pro gp on gp.cd_gru_pro = irg.cd_gru_pro
left join tab_fat tf on tf.cd_tab_fat = irg.cd_tab_fat
where /*trunc(vp.dt_vigencia) = (select max(vpx.dt_vigencia)from val_pro vpx where vpx.cd_pro_fat = vp.cd_pro_fat and vpx.cd_tab_fat = vp.cd_tab_fat) --PF.CD_PRO_FAT = '09085708'
and*/ gp.cd_gru_pro in (select X.CD_GRU_PRO from gru_pro x where x.tp_gru_pro in ('MD','OP','MT'))
--and vp.cd_pro_fat in ('09076773')
--and irg.cd_gru_pro IN (9)--(9,89,95,96
--and conv.cd_convenio = 59
--and vp.cd_pro_fat in ('72094540')
--and cpla.cd_con_pla = 2
and conv.tp_convenio = 'C'
AND conv.sn_ativo = 'S'
AND econv.sn_ativo = 'S'
AND ecpla.sn_ativo = 'S'
and econv.cd_multi_empresa IN (3,4,7,10,11,25)
AND conv.nm_convenio not like '%SMO%'
AND conv.nm_convenio not like '%COVID%'
group by 
econv.cd_multi_empresa,
irg.cd_regra,
rg.ds_regra,
gp.tp_gru_pro,
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
irg.cd_gru_pro,
gp.ds_gru_pro,
tf.cd_tab_fat,
tf.ds_tab_fat,
irg.vl_percetual_pago,
econv.tp_opme_vl_referencia
--nvl(vp.vl_total,0)
order by CASA ,conv.cd_convenio, cpla.cd_con_pla--irg.cd_regra,tf.cd_tab_fat,irg.vl_percetual_pago
--;
/*
select * from gru_pro x where x.tp_gru_pro in ('MD','OP','MT')
ORDER BY 1*/
--select distinct tp_Gru_pro from gru_pro
--select * from empresa_convenio

--select * from empresa_con_pla cp where cp.cd_convenio = 3 and cp.cd_con_pla = 2 
