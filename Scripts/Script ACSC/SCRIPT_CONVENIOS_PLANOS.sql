select econv.cd_multi_empresa,
       conv.cd_convenio,
       conv.nm_convenio,
       cpla.cd_con_pla,
       cpla.ds_con_pla,
       spla.cd_sub_plano,
       spla.ds_sub_plano,
       ecpla.cd_regra,
       
       rg.ds_regra,
       ecpla.cd_indice,
       ind.nm_indice,
       spla.sn_ativo,
       ecpla.sn_permite_ambulatorio,
       ecpla.sn_permite_internacao,
       ecpla.sn_permite_hoca Home_Care,
       ecpla.sn_permite_urgencia,
       ecpla.sn_permite_externo
      
       
   

from dbamv.convenio conv
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio 
inner join dbamv.con_pla cpla on cpla.cd_convenio = econv.cd_convenio 
inner join dbamv.Empresa_Con_Pla ecpla on ecpla.cd_con_pla = cpla.cd_con_pla and ecpla.cd_convenio = econv.cd_convenio
left join dbamv.sub_plano spla on spla.cd_convenio = ecpla.cd_convenio and spla.cd_con_pla = ecpla.cd_con_pla
inner join regra rg on rg.cd_regra = ecpla.cd_regra
inner join indice ind on ind.cd_indice = ecpla.cd_indice
where conv.cd_convenio IN (15)
--econv.cd_multi_empresa in (3)
--AND conv.tp_convenio = 'C'
and conv.sn_ativo = 'S'
and econv.sn_ativo = 'S'
and ecpla.sn_ativo = 'S'
order by econv.cd_multi_empresa,
         conv.cd_convenio,
         cpla.cd_con_pla,
         spla.cd_sub_plano

;
SELECT * FROM PRO_fAT YY WHERE YY.CD_PRO_FAT = '40201023'
;
SELECT * FROM ITREGRA Y WHERE Y.CD_REGRA IN (17) AND Y.CD_GRU_PRO = 23
