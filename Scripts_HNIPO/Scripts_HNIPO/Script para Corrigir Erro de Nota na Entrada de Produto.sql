------------------------( ORDEM DE COMPRA 162226 )------------

solicito ajuste da entrada 459572 onde o Número da nota se lê 12524201, o correto é 1252420, necessidade devido a chegada do fechamento mês de abril
Não foi possível acertar direto no setor devido um dos itens terem sido inventariado.



select * from dbamv.fornecedor f where f.nm_fornecedor like 'FARMAR%'
select * from dbamv.fornecedor f where f.cd_fornecedor in (12988,18698)
select * from dbamv.ent_pro ep where ep.cd_fornecedor = 10730 and ep.nr_documento = '054353'
select * from dbamv.con_pag cpg where cpg.cd_con_pag = 856942


1.Passo : Alterar codigo fornecedor na tabela ORD_COM

SELECT ROWID,V.* FROM DBAMV.ORD_COM  V WHERE V.cd_ord_com in (316731)      --- ****13287
SELECT ROWID,V.* FROM DBAMV.ORD_COM  V WHERE V.Cd_Fornecedor = 8753  and v.cd_ord_com in (160868)


2.Passo : Alterar codigo fornecedor na tabela ENT_PRO

SELECT ROWID,EP.* FROM DBAMV.ENT_PRO EP WHERE EP.CD_ENT_PRO in ( 459572 )  --- ***
SELECT ROWID,EP.* FROM DBAMV.ENT_PRO EP WHERE EP.Cd_Ord_Com = 303556  
SELECT ROWID,EP.* FROM DBAMV.ENT_PRO EP WHERE EP.Cd_Fornecedor in (51286) and ep.dt_entrada >= '10/09/2021'


3.Passo : Selecionar os campos da tabela DUPLICADA  porque você vai ter que DELETAR este registro e inseri-lo novamente (Com codigo novo fornecedor) 
( Guardar o Resultado para depois inserir novamente na tabela (insert ))

SELECT ROWID,DP.* FROM DBAMV.DUPLICATA DP WHERE DP.CD_FORNECEDOR IN (13180) AND DP.NR_DOCUMENTO IN ('1252420')
-- SELECT ROWID,DP.* FROM DBAMV.DUPLICATA DP WHERE DP.CD_FORNECEDOR IN (32581) AND DP.NR_DOCUMENTO IN ('1505122')
      13180 12524201    1     11/06/2022  2027,00     1                       

4.Passo : Excluir o registro incorreto da tabela DUPLICADA

-- DELETe FROM DBAMV.DUPLICATA DP WHERE DP.CD_FORNECEDOR IN (13180) AND DP.NR_DOCUMENTO = '12524201'


5. Passo : Alterar codigo fornecedor na tabela DOCUMENTO_ENTRADA

SELECT * FROM  DBAMV.TMP_DOCUMENTO_ENTRADA_009047 
---Create table DBAMV.TMP_DOCUMENTO_ENTRADA_009047 AS
select ROWID,DE.*  from dbamv.documento_entrada DE WHERE DE.CD_FORNECEDOR IN (13180) AND DE.NR_DOCUMENTO IN ('12524201')  


6.Passo : Inserir novamente o registro EXCLUIDO na tabela DUPLICATA ( Por isto a necessidade de saber como estava antes da exclusao) 

INSERT INTO dbamv.Duplicata (CD_FORNECEDOR,NR_DOCUMENTO,CD_PARCELA,DT_VENCIMENTO,VL_PARCELA,NR_SERIE)
VALUES (13180,'1252420',1,'11/06/2022',2027.00,'1')        

                        

