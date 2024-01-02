select sum(vl_total_conta) from reg_Fat a where a.cd_remessa = 484559;

select sum(b.vl_total_conta) from reg_fat b where b.cd_remessa = 484559;

select SUM(C.VL_TOTAL_CONTA) from itreg_fat c where c.cd_reg_fat in (select b.cd_reg_fat from reg_fat b where b.cd_remessa = 484559)
and c.sn_pertence_pacote = 'N';

select sum(to_number(d.vl_tot_geral,'999999.99'))  from tiss_guia d where d.cd_remessa = 484559;

--select * from tiss_itguia e where e.id_pai = '24302386'

select * from reg_Fat a where a.cd_remessa = 484559;
