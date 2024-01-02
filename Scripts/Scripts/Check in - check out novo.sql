--select d.sn_mal , d.dh_mal, d.us_mal from dbamv.hmsj_checkin_movimentacao d where d.cd_mov = 15250 for update
select status from dbamv.hmsj_checkin_movimentacao m
where m.cd_mov in (38064,38090,38098) for update
