
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
   and pf.cd_gru_pro in (7, 8, 9, 12, 15, 43, 44, 71, 89, 91, 92, 94, 95, 96)
   AND  empresa_produto.cd_multi_empresa = 7-- --{cdMultiEmpresa}
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
--'INTERNADO'tp_Conta,
opme.cd_produto,
opme.ds_produto,
opme.cd_especie,
opme.cd_classe,
opme.ds_classe,
/*opme.cd_multi_empresa,
rf.cd_convenio,*/
pf.cd_pro_fat,
pf.ds_pro_fat,
opme.cd_gru_pro,
opme.ds_gru_pro,
opme.cd_simpro,
ibra.cd_brasindice,
ts.cd_tuss,
ts.ds_tuss,
pf.ds_unidade,
irf.vl_unitario,
count(*)QTD

from
atendime atd
inner join reg_fat rf on rf.cd_atendimento = atd.cd_atendimento
and rf.cd_convenio = atd.cd_convenio
and rf.cd_remessa is not null 
and rf.cd_convenio = 12
inner join itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join pro_fat pf on pf.cd_pro_fat = irf.cd_pro_fat and pf.sn_ativo = 'S'
left join op opme on opme.cd_pro_fat = irf.cd_pro_fat
inner join tuss ts on ts.cd_pro_fat = irf.cd_pro_fat and ts.cd_multi_empresa = opme.cd_multi_empresa
and ts.cd_convenio = rf.cd_convenio
and ts.cd_tip_tuss in (00,19,20)
and ts.dt_fim_vigencia is null 
left join imp_bra ibra on ibra.cd_pro_fat = irf.cd_pro_fat 
where to_char(atd.dt_atendimento,'dd/mm/rrrr') between '01/01/2023' and '31/12/2023'
group by
opme.cd_produto,
opme.ds_produto,
opme.cd_especie,
opme.cd_classe,
opme.ds_classe,
opme.cd_multi_empresa,
rf.cd_convenio,
pf.cd_pro_fat,
pf.ds_pro_fat,
opme.cd_gru_pro,
opme.ds_gru_pro,
opme.cd_simpro,
ibra.cd_brasindice,
ts.cd_tuss,
ts.ds_tuss,
pf.ds_unidade,
irf.vl_unitario
--order by qtd desc


union all


select
--'AMBULATORIAL'tp_Conta,
opme.cd_produto,
opme.ds_produto,
opme.cd_especie,
opme.cd_classe,
opme.ds_classe,
/*opme.cd_multi_empresa,
ramb.cd_convenio,*/
pfx.cd_pro_fat,
pfx.ds_pro_fat,
opme.cd_gru_pro,
opme.ds_gru_pro,
opme.cd_simpro,
ibrax.cd_brasindice,
tsx.cd_tuss,
tsx.ds_tuss,
pfx.ds_unidade,
iramb.vl_unitario,
count(*)QTD
from
atendime atdx
inner join itreg_amb iramb on iramb.cd_atendimento = atdx.cd_atendimento 
inner join reg_amb ramb on ramb.cd_reg_amb = iramb.cd_reg_amb
and ramb.cd_convenio = atdx.cd_convenio
and ramb.cd_remessa is not null 
and ramb.cd_convenio = 12
inner join pro_fat pfx on pfx.cd_pro_fat = iramb.cd_pro_fat and pfx.sn_ativo = 'S'
left join op opme on opme.cd_pro_fat = iramb.cd_pro_fat
inner join tuss tsx on tsx.cd_pro_fat = iramb.cd_pro_fat and tsx.cd_multi_empresa = opme.cd_multi_empresa
and tsx.cd_convenio = ramb.cd_convenio
and tsx.cd_tip_tuss in (00,19,20)
and tsx.dt_fim_vigencia is null 
left join imp_bra ibrax on ibrax.cd_pro_fat = iramb.cd_pro_fat 
where to_char(atdx.dt_atendimento,'dd/mm/rrrr') between  '01/01/2023' and '31/12/2023'

group by
opme.cd_produto,
opme.ds_produto,
opme.cd_especie,
opme.cd_classe,
opme.ds_classe,
/*opme.cd_multi_empresa,
ramb.cd_convenio,*/
pfx.cd_pro_fat,
pfx.ds_pro_fat,
opme.cd_gru_pro,
opme.ds_gru_pro,
opme.cd_simpro,
ibrax.cd_brasindice,
tsx.cd_tuss,
tsx.ds_tuss,
pfx.ds_unidade,
iramb.vl_unitario
order by qtd desc




--select * from gru_pro where cd_gru_pro in (7, 8, 9, 12, 15, 43, 44, 71, 89, 91, 92, 94, 95, 96)
--select * from gru_pro where cd_gru_pro in (8, 95, 96, 9, 89, 91, 7, 12, 15, 43, 44 ,55, 92, 94)

--select * from tip_tuss
