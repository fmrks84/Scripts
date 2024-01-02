select * from dbamv.lote_caixa a where a.cd_lote_caixa = 12537
--10/05/2019 18:19:03
DELETE from dbamv.Mov_Caixa b where b.cd_lote_caixa = 12537 and b.cd_mov_caixa in (852570,852566)--;
delete from dbamv.reccon_rec c where c.cd_reccon_rec = 588583--;
select * from dbamv.itcon_rec d where /*to_char (d.dt_vencimento)> = '01/05/2019' and d.tp_quitacao = 'L' ORDER BY D.DT_VENCIMENTO DESC*/ d.cd_con_rec IN (576421,567085) for update ;
select * from dbamv.con_Rec e where e.cde.cd_con_rec = 576421;
select * from dbamv.nota_fiscal f where f.cd_nota_fiscal = 369161
