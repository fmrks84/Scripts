select ib.cd_tab_fat,
       ib.cd_pro_fat,
       ib.cd_tiss,
       ib.cd_tuss,
       t.cd_tip_tuss,
       t.cd_tuss,
       t.ds_tuss,
       T.CD_MULTI_EMPRESA
       from dbamv.imp_bra ib
       inner join dbamv.tuss t on t.cd_tip_tuss = 20 and t.dt_fim_vigencia is null
       and t.cd_pro_fat = ib.cd_pro_fat
where ib.cd_tab_fat IN (1,311) -- 433 --1
and ib.cd_tuss <> t.cd_tuss
ORDER BY IB.CD_TAB_FAT,T.CD_PRO_FAT,T.CD_TUSS,T.CD_MULTI_EMPRESA
--"

;

select imb.cd_tab_fat,
       imb.cd_pro_fat,
       imb.cd_tuss,
       t.cd_tip_tuss,
       t.cd_tuss,
       t.ds_tuss
       from dbamv.imp_simpro imb
       inner join dbamv.tuss t on t.cd_tip_tuss = 19 and t.dt_fim_vigencia is null
       and t.cd_pro_fat = imb.cd_pro_fat
where imb.cd_tab_fat in (1,311)
and imb.cd_tuss <> t.cd_tuss
