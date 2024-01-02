-- MV Sistemas
--<DS_SCRIPT>
-- VERSÃO SCRIPIT.:10.0
-- DESCRIÇÃO......: Correção do legado devido a problemas passados resolvidos na versão 47E71 e 48J05 no PDA
-- ORIENTAÇÃO.....: Esse script deve ser executado com acompanhamento OBRIGATÓRIO do analista do desenvolvimento.
--                  Esse script deve ser executado com o usuário DBAMV.
--                  Deve ser verificado se todas as estapas foram concluídas com sucesso.
--                  A previsão é em média 5 seg a 20 minutos a depender do legado.
--                  Durante a execussão todo processo de compras e entrada de nota fiscal ficaram parados.
--                  Caso o script pare antes do fim deve ser executada a parte final que reabilitas as triggers.
--                  Ao termino do scpripte verificar se todas as etapas foram concluídas.
-- RESPONSAVEL....: João Paulo F. Ferraz / Jorge Augusto
-- DATA...........: 28-04-2009
-- APLICAÇÃO......: MGCO - Gerenciamento de Compras
--</DS_SCRIPT>
--<USUARIO=DBAMV>

alter package dbamv.pkg_mgco_ordcom compile
/
alter package dbamv.mgco compile
/
alter trigger dbamv.trg_ord_com_prev_aft_upd disable
/
alter trigger dbamv.trg_u_itsol_com disable
/
alter trigger dbamv.trg_i_itsol_com disable
/
alter trigger dbamv.trg_u_itsol_com disable
/
alter trigger dbamv.trg_d_itsol_com disable
/
alter trigger dbamv.trg_u_ent_pro disable
/
alter trigger dbamv.trg_u_itent_pro disable
/
alter trigger dbamv.trg_i_itent_pro disable
/
alter trigger dbamv.trg_d_itent_pro disable
/
alter trigger dbamv.trg_u_itord_pro disable
/
alter trigger dbamv.trg_i_itord_pro disable
/
alter trigger dbamv.trg_d_itord_pro disable
/
alter trigger dbamv.trg_d_itord_pro disable
/
alter trigger dbamv.trg_ord_com_controla_ord disable
/

----------------------------------------------------------------------------------------------------------
-- ********** CORRIGE AS QUANTIDADES CANCELADA, RECEBIDA E MOTIVO DE CANCELAMENTONA ORD_COM **************
DECLARE

 Cursor cQtEntrada is
	Select o.cd_ord_com,
    	   i.cd_produto,
    	   Nvl(i.qt_comprada,0) qt_comprada,
	       Sum(Nvl(i.qt_recebida, (Nvl(t.qt_atendida,0)*ut.vl_fator)/ui.vl_fator)) qt_recebida,
           Nvl(i.qt_cancelada,0) qt_cancelada,
           i.cd_mot_cancel,
	       Sum(nvl(t.qt_entrada,0) ) qt_entrada,
	       Sum(nvl(t.qt_atendida,0) ) qt_atendida_ent
	  From dbamv.ord_com o
	      ,dbamv.itord_pro i
	      ,dbamv.ent_pro e
	      ,dbamv.itent_pro t
        ,dbamv.uni_pro ut
        ,dbamv.uni_pro ui
	 Where o.cd_ord_com = i.cd_ord_com
	   and e.cd_ent_pro = t.cd_ent_pro
	   and o.cd_ord_com = e.cd_ord_com
	   and (i.cd_produto = t.cd_produto OR
          t.cd_produto IN (SELECT cd_produto
                           FROM dbamv.produto
                           WHERE cd_produto_tem = i.cd_produto))
     AND t.cd_uni_pro = ut.cd_uni_pro
     AND i.cd_uni_pro = ui.cd_uni_pro
     AND NVL (o.tp_contrato, 'O') = 'O'
	 Group by o.cd_ord_com,
	       i.cd_produto,
	       Nvl(i.qt_comprada,0),
	       Nvl(i.qt_recebida,0),
           Nvl(i.qt_cancelada,0),
           i.cd_mot_cancel
	  Having Sum(nvl(t.qt_atendida, 0)) <> Nvl(i.qt_recebida, 0) or
	         Nvl(i.qt_comprada,0) < Nvl(i.qt_recebida, 0) + Nvl(i.qt_cancelada,0);

