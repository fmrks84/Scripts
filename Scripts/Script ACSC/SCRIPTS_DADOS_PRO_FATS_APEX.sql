select * from pro_fat where cd_pro_fat in ('09013933');
select * from pro_fat where cd_pro_fat in ('09013933')
select * from imp_simpro sp where sp.cd_pro_fat in ('70697817')

select * from regra where cd_regra = 237
select * from tab_fat where cd_tab_fat in (53)--(2,823,25,2325,689,93,2967)-- 1825

select * from gru_pro where cd_gru_pro in (9,89,96)
--select * from aviso_cirurgia x where x.cd_aviso_cirurgia =348299;
select xx.cd_aviso_cirurgia,xx.cd_convenio,xx.cd_con_pla  from cirurgia_aviso xx where xx.cd_aviso_cirurgia = 389252
select * from empresa_con_pla ep where ep.cd_convenio = 12 and ep.cd_con_pla = 1
select * from pro_fat where cd_pro_fat in('09085708')-- ('09002329','09013933','09002339','09002334')
select * from imp_simpro sp where sp.cd_pro_fat in ('09085708')
select * from itregra ir where ir.cd_regra = 292 and ir.cd_gru_pro in (96);


select * from val_pro where cd_pro_fat in ('09085708') and cd_tab_fat in (2) --for update
select * from imp_simpro where cd
select * from tab_Fat where cd_tab_fat in (823,2325,3187)
select count(*) from val_pro where cd_Tab_Fat = 2127
select * from especie where cd_especie = 20
select/* cd_produto,ds_produto,cd_pro_fat */ * from produto where cd_pro_fat in (70697817)--('09017193','70907986','00258205')
2529,91
505,982


select * from tip_tuss where cd_tip_tuss = 25 
select * from tuss where cd_tip_tuss = 25 and cd_tuss = 08
select * from gru_pro where cd_gru_pro = 9

--- TREINAMENTO CONTAS 
AVISO PORTO - 348365 -- 4782900
AVISO AMIL  - 348324 -- 4782902
AVISO NOTRE - 348366 , 348375-4777402


select * from audit_dbamv.guia -- essa é parte de cima da tela de guias
select * from audit_dbamv.it_guia  -- essa é a parte dos itens da guia
-- VIVEST - 389896 - 
- 09002339 - não tem cadastro na tabela simpro , produto esta com valor em tabela proprio de ME DESCONTINUADO 
- 09013933 - tem cadastro na tabela simpro , produto esta com valor em tabela propria de ME DESCONTINUADO 

--- 
select 
GI.NR_GUIA,
GI.CD_AVISO_CIRURGIA,
G2.CD_PRO_FAT,
G2.DS_PROCEDIMENTO,
G2.TP_PRE_POS_CIRURGICO,
g3.vl_unitario,
--g3.vl_perc_fracao,
g3.vl_taxa_comercializacao taxa_consig,
g3.vl_referencia,
g3.vl_total,
g3.tp_referencia
from 
guia gi 
inner join it_guia g2 on g2.cd_guia = gi.cd_guia
inner join val_opme_it_guia g3 on g3.cd_it_guia = g2.cd_it_guia
where GI.CD_AVISO_CIRURGIA = 348339
AND gi.tp_guia = 'O'
and g2.cd_usu_geracao = 'MVINTEGRA'
ORDER BY 5


--select * from multi_empresas where cd_multi_empresa = 7 
select * from remessa where cd_remessa = 
select * from reg_Fat where cd_remessa = 383565;
select * from itreg_fat where cd_reg_fat = 584553;
select * from itlan_med where cd_reg_Fat = 584553


select * from config_nota_fiscal where cd_multi_empresa in (3,4,7,10,11,25);
select  * from log_con


select * from ori_ate where cd_ori_ate = 321

select * from itreg_amb where cd_pro_fat = 41301099 and cd_atendimento = 5384013
