select DT_EMISSAO, DT_ENTRADA, HR_ENTRADA, CD_ESTOQUE from ent_pro where cd_ent_pro in (5523)

SELECT DT_MVTO_ESTOQUE, HR_MVTO_ESTOQUE FROM MVTO_ESTOQUE WHERE CD_MVTO_ESTOQUE = 75
alter trigger dbamv.trg_D_itmvto_estoque enable
alter trigger dbamv.trg_D_itmvto_estoque disable

SELECT CD_LINHA, cd_contagem, cd_produto, qt_estoque FROM ITCONTAGEM WHERE CD_PRODUTO IN (53602) ---(53706,53707,53709,53714,53715)
delete itcontagem WHERE CD_PRODUTO IN (53602) AND CD_LINHA = 1
alter trigger dbamv.trg_I_itcontagem enable
alter trigger dbamv.trg_I_itcontagem disable

SELECT * FROM ITCONTAGEM 


alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss'


delete from ENT_pro where cd_ENT_PRO IN (2174) 
select cd_produto, qt_movimentacao from itMVTO_ESTOQUE WHERE CD_MVTO_ESTOQUE IN (226967) 

alter trigger  dbamv.trg_lanca_ffcv enable
alter trigger dbamv.trg_lanca_ffcv disable
alter trigger dbamv.trg_u_iTMVTO_ESTOQUE enable
alter trigger dbamv.trg_u_iTMVTO_ESTOQUE disable
alter trigger dbamv.trg_d_iTLOTENT_PRO enable
alter trigger dbamv.trg_d_iTLOTENT_PRO disable
alter trigger dbamv.trg_d_iTENT_PRO enable
alter trigger dbamv.trg_d_iTENT_PRO disable

DELETE FROM SOLSAI_PRO WHERE CD_SOLSAI_PRO IN (535745,519771) 

select qt_estoque_atual, cd_produto, cd_estoque from  est_pro where cd_produto in (53602)
