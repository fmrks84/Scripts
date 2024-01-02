----- ((((((((ABAIXO ESTOU MOSTRANDO AS CONTAS DAS EMPRESAS 1,2,3,4,5 CONCILIADAS E NAO CONCILIADAS))))))-----


                                           ----("|"CONCILIAÇÃO SANTA JOANA"|") ----       
                                            
                                                                           
---------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------===((( CONCILIAÇÃO DE CONTAS ))===------------------------------------------------------------
 ---  RECEITAS DE CONVENIO  --
 
 select 'RECEITAS DE CONVENIO' TIPO
  ,decode(sj1.tp_operacao_saldo_conta, '-', 'SAIDAS',
                                       '+', 'ENTRADAS',
                                       '0', 'X')            TP_OPERACAO
  ,decode (sj1.CD_LAN_CONCOR, '80','RECEITA DE CONVENIO',
                              '11','RECEITA DE CONVENIO',
                              '665','RECEITAS PARTICULARES',
                              '532','RECEITAS PARTICULARES',
                              '73','RECEITAS PARTICULARES') TP_LANCAMENTOS
                              
  ,decode (sj.sn_conciliado,  'S','CONCILIADO',
                              'N','NÃO CONCILIADO')         TP_CONCILIACAO
                              
  ,decode (sj.cd_multi_empresa,'1','SANTA JOANA',
                               '2','PROMATRE',
                               '3','CD SANTA JOANA',
                               '4','VANGUARDA',
                               '5','SANA')                  EMPRESA
      ,sj.dt_movimentacao
      ,sj.cd_processo
      ,sj1.CD_LAN_CONCOR
      ,sj1.ds_lan_concor desc_lanc
      ,sj.cd_con_cor
      ,sj.ds_movimentacao desc_movim
      ,sj.nr_documento_identificacao documento
      ,sj.cd_moeda moeda
      ,sj.vl_movimentacao valor_movimentado
    
  from dbamv.mov_concor sj, 
       dbamv.v_mov_concor sj1

 where 1=1
   and sj.dt_movimentacao between '01/05/2016' and '30/05/2016'
   and sj1.cd_lan_concor = sj.cd_lan_concor
   and sj1.cd_mov_concor = sj.cd_mov_concor
   and sj.cd_processo = sj1.cd_processo
   --and sj1.tp_operacao_saldo_conta = '+' --("+" = 'ENTRADAS' , "-" = 'SAIDAS')
   and sj.sn_conciliado IN ('S')--,'N')
   and sj1.CD_LAN_CONCOR in (80,11)
   and sj.cd_multi_empresa IN (1,2,3,4,5)
-- order by 2,3,4 
 UNION ALL
 
 --- OUTRAS RECEITAS 
 select 'OUTRAS RECEITAS'TIPO
      ,decode(sj1.tp_operacao_saldo_conta, '-', 'SAIDAS',
                                           '+', 'ENTRADAS',
                                           '0', 'X')       TP_OPERACAO 
      , 'OUTRAS RECEITAS'TP_LANCAMENTOS
       ,decode (sj.sn_conciliado,          'S','CONCILIADO',
                                           'N','NÃO CONCILIADO')TP_CONCILIACAO
       ,decode (sj.cd_multi_empresa,       '1','SANTA JOANA',
                                           '2','PROMATRE',
                                           '3','CD SANTA JOANA',
                                           '4','VANGUARDA',
                                           '5','SANA')         EMPRESA
      ,sj.dt_movimentacao
      ,sj.cd_processo
      ,sj1.CD_LAN_CONCOR
      ,sj1.ds_lan_concor desc_lanc
      ,sj.cd_con_cor
      ,sj.ds_movimentacao desc_movim
      ,sj.nr_documento_identificacao documento
      ,sj.cd_moeda moeda
      ,sj.vl_movimentacao valor_movimentado
     
  from dbamv.mov_concor sj, 
       dbamv.v_mov_concor sj1

 where 1=1
   and sj.dt_movimentacao between '01/05/2016' and '30/05/2016'
   and sj1.cd_lan_concor = sj.cd_lan_concor
   and sj1.cd_mov_concor = sj.cd_mov_concor
   and sj.cd_processo = sj1.cd_processo
  -- and sj1.tp_operacao_saldo_conta = '+' --("+" = 'C=CREDITO' , "-" = 'D=DEBITO')
   and sj.sn_conciliado IN ('S')--,'N')
   and sj1.CD_LAN_CONCOR NOT IN (11,73,80,532,665)
   and sj.cd_multi_empresa IN (1,2,3,4,5)
 --order by 2,3,4
 
-----  PAGAMENTOS -------

/*
select distinct 
       
       to_char (a.dt_pagamento, 'DD')DIA,
       to_char (a.dt_pagamento, 'MM')MES,
       to_char (a.dt_pagamento, 'YYYY')ANO,
       b.cd_fornecedor cd_fornecedor,
       b.ds_fornecedor ds_fornecedor,
       b.nr_documento nr_documento,
       c.nr_parcela nr_parcela,
       b.cd_con_pag cd_con_pag,
       a.cd_pagcon_pag COD_PAGTO,
       a.dt_baixa dt_baixa,
       c.dt_vencimento dt_vencimento,
       c.cd_moeda cd_moeda,
       a.vl_pago vl_pago,
       decode (a.cd_multi_empresa,'1','SANTA JOANA','2','PROMATRE','3','CD SANTA JOANA','4','VANGUARDA','5','SANA')EMPRESA_CONTA_PAGAR,
       decode (a.cd_multi_empresa_origem,'1','SANTA JOANA','2','PROMATRE','3','CD SANTA JOANA','4','VANGUARDA','5','SANA') EMPRESA_ORIGEM_PAGAMENTOS, 
       decode (a.tp_pagamento,'3','CHEQUE','4','DINHEIRO','5','DEBITO C/C', '6','PRESTACAO','8','TED', 'B','BAIXA CONTABIL')FORMA_PAGTO,
       decode (g.cd_gru_res,'17','SALARIOS/ENCARGOS/BENEFICIOS',
                            '19','DESPESAS FINANCEIRAS',
                            '20','DESPESAS GERAIS',
                            '22','IMPOSTOS/MULTAS/TAXAS',
                            '24','DESPESAS DE ESTOQUE',
                            '27','HONORARIOS MEDICOS',
                            '30','DISTRIBUIÇÃO DE LUCROS')TP_DESPESAS
     
       
from    dbamv.pagcon_pag a ,
        dbamv.con_pag    b ,
        dbamv.itcon_pag  c ,
        dbamv.ratcon_pag d ,
        dbamv.gru_res g,
        dbamv.item_res i
       
where  a.cd_multi_empresa IN (1,2,3,4,5) --INSERIR A EMPRESA CONTAS A PAGAR  
       and a.cd_itcon_pag = c.cd_itcon_pag
       and b.cd_con_pag = c.cd_con_pag
       and c.cd_con_pag = d.cd_con_pag
       and g.cd_gru_res = i.cd_gru_res
       and i.cd_item_res = d.cd_item_res
       and a.dt_pagamento between '01/03/2016' and '30/03/2016'
       and g.cd_gru_res IN (17,19,20,22,24,27,30)



------------------------------------
/*
--SALARIOS/ENCARGOS E BENEFICIOS
select * from dbamv.gru_res a 
       inner join dbamv.item_res b on a.cd_gru_res = b.cd_gru_res
       and b.sn_ativo = 'S'
       and a.cd_gru_res in (17)--(17,19,20,22,24,27,30)
       order by 1
       
--DESPESAS FINANCEIRAS
select * from dbamv.gru_res a 
       inner join dbamv.item_res b on a.cd_gru_res = b.cd_gru_res
       and b.sn_ativo = 'S'
       and a.cd_gru_res in (19)--(17,19,20,22,24,27,30)
       order by 1
       
       
--DESPESAS GERAIS
select * from dbamv.gru_res a 
       inner join dbamv.item_res b on a.cd_gru_res = b.cd_gru_res
       and b.sn_ativo = 'S'
       and a.cd_gru_res in (20)--(17,19,20,22,24,27,30)
       order by 1
       
--IMPOSTOS/MULTAS E TAXAS
select * from dbamv.gru_res a 
       inner join dbamv.item_res b on a.cd_gru_res = b.cd_gru_res
       and b.sn_ativo = 'S'
       and a.cd_gru_res in (22)--(17,19,20,22,24,27,30)
       order by 1    
--DESPESAS DE ESTOQUE
select * from dbamv.gru_res a 
       inner join dbamv.item_res b on a.cd_gru_res = b.cd_gru_res
       and b.sn_ativo = 'S'
       and a.cd_gru_res in (24)--(17,19,20,22,24,27,30)
       order by 1     
--HONORÁRIOS MEDICOS       
select * from dbamv.gru_res a 
       inner join dbamv.item_res b on a.cd_gru_res = b.cd_gru_res
       and b.sn_ativo = 'S'
       and a.cd_gru_res in (27)--(17,19,20,22,24,27,30)
       order by 1       
       
--DISTRIBUIÇÃO DE LUCROS
select * from dbamv.gru_res a 
       inner join dbamv.item_res b on a.cd_gru_res = b.cd_gru_res
       and b.sn_ativo = 'S'
       and a.cd_gru_res in (30)--(17,19,20,22,24,27,30)
       order by 1

 ------ COLOCAR NO PORTAL QUANDO FOR SAIDAS COR VERMELHA , ENTRADAS PRETO
 ---OK- NAS ENTRADAS SEPARAR EM 3GRUPOS (RECEITAS DE CONVENIOS, RECEITAS DE PARTICULAR, OUTRAS RECEITAS)
 ---OK---NAS SAIDAS ("OBS VERIFICAR ADIANTAMENTO DE FORNECEDORES") SEPARAR EM 7 GRUPOS (SALARIOS/ENCARGOS E BENEFICIOS, DESPESAS FINANCEIRAS, DESPESAS GERAIS, IMPOSTOS/MULTAS E TAXAS, DESPESAS DE ESTOQUE, HONORÁRIOS MEDICOS, DISTRIBUIÇÃO DE LUCROS)
---- INFORMAÇÕES NA TABELA GRU_RES , ITEM_RES
  
  
*/
