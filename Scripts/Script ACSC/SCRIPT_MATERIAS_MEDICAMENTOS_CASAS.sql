--select * from tab_Fat a where a.ds_tab_fat like '%BRASIND%'
select
distinct
decode(epd.cd_multi_empresa,'3','CSSJ','7','HSC')CASA,
pd.cd_produto,
pd.ds_produto,
pd.cd_especie,
esp.ds_especie,
pd.cd_classe,
cls.ds_classe,
pd.cd_sub_cla,
scls.ds_sub_cla,
pd.cd_produto_tem produto_mestre,
mst.ds_produto,
upr.cd_unidade,
pd.sn_controla_serie,
pd.sn_movimentacao,
pd.sn_padronizado,
pd.sn_bloqueio_sol_ord_compra,
pd.sn_bloqueio_de_compra,
pd.cd_tip_ativ,
tav.ds_tip_ativ,
pd.cd_pro_fat,
pf.ds_pro_fat,
pf.ds_unidade,
pf.cd_gru_pro,
gp.ds_gru_pro,
pd.vl_fator_pro_fat,
pd.vl_ultima_entrada,
pd.vl_ultima_custo_real,
pd.vl_custo_medio
--epd.cd_multi_empresa
from
dbamv.gru_pro gp
inner join dbamv.pro_fat pf on pf.cd_gru_pro = gp.cd_gru_pro and pf.sn_ativo = 'S'
inner join dbamv.produto pd on pd.cd_pro_fat = pf.cd_pro_fat --and pd.sn_movimentacao = 'S'
left join dbamv.produto mst on mst.cd_produto = pd.cd_produto_tem
inner join dbamv.empresa_produto epd on epd.cd_produto = pd.cd_produto and epd.cd_multi_empresa in (3,7)
inner join dbamv.especie esp on esp.cd_especie = pd.cd_especie
inner join dbamv.classe cls on cls.cd_classe = pd.cd_classe and cls.cd_especie = pd.cd_especie
inner join dbamv.sub_clas scls on scls.cd_sub_cla = pd.cd_sub_cla and scls.cd_classe = pd.cd_classe
and scls.cd_especie = pd.cd_especie
inner join dbamv.uni_pro upr on upr.cd_produto = pd.cd_produto
inner join dbamv.tip_ativ tav on tav.cd_tip_ativ = pd.cd_tip_ativ
where --GP.CD_GRU_PRO in (8,9,89,95,96)--material
GP.CD_GRU_PRO in (7,12,15,43,44,55,91,92,94)--medicamento
--gp.cd_gru_pro in (7,8,9,12,15,43,44,55,89,91,92,94,95,96)
--and pd.cd_produto = '2000631'
order by CASA