begin
   -- Zera a quantidade recebida para OC contrato (<> O).
   Update dbamv.itord_pro
      Set qt_recebida  = 0
    Where exists (Select cd_ord_com
                   From dbamv.ord_com
                   Where cd_ord_com = itord_pro.cd_ord_com
                     And  NVL(tp_contrato, 'O') <> 'O');

   -- Atualiza os dados do cancelamento para os itens com código de cancelamento.
   UPDATE dbamv.itord_pro
      SET qt_cancelada = abs(qt_comprada - nvl(qt_recebida,0)),
          nm_usuario = nvl(nm_usuario, user),
          dt_cancel = nvl(dt_cancel, sysdate)
    WHERE cd_mot_cancel is not null
      AND nvl(qt_cancelada, 0) = 0;

   UPDATE dbamv.itord_pro
      SET nm_usuario = null,
          dt_cancel = null
    WHERE cd_mot_cancel is null
      AND nm_usuario is not null;

   UPDATE dbamv.itord_pro
      SET nm_usuario = null,
          dt_cancel = null,
          cd_mot_cancel = null
    WHERE cd_mot_cancel is not null
      AND nvl(qt_recebida,0) > 0;

-- Atualiza a quantidade atendida na entrada quando tiver zerada.
   UPDATE dbamv.itent_pro
      SET qt_atendida = qt_entrada
    WHERE nvl(qt_atendida,0) = 0;

-- Anula as quantidades recebidas e canceladas quando o item não tiver entrada.
UPDATE dbamv.itord_pro
   SET qt_recebida = NULL,
       qt_cancelada = NULL
 WHERE EXISTS (
          SELECT cd_produto
            FROM dbamv.itord_pro it, dbamv.ord_com o
           WHERE o.cd_ord_com = it.cd_ord_com
             AND o.tp_situacao NOT IN ('N', 'C', 'T')
             AND o.tp_ord_com  = 'P'
             AND NVL (o.tp_contrato, 'O') = 'O'
             AND (it.qt_recebida > 0 or it.qt_cancelada > 0)
             AND it.cd_mot_cancel is null
             AND NOT EXISTS (
                    SELECT cd_produto
                      FROM dbamv.ent_pro e, dbamv.itent_pro i
                     WHERE e.cd_ent_pro = i.cd_ent_pro
                       AND e.cd_ord_com = it.cd_ord_com
                       AND (   i.cd_produto = it.cd_produto
                            OR i.cd_produto IN (
                                          SELECT cd_produto
                                            FROM dbamv.produto
                                           WHERE cd_produto_tem =
                                                                 it.cd_produto)
                           ))
             AND itord_pro.cd_produto = it.cd_produto
             AND itord_pro.cd_ord_com = it.cd_ord_com);
   --
    For vEntrada in cQtEntrada Loop
      If vEntrada.qt_atendida_ent + vEntrada.qt_cancelada >= vEntrada.qt_comprada then
	    Update dbamv.itord_pro
           Set qt_recebida  = vEntrada.qt_atendida_ent,
               qt_cancelada = vEntrada.qt_comprada - vEntrada.qt_atendida_ent
         Where cd_ord_com   = vEntrada.cd_ord_com
           and cd_produto   = vEntrada.cd_produto;
      Elsif abs(vEntrada.qt_atendida_ent - vEntrada.qt_comprada) > 0  then
	    Update dbamv.itord_pro
           Set qt_recebida  = vEntrada.qt_atendida_ent,
               qt_cancelada = abs(vEntrada.qt_atendida_ent - vEntrada.qt_comprada)
         Where cd_ord_com   = vEntrada.cd_ord_com
           and cd_produto   = vEntrada.cd_produto;
      Elsif vEntrada.qt_entrada = vEntrada.qt_comprada and
	       vEntrada.qt_atendida_ent = vEntrada.qt_entrada then
	  	Update dbamv.itord_pro
           Set qt_recebida  = vEntrada.qt_atendida_ent,
               qt_cancelada = 0
         Where cd_ord_com   = vEntrada.cd_ord_com
           and cd_produto   = vEntrada.cd_produto;
      End If;
	commit;
	End Loop;
  commit;
end;
/

--------------------------------------------------------------------------------------------------
-- ********** CORRIGE SITUACAO ORD_COM ***********************************************************
DECLARE
CURSOR c1
   IS
      SELECT cd_ord_com, tp_situacao,
             dbamv.pkg_mgco_ordcom.fn_situacao (cd_ord_com) nova_situacao
        FROM dbamv.ord_com o
       WHERE tp_situacao <> dbamv.pkg_mgco_ordcom.fn_situacao (cd_ord_com)
         AND o.tp_situacao NOT IN ('N', 'C', 'T')
		 AND o.tp_ord_com  = 'P'
		 AND NVL (tp_contrato, 'O') = 'O'
	ORDER BY o.CD_ORD_COM DESC;
	 vCdMot number;

