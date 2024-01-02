select distinct(pro_fat.cd_pro_fat), 
       pro_fat.ds_pro_fat, 
       gru_pro.cd_gru_pro, 
       gru_pro.ds_gru_pro,
       produto.cd_produto,
       produto.ds_produto,
       especie.cd_especie,
       especie.ds_especie,
       produto.cd_classe,
       classe.ds_classe,
       --SubStr(produto.ds_produto,instr(produto.ds_produto,'REF')+4,50) CAMPO_REF,
       tuss.cd_tip_tuss,
       tuss.cd_tuss,
       tuss.ds_tuss,
       tuss.cd_convenio,
       tuss.data,
       u.vl_total,
       u.dt_vigencia data_valor,
       empresa_produto.vl_ultima_entrada,
       empresa_produto.vl_custo_medio


from pro_fat, gru_pro , produto , lab_pro, empresa_produto, especie, classe,

(SELECT T.CD_TIP_TUSS 
       ,T.CD_TUSS 
       ,T.DS_TUSS 
       ,T.CD_PRO_FAT 
       ,T.CD_CONVENIO
       ,T.DT_INICIO_VIGENCIA DATA 
       FROM TUSS T 
       ,(SELECT CD_PRO_FAT , 
            MAX(DT_INICIO_VIGENCIA)DATAX  
            FROM TUSS
        WHERE CD_CONVENIO = 205
        AND CD_MULTI_EMPRESA = 25
        AND DT_FIM_VIGENCIA IS NULL
        AND CD_TIP_TUSS IN (0,19)
        GROUP BY CD_PRO_FAT
        )T2
WHERE T.CD_PRO_FAT = T2.CD_PRO_FAT
AND   T.DT_INICIO_VIGENCIA = T2.DATAX
AND nvl(T.CD_CONVENIO,205) = 205 
AND T.CD_MULTI_EMPRESA = 25
AND T.DT_FIM_VIGENCIA IS NULL
AND T.CD_TIP_TUSS IN (0,19)

) TUSS

,(select --decode(t.cd_tab_fat,'526','CSSJ','581','CSSJ','1','HSC','181','HSC','690','HSJ','1081','822','HST','941','HST','961','HCNSC','872','HCNSC') CASAS,
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
       v.vl_total



from val_pro v ,
     pro_fat p ,
     gru_pro g ,
     gru_fat gf,
     tab_fat t ,
     (select  vx.cd_tab_fat,
                       px.cd_pro_fat,
             max(vx.dt_vigencia) dt_vigencia


       from val_pro vx , pro_fat px
       where vx.cd_pro_fat = px.cd_pro_fat
      --and px.cd_gru_pro in (7,12,91,92,8,89,43,44,55,94,95,96) 
       and vx.cd_tab_fat in (1705)
      --and vx.cd_tab_fat in (526,581,1,181,690,1081,822,941,961,872)
       group by
             vx.cd_tab_fat,
             px.cd_pro_fat,
             px.ds_pro_fat) uvigente



where p.cd_gru_pro =  g.cd_gru_pro
and   v.cd_pro_fat = p.cd_pro_fat
and   v.cd_tab_fat = t.cd_tab_fat
and   g.cd_gru_fat = gf.cd_gru_fat
and   v.cd_pro_fat = uvigente.cd_pro_fat
and   v.dt_vigencia = uvigente.dt_vigencia
and   v.cd_tab_fat = uvigente.cd_tab_fat
--and   p.cd_gru_pro in (7,12,43,44,94,92) 
and   v.cd_tab_fat in (1705)
--and v.cd_tab_fat in (526,581,1,181,690,1081,822,941,961,872)
order by 4) u




where pro_fat.cd_gru_pro = gru_pro.cd_gru_pro
and   pro_fat.cd_pro_fat = produto.cd_pro_fat (+)
and   produto.cd_produto = empresa_produto.cd_produto (+)
and  produto.cd_produto = lab_pro.cd_produto (+)
and  produto.cd_especie = especie.cd_especie
and  especie.cd_especie = classe.cd_especie
and  produto.cd_classe = classe.cd_classe
AND  pro_fat.cd_pro_fat = u.cd_pro_fat (+)
and  pro_fat.cd_pro_fat = tuss.cd_pro_fat
AND  produto.cd_especie in (61,19,20)
--and  PRO_FAT.CD_GRU_PRO IN (7,12,43,44,94,92) 
and empresa_produto.cd_multi_empresa = 25
and empresa_produto.sn_movimentacao = 'S'
--and pro_fat.cd_pro_fat = '70258260'
and produto.sn_mestre = 'N'
