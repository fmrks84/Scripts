CREATE INDEX dbamv.ind_tiss_guia_10_ix
  ON dbamv.tiss_guia (
    cd_seq_transacao
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_11_ix
  ON dbamv.tiss_guia (
    cd_atendimento
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_12_ix
  ON dbamv.tiss_guia (
    cd_atendimento,
    cd_reg_amb
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_13_ix
  ON dbamv.tiss_guia (
    cd_atendimento,
    cd_reg_fat
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_14_ix
  ON dbamv.tiss_guia (
    cd_remessa
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_15_ix
  ON dbamv.tiss_guia (
    cd_reg_fat
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_1_ix
  ON dbamv.tiss_guia (
    nr_registro_operadora_ans,
    nm_xml,
    nr_guia_operadora
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_2_ix
  ON dbamv.tiss_guia (
    nr_registro_operadora_ans,
    nr_guia_operadora,
    dt_emissao
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_3_ix
  ON dbamv.tiss_guia (
    nm_xml
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_4_ix
  ON dbamv.tiss_guia (
    nr_guia
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_5_ix
  ON dbamv.tiss_guia (
    cd_guia
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_6_ix
  ON dbamv.tiss_guia (
    nr_lote
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_7_ix
  ON dbamv.tiss_guia (
    id_pai
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_8_ix
  ON dbamv.tiss_guia (
    cd_convenio
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/

CREATE INDEX dbamv.ind_tiss_guia_9_ix
  ON dbamv.tiss_guia (
    cd_remessa_glosa
  )
  TABLESPACE mv2000_i
  STORAGE (
    NEXT       1024 K
  )
/