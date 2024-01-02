SELECT cd_setor,CD_REDUZIDO,CD_ITEM_RES,VL_RATEIO,NR_LINHA,CD_CON_REC
FROM DBAMV.RAT_CONREC
WHERE CD_CON_REC = 114289 



select cd_reduzido from dbamv.con_rec where cd_con_rec = 114289






select *
from dbamv.lcto_contabil
where cd_lote = 3367
and cd_lcto_movimento in( 420208,420207)
