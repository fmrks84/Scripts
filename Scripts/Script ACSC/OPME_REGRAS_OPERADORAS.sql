select 
distinct
cd_convenio,
nm_convenio,
cd_con_pla,
ds_con_pla,
cd_regra,
ds_regra,
cd_pro_fat,
ds_pro_fat,
cd_grupo_proced,
nm_grupo_proced,
cd_tab_fat,
ds_tab_fat,
deflator||''||'%'deflator,
inflator||''||'%'inflator,
vl_total_tabela,
case when deflator in (0) then 0
  else (vl_total_tabela - (vl_total_tabela * deflator)/100)  end vl_total_tabela_deflator,
case when inflator in (0) then 0 
else vl_total_tabela + (vl_total_tabela * inflator )/100 end vl_total_tabela_inflator 


from
(
select 
irg.cd_regra,
rg.ds_regra,
irg.cd_gru_pro as cd_grupo_proced,
gp.ds_gru_pro as nm_grupo_proced,
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
irg.cd_gru_pro,
gp.ds_gru_pro,
irg.cd_tab_fat,
tf.ds_tab_fat,
vp.dt_vigencia,
vp.cd_pro_fat,
pf.ds_pro_fat,
irg.vl_percetual_pago,
case when irg.vl_percetual_pago < =100 then (100-irg.vl_percetual_pago)
  else 0
  end deflator,
  case when irg.vl_percetual_pago > =100 then ((irg.vl_percetual_pago)-100)
  else 0
  end inflator,
nvl(vp.vl_total,0)VL_TOTAL_TABELA

from 
dbamv.convenio conv
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio
inner join dbamv.empresa_con_pla ecpla on ecpla.cd_con_pla = cpla.cd_con_pla and ecpla.cd_convenio = conv.cd_convenio
inner join dbamv.itregra irg on irg.cd_regra = cpla.cd_regra
left join dbamv.pro_Fat pf on pf.cd_gru_pro = irg.cd_gru_pro and pf.sn_ativo = 'S'
inner join dbamv.val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat and vp.cd_tab_fat = irg.cd_tab_fat
left join gru_pro gp on gp.cd_gru_pro = irg.cd_gru_pro
left join tab_fat tf on tf.cd_tab_fat = vp.cd_tab_fat
left join regra rg on rg.cd_regra = irg.cd_regra
where trunc(vp.dt_vigencia) = (select max(x.dt_vigencia)from val_pro x where x.cd_pro_fat = vp.cd_pro_fat and x.cd_tab_fat = vp.cd_tab_fat)
--and vp.cd_pro_fat = '00284336' 
and irg.cd_gru_pro IN (9,89,95,96)
and conv.cd_convenio = 25 
and cpla.cd_con_pla = 1
order by vp.cd_pro_fat,irg.cd_regra,irg.cd_gru_pro,irg.cd_tab_fat,irg.vl_percetual_pago
)where 1 = 1 

/*select * from pro_fat where cd_pro_fat = '00284336' 
select * from gru_pro where cd_gru_pro IN (9,89,95,96)
select * from val_pro where cd_tab_fat = 2 and cd_pro_fat = '00284336' */


