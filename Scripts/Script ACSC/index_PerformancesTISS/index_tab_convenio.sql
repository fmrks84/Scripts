CREATE INDEX dbamv.tab_conv_vigencia_ix
  ON dbamv.tab_convenio (
    cd_convenio,
    cd_con_pla,
    cd_pro_fat,
    cd_multi_empresa,
    dt_vigencia
  ) COMPUTE STATISTICS TABLESPACE mv2000_i
/
