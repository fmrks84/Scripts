
--- 01/01/2022 - 18-04-2023--
with op as (
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
   --    P.vl_ultima_entrada,
       SUM(ep.qt_estoque_atual) saldo,
       P.cd_pro_fat,
       pf.cd_gru_pro,
       gp.ds_gru_pro,
       simp.cd_simpro,
       simp.cd_tuss,
       P.sn_kit,
       P.tp_atualizacao_preco,
       P.tp_cx_cirurgica,
       P.tp_carater,
       P.sn_opme,
       p.vl_custo_medio,
       p.vl_ultima_entrada,
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
       dbamv.gru_pro gp,
       dbamv.imp_simpro simp

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
   and p.cd_tip_ativ = a.cd_tip_ativ(+)
   and u.cd_produto = p.cd_produto
   and pf.cd_pro_fat = p.cd_pro_fat
   and gp.cd_gru_pro = pf.cd_gru_pro
   and simp.cd_pro_fat = p.cd_pro_fat(+)
   and u.tp_relatorios = 'R'
   and empresa_produto.cd_produto = p.cd_produto
  --- AND  p.cd_especie in (19,20)
--   AND  P.CD_CLASSE IN (3,1)
--   AND P.CD_SUB_CLA IN (2,5,7,8,9,10,12,14,17)
   and pf.cd_gru_pro in (7,8,9,12,15,43,44,71,89,91,92,95,96)
   AND  empresa_produto.cd_multi_empresa = 3-- --{cdMultiEmpresa}
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
       P.cd_pro_fat,
        pf.cd_gru_pro,
       gp.ds_gru_pro,
        simp.cd_simpro,
       simp.cd_tuss,
       P.sn_kit,
       P.tp_atualizacao_preco,
       P.tp_cx_cirurgica,
       P.tp_carater,
       P.sn_opme,
       P.sn_consignado,
       empresa_produto.cd_multi_empresa,
       EMPRESA_PRODUTO.TP_CLASSIFICACAO_ABC,
        p.vl_custo_medio
      -- p.vl_ultima_entrada
order by p.cd_especie, p.ds_produto
)

select
opme.cd_produto,
opme.ds_produto,
opme.cd_especie,
opme.cd_classe,
opme.ds_classe,
opme.cd_multi_empresa,
pf.cd_pro_fat,
pf.ds_pro_fat,
opme.cd_gru_pro,
opme.ds_gru_pro,
opme.cd_simpro,
opme.cd_tuss,
''DESC_SIMPRO,
''CLASS_SIMPRO,
''DESC_IDENTIFICACAO,
''CONSUMO_12_MESES_VALOR,
''CONSUMO_12_MESES_QTDADE,
vl_custo_medio,
vl_ultima_entrada,
--ts.ds_tuss,
pf.ds_unidade,
count(*)QTD
from
atendime atd
inner join reg_fat rf on rf.cd_atendimento = atd.cd_atendimento
and rf.cd_convenio = atd.cd_convenio
inner join itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join pro_fat pf on pf.cd_pro_fat = irf.cd_pro_fat
inner join op opme on opme.cd_pro_fat = irf.cd_pro_fat
--left join tuss ts on ts.cd_tuss = opme.cd_tuss
where to_char(atd.dt_atendimento,'dd/mm/rrrr') between '01/10/2022' and '31/10/2023'
--= '70252980'
--AND ts.cd_tip_tuss in (00,19)
--and rownum > =1
and RF.cd_convenio in (149, 152, 156, 160, 185, 217, 377)
group by
opme.cd_produto,
opme.ds_produto,
opme.cd_especie,
opme.cd_classe,
opme.ds_classe,
opme.cd_multi_empresa,
pf.cd_pro_fat,
pf.ds_pro_fat,
opme.cd_gru_pro,
opme.ds_gru_pro,
opme.cd_simpro,
opme.cd_tuss,
--ts.ds_tuss,
pf.ds_unidade,
vl_custo_medio,
vl_ultima_entrada
/*''DESC_SIMPRO,
''CLASS_SIMPRO,
''DESC_IDENTIFICACAO,
''CONSUMO_12_MESES_VALOR,
''CONSUMO_12_MESES,QTDADE*/

order by qtd desc
