select * from dbamv.nota_fiscal where nr_id_nota_fiscal = '0000000010'

select * from dbamv.mov_concor  where cd_con_cor = 1

SELECT CD_NOTA_FISCAL,CD_RECCON_REC,CD_CON_COR,DT_RECEBIMENTO,DS_RECCON_REC,NR_DOCUMENTO,VL_RECEBIDO
      ,VL_IMPOSTO_RETIDO,VL_ACRESCIMO,VL_DESCONTO
FROM (SELECT n.cd_nota_fiscal, r.cd_reccon_rec, r.cd_con_cor, r.dt_recebimento, r.ds_reccon_rec,r.nr_documento,
             r.vl_recebido, r.vl_acrescimo, r.vl_desconto, r.tp_recebimento, r.vl_imposto_retido,n.cd_multi_empresa
      FROM   dbamv.reccon_rec r, dbamv.itcon_rec i, dbamv.con_rec c, dbamv.nota_fiscal n
      WHERE  r.cd_itcon_rec = i.cd_itcon_rec
      AND c.cd_con_rec = i.cd_con_rec
      AND c.cd_nota_fiscal = n.cd_nota_fiscal
      AND r.cd_motivo_canc is null
      AND r.dt_estorno is null
      AND r.cd_remessa_glosa is null
      AND NOT EXISTS (SELECT 'x'
                      FROM dbamv.it_recebimento ir
                      WHERE ir.cd_reccon_rec = r.cd_reccon_rec))
WHERE ---cd_nota_fiscal = 218  
/*and*/ cd_multi_empresa = 1
and cd_con_cor = 1
order by dt_recebimento desc