BEGIN

    UPDATE dbamv.ord_com
       SET tp_situacao = 'U'
     WHERE NVL (tp_contrato, 'O') <> 'O'
       AND tp_situacao IN ('L', 'T')
       AND ord_com.tp_ord_com  = 'P';

   SELECT MIN(CD_MOT_CANCEL)
     INTO vCdMot
     FROM DBAMV.MOT_CANCEL;

   UPDATE DBAMV.ORD_COM
      SET TP_SITUACAO = 'U'
    WHERE TP_ORD_COM  = 'S'
      AND CD_MOT_CANCEL IS NULL
      AND NVL (tp_contrato, 'O') = 'O'
      AND DT_CANCELAMENTO IS NULL
      AND CD_ORD_COM NOT IN (SELECT CD_ORD_COM
                               FROM DBAMV.ENT_SERV
                              WHERE CD_ORD_COM IS NOT NULL);

   UPDATE DBAMV.ORD_COM
      SET TP_SITUACAO = 'T'
    WHERE TP_ORD_COM  = 'S'
      AND CD_MOT_CANCEL IS NULL
      AND DT_CANCELAMENTO IS NULL
      AND NVL (tp_contrato, 'O') = 'O'
      AND CD_ORD_COM IN (SELECT CD_ORD_COM
                               FROM DBAMV.ENT_SERV
                              WHERE CD_ORD_COM IS NOT NULL);


   FOR v1 IN c1
   LOOP
      IF v1.nova_situacao = 'C' THEN
      	    DBAMV.pkg_Mgco_OrdCom.Pr_Cancela( v1.cd_ord_com
				                              , Null
				                              , vCdMot
				                              , sysdate
				                              , 'CORRECAO DE LEGADO'
				                              , 'N' );
      ELSE
	     UPDATE dbamv.ord_com
            SET tp_situacao = v1.nova_situacao
          WHERE cd_ord_com  = v1.cd_ord_com;
	  END IF;
	  commit;
   END LOOP;
   
   UPDATE DBAMV.ORD_COM
      SET TP_SITUACAO = 'C'   
    WHERE CD_MOT_CANCEL IS NOT NULL
      AND DT_CANCELAMENTO IS NOT NULL
      AND tp_situacao<> 'C'
      AND tp_ord_com  = 'P'
      AND NVL (tp_contrato, 'O') = 'O';
   commit;
END;
/

--------------------------------------------------------------------------------------------------
-- ********** CORRIGE TOTAIS ORD_COM ***********************************************************

DECLARE

  Cursor cOrd Is
    Select item.cd_ord_com,
           item.vl_total,
           sum(item.vl_total_new) vl_total_new
      From (
      	Select o.cd_ord_com,
      	       o.vl_total, i.cd_produto,
               (decode(i.cd_mot_cancel, null,
                     (decode(sign(Nvl(i.qt_comprada,0) - Nvl(i.qt_cancelada,0)), 1,
                           (Nvl(i.qt_comprada,0) - Nvl(i.qt_cancelada,0)),
                            Nvl(i.qt_comprada,0))),
                     0) *
               Nvl(i.vl_unitario,0) ) + Nvl(i.vl_imposto,0) - Nvl(i.vl_desconto,0) vl_total_new
	      From dbamv.ord_com o
	          ,dbamv.itord_pro i
    	where o.cd_ord_com = i.cd_ord_com
	      and o.tp_situacao not in ('C', 'T')
	      and NVL (o.tp_contrato, 'O') = 'O'
	      and o.tp_ord_com = 'P'
           ) item
 Group by item.cd_ord_com,
          item.vl_total
   Having round(sum(item.vl_total_new)) <> round(item.vl_total)
      And round(sum(item.vl_total_new)) > 0;

BEGIN

      Update dbamv.ord_com
         Set vl_total = 0
       Where tp_situacao not in ('C', 'T')
	     and NVL(tp_contrato, 'O') = 'V'
	     and tp_ord_com = 'P';

  For vOrd in cOrd Loop

      Update dbamv.ord_com
         Set vl_total = vOrd.vl_total_new
       Where cd_ord_com = vOrd.cd_ord_com;

  End Loop;

END;
/

----------------------------------------------------------------------------------------------------
-- ********** CORRIGE A SOLICITAÇÃO DE COMPRAS - ***************************************************

