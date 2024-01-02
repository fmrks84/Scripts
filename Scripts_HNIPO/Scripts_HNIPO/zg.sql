select * from VW_ZG_LOTE_POR_REMESSA a where a.remessa = 464794
select * from vw_zg_valores_faturados c where c.remessa = 464794
select * from vw_zg_resumo_quitacao d where d.remessa = 464794
select sum(e.vl_itfat_nf) from itfat_nota_fiscal e where e.cd_remessa = 464794
select * from nota_fiscal where cd_nota_fiscal = 685356
select * from 
