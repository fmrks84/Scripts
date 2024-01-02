select a.*
  from dbamv.lcto_contabil a, dbamv.lcto_contabil  b
 where 1 = 1
   and a.cd_lote = b.cd_lote
   and a.cd_lcto_movimento = b.cd_lcto_movimento
      --and lcto.cd_lcto_movimento = 11164414
   and a.dt_lcto <> b.dt_lcto
   and a.cd_lote in (66298)
----------------------------------------------------------------------
select /*dt_final_lcto */ * from lote where cd_lote =67647
----------------------------------------------------------------------
alter trigger dbamv.trg_lcto_contabil_lanca_contab disable;
----------------------------------------------------------------------
select a.*
  from dbamv.lcto_contabil a
  where a.cd_lote = 64284
 --- for update
----------------------------------------------------------------------
--alter trigger dbamv.trg_lcto_contabil_lanca_contab disable
update dbamv.lcto_contabil lcto
set dt_lcto = (select dt_final_lcto from lote where cd_lote = 67711)
where cd_lote = 67711
and dt_lcto <> (select dt_final_lcto from lote where cd_lote =67711)

--alter trigger dbamv.trg_lcto_contabil_lanca_contab enable

,
,
,
,
,
,
,
,
,
,
,
,
,
,
,

----------------------------------------------------------------------
--alter trigger dbamv.trg_lcto_contabil_lanca_contab disable
alter trigger dbamv.trg_lcto_contabil_lanca_contab enable


BEGIN
  dbamv.pkg_mv2000.atribui_empresa(1);
END;

SELECT DISTINCT cd_lote, cd_lcto_movimento, To_Char(dt_lcto, 'dd/mm/yyyy') FROM (
        SELECT lcto.cd_lote, lcto.cd_lcto_movimento, lcto.dt_lcto, lcto2.dt_lcto lcto2_dt_lcto, lcto.vl_lancado, lcto2.vl_lancado
          FROM dbamv.lcto_contabil lcto,
              dbamv.lcto_contabil lcto2
        WHERE To_Char(lcto.dt_lcto, 'YYYY') = '2018'
          AND lcto.cd_multi_empresa = 2--dbamv.pkg_mv2000.le_empresa
          AND lcto2.cd_lote = lcto.cd_lote
          AND lcto2.cd_lcto_movimento = lcto.cd_lcto_movimento
          AND Trunc(lcto2.dt_lcto, 'DD') <> Trunc(lcto.dt_lcto, 'DD')
     --   ORDER BY lcto.cd_lote, lcto.cd_lcto_movimento, lcto.dt_lcto
)
ORDER BY cd_lote, cd_lcto_movimento



select * from dbamv.lote where lote.cd_lote in (64284)





