select cd_pro_fat
      ,ds_pro_fat
      ,max(vl_total_269) vl_total_269 
      ,max(dt_vigencia_269) dt_vigencia_269
      ,max(vl_total_271) vl_total_271
      ,max(dt_vigencia_271) dt_vigencia_271
      ,max(vl_total_285) vl_total_285
      ,max(dt_vigencia_285) dt_vigencia_285
  from (
        select b.cd_pro_fat
              ,b.ds_pro_fat
              ,a.vl_total    vl_total_269
              ,a.dt_vigencia dt_vigencia_269
              ,null          vl_total_271
              ,null          dt_vigencia_271
              ,null          vl_total_285
              ,null          dt_vigencia_285
          from (select cd_tab_fat
                      ,cd_pro_fat
                      ,vl_total
                      ,max(dt_vigencia) dt_vigencia
                  from dbamv.val_pro
                 where cd_tab_fat = 269
                   and val_pro.sn_ativo = 'S'
                 group by cd_tab_fat, cd_pro_fat, vl_total) a
              ,dbamv.pro_fat b
         where a.cd_pro_fat = b.cd_pro_fat

        union all
        select b.cd_pro_fat
              ,b.ds_pro_fat
              ,null          vl_total_269
              ,null          dt_vigencia_269
              ,a.vl_total    vl_total_271
              ,a.dt_vigencia dt_vigencia_271
              ,null          vl_total_285
              ,null          dt_vigencia_285
          from (select cd_tab_fat
                      ,cd_pro_fat
                      ,vl_total
                      ,max(dt_vigencia) dt_vigencia
                  from dbamv.val_pro
                 where cd_tab_fat = 271
                   and val_pro.sn_ativo = 'S'
                 group by cd_tab_fat, cd_pro_fat, vl_total) a
              ,dbamv.pro_fat b
         where a.cd_pro_fat = b.cd_pro_fat
        union all
        select b.cd_pro_fat
              ,b.ds_pro_fat
              ,null          vl_total_269
              ,null          dt_vigencia_269
              ,null          vl_total_271
              ,null          dt_vigencia_271
              ,a.vl_total    vl_total_285
              ,a.dt_vigencia dt_vigencia_285
          from (select cd_tab_fat
                      ,cd_pro_fat
                      ,vl_total
                      ,max(dt_vigencia) dt_vigencia
                  from dbamv.val_pro
                 where cd_tab_fat = 285
                   and val_pro.sn_ativo = 'S'
                 group by cd_tab_fat, cd_pro_fat, vl_total) a
              ,dbamv.pro_fat b
         where a.cd_pro_fat = b.cd_pro_fat)
 group by cd_pro_fat, ds_pro_fat
 order by 2
