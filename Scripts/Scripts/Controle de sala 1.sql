select * from sacr_pendencia_origem
WHERE CD_PENDENCIA_SALA IN (select CD_PENDENCIA_SALA from dbamv.sacr_pendencia_sala
WHERE CD_SALA = 6
AND TP_SITUACAO NOT IN ('LIB','FINAL'))
AND DH_MEDICACAO <= '26/12/2016'
