select cd_leito, ds_leito, setor.cd_multi_empresa, count(cd_leito)
  from dbamv.leito, dbamv.unid_int, dbamv.setor, hmsj_leito_mae_rn
where unid_int.cd_setor = setor.cd_setor
   and leito.cd_unid_int = unid_int.cd_unid_int
   and setor.sn_ativo = 'S'
   and unid_int.sn_ativo = 'S'
   and sn_codigo_de_barras = 'N'
   and hmsj_leito_mae_rn.cd_leito_mae = leito.cd_leito
group by cd_leito, ds_leito, setor.cd_multi_empresa
order by setor.cd_multi_empresa
