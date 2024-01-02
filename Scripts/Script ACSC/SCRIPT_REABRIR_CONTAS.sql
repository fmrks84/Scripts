/*REG_AMB*/
select distinct a.cd_multi_empresa, 
                decode(a.tp_atendimento,'I','Internado','U','Urgencia','A','Ambulatorio','E','Externo') tp_atendimento, 
                i.cd_atendimento, 
                r.cd_reg_amb conta, 
                r.cd_convenio,
                r.cd_remessa,
                f.cd_con_rec
from itreg_amb i 
inner join reg_amb         r on r.cd_reg_amb = i.cd_reg_amb
inner join atendime        a on a.cd_atendimento = i.cd_atendimento
inner join  remessa_fatura f on f.cd_remessa = r.cd_remessa
where i.cd_atendimento in (3696513)


order by 5
;

CD_REG_AMB IN (3076453);
REMESSA (276798);
CON_REC (983272);

---------

delete from dbamv.rat_conrec where cd_con_rec in (983272);
Commit;
delete from dbamv.itcon_rec where cd_con_rec in (983272);
Commit;
update dbamv.remessa_fatura set cd_con_rec = null where cd_con_rec in (983272);
Commit;
delete from dbamv.con_rec where cd_con_rec in  (983272);
Commit;
update dbamv.remessa_fatura set sn_fechada = 'N' where cd_remessa in (276798);
Commit;

update dbamv.reg_amb set sn_fechada = 'N' 
where cd_reg_amb in (3076453);
Commit;
update dbamv.reg_amb set sn_fechada = 'N' 
where cd_reg_amb in (3076453);
Commit;
delete from it_repasse 
where cd_reg_amb in (3076453);
Commit;
delete from glosas 
where cd_reg_amb in (3076453);
Commit;
delete from it_recebimento where CD_ITFAT_NF in (select CD_ITFAT_NF from itfat_nota_fiscal 
where cd_reg_amb in (3076453));
Commit;
delete from dbamv.itfat_nota_fiscal 
where cd_reg_amb in (3076453);
Commit;
update dbamv.itreg_amb set sn_fechada = 'N' 
where cd_reg_amb in (3076453);
Commit; 

-------------------------------------------------------------------------

HST - AMBULAT.

CD_REG_AMB IN (3076453);
REMESSA (276798);
CON_REC (983272);

1. - APAGAR NR_REMESSA_ENVIO, TUDO QUE ENVOLVE LOTE E PROTOCOLO

UPDATE remessa_fatura SET DT_ENTREGA_PROTOCOLO = NULL, DS_LOTE_TISS = NULL, DS_PROTOCOLO_RECEB_TISS = NULL
where CD_REMESSA IN (276798);
Commit; 

/*2. TISS - APAGAR TUDO - NÃO RODOU O DELETE
Monitoração de Fat. TISS ****** dbamv.tiss_mensagem 
\*Se precisar procurar por exemplo lote e protocolo ficam na tabela dbamv.tiss_mensagem 
ai o campo nr_documento é a remessa*\

select * from tiss_mensagem x where x.nr_documento IN (297709),297706,297691,295853,297718,297708,295857,297711,295862,297713,295863,295854,297697,295856,297701,295847,
297693,295851,295860,297694,295861,297696,295850,295849,297689,297690); -- colocar aqui a remessa 

delete tiss_mensagem x where x.nr_documento IN  (
Commit; 
;*/

2.1 - APAGAR TUDO
Guia TISS ****** dbamv.tiss_guia
     dbamv.tiss_itguia (resumo intern) - *informa o ID que encontra na tabela tiss_guia
     dbamv.tiss_itguia_out (outras despesas)
EX:
SELECT * FROM tiss_guia T WHERE T.CD_REG_AMB IN (3076453);--ID = ID_PAI
SELECT * FROM tiss_itguia T2 WHERE T2.ID_PAI IN (3076453);

SELECT * FROM tiss_itguia_out T3 WHERE T3.ID_PAI IN (19387270);


delete tiss_guia T WHERE T.ID_PAI IN  (22323431);--informar o ID para deletar
Commit; 

delete tiss_itguia T2 WHERE T2.ID_PAI IN   (21500826,
21500827,
21942745,
21942746,
21943112,
21943116,
21943122,
21943117);--informar oID_PAI para deletar
Commit; 

/*delete tiss_itguia_out WHERE T2.ID_PAI IN */





















