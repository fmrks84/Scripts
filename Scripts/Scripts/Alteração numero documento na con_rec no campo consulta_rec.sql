select * from dbamv.doc_caixa where nr_documento = 'd983' for update --d1935
select * from dbamv.itCon_Rec r where r.cd_con_rec = 329711 -- 178494
select * from dbamv.mov_caixa where cd_doc_caixa = 178494


select * from dbamv.reccon_rec where (cd_itcon_rec = 330138)for update -- alterar o campo nr da con_Rec botao 'cons.receb'
select * from dbamv.mov_concor cc where cc.nr_documento_identificacao = 'd983' for update -- não esquecer de alterar aqui tb
