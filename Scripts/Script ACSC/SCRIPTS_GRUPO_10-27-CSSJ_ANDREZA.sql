
select 
*
from
(
select 
atd.cd_multi_empresa,
rf.cd_convenio,
convx.nm_convenio,
'INTERNADOS'TIPO_CONTA,
atd.cd_atendimento,
rf.cd_reg_fat conta,
rf.cd_remessa,
rm.sn_fechada,
to_char(ft.dt_competencia,'mm/rrrr')comp_fatura,
rm.dt_prevista_para_pgto,
irf.cd_pro_fat,
pf.ds_pro_fat,
irf.sn_pertence_pacote, 
irf.qt_lancamento,
to_date(irf.dt_lancamento,'dd/mm/rrrr')dt_lancamento,
irf.vl_unitario,
irf.vl_total_conta
--irf.cd_conta_pacote,
--cpt.cd_pacote,


from 
atendime atd 
inner join reg_Fat rf on rf.cd_atendimento = atd.cd_atendimento and atd.cd_multi_empresa = 3 --and atd.cd_convenio = 98 
inner join itreg_Fat irf on irf.cd_reg_fat = rf.cd_reg_fat 
inner join pro_Fat pf on pf.cd_pro_fat = irf.cd_pro_fat and pf.cd_gru_pro in (10,27) and pf.sn_ativo = 'S'
left join conta_pacote cpt on cpt.cd_conta_pacote = irf.cd_conta_pacote 
left join pacote pc on pc.cd_pacote = cpt.cd_pacote
left join pro_fat pfx on pfx.cd_pro_fat = pc.cd_pro_fat_pacote
inner  join remessa_fatura rm on rm.cd_remessa = rf.cd_remessa 
inner join fatura ft on ft.cd_fatura = rm.cd_fatura 
inner join convenio convx on convx.cd_convenio = rf.cd_convenio
--left join itreg_Fat irfx on irfx.cd_reg_fat = irf.cd_reg_fat and irf.cd_pro_fat = pc.cd_pro_fat_pacote
where rf.cd_remessa is not null
--and irf.cd_reg_fat = 582465
--and irf.cd_pro_fat in (40402045,10001335)
--order by rf.cd_reg_fat, trunc(irf.dt_lancamento), irf.cd_pro_fat
UNION ALL 

select 
atdx.cd_multi_empresa,
ramb.cd_convenio,
conv.nm_convenio,
'AMBULATORIAL'TIPO_CONTA,
atdx.cd_atendimento,
ramb.cd_reg_amb conta,
rMX.cd_remessa,
rmx.sn_fechada,
to_char(ftx.dt_competencia,'mm/rrrr')comp_fatura,
rmx.dt_prevista_para_pgto,
iramb.cd_pro_fat,
pfx.ds_pro_fat,
iramb.sn_pertence_pacote, 
iramb.qt_lancamento,
to_date(iramb.hr_lancamento,'dd/mm/rrrr')dt_lancamento,
iramb.vl_unitario,
iramb.vl_total_conta


from 
atendime atdx
inner join itreg_amb iramb on atdX.cd_atendimento = iramb.cd_atendimento and atdx.cd_multi_empresa = 3-- and atdx.cd_convenio = 98 
inner join reg_amb ramb on ramb.cd_reg_amb = iramb.cd_reg_amb 
inner join pro_Fat pfx on pfx.cd_pro_fat = iramb.cd_pro_fat and pfx.cd_gru_pro in (10,27) and pfx.sn_ativo = 'S'
left join conta_pacote cptx on cptx.cd_conta_pacote = iramb.cd_conta_pacote 
left join pacote pcx on pcx.cd_pacote = cptx.cd_pacote
left join pro_fat pfxx on pfxx.cd_pro_fat = pcx.cd_pro_fat_pacote
inner  join remessa_fatura rmx on rmx.cd_remessa = ramb.cd_remessa 
inner join fatura ftx on ftx.cd_fatura = rmx.cd_fatura 
inner join convenio conv on conv.cd_convenio = ramb.cd_convenio
where  ramb.cd_remessa is not null 
--order by ramb.cd_reg_amb,to_char(iramb.hr_lancamento,'dd/mm/rrrr'), iramb.cd_pro_fat
)
where cd_convenio not in (102,43)
order by cd_convenio,conta, dt_lancamento, cd_pro_fat

---select * from empresa_convenio where cd_convenio = 68
--
--select trunc(sysdate,'mm/rrrr') from dual 
