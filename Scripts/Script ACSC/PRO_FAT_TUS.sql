---dbamv.fc_acsc_tuss
 select
 distinct
 ts.cd_tip_tuss tabela_tuss,
 PF.CD_PRO_FAT,
 PF.DS_PRO_FAT,
 ts.cd_convenio,
 conv.nm_convenio,
 dbamv.fc_acsc_tuss(ts.cd_multi_empresa,
                    ts.cd_pro_fat,
                    ts.cd_convenio,
                    'COD')COD_TUSS,
  dbamv.fc_acsc_tuss(ts.cd_multi_empresa,
                    ts.cd_pro_fat,
                    ts.cd_convenio,
                    'DESC')DS_TUSS              
 from pro_fat pf 
 inner join itregra irg on irg.cd_gru_pro = pf.cd_gru_pro
 inner join empresa_con_pla ecpla on ecpla.cd_regra = irg.cd_regra 
 inner join tuss ts on ts.cd_pro_fat = pf.cd_pro_fat
 left join convenio conv on conv.cd_convenio = ts.cd_convenio
 where irg.cd_tab_fat = 121
 and pf.cd_pro_fat = 60000
 ORDER BY 1


--grant select on dbamv.fc_acsc_tuss to acsc_fabio_santos
