DROP PROCEDURE DBAMV.ZG_SETA_PROTOCOLO_ENVIO;
COMMIT
;
CREATE OR REPLACE PROCEDURE ZG_SETA_PROTOCOLO_ENVIO(
    id_tiss_mensagem NUMBER,
    numero_protocolo STRING
)
IS
    BEGIN
        UPDATE tiss_mensagem
        SET nr_protocolo_retorno = numero_protocolo
        WHERE id = id_tiss_mensagem;
        EXCEPTION
        WHEN OTHERS
        THEN
        ROLLBACK;
        RAISE;
    END ZG_SETA_PROTOCOLO_ENVIO;

