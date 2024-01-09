DECLARE
  v_ds_observacao VARCHAR2(4000); -- ajuste o tamanho conforme necess�rio
BEGIN
  -- Obtenha o valor atual da ds_observacao
  SELECT ds_observacao
  INTO v_ds_observacao
  FROM dbamv.empresa_con_pla
  WHERE cd_convenio = 5 
    AND cd_con_pla IN (548);
   -- AND ROWNUM = 1; -- Para garantir que apenas uma linha seja selecionada

  -- Atualize o valor com a nova informa��o
  V_DS_OBSERVACAO := V_DS_OBSERVACAO ||' - '|| 'ACOMODA��O ENFERMARIA. SE ACOMODA��O APARTAMENTO, VERIFICAR PLANOS CADASTRADOS ACOMODA��O APTO.';

  -- Atualize a tabela original com o novo valor
  UPDATE dbamv.empresa_con_pla
  SET ds_observacao = v_ds_observacao
  WHERE cd_convenio = 5 
    AND cd_con_pla IN (548);
END;
/
commit;

