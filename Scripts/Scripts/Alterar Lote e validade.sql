select cd_produto, cd_especie, ds_produto, sn_controle_validade, sn_padronizado, sn_pscotropico, sn_medicamento, SN_LOTE from produto
where tp_ativo = 'S'
and cd_produto  in (54846,54850,53702,54615)
--and sn_controle_validade = 'S'
and sn_movimentacao = 'S'

select cd_lot_pro, cd_estoque, cd_produto, dt_validade, qt_estoque_atual from lot_pro where cd_produto  in (54846,54850,53702,54615)
 and qt_estoque_atual > 0

--alter trigger dbamv.trg_lot_pro enable
--alter trigger dbamv.trg_lot_pro disable


select * from produto where cd_produto = 54615
