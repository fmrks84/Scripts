------------------ convenio, plano , diaria automatica configurada ------
select cd_convenio, cd_con_pla, cd_tip_acom, cd_multi_empresa
 from dbamv.acomod_pro_fat where cd_convenio = 10 and cd_pro_fat = 00000010 order by 1
 
 -----------
 select * from dbamv.con_pla p where p.cd_convenio = 10 and p.sn_ativo = 'S' order by 2
