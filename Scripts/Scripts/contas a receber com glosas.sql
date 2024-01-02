SELECT V_COSULTA_PARCELA_CONVENIO.CD_CON_REC,
       V_COSULTA_PARCELA_CONVENIO.CD_ITCON_REC,
       V_COSULTA_PARCELA_CONVENIO.DT_EMISSAO,
       V_COSULTA_PARCELA_CONVENIO.NR_DOCUMENTO,
       V_COSULTA_PARCELA_CONVENIO.NR_SERIE,
       V_COSULTA_PARCELA_CONVENIO.CD_NOTA_FISCAL,
       V_COSULTA_PARCELA_CONVENIO.CD_CONVENIO,
       V_COSULTA_PARCELA_CONVENIO.CD_FORNECEDOR,
       V_COSULTA_PARCELA_CONVENIO.NM_CLIENTE,
       V_COSULTA_PARCELA_CONVENIO.NR_PARCELA,
       V_COSULTA_PARCELA_CONVENIO.DT_VENCIMENTO,
       V_COSULTA_PARCELA_CONVENIO.VL_DUPLICATA,
       V_COSULTA_PARCELA_CONVENIO.VL_RECEBIDO_CONV,
       V_COSULTA_PARCELA_CONVENIO.VL_RECEBIDO_CONC,
       V_COSULTA_PARCELA_CONVENIO.VL_RECEBIDO_RECR,
       V_COSULTA_PARCELA_CONVENIO.VL_GLOSA,
       V_COSULTA_PARCELA_CONVENIO.VL_RECURSO,
       V_COSULTA_PARCELA_CONVENIO.VL_ACEITE
  FROM (SELECT *
          FROM (SELECT cr.cd_con_rec,
                       cr.dt_emissao,
                       cr.nr_documento,
                       cr.nr_serie,
                       cr.cd_nota_fiscal,
                       (SELECT cd_convenio
                          FROM dbamv.nota_fiscal
                         WHERE cd_nota_fiscal = cr.cd_nota_fiscal
                           AND ROWNUM = 1) cd_convenio,
                       cr.cd_fornecedor,
                       cr.nm_cliente,
                       it.cd_itcon_rec,
                       it.nr_parcela,
                       it.dt_vencimento,
                       it.tp_quitacao,
                       it.vl_duplicata,
                       NVL(it.vl_soma_recebido, 0) vl_soma_recebido,
                       NVL(it.vl_glosa, 0) vl_glosa,
                       NVL(it.vl_recurso, 0) vl_recurso,
                       NVL(it.vl_glosa_aceita, 0) vl_aceite,
                       NVL((SELECT SUM(NVL(rc.vl_recebido, 0) -
                                      NVL(rc.vl_acrescimo, 0) +
                                      NVL(rc.vl_desconto, 0) +
                                      NVL(rc.vl_imposto_retido, 0))
                             FROM dbamv.reccon_rec rc
                            WHERE rc.cd_itcon_rec = it.cd_itcon_rec
                              AND rc.cd_remessa_glosa IS NULL
                              AND EXISTS
                            (SELECT 1
                                     FROM dbamv.it_recebimento
                                    WHERE cd_reccon_rec = rc.cd_reccon_rec
                                      AND ROWNUM = 1)),
                           0) vl_recebido_conv,
                       NVL((SELECT SUM(NVL(rc.vl_recebido, 0) -
                                      NVL(rc.vl_acrescimo, 0) +
                                      NVL(rc.vl_desconto, 0) +
                                      NVL(rc.vl_imposto_retido, 0))
                             FROM dbamv.reccon_rec rc
                            WHERE rc.cd_itcon_rec = it.cd_itcon_rec
                              AND rc.cd_remessa_glosa IS NULL
                              AND NOT EXISTS
                            (SELECT 1
                                     FROM dbamv.it_recebimento
                                    WHERE cd_reccon_rec = rc.cd_reccon_rec)),
                           0) vl_recebido_conc,
                       NVL((SELECT SUM(NVL(rc.vl_recebido, 0) -
                                      NVL(rc.vl_acrescimo, 0) +
                                      NVL(rc.vl_desconto, 0) +
                                      NVL(rc.vl_imposto_retido, 0))
                             FROM dbamv.reccon_rec rc
                            WHERE rc.cd_itcon_rec = it.cd_itcon_rec
                              AND rc.cd_remessa_glosa IS NOT NULL),
                           0) vl_recebido_recr
                  FROM dbamv.con_rec cr, dbamv.itcon_rec it
                 WHERE cr.cd_con_rec = it.cd_con_rec
                   AND cr.tp_con_rec = 'C'
                   AND cr.cd_previsao IS NULL) v_cosulta_parcela_convenio) V_COSULTA_PARCELA_CONVENIO
 WHERE cd_con_rec IN (506765/*,502124*/)
  -- and (501853)
 order by cd_con_rec ;
 
 SELECT DT_ENTREGA,
       DT_PREVISTA,
      
       CD_ITCON_REC,
       VL_TOTAL_REMESSA,
       VL_RECEBIDO_FIN,
       DT_RECEBIMENTO_FIN,
       VL_RECEBIDO_ITEM,
       CD_REMESSA,
       CD_REMESSA_GLOSA,
       CD_REMESSA_GLOSA_PAI
  FROM (SELECT m.cd_itcon_rec,
               r.cd_remessa_glosa,
               r.cd_remessa,
               r.cd_remessa_glosa_pai,
               TRUNC(r.dt_entrega) dt_entrega,
               TRUNC(r.dt_prevista_para_pgto) dt_prevista,
               r.vl_total_remessa,
               NVL((SELECT SUM(NVL(vl_recebido, 0) - NVL(vl_acrescimo, 0) +
                              NVL(vl_desconto, 0) +
                              NVL(vl_imposto_retido, 0))
                     FROM dbamv.reccon_rec
                    WHERE cd_remessa_glosa IS NOT NULL
                      AND dt_estorno IS NULL
                      AND cd_remessa_glosa = r.cd_remessa_glosa),
                   0) vl_recebido_fin,
               (SELECT MAX(dt_recebimento)
                  FROM dbamv.reccon_rec
                 WHERE cd_remessa_glosa IS NOT NULL
                   AND dt_estorno IS NULL
                   AND cd_remessa_glosa = r.cd_remessa_glosa) dt_recebimento_fin,
               NVL((SELECT SUM(vl_recebido)
                     FROM dbamv.glosas
                    WHERE cd_remessa_glosa = r.cd_remessa_glosa),
                   0) vl_recebido_item
          FROM dbamv.remessa_glosa r, dbamv.mov_glosas m, dbamv.processo p
         WHERE m.cd_remessa_glosa = r.cd_remessa_glosa
           AND p.cd_processo = m.cd_processo
           AND p.cd_estrutural = '3.1.2.1.1'
           AND m.cd_itcon_rec = 506625
         ORDER BY r.dt_entrega, r.cd_remessa_glosa)
 WHERE 1 = 1 --(CD_ITCON_REC = :1)
   --and (10 / 07 / 2018)
 order by dt_entrega, cd_remessa_glosa

