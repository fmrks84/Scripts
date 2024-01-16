/*select pf.cd_gru_pro, gp.ds_gru_pro, pf.sn_opme , gp.tp_gru_pro
from pro_fat pf 
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
where pf.cd_pro_fat = '40901386'
;

select econv.tp_opme_vl_referencia from empresa_convenio econv where econv.cd_convenio = 9 
*/
select 
distinct
econv.cd_multi_empresa,
       conv.cd_convenio,
       conv.nm_convenio
   --    econv.cd_formulario_nf,
    /*   cpla.cd_con_pla,
      cpla.ds_con_pla,
     spla.cd_sub_plano,
    spla.ds_sub_plano*/
 --ecpla.cd_regra
  --  rg.ds_regra,
   -- irg.cd_tab_fat
   --  tf.ds_tab_fat,
    -- irg.vl_percetual_pago

      
      
from dbamv.convenio conv
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio 
inner join dbamv.con_pla cpla on cpla.cd_convenio = econv.cd_convenio 
inner join dbamv.Empresa_Con_Pla ecpla on ecpla.cd_con_pla = cpla.cd_con_pla and ecpla.cd_convenio = econv.cd_convenio
left join dbamv.sub_plano spla on spla.cd_convenio = ecpla.cd_convenio and spla.cd_con_pla = ecpla.cd_con_pla
inner join regra rg on rg.cd_regra = ecpla.cd_regra
--inner join indice ind on ind.cd_indice = ecpla.cd_indice
inner join itregra irg on irg.cd_regra = rg.cd_regra and rg.cd_regra = irg.cd_regra
inner join tab_fat tf on tf.cd_tab_fat = irg.cd_tab_fat
where 
conv.nm_convenio like '%MARIN%'
--conv.cd_convenio  in (104,218)
--conv.cd_convenio IN (185)
--and 
--AND  econv.cd_multi_empresa IN (7)--(3,4,7,10,11,25)
--and cpla.cd_con_pla = 122
--and irg.cd_gru_pro = 9
--AND conv.tp_convenio = 'P'
--and irg.cd_tab_fat = 2 
AND econv.cd_multi_empresa in (4)--(3,4,10,11,25,52)
--and irg.cd_gru_pro IN (89) 
AND conv.tp_convenio = 'C'
--and conv.cd_convenio not in (43,60,61,742,821,983)
--and conv.nm_convenio like '%CET%'
and conv.sn_ativo = 'S'
and econv.sn_ativo = 'S'
and ecpla.sn_ativo = 'S'
order by 3
/*order by --econv.cd_multi_empresa,
         conv.cd_convenio
         --cpla.cd_con_pla,
       -- spla.cd_sub_plano*/

--select * From multi_empresas 

/*
--- consultar pro_Fat na tabela fat 2 simpro  se possui simpro
select \*pf.cd_gru_pro, sp.cd_simpro, pf.cd_gru_pro*\ * from imp_simpro sp
left join pro_Fat pf on pf.cd_pro_fat = sp.cd_pro_fat
where 1 =1 --sp.cd_tab_fat = 2
and pf.cd_pro_fat = '09004940'
;
select * from pro_Fat where cd_pro_Fat = '09004940'
select * from val_pro where cd_tab_fat = 2 and cd_pro_Fat = 09004940
;
select * from gru_pro x where  X.CD_GRU_PRO = 89 --x.tp_gru_pro = 'OP'
;
select * from imp_simpro j where j.cd_tab_fat = 93 and j.cd_pro_fat = 09004940

--select * from itregra irg where irg.cd_regra = 41 and irg.cd_gru_pro = 89
*/

--select * from val_pro where cd_pro_fat = '09067834' and cd_tab_fat = 25 --09067834
;
--SELECT * FROM MULTI_EMPRESAS WHERE CD_MULTI_EMPRESA = 25