DECLARE
Cursor cItens is
select a.cd_sol_com,
       a.cd_produto,
       a.vl_fator,
       a.qt_solicitada,
       a.qt_comp,
       a.qt_atend,
       a.qt_comprada,
       DECODE(SIGN(nvl(a.qt_solicitada,0) - nvl(a.qt_atendida,0)),
              -1,
	          nvl(a.qt_solicitada,0),
              nvl(a.qt_atendida,0)) qt_atendida,
       a.tp_situacao,
	   a.cd_cancel
  from
 (select i.cd_sol_com,
         i.cd_produto,
         s.tp_situacao,
		 nvl(us.vl_fator,1) vL_fator,
		 nvl(i.cd_mot_cancel, 0) cd_cancel,
         (nvl(i.qt_solic,0)*nvl(us.vl_fator,1)) qt_solicitada,
         (nvl(i.qt_comprada,0)*nvl(us.vl_fator,1)) qt_comp,
		 (nvl(i.qt_atendida,0)*nvl(us.vl_fator,1)) qt_atend,
         sum(nvl(io.qt_comprada,0)*nvl(uo.vl_fator,1)) qt_comprada,
         sum(nvl(io.qt_atendida,0)*nvl(uo.vl_fator,1)) qt_atendida
    from dbamv.ord_com o,
         dbamv.itord_pro io,
         dbamv.sol_com s,
         dbamv.itsol_com i,
         dbamv.uni_pro uo,
         dbamv.uni_pro us
   where o.tp_ord_com = 'P'
     and o.cd_ord_com  = io.cd_ord_com
     and o.cd_sol_com  = i.cd_sol_com
     and io.cd_produto = i.cd_produto
     and s.cd_sol_com  = i.cd_sol_com
     and uo.cd_uni_pro (+) = io.cd_uni_pro
     and us.cd_uni_pro (+) = i.cd_uni_pro
     group by i.cd_sol_com,
              i.cd_produto,
              s.tp_situacao,
			  us.vl_fator,
			  i.cd_mot_cancel,
              i.qt_solic,
              i.qt_comprada,
		      i.qt_atendida
     ) a
 where a.tp_situacao not in ('F', 'C')
   and (a.qt_comprada >= a.qt_solicitada or
        a.qt_atendida <> qt_atend or
		a.qt_comprada <> a.qt_comp)
   and 	a.qt_comprada > 0
   and  a.cd_cancel   = 0
Union
select a.cd_sol_com,
       a.cd_produto,
       a.vl_fator,
       a.qt_solicitada,
       a.qt_comp,
       a.qt_atend,
       a.qt_comprada,
       DECODE(SIGN(nvl(a.qt_solicitada,0) - nvl(a.qt_atendida,0)),
              -1,
	          nvl(a.qt_solicitada,0),
              nvl(a.qt_atendida,0)) qt_atendida,
       a.tp_situacao,
	   a.cd_cancel
  from
 (select i.cd_sol_com,
         i.cd_produto,
         s.tp_situacao,
		 nvl(us.vl_fator,1) vL_fator,
		 nvl(i.cd_mot_cancel, 0) cd_cancel,
         (nvl(i.qt_solic,0)*nvl(us.vl_fator,1)) qt_solicitada,
         (nvl(i.qt_comprada,0)*nvl(us.vl_fator,1)) qt_comp,
		 (nvl(i.qt_atendida,0)*nvl(us.vl_fator,1)) qt_atend,
         sum(nvl(io.qt_comprada,0)*nvl(uo.vl_fator,1)) qt_comprada,
         sum(nvl(io.qt_atendida,0)*nvl(uo.vl_fator,1)) qt_atendida

    from dbamv.ord_com o,
         dbamv.itord_pro io,
         dbamv.sol_com s,
         dbamv.itsol_com i,
         dbamv.uni_pro uo,
         dbamv.uni_pro us
   where o.tp_ord_com  = 'P'
     and o.cd_ord_com  = io.cd_ord_com
     and o.cd_sol_com  = i.cd_sol_com
     and io.cd_produto in (select cd_produto
                             from dbamv.produto
                            where cd_produto_tem = i.cd_produto)
     and s.cd_sol_com  = i.cd_sol_com
     and uo.cd_uni_pro (+) = io.cd_uni_pro
     and us.cd_uni_pro (+) = i.cd_uni_pro
     group by i.cd_sol_com,
              i.cd_produto,
              s.tp_situacao,
			  us.vl_fator,
			  i.cd_mot_cancel,
              i.qt_solic,
              i.qt_comprada,
		      i.qt_atendida
     ) a
 where a.tp_situacao not in ('F', 'C')
   and (a.qt_comprada >= a.qt_solicitada or
        a.qt_atendida <> qt_atend or
		a.qt_comprada <> a.qt_comp)
   and 	a.qt_comprada > 0
   and  a.cd_cancel   = 0
union
select a.cd_sol_com,
       a.cd_produto,
       a.vl_fator,
       a.qt_solicitada,
       a.qt_comp,
       a.qt_atend,
       a.qt_comprada,
       a.qt_atendida,
       a.tp_situacao,
	   a.cd_cancel
  from
 (select i.cd_sol_com,
         i.cd_produto,
         s.tp_situacao,
		 nvl(us.vl_fator,1) vL_fator,
		 nvl(i.cd_mot_cancel, 0) cd_cancel,
         (nvl(i.qt_solic,0)*nvl(us.vl_fator,1)) qt_solicitada,
         (nvl(i.qt_comprada,0)*nvl(us.vl_fator,1)) qt_comp,
		 (nvl(i.qt_atendida,0)*nvl(us.vl_fator,1)) qt_atend,
         0 qt_comprada,
         0 qt_atendida
    from dbamv.sol_com s,
         dbamv.itsol_com i,
         dbamv.uni_pro us
   where s.tp_sol_com  = 'P'
     and s.cd_sol_com  = i.cd_sol_com
     and us.cd_uni_pro (+) = i.cd_uni_pro
     and s.cd_sol_com not in (Select nvl(cd_sol_com, 0)
                      from dbamv.ord_com)
     group by i.cd_sol_com,
              i.cd_produto,
              s.tp_situacao,
			  us.vl_fator,
			  i.cd_mot_cancel,
              i.qt_solic,
              i.qt_comprada,
		      i.qt_atendida
     ) a
 where a.tp_situacao not in ('F', 'C');

