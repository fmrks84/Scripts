CREATE INDEX dbamv.ind_cf_tiss_conv_apr_pcd_2_ix
  ON dbamv.config_tiss_conv_aprs_pcd (
    cd_convenio,
    sn_ativo_apr_proced
  ) COMPUTE STATISTICS  TABLESPACE mv2000_i
/
