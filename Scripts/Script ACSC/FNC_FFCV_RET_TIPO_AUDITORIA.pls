
CREATE OR REPLACE FUNCTION dbamv.fnc_ffcv_ret_tipo_auditoria (
    nconta     IN NUMBER,
    ncdatend   IN NUMBER,
    ncdlanc    IN NUMBER,
    ntpconta   IN VARCHAR2
) RETURN VARCHAR2 IS

    CURSOR ccursor IS
        SELECT
            cd_auditoria_conta,
            cd_usuario_cancelou,
            dt_cancelou,
            qt_lancamento_ant,
            qt_lancamento,
            vl_percentual_multipla,
            vl_percentual_multipla_ant,
            vl_total_conta_ant,
            vl_total_conta
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
            dt_cancelou,
            qt_lancamento_ant,
            qt_lancamento,
            vl_percentual_multipla,
            vl_percentual_multipla_ant,
            vl_total_conta_ant,
            vl_total_conta
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
            vccursor.cd_auditoria_conta IS NOT NULL
        AND
            vccursor.cd_usuario_cancelou IS NULL
        AND
            vccursor.dt_cancelou IS NULL
    THEN
        IF
            nvl(
                vccursor.qt_lancamento_ant,
                0
            ) = 0 AND nvl(
                vccursor.qt_lancamento,
                0
            ) > 0
        THEN
            vvalret := 'I';
        ELSIF nvl(
            vccursor.qt_lancamento_ant,
            0
        ) > 0 AND nvl(
            vccursor.qt_lancamento,
            0
        ) = 0 THEN
            vvalret := 'E';
        ELSIF ( nvl(
            vccursor.qt_lancamento_ant,
            0
        ) <> nvl(
            vccursor.qt_lancamento,
            0
        ) ) OR ( nvl(
            vccursor.vl_percentual_multipla,
            0
        ) <> nvl(
            vccursor.vl_percentual_multipla_ant,
            0
        ) ) OR ( nvl(
            vccursor.vl_total_conta_ant,
            0
        ) <> nvl(
            vccursor.vl_total_conta,
            0
        ) ) THEN
            vvalret := 'A';
        END IF;
    END IF;
   --

    RETURN vvalret;
END;
/

GRANT EXECUTE ON dbamv.fnc_ffcv_ret_tipo_auditoria TO dbaps;
GRANT EXECUTE ON dbamv.fnc_ffcv_ret_tipo_auditoria TO dbasgu;
GRANT EXECUTE ON dbamv.fnc_ffcv_ret_tipo_auditoria TO mv2000;
GRANT EXECUTE ON dbamv.fnc_ffcv_ret_tipo_auditoria TO mvintegra;