vCdProdutoTem number;
BEGIN

UPDATE dbamv.itsol_com
   SET cd_uni_pro = dbamv.verif_cd_unid_prod (cd_produto)
 WHERE (cd_sol_com, cd_produto) NOT IN (
                                       SELECT i.cd_sol_com, i.cd_produto
                                         FROM dbamv.itsol_com i,
                                              dbamv.uni_pro u
                                        WHERE u.cd_uni_pro = i.cd_uni_pro)
   AND (cd_sol_com, cd_produto) NOT IN (
                                  SELECT cd_sol_com, cd_produto
                                    FROM dbamv.itsol_com
                                   WHERE cd_produto NOT IN (
                                                            SELECT cd_produto
                                                              FROM dbamv.produto));


  UPDATE dbamv.itsol_com
     SET qt_atendida = qt_solic
   WHERE qt_atendida > qt_solic;

  For vItens in cItens Loop

     If vItens.qt_atend < vItens.qt_solicitada then
	     UPDATE dbamv.itsol_com
    	    SET qt_comprada = vItens.qt_comprada/vItens.vl_fator
        	   ,qt_atendida = vItens.qt_atendida/vItens.vl_fator
	      WHERE cd_sol_com  = vItens.cd_sol_com
	        AND cd_produto  = vItens.cd_produto;
      Else
	     UPDATE dbamv.itsol_com
	        SET qt_comprada = vItens.qt_comprada/vItens.vl_fator
	      WHERE cd_sol_com  = vItens.cd_sol_com
	        AND cd_produto  = vItens.cd_produto;
      End If;

		commit;
  End Loop;

  commit;
END;
/
------------------------------------------------------------------------------------------------------
-- ********************* CORRIGE SITUAÇÃO DA SOLICITAÇÃO DE COMPRAS **********************************
DECLARE

Cursor cSolcom Is
    SELECT i.Cd_sol_com
         , NVL(SUM(i.qt_solic), 0) Qt_Solic
         , NVL(SUM(DECODE(SIGN(NVL(i.qt_solic, 0) - NVL(i.qt_atendida,0))
                       , -1 ,
                       NVL(i.qt_solic,0),
	     			   NVL(i.qt_atendida,0)
                       )
                )
          ,0) Qt_Atendida,
           NVL(SUM(DECODE(NVL(i.cd_mot_cancel, 0),
                       0,
                       0,
                       NVL(i.qt_solic, 0)
                       )
                 ),
           0) Qt_cancel
          ,s.tp_situacao
      FROM Dbamv.Itsol_com i,
           Dbamv.sol_com s
     WHERE s.tp_situacao in ('A', 'P')
       AND s.cd_sol_com = i.cd_sol_com
	   AND s.tp_sol_com = 'P'
  GROUP BY i.Cd_sol_com,
           s.tp_situacao;

  v_tp_situacao varchar2(1);

BEGIN
For vQtSolcom in cSolcom Loop

     IF NVL(vQtSolCom.Qt_Cancel, 0) >= NVL(vQtSolCom.Qt_solic, 0) AND NVL(vQtSolCom.qt_atendida, 0) = 0 THEN
        v_tp_situacao := 'C';
     ELSIF NVL(vQtSolCom.qt_atendida, 0) + NVL(vQtSolCom.Qt_Cancel, 0) >= NVL(vQtSolCom.Qt_solic, 0) THEN
        v_tp_situacao := 'F';
     ELSIF NVL(vQtSolCom.qt_atendida,0) > 0 THEN
        v_tp_situacao := 'P';
     ELSIF NVL(vQtSolCom.qt_solic,0) - NVL(vQtSolCom.Qt_Cancel, 0) <> NVL(vQtSolCom.qt_atendida,0)
	   AND NVL(vQtSolCom.qt_atendida,0) = 0 THEN
        v_tp_situacao := 'A';
     END IF;
     --
     IF v_tp_situacao IS NOT NULL AND v_tp_situacao <> vQtSolcom.tp_situacao THEN
        --
        UPDATE dbamv.sol_com
           SET tp_situacao = v_tp_situacao
         WHERE cd_sol_com  = vQtSolcom.cd_sol_com;
        --
        UPDATE dbamv.sol_com
           SET sol_com.tp_situacao = v_tp_situacao
         WHERE sol_com.cd_sol_com in (SELECT sol_com.cd_sol_com
                                        FROM dbamv.sol_com
                                       WHERE sol_com.cd_sol_com_tem = vQtSolcom.cd_sol_com );
        --
     END IF;
	 commit;
  End Loop;
  commit;
