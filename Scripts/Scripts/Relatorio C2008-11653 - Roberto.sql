/*Casa
Numero do grupo
Descri��o do grupo
C�digo do item
Descri��o do item
Valor
Numero Operadora
*/

select  

ecpla.cd_multi_empresa,
tf.cd_tab_fat,
tf.ds_tab_fat,
pf.cd_pro_fat,
pf.ds_pro_fat,
max(vp.vl_total),
econv.cd_convenio


from val_pro vp
inner join itregra ir on ir.cd_tab_fat = vp.cd_tab_fat
inner join regra rg on rg.cd_regra = ir.cd_regra
inner join pro_Fat pf on pf.cd_gru_pro = ir.cd_gru_pro
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
inner join gru_fat gf on gf.cd_gru_fat = gp.cd_gru_fat
inner join tab_fat tf on tf.cd_tab_fat = vp.cd_tab_fat 
inner join Empresa_Con_Pla ecpla on ecpla.cd_regra = rg.cd_regra and rg.cd_regra = ir.cd_regra
inner join Empresa_Convenio econv on econv.cd_convenio = ecpla.cd_convenio and ecpla.cd_multi_empresa = econv.cd_multi_empresa
inner join convenio conv on conv.cd_convenio = econv.cd_convenio and ecpla.cd_convenio = conv.cd_convenio
where econv.cd_convenio = 72
and vp.sn_ativo = 'S'
and ecpla.sn_ativo = 'S'
and econv.sn_ativo = 'S'
and pf.cd_pro_fat = '10010096'
group by 
ecpla.cd_multi_empresa,
tf.cd_tab_fat,
tf.ds_tab_fat,
pf.cd_pro_fat,
pf.ds_pro_fat,
econv.cd_convenio
