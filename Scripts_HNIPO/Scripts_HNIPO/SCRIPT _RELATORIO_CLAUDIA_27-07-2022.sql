--- SINTETICO
SELECT * FROM DBAMV.HNB_SNAP_VISAO_CLI_COMP VCC 
INNER JOIN FORNECEDOR FNF ON VCC.NM_FANTASIA = FNF.NM_FANTASIA
WHERE FNF.CD_FORNECEDOR = 8 
AND VCC.COMP_VENC = '2022/06'

;


--- ANALITICO
SELECT V.cd_con_rec,
       FN.CD_FORNECEDOR,
       FN.NM_FORNECEDOR,
      
       V.nr_documento,
       V.dt_vencimento,
       TO_CHAR(V.dt_vencimento,'RRRR')ANO,
       V.dt_prevista_recebimento,
       V.vl_duplicata,
       V.vl_recebido,
       V.vl_desconto,
       V.glosa_inicial,
       V.vl_glosa_atual,
       V.vl_recurso_atual,
       V.vl_glosa_aceita,
       V.vl_glosa_aceita,
       V.vl_recurso_atual,
       V.vl_recebido_glosa,
       V.saldo,
       V.sem_recurso
        
        FROM DBAMV.VDIC_HNB_VISAO_CLIENTE_V2 V 
INNER JOIN FORNECEDOR FN ON FN.CD_FORNECEDOR = V.cd_fornecedor
WHERE V.cd_fornecedor = 8
AND V.dt_vencimento >= '01/06/2022' 
AND V.dt_vencimento <= '30/06/2022'


select * from mvintegra
select * from mvintegra.imv_mensagem_saida_padrao

select  * from nota_fiscal a where  A.CD_NOTA_FISCAL = 733700
and a.cd_nota_fiscal = 733720
order by a.cd_nota_fiscal desc --- a.cd_nota_fiscal = 733657