END;
/
------------------------------------------------------------------------------------------------
-- ******************************** POPULA EST_PRO *********************************************

 DECLARE
        --Produtos que estão na ordem e não estão na est_pro:

CURSOR cProdSemEst IS

SELECT i.cd_produto, o.cd_estoque
  FROM dbamv.itord_pro i, dbamv.ord_com o
 WHERE o.cd_ord_com = i.cd_ord_com
   AND (i.cd_produto, o.cd_estoque) NOT IN (
          SELECT i.cd_produto, o.cd_estoque
            FROM dbamv.itord_pro i, dbamv.ord_com o, dbamv.est_pro e
           WHERE o.cd_ord_com = i.cd_ord_com
             AND o.cd_estoque = e.cd_estoque
             AND i.cd_produto = e.cd_produto)
UNION
SELECT i.cd_produto, s.cd_estoque
  FROM dbamv.itsol_com i, dbamv.sol_com s
 WHERE s.cd_sol_com = i.cd_sol_com
   AND (i.cd_produto, s.cd_estoque) NOT IN (
          SELECT i.cd_produto, s.cd_estoque
            FROM dbamv.itsol_com i, dbamv.sol_com s, dbamv.est_pro e
           WHERE s.cd_sol_com = i.cd_sol_com
             AND s.cd_estoque = e.cd_estoque
             AND i.cd_produto = e.cd_produto);
vCdProdutoTem number;

BEGIN
 	  For vProdSemEst in cProdSemEst Loop

	     DBAMV.MGCO.P_VERIF_EST_PRO(vProdSemEst.cd_estoque,
                  vProdSemEst.cd_produto,
                  vCdProdutoTem, -- Retorna o código do mestre, se houver.
                  'I' );
		COMMIT;
	  End Loop;
 commit;
END;
/
----------------------------------------------------------------------------------
--************** CORRIGE AS QUANTIDADES DE SOL E ORD NA EST_PRO ******************

