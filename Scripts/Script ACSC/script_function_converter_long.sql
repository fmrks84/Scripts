CREATE OR REPLACE FUNCTION get_observation(
    p_cd_convenio IN NUMBER,
    p_cd_con_pla IN NUMBER
) RETURN VARCHAR2
AS
    v_observation VARCHAR2(30000);
    CURSOR c_observation IS
        SELECT ds_observacao
        FROM dbamv.con_pla_obs
        WHERE cd_convenio = p_cd_convenio
        AND cd_con_pla = p_cd_con_pla;
BEGIN
    OPEN c_observation;
    FETCH c_observation INTO v_observation;
    CLOSE c_observation;

    RETURN v_observation;
END;

