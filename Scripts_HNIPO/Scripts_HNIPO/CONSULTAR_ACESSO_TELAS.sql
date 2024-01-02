/*SELECT DISTINCT
       modulo,
       tela,
       cd_papel,
       ds_papel,
       cd_usuario,
       nm_usuario
       
 
  FROM
       (
         SELECT
                nm_sistema Modulo
                ,cd_modulo Tela
                ,cd_usuario
                ,nm_usuario
                ,nvl(cd_papel,0) cd_papel
                ,ds_papel
           FROM
                (
                  SELECT
                         sistema.nm_sistema,
                         modulos.cd_modulo,
                         modulos.nm_modulo,
                         usuarios.cd_usuario,
                         usuarios.nm_usuario,
                         tp_modulo,
                         0 cd_papel,
                         NULL ds_papel
                    FROM
                         dbasgu.sistema,
                         dbasgu.modulos,
                         dbasgu.usuarios,
                         dbasgu.mod_sis,
                         dbasgu.aut_mod
                  
                  
                   WHERE sistema.cd_sistema = mod_sis.cd_sistema
                     AND modulos.cd_modulo = mod_sis.cd_modulo
                     AND modulos.cd_modulo = aut_mod.cd_modulo
                     AND usuarios.cd_usuario = aut_mod.cd_usuario
                     AND usuarios.sn_ativo = 'S'
                   GROUP BY
                         nm_sistema,
                         modulos.cd_modulo,
                         nm_modulo,
                         usuarios.cd_usuario,
                         nm_usuario,
                         tp_modulo
                   UNION
                  SELECT
                         sistema.nm_sistema,
                         modulos.cd_modulo,
                         modulos.nm_modulo,
                         usuarios.cd_usuario,
                         usuarios.nm_usuario,
                         tp_modulo,
                         papel.cd_papel,
                         papel.ds_papel
                    FROM
                         dbasgu.sistema,
                         dbasgu.mod_sis,
                         dbasgu.modulos,
                         dbasgu.usuarios,
                         dbasgu.papel_mod,
                         dbasgu.papel,
                         dbasgu.papel_usuarios p_usu
                   WHERE
                         sistema.cd_sistema = mod_sis.cd_sistema
                         AND mod_sis.cd_modulo = modulos.cd_modulo
                         AND modulos.cd_modulo = papel_mod.cd_modulo
                         AND papel_mod.cd_papel = p_usu.cd_papel
                         AND papel_mod.cd_papel = papel.cd_papel
                         AND p_usu.cd_usuario = usuarios.cd_usuario
                         AND usuarios.sn_ativo = 'S'
                   GROUP BY
                         nm_sistema,
                         modulos.cd_modulo,
                         nm_modulo,
                         usuarios.cd_usuario,
                         nm_usuario,
                         tp_modulo,
                         papel.cd_papel,
                         papel.ds_papel
                   ORDER BY
                         1 ASC,
                         2 ASC,
                         3 ASC,
                         6 ASC,
                         4 ASC,
                         5 ASC,
                         nm_sistema,
                         nm_modulo,
                         nm_usuario,
                         tp_modulo
                ))
                 WHERE
                       --cd_usuario = 
                       tela IN ('M_CONFIGURA')--'M_REMESSA','M_LAN_HOS','M_LAN_AMB_PARTICULAR','M_GERA_REMESSA_AMB')
                       --AND  MODULO LIKE '%FAT%'
                       --AND cd_papel = 0
                       --M_CONVENIO_CONF_TISS
              ORDER BY
                       cd_papel ASC --, 5 ASC
 */                      
select distinct modulo, tela, cd_papel, ds_papel, cd_usuario, nm_usuario
  from (select nm_sistema modulo
              ,cd_modulo tela
              ,cd_usuario
              ,nm_usuario
              ,nvl(cd_papel, 0) cd_papel
              ,ds_papel
          from (
                -- Acesso liberado Individualmente por usuario
                select sistema.nm_sistema
                      ,modulos.cd_modulo
                      ,modulos.nm_modulo
                      ,usuarios.cd_usuario
                      ,usuarios.nm_usuario
                      ,tp_modulo
                      ,0                   cd_papel
                      ,null                ds_papel
                  from dbasgu.sistema
                      ,dbasgu.modulos
                      ,dbasgu.usuarios
                      ,dbasgu.mod_sis
                      ,dbasgu.aut_mod
                
                 where sistema.cd_sistema = mod_sis.cd_sistema
                   and modulos.cd_modulo = mod_sis.cd_modulo
                   and modulos.cd_modulo = aut_mod.cd_modulo
                   and usuarios.cd_usuario = aut_mod.cd_usuario
                   and usuarios.sn_ativo = 'S'
                 group by nm_sistema
                         ,modulos.cd_modulo
                         ,nm_modulo
                         ,usuarios.cd_usuario
                         ,nm_usuario
                         ,tp_modulo
                --         
                union
                -- Liberação de acesso pelo papel
                select sistema.nm_sistema
                      ,modulos.cd_modulo
                      ,modulos.nm_modulo
                      ,usuarios.cd_usuario
                      ,usuarios.nm_usuario
                      ,tp_modulo
                      ,papel.cd_papel
                      ,papel.ds_papel
                  from dbasgu.sistema
                      ,dbasgu.mod_sis
                      ,dbasgu.modulos
                      ,dbasgu.usuarios
                      ,dbasgu.papel_mod
                      ,dbasgu.papel
                      ,dbasgu.papel_usuarios p_usu
                 where sistema.cd_sistema = mod_sis.cd_sistema
                   and mod_sis.cd_modulo = modulos.cd_modulo
                   and modulos.cd_modulo = papel_mod.cd_modulo
                   and papel_mod.cd_papel = p_usu.cd_papel
                   and papel_mod.cd_papel = papel.cd_papel
                   and p_usu.cd_usuario = usuarios.cd_usuario
                   and usuarios.sn_ativo = 'S'
                 group by nm_sistema
                         ,modulos.cd_modulo
                         ,nm_modulo
                         ,usuarios.cd_usuario
                         ,nm_usuario
                         ,tp_modulo
                         ,papel.cd_papel
                         ,papel.ds_papel
                 order by 1          asc
                         ,2          asc
                         ,3          asc
                         ,6          asc
                         ,4          asc
                         ,5          asc
                         ,nm_sistema
                         ,nm_modulo
                         ,nm_usuario
                         ,tp_modulo))
 where
--cd_usuario = 
 tela in ('usuario_setor_ffcv') ---'M_CONVENIO_CONF_TISS','M_TISS_CONFIGURACAO','M_LAN_AMB_PARTICULAR','M_GERA_REMESSA_AMB')
--AND  MODULO LIKE '%FAT%'
--AND cd_papel = 0
--M_CONVENIO_CONF_TISS
 order by cd_papel asc --, 5 ASC  -- M_CONVENIO_CONF_TISS
 
 
-- comandos delete
/*
select *  from dbasgu.aut_mod where cd_modulo = 'M_PRODUTO'
and cd_usuario NOT IN ('DBAMV')

SELECT *  from dbasgu.papel_mod  where cd_modulo IN (\*'C_PRODUTO',*\'M_PRODUTO') 

SELECT * from dbasgu.papel where cd_papel in (54)

*/





