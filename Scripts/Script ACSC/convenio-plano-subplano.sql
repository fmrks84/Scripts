select 
distinct
econv.cd_multi_empresa,
       conv.cd_convenio,
       conv.nm_convenio--,
    /* cpla.cd_con_pla cod_plano,
     cpla.ds_con_pla desc_plano,
      spla.cd_sub_plano,
      spla.ds_sub_plano,
      decode(cpla.sn_permite_ambulatorio,'S','Sim','N','N�o')sn_permite_ambulatorio,
      decode(cpla.sn_permite_externo,'S','Sim','N','N�o')sn_permite_externo,
      decode(cpla.sn_permite_urgencia,'S','Sim','N','N�o')sn_permite_urgencia,
      decode(cpla.sn_permite_internacao,'S','Sim','N','N�o')sn_permite_internacao,
      decode(cpla.sn_permite_hoca, 'S','Sim','N','N�o')sn_permite_home_Care
  
    */
      

      
from dbamv.convenio conv
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio 
inner join dbamv.con_pla cpla on cpla.cd_convenio = econv.cd_convenio 
inner join dbamv.Empresa_Con_Pla ecpla on ecpla.cd_con_pla = cpla.cd_con_pla and ecpla.cd_convenio = econv.cd_convenio
left join dbamv.sub_plano spla on spla.cd_convenio = ecpla.cd_convenio and spla.cd_con_pla = ecpla.cd_con_pla
inner join regra rg on rg.cd_regra = ecpla.cd_regra
inner join itregra irg on irg.cd_regra = rg.cd_regra and rg.cd_regra = irg.cd_regra
inner join tab_fat tf on tf.cd_tab_fat = irg.cd_tab_fat
inner join gru_pro gp on gp.cd_gru_pro = irg.cd_gru_pro
inner join gru_fat gf on gf.cd_gru_fat = gp.cd_gru_fat
where  --econv.cd_multi_empresa IN (3)--(3,4,7,10,11,25) 
--and conv.nr_registro_operadora_ans not in ('999999','000000','111111','111112')
 conv.nm_convenio like 'BRADESCO%' 
--or conv.nm_convenio like '%INTERME%')
--and conv.cd_convenio not in (43,60,61,104,218,421,742,983)
--and cpla.cd_con_pla = 55
AND conv.tp_convenio IN ('C')
and conv.sn_ativo = 'S'
and econv.sn_ativo = 'S'
and ecpla.sn_ativo = 'S'
order by   conv.cd_convenio      
--  cpla.cd_con_pla,
    --      spla.cd_sub_plano           
  --END LOOP           
/*,
conv.cd_convenio,
irg.cd_gru_pro
*/

--SELECT * FROM MULTI_EMPRESAS WHERE CD_MULTI_EMPRESA = 25

--421,742,381,762,

delete proibicao where cd_convenio = 641 and cd_con_pla = 163
