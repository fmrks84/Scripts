select
/* decode (row_number()over (partition by rf.cd_atendimento order by G.CD_AVISO_CIRURGIA),1,'AMOSTRA:', G.CD_AVISO_CIRURGIA) AVISO,
 */
rf.cd_convenio,
conv.nm_convenio,
rf.cd_atendimento,
rf.cd_reg_fat,
pf.cd_pro_fat,
pf.ds_pro_fat,
to_date(irf.dt_lancamento,'dd/mm/rrrr')DT_LANCAMENTO,
pf.cd_gru_pro,
gp.ds_gru_pro,
irf.qt_lancamento, 
irf.vl_unitario VL_UNITARIO_item,
irf.vl_total_conta vl_total_item,
RF.VL_TOTAL_CONTA VL_TOTAL_CONTA,
rf.cd_remessa,
to_char(ft.dt_competencia,'mm/rrrr')comp_remessa,
decode (IRF.SN_PERTENCE_PACOTE , 'S','SIM','NAO')PERTENCE_PACOTE
from
gru_pro gp
inner join pro_Fat pf on pf.cd_gru_pro = gp.cd_gru_pro and pf.sn_opme = 'S'and pf.sn_ativo = 'S'
inner join itreg_Fat irf on irf.cd_pro_fat = pf.cd_pro_fat
inner join reg_Fat rf on rf.cd_reg_fat = irf.cd_reg_fat
inner join guia g on g.cd_atendimento = rf.cd_atendimento and g.cd_guia = irf.cd_guia and g.tp_guia = 'O'
left join  remessa_Fatura rm on rm.cd_remessa = rf.cd_remessa
left join fatura ft on ft.cd_fatura = rm.cd_fatura
inner join convenio conv on conv.cd_convenio = rf.cd_convenio
where to_date(irf.dt_lancamento,'dd/mm/rrrr') between '01/10/2023' and '20/10/2023'
and gp.cd_gru_pro in (9,89,96)  -- 9  ORTESES , PROTESES E SINTESES (OPS)
                                  --89  MATERIAL ESPECIAL
                                  --96  MATERIAL ESPECIAL DESCONTINUADO

and rf.cd_multi_empresa = 7
--and rf.cd_atendimento = 5544347
--and rf.cd_reg_fat = 602180
--and irf.cd_pro_fat = 00157167
order by rf.cd_reg_fat,irf.dt_lancamento

