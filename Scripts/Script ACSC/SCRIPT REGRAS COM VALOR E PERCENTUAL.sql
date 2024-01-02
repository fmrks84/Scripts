select
       
       t.cd_tab_fat,
       t.ds_tab_fat,
       p.cd_pro_fat,
       p.ds_pro_fat,
       p.cd_gru_pro,
       g.ds_gru_pro,
       gf.cd_gru_fat,
       gf.ds_gru_fat,
       v.dt_vigencia,
       v.vl_honorario,
       v.vl_operacional,
       nvl(filme.qt_m2_filme,0) qt_m2_filme,
       v.vl_total,
       r.cd_regra,
       it.vl_percetual_pago,
      (v.vl_total * it.vl_percetual_pago)/100 valor_total_percentual
from val_pro v ,
     pro_fat p ,
     gru_pro g ,
     gru_fat gf,
     tab_fat t ,
     (SELECT
            MAX(DT_VIGENCIA),
            CD_PRO_FAT,
            NR_INCIDENCIAS,
            QT_M2_FILME
       FROM FILME_TAB
            WHERE CD_TAB_FAT in (823,942,2607)
            GROUP BY CD_PRO_FAT,
                    NR_INCIDENCIAS,
                    QT_M2_FILME) FILME,
     (select px.cd_pro_fat,
             max(vx.dt_vigencia) dt_vigencia
             from val_pro vx , pro_fat px
       where vx.cd_pro_fat = px.cd_pro_fat
       and vx.cd_tab_fat in (823,942,2607)
       group by
             px.cd_pro_fat,
             px.ds_pro_fat) uvigente,
       itregra it,
       regra r




where p.cd_gru_pro =  g.cd_gru_pro
and   v.cd_pro_fat = p.cd_pro_fat
and   v.cd_tab_fat = t.cd_tab_fat
and   g.cd_gru_fat = gf.cd_gru_fat
and   v.cd_pro_fat = uvigente.cd_pro_fat
and   v.dt_vigencia = uvigente.dt_vigencia
and   p.cd_pro_fat = filme.cd_pro_fat (+)
and   it.cd_tab_fat = t.cd_tab_fat
and   it.cd_gru_pro = p.cd_gru_pro
and   it.cd_regra = r.cd_regra
and v.cd_tab_fat in (823,942,2607)
AND V.VL_TOTAL >= 1000.0000
--and  p.cd_pro_fat = '00001729'
order by p.cd_pro_fat
