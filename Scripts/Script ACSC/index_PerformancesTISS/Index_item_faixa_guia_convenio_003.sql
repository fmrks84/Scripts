
CREATE INDEX dbamv.ind_it_fxgconv_fx_gui_003_fk
  ON dbamv.item_faixa_guia_convenio (
    cd_faixa_guia,
    nr_sequencia
  )
  TABLESPACE mv2000_i
  STORAGE (
    INITIAL     128 K
    NEXT       1024 K
  )
  LOGGING