with tabft as (
select
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
ecpla.cd_regra,
irg.cd_gru_pro,
irg.cd_tab_fat,
econv.cd_multi_empresa
from
dbamv.convenio conv
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
inner join dbamv.con_pla cpla on cpla   .cd_convenio = conv.cd_convenio and cpla.sn_ativo = 'S'
inner join dbamv.empresa_con_pla ecpla on ecpla.cd_con_pla = cpla.cd_con_pla
and ecpla.cd_convenio = econv.cd_convenio
and ecpla.cd_multi_empresa = econv.cd_multi_empresa
inner join itregra irg on irg.cd_regra = ecpla.cd_regra
where econv.cd_multi_empresa = 25
--and econv.cd_convenio = 68
and conv.sn_ativo = 'S'
and conv.sn_ativo = 'S'
and conv.tp_convenio = 'C'
--and conv.cd_convenio IN (187,287)
and irg.cd_gru_pro in (7, 8, 9, 12, 15, 43, 44, 57, 66, 71, 89, 91, 92, 94, 95, 96)
order by conv.cd_convenio, cpla.cd_con_pla
)
--;

select
distinct
pd.cd_produto,
pd.ds_produto,
pd.cd_especie,
esp.ds_especie,
pd.cd_classe,
cls.ds_classe,
pd.cd_sub_cla,
scls.ds_sub_cla,
pf.ds_unidade,
lpro.cd_registro anvisa,
pd.vl_fator_pro_fat,
isp.cd_imp_simpro,
ibra.cd_tiss brasindice,
pd.cd_pro_fat,
pf.ds_pro_fat,
pf.cd_gru_pro,
gp.ds_gru_pro,
ts.cd_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
/*ts.dt_inicio_vigencia,
ts.dt_fim_vigencia,
ts.cd_multi_empresa,*/
TS.CD_CONVENIO,
conv.nm_convenio,
--TFT.NM_CONVENIO,
vp.cd_tab_fat,
tf.ds_tab_fat,
pd.vl_ultima_entrada,
pd.vl_custo_medio,
VP.DT_VIGENCIA dt_vigencia_tabela_Valores,
vp.vl_total
from
dbamv.gru_pro gp
inner join dbamv.pro_Fat pf on pf.cd_gru_pro = gp.cd_gru_pro and pf.sn_ativo = 'S'
inner join dbamv.produto pd on pd.cd_pro_fat = pf.cd_pro_fat and pd.sn_movimentacao = 'S'
inner join dbamv.empresa_produto epd on epd.cd_produto = pd.cd_produto and epd.cd_multi_empresa = 25
inner join dbamv.tuss ts on ts.cd_pro_fat = pd.cd_pro_fat and ts.cd_multi_empresa = epd.cd_multi_empresa
and ts.cd_tip_tuss in (20,00)  --and (ts.cd_convenio  in (187,207) or ts.cd_convenio IS NULL) -- IN (7,641,32)
aND TS.CD_MULTI_EMPRESA = 25
AND TS.CD_CONVENIO IS NULL---IN (68)
and ts.dt_fim_vigencia is null
left join convenio conv on conv.cd_convenio = ts.cd_convenio
left join lab_pro lpro on lpro.cd_produto = pd.cd_produto
inner join val_pro vp on vp.cd_pro_fat = pd.cd_pro_fat
inner join tabft tft on tft.cd_tab_fat = vp.cd_tab_fat and tft.cd_multi_empresa = epd.cd_multi_empresa
and tft.cd_gru_pro = pf.cd_gru_pro
left join imp_bra ibra on ibra.cd_pro_fat = pd.cd_pro_fat and ibra.cd_tab_fat = tft.cd_tab_Fat
left join imp_simpro isp on isp.cd_pro_fat = pd.cd_pro_fat and isp.cd_tab_fat = tft.cd_tab_Fat
inner join tab_Fat tf on tf.cd_tab_fat = vp.cd_tab_fat and tf.ds_tab_fat like '%HCNSC%'
inner join especie esp on esp.cd_especie = pd.cd_especie
inner join classe cls on cls.cd_classe = pd.cd_classe
and cls.cd_especie = pd.cd_especie
inner join sub_clas scls on scls.cd_sub_cla = pd.cd_sub_cla and scls.cd_classe = pd.cd_classe
and scls.cd_especie = esp.cd_especie
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
--left join  produto x on x.cd_produto = pd.cd_produto_tem
--left join pro_Fat xx on x.cd_pro_fat = xx.cd_pro_fat
where trunc(vp.dt_vigencia) = (select max(x.dt_vigencia)from val_pro x where x.cd_tab_fat = vp.cd_tab_fat and x.cd_pro_fat = vp.cd_pro_fat)
--and vp.vl_total not in ('0,00')
--and pd.cd_produto = 623
--and pd.dt_ultima_entrada between '01/01/2023' and '31/12/2023'
--AND TS.CD_TUSS IN ('19999992','20999992')
and tft.cd_gru_pro  in (7, 8, 9, 12, 15, 43, 44, 57, 66, 71, 89, 91, 92, 94, 95, 96)--(8,9, 91, 55,89, 95, 96,7, 12, 15, 43, 44, 71, 92, 94)
order by 1
--select * from gru_pro where cd_gru_pro in (8,9, 91, 55,89, 95, 96,7, 12, 15, 43, 44, 71, 92, 94)
--cd_gru_pro in (7, 12, 15, 43, 44, 71, 92, 94)
--select * from val_pro vp where vp.cd_tab_fat in (581) and vp.cd_pro_fat = '90000382'
--select * from gru_pro where (ds_gru_pro like '%MAT%' OR ds_gru_pro like '%ORTES%'OR DS_gRU_PRO LIKE '%MEDICAMEN%')
--select * from tab_Fat where cd_tab_fat in (1, 181, 526, 581, 1081, 2868)

/*
select * from imp_bra where cd_pro_fat = '90000382'
select vp.cd_tab_fat , count(*) from val_pro vp where vp.cd_tab_fat in (581,526)group by vp.cd_tab_fat*/
--select * from gru_pro where cd_gru_pro in  (7, 8, 9, 12, 15, 43, 44, 71, 89, 91, 92, 94, 95, 96)

--select * from atendime where cd_paciente = 2337994
