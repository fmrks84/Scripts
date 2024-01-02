SELECT
cr.cd_con_rec,
IR.TP_QUITACAO TIPO,
TO_CHAR(CR.DT_EMISSAO,'DD/MM/YYYY')                            EMISSAO,
--TO_CHAR(IR.dt_vencimento,'DD/MM/YYYY')                         VENCIMENTO,
TRUNC(IR.DT_VENCIMENTO)                                                  VENCIMENTO,
FR.nm_fornecedor                                               FORNECEDOR,
CR.nr_documento                                                NUMERO_NOTA,
IR.vl_duplicata                                                VALOR_ORIGINAL,
IR.vl_soma_recebido                                            VALOR_RECEBIDO,
(IR.vl_duplicata - IR.vl_soma_recebido)                        VALOR_A_RECEBER,
DECODE(CR.cd_multi_empresa,1,'HMSJ',2,'PMP',3,'CDI',4,'VANG',5,'SANA') MULTI_EMPRESA
FROM
DBAMV.CON_REC CR,
DBAMV.ITCON_REC IR,
DBAMV.FORNECEDOR FR
WHERE
IR.cd_con_rec = CR.cd_con_rec AND
FR.cd_fornecedor = CR.cd_fornecedor AND
CR.tp_con_rec IN ('C') 
and (ir.vl_duplicata+ir.vl_soma_recebido) > 0
and (ir.vl_duplicata - ir.vl_soma_recebido) > 0
and IR.TP_QUITACAO NOT IN ('V','P','Q','L')
and TRUNC(ir.dt_vencimento) BETWEEN to_date('01/01/2008','DD/MM/YYYY') AND to_date('31/12/2008','DD/MM/YYYY')
and CR.CD_MULTI_EMPRESA = 1
ORDER BY TRUNC(IR.DT_VENCIMENTO)


