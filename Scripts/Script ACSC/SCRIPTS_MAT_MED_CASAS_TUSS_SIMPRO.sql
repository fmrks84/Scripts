select 
distinct
pd.cd_produto,
pd.ds_produto,
lb.cd_registro anvisa,
pd.cd_especie,
esp.ds_especie,
pd.cd_classe,
cls.ds_classe,
pd.cd_pro_fat,
pf.cd_gru_pro,
gp.ds_gru_pro,
gp.cd_gru_fat,
gf.ds_gru_fat,
pf.ds_unidade,
--vp.cd_tab_fat,
--tf.ds_tab_fat,
--vp.vl_total,
isp.cd_simpro,
ts.cd_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
ts.cd_multi_empresa,
ts.cd_convenio,
conv.nm_convenio,

CASE WHEN pd.ds_produto not like '%REF%' THEN null
     else SubStr(pd.ds_produto,instr(pd.ds_produto,' REF')+5,50)
     end REFERENCIA
from 
dbamv.gru_pro gp 
inner join dbamv.pro_fat pf on pf.cd_gru_pro = gp.cd_gru_pro
inner join produto pd on pd.cd_pro_fat = pf.cd_pro_fat
inner join especie esp on esp.cd_especie = pd.cd_especie
inner join classe cls on cls.cd_especie = esp.cd_especie and cls.cd_classe = pd.cd_classe
inner join empresa_produto epd on epd.cd_produto = pd.cd_produto and epd.cd_multi_empresa in (7)
and pd.sn_movimentacao = 'S'
left join lab_pro lb on lb.cd_produto = epd.cd_produto 
left join imp_simpro isp on isp.cd_pro_fat = pd.cd_pro_fat
inner join tuss ts on ts.cd_pro_fat = pd.cd_pro_fat and ts.cd_tip_tuss in (19,00)
and ts.cd_multi_empresa = epd.cd_multi_empresa
left join convenio conv on conv.cd_convenio = ts.cd_convenio 
--inner join val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat
inner join gru_Fat gf on gf.cd_gru_fat = gp.cd_gru_fat
---left join tab_fat tf on tf.cd_tab_fat = vp.cd_tab_fat
where --trunc(vp.dt_vigencia) = (select max(x.dt_vigencia) from val_pro x where x.cd_tab_fat = vp.cd_tab_fat and x.cd_pro_fat = vp.cd_pro_fat)
--and vp.cd_pro_fat = 00003831'
 gp.cd_gru_pro in (8,9,89,91,95,96)
--and ts.cd_convenio is null
---and gp.cd_gru_pro in (8,9,89,95,96)
order by pd.cd_produto, ts.cd_convenio
;

--select * from tip_tuss

--select * from tuss ts where ts.cd_tuss  = '0000071879'
