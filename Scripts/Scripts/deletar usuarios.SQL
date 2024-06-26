SELECT CD_USUARIO, NM_USUARIO FROM DBASGU.USUARIOS ORDER BY 2,1
SELECT * FROM DBASGU.USUARIOS WHERE CD_USUARIO LIKE 'AMELHEIROS' AND CD_USUARIO <> 'DBAMV'
SELECT * FROM DBASGU.LOG_ACESSO_MV2000 WHERE CD_USUARIO LIKE '%AMELHEIROS%' AND CD_USUARIO <> 'DBAMV'

SELECT * FROM DBAMV.USUARIOS_PORTADORES WHERE CD_USUARIO = 'AMELHEIROS'
DELETE FROM DBAMV.USUARIOS_PORTADORES WHERE CD_USUARIO = 'MJESUS'

SELECT * FROM DBAMV.SAC_RECEPTOR WHERE CD_USUARIO = 'AMELHEIROS'


DELETE FROM DBASGU.USUARIOS WHERE CD_USUARIO LIKE 'RFILHO' AND CD_USUARIO <> 'DBAMV'
UPDATE DBASGU.USUARIOS SET CD_USUARIO = 'EVLIMA' WHERE CD_USUARIO LIKE 'ELIMA'AND CD_USUARIO <> 'DBAMV'

DELETE FROM DBASGU.PAPEL_USUARIOS WHERE CD_USUARIO LIKE 'AMELHEIROS' AND CD_USUARIO <> 'DBAMV'
UPDATE DBASGU.PAPEL_USUARIOS SET CD_USUARIO = 'EVLIMA' WHERE CD_USUARIO LIKE 'ELIMA'AND CD_USUARIO <> 'DBAMV'

DELETE FROM DBASGU.AUT_MOD WHERE CD_USUARIO LIKE 'AMELHEIROS' AND CD_USUARIO <> 'DBAMV'
UPDATE DBASGU.AUT_MOD SET CD_USUARIO = 'SGONSALO' WHERE CD_USUARIO LIKE 'ELIMA'AND CD_USUARIO <> 'DBAMV'


DELETE FROM DBASGU.LOG_ACESSO_MV2000 WHERE CD_USUARIO LIKE 'AMELHEIROS' AND CD_USUARIO <> 'DBAMV'
UPDATE DBASGU.LOG_ACESSO_MV2000 SET CD_USUARIO = 'SGONSALO' WHERE CD_USUARIO LIKE '%SGONZALVES%'



DELETE FROM DBASGU.MOD_LOG_ACESSO_MV2000 WHERE CD_ACESSO IN (SELECT CD_ACESSO FROM DBASGU.LOG_ACESSO_MV2000 WHERE CD_USUARIO LIKE 'AMELHEIROS' AND CD_USUARIO <> 'DBAMV')
UPDATE DBASGU.MOD_LOG_ACESSO_MV2000 SET CD_ACESSO = 'SGONSALO' WHERE CD_ACESSO IN (SELECT CD_ACESSO FROM DBASGU.LOG_ACESSO_MV2000 WHERE CD_USUARIO LIKE '%SGONZALVES%' AND CD_USUARIO <> 'DBAMV')

DELETE FROM DBAMV.LOG_MOVIMENTO_EXAME WHERE CD_USUARIO_RESPONSAVEL LIKE 'AMELHEIROS'
DELETE FROM DBAMV.CONTROLE_USUARIO_FFCV WHERE CD_USUARIO LIKE 'AMELHEIROS'
DELETE FROM DBAMV.ABRE_CAIXA WHERE CD_USUARIO_FECHAMENTO LIKE 'AMELHEIROS'


DELETE FROM DBASGU.AUT_MOD WHERE CD_USUARIO LIKE 'ELIMA' AND CD_USUARIO <> 'DBAMV'
SELECT * FROM DBASGU.PAPEL_USUARIOS WHERE CD_USUARIO LIKE 'AMELHEIROS' AND CD_USUARIO <> 'DBAMV'
SELECT * FROM DBASGU.LOG_ACESSO_MV2000 WHERE CD_USUARIO LIKE 'AMELHEIROS' AND CD_USUARIO <> 'DBAMV'
SELECT * FROM DBASGU.MOD_LOG_ACESSO_MV2000 WHERE CD_ACESSO IN (SELECT CD_ACESSO
                                                                FROM DBASGU.LOG_ACESSO_MV2000
                                                                WHERE CD_USUARIO LIKE 'AMELHEIROS' AND CD_USUARIO <> 'DBAMV')
SELECT * FROM DBAMV.LOG_MOVIMENTO_EXAME WHERE CD_USUARIO_RESPONSAVEL LIKE 'AMELHEIROS'
SELECT * FROM DBAMV.ABRE_CAIXA WHERE CD_USUARIO_fechamento LIKE 'AMOTA'
SELECT * FROM DBAMV.MOV_CC_RPA WHERE NM_USUARIO LIKE 'AMELHEIROS'



SELECT * FROM DBASGU.AUT_MOD WHERE CD_MODULO = 'CAD_PRE'
SELECT * FROM DBASGU.PAPEL
SELECT * FROM DBASGU.V_SIS_MODULOS WHERE CD_MODULO = 'CAD_PRE'



DELETE
FROM DBAMV.USU_ESTOQUE
WHERE CD_ID_DO_USUARIO IN (SELECT CD_USUARIO 
                        FROM DBASGU.USUARIOS 
                        WHERE SN_ATIVO = 'N')

SELECT * FROM DBAMV.USU_ESTOQUE
WHERE CD_ID_DO_USUARIO = 'ELIMA'


SELECT * FROM DBASGU.USUARIOS WHERE CD_USUARIO = 'IRCUNHA'

SELECT * FROM DBAMV.USUARIO_UNID_INT

Select  cd_usuario, nm_usuario, ds_observacao, dt_nascimento, sn_ativo, sn_senha_plogin  
From    Dbasgu.Usuarios
Where   sn_senha_plogin = 'N'
Order By 2
