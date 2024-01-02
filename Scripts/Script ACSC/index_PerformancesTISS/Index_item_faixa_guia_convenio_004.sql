
CREATE INDEX dbamv.ind_it_fxgconv_fx_gui_004_fk
  ON dbamv.item_faixa_guia_convenio (
    cd_faixa_guia,
    nr_guia
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
  LOGGING