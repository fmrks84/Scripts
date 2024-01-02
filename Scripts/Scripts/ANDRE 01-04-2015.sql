select *
/*    ROWID,
      CD_PROCESSO,
      DS_MOVIMENTACAO_PADRAO,
      DS_MOVIMENTACAO_PROCESSO,
      SN_CONCILIADO,
      CD_EXP_CONTABILIDADE,
      DT_MOVIMENTACAO,
      CD_LAN_CONCOR,
      CD_SETOR,
      CD_REDUZIDO,
      NR_DOCUMENTO_IDENTIFICACAO,
      CD_FORNECEDOR,
      DS_MOVIMENTACAO,
      cd_moeda,
      VL_MOEDA,
      VL_MOVIMENTACAO,
      CD_CON_COR,
      CD_MOV_CONCOR,
      SN_COMPENSADO,
      CD_CHEQUE,
      CD_MOV_CONCOR_TRANSFERENCIA,
      CD_MULTI_EMPRESA,
     CD_MULTI_EMPRESA_ORIGEM,
 MOT_CANC_CONC
*/
--SELECT CD_REC_MOV_CON
  from dbamv.mov_concor
 where cd_lan_concor in
       (select cd_lan_concor
          from dbamv.lan_concor
         where nvl(sn_lanc_extrato, 'N') = 'S')
   and ((nvl(sn_conciliado, 'N') <> 'S') or
       (nvl(sn_conciliado, 'N') = 'S' and exists
        (select 'X'
            from dbamv.config_financ
           where cd_lanca_credito_convenio = cd_lan_concor) and
        dbamv.pkg_mv2000.le_cliente not in (429, 969, 1749)))
   and nvl(vl_movimentacao, 0) > 0
   and trunc(dt_movimentacao) = to_date('31/03/2015', 'dd/mm/yyyy')
   and (cd_con_cor = 85)
 order by dt_movimentacao, cd_mov_concor
   for update

select *
  from all_constraints
 where constraint_name like '%REC_MOV_CON_MOV_CONCOR_FK%'
SELECT * FROM REC_MOV_CON
WHERE CD_MOV_CONCOR = 573146

SELECT CD_REC_MOV_CON FROM dbamv.mov_concor WHERE CD_MOV_CONCOR = 573146
CD_REC_MOV_CON


select * from dbamv.itcon_rec r where r.cd_con_rec in (319964) for update
