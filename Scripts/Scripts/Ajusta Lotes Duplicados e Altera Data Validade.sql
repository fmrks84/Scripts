ALTER TRIGGER dbamv.trg_lot_pro DISABLE
/
ALTER TRIGGER dbamv.trg_u_ent_pro DISABLE
/
ALTER TRIGGER dbamv.trg_u_mvto_estoque DISABLE
/
ALTER TRIGGER dbamv.trg_contagem DISABLE
/
ALTER TRIGGER dbamv.trg_prod_atend DISABLE
/
ALTER TRIGGER dbamv.trg_u_itent_pro DISABLE
/
ALTER TRIGGER dbamv.trg_i_itent_pro DISABLE
/
ALTER TRIGGER dbamv.trg_d_itent_pro DISABLE
/
ALTER TRIGGER dbamv.trg_u_itmvto_estoque DISABLE
/
ALTER TRIGGER dbamv.trg_d_itmvto_estoque DISABLE
/
ALTER TRIGGER dbamv.trg_i_itmvto_estoque DISABLE
/

DECLARE

   CURSOR clotedup
   IS
      SELECT l1.cd_estoque,
           l1.cd_produto, 
           max(l1.dt_validade) dt_validade, 
           SUM (nvl(qt_estoque_atual,0)) qt_estoque_atual,
           l1.cd_lote, 
           'N' sn_bloqueio,
           SUM (nvl(qt_estoque_doado,0)) qt_estoque_doado,
           null ds_marca,
           sum(nvl(l1.qt_orcamentario,0)) qt_orcamentario,
           sum(nvl(l1.qt_extra_orcamentario,0)) qt_extra_orcamentario,
           SUM (qt_kit) qt_kit,
           COUNT (*)         
    FROM dbamv.lot_pro l1
GROUP BY l1.cd_estoque, l1.cd_produto, l1.cd_lote
  HAVING COUNT (*) > 1;
BEGIN

    FOR vlote IN clotedup LOOP
   
       UPDATE DBAMV.LOT_PRO
          SET QT_ESTOQUE_ATUAL          = 0,
              QT_ESTOQUE_DOADO          = 0,
              qt_orcamentario           = 0,
              qt_extra_orcamentario     = 0,
              QT_KIT                    = 0,
              SN_BLOQUEIO               = 'S'
        WHERE CD_PRODUTO                = vlote.cd_produto
          AND CD_ESTOQUE                = vlote.cd_estoque
          AND nvl(CD_LOTE,'*CORRECAO*') = nvl(vlote.cd_lote,'*CORRECAO*');     

       UPDATE DBAMV.LOT_PRO
          SET QT_ESTOQUE_ATUAL          = vlote.qt_estoque_atual,
              QT_ESTOQUE_DOADO          = vlote.qt_estoque_doado,
              qt_orcamentario           = vlote.qt_estoque_atual, --vlote.qt_orcamentario,
              qt_extra_orcamentario     = vlote.qt_extra_orcamentario,
              QT_KIT                    = vlote.qt_kit,
              SN_BLOQUEIO               = 'N'
        WHERE CD_PRODUTO                = vlote.cd_produto
          AND CD_ESTOQUE                = vlote.cd_estoque
          AND nvl(CD_LOTE,'*CORRECAO*') = nvl(vlote.cd_lote,'*CORRECAO*')
          AND DT_VALIDADE               = vlote.dt_validade; 
          
    END LOOP;                
END;
/
/*
	Se for colocar para o último dia do mes, descomentar:
		set dt_validade = last_day(dt_validade) 
	se for no promeiro dia do mes, descomentar:
		set dt_validade = trunc(dt_validade, 'MONTH') 
*/
update dbamv.identificador_etiqueta	
   set dt_validade = last_day(dt_validade) 
   --set dt_validade = trunc(dt_validade, 'MONTH') 
 where dt_validade is not null
   and dt_validade <> last_day(dt_validade)
   and trunc(dt_validade) >= trunc(sysdate-30, 'MONTH') --------------->>>>>>>>>>>>>>> SE ESTIVER COMENTADO VAI PEGAR TODAS AS VALIDADES <<<<<<<<<<<
   and nvl(sn_ativo,'S') = 'S'
/


/*
	Se for colocar para o último dia do mes, descomentar:
		set dt_validade = last_day(dt_validade) 
	se for no promeiro dia do mes, descomentar:
		set dt_validade = trunc(dt_validade, 'MONTH') 
*/
update dbamv.lot_pro
   set dt_validade = last_day(dt_validade) 
   --set dt_validade = trunc(dt_validade, 'MONTH') 
 where dt_validade is not null
   and dt_validade <> last_day(dt_validade)
   and trunc(dt_validade) >= trunc(sysdate -30, 'MONTH') --------------->>>>>>>>>>>>>>> SE ESTIVER COMENTADO VAI PEGAR TODAS AS VALIDADES <<<<<<<<<<<
   and nvl(sn_bloqueio,'N') = 'N'
/
ALTER TRIGGER dbamv.trg_lot_pro ENABLE
/
ALTER TRIGGER dbamv.trg_u_ent_pro ENABLE
/
ALTER TRIGGER dbamv.trg_u_mvto_estoque ENABLE
/
ALTER TRIGGER dbamv.trg_contagem ENABLE
/
ALTER TRIGGER dbamv.trg_prod_atend ENABLE
/
ALTER TRIGGER dbamv.trg_u_itent_pro ENABLE
/
ALTER TRIGGER dbamv.trg_i_itent_pro ENABLE
/
ALTER TRIGGER dbamv.trg_d_itent_pro ENABLE
/
ALTER TRIGGER dbamv.trg_u_itmvto_estoque ENABLE
/
ALTER TRIGGER dbamv.trg_d_itmvto_estoque ENABLE
/
ALTER TRIGGER dbamv.trg_i_itmvto_estoque ENABLE
/
