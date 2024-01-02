--  GERAL DO ESTOQUE X PLANO DE CONTAS 
SELECT A2.CD_ESTOQUE,
       A2.DS_ESTOQUE,
       DECODE(A2.TP_ESTOQUE,'D','Distribuicao' ,'S','Sub-estoque')TP_ESTOQUE,
       A2.CD_MULTI_EMPRESA,
       A2.CD_REDUZIDO_DEBITO,
       A2.CD_REDUZIDO_CREDITO,
       A2.CD_SETOR CENTRO_CUSTO,
       A1.NM_SETOR
       
 FROM DBAMV.ESTOQUE A2
 INNER JOIN DBAMV.SETOR A1 ON A1.CD_SETOR = A2.CD_SETOR
 WHERE 1 = 1
 order by CD_MULTI_EMPRESA,
          CD_ESTOQUE

;
--- ESPECIES E PRODUTOS X PLANO DE CONTAS 
SELECT 
       a.CD_ESTOQUE,  
       b.ds_estoque, 
       a.CD_ESPECIE,
       a.CD_REDUZIDO,
       a.CD_REDUZIDO_DESPESA,
       a.CD_REDUZIDO_RECEITA,
       a.CD_SETOR,
       a.CD_REDUZIDO_DEBITO_BAIXA,
       a.CD_RED_EMP_RECEBIDO,
       a.CD_RED_EMP_CONCEDIDO,
       a.CD_RED_PAG_EMP_RECEBIDO,
       a.CD_RED_PAG_EMP_CONCEDIDO,
       a.CD_RED_AJUSTE_CREDITO,
       a.CD_RED_MANIPULACAO_CREDITO,
       a.CD_RED_AJUSTE_DEBITO,
       a.CD_RED_MANIPULACAO_DEBITO,
       b.cd_multi_empresa
          
  FROM dbamv.ESTOQUE_PL_CONTAS a
  inner join dbamv.estoque b on a.cd_estoque = b.cd_estoque
  WHERE 1 = 1 
  order by a.cd_estoque, 
           a.cd_especie
         
