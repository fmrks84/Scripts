--- Medicamentos 
-- 4, 7 

select 
distinct
decode(econv.cd_multi_empresa,'4','HST','7','HSC')EMPRESA,
conv.cd_convenio,
conv.nm_convenio,
dbamv.fc_ovmd_tuss(econv.cd_multi_empresa,
                   vp.cd_pro_fat,
                   conv.cd_convenio,
                   'COD')tuss,               
pf.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade unidade_medida,
irg.cd_tab_fat cd_tabela,
tf.ds_tab_fat desc_tabela,
irg.vl_percetual_pago,
vp.vl_total preco
 

      
from dbamv.convenio conv
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio 
inner join dbamv.con_pla cpla on cpla.cd_convenio = econv.cd_convenio 
inner join dbamv.Empresa_Con_Pla ecpla on ecpla.cd_con_pla = cpla.cd_con_pla and ecpla.cd_convenio = econv.cd_convenio
left join dbamv.sub_plano spla on spla.cd_convenio = ecpla.cd_convenio and spla.cd_con_pla = ecpla.cd_con_pla
inner join regra rg on rg.cd_regra = ecpla.cd_regra
inner join itregra irg on irg.cd_regra = rg.cd_regra and rg.cd_regra = irg.cd_regra
inner join gru_pro gp on gp.cd_gru_pro = irg.cd_gru_pro
inner join tab_fat tf on tf.cd_tab_fat = irg.cd_tab_fat
inner join pro_fat pf on pf.cd_gru_pro = irg.cd_gru_pro and pf.sn_ativo = 'S'
inner join val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat and vp.cd_tab_fat = irg.cd_tab_fat 
where trunc(vp.dt_vigencia) = (select max(x.dt_vigencia) from val_pro x where x.cd_tab_fat = vp.cd_tab_fat and x.cd_pro_fat = vp.cd_pro_fat)
and econv.cd_multi_empresa IN (4)
and conv.cd_convenio in (152)
AND conv.tp_convenio = 'C'
and conv.cd_convenio not in (43,163,301,441,21,26,27,28,62,63,209,211,212,219,401,559,742,843,983)
and irg.cd_gru_pro in (7, 12, 15, 43, 44, 71, 92, 94)
and conv.sn_ativo = 'S'
and econv.sn_ativo = 'S'
and ecpla.sn_ativo = 'S'
and tf.ds_tab_fat not like '%BRASINDICE%' 
order by 
EMPRESA,
conv.cd_convenio,
pf.cd_pro_fat


--16

--select * from gru_pro gpp where gpp.ds_gru_pro like '%MEDICAM%'
