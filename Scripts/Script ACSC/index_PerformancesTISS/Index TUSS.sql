CREATE INDEX dbamv.ind_tuss_14_ix
  ON dbamv.tuss (
    cd_tuss,
    cd_tip_tuss
  )
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tuss_15_ix
  ON dbamv.tuss (
    cd_tip_tuss,
    cd_tuss
  )
  STORAGE (
    NEXT       1024 K
  )
/