select a.cd_lote_caixa,
       a.cd_usuario,
       a.cd_caixa,
       a.dt_abertura,
       a.dt_fechamento,
       a.vl_saldo_inicial,
       a.vl_saldo_final,
       a.vl_saldo_dinheiro
       from dbamv.lote_caixa a where a.cd_caixa = 88 
       order by a.dt_fechamento desc 
       for update 
