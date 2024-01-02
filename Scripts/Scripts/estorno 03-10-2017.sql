/*select * from dbamv.mov_caixa a where a.cd_lote_caixa = 10382  
and a.cd_mov_caixa = 713241 for update 

select * from dbamv.lote_caixa a where a .cd_lote_caixa = 10382--;
select * from dbamv.mov_caixa b where b.cd_lote_caixa = 10382
and b.ds_mov_caixa like '%MARINA SCANDIZZO LEITE%'--;
select * from dbamv.mov_concor c where c.cd_mov_caixa = 713160--713241
select * from dbamv.caixa d where d.cd_caixa = 88
select * from dbamv.'MARINA SCANDIZZO LEITE'*/

select * from dbamv.con_Rec a where a.cd_con_rec in (469862); -- 469862
select * from dbamv.itcon_rec b where b.cd_con_rec in (469862); -- 
select * from dbamv.reccon_rec c where c.cd_itcon_rec in (474027,473774) for update ;

select * from dbamv.nota_fiscal d where d.cd_nota_fiscal = 288570;

select * from dbamv.mov_caixa b where b.cd_lote_caixa = 10382
and b.ds_mov_caixa like '%MARINA SCANDIZZO LEITE%' for update;


