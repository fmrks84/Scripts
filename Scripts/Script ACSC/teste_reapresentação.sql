select * from repasse where cd_repasse = 70169
select * from it_repasse where cd_repasse = 70169 and cd_prestador = 965 --order by 3
select * from repasse_prestador y where y.cd_repasse = 70169 and y.cd_prestador = 965
select * from con_pag x where x.cd_con_pag = 1035766 --557907,97 -- 578518,43
select * from itcon_pag where cd_con_pag = 1035766;
select * from pagcon_pag where cd_itcon_pag = 1035766


select * from con_pag a
inner join itcon_pag b on b.cd_con_pag = a.cd_con_pag  
where a.cd_processo = 26572 and a.cd_multi_empresa = 7 
and b.tp_quitacao = 'C'
and a.cd_con_pag = 1035066
order by a.cd_con_pag , a.vl_bruto_conta desc 

/*select * from repasse_prestador where cd_con_pag = 1037813
select * from it_repasse where cd_repasse = 70169 and cd_prestador in (5379,664,8175)
select * from repasse where cd_repasse = 70169*/

select * from repasse_prestador where cd_con_pag = 1035766;
select * from empresa_prestador where cd_prestador = 25391
select * from it_repasse where cd_repasse = 70169 and cd_prestador in (965)and cd_reg_fat = 329525;
select * from repasse where cd_repasse = 70169;
select * from empresa_prestador where cd_prestador = 25391
select 


select * from con_pag where cd_con_pag = 1034231;
select * from itcon_pag where cd_con_pag = 1034231

select cd_remessa, cd_multi_empresa from reg_Fat where cd_reg_fat = 329525;
--select * from reg_amb where cd_remessa = 226530
select rem.cd_remessa, ft.cd_fatura , ft.cd_convenio , ft.dt_competencia from remessa_fatura rem inner join fatura ft on ft.cd_fatura = rem.cd_fatura where cd_remessa = 227674
select * from itfat_nota_fiscal where cd_remessa = 227674
select * from nota_fiscal where cd_nota_fiscal = 374882
select cd_pro_fat, cd_prestador, qt_lancamento , vl_unitario , vl_total_conta  from itreg_Fat where cd_reg_fat = 329525 and cd_lancamento in (63,253,276,335);
--select w.cd_reg_fat, w.cd_lancamento, w.cd_prestador , w.vl_ato , w.vl_base_repassado from itlan_med w where w.cd_reg_fat = 322775 and w.cd_lancamento in (63,253,276,335) and w.cd_prestador = 965;

select * from con_rec where cd_con_Rec = 827766

