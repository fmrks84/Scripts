 DECLARE

 CURSOR c_cd_notas_erro IS
 SELECT cd_nota_fiscal,cd_multi_empresa FROM dbamv.nota_fiscal WHERE 
 (nr_nota_fiscal_nfe IS NULL OR cd_status_nfe = 'R' )AND dt_emissao > Trunc(SYSDATE-1);

 BEGIN
 FOR r IN  c_cd_notas_erro
 LOOP

  dbamv.pkg_mv2000.atribui_empresa(r.cd_multi_empresa);
  update dbamv.nota_fiscal
       set CD_NOTA_FISCAL_INTEGRA = null
           , CD_SEQ_INTEGRA = null
             , DT_INTEGRA = null
             , NR_PROTOCOLO = null
             , DS_RETORNO_NFE = null
             , DS_URL_NFE = null
     where cd_nota_fiscal = r.cd_nota_fiscal;


    update dbamv.nota_fiscal
     set CD_STATUS_NFE = 'A'
         , cd_status = 'E'
         , cd_tipo_situacao_nota_fiscal = 4
     where cd_nota_fiscal = r.cd_nota_fiscal;

  Dbms_Output.Put_Line(r.cd_nota_fiscal);

 END LOOP;

 END;
