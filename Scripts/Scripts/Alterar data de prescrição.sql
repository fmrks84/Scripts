SELECT DT_PRE_MED, HR_PRE_MED, DT_VALIDADE, DT_REFERENCIA, DH_CRIACAO, DH_IMPRESSAO  FROM PRE_MED WHERE CD_PRE_MED = 897911

SELECT * FROM PRE_MED WHERE CD_PRE_MED = 897911

SELECT * FROM ITPRE_MED WHERE CD_PRE_MED = 897911

SELECT * FROM REG_FAT

Begin
  Pkg_Mv2000.Atribui_Empresa( 1 );  -->> Trocar a empresa e rodar uma vez para cada empresa
End;


alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss' --- Alterar o formato da data.
