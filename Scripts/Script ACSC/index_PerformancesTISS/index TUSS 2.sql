CREATE INDEX ind_tuss_10x --- não possui em prod
  ON tuss (
  cd_tip_tuss 
  ,cd_multi_empresa
  ,cd_convenio
  ,dt_inicio_vigencia
  ,dt_fim_vigencia  
  ,cd_pro_fat
  ) COMPUTE STATISTICS  TABLESPACE mv2000_i
/

CREATE INDEX ind_tuss_11x  --- não possui em prod
  ON tuss (
  cd_pro_fat
  ) COMPUTE STATISTICS  TABLESPACE mv2000_i
/
