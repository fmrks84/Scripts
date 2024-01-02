SELECT SUM(VL_DESCONTO_CONTA) FROM (
SELECT CD_PRO_FAT, VL_DESCONTO_CONTA FROM ITREG_FAT WHERE CD_REG_FAT = 140075 AND VL_DESCONTO_CONTA IS NOT NULL--)

Begin
  Pkg_Mv2000.Atribui_Empresa( 1 );  -->> Trocar a empresa e rodar uma vez para cada empresa
End;




