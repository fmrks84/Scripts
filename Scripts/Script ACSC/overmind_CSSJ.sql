select * from pro_fat where cd_pro_fat in ('41001095',
'41101170', 
'41101189')
;
select * from exa_Rx x where x.exa_rx_cd_pro_fat in (select cd_pro_fat from pro_fat where cd_pro_fat in ('41001095',
'41101170', 
'41101189'))
and x.sn_ativo = 'S'


select * from dbamv.vw_ovmd_guia_sadt_eletivo

select * from item_agendamento it where it.cd_exa_rx in (select x.cd_exa_rx from exa_Rx x where x.exa_rx_cd_pro_fat in 
(select cd_pro_fat from pro_fat where cd_pro_fat in ('41001095',
'41101170', 
'41101189'))
and x.sn_ativo = 'S')

