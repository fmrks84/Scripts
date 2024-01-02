SELECT * FROM dbamv.custo_medio
WHERE cd_produto = 1800
 AND cd_multi_empresa = 2
and cd_estoque = 5
--and qt_estoque_antes < 0
ORDER BY dt_custo desc  
   for update;

--/*
UPDATE dbamv.custo_medio 
   set QT_ESTOQUE_ANTES = QT_ESTOQUE_ANTES_DO_ESTOQUE 
 WHERE cd_produto = 63916
   AND CD_MULTI_EMPRESA = 2
 and qt_estoque_antes < 0
 --  AND cd_custo_medio IN (3606416,3606416,3600752,3590528) --,3581595,3585230,3586296,3584623)--,3556819,3558204,3563053)
--commit;
--*/

select * from dbamv.lot_pro where cd_produto = 56562-- and cd_estoque = 1 --cd_lote = '121112A'

update dbamv.custo_medio
 set vl_custo_medio = 0.76196247
 ,vl_custo_medio_antes = 0.76196247
 where cd_custo_medio = 3590260
 
 
 SELECT * FROM dbamv.controle_execucao_cmm WHERE HR_FIM IS null                                                               

delete from dbamv.controle_execucao_cmm where HR_FIM IS NULL



select i.CD_ENT_PRO
      ,i.cd_itent_pro
      ,i.CD_PRODUTO
      ,e.cd_ord_com
      ,e.TP_DOCUMENTO_ENTRADA
      ,i.QT_ENTRADA
      ,i.QT_ATENDIDA
      ,e.cd_estoque
      ,e.CD_FORNECEDOR
      ,e.DT_ENTRADA
      ,e.NR_DOCUMENTO
      ,i.VL_UNITARIO
    ,i.VL_TOTAL VL_TOTAL_IT    
      ,e.VL_TOTAL VL_TOTAL_ENT
    ,u.VL_FATOR
      ,i.VL_UNITARIO / u.VL_FATOR VL_CUSTO_REF
FROM dbamv.itent_pro i
    ,dbamv.ent_pro e
    ,dbamv.uni_pro u 
WHERE i.CD_ENT_PRO = e.CD_ENT_PRO
AND   i.CD_UNI_PRO = u.CD_UNI_PRO
AND i.cd_produto = 50334
--AND e.cd_estoque = 90 
--AND e.CD_FORNECEDOR = 7535
AND DT_ENTRADA >= To_Date('01/03/2014','DD/MM/YYYY')
AND e.TP_DOCUMENTO_ENTRADA = 'N'
--AND i.VL_UNITARIO < 54
ORDER BY e.DT_ENTRADA DESC
