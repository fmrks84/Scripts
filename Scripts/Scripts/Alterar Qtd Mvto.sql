select * from itmvto_estoque where cd_produto =
and cd_mvto_estoque in ()

alter trigger dbamv.trg_U_itmvto_estoque enable
alter trigger dbamv.trg_U_itmvto_estoque disable


alter trigger  dbamv.trg_lanca_ffcv enable
alter trigger dbamv.trg_lanca_ffcv disable

select cd_uni_pro from itent_pro where cd_ent_pro = 1135
alter trigger dbamv.trg_U_itent_pro enable
alter trigger dbamv.trg_U_itent_pro disable
