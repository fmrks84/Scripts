select audit_coluna.cd_tabela, audit_coluna.coluna, audit_coluna.dado_anterior, audit_coluna.chave_primaria
     , audit_coluna.dado_atual, audit_tabela.usuario, usuarios.nm_usuario, dt_transacao , ds_observacao, audit_tabela.tp_transacao

from   dbamv.audit_coluna, dbamv.audit_tabela, dbasgu.usuarios

where  audit_coluna.cd_audit_tabela = audit_tabela.cd_audit_tabela
and    audit_coluna.cd_tabela = 'DESLIG_CON_PLA'
--and    audit_coluna.coluna = 'CD_ATENDIMENTO'
--and    audit_coluna.chave_primaria = 526--Like '4%'
--and    audit_coluna.coluna = 'SN_PERTENCE_PACOTE'
--and    audit_coluna.dado_anterior = 'N'
--and    audit_coluna.dado_atual = 'S'
And    Trunc(dt_transacao) Between To_Date('01/08/2018','dd/mm/yyyy') And To_Date('31/07/2018','dd/mm/yyyy')
--and    audit_tabela.tp_transacao = 'I'  ----- D (DELETADO) , I(INSERIDO) , U (ALTERADO) 
and    audit_tabela.usuario = usuarios.cd_usuario
order by dado_atual, dt_transacao, chave_primaria desc
