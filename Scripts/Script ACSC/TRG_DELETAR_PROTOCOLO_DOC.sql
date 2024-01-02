CREATE OR REPLACE PROCEDURE PRC_ACSC_DELETE_PROTOCOLO
IS
BEGIN
  DELETE FROM it_protocolo_doc
  WHERE cd_protocolo_doc IN (
    SELECT idc.cd_protocolo_doc
    FROM it_protocolo_doc idc
    WHERE TO_DATE(idc.dt_realizacao, 'dd/mm/rrrr') >= TO_DATE('05/07/2023', 'dd/mm/rrrr')
  );

  DELETE FROM protocolo_doc
  WHERE cd_protocolo_doc IN (
    SELECT dc.cd_protocolo_doc
    FROM protocolo_doc dc
    WHERE TO_DATE(dc.dt_Envio, 'dd/mm/rrrr') >= TO_DATE('05/07/2023', 'dd/mm/rrrr')
  );
END;
/


CREATE OR REPLACE TRIGGER TRG_ACSC_DELETE_PROTOCOLO
BEFORE DELETE ON it_protocolo_doc
FOR EACH ROW
DECLARE
BEGIN
  IF TO_DATE(:OLD.dt_realizacao, 'dd/mm/rrrr') >= TO_DATE('05/07/2023', 'dd/mm/rrrr') THEN
    RAISE_APPLICATION_ERROR(-20001, 'Não é possível apagar um protocolo enviado para o setor, solicite ao setor de destino devolver o protocolo:' || :OLD.cd_protocolo_doc || '');
  ELSE
    PRC_ACSC_DELETE_PROTOCOLO; -- Chama a procedure para exclusão
  END IF;
END;
/
