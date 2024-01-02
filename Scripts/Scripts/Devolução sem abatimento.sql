select data, nr_documento, fornecedor, valor, decode(tp_quitacao,'V','SEM_ABATER','T','ABATIDA') quitacao from (
select cp.dt_lancamento data, cp.nr_documento, cp.ds_fornecedor fornecedor, cp.vl_bruto_conta VALOR, it.tp_quitacao
from con_pag cp, itcon_pag it
where cp.cd_con_pag = it.cd_con_pag
and cp.cd_processo = 191
and it.tp_quitacao = 'V'

union all

select distinct dev.dt_devolucao data, dev.nr_documento, f.nm_fornecedor fornecedor, dev.vl_total valor, 'V' TP_QUITACAO from dev_for dev, ent_pro ent, fornecedor f 
where dev.cd_con_pag is null
and dev.cd_ent_pro = ent.cd_ent_pro
and ent.cd_fornecedor = f.cd_fornecedor
and dev.cd_mot_dev not in (30,44)
and dev.vl_total > 0
)