DECLARE
        --Cursor para atualizar o qt_solicitacao dos produtos mestres
        cursor c_est_pro_sol_com_mestre is
           select est_pro.cd_produto                cd_produto
                 ,est_pro.cd_estoque                cd_estoque
                 ,est_pro.qt_solicitacao_de_compra  qt_solicitacao_de_compra
                 ,solicitacoes.total                total
               from   dbamv.est_pro,  dbamv.produto
                   ,(select sum(nvl(itsol_com.qt_solic,0)*nvl(uni_pro.vl_fator,0) -
                             nvl(itsol_com.qt_atendida,0)*nvl(uni_pro.vl_fator,0) ) total
                        ,decode(produto.sn_mestre, 'S', produto.cd_produto, produto.cd_produto_tem) cd_produto_tem
                        ,cd_estoque
                     from   dbamv.itsol_com  itsol_com
                           ,dbamv.sol_com    sol_com
                           ,dbamv.uni_pro    uni_pro
                           ,dbamv.produto   produto
                     where itsol_com.cd_sol_com = sol_com.cd_sol_com
                     and   itsol_com.cd_uni_pro = uni_pro.cd_uni_pro
                     and   itsol_com.cd_produto = produto.cd_produto
                     and   sol_com.tp_situacao not in ('F', 'C')
                     and   itsol_com.cd_mot_cancel is null
                     group by decode(produto.sn_mestre, 'S', produto.cd_produto, produto.cd_produto_tem), cd_estoque
                     order by decode(produto.sn_mestre, 'S', produto.cd_produto, produto.cd_produto_tem), cd_estoque) solicitacoes
               where  solicitacoes.cd_produto_tem(+) = est_pro.cd_produto
               and    solicitacoes.cd_estoque(+)     = est_pro.cd_estoque
               and    nvl(est_pro.qt_solicitacao_de_compra,0) <> nvl(solicitacoes.total, 0)
               and    est_pro.cd_produto = produto.cd_produto
               and    produto.sn_mestre = 'S'
               order by est_pro.cd_produto;

        --Cursor para atualizar o qt_ordem_de_compra dos produtos não mestre
        cursor c_est_pro_ord_com_n_mestre is
          select est_pro.cd_produto                cd_produto
            ,est_pro.cd_estoque                cd_estoque
            ,est_pro.qt_ordem_de_compra        qt_ordem_de_compra
            ,Decode(Sign(ordens.total), -1, 0, ordens.total) total
            ,ordens.tp_contrato
          from   dbamv.est_pro
             ,dbamv.produto
             ,(select sum(
                       decode(sign( nvl(itord_pro.qt_comprada,0)*nvl(uni_pro.vl_fator,0) -
                                   (nvl(itord_pro.qt_recebida,0)*nvl(uni_pro.vl_fator,0) +
                                    nvl(itord_pro.qt_cancelada,0)*nvl(uni_pro.vl_fator,0)) ), -1, 0, 
                                    nvl(itord_pro.qt_comprada,0)*nvl(uni_pro.vl_fator,0) -
                                   (nvl(itord_pro.qt_recebida,0)*nvl(uni_pro.vl_fator,0) +
                                    nvl(itord_pro.qt_cancelada,0)*nvl(uni_pro.vl_fator,0)) )
                        ) total
                     ,itord_pro.cd_produto
                     ,cd_estoque, ord_com.tp_contrato
               from   dbamv.itord_pro itord_pro
                     ,dbamv.ord_com   ord_com
                     ,dbamv.uni_pro   uni_pro
               where itord_pro.cd_ord_com = ord_com.cd_ord_com
               and   itord_pro.cd_uni_pro = uni_pro.cd_uni_pro
               and   ord_com.tp_situacao not in ('T', 'C')
               and   itord_pro.cd_mot_cancel is null
               group by itord_pro.cd_produto, cd_estoque, ord_com.tp_contrato) ordens
            where    ordens.cd_produto(+) = est_pro.cd_produto
              and    ordens.cd_estoque(+) = est_pro.cd_estoque
              and    nvl(est_pro.qt_ordem_de_compra,0) <> nvl(ordens.total, 0)
              and    produto.cd_produto = est_pro.cd_produto
              and    produto.sn_mestre = 'N'
              and    nvl(ordens.tp_contrato, 'O') = 'O'
              order by est_pro.cd_produto;

    --Cursor para atualizar o qt_ord_com dos produtos mestres
    cursor c_est_pro_ord_com_mestre is
      select est_pro.cd_produto                cd_produto
            ,est_pro.cd_estoque                cd_estoque
            ,est_pro.qt_ordem_de_compra        qt_ordem_de_compra
            ,Decode(Sign(ordens.total), -1, 0, ordens.total) total
            ,ordens.tp_contrato
      from   dbamv.est_pro,
             dbamv.produto
             ,(select sum(
                       decode(sign( nvl(itord_pro.qt_comprada,0)*nvl(uni_pro.vl_fator,0) -
                                   (nvl(itord_pro.qt_recebida,0)*nvl(uni_pro.vl_fator,0) +
                                    nvl(itord_pro.qt_cancelada,0)*nvl(uni_pro.vl_fator,0)) ), -1, 0, 
                                    nvl(itord_pro.qt_comprada,0)*nvl(uni_pro.vl_fator,0) -
                                   (nvl(itord_pro.qt_recebida,0)*nvl(uni_pro.vl_fator,0) +
                                    nvl(itord_pro.qt_cancelada,0)*nvl(uni_pro.vl_fator,0)) )
                        ) total
                     ,decode(produto.sn_mestre, 'S', produto.cd_produto, produto.cd_produto_tem) cd_produto_tem
                     ,cd_estoque, ord_com.tp_contrato
               from   dbamv.itord_pro itord_pro
                     ,dbamv.ord_com   ord_com
                     ,dbamv.uni_pro   uni_pro
                     ,dbamv.produto   produto
               where itord_pro.cd_ord_com = ord_com.cd_ord_com
               and   itord_pro.cd_uni_pro = uni_pro.cd_uni_pro
               and   itord_pro.cd_produto = produto.cd_produto
               and   ord_com.tp_situacao not in ('T', 'C')
               and   itord_pro.cd_mot_cancel is null
               group by decode(produto.sn_mestre, 'S', produto.cd_produto, produto.cd_produto_tem), cd_estoque, ord_com.tp_contrato
               order by decode(produto.sn_mestre, 'S', produto.cd_produto, produto.cd_produto_tem), cd_estoque) ordens
             where  ordens.cd_produto_tem(+) = est_pro.cd_produto
               and    ordens.cd_estoque(+)     = est_pro.cd_estoque
               and    nvl(est_pro.qt_ordem_de_compra,0) <> nvl(ordens.total, 0)
               and    est_pro.cd_produto = produto.cd_produto
               and    nvl(ordens.tp_contrato, 'O') = 'O'
               and    produto.sn_mestre = 'S'
              order by est_pro.cd_produto;

    --Cursor para atualizar o qt_solicitacao dos produtos não mestres
    cursor c_est_pro_sol_com_n_mestre is
      select est_pro.cd_produto                cd_produto
            ,est_pro.cd_estoque                cd_estoque
            ,est_pro.qt_solicitacao_de_compra  qt_solicitacao_de_compra
            ,solicitacoes.total                total
      from   dbamv.est_pro
             ,dbamv.produto
             ,(select sum(nvl(itsol_com.qt_solic,0)*nvl(uni_pro.vl_fator,0) -
                          nvl(itsol_com.qt_atendida,0)*nvl(uni_pro.vl_fator,0) ) total
                     ,itsol_com.cd_produto
                     ,cd_estoque
               from   dbamv.itsol_com  itsol_com
                     ,dbamv.sol_com    sol_com
                     ,dbamv.uni_pro    uni_pro
               where itsol_com.cd_sol_com = sol_com.cd_sol_com
               and   itsol_com.cd_uni_pro = uni_pro.cd_uni_pro
               and   sol_com.tp_situacao not in ('F', 'C')
               and   itsol_com.cd_mot_cancel is null
               group by itsol_com.cd_produto, cd_estoque
               order by itsol_com.cd_produto, cd_estoque) solicitacoes
      where  solicitacoes.cd_produto(+) = est_pro.cd_produto
      and    solicitacoes.cd_estoque(+) = est_pro.cd_estoque
      and    nvl(est_pro.qt_solicitacao_de_compra,0) <> nvl(solicitacoes.total, 0)
      and    est_pro.cd_produto = produto.cd_produto
      and    produto.sn_mestre = 'N'
      order by est_pro.cd_produto;

