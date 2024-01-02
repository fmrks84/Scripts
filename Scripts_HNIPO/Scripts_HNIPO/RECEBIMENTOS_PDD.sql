
SELECT  ANOVCTO, 
        CLIENTE, 
        NF,
        VCTO,
        SUM(JANEIRO) JANEIRO, 
        SUM(FEVEREIRO) FEVEREIRO, 
        SUM(MARCO) MARCO, 
        SUM(ABRIL) ABRIL, 
        SUM(MAIO) MAIO, 
        SUM(JUNHO) JUNHO, 
        SUM(JULHO) JULHO, 
        SUM(AGOSTO) AGOSTO, 
        SUM(SETEMBRO) SETEMBRO, 
        SUM(OUTUBRO) OUTUBRO, 
        SUM(NOVEMBRO) NOVEMBRO, 
        SUM(DEZEMBRO) DEZEMBRO,
        SUM(TOTAL) TOTAL
         FROM (
SELECT  to_char(it.dt_vencimento,'yyyy') anovcto,
        F.nm_fantasia CLIENTE,
        CR.nr_documento NF,
        TO_CHAR(IT.dt_vencimento,'DD/MM/YYYY') VCTO,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'01',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) JANEIRO,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'02',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) FEVEREIRO,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'03',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) MARCO,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'04',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) ABRIL,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'05',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) MAIO,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'06',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) JUNHO,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'07',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) JULHO,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'08',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) AGOSTO,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'09',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) SETEMBRO,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'10',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) OUTUBRO,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'11',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) NOVEMBRO,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'12',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) DEZEMBRO,
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'01',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) +
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'02',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) +
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'03',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) +
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'04',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) +
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'05',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) +
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'06',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) +
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'07',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) +
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'08',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) +
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'09',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) +
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'10',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) +
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'11',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) +
        decode(TO_CHAR(IT.dt_vencimento,'mm'),'12',IT.vl_duplicata - SUM(nvl(REC.vl_recebido,0)) - SUM(nvl(REC.vl_desconto,0)) + SUM(nvl(REC.vl_acrescimo,0)) - nvl(IT.vl_glosa_aceita,0),0) total
 FROM   ITCON_REC IT, 
        RECCON_REC REC, 
        CON_REC CR,
        FORNECEDOR F
            WHERE IT.cd_con_rec = CR.cd_con_rec
            AND IT.cd_itcon_rec = REC.cd_itcon_rec (+)
            AND CR.cd_fornecedor = F.cd_fornecedor
            AND REC.dt_estorno IS NULL
            AND CR.cd_previsao IS NULL
            AND CR.dt_cancelamento IS NULL
            AND F.tp_fornecedor = 'J'
            AND CR.cd_multi_empresa = 1
           and f.cd_fornecedor = 6
    GROUP BY to_char(it.dt_vencimento,'yyyy'), IT.vl_duplicata, IT.vl_glosa_aceita, TO_CHAR(IT.dt_vencimento,'mm'), F.nm_FANTASIA, CR.nr_documento,
        IT.dt_vencimento
) 
where anovcto in ('2021')
AND TOTAL NOT LIKE '%-%'
AND TOTAL > 0
and nf = '837681'
group by 
ANOVCTO, 
        CLIENTE, 
        NF,
        VCTO
ORDER BY 2    --)  

/*WHERE TOTAL > 0 
AND ANOVCTO >= */

--514,95


--398302
/*select distinct(x1.cd_remessa) 
from
itfat_nota_fiscal x1
inner join nota_fiscal x2 on x2.cd_nota_fiscal = x1.cd_nota_fiscal
where x2.nr_id_nota_fiscal = 244545


select * from con_rec xz where xz.nr_documento = '244545'
select * from mov_glosas x where x.cd_remessa = 33849 ---for update;
select * from itcon_Rec where cd_con_rec = 57435 for update-- cd_itcon_Rec = 139063 for update
select * from reccon_rec where cd_itcon_rec = 57989 for update 


alter trigger dbamv.trg_reccon_rec_lanca_contab disable
alter trigger dbamv.TRG_RECCON_REC_LANCA_FINANC disable
alter trigger dbamv.trg_reccon_rec_after disable

alter trigger dbamv.trg_reccon_rec_lanca_contab enable
alter trigger dbamv.TRG_RECCON_REC_LANCA_FINANC enable
alter trigger dbamv.trg_reccon_rec_after enable
*/
--select * from con_Rec where nr_documento = '261214'


