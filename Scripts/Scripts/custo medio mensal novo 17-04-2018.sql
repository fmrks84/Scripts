--- custo medio mensal
Begin
      -- Custo Médio Mensal
      dbamv.pkg_mv2000.atribui_empresa(1);

      dbamv.pkg_mges_custo_medio.prc_geracao_custo_medio ( trunc(to_date('01/03/2018','DD/MM/YYYY'),'MM' ));
      Dbamv.Pkg_Mges_Consolida.Pr_Apaga_C_Conest(03,2018);
      Dbamv.Pkg_Mges_Consolida.Pr_Estoque_Inicial(03,2018);
      dbamv.Pr_Copia_Custo_Medio_temp (to_date('01/03/2018','dd/mm/yyyy'), to_date('31/03/2018','dd/mm/yyyy'));
      Dbamv.Pkg_Mges_Consolida.Pr_Consolidacao (03,2018,'N');
      Dbamv.Pkg_Mges_Consolida.Pr_Ajusta_Consolidacao (03,2018);
End;
