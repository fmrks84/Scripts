CREATE OR REPLACE TRIGGER TRG_HNB_DEL_LOG_CONSOLIDACAO
BEFORE DELETE ON LOG_ERRO_ENT_PRO
FOR EACH ROW
BEGIN
DELETE FROM LOG_ERRO_ENT_PRO
       WHERE LOG_ERRO_ENT_PRO.DT_LOG =: NEW.DT_LOG;

END;
