select 
distinct
econv.cd_multi_empresa,
       conv.cd_convenio,
       conv.nm_convenio,
   --    econv.cd_formulario_nf,
       cpla.cd_con_pla,
      cpla.ds_con_pla,
  --   spla.cd_sub_plano,
  --    spla.ds_sub_plano,
  irg.cd_gru_pro,
  gp.ds_gru_pro,
ecpla.cd_regra,
   rg.ds_regra,
   econv.tp_opme_vl_referencia,
    irg.cd_tab_fat,
    tf.ds_tab_fat,
     irg.vl_percetual_pago

      
       
   

from dbamv.convenio conv
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio 
inner join dbamv.con_pla cpla on cpla.cd_convenio = econv.cd_convenio 
inner join dbamv.Empresa_Con_Pla ecpla on ecpla.cd_con_pla = cpla.cd_con_pla and ecpla.cd_convenio = econv.cd_convenio
left join dbamv.sub_plano spla on spla.cd_convenio = ecpla.cd_convenio and spla.cd_con_pla = ecpla.cd_con_pla
inner join regra rg on rg.cd_regra = ecpla.cd_regra
--inner join indice ind on ind.cd_indice = ecpla.cd_indice
inner join itregra irg on irg.cd_regra = rg.cd_regra and rg.cd_regra = irg.cd_regra
inner join tab_fat tf on tf.cd_tab_fat = irg.cd_tab_fat
inner join gru_pro gp on gp.cd_gru_pro = irg.cd_gru_pro
where econv.cd_multi_empresa IN (7)--conv.nm_convenio like 'AMIL%'
--conv.cd_convenio  in (7)
--conv.cd_convenio IN (185)
--and 
--AND  econv.cd_multi_empresa IN (7)--(3,4,7,10,11,25)
--and cpla.cd_con_pla = 5
and irg.cd_gru_pro in (9,89)
and conv.tp_convenio = 'C'
and conv.cd_convenio not in (742,821,60,36,43)
--AND conv.tp_convenio = 'P'
--and irg.cd_tab_fat = 2 
-- econv.cd_multi_empresa in (52)--(3,4,10,11,25,52)
--and irg.cd_gru_pro IN (89) 
--AND conv.tp_convenio = 'C'
and conv.nm_convenio like '%PORTO%'
and conv.sn_ativo = 'S'
and econv.sn_ativo = 'S'
and ecpla.sn_ativo = 'S'
order by 2,4

