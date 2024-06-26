select 
distinct
me.tp_mvto_estoque,
me.hr_mvto_estoque,
me.cd_aviso_cirurgia,
me.cd_atendimento,
me.cd_mvto_estoque,
me.dt_mvto_estoque,
ime.cd_produto,
pd.ds_produto,
ime.qt_movimentacao,
'<----'mov_est,
'---->'conta,
irf.cd_reg_fat,
irf.cd_gru_fat,
gf.ds_gru_fat,
irf.cd_pro_fat,
pf.ds_pro_fat,
irf.vl_unitario,
irf.qt_lancamento,
irf.tp_mvto,
irf.vl_total_conta vl_total_opme,
'---->'saida_cons,
icob.vl_preco_unitario,
icob.vl_preco_total,
icob.cd_fornecedor,
'---->'ent_oc,
ep.cd_estoque,
case when iep.cd_produto is not null then ep.cd_ord_com else null end cd_ord_com,
iep.cd_ent_pro,
iep.cd_produto,
case when iep.cd_produto is not null then pd.ds_produto else null end ds_produto,
iep.qt_entrada,
case when  iep.cd_produto is not null then nvl(iep.qt_devolvida,0) else null end qt_devolvida,
case when  iep.cd_produto is not null then nvl(iep.qt_atendida,0) else null end qt_atendida,
iep.vl_unitario,
iep.vl_total

from 
dbamv.mvto_estoque me 
left join dbamv.itmvto_estoque ime on ime.cd_mvto_estoque = me.cd_mvto_estoque
inner join dbamv.produto pd on pd.cd_produto = ime.cd_produto 
and pd.cd_especie in (19,20) and pd.sn_movimentacao = 'S'
left join dbamv.empresa_produto emp on emp.cd_produto = pd.cd_produto 
and emp.cd_multi_empresa = me.cd_multi_empresa
left join dbamv.reg_fat rf on rf.cd_atendimento = me.cd_atendimento 
left join dbamv.itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat and pd.cd_pro_fat = irf.cd_pro_fat
and (irf.cd_mvto = me.cd_mvto_estoque or irf.cd_mvto is null)
 and irf.cd_gru_fat in (5,9)
left join dbamv.pro_fat pf on pf.cd_pro_fat = irf.cd_pro_fat
left join dbamv.gru_fat gf on gf.cd_gru_fat = irf.cd_gru_fat
left join dbamv.itcob_pre icob on icob.cd_reg_fat = irf.cd_reg_fat and icob.cd_lancamento = irf.cd_lancamento
left join dbamv.ent_pro ep on ep.cd_atendimento = rf.cd_atendimento 
left join dbamv.itent_pro iep on iep.cd_ent_pro = ep.cd_ent_pro and iep.cd_produto = pd.cd_produto
where me.dt_mvto_estoque  between  '01/12/2023' and '27/12/2023' -- filtro data 
and rf.cd_remessa is null
and me.tp_mvto_estoque not in ('T','X','S','C')
and (irf.tp_mvto = 'Faturamento' or irf.tp_mvto <> 'Faturamento')
and me.cd_multi_empresa = 7 --filtro empresa 
and me.cd_aviso_cirurgia = 365198
order by me.cd_aviso_cirurgia

/*union all 

select 
distinct
me.tp_mvto_estoque,
me.hr_mvto_estoque,
me.cd_aviso_cirurgia,
me.cd_atendimento,
me.cd_mvto_estoque,
me.dt_mvto_estoque,
ime.cd_produto,
pd.ds_produto,
ime.qt_movimentacao,
'<----'mov_est,
'---->'conta,
irf.cd_reg_fat,
irf.cd_gru_fat,
gf.ds_gru_fat,
irf.cd_pro_fat,
pf.ds_pro_fat,
irf.vl_unitario,
irf.qt_lancamento,
irf.tp_mvto,
irf.vl_total_conta vl_total_opme,
'---->'saida_cons,
icob.vl_preco_unitario,
icob.vl_preco_total,
icob.cd_fornecedor,
'---->'ent_oc,
ep.cd_estoque,
case when iep.cd_produto is not null then ep.cd_ord_com else null end cd_ord_com,
iep.cd_ent_pro,
iep.cd_produto,
case when iep.cd_produto is not null then pd.ds_produto else null end ds_produto,
iep.qt_entrada,
case when  iep.cd_produto is not null then nvl(iep.qt_devolvida,0) else null end qt_devolvida,
case when  iep.cd_produto is not null then nvl(iep.qt_atendida,0) else null end qt_atendida,
iep.vl_unitario,
iep.vl_total

from 
dbamv.mvto_estoque me 
left join dbamv.itmvto_estoque ime on ime.cd_mvto_estoque = me.cd_mvto_estoque
inner join dbamv.produto pd on pd.cd_produto = ime.cd_produto 
and pd.cd_especie in (19,20) and pd.sn_movimentacao = 'S'
left join dbamv.empresa_produto emp on emp.cd_produto = pd.cd_produto 
and emp.cd_multi_empresa = me.cd_multi_empresa
left join dbamv.reg_fat rf on rf.cd_atendimento = me.cd_atendimento 
left join dbamv.itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat and pd.cd_pro_fat = irf.cd_pro_fat
and irf.cd_mvto = me.cd_mvto_estoque and irf.cd_gru_fat in (5,9)
left join dbamv.pro_fat pf on pf.cd_pro_fat = irf.cd_pro_fat
left join dbamv.gru_fat gf on gf.cd_gru_fat = irf.cd_gru_fat
left join dbamv.itcob_pre icob on icob.cd_reg_fat = irf.cd_reg_fat and icob.cd_lancamento = irf.cd_lancamento
left join dbamv.ent_pro ep on ep.cd_atendimento = rf.cd_atendimento 
left join dbamv.itent_pro iep on iep.cd_ent_pro = ep.cd_ent_pro and iep.cd_produto = pd.cd_produto
where me.dt_mvto_estoque between  '01/12/2023' and '20/12/2023'
and rf.cd_remessa is null 
and me.tp_mvto_estoque not in ('T','X','S','C')
--and irf.cd_reg_fat = 617733
--and me.cd_aviso_cirurgia = 391722
and irf.tp_mvto = 'Faturamento'
and me.cd_multi_empresa = 7 
order by cd_atendimento
)
*/
