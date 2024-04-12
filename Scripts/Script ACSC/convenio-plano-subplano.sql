select 
distinct
econv.cd_multi_empresa,
       conv.cd_convenio,
       conv.nm_convenio/*,
       cpla.cd_con_pla cod_plano,
       cpla.ds_con_pla desc_plano,
       cpla.cd_regra,
       rg.ds_regra,
       irg.cd_gru_pro,
       gp.ds_gru_pro,
       gp.cd_gru_fat,
       gf.ds_gru_fat,
       irg.cd_tab_fat,
       tf.ds_tab_fat,
       irg.vl_percetual_pago*/
      
      
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
where  
econv.cd_multi_empresa IN (25)--(3,4,7,10,11,25) 
 and conv.nm_convenio like '%NOTRE%'
--and conv.cd_convenio not in (43)
AND conv.tp_convenio IN ('C','P')
and conv.sn_ativo = 'S'
and econv.sn_ativo = 'S'
and ecpla.sn_ativo = 'S'
order by 
1/*,
conv.cd_convenio,
irg.cd_gru_pro
*/



--421,742,381,762,
