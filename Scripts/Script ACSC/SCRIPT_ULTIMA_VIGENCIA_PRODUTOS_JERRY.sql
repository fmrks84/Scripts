select 
distinct 
ecpla.cd_multi_empresa,
emp.ds_multi_empresa,
pr.cd_produto,
pr.ds_produto,
dbamv.fc_acsc_tuss(ecpla.cd_multi_empresa,vp.cd_pro_fat,conv.cd_convenio,'COD')tuss,
dbamv.fc_acsc_tuss(ecpla.cd_multi_empresa,vp.cd_pro_fat,conv.cd_convenio,'DESC')desc_tuss,
conv.cd_convenio,
conv.nm_convenio,
vp.vl_total,
round(pr.vl_custo_medio,2)vl_custo_medio,
vp.cd_tab_fat,
vp.cd_pro_fat

from produto pr
inner join pro_fat pf on pf.cd_pro_fat = pr.cd_pro_fat
inner join itregra ir on ir.cd_gru_pro = pf.cd_gru_pro
inner join val_pro vp on vp.cd_tab_fat = ir.cd_tab_fat and vp.cd_pro_fat = pf.cd_pro_fat
inner join empresa_con_pla ecpla on ecpla.cd_regra = ir.cd_regra 
inner join convenio conv on conv.cd_convenio = ecpla.cd_convenio
inner join multi_empresas emp on emp.cd_multi_empresa = ecpla.cd_multi_empresa
where vp.dt_vigencia in (select max(x.dt_vigencia) from val_pro x where  x.cd_pro_fat = vp.cd_pro_fat
                                                                        and x.cd_tab_fat = vp.cd_tab_fat)
                                                                        
and pr.cd_produto = 11420 
and conv.sn_ativo = 'S'
AND EMP.CD_MULTI_EMPRESA = 3
--and vp.cd_tab_fat = 181
--and conv.cd_convenio in (5)
--select * from val_pro where cd_pro_Fat = '90171098' and cd_tab_fat = 181 
order by conv.nm_convenio
