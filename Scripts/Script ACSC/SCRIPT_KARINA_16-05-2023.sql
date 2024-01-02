select p.cd_produto,
 replace(p.ds_produto,';',',')ds_produto,
SubStr(p.ds_produto,instr(p.ds_produto,'REF')+4,50) CAMPO_REF,
 p.cd_especie,
 replace(e.ds_especie,';',',')ds_especie,
 p.cd_classe,
 replace(c.ds_classe,';',',')ds_classe,
 p.cd_sub_cla,
 replace(sub.ds_sub_cla,';',',')ds_sub_cla,
 p.sn_mestre,
 p.cd_produto_tem ,
 replace(m.ds_produto,';',',') ds_mestre,
 p.sn_bloqueio_de_compra,
 p.sn_movimentacao,
 p.sn_controle_validade,
 p.sn_padronizado,
 p.sn_pscotropico ,
 replace(u.ds_unidade,';',',') unidade_ref,
 p.cd_tip_ativ ,
 a.ds_tip_ativ,
 p.cd_lista_codigo_medicamento,
 p.ds_produto_resumido,
 p.dt_ultima_entrada,
 P.vl_ultima_entrada,
 SUM(ep.qt_estoque_atual) saldo,
 Pf.cd_pro_fat,
 Pf.ds_pro_fat,
 Pf.cd_gru_pro,
 gp.DS_GRU_PRO,
 Pf.ds_unidade,
 P.sn_kit,
 P.tp_atualizacao_preco,
 P.tp_cx_cirurgica,
 P.tp_carater,
 P.sn_opme,
 DECODE(P.sn_consignado,'R','REPROCESSADO', 'S', 'CONSIGNADO', 'N', 'NORMAL', NULL)TIP_PRODUTO,
 empresa_produto.cd_multi_empresa,
 EMPRESA_PRODUTO.TP_CLASSIFICACAO_ABC 
 from dbamv.produto p,
 dbamv.especie e,
 dbamv.classe c,
 dbamv.sub_clas sub,
 dbamv.produto m,
 dbamv.tip_ativ a,
 dbamv.uni_pro u,
 dbamv.est_pro ep,
 dbamv.empresa_produto,
 dbamv.pro_fat pf,
 dbamv.gru_pro gp

Where p.cd_especie = e.cd_especie
and p.cd_classe = c.cd_classe
and p.cd_especie = c.cd_especie
and c.cd_especie = e.cd_especie
and p.cd_sub_cla = sub.cd_sub_cla
and p.cd_classe = sub.cd_classe
and p.cd_especie = sub.cd_especie
and c.cd_classe = sub.cd_classe
AND p.cd_produto = ep.cd_produto(+)
and p.cd_produto_tem = m.cd_produto(+)
and pf.cd_pro_fat = p.cd_pro_fat(+)
and gp.cd_gru_pro = pf.cd_gru_pro
and p.cd_tip_ativ = a.cd_tip_ativ(+)
and u.cd_produto = p.cd_produto
and u.tp_relatorios = 'R'
and empresa_produto.cd_produto = p.cd_produto
AND p.cd_especie in (19,20)
AND empresa_produto.cd_multi_empresa = 7-- --{cdMultiEmpresa}
AND p.cd_produto IN (SELECT cd_produto FROM dbamv.empresa_produto)
Group By p.cd_produto,
p.ds_produto,
p.cd_especie,
e.ds_especie,
p.cd_classe,
c.ds_classe,
p.cd_sub_cla,
sub.ds_sub_cla,
p.sn_mestre,
p.cd_produto_tem ,
m.ds_produto ,
p.sn_bloqueio_de_compra,
p.sn_controle_validade,
p.sn_padronizado,
p.sn_pscotropico ,
u.ds_unidade ,
p.cd_tip_ativ ,
a.ds_tip_ativ,
p.cd_lista_codigo_medicamento,
p.ds_produto_resumido,
p.dt_ultima_entrada ,
P.vl_ultima_entrada,
p.sn_movimentacao,
P.ds_produto_resumidO,
 Pf.cd_pro_fat,
 Pf.ds_pro_fat,
 Pf.cd_gru_pro,
 gp.DS_GRU_PRO,
Pf.ds_unidade,
P.sn_kit,
P.tp_atualizacao_preco,
P.tp_cx_cirurgica,
P.tp_carater,
P.sn_opme,
P.sn_consignado,
empresa_produto.cd_multi_empresa,
EMPRESA_PRODUTO.TP_CLASSIFICACAO_ABC
order by p.cd_especie, p.ds_produto
