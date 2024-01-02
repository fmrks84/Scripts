/*begin
DBAMV.PKG_MV2000.atribui_empresa (7);
END;
/
select dbamv.calc_vl_proc_unit  ( 'C'
,'10101039'
,sysdate
,sysdate
,33
,2
,'I'
,1
,'U',
Null ) from dual
*/
/*
Casa
Numero do grupo
Descrição do grupo
Código do item --
Descrição do item --
Valor
Numero Operadora*/

select 
econv.cd_multi_empresa,
tf.cd_tab_fat,
tf.ds_tab_fat,
pf.cd_pro_fat,
pf.ds_pro_fat,
econv.cd_convenio,
(select dbamv.calc_vl_proc_unit('C',
                               pf.cd_pro_fat,
                               sysdate,
                               sysdate,
                               econv.cd_convenio,
                               ecpla.cd_con_pla,
                               null,
                               null,   
                               vp.vl_total,
                               null            ) from dual) 

from pro_fat pf 
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
inner join itregra irg on irg.cd_gru_pro = gp.cd_gru_pro 
inner join regra rg on rg.cd_regra = irg.cd_regra 
inner join empresa_con_pla ecpla on ecpla.cd_regra = rg.cd_regra 
inner join empresa_convenio econv on econv.cd_convenio = ecpla.cd_convenio 
                                 and econv.cd_multi_empresa = ecpla.cd_multi_empresa
inner join tab_Fat tf on tf.cd_tab_fat = irg.cd_tab_fat 
inner join val_pro vp on vp.cd_tab_fat = irg.cd_tab_fat
where pf.sn_ativo = 'S'
and econv.sn_ativo = 'S'
and ecpla.sn_ativo = 'S'

--10010096                                 
                                  



