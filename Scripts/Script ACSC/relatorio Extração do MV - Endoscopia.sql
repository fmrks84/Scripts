select distinct 
       rx.cd_exa_rx COD_EXAME,
       rx.ds_exa_rx NM_EXAME,
     --   conv.cd_convenio ,
       conv.nm_convenio,
       ts.cd_tuss COD_TUSS,
       ts.ds_tuss DS_TUSS,
       vp.cd_pro_fat COD_PROCEDIMENTO,
       vp.cd_tab_fat COD_TAB_FATURAMNTO,
       tf.ds_tab_fat DS_tabela_Faturamento,
       max(vp.dt_vigencia)DT_VIGENCIA,
       max(vp.vl_total)VALOR
  
   
       
from 
empresa_convenio econv
inner join convenio conv on conv.cd_convenio = econv.cd_convenio
inner join empresa_con_pla ecpla on ecpla.cd_convenio = econv.cd_convenio
inner join con_pla cpla on cpla.cd_convenio = ecpla.cd_convenio and ecpla.cd_con_pla = cpla.cd_con_pla
inner join regra rg on rg.cd_regra = ecpla.cd_regra
inner join itregra irg on irg.cd_regra = rg.cd_regra 
inner join val_pro vp on vp.cd_tab_fat = irg.cd_tab_fat 
inner join setor st on st.cd_multi_empresa = econv.cd_multi_empresa
inner join exa_set srx on srx.cd_set_exa = st.cd_setor
inner join exa_rx rx on rx.cd_exa_rx = srx.cd_exa_rx
inner join tuss ts on ts.cd_pro_fat = rx.exa_rx_cd_pro_fat and rx.exa_rx_cd_pro_fat = vp.cd_pro_fat
inner join tab_fat tf on tf.cd_tab_fat = vp.cd_tab_fat
where /*econv.cd_multi_empresa = 7
and*/ ts.cd_convenio is null
--and srx.cd_set_exa = 32 -- setor endoscopia 
and rx.ds_exa_rx LIKE '%ENDOSCO%'
--and vp.cd_tab_fat = 23%%
--and rx.exa_rx_cd_pro_fat = '40801055'-- vp.cd_pro_fat = '40801055'
--and ts.cd_tip_tuss = 22
--and conv.cd_convenio = 7
--and cpla.cd_con_pla = 3
and econv.sn_ativo = 'S'
and conv.sn_ativo = 'S'
--and conv.tp_convenio = 'C'
group by rx.cd_exa_rx,
       rx.ds_exa_rx,
    --   conv.cd_convenio,
       conv.nm_convenio,
       ts.cd_tuss,
       ts.ds_tuss,
       vp.cd_pro_fat,
       vp.cd_tab_fat,
       tf.ds_tab_fat
ORDER BY        
      conv.nm_convenio,
      rx.ds_exa_rx,
      vp.cd_tab_fat

/*select * from dbamv.exa_rx 
where ds_exa_rx like '%ENDOSCOPIA%'*/
