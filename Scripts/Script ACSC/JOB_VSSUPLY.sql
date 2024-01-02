-- 1º transf para cotacao
-- 2º aguarda retorno cotacao
---- rodar quando passar para fazee aguardando retorno da cotação opme 
begin
mvintegra.PRC_IMVW_OUT_AVISO_BAIX_JOB;
end;

/*
select cd_produto, ds_produto from produto where cd_produto in (5118,3990,16618,18683,68116)


select * from DBAMV.LOG_FSCC_WORKFLOW x where x.cd_aviso_cirurgia = 348318
begin 
  pkg_mv2000.Atribui_Empresa(7);
  end;
select * from aviso_cirurgia xp where xp.cd_aviso_cirurgia = 348318 --for update */
