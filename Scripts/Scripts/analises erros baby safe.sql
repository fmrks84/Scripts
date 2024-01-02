------------ ANALISE DE ERROS BABYSAFE ----------------------------------
------------ BUSCAR OS REGISTROS DE ERROS PELO ATENDIMENTO --------------
SELECT * FROM BABYSAFE.REGISTRO_ERROS_PROCESSOS R
WHERE R.CD_ATENDIMENTO_FILHO = 1583290-- COLOCAR O ATENDIMENTO (ATENDIMENTO PAI)
;

------------ BUSCAR OS REGISTROS DE ERROS NO LOG DA TABELA DO BABYSAFE ------------
------------ VERIFICAR SE UM PROCESSO FOI FEITO ENQUANTO O PALM ESTAVA OFFLINE ----
------------ NORMALMENTE OCORRE ERRO NO PROCESSO 5 (ALTA DA ENFERMAGEM) -----------
SELECT * FROM BABYSAFE.LOG_PROCESSO L
WHERE L.DESCRICAO_LOG LIKE '%1583420%'--1561135,1561362
;

------------ EXCLUIR LOG INCORRETO ---------------
SELECT * FROM BABYSAFE.REGISTRO_ERROS_PROCESSOS R
WHERE R.ID_LOG_ERROS = 12465 -- DIGITAR A ID_LOG_ERRO
FOR UPDATE
;

select * from dbamv.atendime z where z.CD_ATENDIMENTO in (1561135,1561362)
select * from dbamv.leito z1 where z1.cd_leito in (3557,561)
--------------

select * from babysafe.registro_processo xx where xx.cd_atendimento_filho = 1583420-- xx.cd_atendimento_pai = 1583290