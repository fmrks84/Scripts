select   movConCor.cd_mov_concor
        ,movConCor.ds_movimentacao
        ,movConCor.dt_movimentacao
--        ,movConCor.vl_movimentacao
--        ,movConCor.vl_conciliado

,movConCor.vl_movimentacao
,nvl(movConCor.vl_conciliado,0)
,movConCor.vl_movimentacao - nvl(movConCor.vl_conciliado,0)
    from dbamv.mov_concor movConCor
    where movConCor.cd_con_cor      = 28 -- :DADOS_BANCARIOS.CD_CONTA
      AND ( movConCor.vl_movimentacao - nvl(movConCor.vl_conciliado,0) ) >= Nvl('8873,12',0) - NVL('572,26',0)
      and exists ( select 'x' from dbamv.convenio c
                    where c.cd_fornecedor = movConCor.cd_fornecedor
                      and c.cd_convenio   = 6 )
      and exists ( select 'x' from dbamv.config_financ cfg
                    where cfg.cd_lanca_credito_convenio = movConCor.cd_lan_concor
                      and cfg.cd_multi_empresa = 3 )
    Order by movConCor.dt_movimentacao desc