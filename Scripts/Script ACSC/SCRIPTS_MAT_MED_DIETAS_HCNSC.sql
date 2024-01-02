select
distinct
pd.cd_produto,
pd.ds_produto,
pd.cd_especie,
esp.ds_especie,
pd.cd_classe,
cls.ds_classe,
CASE WHEN pd.ds_produto not like '%REF%' THEN null
     else SubStr(pd.ds_produto,instr(pd.ds_produto,' REF')+5,50)
     end REFERENCIA,
lb.cd_registro anvisa,
imp.cd_simpro simpro,
pd.cd_pro_fat,
pf.ds_unidade,
pf.cd_gru_pro,
gp.ds_gru_pro,
ts.cd_tip_tuss,
ts.cd_tuss,
ts.ds_tuss,
ts.cd_multi_empresa,
ts.cd_convenio,
conv.nm_convenio

from
produto pd
inner join empresa_produto emp on emp.cd_produto = pd.cd_produto and pd.sn_movimentacao = 'S'
inner join pro_fat pf on pf.cd_pro_fat = pd.cd_pro_fat  
inner join gru_pro gp on gp.cd_gru_pro =  pf.cd_gru_pro and gp.cd_gru_pro in (7, 9, 12, 15, 43, 44, 55, 71, 73, 91, 92, 94)-- MAT(8,91,89,95,96)--(7,8,12,15,43,44,71,89,91,92,94,95,96)
inner join tuss ts on ts.cd_pro_fat = pf.cd_pro_fat and ts.cd_tip_tuss in (00,19,20,22)--/*,20,22*/)
and ts.dt_fim_vigencia is null
and ts.cd_multi_empresa = emp.cd_multi_empresa
left  join imp_simpro imp on imp.cd_pro_fat = pd.cd_pro_fat
left  join lab_pro lb on lb.cd_produto = pd.cd_produto
inner join especie esp on esp.cd_especie = pd.cd_especie
inner join classe cls on cls.cd_especie = pd.cd_especie and cls.cd_classe = pd.cd_classe
left join convenio conv on conv.cd_convenio = ts.cd_convenio
where emp.cd_multi_empresa in (25)
order by pd.cd_produto, ts.cd_multi_empresa
--and pd.cd_produto = 314
--cd_gru_pro in (71, 7, 73, 12, 91, 92, 15, 43, 44, 55, 94)
--select * from tip_tuss
/*select * from gru_pro x where (x.ds_gru_pro like '%MEDICAMEN%' OR x.ds_gru_pro like '%MEDICAM%' OR
x.ds_gru_pro like '%DIETAS%' OR X.DS_GRU_PRO LIKE '%ORTES%')*/

--select * from multi_empresas where cd_multi_empresa in (11,25)
