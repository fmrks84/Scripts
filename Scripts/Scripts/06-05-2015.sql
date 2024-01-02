select * from dbamv.mov_caixa c where c.cd_lote_caixa = 8304  --and c.cd_doc_caixa is null  and C.VL_MOVIMENTACAO IN (666.66)--(7000.00)--(666.66)--order by c.dt_movimentacao desc for update
select * from dbamv.v_resumo_mov_caixa where cd_lote_caixa = 8304
