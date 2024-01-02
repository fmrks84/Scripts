select * from dbamv.con_Rec a where a.cd_con_rec in (416043,416062,416030,416040)for update 
select * from dbamv.itcon_rec b where b.cd_con_rec in (416043,416062,416030,416040)
select * from dbamv.reccon_rec c where c.cd_itcon_rec in (418723,418733,418736,418755)
select * from dbamv.rat_conrec d where d.cd_con_rec = 
select * from dbamv.lcto_contabil e where e.cd_lcto_contabil = 
--select cd_remessa , cd_reg_amb , cd_multi_empresa from dbamv.reg_amb where cd_reg_amb IN (920483,920495,920498,920504)for update

select * from dbamv.mov_caixa z1 where z1.cd_mov_caixa in (653783,653822,653825,653841)for update 
--LOTE 51054 - 8852473,136312 - 416030
--LOTE       - 8852471,136311 - 416043
--LOTE      - 8852472 ,136310 - 416062
--LOTE      - 8852819 ,136309 - 416040      

---- 136312 - 416030
---- 136310 - 416062
---- 136309 - 416040
---- 136311 - 416043
