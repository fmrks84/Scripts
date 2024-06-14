select 
distinct
pd.cd_produto,
pd.ds_produto,
pd.vl_fator_pro_fat,
pd.cd_especie,
esp.ds_especie,
pd.cd_classe,
cls.ds_classe,
pd.cd_sub_cla,
scls.ds_sub_cla,
imp.cd_simpro,
ibra.cd_tiss brasindice,
CASE WHEN pd.ds_produto not like '%REF%' THEN null
     else SubStr(pd.ds_produto,instr(pd.ds_produto,' REF')+5,50)
     end REFERENCIA,
lpro.cd_registro anvisa,
pf.cd_gru_pro,
gp.ds_gru_pro,
pd.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade,
ts.cd_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
vp.cd_tab_fat,
tb.ds_tab_fat,
vp.vl_total,
ts.cd_multi_empresa,
ts.cd_convenio,
conv.nm_convenio
from 
dbamv.pro_Fat pf 
inner join dbamv.gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro 
and gp.cd_gru_pro  in (7, 8, 9, 12, 15, 43, 44, 55, 71, 73, 89, 91, 92, 94, 95, 96)
inner join dbamv.produto pd on pd.cd_pro_fat = pf.cd_pro_fat
and pd.sn_movimentacao = 'S'
inner join dbamv.especie esp on esp.cd_especie = pd.cd_especie 
--and esp.cd_especie not in (5,9,11,21)
inner join dbamv.classe cls on  cls.cd_classe = pd.cd_classe
and cls.cd_especie = pd.cd_especie 
inner join dbamv.sub_clas scls on scls.cd_sub_cla = pd.cd_sub_cla
and scls.cd_classe = pd.cd_classe
and scls.cd_especie = pd.cd_especie
inner join dbamv.tuss ts on ts.cd_pro_fat = pf.cd_pro_fat and ts.cd_tip_tuss in (00,19,20,22)
inner join dbamv.empresa_produto emp on emp.cd_produto = pd.cd_produto and
emp.cd_multi_empresa =  ts.cd_multi_empresa
and ts.dt_fim_vigencia is null
and ts.cd_multi_empresa in (3) -- coloar a codigo da empresa 
and ts.cd_convenio IN (68)
left join dbamv.convenio conv on conv.cd_convenio = ts.cd_convenio
inner join dbamv.val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat
left join dbamv.imp_simpro imp on imp.cd_pro_fat = vp.cd_pro_fat 
and imp.cd_tab_fat = vp.cd_tab_fat
left join dbamv.imp_bra ibra on ibra.cd_pro_fat= vp.cd_pro_fat
and ibra.cd_tab_fat = vp.cd_tab_fat
inner join dbamv.lab_pro lpro on lpro.cd_produto = pd.cd_produto
inner join dbamv.tab_FAt tb on tb.cd_tab_fat = vp.cd_tab_fat and tb.ds_tab_fat like '%CSSJ%' 
where trunc(vp.dt_vigencia) = (select max(x.dt_vigencia) from val_pro x where x.cd_pro_fat = vp.cd_pro_fat
and vp.cd_tab_fat = x.cd_tab_fat)
--and pf.cd_gru_pro in (7,12,15,43,44,71,92,94)
--and (ts.cd_convenio  in (205,206) or ts.cd_convenio IS NULL) -- aqui voc� colocar se ir� trazer aberto quando colocar 'is null' ou se colocar o codigo do convenio deve alterar para in () para que traga fechado
order by pd.cd_produto

--select * from gru_pro gp where (gp.ds_gru_pro like '%MATERIAL%' OR GP.DS_GRU_PRO LIKE '%MEDICAM%' OR GP.DS_GRU_PRO LIKE '%ORTESE%' OR GP.DS_GRU_PRO LIKE '%DIETA%')

/*select 
distinct
pd.cd_especie,
esp.ds_especie
from dbamv.pro_fat pf 
inner join dbamv.produto pd on pd.cd_pro_fat = pf.cd_pro_fat
and pf.cd_gru_pro in (7,8,9,12,43,44,55,89,91,92,94,95,96)
inner join dbamv.empresa_produto emp on emp.cd_produto = pd.cd_produto 
and emp.cd_multi_empresa = 1 
inner join dbamv.especie esp on esp.cd_especie = pd.cd_especie
where pd.cd_especie not in (5,9,11,21)
order by pd.cd_especie 
*/

--select * from empresa_convenio where cd_convenio = 107
