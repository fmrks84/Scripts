select DISTINCT 
       rx.cd_exa_rx COD_EXAME,
       rx.ds_exa_rx NM_EXAME,
       conv.nm_convenio,
       TS.CD_TUSS COD_TUSS,
       TS.DS_TUSS DS_TUSS,
       vp.cd_pro_fat COD_PROCEDIMENTO,
       VP.CD_TAB_FAT TAB_FATURAMENTO,
       tf.ds_tab_fat DS_tabela_Faturamento,
       VP.DT_VIGENCIA ,
       VP.VL_TOTAL
     --  itr.cd_regra
       
       
from 
exa_rx rx
inner join val_pro vp on vp.cd_pro_fat = rx.exa_rx_cd_pro_fat
inner join tab_fat tf on tf.cd_tab_fat = vp.cd_tab_fat
inner join tuss ts on ts.cd_pro_fat = rx.exa_rx_cd_pro_fat
inner join pro_Fat pf on pf.cd_pro_fat = rx.exa_rx_cd_pro_fat
inner join itregra itr on itr.cd_tab_fat = tf.cd_tab_fat
inner join regra rg on rg.cd_regra = itr.cd_regra 
inner join Empresa_Con_Pla ecpla on ecpla.cd_regra =  rg.cd_regra
inner join convenio conv on conv.cd_convenio = ecpla.cd_convenio
where trunc (vp.dt_vigencia) =
(select max(trunc(vl.dt_vigencia)) from val_pro vl where vl.cd_pro_fat = vp.cd_pro_fat and vl.cd_tab_fat = vp.cd_tab_fat)
and ds_exa_rx like '%ENDOSCOPIA%'
--AND rx.exa_rx_cd_pro_fat = 40202038
and conv.sn_ativo = 'S'
AND TS.CD_CONVENIO IS NULL
--AND TS.CD_TIP_TUSS
/*GROUP BY 
       rx.cd_exa_rx ,
       rx.ds_exa_rx ,
       rx.exa_rx_cd_pro_fat ,
       VP.CD_TAB_FAT ,
     --  VP.DT_VIGENCIA
       VP.VL_TOTAL*/
ORDER BY rx.cd_exa_rx, conv.nm_convenio
