SELECT
       a.cd_acesso,
       a.cd_usuario,
       a.nm_usuario,
       a.cd_prestador,
       (SELECT valor cd_setor
          FROM reg_maquina
         WHERE sequencia = 'CD_SETOR'
           AND reg_maquina.maquina = a.maquina
           AND ROWNUM = 1) cd_setor,
       (SELECT valor cd_setor
          FROM reg_maquina
         WHERE sequencia = 'NM_SETOR'
           AND reg_maquina.maquina = a.maquina
           AND ROWNUM = 1) nm_setor,
       a.maquina,
       a.dt_conexao,
       a.hora_conexao,
       a.dt_desconexao,
       a.hora_desconexao,
       a.cd_sistema_origem,
       a.tela,
       a.dt_acesso_tela,
       a.hora_acesso_tela,
       a.cd_empresa_conexao,
       a.maq_emp
 FROM  (
        SELECT
               mla.cd_acesso,
               la.cd_usuario,
               usuarios.nm_usuario,
               usuarios.cd_prestador,
               la.maquina,
               trunc(la.dt_conexao)dt_conexao,
               To_Char(la.dt_conexao, 'hh24:mi') hora_conexao,
               trunc(la.dt_desconexao) dt_desconexao,
               To_Char(la.dt_desconexao, 'hh24:mi') hora_desconexao,
               la.cd_sistema_origem,
               mla.cd_modulo tela,
               Trunc(mla.dt_acesso) dt_acesso_tela,
               To_Char(mla.dt_acesso,'hh24:mi') hora_acesso_tela,
               la.cd_empresa_conexao,
               CASE
                   WHEN la.maquina like 'SUA EMPRESA'
                   THEN 2
                   WHEN la.maquina like 'SUA EMPRESA'                                                                                                                                                 --
                   THEN 3
                   WHEN la.maquina like 'SUA EMPRESA'
                   THEN 5
                END MAQ_EMP
          FROM
               dbasgu.log_acesso_mv2000 la,
               dbasgu.mod_log_acesso_mv2000 mla,
               dbasgu.usuarios
         WHERE
               mla.cd_acesso = la.cd_acesso
               AND la.cd_usuario = usuarios.cd_usuario
               AND la.dt_conexao >= To_Date(To_Char(Add_Months(SYSDATE ,- 24),'mm/yyyy'),'mm/yyyy')
               AND la.dt_conexao <= last_day(To_Date(To_Char(Add_Months(SYSDATE ,- 0),'mm/yyyy'),'mm/yyyy'))
               --AND (MAQUINA <> 'CTI05') AND  (MAQUINA <> 'CTI05VM')
       ) a
 WHERE
       dt_conexao >= To_Date('01/01/2014','dd/mm/yyyy')
       AND dt_conexao <= To_Date('07/08/2015','dd/mm/yyyy')
       AND cd_usuario = 'SEU USUARIO'
 ORDER BY
       dt_conexao DESC,
       hora_conexao,
       hora_desconexao,
       cd_sistema_origem,
       tela,
       hora_acesso_tela desc
