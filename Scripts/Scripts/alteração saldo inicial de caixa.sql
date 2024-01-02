/*SELECT CD_LOTE_CAIXA, TP_REC, TOTAL_SAI, TOTAL_ENT
  FROM (SELECT cd_lote_caixa,
               Sum(tot_ent) total_ent,
               Sum(tot_sai) total_sai,
               tp_rec
          FROM dbamv.v_resumo_mov_caixa
         GROUP BY tp_rec, cd_lote_caixa)
 WHERE cd_lote_caixa = 9886
 --  and (CD_LOTE_CAIXA = :2)
----
*/

select * from dbamv.lote_caixa a where a.cd_caixa = 88
order by 1 desc for update --a.cd_lote_caixa = 9801 for update --692069,90,683782,95
