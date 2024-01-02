SELECT * --DH_REALIZACAO_FECHAMENTO_MES, SN_FECHAMENTO_DO_MES, CD_USUARIO_FECHAMENTO_DO_MES, SN_CONSOLIDACAO, SID, SERIAL, AUDSID, DH_REALIZACAO_CONSOLIDACAO, CD_USUARIO_CONSOLIDACAO
FROM DBAMV.FECHAMENTO_DO_MES WHERE CD_MULTI_EMPRESA = 1
ORDER BY DT_COMPETENCIA DESC


alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss' --- Alterar o formato da data.


Begin
  Pkg_Mv2000.Atribui_Empresa(1);  -->> Trocar a empresa e rodar uma vez para cada empresa (Caso seja Multi-Empresa
End;
