/*Casa
Numero do grupo
Descrição do grupo
Código do item
Descrição do item
Valor
Numero Operadora
*/

select  
distinct 
ecpla.cd_multi_empresa,
tf.cd_tab_fat,
tf.ds_tab_fat,
pf.cd_pro_fat,
pf.ds_pro_fat,
max(vp.vl_total)VL_TOTAL,
econv.cd_convenio,
conv.nm_convenio

from val_pro vp
inner join itregra ir on ir.cd_tab_fat = vp.cd_tab_fat  
inner join regra rg on rg.cd_regra = ir.cd_regra
inner join pro_Fat pf on pf.cd_gru_pro = ir.cd_gru_pro and vp.cd_pro_fat = pf.cd_pro_fat
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
inner join gru_fat gf on gf.cd_gru_fat = gp.cd_gru_fat
inner join tab_fat tf on tf.cd_tab_fat = vp.cd_tab_fat 
inner join Empresa_Con_Pla ecpla on ecpla.cd_regra = rg.cd_regra and rg.cd_regra = ir.cd_regra
inner join Empresa_Convenio econv on econv.cd_convenio = ecpla.cd_convenio and ecpla.cd_multi_empresa = econv.cd_multi_empresa
inner join convenio conv on conv.cd_convenio = econv.cd_convenio and ecpla.cd_convenio = conv.cd_convenio
where econv.cd_multi_empresa in (4)--3,4,7,10,25)
and ecpla.cd_con_pla = 1
and vp.sn_ativo = 'S'
and ecpla.sn_ativo = 'S'
and econv.sn_ativo = 'S'
group by 
ecpla.cd_multi_empresa,
tf.cd_tab_fat,
tf.ds_tab_fat,
pf.cd_pro_fat,
pf.ds_pro_fat,
econv.cd_convenio,
conv.nm_convenio
--ecpla.cd_con_pla
order by 
ecpla.cd_multi_empresa,
econv.cd_convenio
--ecpla.cd_con_pla

--and 
/*group by 
ecpla.cd_multi_empresa,
tf.cd_tab_fat,
tf.ds_tab_fat,
pf.cd_pro_fat,
pf.ds_pro_fat,
econv.cd_convenio*/
