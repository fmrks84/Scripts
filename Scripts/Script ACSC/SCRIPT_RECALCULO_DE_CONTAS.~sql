DECLARE
cmserro VARCHAR2(30000);
BEGIN

dbamv.pkg_mv2000.atribui_empresa(4);
--conta ambulatorial
dbamv.pack_ffcv.valores_conta_ambula(3828294 , --conta(obrigatorio)
                                     cmserro , --msg(retorno)
                                     4610482 , --atendimento(obrigatorio)
                                     null  ); --cd lancamento(opcional)
/*--conta hospitalar
dbamv.pack_ffcv.PROC_VALORIZACAO(316911 ,  --conta(obrigatorio)
                                 cmserro,  --msg(retorno)
                                 FALSE  ,
                                 NULL  ); --cd lancamento(opcional)*/


END ;
/
commit
/

--select * from itreg_amb x where x.cd_reg_amb = 3822042 and x.cd_pro_fat = 97000001
