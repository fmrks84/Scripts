select audit_coluna.cd_tabela, audit_coluna.coluna, audit_coluna.dado_anterior, audit_coluna.chave_primaria
     , audit_coluna.dado_atual, audit_tabela.usuario, usuarios.nm_usuario, dt_transacao , ds_observacao, audit_tabela.tp_transacao

from   dbamv.audit_coluna, dbamv.audit_tabela, dbasgu.usuarios

where  audit_coluna.cd_audit_tabela = audit_tabela.cd_audit_tabela
and    audit_coluna.cd_tabela = 'TB_ATENDIME'
--and    audit_coluna.coluna = 'IT_REG_FAT'
and    audit_coluna.chave_primaria Like '%900908%'
--and    audit_coluna.coluna = 'NM_PRESTADOR'
--and    audit_coluna.dado_atual LIKE '%VANGUARDA%'
--and    audit_tabela.tp_transacao = 'D'--- D(DELETADO), I(INSERT-INSERIDO), U (UPDATE-ALTERADO)
and    audit_tabela.usuario = usuarios.cd_usuario
order by dado_atual, dt_transacao, chave_primaria desc
