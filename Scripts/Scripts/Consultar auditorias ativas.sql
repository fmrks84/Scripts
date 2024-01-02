SELECT 
       CD_TABELA,
       DS_TABELA,
       NM_TRIGGER_AUDITORIA,
       OWNER,
       SN_AUDITORIA
  FROM DBAMV.TABELAS
 WHERE owner is not null
   and CD_TABELA <> 'AUDIT_TABELA'
   and CD_TABELA <> 'AUDIT_COLUNA'
   and CD_TABELA <> 'AUDIT_COLUNA_AUDITORIA'
   and CD_TABELA <> 'AUDIT_TABELA_AUDITORIA'
   and SN_AUDITORIA = 'S'
 order by cd_tabela


/*SELECT
       CD_TABELA,
       COLUNA,
       TP_DADO,
       SN_DELETE,
       SN_INSERT,
       SN_UPDATE,
       SN_PK,
       SN_FK
  FROM DBAMV.COLUNAS
 WHERE (CD_TABELA LIKE :1)
 order by sn_delete desc*/
