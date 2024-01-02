--PROMPT CREATE OR REPLACE FUNCTION dbamv.fnc_ffcv_ret_auditoria
CREATE OR REPLACE FUNCTION dbamv.fnc_ffcv_ret_auditoria (
    nconta     IN NUMBER,
    ncdatend   IN NUMBER,
    ncdlanc    IN NUMBER,
    ntpconta   IN VARCHAR2
) RETURN VARCHAR2 IS

    CURSOR ccursor IS
        SELECT
            cd_auditoria_conta,
            cd_usuario_cancelou,
            dt_cancelou
        FROM
            dbamv.auditoria_conta
        WHERE
                ntpconta = 'H'
            AND
                cd_reg_fat = nconta
            AND
                cd_atendimento = ncdatend
            AND
                cd_lancamento_fat = ncdlanc
        UNION ALL
        SELECT
            cd_auditoria_conta,
            cd_usuario_cancelou,
            dt_cancelou
        FROM
            dbamv.auditoria_conta
        WHERE
                ntpconta = 'A'
            AND
                cd_reg_amb = nconta
            AND
                cd_atendimento = ncdatend
            AND
                cd_lancamento_amb = ncdlanc
        ORDER BY cd_auditoria_conta DESC;

    vccursor   ccursor%rowtype;
    vvalret    VARCHAR2(1) := NULL;
BEGIN
   --
    vccursor := NULL;
   --
    OPEN ccursor;
    FETCH ccursor INTO vccursor;
    CLOSE ccursor;
   --
    IF
        (
            vccursor.cd_usuario_cancelou IS NOT NULL
        OR
            vccursor.dt_cancelou IS NOT NULL
        ) AND
            vccursor.cd_auditoria_conta IS NOT NULL
    THEN
        vvalret := 'N';
    ELSIF
        vccursor.cd_auditoria_conta IS NOT NULL
    AND
        vccursor.cd_usuario_cancelou IS NULL
    AND
        vccursor.dt_cancelou IS NULL
    THEN
        vvalret := 'S';
    ELSE
        vvalret := 'N';
    END IF;
   --

    RETURN vvalret;
END;
/

GRANT EXECUTE ON dbamv.fnc_ffcv_ret_auditoria TO dbaps;
GRANT EXECUTE ON dbamv.fnc_ffcv_ret_auditoria TO dbasgu;
GRANT EXECUTE ON dbamv.fnc_ffcv_ret_auditoria TO mv2000;
GRANT EXECUTE ON dbamv.fnc_ffcv_ret_auditoria TO mvintegra;
