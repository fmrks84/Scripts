CREATE OR REPLACE TRIGGER dbamv.trg_it_guia_ajusta_campos
 BEFORE INSERT OR UPDATE ON dbamv.it_guia
 REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
/*--------------------------------------------------------------------------------------------
 HISTÓRICO :
 PDA      DATA       AUTOR             DESCRIÇÃO
 -------  ---------- ----------------- -------------------------------------------------------
  380901  29/07/2010 Amalia Araújo     PROJETO RECIFE - Migração da tela M_GUIAS.
                                       Com a retirada da utilização de PKTs na tela de guias,
                                       a rotina PKG_FFCV_GUIA.FNC_AJUSTA_CAMPOS_ITGUIA foi
                                       transferida para esta trigger.
--------------------------------------------------------------------------------------------*/
  --
  cursor cGuia is
    select guia.tp_situacao,
           nvl( guia.nr_dias_solicitados, 0 ) nr_dias_solicitados,
           nvl( guia.nr_dias_autorizados, 0 ) nr_dias_autorizados
    	   , guia.tp_guia
         , guia.cd_senha
         , guia.dt_autorizacao
         , guia.sn_revisado
         , guia.CD_GUIA
      from dbamv.guia
     where guia.cd_guia = Nvl(:NEW.cd_guia,:OLD.cd_guia);
  --
  cursor cProFat( pvProFat in varchar ) is
    select pro_fat.tp_serv_hospitalar
      from dbamv.pro_fat
     where pro_fat.cd_pro_fat = pvProFat;
  --
  nQtSolic          dbamv.guia.nr_dias_solicitados%type;
  nQtAutDiar        dbamv.guia.nr_dias_autorizados%type;
  nQtAutDiarAcomp   dbamv.guia.nr_dias_autorizados%type;
  vTpSituacao       dbamv.guia.tp_situacao%type;
  vTpDiaria         dbamv.pro_fat.tp_serv_hospitalar%type;
  vTpGuia           dbamv.guia.tp_guia%type;
  vCdSenha          dbamv.guia.cd_senha%type:= null;
  vDtAutorizacao    dbamv.guia.dt_autorizacao%type:= null;
  vSnGuiaRevisa     VARCHAR2(1);
  --
  rGuia             cGuia%ROWTYPE;

