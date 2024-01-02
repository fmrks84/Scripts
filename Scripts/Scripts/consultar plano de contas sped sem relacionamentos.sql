

SELECT DISTINCT Pl.cd_reduzido
              ,Pl.Cd_Contabil
              ,Pl.Ds_Conta
FROM dbamv.plano_contas pl
    ,dbamv.config_contabil cc
    ,(   SELECT MIN( Dt_Lcto ) Dt_Lanca
                ,cd_reduzido_debito cd_reduzido
            FROM dbamv.lcto_contabil
          WHERE cd_reduzido_debito IS NOT NULL
        GROUP BY cd_reduzido_debito
        UNION
          SELECT MIN( Dt_Lcto ) Dt_Lanca
                ,cd_reduzido_credito cd_reduzido
            FROM dbamv.lcto_contabil
          WHERE cd_reduzido_credito IS NOT NULL
        GROUP BY cd_reduzido_credito ) lcto
WHERE SUBSTR( Pl.cd_contabil, 1, 1 ) = cc.Cd_Contabil
  AND Pl.Cd_multi_empresa = cc.Cd_multi_Empresa
  AND Pl.Cd_reduzido = lcto.cd_reduzido(+)
  AND Pl.Cd_Multi_empresa = 1  --p_cd_multi_empresa
  AND TRUNC( NVL( Lcto.Dt_Lanca, TO_DATE( to_date('01/01/2016','dd/mm/yyyy'), 'dd/mm/yyyy' ) ) ) <= TO_DATE( to_date('31/12/2016','dd/mm/yyyy'), 'dd/mm/yyyy' )
  AND pl.tp_conta = 'A'
  AND pl.sn_ativo <> 'N'
  AND NOT EXISTS (SELECT 'x' FROM dbamv.PLANO_CONTAS_REF_SPED ps
                  WHERE PS.cd_reduzido = pl.cd_reduzido
                    AND LPAD(PS.cd_liga_ref_sped,2,'00') = (Select NR_PLANO_CONTAS From dbamv.MULTI_EMPRESAS where cd_multi_empresa = 1)  --p_cd_multi_empresa)
                    AND PS.dt_validade_inicio = (SELECT Max(ps2.dt_validade_inicio)
                                                    FROM dbamv.PLANO_CONTAS_REF_SPED ps2
                                                    WHERE PS2.cd_reduzido = ps.cd_reduzido
                                                      AND PS2.cd_liga_ref_sped = PS.cd_liga_ref_sped
                                                      AND Trunc(PS2.dt_validade_inicio,'YYYY') <= TO_DATE( to_date('01/01/2016','dd/mm/yyyy'), 'dd/mm/yyyy' )))
GROUP BY Pl.cd_reduzido
    ,Pl.Cd_Contabil
    ,Pl.Ds_Conta
ORDER BY Pl.Cd_Contabil;
