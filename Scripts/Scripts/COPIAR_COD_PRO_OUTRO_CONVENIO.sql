-- Script para copiar Tabela COD_PRO de Procedimentos que come�am com '08,07'para outro conv�nio
-- Na linha 03 contando da declara��o ( Declare ) Trocar o n�mero do conv�nio origem , neste exemplo n�mero 3
-- Na linha 09 contando da declara��o ( Declare ) trocar o c�digo 318 para o conv�nio destino, ap�s o campo x.CD_PRO_FAT
Declare
Cursor origem is
Select * from dbamv.cod_pro c where c.cd_convenio = 318
and substr(c.cd_pro_fat,1,2)='07';
Begin
    For x in origem Loop
        insert into dbamv.cod_pro(CD_PRO_FAT,CD_CONVENIO,DS_CODIGO_COBRANCA,DS_NOME_COBRANCA,
        DS_UNIDADE_COBRANCA,TP_ATENDIMENTO,CD_MULTI_EMPRESA,CD_COD_PRO) values
        (x.CD_PRO_FAT,342,x.DS_CODIGO_COBRANCA,x.DS_NOME_COBRANCA,
        x.DS_UNIDADE_COBRANCA,x.TP_ATENDIMENTO,x.CD_MULTI_EMPRESA,dbamv.SEQ_COD_PRO.NEXTVAL);
    End loop;
End;
/