begin
  --
  vTpSituacao    := dbamv.pkg_ffcv_guia.Le_GuiaPkg_TpSituacao();
  nQtSolic       := dbamv.pkg_ffcv_guia.Le_GuiaPkg_NrDiasSolic();
  nQtAutDiar     := dbamv.pkg_ffcv_guia.Le_GuiaPkg_NrDiasAutor();
  vTpGuia        := dbamv.pkg_ffcv_guia.Le_GuiaPkg_TpGuia();
  vCdSenha       := dbamv.pkg_ffcv_guia.Le_GuiaPkg_CdSenha();
  vDtAutorizacao := dbamv.pkg_ffcv_guia.Le_GuiaPkg_DtAutorizacao();
  --
  nQtAutDiarAcomp := nQtAutDiar;
  --
  /* dentro do loop, a variável nQtAutDiar será usada para ir calculando item a item a
     quantidade que estiver informada na guia.nr_dias_autorizados e acertando a quantidade
     autorizada de cada item */
  --
  /* se a guia está Negada, quantidade autorizada no item será zero */
  if vTpSituacao = 'N' then
    :NEW.qt_autorizada_convenio := 0;
  end if;
  --
  /* Se a quantidade autorizada estiver informada, e a situação da guia mudar para S, limpar a qtd autorizada. */
  if dbamv.pkg_mv2000.le_cliente <> 429 THEN
    if vTpSituacao = 'S' and :NEW.qt_autorizada_convenio is not null
       and vCdSenha is null and vDtAutorizacao is null and vTpGuia <> 'O' THEN
      :NEW.qt_autorizada_convenio := null;
    end if;
  END IF;
  --
  /* se a guia está autorizada... */
  if vTpSituacao = 'A' and vTpGuia <> 'O' and :NEW.tp_pre_pos_cirurgico <> 'POS'	then
    --
    vTpDiaria := null;
    open cProFat( :NEW.cd_pro_fat );
    fetch cProFat into vTpDiaria;
    close cProFat;
    --
    /* se quant.autorizada está nula ou é uma diária e o guia.nr_dias_autorizados na guia
        não é nulo... */
    if :NEW.qt_autorizada_convenio is null then
      --
      /* se o procedimento está preenchido mas não for uma diária, qt.autoriz = qt.solic */
      if :NEW.cd_pro_fat is not null and nvl( vTpDiaria, 'XX' ) not in ( 'DA', 'DI', 'DU' ) then
        :NEW.qt_autorizada_convenio := :NEW.qt_autorizado;
      end if;
      --
      /* se o procedimento for uma diária <> de acompanhante */
      if :NEW.cd_pro_fat is not null and nvl( vTpDiaria, 'XX' ) in ( 'DI', 'DU' ) then
        --
        if :NEW.qt_autorizado >= nQtSolic then
          :NEW.qt_autorizada_convenio := nQtAutDiar;
          nQtAutDiar := 0;
        else
          if nQtAutDiar < :NEW.qt_autorizado then
            :NEW.qt_autorizada_convenio := nQtAutDiar;
            nQtAutDiar := 0;
          end if;
          if nQtAutDiar > :NEW.qt_autorizada_convenio then
            if nQtAutDiar > nQtSolic then
              :NEW.qt_autorizada_convenio := nQtAutDiar - nQtSolic;
              nQtAutDiar := nQtSolic;
            end if;
            :NEW.qt_autorizada_convenio := :NEW.qt_autorizada_convenio
                                         + :NEW.qt_autorizado;
            nQtAutDiar := nQtAutDiar - :NEW.qt_autorizada_convenio;
            if nQtAutDiar < 0 then
              nQtAutDiar := 0;
            end if;
          end if;
        end if;
        --
      end if;
      --
      /* Se CD_PRO_FAT is not null e CD_PRO_FAT é diária e é de Acompanhante (='DA'),
          então repetir os mesmos passos do tópico de ¿não acompanhante¿, onde apenas
          será substituída a variável nQtAutDiar por nQtAutDiarAcomp.       */
      if :NEW.cd_pro_fat is not null and nvl( vTpDiaria, 'XX' ) = 'DA' then
        --
        if :NEW.qt_autorizado >= nQtSolic then
          :NEW.qt_autorizada_convenio := nQtAutDiarAcomp;
          nQtAutDiarAcomp := 0;
        else
          if nQtAutDiarAcomp < :NEW.qt_autorizado then
            :NEW.qt_autorizada_convenio := nQtAutDiarAcomp;
            nQtAutDiarAcomp := 0;
          end if;
          if nQtAutDiarAcomp > :NEW.qt_autorizada_convenio then
            if nQtAutDiarAcomp > nQtSolic then
              :NEW.qt_autorizada_convenio := nQtAutDiarAcomp - nQtSolic;
              nQtAutDiarAcomp := nQtSolic;
            end if;
            :NEW.qt_autorizada_convenio := :NEW.qt_autorizada_convenio
                                         + :NEW.qt_autorizado;
            nQtAutDiarAcomp := nQtAutDiarAcomp - :NEW.qt_autorizada_convenio;
            if nQtAutDiarAcomp < 0 then
              nQtAutDiarAcomp := 0;
            end if;
          end if;
        end if;
        --
      end if;
      --
    end if;
  end if;

  IF INSERTING THEN
    :NEW.TP_SITUACAO := 'P';
  END IF;

  -- FATURCONV-3103 - O ajuste na situao da guia precisa ficar nesta trigger, pois a guia no  criada apenas nas telas de guia.
  -- dbamv.prc_grava_log_erro('TRG_IT_GUIA',:new.cd_guia,NULL,'pro_fat:'||:new.cd_pro_fat||'  vTpSituacao:'||vTpSituacao||'  qt.sol:'||Nvl(:new.qt_autorizado,0)||'  qt_aut:'||Nvl(:new.qt_autorizada_convenio,0),1);
  if vTpSituacao = 'C' then
    if Nvl(:new.qt_autorizada_convenio,0) = 0 then
      :new.tp_situacao := 'C';
	  end if;
  elsif vTpSituacao = 'A' then
    :new.tp_situacao := 'A';
  elsif Nvl(:new.qt_autorizado,0) = 0 then
    :new.tp_situacao := 'P';
  elsif Nvl(Nvl(:new.qt_autorizado,:old.qt_autorizado),0) > 0 AND :new.qt_autorizada_convenio IS NULL then
    if vTpSituacao = 'P' then
	  :new.tp_situacao := 'P';
	else
	  :new.tp_situacao := 'S';
	end if;
  elsif Nvl(Nvl(:new.qt_autorizada_convenio,:old.qt_autorizada_convenio),0) >= Nvl(Nvl(:new.qt_autorizado,:old.qt_autorizado),0) then
    :new.tp_situacao := 'A';
  elsif Nvl(:new.qt_autorizada_convenio,:old.qt_autorizada_convenio) = 0 AND :new.tp_situacao <> 'P' then
    :new.tp_situacao := 'N';
  end if;
  -- Se a guia for cancelada e os itens tiverem a quantidade autorizada informada, os ficaro como Autorizado.
  if vTpSituacao = 'C' and Nvl(Nvl(:new.qt_autorizada_convenio,:old.qt_autorizada_convenio),0) > 0 then
    :new.tp_situacao := 'N';
  end if;
  -- FATURCONV-3103 - fim

  /* Transferir item para conta particular se o mesmo for negado.  */
  declare
    --
    cursor cLancamentos( pvTpConvOrigem in varchar2 ) is
      select itreg_fat.cd_reg_fat cd_conta,
              reg_fat.cd_atendimento,
              itreg_fat.cd_lancamento,
              'H' tp_conta
        from dbamv.reg_fat,
              dbamv.itreg_fat,
              dbamv.convenio
        where itreg_fat.cd_guia      = Nvl(:NEW.cd_guia,:OLD.cd_guia)
          and itreg_fat.cd_pro_fat   = :NEW.cd_pro_fat
          and itreg_fat.cd_reg_fat   = reg_fat.cd_reg_fat
          and convenio.cd_convenio   = reg_fat.cd_convenio
          and convenio.tp_convenio   = pvTpConvOrigem
          and nvl( reg_fat.sn_fechada, 'N' ) = 'N'
      union all
      select itreg_amb.cd_reg_amb cd_conta,
              itreg_amb.cd_atendimento,
              itreg_amb.cd_lancamento,
              'A' tp_conta
        from dbamv.itreg_amb,
              dbamv.reg_amb,
              dbamv.convenio
        where itreg_amb.cd_guia        = Nvl(:NEW.cd_guia,:OLD.cd_guia)
          and itreg_amb.cd_pro_fat     = :NEW.cd_pro_fat
          and itreg_amb.cd_reg_amb     = reg_amb.cd_reg_amb
          and convenio.cd_convenio     = reg_amb.cd_convenio
          and convenio.tp_convenio     = pvTpConvOrigem
          and nvl( itreg_amb.sn_fechada, 'N' ) = 'N';
    --
    vTpConvOrigem      varchar2(01);
    --
  begin
    --
   if :new.qt_autorizada_convenio is not null and Nvl(:NEW.qt_autorizada_convenio,99) <> Nvl(:old.qt_autorizada_convenio,99) THEN -- OP 11962
    if :NEW.qt_autorizada_convenio = 0 then
      vTpConvOrigem := 'C';
    else
      vTpConvOrigem := 'P';
    end if;
    --
    for vcLancamentos in cLancamentos( vTpConvOrigem ) loop
      --
      dbamv.pkg_ffcv_it_conta.prc_transfere_itens_conta( vcLancamentos.cd_conta,
                                                          vcLancamentos.cd_atendimento,
                                                          vcLancamentos.cd_lancamento,
                                                          null,
                                                          null,
                                                          vcLancamentos.tp_conta,
                                                          vTpConvOrigem     );
      --
    end loop;
   END IF;
    --
  end;
  --

  -- OP-50467
  IF :NEW.CD_PRO_FAT IS NOT NULL THEN
    DECLARE
      CURSOR C_GUIA_AC IS
        SELECT G.CD_CONVENIO
             , G.CD_TIP_ACOM
             , G.TP_GUIA
          FROM DBAMV.GUIA G
         WHERE CD_GUIA = NVL(:NEW.CD_GUIA,:OLD.CD_GUIA);
      R_GUIA_AC C_GUIA_AC%ROWTYPE;
    BEGIN
      OPEN C_GUIA_AC;
        FETCH C_GUIA_AC INTO R_GUIA_AC;
      CLOSE C_GUIA_AC;
      :NEW.SN_ALTO_CUSTO:= DBAMV.FNC_FFCV_PROCEDIMENTO_AC(R_GUIA_AC.CD_CONVENIO,NULL,R_GUIA_AC.CD_TIP_ACOM,:NEW.CD_PRO_FAT,R_GUIA_AC.TP_GUIA,SYSDATE,DBAMV.PKG_MV2000.LE_EMPRESA);
    END;
  END IF;

   -- FATURCONV-3294
   OPEN cGuia;
   FETCH cGuia INTO rGuia;
   CLOSE cGuia;

  IF vTpGuia = 'O' AND NVL(PKG_MV2000.LE_CONFIGURACAO('FFCV', 'SN_ALT_STATUS_GUIA_OPME'), 'S') = 'N' THEN
    IF DBAMV.PKG_FFCV_M_GUIAS.F_STATUS_GUIA_OPME(rGuia.CD_GUIA,'O',rGuia.SN_REVISADO) NOT IN ('R','RE') AND Nvl(:NEW.QT_AUTORIZADA_CONVENIO,:OLD.QT_AUTORIZADA_CONVENIO) > 0 THEN
      RAISE_APPLICATION_ERROR ( -20038, PKG_RMI_TRADUCAO.EXTRAIR_PROC_MSG('MSG_1', 'TRG_IT_GUIA_AJUSTA_CAMPOS', 'Os itens de uma guia de OPME não podem ser autorizadas sem o Fluxo de OPME estar Revisado!'));
    END IF;
  END IF;

END;
/

