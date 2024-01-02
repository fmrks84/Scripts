SELECT *--CD_SITE_XML, CD_SITE_SERVICO, CD_WIZARD_ORIGEM
  FROM dbamv.site_xml --order by dt_criacao desc
 WHERE cd_wizard_origem = 157624 for update---CD_SITE_XML = 154087 for update

select * from dbamv.tiss_mensagem m where m.nr_lote in (2659)and m.cd_convenio = 377 and m.cd_seq_transacao = 13779--- and m.nr_documento = '71570' for update

select * from dbamv.tiss_lote l where l.id_pai in (2659) for update
