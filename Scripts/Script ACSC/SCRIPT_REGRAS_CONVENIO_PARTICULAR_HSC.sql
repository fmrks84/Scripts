---- particular 35
---- particular 

select 
a.cd_convenio,
a.nm_convenio,
b.cd_con_pla,
b.ds_con_pla,
irg.cd_gru_pro,
gp.ds_gru_pro,
pf.cd_pro_fat,
pf.ds_pro_fat,
irg.cd_tab_fat,
tf.ds_tab_fat,
b.cd_regra,
rg.ds_regra,
irg.vl_percetual_pago,
vp.dt_vigencia,
vp.vl_total


from 
dbamv.convenio a
inner join dbamv.con_pla b on b.cd_convenio = a.cd_convenio 
and b.sn_ativo = 'S' 
AND a.sn_ativo = 'S'
inner join dbamv.regra rg on rg.cd_regra = b.cd_regra
inner join dbamv.itregra irg on irg.cd_regra = rg.cd_regra
inner join dbamv.pro_fat pf on pf.cd_gru_pro = irg.cd_gru_pro and pf.sn_ativo = 'S'
inner join dbamv.gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
inner join dbamv.val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat and vp.cd_tab_fat = irg.cd_tab_fat
inner join dbamv.tab_Fat tf on tf.cd_tab_fat = vp.cd_tab_fat
where trunc(vp.dt_vigencia) = (select max(x.dt_vigencia)from val_pro x where x.cd_pro_fat = vp.cd_pro_fat and x.cd_tab_fat = vp.cd_tab_fat)
and  a.cd_convenio = 40 
--and b.cd_con_pla = 1
--and irg.cd_gru_pro = 0
--and vp.cd_pro_fat = '10101100'
order by b.cd_con_pla, irg.cd_gru_pro,vp.dt_vigencia desc
;

--select * from val_pro where cd_tab_fat = 222 and cd_pro_fat = 10101100