BEGIN

      for c_record in c_est_pro_sol_com_mestre loop
         update dbamv.est_pro
         set    qt_solicitacao_de_compra = nvl(c_record.total, 0)
         where  cd_estoque = c_record.cd_estoque
         and    cd_produto = c_record.cd_produto;
       commit;
      end loop;


      for c_record in c_est_pro_ord_com_mestre loop
         update dbamv.est_pro
         set    qt_ordem_de_compra = nvl(c_record.total, 0)
         where  cd_estoque = c_record.cd_estoque
         and    cd_produto = c_record.cd_produto;
       commit;
      end loop;


      for c_record in c_est_pro_ord_com_n_mestre loop
         update dbamv.est_pro
         set    qt_ordem_de_compra = nvl(c_record.total, 0)
         where  cd_estoque = c_record.cd_estoque
         and    cd_produto = c_record.cd_produto;
    	commit;
      end loop;

      for c_record in c_est_pro_sol_com_n_mestre loop
         update dbamv.est_pro
         set    qt_solicitacao_de_compra = nvl(c_record.total, 0)
         where  cd_estoque = c_record.cd_estoque
         and    cd_produto = c_record.cd_produto;
 		commit;
      end loop;

   commit;
   dbms_output.put_line('Finalizado com Sucesso!');
END;
/
--******************* A T E N Ç Ã O *******************************************************************************
--*****************************************************************************************************************
--********* CASO DÊ PROBLEMAS EXECUTE A PARTIR DAQUI **************************************************************
--*****************************************************************************************************************

-- enable:
alter trigger dbamv.trg_ord_com_prev_aft_upd enable
/
alter trigger dbamv.trg_u_itsol_com enable
/
alter trigger dbamv.trg_i_itsol_com enable
/
alter trigger dbamv.trg_u_itsol_com enable
/
alter trigger dbamv.trg_d_itsol_com enable
/
alter trigger dbamv.trg_u_ent_pro enable
/
alter trigger dbamv.trg_u_itent_pro enable
/
alter trigger dbamv.trg_i_itent_pro enable
/
alter trigger dbamv.trg_d_itent_pro enable
/
alter trigger dbamv.trg_u_itord_pro enable
/
alter trigger dbamv.trg_i_itord_pro enable
/
alter trigger dbamv.trg_d_itord_pro enable
/
alter trigger dbamv.trg_d_itord_pro enable
/
alter trigger dbamv.trg_ord_com_controla_ord enable
/
-- compilação:
alter trigger dbamv.trg_u_itsol_com compile
/
alter trigger dbamv.trg_i_itsol_com compile
/
alter trigger dbamv.trg_u_itsol_com compile
/
alter trigger dbamv.trg_d_itsol_com compile
/
alter trigger dbamv.trg_u_ent_pro compile
/
alter trigger dbamv.trg_u_itent_pro compile
/
alter trigger dbamv.trg_i_itent_pro compile
/
alter trigger dbamv.trg_d_itent_pro compile
/
alter trigger dbamv.trg_u_itord_pro compile
/
alter trigger dbamv.trg_i_itord_pro compile
/
alter trigger dbamv.trg_d_itord_pro compile
/
alter trigger dbamv.trg_d_itord_pro compile
/
alter trigger dbamv.trg_u_ent_pro_conclusao compile
/
alter trigger dbamv.trg_ord_com_controla_ord compile
/





