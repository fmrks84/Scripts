--select * from dbamv.tiss_guia g where g.cd_atendimento = 1099537 for update
select x.id, x.id_pai, x.nm_xml, x.nr_guia from dbamv.tiss_sol_guia x where x.cd_paciente = 604171  for update
select cd_atendimento, cd_reg_Fat , cd_remessa, a.nr_guia from dbamv.tiss_guia a where nr_guia in '00885038' for update--'5414820'--'06657514'--'06611919' '06661549'// 
select * from dbamv.tiss_nr_guia xx where  xx.nr_guia = '04872744'--cd_atendimento in (1214289)
select * from dbamv.tiss_guia where nr_guia in ('04872744') for update -- 2252.50
select * from dbamv.tiss_guia where nm_prestador_sol = 'TELMA REGINA MENDES GONCALVES'
select * from dbamv.atendime a where a.CD_ATENDIMENTO in (1303579)
selct * from dbamv.in
update dbamv.tiss_sol_guia set nr_guia = '04739828'  where nr_guia = '04739827'

select * from dbamv.prestador_externo x where x.nm_paciente = ''
--------------------------------------------------------------------------------------------
select * from dbamv.reg_Fat where cd_atendimento in (1074804,1062135)		               			               
select f.cd_pro_fat , f.cd_prestador, f.cd_reg_fat from dbamv.itreg_Fat f where f.cd_reg_fat in (965475
,965447
,965563
,965341
,976936
,976634
,976674)

and f.cd_pro_fat = '20010141' for update      

select * from dbamv.tiss_guia where cd_reg_amb = 697028

select * from dbamv.guia where cd_atendimento = 1126211

select * from dbamv.aviso_cirurgia z where z.CD_AVISO_CIRURGIA = 287091
select * from dbamv.itlan_med where CD_REG_FAT in (1319244,1319244)
and cd_prestador in (2780,9992)
and 
for update
select * from dbamv.ITreg_fat where cd_reg_Fat = 1173754 AND -CD_PRO_fAT = '11000043' --cd_remessa = 67905 for update
select * from dbamv.remessa_fatura where cd_remessa_pai = 70837  for update
select  from dbamv.ITreg_Fat where cd_reg_Fat = 1031202 

select * from dbamv.Pro_Fat WHERE CD_PRO_FAT = '00049999'
select * from dbamv.Reg_Fat where cd_Reg_FAt = 1097771

select * from dbamv.itreg_fat f1 
where f1.cd_reg_fat = 1319245
and f1.cd_prestador = 2780
and f1.cd_ati_med is null
for update



select * from dbamv.itlan_med x1 where x1.cd_reg_fat
 
select * from dbamv.itreg_Fat fa where fa.cd_reg_fat in (1326031,1326032)
and fa.cd_prestador = 2780
and fa.cd_ati_med is null
for update 
