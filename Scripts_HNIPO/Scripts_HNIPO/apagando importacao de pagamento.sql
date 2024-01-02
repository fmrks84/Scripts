-- apagando importação Retorno TISS
declare
    --
    vID   number;
    --
begin
  --
  --
  --
  vID := 973272; -- <<====  INFORMAR aqui o ID da mensagem de Retorno (DEMONSTRATIVO_ANALISE_CONTA)
  --
  --
    --
    delete from dbamv.TISS_RETORNO_DEMON_CONTA_PRC_G
        where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA_PROC
                            where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA_GUIA
                                                where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA_LOTE
                                                                    where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA
                                                                                        where id_pai in (select id from dbamv.TISS_MENSAGEM where id = vID)))));
    --
    delete from dbamv.TISS_RETORNO_DEMON_CONTA_PROC
        where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA_GUIA
                            where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA_LOTE
                                                where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA
                                                                   where id_pai in (select id from dbamv.TISS_MENSAGEM where id = vID))));
    --
    delete from dbamv.TISS_RETORNO_DEMON_CTA_GLOSA_G
        where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA_GUIA
                            where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA_LOTE
                                                where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA
                                                                   where id_pai in (select id from dbamv.TISS_MENSAGEM where id = vID))));
    --
    delete from dbamv.TISS_RETORNO_DEMON_CONTA_GUIA
       where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA_LOTE
                            where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA
                                                where id_pai in (select id from dbamv.TISS_MENSAGEM where id = vID)));
    --
    delete from dbamv.TISS_RETORNO_DEMON_CTA_LOTE_G
       where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA_LOTE
                            where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA
                                                where id_pai in (select id from dbamv.TISS_MENSAGEM where id = vID)));
    --
    delete from dbamv.TISS_RETORNO_DEMON_CONTA_LOTE
        where id_pai in (select id from dbamv.TISS_RETORNO_DEMON_CONTA
                            where id_pai in (select id from dbamv.TISS_MENSAGEM where id = vID));
    --
    delete from dbamv.TISS_RETORNO_DEMON_CONTA
        where id_pai in (select id from dbamv.TISS_MENSAGEM where id = vID);
    --
    delete from dbamv.TISS_LOG
        where id_mensagem = vID;
    --
    delete from dbamv.TISS_MENSAGEM
        where id = vID;
    --
end;


/*

delete from dbamv.con_rec a where a.cd_con_rec = 393297
delete from dbamv.itcon_rec b where b.cd_con_rec = 393297
delete from dbamv.rat_conrec c where c.cd_con_rec = 393297
select * from dbamv.
*/