/*SELECT CD_ITCON_REC,
       DT_MOVIMENTACAO,
       CD_ESTRUTURAL,
       DS_MOVIMENTACAO,
       VL_MOVIMENTACAO,
       CD_EXP_CONTABILIDADE,
       CD_PRIORIDADE 
FROM (SELECT  cd_itcon_rec, 
              dt_movimentacao,  
              cd_estrutural,  
              ds_movimentacao,  
              vl_movimentacao,  
              cd_exp_contabilidade,  
              cd_prioridade  
FROM (SELECT rc.cd_itcon_rec, 
      TRUNC (rc.dt_recebimento) dt_movimentacao, 
                                pr.cd_estrutural,  
                                'RECEBIMENTO DE CONVÊNIO' ds_movimentacao,  (NVL(rc.vl_recebido, 0) - NVL(rc.vl_acrescimo, 0) + NVL(rc.vl_desconto, 0) + NVL(rc.vl_imposto_retido, 0)) vl_movimentacao,   
                                rc.cd_exp_contabilidade cd_exp_contabilidade,  0 cd_prioridade  
FROM dbamv.reccon_rec rc, 
      dbamv.processo pr 
 WHERE rc.cd_itcon_rec = 506625 
AND rc.tp_lancamento 
IS NULL  AND pr.cd_processo = rc.cd_processo  
AND EXISTS (SELECT 1 FROM dbamv.it_recebimento  WHERE cd_reccon_rec = rc.cd_reccon_rec AND ROWNUM = 1)  
UNION ALL  
SELECT rc.cd_itcon_rec, 
TRUNC (rc.dt_movimentacao) dt_movimentacao, 
       pr.cd_estrutural, 
       'REGISTRO DE GLOSA' ds_movimentacao,  
       (NVL (rc.vl_movimentacao, 0)) vl_movimentacao, 
        rc.cd_exp_contabilidade cd_exp_contabilidade,  
        1 cd_prioridade  
FROM dbamv.mov_glosas rc, 
     dbamv.processo pr  
WHERE rc.cd_itcon_rec = 506625 
AND pr.cd_processo = rc.cd_processo  
AND pr.cd_estrutural = '1.4.2.1.4' 
 AND rc.cd_remessa_glosa IS NULL  
UNION ALL  
SELECT rc.cd_itcon_rec, 
TRUNC (rc.dt_recebimento) dt_movimentacao, 
       pr.cd_estrutural,  
      'RECEBIMENTO' ds_movimentacao,  
      (NVL(rc.vl_recebido, 0) - NVL(rc.vl_acrescimo, 0) + NVL(rc.vl_desconto, 0) + NVL(rc.vl_imposto_retido, 0)) vl_movimentacao,  
      rc.cd_exp_contabilidade cd_exp_contabilidade,  2 cd_prioridade  
FROM dbamv.reccon_rec rc, 
     dbamv.processo pr  
WHERE rc.cd_itcon_rec = 506625 
AND rc.cd_remessa_glosa IS NULL  
AND pr.cd_processo = rc.cd_processo  
AND rc.tp_lancamento IS NULL  
AND NOT EXISTS (SELECT 1 FROM dbamv.it_recebimento WHERE cd_reccon_rec = rc.cd_reccon_rec)  
UNION ALL  
SELECT rc.cd_itcon_rec, 
       TRUNC (rc.dt_movimentacao) dt_movimentacao, 
       pr.cd_estrutural,  
       'REGISTRO DE GLOSA NÃO DETALHADA' ds_movimentacao,  
       (NVL (rc.vl_movimentacao, 0)) vl_movimentacao,  
        rc.cd_exp_contabilidade cd_exp_contabilidade,  
        3 cd_prioridade 
FROM dbamv.mov_glosas rc, 
     dbamv.processo pr, 
     dbamv.remessa_glosa rg 
WHERE rc.cd_itcon_rec = 506625 
      AND pr.cd_processo = rc.cd_processo  
      AND pr.cd_estrutural = '3.1.2.1.3'  
      AND rc.cd_remessa_glosa = rg.cd_remessa_glosa  
UNION ALL  
SELECT rc.cd_itcon_rec, 
TRUNC (rc.dt_estorno) dt_movimentacao,  
      pr.cd_estrutural,  
      'ESTORNO DE RECEBIMENTO' ds_movimentacao,  
     ( NVL(rc.vl_recebido, 0) - NVL(rc.vl_acrescimo, 0) + NVL(rc.vl_desconto, 0) + NVL(rc.vl_imposto_retido, 0)) vl_movimentacao,  
     Decode(rc.cd_caixa,NULL,  
     Nvl(mvc.cd_exp_contabilidade,
     rc.cd_exp_contab_estorno_baixa), 
     mc.cd_exp_contabilidade) cd_exp_contabilidade,  
     3 cd_prioridade 
FROM dbamv.reccon_rec rc, 
     dbamv.processo pr , 
     dbamv.mov_caixa mc, 
 (SELECT rm.cd_reccon_rec cd_recebimento, 
         mcc.cd_exp_contabilidade 
FROM dbamv.mov_concor mcc, 
     dbamv.rec_mov_con rm 
WHERE rm.cd_mov_concor = mcc.cd_mov_concor 
AND mcc.dt_Estorno IS NOT NULL) mvc  
WHERE rc.cd_itcon_rec = 506625 
AND rc.dt_estorno IS NOT NULL  
AND pr.cd_processo = rc.cd_processo_sec  
AND rc.cd_reccon_rec = mvc.cd_recebimento(+)  
AND rc.cd_reccon_rec = mc.cd_reccon_rec(+)  
UNION ALL  
SELECT rc.cd_itcon_rec,
TRUNC (rc.dt_movimentacao) dt_movimentacao, 
       pr.cd_estrutural, 
       ( 'ENTREGA DE RECURSO (RM: ' || rg.cd_remessa || ') 
       (REC: ' || rc.cd_remessa_glosa || ')') ds_movimentacao, 
        NVL (rc.vl_movimentacao, 0) vl_movimentacao, 
        rc.cd_exp_contabilidade cd_exp_contabilidade,  
        3 cd_prioridade  
FROM dbamv.mov_glosas rc, 
dbamv.processo pr, 
dbamv.remessa_glosa rg 
WHERE rc.cd_itcon_rec = 506625 
AND pr.cd_processo = rc.cd_processo  
AND rc.cd_remessa_glosa = rg.cd_remessa_glosa  
AND rg.cd_remessa_glosa_pai IS NULL  
AND pr.cd_estrutural = '3.1.2.1.1'  
UNION ALL  
SELECT rc.cd_itcon_rec, 
TRUNC (rc.dt_recebimento) dt_movimentacao,  
      pr.cd_estrutural,  ('RECEBIMENTO DE RECURSO (RM: ' || rg.cd_remessa || ')' || ' (REC: ' || rc.cd_remessa_glosa || ')') 
      ds_movimentacao,  
      (NVL(rc.vl_recebido, 0) - NVL(rc.vl_acrescimo, 0) + NVL (rc.vl_desconto, 0) + NVL (rc.vl_imposto_retido, 0)) vl_movimentacao,  
      rc.cd_exp_contabilidade cd_exp_contabilidade,  4 cd_prioridade  
      FROM dbamv.reccon_rec rc, 
           dbamv.remessa_glosa rg, 
           dbamv.processo pr  
      WHERE rc.cd_itcon_rec = 506625 
      AND rc.cd_remessa_glosa = rg.cd_remessa_glosa  
      AND pr.cd_processo = rc.cd_processo  
      AND rg.cd_remessa_glosa_pai IS NULL  
      AND rc.tp_lancamento IS NULL  
      UNION ALL  
      SELECT rc.cd_itcon_rec, 
      TRUNC (rc.dt_movimentacao) dt_movimentacao,  
             pr.cd_estrutural,  
             ('ENTREGA DE RECURSO DO RECURSO (RM: ' || rg.cd_remessa || ') (ORIGEM: ' || rg.cd_remessa_glosa_pai || ') (REC: '|| rc.cd_remessa_glosa || ')') ds_movimentacao,   
             NVL (rc.vl_movimentacao, 0) vl_movimentacao,  
             rc.cd_exp_contabilidade cd_exp_contabilidade,  
             5 cd_prioridade  
FROM dbamv.mov_glosas rc, 
     dbamv.processo pr, 
     dbamv.remessa_glosa rg  
WHERE rc.cd_itcon_rec = 506625 
AND pr.cd_processo = rc.cd_processo  
AND rc.cd_remessa_glosa = rg.cd_remessa_glosa  
AND rg.cd_remessa_glosa_pai IS NOT NULL 
AND pr.cd_estrutural = '3.1.2.1.1'  
UNION ALL  
SELECT rc.cd_itcon_rec, 
TRUNC (rc.dt_recebimento) dt_movimentacao,   
       pr.cd_estrutural,  
       'RECEBIMENTO DE RECURSO (RM: ' || rg.cd_remessa || ') (REC: ' || rc.cd_remessa_glosa || ')' ds_movimentacao,  
       (NVL(rc.vl_recebido, 0) - NVL(rc.vl_acrescimo, 0) + NVL(rc.vl_desconto, 0) + NVL(rc.vl_imposto_retido, 0)) vl_movimentacao,  
       rc.cd_exp_contabilidade cd_exp_contabilidade,  
       6 cd_prioridade  
FROM dbamv.reccon_rec rc, 
     dbamv.remessa_glosa rg, 
     dbamv.processo pr  
WHERE rc.cd_itcon_rec = 506625 
AND rc.cd_remessa_glosa = rg.cd_remessa_glosa  
AND pr.cd_processo = rc.cd_processo  
AND rg.cd_remessa_glosa_pai IS NOT NULL  
AND rc.tp_lancamento IS NULL  
UNION ALL  
SELECT cd_itcon_rec,  
       dt_movimentacao,  
       cd_estrutural,  
       (CASE WHEN (vl_recurso > 0) THEN ds_movimentacao || ' (BAIXA DE RECURSO: ' || to_char(vl_recurso, '999G999G990D00') ||')'  
        ELSE ds_movimentacao  END) ds_movimentacao, 
        vl_movimentacao,  
        cd_exp_contabilidade,  
        cd_prioridade  
FROM 
(SELECT rc.cd_itcon_rec, 
 TRUNC (rc.dt_movimentacao) dt_movimentacao, 
         pr.cd_estrutural, 
          'GLOSA ACEITA' ds_movimentacao, 
         NVL (rc.vl_movimentacao, 0) vl_movimentacao, 
         Nvl((SELECT Sum(vl_retira_recurso)   
FROM dbamv.itmov_glosas 
WHERE cd_mov_glosas = rc.cd_mov_glosas), 0) vl_recurso,  rc.cd_exp_contabilidade cd_exp_contabilidade,  7 cd_prioridade  
FROM dbamv.mov_glosas rc, 
     dbamv.processo pr  
WHERE rc.cd_itcon_rec = 506625 
AND pr.cd_processo = rc.cd_processo  
AND pr.cd_estrutural = '3.1.2.1.2') ) resumo  
ORDER BY dt_movimentacao, cd_prioridade ) WHERE 1 =1*/ 
