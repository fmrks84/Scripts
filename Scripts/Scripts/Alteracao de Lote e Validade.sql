select * from lot_pro where cd_lote = 'RJ0378' and cd_produto = 9402
update lot_pro set dt_validade =  '01/01/08' where cd_lote = 'RJ0378' and cd_produto = 9402 and dt_validade = '01/11/08'
delete lot_pro where cd_lot_pro In ( '27058','27376')

select * from itmvto_estoque where cd_produto = 9402 and cd_lote = 'RJ0378' and cd_produto = 9402 --and dt_validade = '01/11/08'
select * from itent_pro where cd_produto = 9402

alter trigger dbamv.trg_U_itmvto_estoque enable
alter trigger dbamv.trg_U_itmvto_estoque disable


alter trigger  dbamv.trg_lanca_ffcv enable
alter trigger dbamv.trg_lanca_ffcv disable

alter trigger dbamv.trg_lot_pro enable
alter trigger dbamv.trg_lot_pro disable


