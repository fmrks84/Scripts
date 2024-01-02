select a.cd_con_pag,
       a.nr_documento,
       a.dt_emissao,
       a.dt_lancamento,
       a.ds_con_pag,
       a.cd_exp_contabilidade,
       a.cd_multi_empresa
from dbamv.con_pag a where a.cd_processo in (200,8857,8858,8859,8860,8861,8862,8863,8864,8865,10223,10820,11477)
and tO_CHAR(a.dt_emissao,'MM/YYYY') = '11/2018'
and A.DS_CON_PAG LIKE '%[NR#DOC]%'
order by a.cd_multi_empresa
--for update
;
--
select * from dbamv.lcto_contabil c where c.cd_lote = 64118
and c.cd_lcto_contabil = 23632028 for update 
