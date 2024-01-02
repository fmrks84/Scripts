
/*select  * from dbamv.Pro_Fat where not exists (select * from dbamv.imp_simpro where cd_simpro is null)
and cd_gru_pro IN (8,58,59,62)-- MATERIAL   (07)MEDICAMENTOS
and sn_Ativo = 'S' 
order by 2 */

----------- medicamentos ATIVOS ,CD_BRASINDICE, _CD_TUSS-------------------------

select b.cd_pro_fat COD_PROCED, 
       p.ds_pro_fat DESCRICAO,
       b.cd_tab_fat TAB_FATUR, 
       b.cd_medicamento BRASINDICE,
       b.cd_tuss TUSS 
  from dbamv.Pro_Fat p, dbamv.imp_bra b
 where p.sn_ativo = 'S'
   and p.cd_pro_fat = b.cd_pro_fat
   --and b.cd_tuss is null
    order by 2
     
  ----------------- Materiais ATIVOS ,CD_BRASINDICE, _CD_TUSS  -------------------------------------------
select i.cd_pro_fat COD_PROCED,     
       s.ds_simpro DESCRICAO,
       i.cd_tab_fat TAB_FATUR,
       i.cd_simpro SIMPRO,
       i.cd_tuss TUSS
      from dbamv.imp_simpro i, dbamv.simpro S
where s.cd_simpro iS NOT null
and i.cd_simpro = s.cd_simpro
order by 2


