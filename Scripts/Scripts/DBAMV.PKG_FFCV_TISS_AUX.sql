-- Start of DDL Script for Package DBAMV.PKG_FFCV_TISS_AUX_RENAN
-- Generated 28/08/2009 18:59:36 from DBAMV@v48jf

CREATE OR REPLACE 
PACKAGE dbamv.pkg_ffcv_tiss_aux IS

/*-----------------------------------------------------------------------------------------------------
Package contendo procedures e functions necessarias ao TISS
05/10/2007

Nesta package foi refeita a FNC_RETORNA_NR_GUIA_HOSPITAL para o novo processo de deletar todos os
registros da TISS_NR_GUIA do atendimento+conta passados como parâmetros. A criação desta nova PKG
tem como objetivo não alterar a assinatura da PKG_FFCV_TISS por causa do impacto nas compilações
e no processo de transição de um processo para o outro.
Nesta package estão sendo implementadas as funções abaixo, utilizadas no novo processo:
   - fnc_apaga_guias        : Limpa numeração de guias utilizada e limpa a TISS_NR_GUIA de
                              determinada conta.
   - fnc_retorna_contratado : Retorna o código do contratado solicitante.

------------------------------------------------------------------------------------------------------*/

/* pda 226051 - 24/04/2008 - Amalia Araújo
   Identificar o convênio e a empresa da conta passada na função.   */
cursor cConta( pnConta in number, pvTpConta in varchar2 ) is
  select reg_fat.cd_convenio,
         reg_fat.cd_multi_empresa
    from dbamv.reg_fat
   where reg_fat.cd_reg_fat = pnConta
     and pvTpConta          = 'H'
  union all
  select reg_amb.cd_convenio,
         reg_amb.cd_multi_empresa
    from dbamv.reg_amb
   where reg_amb.cd_reg_amb = pnConta
     and pvTpconta          = 'A';
--
/* Identificar se o convênio da conta vai reutilizar ou não a numeração das guias.  */
cursor cReutilizaNrGuia( pnConvenio in number, pnEmpresa in number ) is
  select 'X'
    from dbamv.configuracao
   where cd_sistema = 'FFCV'
     and chave      = 'CD_CONV_NAO_REUTILIZA_GUIA_TISS'
     and cd_multi_empresa = pnEmpresa
     and instr( valor, lpad(to_char(pnConvenio),4,'0') ) > 0;
/* pda 226051 - fim   */
--
/* pda 201664 - 15/10/2007 - Amalia Araújo
   Variáveis que serão utilizadas entre as funções desta package.                                     */
vgGuiaPrincipalHI           varchar2(4000);         -- pda 221585 - 22/03/2008
vgGuiaPrincipalSP           varchar2(4000);         -- pda 221585 - 22/03/2008
vReutilizaNrGuia			varchar2(01) := null;	-- pda 226051 - 24/04/2008
--
/* pda 225224 - 28/04/2008 - Amalia Araújo - Controle das faixas não utilizadas. */
type rLotFaixa   is record ( cd_faixa_guia       number,
                             cd_item_faixa_guia  number
                            );
type tTableFaixa is table of rLotFaixa index by binary_integer;
aRegFaixa        tTableFaixa;
nIndexFaixa      binary_integer := 0;
/* pda 225224 - fim */
--
--
/* pda 201664 - 25/09/2007 - Amalia Araújo - função para limpar as guias pre-criadas.                 */
function fnc_apaga_guias( pnAtendimento in number,
                          pnConta       in number,
                          pnConvenio    in number,
					      pvTpConta     in varchar2   ) return varchar2;
--
/* pda 201664 - 25/09/2007 - Amalia Araújo - função para retornar o código do contratado solicitante. */
function fnc_retorna_contratado( pnAtend    in number,
                                 pnConvenio in number,
                                 pvProFat   in varchar2,
                                 pnCdSetor  in number,
                                 pnCdGruPro in number,
                                 pvtpGruPro in varchar2       ) return varchar2;
--
/* pda 201664 - 25/09/2007 - Amalia Araújo e Fabiana Cunha
   Função que cria os registros na TISS_NR_GUIA utilizada para geração do XML e impressão das guias TISS.
   Reformulação da function, com nova assinatura.                                                     */
function fnc_retorna_nr_guia_hospital( pnAtendimento in number,
                                       pnConta       in number,
					     		       pvTpConta     in varchar2,
								       pvMsgErro     out varchar2 ) return varchar2;
--
/* pda 201664 - 15/10/2007 - Amalia Araújo
   Função que identifica o tipo de guia a ser gerado (mais específicamente para o hospital 719).      */
function fnc_identifica_tipo_guia( pnAtendimento in number,
                                   pnConta       in number,
                                   pnEmpresa     in varchar2,
                                   pvTpGruPro    in varchar2 ) return varchar2;
--
function fnc_retorna_guia_conta( pnCdGuia in number
                               , pnCdAtendimento in number ) return number;
-- pda 211289
function fnc_retorna_versao_tiss( pnCdConvenio in number ) return varchar2;
--
function fnc_retorna_proc_natureza( pnCdConvenio in number, pnProFat in varchar2 ) return varchar2; -- pda 248374 -- PDA.: 258657 - 02/12/2008 - Emanoel Deivison
--
END PKG_FFCV_TISS_AUX;
/

-- Grants for Package
GRANT EXECUTE ON dbamv.pkg_ffcv_tiss_aux TO mv2000
/

CREATE OR REPLACE 
PACKAGE BODY       dbamv.pkg_ffcv_tiss_aux IS

/* pda 201664 - 25/09/2007 - Amalia Araújo - função para limpar as guias pre-criadas.   */
function fnc_apaga_guias( pnAtendimento in number,
                          pnConta       in number,
                          pnConvenio    in number,
					      pvTpConta     in varchar2   ) return varchar2 is
  --
  /* pda 297329 - 10/07/2009 - Francisco Morais
     Nas contas ambulatoriais, quando o cliente mudava o lote, os dados antigos estavam na tiss_nr_guia
     e com isso ficava o legado, correcao feita no cursor cGuias da funcao fnc_apaga_guias foi removido o
     numero da conta so deixando o numero do atendimento, foi tambem inserido um le_cliente para diferenciar
     do Cliente 719 (Sta Joana).*/
  -- pda 206435 - 07/11/2007 - Amalia Araújo - Mesma correção no cursor hospitalar (pda 206220).
  -- pda 206220 - 06/11/2007 - Amalia Araújo
  -- Correção no select ambulatorial para apagar a guia principal, inclusive.
  --
  -- Cursor para identificar as guias TISS da conta e atendimento
  cursor cGuias is
    select distinct tiss_nr_guia.cd_atendimento,
           tiss_nr_guia.cd_reg_fat  cd_conta,
	       tiss_nr_guia.nr_guia,
		   tiss_nr_guia.tp_guia,
		   tiss_nr_guia.cd_multi_empresa,                                         --  24/10/2007
		   reg_fat.nr_guia_envio_principal
      from dbamv.tiss_nr_guia, dbamv.reg_fat
     -- pda 222774 - 27/03/2008 - Amalia Araújo - usando OR ao invés de NVL para idenficar as contas filhas.
     -- pda 217868 - 21/01/2008 - Amalia Araújo - para considerar as filhas do hosp 719
     where tiss_nr_guia.cd_reg_fat in ( select r.cd_reg_fat from dbamv.reg_fat r
                                         where ( r.cd_conta_pai = pnConta or r.cd_reg_fat = pnConta ) )
     -- tiss_nr_guia.cd_reg_fat     = pnConta
     -- pda 217868 - fim
     -- pda 222774 - fim
       -- and tiss_nr_guia.cd_atendimento = pnAtendimento               --pda 211523 - por orientação de Sandro Marin
       -- and reg_fat.cd_atendimento      = tiss_nr_guia.cd_atendimento --pda 211523 - por orientação de Sandro Marin
       and reg_fat.cd_reg_fat          = tiss_nr_guia.cd_reg_fat                    -- pda 206435
       -- and tiss_nr_guia.nr_guia       <> nvl(reg_fat.nr_guia_envio_principal,'X') -- pda 206435
       and pvTpConta                   = 'H'
    union all
    -- pda 225105 - 16/04/2008 - Amalia Araújo
    -- Quando o lote for diferente na tiss_nr_guia, deve buscar pelo atendimento e pelo convênio.
    select distinct * from (
      select distinct tiss_nr_guia.cd_atendimento,
             tiss_nr_guia.cd_reg_amb   cd_conta,
	         tiss_nr_guia.nr_guia,
	   	     tiss_nr_guia.tp_guia,
	 	     tiss_nr_guia.cd_multi_empresa,
		     atendime.nr_guia_envio_principal
        from dbamv.tiss_nr_guia, dbamv.atendime
       where tiss_nr_guia.cd_atendimento = pnAtendimento
         and dbamv.pkg_mv2000.le_cliente <> 719
         and atendime.cd_atendimento     = tiss_nr_guia.cd_atendimento
         and pvTpConta                   = 'A'
      union all
      select distinct tiss_nr_guia.cd_atendimento,
             tiss_nr_guia.cd_reg_amb   cd_conta,
	         tiss_nr_guia.nr_guia,
		     tiss_nr_guia.tp_guia,
		     tiss_nr_guia.cd_multi_empresa,
  		     atendime.nr_guia_envio_principal
         from dbamv.tiss_nr_guia, dbamv.atendime
       where tiss_nr_guia.cd_atendimento = pnAtendimento
         and tiss_nr_guia.cd_reg_amb in ( select distinct it.cd_reg_amb from dbamv.itreg_amb it
                                           where it.cd_atendimento = tiss_nr_guia.cd_atendimento
                                             and it.cd_convenio    = pnConvenio )
         and atendime.cd_atendimento     = tiss_nr_guia.cd_atendimento
         and dbamv.pkg_mv2000.le_cliente = 719
         and pvTpConta                   = 'A'
      )
      -- pda 225105 - fim
    ;
  -- pda 206220 - fim
  -- pda 206435 - fim
  --
  -- Cursor para identificar se a guia está vazia (cd_pro_fat='0') para guardar o número e não liberar a faixa - 16/10/2007
  cursor cGuiaZerada( pnAtend in number, pvNrGuia in varchar2, pvTpGuia in varchar2 ) is
    select tiss_nr_guia.cd_pro_fat
      from dbamv.tiss_nr_guia
     where tiss_nr_guia.cd_atendimento = pnAtend
       and tiss_nr_guia.nr_guia        = pvNrGuia
       and tiss_nr_guia.tp_guia        = pvTpGuia
       and nvl(tiss_nr_guia.cd_pro_fat,'0') = '0';                        -- 22/10/2007 - 24/10 nvl
  --
  -- Cursor para pegar o tamanho fixo da Faixa de Guia por Convênio.
  cursor cIdentificaFaixa( pnEmpresa  in number,
                           pvNrGuia   in varchar2,
                           pvTpGuia   in varchar2 ) is
    select faixa.cd_faixa_guia,
           item.cd_item_faixa_guia
      from dbamv.faixa_guia_convenio faixa,
           dbamv.item_faixa_guia_convenio item
     where faixa.cd_multi_empresa = pnEmpresa
       and faixa.cd_convenio      = pnConvenio
       and item.cd_faixa_guia     = faixa.cd_faixa_guia
       and item.nr_guia           = pvNrGuia
       and (   ( pvTpGuia in ('I','SI')  and nvl( faixa.tp_guia, 'T' ) in ('I','U','T') )
            or ( pvTpGuia in ('C','SS')  and nvl( faixa.tp_guia, 'T' ) in ('S','E','U','T') )
            or ( pvTpGuia in ('CO')      and nvl( faixa.tp_guia, 'T' ) in ('C','G','T') )
            or ( pvTpGuia in ('SP')      and nvl( faixa.tp_guia, 'T' ) in ('E','G','T') )
            or ( pvTpGuia in ('RI','HI') and nvl( faixa.tp_guia, 'T' ) in ('G','T') ) );
  --
  vIdentificaFaixa              cIdentificaFaixa%rowtype;
  vCdProFat                     dbamv.tiss_nr_guia.cd_pro_fat%type;                 -- 16/10/2007
  bLimpaFaixa                   boolean;                                            -- 16/10/2007
  --
begin
  --
  -- Liberando a numeração das guias na faixa de guias
  for v in cGuias loop
    --
    -- Se a coluna cd_pro_fat estiver com zero, não liberar a faixa de guias (apenas SP e HI hospitalar) - 16/10/2007
    bLimpaFaixa := true;
    --
    -- pda 226051 - 24/04/2008 - Amalia Araújo
	-- Incluida a condição da vReutilizaNrGuia porque neste caso não reaproveita esta numeração das guias em branco.
    if pvTpConta = 'H' and v.tp_guia in ( 'SP', 'HI' ) and vReutilizaNrGuia is null then
    -- pda 226051 - fim
      --
      vCdProFat := null;
      open  cGuiaZerada( v.cd_atendimento, v.nr_guia, v.tp_guia );
      fetch cGuiaZerada into vCdProFat;
      if cGuiaZerada%found and nvl(vCdProFat,'0') = '0' then                        -- 24/10/2007 (cGuiaZerada%found)
        bLimpaFaixa := false;
        if v.tp_guia = 'HI' then
          vgGuiaPrincipalHI := vgGuiaPrincipalHI || v.nr_guia||'#';                 /* PDA 284020 */
        else
          vgGuiaPrincipalSP := vgGuiaPrincipalSP || v.nr_guia||'#';                 /* PDA 284020 */
        end if;
      end if;
      close cGuiaZerada;
      --
    end if;
    --
    -- pda 206435 - 08/11/2007 - Amalia Araújo - Não limpar faixa da guia principal
    if v.nr_guia = v.nr_guia_envio_principal then
      bLimpaFaixa := false;
    end if;
    -- pda 206435 - fim
    --
    -- pda 226051 - 24/04/2008 - Amalia Araújo - Não limpar a faixa se não for para reutilizar as guias.
    if vReutilizaNrGuia is not null then
      --
      bLimpaFaixa := false;
      --
      -- Na conta ambulatorial, precisa renumerar a guia principal do Sta Joana
      if pvTpConta = 'A' and dbamv.pkg_mv2000.le_cliente = 719 then
        update dbamv.atendime set nr_guia_envio_principal = null
         where cd_atendimento = pnAtendimento;
      end if;
      --
    end if;
    -- pda 226051 - fim
    --
    if bLimpaFaixa then                                                             -- 16/10/2007 - fim
      --
      open  cIdentificaFaixa( nvl(v.cd_multi_empresa,dbamv.pkg_mv2000.le_empresa), v.nr_guia, v.tp_guia );  -- 24/10/2007 - nvl empresa
      fetch cIdentificaFaixa Into vIdentificaFaixa;
      if cIdentificaFaixa%found then
        --
        update dbamv.item_faixa_guia_convenio set nr_guia = null, cd_guia = null, dt_lancamento = null
         where cd_faixa_guia      = vIdentificaFaixa.cd_faixa_guia
  	       and cd_item_faixa_guia = vIdentificaFaixa.cd_item_faixa_guia;
        --
        -- pda 225224 - 28/04/2008 - Amalia Araújo - Guardando faixas limpas.
	    dbamv.pkg_ffcv_tiss_aux.nIndexFaixa   := dbamv.pkg_ffcv_tiss_aux.nIndexFaixa + 1;
	    dbamv.pkg_ffcv_tiss_aux.aRegFaixa(dbamv.pkg_ffcv_tiss_aux.nIndexFaixa).cd_faixa_guia      := vIdentificaFaixa.cd_faixa_guia;
	    dbamv.pkg_ffcv_tiss_aux.aRegFaixa(dbamv.pkg_ffcv_tiss_aux.nIndexFaixa).cd_item_faixa_guia := vIdentificaFaixa.cd_item_faixa_guia;
        -- pda 225224 - fim
        --
      end if;
      close cIdentificaFaixa;
      --
    end if;
    --
    -- Limpando numeração da guia do TISS nos itens da conta
    if pvTpConta = 'H' then
      update dbamv.itreg_fat set nr_guia_envio = null where cd_reg_fat = v.cd_conta;
      update dbamv.itlan_med set nr_guia_envio = null where cd_reg_fat = v.cd_conta;
    else
      update dbamv.itreg_amb set nr_guia_envio = null
       where cd_atendimento = pnAtendimento and cd_reg_amb = v.cd_conta;
    end if;
    --
    -- Deletando a TISS_NR_GUIA
    if pvTpConta = 'H' then
      if nvl( dbamv.pkg_mv2000.le_cliente, 0 ) <> 719 then
        delete from dbamv.tiss_nr_guia
         where cd_atendimento = pnAtendimento and cd_reg_fat = v.cd_conta;
      else
        -- pda 226051 - 24/04/2008 - Amalia Araújo
		-- Caso esteja configurado para não aproveitar a numeração, deleta todas as guias.
		if vReutilizaNrGuia is not null then
          delete from dbamv.tiss_nr_guia
           where cd_atendimento = pnAtendimento and cd_reg_fat = v.cd_conta;
        else
        -- pda 226051 - fim
          --
          /* 22/10/2007 - para o Santa Joana, não vai apagar as guias impressas em branco no momento do atendimento
                          pela função FNC_FFCV_GERA_TISS_719, só no caso de conta hospitalar.                    */
          delete from dbamv.tiss_nr_guia
           where cd_atendimento = pnAtendimento and cd_reg_fat = v.cd_conta
             and nr_guia not in ( select t.nr_guia from dbamv.tiss_nr_guia t
                                   where t.cd_atendimento = pnAtendimento
                                     and t.cd_reg_fat = v.cd_conta
                                     and t.tp_guia in ('SP','HI')
                                     and nvl(cd_pro_fat,'0') = '0' );
          delete from dbamv.tiss_nr_guia
           where cd_atendimento = pnAtendimento
             and cd_reg_fat     = pnConta                   -- pda 221585 - 19/03/2008 - Amalia Araújo
             and tp_guia = 'RI';
        end if;
	  end if;
    else
      delete from dbamv.tiss_nr_guia
       where cd_atendimento = pnAtendimento and cd_reg_amb = v.cd_conta;

      -->> 209301
      delete from dbamv.tiss_nr_guia
       where cd_atendimento = pnAtendimento and cd_reg_amb = '0' and tp_guia = 'CO';

    end if;
    --
  end loop;
  --
  commit;
  return null;
  --
end;  -- fim da fnc_apaga_guias
--
--
/* pda 201664 - 25/09/2007 - Amalia Araújo - função para retornar o código do contratado solicitante.   */
function fnc_retorna_contratado( pnAtend    in number,
                                 pnConvenio in number,
                                 pvProFat   in varchar2,
                                 pnCdSetor  in number,
                                 pnCdGruPro in number,
                                 pvtpGruPro in varchar2       ) return varchar2 is
  --
  -- Identifica dados do atendimento
  cursor cAtendimento is
    select atendime.tp_atendimento,
           atendime.cd_ori_ate,
           atendime.cd_servico
      from dbamv.atendime
     where atendime.cd_atendimento = pnAtend;
  --
  -- Identifica o Centro de Custo do setor
  cursor cSetor is
    select setor.cd_cen_cus
      from dbamv.setor
     where setor.cd_setor = pnCdSetor;
  --
  -- Identifica código do contratado solicitante - fica
  cursor cContratado( pvTpAtend in varchar2, pnOrigem in number, pnServico in number,
                      pvCenCus  in varchar2, pnSetor  in number, pvTpGrupo in varchar2,
                      pnCdGrupo in number,   pvProced in varchar2, pnConvenio in number ) is
    select cod.cd_convenio_conf_tiss_contr,
           cod.cd_codigo_contratado,
           decode( cod.cd_pro_fat, null,
             decode( cod.cd_gru_pro, null,
                decode( cod.tp_gru_pro, null,
                   decode( cod.cd_setor  , null,
                      decode( cod.cd_cen_cus, null,
                         decode( cod.cd_servico, null,
                            decode( cd_ori_ate    , null,
                               decode( cod.tp_atendimento, 'T', 8, 9 )
                                       , 7 ), 6 ), 5 ), 4 ), 3 ), 2 ), 1 ) ord_ref
      from dbamv.convenio_conf_tiss_contratado cod
     where cod.cd_convenio = pnConvenio
       and ( cod.tp_atendimento = pvTpAtend or cod.tp_atendimento = 'T' )
       and ( cod.cd_ori_ate     = pnOrigem  or cod.cd_ori_ate is null )
       and ( cod.cd_servico     = pnServico or cod.cd_servico is null )
       and ( cod.cd_cen_cus     = pvCenCus  or cod.cd_cen_cus is null )
       and ( cod.cd_setor       = pnSetor   or cod.cd_setor   is null )
       and ( cod.tp_gru_pro     = pvTpGrupo or cod.tp_gru_pro is null )
       and ( cod.cd_gru_pro     = pnCdGrupo or cod.cd_gru_pro is null )
       and ( cod.cd_pro_fat     = pvProced  or cod.cd_pro_fat is null )
/* pda 213787 - 17/01/2008 - Amalia Araújo
       Select específico para dar preferência a uma configuração de determinado
       tipo de atendimento sem outro tipo de restrição.             */
    union all
    select cod.cd_convenio_conf_tiss_contr,
           cod.cd_codigo_contratado,
           0 ord_ref
      from dbamv.convenio_conf_tiss_contratado cod
     where cod.cd_convenio = pnConvenio
       and cod.tp_atendimento = pvTpAtend
       and ( cod.cd_ori_ate     is null )
       and ( cod.cd_servico     is null )
       and ( cod.cd_cen_cus     is null )
       and ( cod.cd_setor       is null )
       and ( cod.tp_gru_pro     is null )
       and ( cod.cd_gru_pro     is null )
       and ( cod.cd_pro_fat     is null )
       and not exists( select c.cd_codigo_contratado
                         from dbamv.convenio_conf_tiss_contratado c
                        where c.tp_atendimento = pvTpAtend
                          and ( c.cd_ori_ate     is not null
                            or  c.cd_servico     is not null
                            or  c.cd_cen_cus     is not null
                            or  c.cd_setor       is not null
                            or  c.tp_gru_pro     is not null
                            or  c.cd_gru_pro     is not null
                            or  c.cd_pro_fat     is not null  )
                      )
    /* pda 213787 - fim */
     order by 3;
  --
  vcContratado                      cContratado%rowtype;
  vcAtendimento                     cAtendimento%rowtype;
  --
  vCentroCusto                      dbamv.setor.cd_cen_cus%type;
  --
begin
  --
  open  cAtendimento;
  fetch cAtendimento into vcAtendimento;
  close cAtendimento;
  --
  open  cSetor;
  fetch cSetor into vCentroCusto;
  close cSetor;
  --
  open cContratado( vcAtendimento.tp_atendimento
                  , vcAtendimento.cd_ori_ate
                  , vcAtendimento.cd_servico
                  , vCentroCusto
                  , pnCdSetor
                  , pvTpGruPro
                  , pnCdGruPro
                  , pvProFat
                  , pnConvenio );
  fetch cContratado into vcContratado;
  close cContratado;
  --
  return vcContratado.cd_codigo_contratado;
  --
end;
--
--
/* pda 201664 - 16/10/2007 - Amalia Araújo
   Função que identifica o tipo de guia a ser gerado (mais específicamente para o hospital 719).        */
function fnc_identifica_tipo_guia( pnAtendimento in number,
                                   pnConta       in number,
                                   pnEmpresa     in varchar2,
                                   pvTpGruPro    in varchar2 ) return varchar2 is
  --
  cursor cHospital is
    select hospital.cd_hospital
      from dbamv.hospital
     where hospital.cd_multi_empresa = pnEmpresa;
  --
  -- pda 221368 - 13/03/2008 - Amalia Araújo - Incluido parâmetro e filtro pelo convênio.
  cursor cItensConta( pnConv in number ) is
    select 'X'
      from dbamv.itreg_fat,
           dbamv.reg_fat
     where itreg_fat.cd_multi_empresa <> pnEmpresa
       and itreg_fat.cd_reg_fat        = reg_fat.cd_reg_fat
       and reg_fat.cd_convenio         = pnConv
       and reg_fat.cd_atendimento      = pnAtendimento
       -- pda 236172 - 25/06/2008 - Amalia Araújo - Colocando OR
       and ( reg_fat.cd_reg_fat in (select rf2.cd_reg_fat
                                      from dbamv.reg_fat rf2
                                     where rf2.cd_atendimento = pnAtendimento
                                       and nvl(rf2.cd_conta_pai,rf2.cd_reg_fat) = pnConta)
          or reg_fat.cd_reg_fat = (select rf3.cd_conta_pai from dbamv.reg_fat rf3 where rf3.cd_reg_fat = pnConta) );
       -- pda 236172 - fim
  -- pda 221368 - fim
  --
  -- pda 236172 - 25/06/2008 - Amalia Araújo
  -- Incluindo as colunas de convênio do atendimento e de acoplamento.
  cursor cConvenio is
    select reg_fat.cd_convenio,
           atendime.cd_convenio cd_convenio_atendime,
           atendime.cd_convenio_secundario
      from dbamv.reg_fat,
           dbamv.atendime
     where reg_fat.cd_reg_fat = pnConta
       and atendime.cd_atendimento = pnAtendimento;
  -- pda 236172 - fim
  --
  -- pda 225227 - 28/04/2008 - Amalia Araújo
  -- Identificando se há Exame na empresa Sana, porque tem tratamento diferenciado.
  -- Isto ocorre no cliente 719 no convênio AGF, procedimento 24010049.
  cursor cEmpresa5( pnConv in number ) is
    select itreg_fat.cd_pro_fat
      from dbamv.itreg_fat,
           dbamv.pro_fat,
           dbamv.gru_pro,
           dbamv.reg_fat
     where reg_fat.cd_atendimento      = pnAtendimento
       and reg_fat.cd_convenio         = pnConv
       and reg_fat.cd_multi_empresa    = 5 -- (Sana)
       and reg_fat.cd_convenio         = 6 -- (AGF)
       and reg_fat.cd_reg_fat in (select r2.cd_reg_fat
                                    from dbamv.reg_fat r2
                                    where nvl(r2.cd_conta_pai,r2.cd_reg_fat) = pnConta) -- XIS_MARIN
       and itreg_fat.cd_reg_fat        = reg_fat.cd_reg_fat
       and pro_fat.cd_pro_fat          = itreg_fat.cd_pro_fat
       and gru_pro.cd_gru_pro          = pro_fat.cd_gru_pro
       and gru_pro.tp_gru_pro         in ('SD','SP')
       -- pda 225227 - 02/05/2008 - acerto
       AND NOT EXISTS( select i.cd_reg_fat from dbamv.reg_fat r, dbamv.itreg_fat i
                        where i.cd_reg_fat = r.cd_reg_fat
                          and r.cd_reg_fat in (select r2.cd_reg_fat
                                    from dbamv.reg_fat r2
                                    where nvl(r2.cd_conta_pai,r2.cd_reg_fat) = pnConta) -- XIS_MARIN
                          and r.cd_atendimento = pnAtendimento
                          and r.cd_multi_empresa in ( 1, 2 ) );
  -- pda 225227 - fim
  --
  -- pda 257650 - 04/11/2008 - Amalia Araújo
  -- Cursor para identificar se a conta é de complemento de SP, para retornar HI na tp_guia_aux
  -- Conta de complemento no Sta Joana só tem registro na empresa-filha, um SP que ficou de fora da primeira conta.
  -- Neste caso não é gerada guia de RI para a conta-mãe.
  cursor cContaComplemento( pnAtend in number, pnCta in number ) is
    select 'X'
      from dbamv.reg_fat
     where reg_fat.cd_reg_fat in ( select r.cd_conta_pai from dbamv.reg_fat r where r.cd_reg_fat = pnCta )
       and reg_fat.cd_atendimento = pnAtend
       and not exists( select i.cd_reg_fat from dbamv.itreg_fat i
                        where i.cd_reg_fat = reg_fat.cd_reg_fat )
       and not exists( select it.cd_reg_fat
                         from dbamv.itreg_fat it, dbamv.reg_fat re, dbamv.pro_fat pr, dbamv.gru_pro gr
                        where re.cd_conta_pai = reg_fat.cd_reg_fat
                          and it.cd_reg_fat   = re.cd_reg_fat
                          and pr.cd_pro_fat   = it.cd_pro_fat
                          and gr.cd_gru_pro   = pr.cd_gru_pro and gr.tp_gru_pro not in ('SP','SD') ) -- PDA 279241
       and     exists( select it.cd_reg_fat
                         from dbamv.itreg_fat it, dbamv.reg_fat re, dbamv.pro_fat pr, dbamv.gru_pro gr
                        where re.cd_conta_pai = reg_fat.cd_reg_fat
                          and it.cd_reg_fat   = re.cd_reg_fat
                          and pr.cd_pro_fat   = it.cd_pro_fat
                          and gr.cd_gru_pro   = pr.cd_gru_pro and gr.tp_gru_pro in ('SP','SD') );  -- PDA 279241
  -- pda 257650 - fim
  --
  nConvenio                     dbamv.convenio.cd_convenio%type := null;
  nConvenioAtend                dbamv.convenio.cd_convenio%type := null;  -- pda 236172
  nConvenioAcopl                dbamv.convenio.cd_convenio%type := null;  -- pda 236172
  vHospital                     dbamv.hospital.cd_hospital%type;
  vTemItens                     varchar2(01) := null;
  vRetorno                      varchar2(02) := null;
  vProFatExame                  dbamv.pro_fat.cd_pro_fat%type;            -- pda 225227
  vComplemento                  varchar2(01);                             -- pda 257650
  --
begin
  --
  if pvTpGruPro is null then
    return null;
  end if;
  --
  open  cHospital;
  fetch cHospital into vHospital;
  close cHospital;
  --
  -- Como a função é específica para o Santa Joana, já retorna daqui se o hospital for diferente de 719.
  if to_number(vHospital) <> 719 then
    return null;
  end if;
  --
  if to_number(vHospital) = 719 then
    --
    -- pda 217868 - 20/02/2008 - Amalia Araújo
    -- A verificação do convênio 38 estava no final da função, trouxe para o início junto com
    -- o retorno da guia de Resumo de Internação.
    --
    open  cConvenio;
    fetch cConvenio into nConvenio,
                         nConvenioAtend,  -- pda 236172
                         nConvenioAcopl;  -- pda 236172
    if cConvenio%notfound then
      close cConvenio;
      return null;
    end if;
    close cConvenio;
    --
    -- Se a empresa for 1 (Santa Joana) ou 2 (ProMatre) e os procedimentos forem SD ou SP, a guia é de Resumo.
    -- Exceto no convênio 38.
    if pnEmpresa in (1,2) and pvTpGruPro in ( 'SD', 'SP' ) then
      --
      vRetorno := 'RI';
      --
      -- Independente da empresa, se o convênio for 38 : Se o procedimento for SP, então a guia é de Honorário.
      --                                                 Senão, então a guia é de Resumo.
      if nConvenio = 38 and pvTpGruPro = 'SP' then
        vRetorno := 'HI';
      end if;
      --
      return vRetorno;
      --
    end if;
    -- pda 217868 - fim
    --
    -- pda 225227 - 28/04/2008 - Amalia Araújo - Identificando se há exame em conta da Vanguarda.
    vProFatExame := null;
    open  cEmpresa5( nConvenio );
    fetch cEmpresa5 into vProFatExame;
    close cEmpresa5;
    -- pda 225227 - fim
    --
    -- Se a empresa for 4 (Vanguarda) e não houver nenhum item de outra empresa no atendimento, a guia é de Resumo.
    -- (caso de contas de recém-nascido)
    if pnEmpresa = 4 then
      --
      -- pda 221368 - 13/03/2008 - Amalia Araújo - Incluido parâmetro do convênio.
      open  cItensConta( nConvenio );
      fetch cItensConta into vTemItens;
      close cItensConta;
      -- pda 221368 - fim
      --
      -- pda 225227 - 28/04/2008 - Amalia Araújo - Condição específica do convênio AGF.
      if vTemItens is not null and vProFatExame is not null then
        return 'RI';
      end if;
      -- pda 225227 - fim
      --
      -- pda 236172 - 25/06/2008 - Amalia Araújo
      -- Se a conta for de convênio de acoplamento e cair nesta condição, é porque não
      -- há itens para a conta-mãe, então não entra neste IF para não retornar como guia
      -- de Resumo de Internação. Irá continuar e retornar como guia de SP ou de HI, sem
      -- gerar guia de RI. Incluida a condição da variável nConvenioAcopl.
      if vTemItens is null and
	    ( nConvenioAcopl is null or nConvenioAcopl = nConvenioAtend ) then
        --
        -- pda 257650 - 04/11/2008 - Amalia Araújo - Se for conta de complemento de SP, retornar HI;
        --                           caso contrário retorna RI como estava antes.
        vComplemento := null;
        open  cContaComplemento( pnAtendimento, pnConta );
        fetch cContaComplemento into vComplemento;
        close cContaComplemento;
        if vComplemento = 'X' then
           -- -- PDA 279241   return 'HI';
          if pvTpGruPro = 'SP' then			-- PDA 279241
            return 'HI';					-- PDA 279241
          else								-- PDA 279241
            return 'SP';					-- PDA 279241
          end if;							-- PDA 279241
        else
          return 'RI';
        end if;
        -- pda 257650 - fim
        --
      end if;
      -- pda 236172 - fim
      --
    end if;
    --
    -- Se a empresa for 4 (Vanguarda) ou 5 (Sana) : Se o tipo de procedimento for SD então a guia é de SP/SADT.
    --                                              Se o procedimento for SP então a guia é de Honorário.
    if pnEmpresa in (4,5) then
      if pvTpGruPro = 'SD' then
        --
        -- pda 225227 - 28/04/2008 - Amalia Araújo - Condição específica do convênio AGF.
        if pnEmpresa = 5 and vProFatExame is not null then
          vRetorno := 'HI';
        else
        -- pda 225227 - fim
          --
          vRetorno := 'SP';
        end if;
      elsif pvTpGruPro = 'SP' then
        vRetorno := 'HI';
      end if;
    end if;
    --
  end if;
  --
  return vRetorno;
  --
end;
--
--
/* pda 201664 - 25/09/2007 - Amalia Araújo e Fabiana Cunha
   Função que cria os registros na TISS_NR_GUIA utilizada para geração do XML e impressão das guias TISS.
   Reformulação da function, com nova assinatura.                                                       */
function fnc_retorna_nr_guia_hospital( pnAtendimento in number,
                                       pnConta       in number,
					     		       pvTpConta     in varchar2,
								       pvMsgErro     out varchar2                  ) return varchar2 is
  --
  -- pda 206077 - 09/11/2007 - Amalia Araújo - Incluindo TP_CONVENIO
  cursor cConvenio (cpnCdAtendimento in number, cpnCdRegFat in number, cpvTpConta in varchar2) is
    select reg_fat.cd_convenio,
           convenio_conf_tiss.tp_quebra_guia_res_int,
           reg_fat.cd_multi_empresa,
           convenio.tp_convenio,
           convenio_conf_tiss.tp_totaliza_res_int -- PDA 198883
      from dbamv.reg_fat,
           dbamv.convenio_conf_tiss,
           dbamv.convenio
     where reg_fat.cd_atendimento  = cpnCdAtendimento
       and reg_fat.cd_reg_fat      = cpnCdRegFat
       and reg_fat.cd_convenio     = convenio_conf_tiss.cd_convenio
       and convenio.cd_convenio    = reg_fat.cd_convenio
       and 'H'                     = cpvTpConta
     union all
    select distinct itreg_amb.cd_convenio,
           convenio_conf_tiss.tp_quebra_guia_res_int,
           reg_amb.cd_multi_empresa,
           convenio.tp_convenio,
           convenio_conf_tiss.tp_totaliza_res_int -- PDA 198883
      from dbamv.itreg_amb,
           dbamv.reg_amb,
           dbamv.convenio_conf_tiss,
           dbamv.convenio
     where itreg_amb.cd_atendimento = cpnCdAtendimento
       and itreg_amb.cd_reg_amb     = cpnCdRegFat
       and reg_amb.cd_reg_amb       = itreg_amb.cd_reg_amb
       and itreg_amb.cd_convenio = convenio_conf_tiss.cd_convenio
       and convenio.cd_convenio  = reg_amb.cd_convenio
       and 'A'                      = cpvTpConta;
  -- pda 206077 - fim
  --
  cursor cConvenioConsulta (cpnCdAtendimento in number) is
    select atendime.cd_convenio
      from dbamv.atendime
     where atendime.cd_atendimento = cpnCdAtendimento;
  --
  -- Cursor de Contas Hospitalares (Internação e Home-Care)
  --------------------------------------------------------------------------------------------------------------------
  -- A ideia da coluna Ordem_Guia, é tentar deixar todos os itens de forma ordenada pronta para ser inserido os dados
  -- na Tiss_Nr_Guia, só faltando o agrupamento antes da inserção e algumas checagens.
  -- A composição da coluna Ordem_Guia é composta de 4 partes:
  -- - Campo 1: Tipo de pagamento / Campo 2: Tipo de Grupo / Campo 3: Tipo de Guia
  -- - Campo 4: Configuracao de Tipo de geracao da Guia
  -- **ATENÇÃO** : Muito cuidado com a ordenação deste cursor, pois a geração correta da TISS_NR_GUIA depende disto.
  --------------------------------------------------------------------------------------------------------------------
  -- pda 207164 - 16/11/2007 - Amalia Araújo - Correção na gerar procedimentos que tem guia especifica, mas o nr da
  -- guia de procedimento é igual ao da guia de internação, não gerar SP e sim na guia de RI normal.
  -- Pda 207749 - 20/11/2007 - Desfazer a alteração do pda acima 207164
  /*
  pda 236232 - 14/07/2008 - Amalia Araújo
  Alteração neste cursor para considerar a informação de HORÁRIO ESPECIAL de acordo com configuração criada.
  - Será necessário gravar o valor da coluna SN_HORARIO_ESPECIAL = 'S' em todos os lançamentos de horário
    especial (HE), caso a configuração CONVENIO_CONF_TISS.TP_INF_HORARIO_ESPECIAL for = 'H' (por Hora de Lançamento)
	ou 'P' (por Percentual de Acréscimo e Hora de Lançamento).
  - A alteração para inclusão da coluna SN_HORARIO_ESPECIAL inclui os selects que retornam os procedimentos
    agrupados em uma única data. Os lançamentos de HE serão separados, nos restantes esta coluna ficará nula
	sem afetar o agrupamento. A partir da 4.8.J temos anteriormente a implementação do pda 221861 que será alterada
	para trabalhar junto com esta nova configuração.
  */
  /* pda 286732 - 08/06/09 - Francisco Morais - Inserido o cliente 436 para que o mesmo possa imprimir guia de Sp/Sadt para
                                                credenciados em Internações.*/
  /*
  /*
     pda 289145 - 29/05/09 - Francisco Morais - Foi trocado o campo guia.nr_guia pelo o decode(SN_GUIA_ESPECIF,'S',guia.nr_guia,null)
                                                para verificar se tem guia especifica no select especfico para os procedimentos de
                                                OPME e SH.
  /*
     pda 286719 - 15/05/09 - Francisco Morais - Inserido um decode no tipo de pagamento, onde se for Credenciado o codigo sera
                                                'C', senao sera 'P', com isso a tiss_nr_guia nao era gerada errada e nao tem
                                                divergencia.*/
  /*
     pda 283464 - 28/04/09 - Francisco Morais - Inserido um decode no tipo de pagamento, onde se for Credenciado o codigo sera
                                                nulo, com isso o relatorio no campo 30 retornara o codigo do credenciamento do
                                                prestador Credenciado, pois sem essa condicao o sistema respeitava o codigo que
                                                estava sendo informado do credenciamento do convenio e nao o codigo do credenciamento
                                                do prestador no convenio.
  */
  /* pda 282809 - 28/04/09 - Francisco Morais - Inserido o cliente 283 para que o mesmo possa imprimir guia de Sp/Sadt para
                                                credenciados em Internações. Foi inserido tambem uma condicao para se for o
                                                cliente 283 e o tipo do grupo do procedimento for SP sera 3.*/
  /*
     pda 283360 - 24/04/09 - Francisco Morais - Inserido no cursor cItensGravaHosp da pkg_ffcv_tiss_aux a ordenacao pelo
                                                vl_percentual_multipla para guia HI (2), pois a ordem da equipe medica
                                                nao estava correta, com isso era gerada uma linha a mais na tiss_nr_guia.*/

  /* pda 276628 - 11/03/09 - Francisco Morais - Correcao feita por conta da atividade medica padrao (Ativ. Medica Clinico),
                                                substituido dos cursores (cItensGravaHosp e cItensGravaAmb) a atividade medica
                                                '07' pelo dbamv.pkt_config_ffcv.retorna_campo(dbamv.pkg_mv2000.le_empresa,
                                                'CD_ATI_MED_CLINICO' )*/
  /*
     pda 279096 - 26/03/09 - Francisco Morais - Inserido no cursor cItensGravaHosp da pkg_ffcv_tiss_aux a ordenacao pelo
                                                vl_percentual_multipla, pois a equipe medica nao estava correta, ela estava
                                                sendo agrupada incorretamente.*/
  /*
     pda 279764 - 31/03/09 - Francisco Morais - Inserido no cursor cItensGravaHosp no ponto da query de uma unica data 'U'
                                                foi modificado o modo de pegar a atividade medica, pois o mesmo estava gerando
                                                mais de uma linda na tiss_nr_guia por conta da atividade diferente e com isso
                                                as quantidades eram duplicadas e o valor dos procedimentos tambem, com isso a
                                                divergencia acontecia.*/
  --
  /* PDA 284714 - 01/07/2009 - Renan Salvador - adicionando SELECT no cursor que irá verificar os procedimentos com natureza em contas hospitalares
          tal select possuirá o cd_Select = 7 e o select q possuia o cd_Select = 7 será 8 agora , foi adicionado a coluna sn_natureza em todos os selects*/
  cursor cItensGravaHosp is
    -- pda 207164 - inicio
    Select
          --Pda 207749 - Ams - DESFAZENDO O PDA 207164
          distinct decode(tp_guia_aux,'RI',1,'HI',2,'SP',3,Ordem_Guia) ordem_guia
          --distinct decode(tp_guia_aux,'RI',1,'HI',2,'SP',decode(tp_gru_pro,'SD',3,1),decode(tp_gru_pro,'SP',1,'SH',1,ordem_guia)) ordem_guia              -- 16/10/2007 - decode
          ,Decode( Nvl(tp_pagamento,'P'), 'C',NULL, cd_codigo_contratado) cd_codigo_contratado
          --Inicio pda 209197
          --,Decode( tp_gru_pro, 'SD', Cd_Guia_Conta, NULL ) cd_guia_conta
          ,decode(SN_GUIA_ESPECIF,'S',cd_guia_conta,null) cd_guia_conta
          ,decode(SN_GUIA_ESPECIF,'S',nr_guia,null) nr_guia
          --Fim pda 209197
          -- 260978 Renan Salvador  (ínicio)
		  -- agrupando o procedimento , caso exista agrupamento
		  ,decode(tp_gru_pro,'OP',decode(ordem_guia,1,decode(nvl( dbamv.pkg_ffcv_meio_mag.fnc_ffcv_agrupa_proc( 'P@'||cd_convenio, cd_apr,cd_pro_fat, null ), cd_pro_fat ),
                                         cd_pro_fat,cd_pro_fat,
						                                       dbamv.pkg_ffcv_meio_mag.fnc_ffcv_agrupa_proc('P@'||cd_convenio, cd_apr,cd_pro_fat,null ) ),cd_pro_fat),cd_pro_fat) cd_pro_fat
           -- verificando o tipo do agrupamento do procedimento
          ,decode(ordem_guia,1,decode(nvl( dbamv.pkg_ffcv_meio_mag.fnc_ffcv_agrupa_proc( 'P@'||cd_convenio, cd_apr,cd_pro_fat, null ), cd_pro_fat ),
                                   cd_pro_fat,null,
						                                 dbamv.pkg_ffcv_meio_mag.fnc_ffcv_agrupa_proc('T@'||cd_convenio, cd_apr,cd_pro_fat,null ) ),null) tp_agrup_opme
          --260978 (íFim)
		  --Pda Inicio 207749 - Ams - DESFAZENDO O PDA 207164
          /*
          ,decode(decode(tp_guia_aux,'RI',1,'HI',2,'SP',decode(tp_gru_pro,'SD',3,1),decode(tp_gru_pro,'SP',1,'SH',1,ordem_guia)),3,to_date(null),dt_lancamento) Dt_Lancamento
          ,decode(decode(tp_guia_aux,'RI',1,'HI',2,'SP',decode(tp_gru_pro,'SD',3,1),decode(tp_gru_pro,'SP',1,'SH',1,ordem_guia)),1,null,
                  to_number(substr(lpad(cd_prestador_solicitante,10,'0'),1,9))) cd_prestador_solicitante
          ,decode(decode(tp_guia_aux,'RI',1,'HI',2,'SP',decode(tp_gru_pro,'SD',3,1),decode(tp_gru_pro,'SP',1,'SH',1,ordem_guia)),1,null,
                  substr(cd_prestador_solicitante,-1,1)) tp_prestador_solicitante
--          ,decode(tp_gru_pro,'SD',0,cd_prestador_executante) cd_prestador_executante -- pda 206976
          ,decode(Tp_Geracao_Guia_Sadt,'S',cd_prestador_executante,decode(tp_gru_pro,'SD',0,cd_prestador_executante)) cd_prestador_executante -- pda 207590
          ,decode(decode(tp_guia_aux,'RI',1,'HI',2,'SP',decode(tp_gru_pro,'SD',3,1),decode(tp_gru_pro,'SP',1,'SH',1,ordem_guia))||dbamv.pkg_mv2000.le_cliente||cd_pro_fat,
                  '371900030031', '10', cd_ati_med ) cd_ati_med
          -- pda 207164 - fim
          */
          --Pda Fim 207749 - Ams - DESFAZENDO O PDA 207164

           -- pda 236232 - 18/07/2008 - Amalia Araújo
		   -- Correção. A data de lançamento precisa preencher nos registros de horário especial.
          -- ,decode(decode(tp_guia_aux,'RI',1,'HI',2,'SP',3,Ordem_Guia),3,to_date(null),dt_lancamento) Dt_Lancamento
          , -- PDA 284066 - colocando diretamente o dt_lancamento
          /*decode( sn_horario_especial, 'S', dt_lancamento,
       		  decode(decode(tp_guia_aux,'RI',1,'HI',2,'SP',3,Ordem_Guia),3,to_date(null),dt_lancamento)
			   )*/ dt_lancamento
           -- pda 236232 - fim
           --

          ,decode(decode(tp_guia_aux,'RI',1,'HI',2,'SP',3,Ordem_Guia),1,null,
                  to_number(substr(lpad(cd_prestador_solicitante,10,'0'),1,9))) cd_prestador_solicitante
          ,decode(decode(tp_guia_aux,'RI',1,'HI',2,'SP',3,Ordem_Guia),1,null,
                  substr(cd_prestador_solicitante,-1,1)) tp_prestador_solicitante

          -- pda 217868 - 12/03/2008 - Amalia Araújo - Hosp 719 não zera prestador executante
          ,decode( tp_pagamento,'C',cd_prestador_executante,
             decode(ordem_guia,'3',cd_prestador_executante,
                Decode(dbamv.pkg_Mv2000.Le_Cliente,970,cd_prestador_executante,719,cd_prestador_executante,
                   decode(tp_gru_pro,'SD',0,cd_prestador_executante)
                      )
                    )
                  ) cd_prestador_executante

			,cd_prestador_executante cd_pres_ext -- PDA 251806
          -- pda 217868 - fim

          ,decode(decode(tp_guia_aux,'RI',1,'HI',3,'SP',3,Ordem_Guia)||dbamv.pkg_mv2000.le_cliente||cd_pro_fat,
                  '371900030031', '10', cd_ati_med ) cd_ati_med

          ,tp_serv_hospitalar
          ,Tp_Geracao_Guia_Sadt
          ,Tp_Gru_Pro
          ,tp_ordem
          --,Qt_Lancamento
          --,Vl_Total_Conta
          ,Cd_Gru_Pro
          ,Cd_Convenio
          ,cd_reg_fat
          ,cd_lancamento
          ,tp_pagamento
          ,cd_itlan_med
          ,nr_guia_envio_principal
          ,cd_multi_empresa
          ,tp_atendimento
          ,tp_guia_aux
          ,ordem_tp_proced
          ,vl_percentual_multipla       -- pda 211144
          ,SN_GUIA_ESPECIF 				-- pda 211289 - 14/01/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          ,SN_somente_xml 				-- pda 214757 - 07/03/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          ,sn_horario_especial 			-- pda 221861
          ,tp_inf_horario_especial    	-- pda 236232
          ,cd_select					-- pda 236232
          ,cd_apr                       -- PDA 260978
		  ,sn_natureza                  /*PDA  284174*/
    From(

select prestador.cd_prestador cd_prestador_executante,
           itreg_fat.cd_pro_fat,
           pro_fat.tp_serv_hospitalar ,
           conf.Tp_Geracao_Guia_Sadt ,
	       dbamv.pkg_ffcv_tiss.fnc_ffcv_ret_ati_med_hosp( reg_fat.cd_reg_fat,
	             nvl( nvl(itlan_med.cd_ati_med,nvl(itreg_fat.cd_ati_med,dbamv.pkt_config_ffcv.retorna_campo(dbamv.pkg_mv2000.le_empresa, 'CD_ATI_MED_CLINICO' ))), dbamv.pkt_config_ffcv.retorna_campo(dbamv.pkg_mv2000.le_empresa, 'CD_ATI_MED_CLINICO' ) ) ) cd_ati_med,
           Decode( conf.tp_totaliza_res_int||'-'||itreg_fat.sn_horario_especial||'-'||nvl(itlan_med.cd_ati_med,'0'),
                  'L-N-0',trunc(itreg_fat.dt_lancamento),
                  'U-N-0',trunc(reg_fat.dt_inicio),
                        decode(conf.tp_inf_horario_Especial||'-'||conf.tp_totaliza_res_int||'-'||nvl(itlan_med.cd_ati_med,'0'),
                        'S-U-0',trunc(reg_fat.dt_inicio),
                        'S-L-0',trunc(itreg_fat.dt_lancamento),
                        to_date(to_char(itreg_fat.dt_lancamento,'DD/MM/YYYY')||' '||to_char(itreg_fat.hr_lancamento,'HH24:MI'),'DD/MM/YYYY HH24:MI'))) dt_lancamento,
           gru_pro.tp_gru_pro,
           guia.tp_guia tp_guia,
           decode(dbamv.pkg_mv2000.le_cliente||'-'||tp_gru_pro||'-'||CONF.SN_GUIA_ESPECIF,'719-SH-N',null,'719-SD-N',null,guia.nr_guia) nr_guia,
           atendime.tp_atendimento,
           decode(nvl(itlan_med.tp_pagamento,itreg_fat.tp_pagamento),'C','C','P')||tp_gru_pro||decode(guia.nr_guia,null,' ',guia.tp_guia)||tp_geracao_guia_sadt tp_ordem,
           DECODE ( conf.SN_GUIA_ESPECIF,'N',  DECODE( nvl(itlan_med.tp_pagamento,itreg_fat.tp_pagamento),'C',decode(dbamv.pkg_mv2000.le_cliente,703,decode(length(prestador.NR_CPF_CGC),14,3,2), 2),1), -- pda 211289 - 14/01/2008 - Thiago Miranda de oliveira
           decode(dbamv.pkg_mv2000.le_cliente||'-'||tp_gru_pro,'719-SP',decode(nvl(itlan_med.tp_pagamento,itreg_fat.tp_pagamento),'C','C','P')||tp_gru_pro,
		   decode(decode(nvl(itlan_med.tp_pagamento,itreg_fat.tp_pagamento),'C','C','P')||tp_gru_pro||decode(guia.nr_guia,null,' ',tp_guia)||tp_geracao_guia_sadt,
           'CSP H',decode(dbamv.pkg_mv2000.le_cliente, '283', decode( length(prestador.NR_CPF_CGC),14,3, 2),2),'CSD H',decode(dbamv.pkg_mv2000.le_cliente||'-'||length(prestador.NR_CPF_CGC),'703-14',3,'292-14',3,'257-14',3,'283-14',3,'436-14',3,'1103-14',3,2),'COP H',2,-- pda 223638 -- pda 249071
           'CSP S',decode(dbamv.pkg_mv2000.le_cliente, '283', decode( length(prestador.NR_CPF_CGC),14,3, 2),2),'CSD S',decode(dbamv.pkg_mv2000.le_cliente||'-'||length(prestador.NR_CPF_CGC),'703-14',3,'292-14',3,'257-14',3,'283-14',3,'436-14',3,'1103-14',3,2),'COP S',2,-- pda 223638 -- pda 249071

           'CSPIH',decode(dbamv.pkg_mv2000.le_cliente, '283', decode( length(prestador.NR_CPF_CGC),14,3, 2),2),'CSDIH',decode(dbamv.pkg_mv2000.le_cliente||'-'||length(prestador.NR_CPF_CGC),'703-14',3,'292-14',3,'257-14',3,'283-14',3,'436-14',3,'1103-14',3,2),'COPIH',2,-- pda 223638 -- pda 249071
           'CSPIS',decode(dbamv.pkg_mv2000.le_cliente, '283', decode( length(prestador.NR_CPF_CGC),14,3, 2),2),'CSDIS',decode(dbamv.pkg_mv2000.le_cliente||'-'||length(prestador.NR_CPF_CGC),'703-14',3,'292-14',3,'257-14',3,'283-14',3,'436-14',3,'1103-14',3,2),'COPIS',2,-- pda 223638 -- pda 249071

           'CSPPH',decode(dbamv.pkg_mv2000.le_cliente, '283', decode( length(prestador.NR_CPF_CGC),14,3, 2),2),'CSDPH',decode(dbamv.pkg_mv2000.le_cliente||'-'||length(prestador.NR_CPF_CGC),'703-14',3,'292-14',3,'257-14',3,'283-14',3,'436-14',3,'1103-14',3,2),'COPPH',2,-- pda 223638 -- pda 249071
           'CSPPS',decode(dbamv.pkg_mv2000.le_cliente, '283', decode( length(prestador.NR_CPF_CGC),14,3, 2),2),'CSDPS',decode(dbamv.pkg_mv2000.le_cliente||'-'||length(prestador.NR_CPF_CGC),'703-14',3,'292-14',3,'257-14',3,'283-14',3,'436-14',3,'1103-14',3,2),'COPPS',2,-- pda 223638 -- pda 249071
           'PSP H',1,'PSD H',1,'POP H',1,
           'PSP S',1,'PSD S',3,'POP S',1,

           'PSPIH',1,'PSDIH',1,'POPIH',1,
           'PSPIS',1,'PSDIS',1,'POPIS',1,

           'PSPPH',3,'PSDPH',3,'POPPH',3,
           'PSPPS',3,'PSDPS',3,'POPPS',3,
           'CSH H',2,'PSP',3,
           1))) Ordem_Guia,
           decode(dbamv.pkg_mv2000.le_cliente||'-'||tp_gru_pro||'-'||CONF.SN_GUIA_ESPECIF,'719-SH-N',null,'719-SD-N',null,decode( guia.nr_guia, null, null, itreg_fat.cd_guia ) ) cd_guia_conta ,
           gru_pro.cd_gru_pro,
           reg_fat.cd_convenio,
           reg_fat.cd_reg_fat,
           itreg_fat.cd_lancamento, --**
           decode( nvl(itlan_med.tp_pagamento,nvl(itreg_fat.tp_pagamento,'P')), 'C', 'C', 'P') tp_pagamento,
           decode(itlan_med.cd_Ati_med,null,'0',itlan_med.cd_ati_med)  cd_itlan_med, --##
           reg_fat.nr_guia_envio_principal,
           reg_fat.cd_multi_empresa,
           dbamv.pkg_ffcv_tiss_aux.fnc_retorna_contratado( atendime.cd_atendimento, reg_fat.cd_convenio,
		                                                   pro_fat.cd_pro_fat, itreg_fat.cd_setor_produziu,
														   gru_pro.cd_gru_pro, gru_pro.tp_gru_pro ) cd_codigo_contratado,

           dbamv.pkg_ffcv_tiss.prestador_solic_ambul( reg_fat.cd_atendimento, reg_fat.cd_reg_fat,itreg_fat.cd_pro_fat ||'@'|| itreg_fat.cd_mvto ) cd_prestador_solicitante, --pda 270489 - 29/01/09 - Francisco Morais
		
           dbamv.pkg_ffcv_tiss_aux.fnc_identifica_tipo_guia( atendime.cd_atendimento, reg_fat.cd_reg_fat,reg_fat.cd_multi_empresa, gru_pro.tp_gru_pro ) tp_guia_aux,
           '1' ordem_tp_proced
          ,itreg_fat.vl_percentual_multipla
          ,conf.SN_GUIA_ESPECIF 	
          ,conf.SN_somente_xml
          ,decode( conf.tp_inf_horario_especial, 'S', null,
		           decode( itreg_fat.sn_horario_especial, 'S', itreg_fat.sn_horario_especial, null )) sn_horario_especial
          ,conf.tp_inf_horario_especial
		  , '1' cd_select
          , apr.cd_Apr -- PDA 260978
		  ,'N' sn_natureza
		  --
      from dbamv.itreg_fat,
           dbamv.itlan_med,
           dbamv.reg_fat,
           dbamv.pro_fat,
           dbamv.gru_pro,
           dbamv.prestador,
		   dbamv.Convenio_Conf_Tiss conf,
           dbamv.atendime,
           dbamv.guia,
           (select apr.cd_apr_conta_meio_mag cd_apr
			  from dbamv.apr_conta_meio_mag apr
			 where apr.nm_funcao_banco = 'GERA_ARQMAG_TISS' ) apr
     where reg_fat.cd_atendimento        = pnAtendimento
       and nvl(reg_fat.cd_conta_pai,reg_fat.cd_reg_fat) = pnConta
       and itreg_fat.cd_reg_fat          = reg_fat.cd_reg_fat
       and reg_fat.cd_atendimento        = atendime.cd_atendimento
       and prestador.cd_prestador        = NVL(itlan_med.cd_prestador, itreg_fat.cd_prestador)
       and pro_fat.cd_pro_fat            = itreg_fat.cd_pro_fat
       and gru_pro.cd_gru_pro            = pro_fat.cd_gru_pro
       and reg_fat.cd_convenio           = Conf.cd_convenio
       and itlan_med.cd_reg_fat(+)       = itreg_fat.cd_reg_fat
       and itlan_med.cd_lancamento(+)    = itreg_fat.cd_lancamento
       and gru_pro.tp_gru_pro           in ('SP','SD','SH')
       and ( ( gru_pro.tp_gru_pro = 'SH' and (substr(nvl(pro_fat.tp_serv_hospitalar,'X'),1,1) not in ('T','D')
             Or (substr(nvl(pro_fat.tp_serv_hospitalar,'X'),1,1) in ('T','D') And nvl(itlan_med.tp_pagamento, nvl(itreg_fat.tp_pagamento,'P')) = 'C')) ) -->> 207364
             or gru_pro.tp_gru_pro <> 'SH' )
       and guia.cd_guia(+) = dbamv.pkg_ffcv_tiss_aux.fnc_retorna_guia_conta(itreg_fat.cd_guia, pnAtendimento) -- pda 208292
       --and Nvl(dbamv.pkg_mv2000.le_cliente,1) <> 719
	   and nvl( itreg_fat.sn_pertence_pacote, 'N' ) = 'N'
	   and ( nvl(itlan_med.tp_pagamento, nvl(itreg_fat.tp_pagamento,'P')) <> 'C' or
             ( nvl(itlan_med.tp_pagamento, nvl(itreg_fat.tp_pagamento,'P')) = 'C' and
               conf.sn_imprime_credenciado = 'S' ) )

    union all

        -- Select específico para os procedimentos de OPME e SH por causa do prestador que não existe nestes itens da conta.

    select distinct decode(decode(decode(nvl(itreg_fat.tp_pagamento,'P'),'C','C','P')||tp_gru_pro||decode(decode(conf.SN_GUIA_ESPECIF,'S',guia.nr_guia,null),null,' ',tp_guia)||tp_geracao_guia_sadt,
           'CSP H',2,'CSD H',2,'COP H',2,
           'CSP S',2,'CSD S',2,'COP S',2,

           'CSPIH',2,'CSDIH',2,'COPIH',2,
           'CSPIS',2,'CSDIS',2,'COPIS',2,

           'CSPPH',2,'CSDPH',2,'COPPH',2,
           'CSPPS',2,'CSDPS',2,'COPPS',2,

           'PSP H',1,'PSD H',1,'POP H',1,
           'PSP S',1,'PSD S',3,'POP S',1,

           'PSPIH',1,'PSDIH',1,'POPIH',1,
           'PSPIS',1,'PSDIS',1,'POPIS',1,

           'PSPPH',3,'PSDPH',3,'POPPH',3,
           'PSPPS',3,'PSDPS',3,'POPPS',3,
           'CSH H',2,                     -->> 207364
           1),1,to_number(null),nvl(itreg_fat.cd_prestador,atendime.cd_prestador)) cd_prestador_executante, -- pda 210550
           itreg_fat.cd_pro_fat,
           pro_fat.tp_serv_hospitalar,
           conf.Tp_Geracao_Guia_Sadt,
           --Ams Inicio pda 206619
           --nvl( itreg_fat.cd_ati_med, '07' ) cd_ati_med,
	       dbamv.pkg_ffcv_tiss.fnc_ffcv_ret_ati_med_hosp( reg_fat.cd_reg_fat,
	             nvl( nvl(itreg_fat.cd_ati_med,dbamv.pkt_config_ffcv.retorna_campo(dbamv.pkg_mv2000.le_empresa, 'CD_ATI_MED_CLINICO' )), dbamv.pkt_config_ffcv.retorna_campo(dbamv.pkg_mv2000.le_empresa, 'CD_ATI_MED_CLINICO' ) ) ) cd_ati_med,
           --Ams Fim pda 206619
           trunc(itreg_fat.dt_lancamento) dt_lancamento,
           gru_pro.tp_gru_pro,
           guia.tp_guia,
           guia.nr_guia,							-- pda 211434
           atendime.tp_atendimento,
           -- pda 211523 - so considerar a forma de pagamento 'C' ou 'P'
           decode(nvl(itreg_fat.tp_pagamento,'P'),'C','C','P')||tp_gru_pro||decode(guia.nr_guia,null,' ',tp_guia)||tp_geracao_guia_sadt tp_ordem,
           -- pda 211523 - so considerar a forma de pagamento 'C' ou 'P'
           DECODE ( conf.SN_GUIA_ESPECIF,'N',  DECODE( itreg_fat.tp_pagamento,'C',2,1), -- pda 211289 - 14/01/2008 - Thiago Miranda de oliveira
           decode(decode(nvl(itreg_fat.tp_pagamento,'P'),'C','C','P')||tp_gru_pro||decode(guia.nr_guia,null,' ',tp_guia)||tp_geracao_guia_sadt,
           'CSP H',2,'CSD H',2,'COP H',2,
           'CSP S',2,'CSD S',2,'COP S',2,

           'CSPIH',2,'CSDIH',2,'COPIH',2,
           'CSPIS',2,'CSDIS',2,'COPIS',2,

           'CSPPH',2,'CSDPH',2,'COPPH',2,
           'CSPPS',2,'CSDPS',2,'COPPS',2,

           'PSP H',1,'PSD H',1,'POP H',1,
           'PSP S',1,'PSD S',3,'POP S',1,

           'PSPIH',1,'PSDIH',1,'POPIH',1,
           'PSPIS',1,'PSDIS',1,'POPIS',1,

           'PSPPH',3,'PSDPH',3,'POPPH',3,
           'PSPPS',3,'PSDPS',3,'POPPS',3,
           'CSH H',2,                     -->> 207364
           1)) Ordem_Guia,
           --itreg_fat.qt_lancamento qt_lancamento,
           --itreg_fat.vl_total_conta vl_total_conta,
           --itreg_fat.cd_setor_produziu cd_setor,
           decode( guia.nr_guia, null, null, itreg_fat.cd_guia ) cd_guia_conta,
           gru_pro.cd_gru_pro,
           reg_fat.cd_convenio,
           reg_fat.cd_reg_fat,
           itreg_fat.cd_lancamento,
           decode(nvl(itreg_fat.tp_pagamento,'P'), 'C', 'C', 'P') tp_pagamento,
           to_char(null)  cd_itlan_med,								-- pda 211781
           reg_fat.nr_guia_envio_principal,
           reg_fat.cd_multi_empresa,
           dbamv.pkg_ffcv_tiss_aux.fnc_retorna_contratado( atendime.cd_atendimento, reg_fat.cd_convenio,
		                                                   pro_fat.cd_pro_fat, itreg_fat.cd_setor_produziu,
														   gru_pro.cd_gru_pro, gru_pro.tp_gru_pro ) cd_codigo_contratado,
           dbamv.pkg_ffcv_tiss.prestador_solic_ambul( reg_fat.cd_atendimento, reg_fat.cd_reg_fat,
                                                   --itreg_fat.cd_pro_fat ) cd_prestador_solicitante,                         --pda 270489 - 29/01/09 - Francisco Morais
                                                   itreg_fat.cd_pro_fat ||'@'|| itreg_fat.cd_mvto ) cd_prestador_solicitante, --pda 270489 - 29/01/09 - Francisco Morais
           dbamv.pkg_ffcv_tiss_aux.fnc_identifica_tipo_guia( atendime.cd_atendimento, reg_fat.cd_reg_fat,
                                                             reg_fat.cd_multi_empresa, gru_pro.tp_gru_pro ) tp_guia_aux,
           decode(gru_pro.tp_gru_pro,'OP','3','2') ordem_tp_proced --207590 colocando para sair o numero 3 qunado for opme
          ,itreg_fat.vl_percentual_multipla                     -- pda 211144
          ,conf.SN_GUIA_ESPECIF -- pda 211289 - 14/01/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          ,conf.SN_somente_xml -- pda 214757 - 07/03/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          --
          -- pda 236232 - 14/07/2008 - Substituindo coluna sn_horario_especial para utilizar a nova configuração
          --,decode(conf.nr_registro_operadora_ans, '323080', itreg_fat.sn_horario_especial, null) sn_horario_especial  -- pda 221861
          ,decode( conf.tp_inf_horario_especial, 'S', null,
		           decode( itreg_fat.sn_horario_especial, 'S', itreg_fat.sn_horario_especial, null )) sn_horario_especial
          ,conf.tp_inf_horario_especial
		  , '6' cd_select
          , apr.cd_apr -- PDA 260978
		  -- pda 236232 - fim
		  ,'N' sn_natureza
		  --
      from dbamv.itreg_fat,
           dbamv.reg_fat,
           dbamv.pro_fat,
           dbamv.gru_pro,
		       dbamv.Convenio_Conf_Tiss conf,
           dbamv.atendime,
           dbamv.guia,
           (select apr.cd_apr_conta_meio_mag cd_apr
			  from dbamv.apr_conta_meio_mag apr
			 where apr.nm_funcao_banco = 'GERA_ARQMAG_TISS' ) apr -- PDA 260978

     where reg_fat.cd_atendimento        = pnAtendimento
       and nvl(reg_fat.cd_conta_pai,reg_fat.cd_reg_fat) = pnConta  -- 24/10/2007 ( nvl cd_conta_pai)
       and itreg_fat.cd_reg_fat          = reg_fat.cd_reg_fat
       and reg_fat.cd_atendimento        = atendime.cd_atendimento
       and pro_fat.cd_pro_fat            = itreg_fat.cd_pro_fat
       and gru_pro.cd_gru_pro            = pro_fat.cd_gru_pro
       and reg_fat.cd_convenio           = Conf.cd_convenio
     /* pda 208318 - so considerar prestador para procedimentos do grupo OPME
        and gru_pro.tp_gru_pro = 'OP'                                         -- 19/10/2007
        and gru_pro.tp_gru_pro         in ('OP','SH')
       and itreg_fat.cd_prestador is null -- pda 206976 - Thiago Miranda de Oliveira*/
       and ( ( gru_pro.tp_gru_pro = 'SH' and itreg_fat.cd_prestador is null ) or ( gru_pro.tp_gru_pro = 'OP') )
       and ( ( gru_pro.tp_gru_pro = 'SH' and (substr(nvl(pro_fat.tp_serv_hospitalar,'X'),1,1) not in ('T','D')
             Or (substr(nvl(pro_fat.tp_serv_hospitalar,'X'),1,1) in ('T','D') And nvl(itreg_fat.tp_pagamento,'P') = 'C')) ) -->> 207364
             or gru_pro.tp_gru_pro <> 'SH' )
       and guia.cd_guia(+) = dbamv.pkg_ffcv_tiss_aux.fnc_retorna_guia_conta(itreg_fat.cd_guia, pnAtendimento) -- pda 208292
	   and nvl( itreg_fat.sn_pertence_pacote, 'N' ) = 'N'
       --and nvl(itreg_fat.sn_paciente_paga,'N') = 'N' pda 223418 10/04/2008 Renan Salvador (sob orientação de Sandro Marin)
	   and ( nvl(itreg_fat.tp_pagamento,'P') <> 'C' or
	       ( nvl(itreg_fat.tp_pagamento,'P') = 'C' and conf.sn_imprime_credenciado = 'S' ) )
    --
    union all
    /* PDA 284714  - Renan Salvador - select novo p/ verificar os procedimentos com natureza em conta hospitalar*/
	select to_number(null) 					    cd_prestador_executante,
           itr.cd_pro_fat 				    cd_pro_fat,
           to_char(null) 					tp_serv_hospitalar,
           to_char(null)					Tp_Geracao_Guia_Sadt,
           dbamv.pkt_config_ffcv.retorna_campo(dbamv.pkg_mv2000.le_empresa, 'CD_ATI_MED_CLINICO' ) 							cd_ati_med,
           trunc(reg_Fat.dt_inicio) 	    dt_lancamento,
           to_char(null) 					tp_gru_pro,
           to_char(null)					tp_guia,
           to_char(null)					nr_guia,
           atendime.tp_atendimento			tp_atendimento,
           to_char(null) 					tp_ordem,
           1 								Ordem_Guia,
           null   				    		cd_guia_conta,  -- aqui não aceitou to_char nem to_number.
           to_number(null) 					cd_gru_pro,
           reg_fat.cd_convenio				cd_convenio,
           reg_fat.cd_reg_fat,
           to_number(null) 					cd_lancamento,
           'P' 								tp_pagamento,
           to_char(null)  				    cd_itlan_med,
           reg_fat.nr_guia_envio_principal	nr_guia_envio_principal,
           reg_fat.cd_multi_empresa			cd_multi_empresa,
           dbamv.pkg_ffcv_tiss_aux.fnc_retorna_contratado( atendime.cd_atendimento, reg_fat.cd_convenio,
		                                                   null, null,
														   null, null ) cd_codigo_contratado,
           dbamv.pkg_ffcv_tiss.prestador_solic_ambul( reg_fat.cd_atendimento, reg_fat.cd_reg_fat,
			                                          null ) cd_prestador_solicitante,
           dbamv.pkg_ffcv_tiss_aux.fnc_identifica_tipo_guia( atendime.cd_atendimento, reg_fat.cd_reg_fat,
                                                             reg_fat.cd_multi_empresa, null ) tp_guia_aux,
           '1' 								ordem_tp_proced
          ,to_number(null) vl_percentual_multipla
          ,conf.SN_GUIA_ESPECIF
          ,conf.SN_somente_xml
          ,to_char(null) sn_horario_especial
          ,conf.tp_inf_horario_especial
		  , '7' cd_select
          , apr.cd_Apr
		  , 'S' sn_natureza
      from dbamv.reg_fat,
           dbamv.Convenio_Conf_Tiss conf,
           dbamv.atendime,
           dbamv.itreg_fat itr,
           (select apr.cd_apr_conta_meio_mag cd_apr
			  from dbamv.apr_conta_meio_mag apr
			 where apr.nm_funcao_banco = 'GERA_ARQMAG_TISS' ) apr -- PDA 260978

     where reg_fat.cd_atendimento        = pnAtendimento
       and reg_fat.cd_reg_fat            = pnConta
       and reg_fat.cd_atendimento        = atendime.cd_atendimento
       and reg_fat.cd_convenio           = Conf.cd_convenio
       and ( dbamv.pkg_mv2000.le_cliente <> 719 or
           ( dbamv.pkg_mv2000.le_cliente = 719 and reg_fat.cd_multi_empresa in (1,2) ) )
	   and itr.cd_reg_fat = reg_Fat.cd_reg_fat
	   and dbamv.pkg_ffcv_tiss_aux.fnc_retorna_proc_natureza(reg_fat.cd_convenio,itr.cd_pro_fat) = 'S'
	   and ( ( itr.cd_prestador is not null
				and nvl(itr.tp_pagamento,'P') = 'C'
				and itr.cd_pro_fat not in ( select cd_pro_fat
											 from dbamv.itreg_fat it,
											      dbamv.itlan_med itl
										   where it.cd_reg_fat = itr.cd_reg_Fat
											 and itl.cd_reg_fat (+) = it.cd_reg_Fat
											 and itl.cd_lancamento (+) = it.cd_lancamento
											 and nvl(itl.tp_pagamento,it.tp_pagamento) = 'P'
											 and it.cd_pro_fat = itr.cd_pro_fat))

			  or itr.cd_prestador is null and not exists ( select 'X' from dbamv.itlan_med itl
															where itl.cd_reg_fat = itr.cd_reg_Fat
															  and itr.cd_lancamento = itl.cd_lancamento ) )

	union all
	/* PDA 284714 - Renan Salvador , o select que irá gerar a guia vazia possuirá o cd_select 8 e foi adicionado uma condição and ( not exists ), p/ não retornar os procedimentos que entraram
	     na regra de négocios desta implementação */
    -- Select específico para quando não houver nenhum procedimento para a guia principal.
    select to_number(null) 					cd_prestador_executante,
           '0' 								cd_pro_fat,
           to_char(null) 					tp_serv_hospitalar,
           to_char(null)					Tp_Geracao_Guia_Sadt,
           dbamv.pkt_config_ffcv.retorna_campo(dbamv.pkg_mv2000.le_empresa, 'CD_ATI_MED_CLINICO' ) 							cd_ati_med,
           trunc(atendime.dt_atendimento) 	dt_lancamento,
           to_char(null) 					tp_gru_pro,
           to_char(null)					tp_guia,
           to_char(null)					nr_guia,							-- pda 211434
           atendime.tp_atendimento			tp_atendimento,
           to_char(null) 					tp_ordem,
           1 								Ordem_Guia,
           --to_number(null) 					qt_lancamento,
           --to_number(null) 					vl_total_conta,
           --to_number(null) 					cd_setor,
           null   				    		cd_guia_conta,  -- aqui não aceitou to_char nem to_number.
           to_number(null) 					cd_gru_pro,
           reg_fat.cd_convenio				cd_convenio,
           reg_fat.cd_reg_fat,
           to_number(null) 					cd_lancamento,
           'P' 								tp_pagamento,
           to_char(null)  				    cd_itlan_med,						-- pda 211781
           reg_fat.nr_guia_envio_principal	nr_guia_envio_principal,
           reg_fat.cd_multi_empresa			cd_multi_empresa,
           dbamv.pkg_ffcv_tiss_aux.fnc_retorna_contratado( atendime.cd_atendimento, reg_fat.cd_convenio,
		                                                   null, null,
														   null, null ) cd_codigo_contratado,
           dbamv.pkg_ffcv_tiss.prestador_solic_ambul( reg_fat.cd_atendimento, reg_fat.cd_reg_fat,
			                                          null ) cd_prestador_solicitante,
           dbamv.pkg_ffcv_tiss_aux.fnc_identifica_tipo_guia( atendime.cd_atendimento, reg_fat.cd_reg_fat,
                                                             reg_fat.cd_multi_empresa, null ) tp_guia_aux,
           '1' 								ordem_tp_proced
          ,to_number(null) vl_percentual_multipla                     -- pda 211144
          ,conf.SN_GUIA_ESPECIF -- pda 211289 - 14/01/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          ,conf.SN_somente_xml -- pda 214757 - 07/03/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          --
          -- pda 236232 - 14/07/2008 - Substituindo coluna sn_horario_especial para utilizar a nova configuração
          --, null sn_horario_especial -- pda 221861
          ,to_char(null) sn_horario_especial
          ,conf.tp_inf_horario_especial
		  , '8' cd_select
          , apr.cd_Apr
		  -- pda 236232 - fim
		  ,'N' sn_natureza
           --
      from dbamv.reg_fat,
           dbamv.Convenio_Conf_Tiss conf,
           dbamv.atendime,
           (select apr.cd_apr_conta_meio_mag cd_apr
			  from dbamv.apr_conta_meio_mag apr
			 where apr.nm_funcao_banco = 'GERA_ARQMAG_TISS' ) apr -- PDA 260978

     where reg_fat.cd_atendimento        = pnAtendimento
       and reg_fat.cd_reg_fat            = pnConta
       and reg_fat.cd_atendimento        = atendime.cd_atendimento
       and reg_fat.cd_convenio           = Conf.cd_convenio
       and ( dbamv.pkg_mv2000.le_cliente <> 719 or
           ( dbamv.pkg_mv2000.le_cliente = 719 and reg_fat.cd_multi_empresa in (1,2) ) )
       and not exists( select itreg_fat.cd_pro_fat
                         from dbamv.itreg_fat, dbamv.pro_fat, dbamv.gru_pro, dbamv.convenio_conf_tiss conf, dbamv.itlan_med
                        where itreg_fat.cd_reg_fat       = reg_fat.cd_reg_fat
                          and Nvl(itlan_med.tp_pagamento,nvl( itreg_fat.tp_pagamento, 'P' )) <> 'C' -- >> 205536
                    	  and nvl( itreg_fat.sn_pertence_pacote, 'N' ) = 'N'
                    	  and pro_fat.cd_pro_fat         = itreg_fat.cd_pro_fat
                    	  and gru_pro.cd_gru_pro         = pro_fat.cd_gru_pro
                          and conf.cd_convenio           = reg_fat.cd_convenio
                          and itlan_med.cd_reg_fat(+)    = itreg_fat.cd_reg_fat -->> 205536
                          and itlan_med.cd_lancamento(+) = itreg_fat.cd_lancamento -->> 205536
                          and ( gru_pro.tp_gru_pro in ( 'SP', 'SD' )
                                or ( gru_pro.tp_gru_pro = 'SH' and
					                 nvl( substr( pro_fat.tp_serv_hospitalar,1,1),'H') not in ('T','D') ) )
					  )
       -- pda 221368 - 13/03/2008 - Amalia Araújo
       and ( dbamv.pkg_mv2000.le_cliente <> 719
         or ( dbamv.pkg_mv2000.le_cliente = 719 and
          exists ( select 'x'
                     from dbamv.itreg_fat itreg,
                          dbamv.reg_fat   reg,
                          dbamv.atendime  ate
                     where ( itreg.cd_multi_empresa <> 4 or
                           -- PDA 279241- inicio - ou caso todos os procedimentos com tp_pagamento preenchido sejam credenciados */
                           not exists( select 'X'
                                         from dbamv.itreg_fat it4, reg_fat rg4, itlan_med il4
                                           where rg4.cd_atendimento = reg.cd_atendimento
                                             and it4.cd_reg_fat = rg4.cd_reg_fat
                                             and il4.cd_reg_fat(+) = it4.cd_reg_fat
                                             and il4.cd_lancamento(+) = it4.cd_lancamento
                                             and nvl(il4.tp_pagamento,it4.tp_pagamento) = 'P' ) )
                            -- PDA 279241 - final
                       and itreg.cd_reg_fat   = reg.cd_reg_fat
                       -- pda 225227 - 28/04/2008 - Amalia Araújo - Condição especial do conv AGF
                       and itreg.cd_pro_fat not in (
                           select i.cd_pro_fat
                             from dbamv.itreg_fat i,
                                  dbamv.pro_fat p,
                                  dbamv.gru_pro g,
                                  dbamv.reg_fat r
                            where r.cd_atendimento    = reg.cd_atendimento
                              and r.cd_convenio       = reg.cd_convenio
                              and r.cd_multi_empresa  = 5 -- (Sana)
                              and i.cd_reg_fat        = r.cd_reg_fat
                              and p.cd_pro_fat        = i.cd_pro_fat
                              and g.cd_gru_pro        = p.cd_gru_pro
                              and g.tp_gru_pro       in ('SD','SP')
                                                     )
                       -- pda 225227 - fim
                       and ate.cd_atendimento = reg.cd_atendimento
                       -- pda 236172 - 25/06/2008 - Amalia Araújo
                       -- Correção feita por Marin para não verificar contas anteriores do atendimento
                       and reg.cd_reg_fat in (select rf2.cd_reg_fat
                                                from dbamv.reg_fat rf2
                                                where rf2.cd_atendimento = reg_fat.cd_atendimento
                                                  and nvl(rf2.cd_conta_pai,rf2.cd_reg_fat) = reg_fat.cd_reg_fat) --
                       -- pda 236172 - fim
                       -- and reg.cd_convenio    = ate.cd_convenio   -- pda 245298 - 20/08/2008 - Amalia Araújo - por causa de conta de acoplamento
                       and reg.cd_atendimento = reg_fat.cd_atendimento ) ) )
	   and not exists
	      ( select 'X'
		      from dbamv.reg_fat,
			       dbamv.atendime,
				   dbamv.itreg_fat itr
			  where reg_fat.cd_atendimento        = pnAtendimento
			    and reg_fat.cd_reg_fat            = pnConta
			    and reg_fat.cd_atendimento        = atendime.cd_atendimento
			    and reg_fat.cd_convenio           = Conf.cd_convenio
			    and ( dbamv.pkg_mv2000.le_cliente <> 719 or
				    ( dbamv.pkg_mv2000.le_cliente = 719 and reg_fat.cd_multi_empresa in (1,2) ) )
			    and itr.cd_reg_fat = reg_Fat.cd_reg_fat
			    and dbamv.pkg_ffcv_tiss_aux.fnc_retorna_proc_natureza(reg_fat.cd_convenio,itr.cd_pro_fat) = 'S'
			    and ( ( itr.cd_prestador is not null
					    and nvl(itr.tp_pagamento,'P') = 'C'
					    and itr.cd_pro_fat not in ( select cd_pro_fat
													 from dbamv.itreg_fat it,
														  dbamv.itlan_med itl
												   where it.cd_reg_fat = itr.cd_reg_Fat
													 and itl.cd_reg_fat (+) = it.cd_reg_Fat
													 and itl.cd_lancamento (+) = it.cd_lancamento
													 and nvl(itl.tp_pagamento,it.tp_pagamento) = 'P'
													 and it.cd_pro_fat = itr.cd_pro_fat))
				     or itr.cd_prestador is null and not exists ( select 'X' from dbamv.itlan_med itl
																	where itl.cd_reg_fat = itr.cd_reg_Fat
																	  and itr.cd_lancamento = itl.cd_lancamento ) )
       -- pda 221368 - fim
           )
  ) order by Ordem_guia,
             sn_natureza desc, /* PDA 284714 - inserir primeiro na TISS_NR_GUIA os procedimentos com natureza S */
             cd_reg_fat,                -- pda 217868 - 12/03/2008 - Amalia Araújo
             cd_codigo_contratado,
			 nr_guia,  -- cd_guia_conta,  -- pda 211434
			 -- pda 236232 - 14/07/2008 - Amalia Araújo - alterando a posição da sn_horario_especial para antes da cd_ati_med
             -- pda 221861 adiconando o campo sn_horario_especial na ordenação
             decode(ordem_guia, 3, cd_prestador_solicitante||cd_prestador_executante||cd_pro_fat||to_char(dt_lancamento,'YYYYMMDD')||sn_horario_especial||cd_ati_med,  -- pda 222376
                                2, cd_prestador_solicitante||cd_prestador_executante||cd_ati_med||to_char(dt_lancamento,'YYYYMMDD')||sn_horario_especial||cd_pro_fat||vl_percentual_multipla,  -- pda 222376
                                   cd_prestador_solicitante||ordem_tp_proced||to_char(dt_lancamento,'YYYYMMDD')||cd_pro_fat||vl_percentual_multipla||sn_horario_especial||cd_prestador_executante||cd_ati_med );  -- pda 222376
  -- PDA 252700 (trocando a posição do cd_ati_med no ORDER BY acima , pois ele estava dando preferencia ao cd_Ati_med do que prestador executante fazendo assim a ordenação errada e inserindo na tiss_nr_guia linhas duplicadas)
  -- fim pda 221861
  --
  -- Cursor de Contas Ambulatoriais (Ambulatório / Urgência/Emergência / Externo)
  --------------------------------------------------------------------------------------------------------------------
  -- **ATENÇÃO** : Muito cuidado com a ordenação deste cursor, pois a geração correta da TISS_NR_GUIA depende disto.
  --------------------------------------------------------------------------------------------------------------------
  -- pda 209472 - 12/12/2007 - Amalia Araújo
  -- Este cursor foi alterado para usar futuras configurações de gerar ou não guia específica (conf.SN_GUIA_ESPEC)
  -- mas no momento está com valor fixo para não gerar, para ser avaliado no cliente 703.
  /*
  pda 236232 - 27/06/2008 - Amalia Araújo
  Alteração neste cursor para considerar a informação de HORÁRIO ESPECIAL de acordo com configuração criada.
  - Será necessário gravar o valor da coluna SN_HORARIO_ESPECIAL = 'S' em todos os lançamentos de horário
    especial (HE), caso a configuração CONVENIO_CONF_TISS.TP_INF_HORARIO_ESPECIAL for = 'H' (por hora de lançamento)
	ou 'P' (percentual de acréscimo e hora de lançamento).
  - A alteração para inclusão da coluna SN_HORARIO_ESPECIAL inclui os selects que retornam os procedimentos
    agrupados em uma única data. Os lançamentos de HE serão separados, nos restantes esta coluna ficará nula
	sem afetar o agrupamento. Será revista a implementação do pda 221861 para considerar a nova configuração.
  */
  /* pda 291677 - 09/06/2009 - Francisco Morais - Inserido o campo VL_PERCENTUAL_MULTIPLA no order by (apos o cd_pro_fat),
                                                  pois na conta podem existir procedimentos iguais com percentuais diferentes
                                                  se a ordenacao nao estiver correta o mesmo sera gerado em uma outra linha e
                                                  causara divergencia.*/
  /* pda 283464 - 28/04/09 - Francisco Morais - Inserido um decode no tipo de pagamento, onde se for Credenciado o codigo sera
                                                nulo, com isso o relatorio no campo 30 retornara o codigo do credenciamento do
                                                prestador Credenciado, pois sem essa condicao o sistema respeitava o codigo que
                                                estava sendo informado do credenciamento do convenio e nao o codigo do credenciamento
                                                do prestador no convenio.*/

  /* pda 282036 - 16/04/2009 - Francisco Morais - Problema corrigido no comentario do cursor cItensGravaAmb referente ao pda 280637.*/
  /* pda 275912 - 06/03/2009 - Francisco Morais - Ajuste no decode referente a ATI_MED (pda 274888)*/
  /* pda 274888 - 05/03/2009 - Francisco Morais
     Adicionado o campo ATI_MED_PRINC que corresponde a atividade medica do procedimento principal da conta, para que no momento da ordenacao nao seja
     criada guias diferentes (desnecessarias), a ordenacao sera a partir do ATI_MED do procedimento principal.*/
  /* pda 276628 - 11/03/09 - Francisco Morais - Correcao feita por conta da atividade medica padrao (Ativ. Medica Clinico),
                                                substituido dos cursores (cItensGravaHosp e cItensGravaAmb) a atividade medica
                                                '07' pelo dbamv.pkt_config_ffcv.retorna_campo(dbamv.pkg_mv2000.le_empresa,
                                                'CD_ATI_MED_CLINICO' )*/
  /* pda 280637 - 03/04/2009 - Francisco Morais
     Problema corrigido no select específico para quando não houver nenhum procedimento para a guia principal, o codigo do setor de
     origem do atendimento nao estava sendo informado  e com isso era gerada mais de uma linha na tiss nr guia com isso eram gerados
     mais de um relatorio. Foi inserido o codigo do setor do atendimento na chamada da funcao dbamv.pkg_ffcv_tiss_aux.fnc_retorna_contratado
     e o problema foi corrigido.  Em analize com o Thiago foi alterado o valor da coluna SN_PREST_PRINC para ser fixo como '1' por conta
     da ordenacao dependendo da configuracao SN_SEPARA_PREST_GUIA estar como 'S'.*/
  --
  cursor cItensGravaAmb is
    Select ORDEM_GUIA                -- pda 209472 - 12/12/2007 - Amalia Araújo
          , DECODE (TP_PAGamenTO,'C','2','1') ORDEM_TP_PAGTO  -- pda 209472 - 12/12/2007 - Amalia Araújo
          , DECODE(SN_PROC_PRINC,'S','1',decode(tp_consulta,null,'2','1')) SN_PROC_PRINC   -- pda 209472 / PDA 279630

          /* pda 293128 - 29/06/2009 - Francisco Morais - A identificacao do prestador de credenciados nao respeitava a configuracao de prestadores por origem.*/
          , /*Decode( Nvl(tp_pagamento,'P'), 'C',NULL, cd_codigo_contratado)*/ cd_codigo_contratado

          ,decode( ordem_guia, '1', null,
                               '3', DECODE( cd_guia_conta, cd_guia_atend, null, cd_guia_conta ),
                               cd_guia_conta ) Cd_Guia_Conta  -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
          ,Cd_Pro_Fat
          ,sn_guia_consulta
          ,tp_consulta
           /*  -- pda 209472 - 12/12/2007 - Amalia Araújo
          ,decode(tp_pagamento,'P','1','2')                             -- primeiro não credenciados(1) e depois os credenciados(2)
		   ||decode(cd_pro_fat,cd_pro_int,'PR'
                      ,decode(prestador_principal,lpad(cd_prestador_executante,4,0)||lpad(to_number(substr(lpad(cd_prestador_solicitante,10,'0'),1,9)),4,0),'QR'
                                ,'RR'))                                  -- depois ordena pelo procedimento principal(PR)
		   ||decode(cd_guia_conta,null,'1','2')                         -- depois pelas guias específicas de não credenciados
		   ||decode(substr(cd_prestador_solicitante,-1,1),'P','P','Q')  -- depois pelo prestador solicitante interno(P) e depois externo(Q)
		     tp_ordem	   --*/
          ,Dt_Lancamento
          ,to_number(substr(lpad(cd_prestador_solicitante,10,'0'),1,9)) cd_prestador_solicitante
          ,substr(cd_prestador_solicitante,-1,1) tp_prestador_solicitante
          ,cd_prestador_executante
          ,tp_pagamento
          --,Cd_Ati_Med
          ,decode(SN_SEPARA_PREST_GUIA,'S',Cd_Ati_Med,null) Cd_Ati_Med --233267
          ,tp_serv_hospitalar
          ,Tp_Gru_Pro
          ,Qt_Lancamento
          ,Vl_Total_Conta
          ,Cd_Gru_Pro
          ,Cd_Convenio
          ,cd_lancamento
          ,cd_itlan_med
          ,nr_guia_envio_principal
          ,cd_multi_empresa
          ,tp_atendimento
          --,cd_select				  -- pda 209472 - 12/12/2007 - Amalia Araújo
          --,ordem_tp_proced		  -- pda 209472 - 12/12/2007 - Amalia Araújo
          ,SN_PREST_PRINC             -- pda 209472 - 12/12/2007 - Amalia Araújo
          ,nr_guia_envio_atendime     -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
          ,SN_GUIA_ESPECIF            -- pda 211289 - 14/01/2008 - Thiago Miranda de Oliveira
          ,SN_SEPARA_PREST_GUIA       -- pda 211289 - 14/01/2008 - Thiago Miranda de Oliveira
          ,SN_somente_xml 			  -- pda 214757 - 07/03/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          ,sn_horario_especial        -- pda 221861
          ,tp_inf_horario_especial    -- pda 236232
          ,ordem_natureza             -- pda 248374
          , vl_percentual_multipla   /* PDA.: 266927 - 09/01/2009 - Emanoel Deivison */
          ,ATI_MED_PRINC
         -- ,cd_lanc_agrup              --PDA 284066
    From(
    select itreg_amb.cd_prestador cd_prestador_executante,
           itreg_amb.cd_pro_fat,
           pro_fat.tp_serv_hospitalar,
           nvl( itreg_amb.cd_ati_med, dbamv.pkt_config_ffcv.retorna_campo(dbamv.pkg_mv2000.le_empresa, 'CD_ATI_MED_CLINICO' ) ) cd_ati_med,
           Decode( conf.tp_totaliza_amb||'-'||itreg_amb.sn_horario_especial,
                  'L-N',trunc(nvl( itreg_amb.dt_sessao,atendime.dt_atendimento)),
                  'U-N',trunc(nvl( itreg_amb.dt_sessao, atendime.dt_atendimento )),
                        decode(conf.tp_inf_horario_especial||'-'||nvl(itreg_amb.sn_horario_especial,'N'),'S-S',trunc(nvl( itreg_amb.dt_sessao, atendime.dt_atendimento )),
						to_date(to_char(trunc(nvl(itreg_amb.dt_sessao,atendime.dt_atendimento)))||' '||to_char(itreg_amb.hr_lancamento,'HH24:MI'),'DD/MM/YYYY HH24:MI'))) dt_lancamento,
           gru_pro.tp_gru_pro,
           guia.tp_guia,
           atendime.tp_atendimento,
           itreg_amb.qt_lancamento qt_lancamento,
           itreg_amb.vl_total_conta vl_total_conta,
           itreg_amb.cd_setor_produziu cd_setor,
           decode( guia.nr_guia, null, null, itreg_amb.cd_guia ) cd_guia_conta,
           gru_pro.cd_gru_pro,
           reg_amb.cd_convenio,
           itreg_amb.cd_lancamento,
           -- PDA 206895 Inicio
           -- nvl(itreg_amb.tp_pagamento,'P') tp_pagamento,
           DECODE(nvl( itreg_amb.tp_pagamento, 'P' ), 'P', 'P'
                                                    , 'F', 'P'
                                                    , 'C', 'C') tp_pagamento,
           -- PDA 206895 Fim
           to_number(null)  cd_itlan_med,
           nvl( guia2.nr_guia, atendime.nr_guia_envio_principal ) nr_guia_envio_principal,    -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
           atendime.nr_guia_envio_principal                       nr_guia_envio_atendime,     -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
           reg_amb.cd_multi_empresa,
           dbamv.pkg_ffcv_tiss_aux.fnc_retorna_contratado( atendime.cd_atendimento, reg_amb.cd_convenio,
		                                                   pro_fat.cd_pro_fat, itreg_amb.cd_setor_produziu,
														   gru_pro.cd_gru_pro, gru_pro.tp_gru_pro ) cd_codigo_contratado,
           dbamv.pkg_ffcv_tiss.prestador_solic_ambul( itreg_amb.cd_atendimento, reg_amb.cd_reg_amb,
                                                --itreg_amb.cd_pro_fat ) cd_prestador_solicitante,                         --pda 270489 - 29/01/09 - Francisco Morais
                                                itreg_amb.cd_pro_fat ||'@'|| itreg_amb.cd_mvto ) cd_prestador_solicitante, --pda 270489 - 29/01/09 - Francisco Morais

           atendime.cd_pro_int,
           conf.sn_guia_consulta,
           pro_fat.tp_consulta
           --'1' cd_select,				  -- pda 209472 - 12/12/2007 - Amalia Araújo
           --'1' ordem_tp_proced		    -- pda 209472 - 12/12/2007 - Amalia Araújo
          ,DECODE ( conf.SN_GUIA_ESPECIF, 'S', -- pda 211289 - 14/01/2008 - Thiago Miranda de Oliveira - substituindo código pela coluna
             DECODE (  DECODE( itreg_AMB.cd_guia,atendime.cd_guia,'S','N'),'S',
                             DECODE(itreg_AMB.tp_pagAMENto,'C','3','1'), DECODE(itreg_AMB.tp_pagAMENto,'C','3',DECODE(guia.nr_guia,null,'1','2'))  )
            ,DECODE(itreg_AMB.tp_pAgAMENto,'C','3','1') )                   ORDEM_GUIA     -- pda 209472 - 12/12/2007 - Amalia Araújo

          ,DECODE( itreg_amb.cd_pro_fat,atendime.cd_pro_int,'S','N')      SN_PROC_PRINC  -- pda 209472 - 12/12/2007 - Amalia Araújo

          ,ATENDIME.CD_GUIA CD_GUIA_ATEND  -- pda 209472 - 12/12/2007 - Amalia Araújo
          ,DECODE(itreg_amb.CD_PRESTADOR,atendime.CD_PRESTADOR,'1','2') SN_PREST_PRINC -- pda 209472 - 12/12/2007 - Amalia Araújo
          ,conf.SN_GUIA_ESPECIF      -- pda 211289 - 14/01/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          ,conf.SN_SEPARA_PREST_GUIA -- pda 211289 - 14/01/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          ,conf.SN_somente_xml -- pda 214757 - 07/03/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          --
          -- pda 236232 - 14/07/2008 - Substituindo coluna sn_horario_especial para utilizar a nova configuração
          --,decode(conf.nr_registro_operadora_ans, '323080', itreg_amb.sn_horario_especial, null) sn_horario_especial  -- pda 221861
          ,decode( conf.tp_inf_horario_especial, 'S', null,
		           decode( itreg_amb.sn_horario_especial, 'S', itreg_amb.sn_horario_especial, null )) sn_horario_especial
          ,conf.tp_inf_horario_especial
		  -- pda 236232 - fim
		  --
          , '2'  ordem_natureza -- pda 248374
          , itreg_amb.vl_percentual_multipla /* PDA.: 266927 - 09/01/2009 - Emanoel Deivison */
          ,ATI_MED_PRINC.CD_ATI_MED ATI_MED_PRINC

         /* ,Decode( conf.tp_totaliza_amb||'-'||itreg_amb.sn_horario_especial,
                   'L-N',0,'U-N',0,decode(conf.tp_inf_horario_especial||'-'||nvl(itreg_amb.sn_horario_especial,'N'),'S-S',0,itreg_Amb.cd_lancamento)) cd_lanc_agrup*/
      from dbamv.itreg_amb,
           dbamv.reg_amb,
           dbamv.pro_fat,
           dbamv.gru_pro,
           dbamv.prestador,
		   dbamv.Convenio_Conf_Tiss conf,
           dbamv.atendime,
           dbamv.guia,
           dbamv.guia guia2             -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
           ,(SELECT  Min (cd_ati_med) cd_ati_med FROM dbamv.itreg_amb WHERE cd_pro_fat = (SELECT DISTINCT cd_pro_int
                                                                                          FROM dbamv.atendime
                                                                                          where cd_atendimento = pnAtendimento)
                                                                      AND cd_atendimento = pnAtendimento
                                                                      AND cd_reg_amb = pnConta) ATI_MED_PRINC
     where itreg_amb.cd_atendimento      = pnAtendimento
       and itreg_amb.cd_reg_amb          = pnConta
       and itreg_amb.cd_reg_amb          = reg_amb.cd_reg_amb
       and itreg_amb.cd_atendimento      = atendime.cd_atendimento
       and prestador.cd_prestador        = itreg_amb.cd_prestador
       and pro_fat.cd_pro_fat            = itreg_amb.cd_pro_fat
       and gru_pro.cd_gru_pro            = pro_fat.cd_gru_pro
       and reg_amb.cd_convenio           = Conf.cd_convenio
       and gru_pro.tp_gru_pro         in ('SP','SD','SH')
       and ( ( gru_pro.tp_gru_pro = 'SH' and substr(nvl(pro_fat.tp_serv_hospitalar,'X'),1,1) not in ('T','D') )
             or gru_pro.tp_gru_pro <> 'SH' )
       and guia.cd_guia(+) = itreg_amb.cd_guia
       AND GUIA2.CD_GUIA(+) = ATENDIME.CD_GUIA           -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
	   and nvl( itreg_amb.sn_pertence_pacote, 'N' ) = 'N'
       and nvl( itreg_amb.sn_paciente_paga  ,'N') = 'N'
	   and ( nvl(itreg_amb.tp_pagamento,'P') <> 'C' or
            ( nvl(itreg_amb.tp_pagamento,'P') = 'C' and conf.sn_imprime_credenciado = 'S' ) )
    --
    union all
    --
    -- Select específico para SH sem prestador que não é Diária nem Taxa.
    select atendime.cd_prestador cd_prestador_executante,
           itreg_amb.cd_pro_fat,
           pro_fat.tp_serv_hospitalar,
           nvl( itreg_amb.cd_ati_med, dbamv.pkt_config_ffcv.retorna_campo(dbamv.pkg_mv2000.le_empresa, 'CD_ATI_MED_CLINICO' ) ) cd_ati_med,
           Decode( conf.tp_totaliza_amb||'-'||itreg_amb.sn_horario_especial,
                  'L-N',trunc(nvl( itreg_amb.dt_sessao,atendime.dt_atendimento)),
                  'U-N',trunc(nvl( itreg_amb.dt_sessao, atendime.dt_atendimento )),
                        decode(conf.tp_inf_horario_especial||'-'||nvl(itreg_amb.sn_horario_especial,'N'),
                        'S-S',trunc(nvl( itreg_amb.dt_sessao, atendime.dt_atendimento )),
						      to_date(to_char(trunc(nvl(itreg_amb.dt_sessao,atendime.dt_atendimento)))||' '||to_char(itreg_amb.hr_lancamento,'HH24:MI'),'DD/MM/YYYY HH24:MI'))) dt_lancamento,
           gru_pro.tp_gru_pro,
           guia.tp_guia,
           atendime.tp_atendimento,
           itreg_amb.qt_lancamento qt_lancamento,
           itreg_amb.vl_total_conta vl_total_conta,
           itreg_amb.cd_setor_produziu cd_setor,
           decode( guia.nr_guia, null, null, itreg_amb.cd_guia ) cd_guia_conta,
           gru_pro.cd_gru_pro,
           reg_amb.cd_convenio,
           itreg_amb.cd_lancamento,
           -- PDA 206895 Inicio
           -- nvl(itreg_amb.tp_pagamento,'P') tp_pagamento,
           DECODE(nvl( itreg_amb.tp_pagamento, 'P' ), 'P', 'P'
                                                    , 'F', 'P'
                                                    , 'C', 'C') tp_pagamento,
           -- PDA 206895 Fim
           to_number(null)  cd_itlan_med,
           nvl( guia2.nr_guia, atendime.nr_guia_envio_principal ) nr_guia_envio_principal,    -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
           atendime.nr_guia_envio_principal                       nr_guia_envio_atendime,     -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
           reg_amb.cd_multi_empresa,
           dbamv.pkg_ffcv_tiss_aux.fnc_retorna_contratado( atendime.cd_atendimento, reg_amb.cd_convenio,
		                                                   pro_fat.cd_pro_fat, itreg_amb.cd_setor_produziu,
														   gru_pro.cd_gru_pro, gru_pro.tp_gru_pro ) cd_codigo_contratado,
           dbamv.pkg_ffcv_tiss.prestador_solic_ambul( itreg_amb.cd_atendimento, reg_amb.cd_reg_amb,
                                                   --itreg_amb.cd_pro_fat ) cd_prestador_solicitante,                         --pda 270489 - 29/01/09 - Francisco Morais
                                                   itreg_amb.cd_pro_fat ||'@'|| itreg_amb.cd_mvto ) cd_prestador_solicitante, --pda 270489 - 29/01/09 - Francisco Morais
           atendime.cd_pro_int,
           conf.sn_guia_consulta,
           pro_fat.tp_consulta
           --'2' cd_select,		  -- pda 209472 - 12/12/2007 - Amalia Araújo
           --'1' ordem_tp_proced		  -- pda 209472 - 12/12/2007 - Amalia Araújo
          ,DECODE ( conf.SN_GUIA_ESPECIF, 'S', -- pda 211289 - 14/01/2008 - Thiago Miranda de Oliveira - substituindo código pela coluna
             DECODE (  DECODE( itreg_AMB.cd_guia,atendime.cd_guia,'S','N'),'S',
                             DECODE(itreg_AMB.tp_pagAMENto,'C','3','1'), DECODE(itreg_AMB.tp_pagAMENto,'C','3',DECODE(guia.nr_guia,null,'1','2'))  )
                ,DECODE(itreg_AMB.tp_pAgAMENto,'C','3','1') )                   ORDEM_GUIA     -- pda 209472 - 12/12/2007 - Amalia Araújo

          , DECODE( itreg_amb.cd_pro_fat,atendime.cd_pro_int,'S','N')      SN_PROC_PRINC  -- pda 209472 - 12/12/2007 - Amalia Araújo

          , ATENDIME.CD_GUIA CD_GUIA_ATEND  -- pda 209472 - 12/12/2007 - Amalia Araújo
          ,DECODE(itreg_amb.CD_PRESTADOR,atendime.CD_PRESTADOR,'1','2') SN_PREST_PRINC -- pda 209472 - 12/12/2007 - Amalia Araújo
          ,conf.SN_GUIA_ESPECIF      -- pda 211289 - 14/01/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          ,conf.SN_SEPARA_PREST_GUIA -- pda 211289 - 14/01/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          ,conf.SN_somente_xml -- pda 214757 - 07/03/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          --
          -- pda 236232 - 14/07/2008 - Substituindo coluna sn_horario_especial para utilizar a nova configuração
          --,decode(conf.nr_registro_operadora_ans, '323080', itreg_amb.sn_horario_especial, null) sn_horario_especial  -- pda 221861
          ,decode( conf.tp_inf_horario_especial, 'S', null,
		           decode( itreg_amb.sn_horario_especial, 'S', itreg_amb.sn_horario_especial, null )) sn_horario_especial
          ,conf.tp_inf_horario_especial
		  -- pda 236232 - fim
		  --
          , '2'                              ordem_natureza
          , itreg_amb.vl_percentual_multipla /* PDA.: 266927 - 09/01/2009 - Emanoel Deivison */
          ,ATI_MED_PRINC.CD_ATI_MED ATI_MED_PRINC

          /*,Decode( conf.tp_totaliza_amb||'-'||itreg_amb.sn_horario_especial,
                   'L-N',0,'U-N',0,decode(conf.tp_inf_horario_especial||'-'||nvl(itreg_amb.sn_horario_especial,'N'),'S-S',0,itreg_Amb.cd_lancamento)) cd_lanc_agrup*/
      from dbamv.itreg_amb,
           dbamv.reg_amb,
           dbamv.pro_fat,
           dbamv.prestador,
           dbamv.gru_pro,
		       dbamv.Convenio_Conf_Tiss conf,
           dbamv.atendime,
           dbamv.guia,
           DBAMV.GUIA   GUIA2          -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
           ,(SELECT  Min (cd_ati_med) cd_ati_med FROM dbamv.itreg_amb WHERE cd_pro_fat = (SELECT DISTINCT cd_pro_int
                                                                                          FROM dbamv.atendime
                                                                                          where cd_atendimento = pnAtendimento)
                                                                      AND cd_atendimento = pnAtendimento
                                                                      AND cd_reg_amb = pnConta) ATI_MED_PRINC
     where itreg_amb.cd_atendimento      = pnAtendimento
       and itreg_amb.cd_reg_amb          = pnConta
       and itreg_amb.cd_reg_amb          = reg_amb.cd_reg_amb
       and itreg_amb.cd_atendimento      = atendime.cd_atendimento
       and itreg_amb.cd_prestador       is null
       and prestador.cd_prestador        = atendime.cd_prestador
       and pro_fat.cd_pro_fat            = itreg_amb.cd_pro_fat
       and gru_pro.cd_gru_pro            = pro_fat.cd_gru_pro
       and reg_amb.cd_convenio           = Conf.cd_convenio
       and ( gru_pro.tp_gru_pro = 'SH' and substr(nvl(pro_fat.tp_serv_hospitalar,'X'),1,1) not in ('T','D') )
       and guia.cd_guia(+) = itreg_amb.cd_guia
       AND GUIA2.CD_GUIA(+) = ATENDIME.CD_GUIA           -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
	   and nvl( itreg_amb.sn_pertence_pacote, 'N' ) = 'N'
       and nvl( itreg_amb.sn_paciente_paga  ,'N') = 'N'
	   and ( nvl(itreg_amb.tp_pagamento,'P') <> 'C' or
            ( nvl(itreg_amb.tp_pagamento,'P') = 'C' and conf.sn_imprime_credenciado = 'S' ) )
    --pda 248374
    union all
    --
    select distinct atendime.cd_prestador   cd_prestador_executante,
           itreg_amb.cd_pro_fat				cd_pro_fat,
           to_char(null) 					tp_serv_hospitalar,
           nvl( itreg_amb.cd_ati_med, dbamv.pkt_config_ffcv.retorna_campo(dbamv.pkg_mv2000.le_empresa, 'CD_ATI_MED_CLINICO' )) cd_ati_med,
           trunc(atendime.dt_atendimento) 	dt_lancamento,
           to_char(null) 					tp_gru_pro,
           to_char(null)					tp_guia,
           atendime.tp_atendimento			tp_atendimento,
           to_number(null)                  qt_lancamento,
           to_number(null)                  vl_total_conta,
           to_number(null)                  cd_setor,
           null                				cd_guia_conta,
           to_number(null) 					cd_gru_pro,
           reg_amb.cd_convenio				cd_convenio,
           itreg_amb.cd_lancamento			cd_lancamento,
           'P'                  			tp_pagamento,
           to_number(null)  				cd_itlan_med,
           atendime.nr_guia_envio_principal nr_guia_envio_principal,
           atendime.nr_guia_envio_principal nr_guia_envio_atendime,
           reg_amb.cd_multi_empresa			cd_multi_empresa,
           to_char(null)                    cd_codigo_contratado,
           atendime.cd_prestador||'P'       cd_prestador_solicitante,
           atendime.cd_pro_int              cd_pro_int,
           'N'                              sn_guia_consulta,
           to_char(null)                    tp_consulta,
           '1'                              ORDEM_GUIA,
           'N'                              SN_PROC_PRINC,
           to_number(null)                  CD_GUIA_ATEND,
           '1'                              SN_PREST_PRINC,
           conf.SN_GUIA_ESPECIF             SN_GUIA_ESPECIF,
           conf.SN_SEPARA_PREST_GUIA        SN_SEPARA_PREST_GUIA,
           conf.sn_somente_xml              SN_somente_xml,
           decode( conf.tp_inf_horario_especial, 'S', null,
		           decode( itreg_amb.sn_horario_especial, 'S', itreg_amb.sn_horario_especial, null )) sn_horario_especial,
           conf.tp_inf_horario_especial     tp_inf_horario_especial,
           '1'                              ordem_natureza
          , to_number(null) vl_percentual_multipla  /* PDA.: 266927 - 09/01/2009 - Emanoel Deivison */
          ,To_Char(NULL) ATI_MED_PRINC
          --,0 cd_lanc_agrup
      from dbamv.reg_amb,
           dbamv.itreg_amb,
           dbamv.convenio_conf_tiss conf,
           dbamv.atendime,
           dbamv.cod_pro
     where itreg_amb.cd_atendimento           = pnAtendimento
       and itreg_amb.cd_reg_amb               = pnConta
       and reg_amb.cd_reg_amb                 = itreg_amb.cd_reg_amb
       and itreg_amb.cd_atendimento           = atendime.cd_atendimento
       and cod_pro.cd_pro_fat                 = itreg_amb.cd_pro_fat
       and reg_amb.cd_convenio                = conf.cd_convenio
       and reg_amb.cd_convenio                = cod_pro.cd_convenio
       and conf.sn_somente_xml                = 'N'
       and upper(cod_pro.ds_unidade_cobranca) = 'NATUREZA'
       -- fim pda 248374
    union all
    -- pda 205536 - 29/10/2007 - Amalia Araújo - Colocado DISTINCT e correção na condição de NOT EXISTS.
    -- Select específico para quando não houver nenhum procedimento para a guia principal.
    select --distinct to_number(null)  		cd_prestador_executante, -- pda 206435 - Thiago Miranda de Oliveira 07/11/2007 - comentando codigo
           distinct atendime.cd_prestador   cd_prestador_executante, -- pda 206435 - Thiago Miranda de Oliveira 07/11/2007 - pegando o prestador do atendimento
           '0' 								cd_pro_fat,
           to_char(null) 					tp_serv_hospitalar,
           dbamv.pkt_config_ffcv.retorna_campo(dbamv.pkg_mv2000.le_empresa, 'CD_ATI_MED_CLINICO' ) 							cd_ati_med,
           trunc(atendime.dt_atendimento) 	dt_lancamento,
           to_char(null) 					tp_gru_pro,
           to_char(null)					tp_guia,
           atendime.tp_atendimento			tp_atendimento,
           to_number(null) 					qt_lancamento,
           to_number(null) 					vl_total_conta,
           to_number(null) 					cd_setor,
           null   				    		cd_guia_conta,  -- aqui não aceitou to_char nem to_number.
           to_number(null) 					cd_gru_pro,
           reg_amb.cd_convenio				cd_convenio,
           to_number(null) 					cd_lancamento,
           'P' 								tp_pagamento,
           to_number(null)  				cd_itlan_med,
           nvl( guia2.nr_guia, atendime.nr_guia_envio_principal ) nr_guia_envio_principal,    -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
           atendime.nr_guia_envio_principal                       nr_guia_envio_atendime,     -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
           reg_amb.cd_multi_empresa			cd_multi_empresa,
           dbamv.pkg_ffcv_tiss_aux.fnc_retorna_contratado( atendime.cd_atendimento, reg_amb.cd_convenio,
		                                                   null, --null, -- pda 237507 - solocar o setor da conta como parametro
                                                           CdSetorOrigem.cd_setor,
														   null, null ) cd_codigo_contratado,
           dbamv.pkg_ffcv_tiss.prestador_solic_ambul( atendime.cd_atendimento, reg_amb.cd_reg_amb,
			                                          null ) cd_prestador_solicitante,
           atendime.cd_pro_int,
           conf.sn_guia_consulta,
           NULL tp_consulta
           --'3' 								cd_select,    -- pda 209472 - 12/12/2007 - Amalia Araújo
           --'1' 								ordem_tp_proced    -- pda 209472 - 12/12/2007 - Amalia Araújo
          ,'1'    ORDEM_GUIA     -- pda 209472 - 12/12/2007 - Amalia Araújo

          , 'N'      SN_PROC_PRINC  -- pda 209472 - 12/12/2007 - Amalia Araújo

          , ATENDIME.CD_GUIA CD_GUIA_ATEND  -- pda 209472 - 12/12/2007 - Amalia Araújo
          ,'1' SN_PREST_PRINC
          ,conf.SN_GUIA_ESPECIF      -- pda 211289 - 14/01/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          ,conf.SN_SEPARA_PREST_GUIA -- pda 211289 - 14/01/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          ,conf.SN_somente_xml -- pda 214757 - 07/03/2008 - Thiago Miranda de oliveira - adicionando nova coluna no select
          ,to_char( null ) sn_horario_especial   -- pda 221861
          ,conf.tp_inf_horario_especial          -- pda 236232
          ,'2'                              ordem_natureza
          , to_number(null) vl_percentual_multipla  /* PDA.: 266927 - 09/01/2009 - Emanoel Deivison */
          ,To_Char(NULL) ATI_MED_PRINC
          --,0 cd_lanc_agrup
      from dbamv.reg_amb,
           dbamv.itreg_amb,
           dbamv.Convenio_Conf_Tiss conf,
           dbamv.atendime,
           dbamv.pro_fat,
           dbamv.guia guia2             -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
          ,( select cd_setor
             from dbamv.ori_ate
             where cd_ori_ate IN (
                                  select cd_ori_ate
                                  from DBamv.atendime
                                  where cd_atendimento = pnAtendimento)
          )CdSetorOrigem
     where itreg_amb.cd_atendimento      = pnAtendimento
       and itreg_amb.cd_reg_amb          = pnConta
       and reg_amb.cd_reg_amb            = itreg_amb.cd_reg_amb
       and itreg_amb.cd_atendimento      = atendime.cd_atendimento
       and pro_fat.cd_pro_fat            = itreg_amb.cd_pro_fat
       and reg_amb.cd_convenio           = Conf.cd_convenio
       AND GUIA2.CD_GUIA(+) = ATENDIME.CD_GUIA           -- pda 209472 - 12/12/2007 - Amalia Araújo (*)
       and not exists( select itreg.cd_pro_fat
                         from dbamv.itreg_amb itreg, dbamv.pro_fat, dbamv.gru_pro
                        where itreg.cd_reg_amb     = itreg_amb.cd_reg_amb
                          and itreg.cd_atendimento = itreg_amb.cd_atendimento     -- pda 205536 - 29/10/2007 - Amalia Araújo
                          and nvl( itreg.tp_pagamento, 'P' ) <> 'C'
                    	  and nvl( itreg.sn_pertence_pacote, 'N' ) = 'N'
                    	  and pro_fat.cd_pro_fat       = itreg.cd_pro_fat
                    	  and gru_pro.cd_gru_pro       = pro_fat.cd_gru_pro
                          and ( gru_pro.tp_gru_pro in ( 'SP', 'SD' )
                                or ( gru_pro.tp_gru_pro = 'SH' and
								     nvl( substr( pro_fat.tp_serv_hospitalar,1,1),'H') not in ('T','D') ) ) )
      -- pda 248374
      and not exists(select 'X'
                       from dbamv.reg_amb,
                            dbamv.itreg_amb,
                            dbamv.convenio_conf_tiss conf,
                            dbamv.cod_pro
                      where itreg_amb.cd_atendimento      = pnAtendimento
                        and itreg_amb.cd_reg_amb          = pnConta
                        and reg_amb.cd_reg_amb            = itreg_amb.cd_reg_amb
                        and cod_pro.cd_pro_fat            = itreg_amb.cd_pro_fat
                        and reg_amb.cd_convenio           = conf.cd_convenio
                        and reg_amb.cd_convenio           = cod_pro.cd_convenio
                        and conf.sn_somente_xml           = 'N'
                        and cod_pro.ds_unidade_cobranca   = 'NATUREZA')
       -- fim pda 248374
    --) order by tp_ordem, cd_codigo_contratado, cd_guia_conta;            -- PDA JALS Inicio/Fim
    -- pda 211289 - Thiago Miranda de Oliveira colocando um nvl no campo de SN_SEPARA_PREST_GUIA
    ) order by ordem_guia
             , ordem_natureza -- pda 248374
             , ORDEM_TP_PAGTO
             , decode(SN_SEPARA_PREST_GUIA,'S',SN_PREST_PRINC,null)
             , cd_guia_conta
             , SN_PROC_PRINC
             , cd_codigo_contratado desc
             , decode(SN_SEPARA_PREST_GUIA,'S',cd_prestador_solicitante,null) -- PDA.: 249027 - Emanoel Deivison - 17/09/2008
             , decode(SN_SEPARA_PREST_GUIA,'S',cd_prestador_executante,null)
             , decode(SN_SEPARA_PREST_GUIA,'S',decode(CD_ATI_MED,ATI_MED_PRINC,'00', cd_ati_med),null)
             , cd_pro_fat
             , vl_percentual_multipla
             , sn_horario_especial; -- pda 221861  ( pda 236232 - está correto assim )
    -- 209094 - Thiago Miranda de oliveira adicionando cd_prestador_solcitante e cd_prestador_executante na ordenação
  --
  -- Verifica se a conta está fechada - fica
  cursor cContaFechada is
    select flag, cd_remessa from (
      select 'S' flag,
             cd_remessa
        from dbamv.reg_fat
       where reg_fat.cd_atendimento = pnAtendimento
         and reg_fat.cd_reg_fat     = pnConta
         and reg_fat.sn_fechada     = 'S'
         and pvTpConta              = 'H'
      union all
      select 'S' flag,
            cd_remessa
        from dbamv.reg_amb
       where reg_amb.cd_reg_amb     = pnConta
         and pvTpConta              = 'A'
         and not exists ( select itreg_amb.sn_fechada from dbamv.itreg_amb
                           where itreg_amb.cd_atendimento = pnAtendimento
                             and itreg_amb.cd_reg_amb     = reg_amb.cd_reg_amb
                             and itreg_amb.sn_fechada     = 'N' ) );
  --
  -- pda 206435 - 07/11/2007 - Amalia Araújo
  -- Condição NOT EXISTS porque se houver algum registro com NR_GUIA_PRINCIPAL nulo, é para processar como se
  -- não tivesse nenhum registro na TISS_NR_GUIA.
  --
  -- pda 224554 - 15/04/2008 - Amalia Araújo - Acertos no select hospitalar.
  -- pda 221585 - 25/03/2008 - Amalia Araújo - Refazendo query hospitalar por causa do Sta Joana.
  -- pda 205536 - 29/10/2007 - Amalia Araújo
  cursor cTemTiss is
    select tiss.cd_atendimento
      from dbamv.tiss_nr_guia tiss
     where tiss.cd_atendimento = pnAtendimento
       and tiss.cd_reg_fat in ( select r.cd_reg_fat from dbamv.reg_fat r
                                    where r.cd_atendimento = tiss.cd_atendimento
                                      and r.cd_conta_pai = pnConta
                                   union all
                                   select r.cd_reg_fat from dbamv.reg_fat r
                                    where r.cd_atendimento = tiss.cd_atendimento
                                      and r.cd_reg_fat = pnConta
                                 )
       and tiss.nr_guia_principal is not null
       and pvTpConta = 'H'
    union all
    select tiss.cd_atendimento
      from dbamv.tiss_nr_guia tiss
     where tiss.cd_atendimento = pnAtendimento
       and tiss.cd_reg_amb     = pnConta
       and tiss.nr_guia_principal is not null
       and pvTpConta           = 'A';
  /*
    select tiss.cd_atendimento
      from dbamv.tiss_nr_guia tiss,
           dbamv.reg_fat
     where reg_fat.cd_atendimento = pnAtendimento
       and reg_fat.cd_reg_fat in ( select r.cd_reg_fat from dbamv.reg_fat r
                                    where r.cd_atendimento = reg_fat.cd_atendimento
                                      and r.cd_conta_pai = pnConta
                                   union all
                                   select r.cd_reg_fat from dbamv.reg_fat r
                                    where r.cd_atendimento = reg_fat.cd_atendimento
                                      and r.cd_reg_fat = pnConta
                                 )
       and tiss.cd_atendimento = reg_fat.cd_atendimento
       and tiss.cd_reg_fat = reg_fat.cd_reg_fat
       and ( tiss.tp_guia = 'RI' or ( tiss.tp_guia <> 'RI' and nvl(tiss.cd_pro_fat,'0') <> '0' ) )
       and not exists ( select t.cd_atendimento
                          from dbamv.tiss_nr_guia t
                         where t.cd_atendimento = tiss.cd_atendimento
                           and t.cd_reg_fat in ( select r.cd_reg_fat from dbamv.reg_fat r
                                                  where r.cd_atendimento = reg_fat.cd_atendimento
                                                    and r.cd_conta_pai = pnConta
                                                 union all
                                                 select r.cd_reg_fat from dbamv.reg_fat r
                                                  where r.cd_atendimento = reg_fat.cd_atendimento
                                                    and r.cd_reg_fat = pnConta
                                                )
                           and t.nr_guia_principal is null )
       and pvTpConta           = 'H'
    union all
    select tiss.cd_atendimento
      from dbamv.tiss_nr_guia tiss
     where tiss.cd_atendimento = pnAtendimento
       and tiss.cd_reg_amb     = pnConta
       and nvl(tiss.cd_pro_fat,'0') <> '0' -- pda 221585 - 22/03/2008
       and not exists ( select t.cd_atendimento from dbamv.tiss_nr_guia t
                         where t.cd_atendimento = tiss.cd_atendimento and t.cd_reg_amb = tiss.cd_reg_amb
                           and t.nr_guia_principal is null )
       and pvTpConta           = 'A';  */
  -- pda 206435 - fim
  -- pda 221585 - fim
  --
  cursor cTissCerto is
    select distinct t.cd_reg_amb
      from dbamv.tiss_nr_guia t
     where t.cd_atendimento = pnAtendimento
       and t.cd_reg_amb     = pnConta
       and pvTpConta        = 'A';
  --
  cursor cTissErrado is
    select distinct t.cd_reg_amb
      from dbamv.tiss_nr_guia t
     where t.cd_atendimento = pnAtendimento
       and t.cd_reg_amb is not null
       and pvTpConta        = 'A';
  --
  -- pda 224554 - fim
  --
  cursor cGuiaInternacao is    -- fica
    -- pda 211289 - 16/01/2008 - Thiago Miranda de Oliveira - considerar primeiro a guia da tela do faturamento
    select nr_guia
    from( select guia.nr_guia,
           '2' ordem -- pda 211289
      from dbamv.guia
     where guia.cd_atendimento = pnAtendimento
       and guia.tp_guia        = 'I'
       -- pda 217868 - 12/03/2008 - Amalia Araújo - validar se tem número, e não se está autorizada.
	   -- and guia.tp_situacao    = 'A'
       and guia.nr_guia        is not null
       -- pda 217868 - fim
    -- pda 211289 - adicionando outro select ao cursor
    union all
    --
    select guia.nr_guia,
           '1' ordem
      from dbamv.guia,
           dbamv.reg_fat
     where guia.cd_atendimento    = pnAtendimento
       and reg_fat.cd_atendimento = pnAtendimento
       and reg_fat.cd_reg_fat     = pnConta
       and guia.cd_atendimento    = reg_fat.cd_atendimento
       and guia.cd_guia           = reg_fat.cd_guia
       -- and guia.tp_situacao       = 'A'  -- pda 217868 - 12/03/2008 - Amalia Araújo - não validar isto
       and reg_fat.cd_guia        is not null
       and guia.nr_guia           is not null
     --
     order by ordem);
   -- fim pda 211289
  --
  -- pda 244040 - 12/08/2008 - Amalia Araújo
  -- Incluida condição com a variável vReutilizaNrGuia porque nestes convênios as guias
  -- ambulatoriais precisam ficar em ordem sem saltos, então a guia principal não pode
  -- pegar da guia de solicitação.
  cursor cGuiaAmbulatorio is
    select min(guia.cd_guia) cd_guia,
	       guia.nr_guia,
           null nr_guia_atend,
           '2' ordem  -- pda 211289 - 16/01/2008 adicionando coluna para ordem
      from dbamv.guia
     where guia.cd_atendimento = pnAtendimento
       and guia.tp_guia       in ('C','P')
       and guia.tp_situacao    = 'A'
       and guia.nr_guia       is not null
       and vReutilizaNrGuia is null                    -- pda 244040 - 12/08/2008
       -- pda 197195 - 09/11/2007 - Amalia Araújo - Esta condição não será mais verificada.
       /*
	   and exists( select it.cd_guia from dbamv.itreg_amb it
	                where it.cd_atendimento = pnAtendimento
					  and it.cd_reg_amb     = pnConta
					  and nvl( it.tp_pagamento, 'P' ) <> 'C'
					  and it.cd_guia        = guia.cd_guia )
	   */
	   -- pda 197195 - fim
   -- pda 207690 - 22/11/2007 - Thiago Miranda de Oliveira - criando condição
	   and not exists( select it.cd_guia
                     from dbamv.itreg_amb it,
                          dbamv.atendime a
	                where it.cd_atendimento = pnAtendimento
					  and it.cd_reg_amb     = pnConta
                      and a.cd_atendimento  = pnAtendimento
                      and a.cd_atendimento  = it.cd_atendimento
                      -- pda - 208925 - Thiago Miranda de Oliveira colocando mais uma condição para copnsiderar o credenciado ou cd_pro_int
					  and (
                           (it.cd_pro_fat  <> nvl(a.cd_pro_int,'XXX') and nvl( it.tp_pagamento, 'P' ) <> 'C') -- PDA.: 238453 - 29/07/2008 - Emanoel Deivison
                          or
                           (nvl( it.tp_pagamento, 'P' ) = 'C')
                          )
                      -- fim pda 208925
					  and it.cd_guia        = guia.cd_guia )
	   -- pda 207690 - fim
	 group by guia.nr_guia
    -- pda 211289 - 16/01/2008 - Thiago Miranda de Oliveira - considerar primeiro a guia que tem na tela de faturamento
    union all
    --
    select guia.cd_guia,
           null nr_guia,
           guia.nr_guia nr_guia_atend,
           '1' ordem
      from dbamv.guia,
           dbamv.atendime
      where guia.cd_atendimento = pnAtendimento
        and guia.cd_atendimento = atendime.cd_atendimento
        and guia.nr_guia       is not null
        and guia.cd_guia        = atendime.cd_guia
        and vReutilizaNrGuia is null                    -- pda 244040 - 12/08/2008
    --
    order by ordem;
    -- fim pda 211289
    -- pda 244040 - fim
  --
  -- pda 207690 - 22/10/2007 - Thiago Miranda de Oliveira - criando cursor
  cursor cGuiaAmbEsp(pnCdGuia in number) is
    select guia.nr_guia
      from dbamv.guia
     where guia.cd_atendimento = pnAtendimento
       and guia.cd_guia        = pnCdGuia
       and guia.tp_guia       in ('C','P')
       and guia.tp_situacao    = 'A'
       and guia.nr_guia       is not null;

  cursor cGuiaEspecifica( pnCdGuia in number ) is
    select guia.nr_guia
      from dbamv.guia
     where guia.cd_guia = pnCdGuia
       and guia.nr_guia is not null;
  --
  cursor cTamanhoFaixa( pnEmpresa in number,
                        pnConvenio in number,
                        pvTpGuia in varchar2 ) is
    select faixa.nr_tamanho_fixo nr_tamanho_fixo
      from dbamv.faixa_guia_convenio faixa
     where faixa.cd_multi_empresa = pnEmpresa
       and faixa.cd_convenio      = pnConvenio
       and (   ( pvTpGuia in ('I','SI')  and nvl( faixa.tp_guia, 'T' ) in ('I','U','T') )
            or ( pvTpGuia in ('C','SS')  and nvl( faixa.tp_guia, 'T' ) in ('S','E','U','T') )
            or ( pvTpGuia in ('CO')      and nvl( faixa.tp_guia, 'T' ) in ('C','G','T') )
            or ( pvTpGuia in ('SP')      and nvl( faixa.tp_guia, 'T' ) in ('E','G','T') )
            or ( pvTpGuia in ('RI','HI') and nvl( faixa.tp_guia, 'T' ) in ('G','T') ) )
       and rownum = 1;
  --
  cursor cLegado is
  -- pda 211289 - colocando tudo dentro de um unico select para so considerar as que realmente tiverem guias
  select nr_guia from (
    select min(tiss_nr_guia.nr_guia) nr_guia
      from dbamv.tiss_nr_guia,
           dbamv.reg_fat
     where tiss_nr_guia.cd_atendimento = pnAtendimento
       and reg_fat.cd_atendimento      = tiss_nr_guia.cd_atendimento
       and tiss_nr_guia.cd_reg_fat     = pnConta
       and tiss_nr_guia.tp_guia        = 'RI'
	   and reg_fat.nr_guia_envio_principal is null
       and pvTpConta = 'H'
    union all
    select min(tiss_nr_guia.nr_guia) nr_guia
      from dbamv.tiss_nr_guia,
           dbamv.atendime
     where tiss_nr_guia.cd_atendimento = pnAtendimento
       and atendime.cd_atendimento     = tiss_nr_guia.cd_atendimento
       and tiss_nr_guia.cd_reg_amb     = pnConta
       and tiss_nr_guia.tp_guia        = 'SP'
       and nvl(tiss_nr_guia.tp_pagamento,'P') = 'P'
	   and atendime.nr_guia_envio_principal is null
       and pvTpConta = 'A'
    union all
    -- pda 211289 - 24/01/2007 - Thiago Miranda de Oliveira - qunado atualizei o pacote não esta pegando a guia de consulta no legado
    select min(tiss_nr_guia.nr_guia) nr_guia
      from dbamv.tiss_nr_guia,
           dbamv.atendime
     where tiss_nr_guia.cd_atendimento = pnAtendimento
       and atendime.cd_atendimento     = tiss_nr_guia.cd_atendimento
       and tiss_nr_guia.tp_guia        = 'CO'
	   and atendime.nr_guia_envio_principal is null
       and pvTpConta = 'A'
    ) guia
   where nr_guia is not null;
  --
  cursor cQtdItens is
    select count(itreg_amb.cd_pro_fat) qt_itens
      from dbamv.itreg_amb
     where itreg_amb.cd_atendimento = pnAtendimento
       and itreg_amb.cd_reg_amb     = pnConta
	   and nvl( itreg_amb.sn_pertence_pacote, 'N' ) = 'N'
       and nvl( itreg_amb.sn_paciente_paga  ,'N') = 'N';
  -- 208925 - Thiago Miranda de Oliveira - criando cursor para pegar os dados da remessa
  cursor cDadosRemessa(pnCdRemessa in number) is
    select to_char(dt_fechamento,'yyyy/mm/dd hh24:mi:ss') dt_fechamento
         , sn_fechada
      from dbamv.remessa_fatura
      where cd_remessa = pnCdRemessa;
  -- 208925 - Thiago Miranda de Oliveira - criando cursor para pegar os dados da tebela de configuração
  cursor cConfiguracao is
   select valor
    from dbamv.configuracao
   where upper(cd_sistema) = 'FFCV'
     and upper(chave)      = 'DH_PKG_FFCV_TISS_AUX';
  --
  --PDA 221485(INICIO) 18/03/2008 - Jansen Gallindo
  Cursor cHospital is
   select cd_hospital
    from dbamv.hospital
   where cd_multi_empresa = dbamv.pkg_mv2000.le_empresa;
  --PDA 221485(FIM) 18/03/2008 - Jansen Gallindo
  --
  -- pda 226291 - 25/04/2008 - Amalia Araújo - Incluindo a coluna da conta-pai
  -- pda 222774 - 27/03/2008 - Amalia Araújo
  -- Estes três cursores serão utilizados para corrigir a NR_GUIA_PRINCIPAL no cliente 719, que em alguns casos
  -- ainda não identificados, está ficando nula.
  cursor cGuiaLimpa( pnAtend in number ) is
    select * from (
      select distinct t.cd_atendimento, t.cd_reg_fat, t.nr_guia, t.tp_guia,
	                  t.cd_multi_empresa, t.nr_guia_principal, r.cd_conta_pai
        from dbamv.tiss_nr_guia t, dbamv.reg_fat r
       where t.cd_reg_fat is not null
         and r.cd_reg_fat = t.cd_reg_fat
         and exists( select t1.cd_reg_fat from dbamv.tiss_nr_guia t1
                      where t1.cd_atendimento = t.cd_atendimento
                        and t1.nr_guia_principal is not null )
         and exists( select t2.cd_reg_fat from dbamv.tiss_nr_guia t2
                      where t2.cd_atendimento = t.cd_atendimento
                        and t2.nr_guia_principal is null )
         and t.cd_atendimento = pnAtend
        )
       where nr_guia_principal is not null;
  --
  cursor cGuiaLimpa_2( pnAtend in number ) is
    select * from (
      select distinct t.cd_atendimento, t.cd_reg_fat, t.nr_guia, t.tp_guia, t.cd_multi_empresa, t.nr_guia_principal
        from dbamv.tiss_nr_guia t
       where t.cd_reg_fat is not null
         and not exists( select t1.cd_reg_fat from dbamv.tiss_nr_guia t1
                      where t1.cd_atendimento = t.cd_atendimento
                        and t1.nr_guia_principal is not null )
         and exists( select t2.cd_reg_fat from dbamv.tiss_nr_guia t2
                      where t2.cd_atendimento = t.cd_atendimento
                        and t2.nr_guia_principal is null )
         and t.cd_atendimento = pnAtend
        );
  --
  cursor cGuiaPrinc( pnAtend in number ) is
    select nr_guia_envio_principal from dbamv.atendime where cd_atendimento = pnAtend;
  -- pda 222774 - fim
  --
  -- pda 222774 - 31/03/2008 - Amalia Araújo
  cursor cAtendDuplic( pnAtendimento in number ) is
    select t.cd_atendimento, t.cd_reg_fat, t.cd_reg_amb, t.tp_guia,
           t.cd_pro_fat, t.cd_prestador, t.tp_pagamento, count(t.nr_guia) qt_guias
      from dbamv.tiss_nr_guia t
     where tp_guia = 'SP' and cd_pro_fat is not null
       and cd_atendimento = pnAtendimento
     group by cd_atendimento, cd_reg_fat, cd_reg_amb, tp_guia, cd_pro_fat, cd_prestador, tp_pagamento
     having count(nr_guia) > 1;
  --
  cursor cGuiaDuplic( pnAtend in number, pvProFat in varchar2, pnPrest in number ) is
    select nr_guia, nr_folha, nr_linha
      from dbamv.tiss_nr_guia
     where cd_atendimento = pnAtend
       and tp_guia        = 'SP'
       and cd_pro_fat     = pvProFat
       and cd_prestador   = pnPrest
       and nr_guia <> ( select min(t.nr_guia) nr_guia from dbamv.tiss_nr_guia t
                         where t.cd_atendimento = tiss_nr_guia.cd_atendimento
                           and t.tp_guia        = tiss_nr_guia.tp_guia
                           and t.cd_pro_fat     = tiss_nr_guia.cd_pro_fat
                           and t.cd_prestador   = tiss_nr_guia.cd_prestador )
     order by nr_guia desc, nr_linha;
  --
  cursor cAtendDuplicHI( pnAtendimento in number ) is
    select t.cd_atendimento, t.cd_reg_fat, t.cd_reg_amb, t.tp_guia,
           t.cd_pro_fat, t.cd_prestador, t.dt_lancamento, t.cd_ati_med,
           nvl(t.tp_pagamento,'P') tp_pagamento,
           t.vl_percentual_multipla,                       -- pda 224554 - 15/04/2008
           count(t.nr_guia) qt_guias
      from dbamv.tiss_nr_guia t
     where t.tp_guia = 'HI' and t.cd_pro_fat is not null
       and t.cd_atendimento = pnAtendimento
     group by t.cd_atendimento, t.cd_reg_fat, t.cd_reg_amb, t.tp_guia,
	          t.cd_pro_fat, t.cd_prestador, t.dt_lancamento, t.cd_ati_med,
              nvl(t.tp_pagamento,'P'),
              t.vl_percentual_multipla                     -- pda 224554 - 15/04/2008
     having count(nr_guia) > 1;
  --
  cursor cGuiaDuplicHI( pnAtend in number, pvProFat in varchar2, pnPrest in number,
                        pdDtLanc in date, pvAtiMed in varchar2,
                        pnPercent in number                -- pda 224554 - 15/04/2008
                         ) is
    select nr_guia, nr_folha, nr_linha
      from dbamv.tiss_nr_guia
     where cd_atendimento = pnAtend
       and tp_guia        = 'HI'
       and cd_pro_fat     = pvProFat
       and cd_prestador   = pnPrest
       and cd_ati_med     = pvAtiMed
       and nvl(vl_percentual_multipla,100) = nvl(pnPercent,100)  -- pda 224554 - 15/04/2008
       and trunc(dt_lancamento) = trunc(pdDtLanc)
       and nr_guia <> ( select min(t.nr_guia) nr_guia from dbamv.tiss_nr_guia t
                         where t.cd_atendimento = tiss_nr_guia.cd_atendimento
                           and t.tp_guia        = tiss_nr_guia.tp_guia
                           and t.cd_pro_fat     = tiss_nr_guia.cd_pro_fat
                           and t.cd_prestador   = tiss_nr_guia.cd_prestador
                           and trunc(t.dt_lancamento) = trunc(tiss_nr_guia.dt_lancamento)
                           and nvl(t.vl_percentual_multipla,100) = nvl(tiss_nr_guia.vl_percentual_multipla,100)  -- pda 224554
                           and t.cd_ati_med     = tiss_nr_guia.cd_ati_med     )
     order by nr_guia desc, nr_linha;
  -- pda 222774 - fim
  --
  -- pda 222774 - 27/03/2008 - Amalia Araújo - Verificar se o atendimento não tem tiss_nr_guia (nenhum)
  cursor cNaoTemTiss is
    select t.cd_atendimento from dbamv.tiss_nr_guia t
     where t.cd_atendimento = pnAtendimento
       and pvTpConta        = 'H'
    union all
    select t.cd_atendimento from dbamv.tiss_nr_guia t
     where t.cd_atendimento = pnAtendimento
       and t.cd_reg_amb     = pnConta
       and pvTpConta        = 'A';
  -- pda 222774 - fim
  --
  -- pda 222774 - 02/04/2008 - Amalia Araújo
  -- Identifica prestadores divergentes nas guias de SP hospitalar
  cursor cPrestDif is
    select t.cd_atendimento, t.cd_reg_fat, t.nr_guia, t.cd_pro_fat, t.cd_prestador, i.cd_prestador cd_prestador_conta
      from dbamv.tiss_nr_guia t, dbamv.itreg_fat i
     where t.tp_guia = 'SP'
       and t.cd_atendimento = pnAtendimento
       and t.cd_reg_fat = i.cd_reg_fat
       and t.nr_guia    = i.nr_guia_envio
       and t.cd_pro_fat = i.cd_pro_fat
       and to_number(substr(lpad(t.cd_prestador, 10, '0'),1,6)) <> i.cd_prestador;
  -- pda 222774 - fim
  --
  -- pda 224310 - 09/04/2008 - Amalia Araújo
  -- Identifica atendimento ambulatorial com lote divergente na tiss_nr_guia,
  -- mas somente se for do mesmo convênio.
  cursor cLoteAmb is
    select tiss.cd_atendimento
      from dbamv.tiss_nr_guia tiss,
           dbamv.reg_amb      reg1,
           dbamv.reg_amb      reg2
     where tiss.cd_atendimento = pnAtendimento
       and tiss.cd_reg_amb    <> pnConta
       and reg1.cd_reg_amb     = pnConta
       and reg2.cd_reg_amb     = tiss.cd_reg_amb
       and reg1.cd_convenio    = reg2.cd_convenio
       and tiss.cd_reg_amb is not null;
  -- pda 224310 - fim
  --
  -- pda 249143 - 15/09/2008 - cursor que identifica guias da conta de complemento
  cursor cComplemento719( pnAtend in number, pnCta in number ) is
  select tiss_nr_guia.cd_atendimento, tiss_nr_guia.cd_reg_fat,
         count(tiss_nr_guia.tp_guia) qt_reg
    from dbamv.tiss_nr_guia
   where tiss_nr_guia.cd_atendimento = pnAtend
     and tiss_nr_guia.cd_reg_fat in ( select rg.cd_reg_fat from dbamv.reg_fat rg
                                       where rg.cd_conta_pai = pnCta ) -- 23/09/2008 - 06/10/2008
     and tiss_nr_guia.tp_guia = 'RI'
     and tiss_nr_guia.cd_multi_empresa in (4,5)
     and nvl(tiss_nr_guia.cd_pro_fat,'0') <> '0'
     and tiss_nr_guia.cd_prestador is not NULL
     and not exists ( select 'X' from dbamv.itreg_fat itf, dbamv.pro_fat pf, dbamv.gru_pro gp
                      where itf.cd_reg_fat in (select rf.cd_reg_fat from dbamv.reg_fat rf
                                               where nvl(rf.cd_conta_pai,rf.cd_reg_fat) = pnCta)
                            and pf.cd_pro_fat = itf.cd_pro_fat
                            and gp.cd_gru_pro = pf.cd_gru_pro
                            and gp.tp_gru_pro not in ('SP','SD') ) -- 04/02/2009 - Marin - não pode ter outro tipo de item
     and not exists ( select t.cd_atendimento from dbamv.tiss_nr_guia t
                       where t.cd_atendimento = tiss_nr_guia.cd_atendimento
                         and t.cd_reg_fat     = tiss_nr_guia.cd_reg_fat      -- 23/09/2008
                         and t.cd_reg_fat in ( select r.cd_reg_fat from dbamv.reg_fat r
                                                where r.cd_atendimento = t.cd_atendimento
                                                  and (r.cd_reg_fat = t.cd_reg_fat or r.cd_conta_pai = t.cd_reg_fat ) )
                         and t.cd_multi_empresa not in (4,5) ) --and t.tp_guia <> 'RI' ) -- 23/09/2008
   group by tiss_nr_guia.cd_atendimento, tiss_nr_guia.cd_reg_fat;
  -- pda 249143 - fim
  -- pda 239133
  cursor cTipoGeracaoImpressao(pnConvenio in number, pnAtend in number) is
    select 'S' gerar
      from dbamv.tiss_conv_impressao_guia imp
         , dbamv.convenio_conf_tiss conf
         , dbamv.atendime a
     where conf.cd_convenio = pnConvenio
       and conf.sn_somente_xml = 'S'
       and conf.cd_convenio = imp.cd_convenio
       and a.cd_atendimento = pnAtend
       and a.tp_atendimento = imp.tp_atendimento;
  -- fim pda 239133
  --
  -- pda 284024 - 28/04/2009 - Amalia Araújo - Cursor para identificar a regra de recém-nascido.
  cursor cRecemNascido is
        select atendime.cd_atendimento,
               atendime.cd_convenio,
               atendime.sn_recem_nato,
               atendime.cd_leito,
               unid_int.cd_unid_int,
               unid_int.cd_setor
          from dbamv.atendime,
               dbamv.leito,
               dbamv.unid_int,
               dbamv.regra_pro_fat_empresa regra
         where atendime.cd_atendimento         = pnAtendimento
           and nvl(atendime.sn_recem_nato,'N') = 'S'
           and leito.cd_leito                  = atendime.cd_leito
           and unid_int.cd_unid_int            = leito.cd_unid_int
           and regra.cd_multi_empresa_origem   = dbamv.pkg_mv2000.le_empresa
           and regra.cd_convenio               = atendime.cd_convenio
           and nvl(regra.cd_setor,0)           = unid_int.cd_setor
           and nvl(regra.sn_rn,'N')            = 'S';
  -- pda 284024 - fim
  --
  vHosp dbamv.hospital.cd_hospital%type; --PDA 221485
  vcGuiaAmbulatorio			cGuiaAmbulatorio%rowtype;
  vcGuiaAmbEsp			    cGuiaAmbEsp%rowtype; -- pda 207690
  vcRecemNascido            cRecemNascido%rowtype;   -- pda 274056
  --
  nCdConvenio               dbamv.convenio.cd_convenio%type;
  nCdMultiEmpresa           dbamv.tiss_nr_guia.cd_multi_empresa%type;
  cTpGuia                   dbamv.tiss_nr_guia.tp_guia%type;
  nEmpresa                  dbamv.multi_empresas.cd_multi_empresa%type;  -- pda 274056
  --
  cTpQuebraResint           varchar2(01);
  vSnFechada                varchar2(01);
  vTpPagamento              varchar2(01);
  vTpConta                  varchar2(01);
  vTpGuiaTiss               varchar2(02);
  vCdAtiMed                 varchar2(05);
  /*vProFat                   varchar2(08);  PDA 287537 */
  vProFat                   DBAMV.TISS_NR_GUIA.CD_PRO_FAT%TYPE:= NULL;
  /*auxcdprofat               varchar2(08)   := null;  PDA 287537 */
  auxcdprofat               DBAMV.TISS_NR_GUIA.CD_PRO_FAT%TYPE:= NULL;/*PDA 287537 */
  auxcdatimed               varchar2(08)   := null;
  auxVlPercMult             number; /* PDA.: 266927 - 09/01/2009 - Emanoel Deivison */
  auxcdregfat               dbamv.reg_fat.cd_reg_fat%type := null;   -- pda 217868 - 12/03/2008 - Amalia Araújo
  auxContratado             varchar2(100);
  auxGuiaConta              varchar2(100)  := null;
  vDtLancamento             varchar2(10);
  vNrGuia                   varchar2(100);
  vNrGuiaValidacao          varchar2(100);
  vNrGuiaPrincipal          varchar2(100);
  vNrGuiaEspecifica         varchar2(100) := null;
  vNrGuiaLegado             varchar2(100);
  vNrGuiaUsada              varchar2(10000);  -- pda 219362 - 29/02/2008 - Amalia Araújo - de 2000 para 4000.--pda 234105 - 13-06-2008 - Francisco Morais
  vNrGuiaZerada             varchar2(100);
  vCdContratado             varchar2(100);
  vMsgErro                  varchar2(2000) := null;
  vChave                    varchar2(2000) := 'X';
  vTpConvenio               varchar2(01); 					-- pda 206077
  vTpTotalizaResInt         varchar2(01); -- PDA 198883
  auxTpPagamento            varchar2(01); 					-->> Pda: 208700
  vPrestExecutante          varchar2(10) := null;           -- pda 209472 (**)
  vPrestSolicitante         varchar2(10) := null;           -- pda 209472 (**)
  --
  auxdtlancamento           date := null;
  --
  nFolha                    number := 1;
  nequipe                   number := 0;
  nregistro                 number := 0;
  nopme                     number := 0;
  nprimeiroopme             number := 0;
  nfolhainicioopme          number := 0;
  nPercentualMultipla       number(6,2);
  nQtItensGuiaHI            number(02);
  nQtItens                  number(04);
  Numeracao                 Number := 0;
  auxcdprestador_exe        number := null;
  auxcdprestador_sol        number := null;
  nAuxOrdem                 number := 0;
  nPrestador                number;
  nTamanhoFaixa             number(30);
  nTemTiss                  number(38) := null;				-- pda 205536
  --
  bPrimeiroRegistro         boolean := true;
  bEntrou                   boolean := false;
  bGuiaEspecifica           boolean := false;
  bProcessa                 boolean := false;    -- pda 224554 - 17/04/2008
  --
  --auxNrGuia               number;        -- PDA 207212 Inicio/fim
  auxNrGuia                 varchar2(100); -- PDA 207212 Inicio/fim
  nCdRemessa                number; --tmdo
  vValorConfig              varchar2(100); -- 208925
  vDtRemessa                varchar2(100); -- 208925
  vSnRemessaFechada         varchar2(2);
  Auxnregistro              number := 0;  -- 209459 - 07/12/2007 - criando variavel
  auxNumero                 varchar2(100); -- PDA 210550
  auxvlpercentual           dbamv.tiss_nr_guia.vl_percentual_multipla%type;   -- pda 211223
  auxQtdRegistros           number; 								-- pda 214757
  nNaoTemTiss               number;      							-- pda 222774 - 27/03/2008
  vNrGuiaLimpa              varchar2(100);          				-- pda 222774 - 27/03/2008
  nAtendAmbu                dbamv.atendime.cd_atendimento%type;		-- pda 224310 - 09/04/2008 - Amalia Araújo
  nContaCerta               number;   								-- pda 224554
  vcConta					dbamv.pkg_ffcv_tiss_aux.cConta%rowtype;	-- pda 226051 - 24/04/2008
  auxSnHorario              varchar2(1):= 'X';  					-- pda 221861 - pda 236232 (='X')
  auxdtlanc                 date;                                   -- pda 236232 - 11/07/2008
  auxOrdemNatureza          varchar2(1); -- pda 248374
  -- pda 239133
  vGeraImpressao           varchar2(1) := null;
  nfolhaAmb                number := 0;
  -- fim pda 239133
  --
  vNrGuiaPrinc         varchar2(100);          --pda 271551 - 04/02/2009 - Francisco Morais
  vPrestadorPrincExe   varchar2(10) := null;   --pda 271551 - 04/02/2009 - Francisco Morais
  vPrestadorPrincSol   varchar2(10) := null;   --pda 271551 - 04/02/2009 - Francisco Morais
  --auxCdLAncAgrup       number;                 --PDA 284066
  --
Begin
  --
  /* pda 284313 */
  /*vMsgErro := dbamv.pkg_ffcv_tiss_pii.fnc_sincro_pda ('284313','PKG_FFCV_TISS_AUX','S',NULL);
  if vMsgErro <> 'OK' then
    return vMsgErro;
  end if;*/


  -- pda 206077 - 09/11/2007 - Amalia Araújo - Não processar se TP_CONVENIO <> 'C'
  -- Obter dados auxiliares fixos como os parâmetros do convênio (cursor 'cConvenio').
  Open  cConvenio( pnAtendimento, pnConta, pvTpConta );
  Fetch cConvenio into nCdConvenio, cTpQuebraResint, nCdMultiEmpresa, vTpConvenio, vTpTotalizaResInt; -- PDA 198883
  if cConvenio%notfound then
    pvMsgErro := 'Atenção: Convênio não configurado para trabalhar com o TISS.';
    return 'OK';
  end if;
  Close cConvenio;
  --
  if vTpConvenio <> 'C' then
    pvMsgErro := 'Atenção: Convênio não é do tipo C.';
    return 'OK';
  end if;
  -- pda 206077 - fim
  --
  -- pda 226291 - 25/04/2008 - Amalia Araújo - Trazendo estes cursores cá para cima.
  --
  -- Verificando se a conta está fechada, porque em conta fechada esta função não será processada.
  vSnFechada := null;
  nCdRemessa := null; -- pda 208925 - setando parametro como null
  --
  -- 208925 Thiago Miranda de Oliveira - colocando mais um parametro para retornar o cd_remessa
  open  cContaFechada;
  fetch cContaFechada into vSnFechada, nCdRemessa;
  close cContaFechada;
  --
  -- 208925 Thiago Miranda de Oliveira - abrindo cursor para pegar os dados da configuracao
  open cConfiguracao;
  fetch cConfiguracao into vValorConfig;
  close cConfiguracao;
  --
  -- 208925 Thiago Miranda de Oliveira - abrindo cursor para pegar os dados da remessa
  open cDadosRemessa(nCdRemessa);
  fetch cDadosRemessa into vDtRemessa, vSnRemessaFechada;
  close cDadosRemessa;
  --
  -- pda 226291 - fim
  --
  -- pda 222774 - 31/03/2008 - Amalia Araújo
  if dbamv.pkg_mv2000.le_cliente = 719 then
    --
    -- pda 226291 - 25/04/2008 - Ainda ocorreram casos de ficar a nr_guia_principal nula em alguns registros.
    -- Encontra e corrige atendimentos onde há registros na TISS_NR_GUIA com e sem a guia principal informada.
    if pvTpConta = 'H' and nvl(vSnFechada,'N') = 'S' then
      for v in cGuiaLimpa( pnAtendimento ) loop
        update dbamv.tiss_nr_guia set nr_guia_principal = v.nr_guia_principal
         where cd_atendimento = v.cd_atendimento
           -- pda 226291 - 25/04/2008 - Amalia Araújo
           and ( cd_reg_fat = v.cd_reg_fat or
                 cd_reg_fat in ( select r.cd_reg_fat from dbamv.reg_fat r
                                  where r.cd_conta_pai = v.cd_reg_fat )
                )
           -- pda 226291 - fim
           and nr_guia_principal is null;
        --
        insert into dbamv.log_erro( id_log_erro, usuario, dt_erro, forms, ds_erro )
          values( dbamv.seq_log_erro.nextval, user, sysdate, dbamv.pkg_mv2000.le_formulario,
             'cGuiaLimpa 1 - atendimento:'||v.cd_atendimento||' - conta: '||v.cd_reg_fat
             ||' - conta pai:'||v.cd_conta_pai||' - nr_guia_principal:'||v.nr_guia_principal
               );
        --
      end loop;
    end if;
    -- pda 226291 - fim
    --
    -- QUando todos os registros estão sem a guia principal, pega a do atendimento
    /*
    for v in cGuiaLimpa_2( pnAtendimento ) loop
      --
      vNrGuiaLimpa := null;
      open  cGuiaPrinc( v.cd_atendimento );
      fetch cGuiaPrinc into vNrGuiaLimpa;
      close cGuiaPrinc;
      --
      update dbamv.tiss_nr_guia set nr_guia_principal = vNrGuiaLimpa
       where cd_atendimento = v.cd_atendimento
         and nr_guia_principal is null;
    end loop;
    */
    --
    /* pda 245420 - 21/08/2008 - Amalia Araújo - comentado porque deletou registros indevidamente
    -- Identifica registros duplicados na guia de SP e deixa apenas o primeiro registrado.
    for v in cAtendDuplic( pnAtendimento ) loop
      for v2 in cGuiaDuplic( v.cd_atendimento, v.cd_pro_fat, v.cd_prestador ) loop
        delete from dbamv.tiss_nr_guia
         where cd_atendimento = v.cd_atendimento and cd_pro_fat = v.cd_pro_fat
           and cd_prestador   = v.cd_prestador   and nr_guia    = v2.nr_guia    and nr_linha = v2.nr_linha;
      end loop;
    end loop;
    --
    for v in cAtendDuplicHI( pnAtendimento ) loop
      for v2 in cGuiaDuplicHI( v.cd_atendimento, v.cd_pro_fat, v.cd_prestador,
                               v.dt_lancamento, v.cd_ati_med,
                               v.vl_percentual_multipla            -- pda 224554
                             ) loop
        delete from dbamv.tiss_nr_guia
         where cd_atendimento = v.cd_atendimento and cd_pro_fat = v.cd_pro_fat
           and cd_prestador   = v.cd_prestador   and nr_guia    = v2.nr_guia
           and trunc(dt_lancamento) = trunc(v.dt_lancamento) and cd_ati_med     = v.cd_ati_med;
      end loop;
    end loop;
    pda 245420 - fim   */
    --
    /*
    -- Limpa tiss_nr_guia do atendimento ambulatorial caso haja algum registro com nr_guia nulo.
    update dbamv.tiss_nr_guia set nr_guia_principal=null
     where cd_atendimento = pnAtendimento and cd_reg_amb is not null
       and exists( select t.cd_atendimento from dbamv.tiss_nr_guia t
                    where t.cd_atendimento = pnAtendimento
                      and t.nr_guia is null                );
    */
	--
    /* PDA 290750 - 05/06/2009 - Francisco Morais
       Devido a implementacao do pda 284313 (aumento do campo prestador de 8 para 10 caracteres) foi modificado o substr
       de substr(lpad(cd_prestador,10,'0'),7,5) para substr(lpad(cd_prestador,10,'0'),5,6) ou seja ira pegar a partir do 5º
       caractere 6 casas.
    */
    -- Identifica e corrige os registros na tiss_nr_guia (SP internado) com prestador diferente do item da conta.
    for v in cPrestDif loop
      update dbamv.tiss_nr_guia set cd_prestador = v.cd_prestador_conta || substr(lpad(cd_prestador,10,'0'),5,6)
       where cd_atendimento = v.cd_atendimento and cd_reg_fat = v.cd_reg_fat
         and tp_guia = 'SP' and cd_pro_fat = v.cd_pro_fat and cd_prestador = v.cd_prestador;
    end loop;
    --
    open  cTissCerto;
    fetch cTissCerto into nContaCerta;
    if cTissCerto%notfound then
      open  cTissErrado;
      fetch cTissErrado into nContaCerta;
      if cTissErrado%found then
        insert into dbamv.log_erro( id_log_erro, usuario, dt_erro, forms, ds_erro )
          values( dbamv.seq_log_erro.nextval, user, sysdate, dbamv.pkg_mv2000.le_formulario,
                    'acerto lote - atendimento:'||pnAtendimento||' lote certo:'||pnConta
                    ||' - lote errado:'||nContaCerta
                 );
        update dbamv.tiss_nr_guia set cd_reg_amb = pnConta, nr_guia_principal = null
         where cd_atendimento = pnAtendimento and cd_reg_amb = nContaCerta;
      end if;
      close cTissErrado;
    end if;
    close cTissCerto;
    --
  end if;
  -- pda 222774 - fim
  --
  -- pda 224310 - 09/04/2008 - Amalia Araújo
  -- Identifica atendimento ambulatorial com lote divergente na tiss_nr_guia e limpa para reprocessar
  nAtendAmbu := null;
  if dbamv.pkg_mv2000.le_cliente = 719 then
    open  cLoteAmb;
    fetch cLoteAmb into nAtendAmbu;
    if cLoteAmb%found then
      update dbamv.tiss_nr_guia set cd_reg_amb = pnConta where cd_atendimento = pnAtendimento;
    end if;
    close cLoteAmb;
  end if;
  -- pda 224310 - fim
  --
  -- pda 222774 - 27/03/2008 - Amalia Araújo
  nTemTiss := null;
  open  cTemTiss;
  fetch cTemTiss into nTemTiss;
  close cTemTiss;
  /*
  nNaoTemTiss := null;
  open  cNaoTemTiss;
  fetch cNaoTemTiss into nNaoTemTiss;
  if cNaoTemTiss%found then
    -- pda 205536 - 29/10/2007 - Amalia Araújo - Verifica se tem registro na TISS_NR_GUIA
    if dbamv.pkg_mv2000.le_formulario = 'O_GERAARQMAG_TISS' then
      open  cTemTiss;
      fetch cTemTiss into nTemTiss;
      close cTemTiss;
    else
      nTemTiss := 999;
    end if;
    -- pda 205536 - fim
  end if;
  close cNaoTemTiss;
  */
  -- pda 222774 - fim
  --
  -- pda 224554 - 17/04/2008 - Amalia Araújo
  -- Rotina alterada. A conta somente será reprocessada depois de fechada nestes dois casos:
  --    1. se não existir nenhum registro na tabela tiss_nr_guia (ver cursor cTemTiss)
  --    2. se acusar divergência de valor pela tela de geração do XML, e somente estas contas com divergência
  if /*dbamv.pkg_mv2000.le_formulario = 'O_GERAARQMAG_TISS' and*/ nvl(nTemTiss,0) = 0 then
    bProcessa := true;
  else
    if nvl(vSnFechada,'N') <> 'S' then
      bProcessa := true;
    end if;
  end if;
  --
  -- pda 221585 - 25/03/2008 - Amalia Araújo - Acertando condições e colocando NVL onde necessário.
  -- Se a conta estiver fechada e não houver registro na TISS_NR_GUIA, deixa passar porque é legado de
  -- conta fechada que ainda não tinham sido criados os registros na tabela.
  -- pda 205536 - 29/10/2007 - Amalia Araújo - Incluida a condição da variável vTemTiss.
  if not bProcessa then
    --
    pvMsgErro := 'Atenção: Conta não processada (TISS).';
    return 'OK';
    --
  end if;
  -- pda 205536 - fim
  -- pda 221585 - fim
  -- pda 224554 - fim
  --
  vNrGuiaLegado := null;
  vNrGuiaUsada  := null;
  --
  -- pda 225224 - 28/04/2008 - Amalia Araújo - Inicializando variáveis
  dbamv.pkg_ffcv_tiss_aux.nIndexFaixa := 0;
  dbamv.pkg_ffcv_tiss_aux.aRegFaixa.delete;
  -- pda 225224 - fim
  --
  -- pda 226051 - 24/04/2008 - Amalia Araújo -- Cliente 719 não faz mais esta verificação.
  if dbamv.pkg_mv2000.le_cliente <> 719 then
  -- pda 226051 - fim
    -- Verificando se é Legado, para pegar o número da primeira guia de Resumo de Internação.
    open  cLegado;
    fetch cLegado into vNrGuiaLegado;
    close cLegado;
    if vNrGuiaLegado is not null then
      --
      update dbamv.atendime set nr_guia_envio_principal = vNrGuiaLegado
  	   where cd_atendimento = pnAtendimento and nr_guia_envio_principal is null;
  	  --
	  if pvTpConta = 'H' then
        update dbamv.reg_fat set nr_guia_envio_principal = vNrGuiaLegado
         where cd_reg_fat = pnConta;
  	  end if;
	  --
    end if;
  end if;
  --
  -- Limpa variáveis globais que guardam as guias de Sp e HI hospitalares, se estiverem sem itens (cd_pro_fat='0') - 16/10/2007
  vgGuiaPrincipalHI := null;
  vgGuiaPrincipalSP := null;
  --
  -- pda 226051 - 24/04/2008 - Amalia Araújo
  -- No hospital Santa Joana (719), por causa da forma de impressão da GRD do convênio Bradesco, a numeração das
  -- guias de cada atendimento, por tipo de guia, não podem ficar saltadas, para agilizar o processo de envio das
  -- guias impressas ao convênio, que precisam ir na mesma ordem da GRD (ordenada pela numeração das guias).
  -- Por causa disto, foi criado o parâmetro CD_CONV_NAO_REUTILIZA_GUIA_TISS que guarda os códigos dos convênios
  -- que não vão limpar a faixa de guias para reutilizar. Por enquanto este processo será apenas para o cliente 719.
  -- Também não aproveita a numeração das guias em branco impressas no atendimento.
  --
  vReutilizaNrGuia := null;
  --
  if dbamv.pkg_mv2000.le_cliente = 719 then
    --
    open  dbamv.pkg_ffcv_tiss_aux.cConta( pnConta, pvTpConta );
    fetch dbamv.pkg_ffcv_tiss_aux.cConta into vcConta;
    if dbamv.pkg_ffcv_tiss_aux.cConta%found then
      --
      open  cReutilizaNrGuia( vcConta.cd_convenio, vcConta.cd_multi_empresa );
      fetch cReutilizaNrGuia into vReutilizaNrGuia;   -- variável será utilizada mais abaixo, na faixa de guias.
      close cReutilizaNrGuia;
      --
      if vReutilizaNrGuia is not null then
        insert into dbamv.log_erro( id_log_erro, usuario, dt_erro, forms, ds_erro )
          values( dbamv.seq_log_erro.nextval, user, sysdate, dbamv.pkg_mv2000.le_formulario,
                 'NAO REUTILIZOU FAIXA - atendimento:'||pnAtendimento||' conta:'||pnConta
                 ||' - convenio:'||vcConta.cd_convenio||' - pvTpConta:'||pvTpConta
                 ||' - empresa:'||vcConta.cd_multi_empresa
             );
      end if;
      --
    end if;
    close dbamv.pkg_ffcv_tiss_aux.cConta;
    --
  end if;
  -- pda 226051 - fim
  --
  -- Acionar a função DBAMV.PKG_FFCV_TISS.FNC_APAGA_GUIAS para apagar vestígios de gerações anteriores da tabela TISS_NR_GUIA.
  vMsgErro := dbamv.pkg_ffcv_tiss_aux.fnc_apaga_guias( pnAtendimento, pnConta, nCdConvenio, pvtpConta );
  if vMsgErro is not null then
    pvMsgErro := vMsgErro;
    return 'OK';
  end if;
  --
  -- Completa o dígito final se a variável tiver valor - 22/10/2007
  /* comentado pelo PDA 284020
  if vgGuiaPrincipalHI is not null then
    vgGuiaPrincipalHI := vgGuiaPrincipalHI ||'#';
  end if;
  if vgGuiaPrincipalSP is not null then
    vgGuiaPrincipalSP := vgGuiaPrincipalSP ||'#';
  end if;
  */
  --
  auxNumero := null; -- PDA 210550
  -- pda 239133
  open cTipoGeracaoImpressao(nCdConvenio, pnAtendimento);
  fetch cTipoGeracaoImpressao into vGeraImpressao;
  close cTipoGeracaoImpressao;
  -- fim pda 239133
  -- Para Contas Hospitalares
  -- Executar o cursor principal para classificar os procedimentos. Realizar o Loop principal sobre o cursor
  For vp In cItensGravaHosp Loop       -- Inicio 0H*
    --
    -- Tipo de guia baseado na coluna Ordem_Guia dos cursores:
    -- Hospitalar: 1 = Resumo de Internação (RI); 2 = Honorário Individual (HI); 3 = SP/Sadt (SP).
    if vp.ordem_guia = 1 then
      vTpGuiaTiss := 'RI';
    elsif vp.ordem_guia = 2 then
      vTpGuiaTiss := 'HI';
    elsif vp.ordem_guia = 3 then
      vTpGuiaTiss := 'SP';
    end if;
    --
    -- pda 217868 - 12/03/2008 - Amalia Araújo - tipo de guia diferenciado no cliente 719
    vTpGuiaTiss := nvl( vp.tp_guia_aux, vTpGuiaTiss );
    -- pda 217868 - fim
    --
    /* pda 284024 - 13/05/2009 - Amalia Araújo
       Se for regra de recém-nascido, gerar a guia de RI com a empresa 4.  */
    nEmpresa := vp.cd_multi_empresa;
    if dbamv.pkg_mv2000.le_cliente = 719 then
      open  cRecemNascido;
      fetch cRecemNascido into vcRecemNascido;
      if cRecemNascido%found then
        if vp.cd_ati_med = '06' then
          nEmpresa := 5;
        else
          nEmpresa := 4;
        end if;
      end if;
      close cRecemNascido;
    end if;
    --
    bEntrou       := true;
    vNrGuiaZerada := null;                              -- 22/10/2007
    -- Busca numeração da guia principal (só uma vez) e já pega a primeira guia de envio do atendimento.
    if vNrGuiaPrincipal is null then   -- Inicio 1*
      /* - Internações:
         - Pesquisar uma guia (tabela GUIA) do tipo ¿I¿ com status ¿Autorizada¿ referente ao atendimento em questão.
         - Se encontrar, Atribuir Guia Principal (aqui denominaremos vGuiaPrinc).
         - Se não encontrar uma guia deste tipo, o processo deverá interrompido com mensagem associativa
		  (ex: ¿Falta Guia de Autorização no Atendimento 99999'), pois o conceito TISS assim exige para que sejam
		  associadas as guias complementares.
      */
      --
      open  cGuiaInternacao;
      fetch cGuiaInternacao into vNrGuiaPrincipal;
      if cGuiaInternacao%notfound then
        close cGuiaInternacao;
        -- pda 217868 - 12/03/2008 - Amalia Araújo - ajuste na mensagem
        pvMsgErro := 'Erro: Guia da Conta/Internação do atendimento '||pnAtendimento||' não encontrada ou não autorizada!';
        -- pda 217868 - fim
        return 'ERRO';
      end if;
      close cGuiaInternacao;
      if vNrGuiaPrincipal is null then
        pvMsgErro := 'Erro: Guia da Conta/Internação do atendimento '||pnAtendimento||' sem número informado!';
        return 'ERRO';
      end if;
      --
      if vNrGuiaLegado is not null then
        vNrGuia       := vNrGuiaLegado;
        vNrGuiaLegado := null;
      else
        if bPrimeiroRegistro and vp.nr_guia_envio_principal is not null then
          vNrGuia := vp.nr_guia_envio_principal;
        else
          vNrGuia := dbamv.pkg_ffcv_guia.fnc_retornar_faixa_guias(nCdConvenio, 'RE', 'RI'||'@'||vp.cd_multi_empresa , sysdate, pvMsgErro);
          if pvMsgErro is not null then
            return 'ERRO';
          end if;
          --
          update dbamv.atendime set nr_guia_envio_principal = vNrGuia
		   where cd_atendimento = pnAtendimento and nr_guia_envio_principal is null;
          --
          -- pda 224532 - 11/04/2008 - Amalia Araújo - Gravando também nas contas filhas
		  update dbamv.reg_fat set nr_guia_envio_principal = vNrGuia
           where cd_reg_fat = pnConta
              or cd_reg_fat in ( select r.cd_reg_fat from dbamv.reg_fat r
                                  where r.cd_conta_pai = pnConta );
          -- pda 224532 - fim
		  --
        end if;
      end if;
      --
    end if;    -- Fim *1
    --
    -- Primeiro registro lido do cursor.    -- Inicio 2*
    -- Se for ORDEM <> 1, deverá ser gerado um registro virtual que será ORDEM=1 (procedimento = '0').
    if ( bPrimeiroRegistro and vp.ordem_guia <> 1 and
        ( dbamv.pkg_mv2000.le_cliente <> 719 or
          ( dbamv.pkg_mv2000.le_cliente = 719 and vp.cd_multi_empresa in (1,2) ) ) )
        or ( bPrimeiroRegistro and dbamv.pkg_mv2000.le_cliente = 719 and vp.cd_multi_empresa = 4 ) then  /* pda 284024 - 13/05/2009 */
      /* pda 284509 - Inserindo um LTRIM na variavel vNrGuiaPrincipal.*/
      insert into dbamv.tiss_nr_guia
           ( cd_atendimento, cd_reg_fat,
             tp_guia, nr_guia, cd_prestador, cd_pro_fat,
             dt_lancamento, cd_multi_empresa,
             nr_folha, nr_linha, cd_codigo_contratado,
             nr_guia_principal, cd_ati_med )
       values( pnAtendimento, pnConta,  --vp.cd_reg_fat,   /* pda 284024 - 13/05/2009 */
               'RI', LTRIM(vNrGuia), null, '0', -->> 210355 Adcionado LTRIM na variavel da Guia.
               null, nEmpresa,   --vp.cd_multi_empresa,
               1, 1, vp.cd_codigo_contratado,
               LTRIM(vNrGuiaPrincipal), NULL );
      --
      /* pda 284024 - fim */
      --
      bPrimeiroRegistro := false;
      --
    end if;    -- Fim *2
    --
    /* pda 284024 - 27/04/2009 - Amalia Araújo
       Se for regra de recém-nascido, gerar a guia de RI com a empresa 4.  */
    nEmpresa := vp.cd_multi_empresa;
    if dbamv.pkg_mv2000.le_cliente = 719 then
      open  cRecemNascido;
      fetch cRecemNascido into vcRecemNascido;
      if cRecemNascido%found then
        if vp.cd_ati_med = '06' then
          vTpGuiaTiss := 'HI';
        else
          vTpGuiaTiss := 'SP';
        end if;
      end if;
      close cRecemNascido;
    end if;
    --
    -- 25/10/2007 - Guia especifica para HI e SP.
    if vTpGuiaTiss in ( 'HI', 'SP' ) then
      --
      if vp.cd_guia_conta is not null then
        --
        open  cGuiaEspecifica( vp.cd_guia_conta );
        fetch cGuiaEspecifica into vNrGuiaEspecifica;
        close cGuiaEspecifica;
        --
        -- Se houver guia específica no procedimento, mas já foi registrada com outro prestador, não utiliza
        if vNrGuiaEspecifica is not null then
          --
          nTamanhoFaixa := null;
          open  cTamanhoFaixa( vp.cd_multi_empresa, nCdConvenio, vTpGuiaTiss );
          fetch cTamanhoFaixa into nTamanhoFaixa;
          close cTamanhoFaixa;
          if nvl(nTamanhoFaixa,0) > 0 and length(vNrGuiaEspecifica) < nvl(nTamanhoFaixa,0) then
            vNrGuiaEspecifica := lpad( vNrGuiaEspecifica, nTamanhoFaixa, '0' );
          end if;
          --
          if instr( nvl(vNrGuiaUsada,'#'), '#'||vNrGuiaEspecifica||'$' ) > 0 AND
          --
         /*pda 284313 - 30/04/2009 - Francisco Morais - referente ao aumento do codigo do prestador solicitante que passou de
                                     4 para 6 digitos, igual ao cliente 739.*/
		     instr( nvl(vNrGuiaUsada,'#'), '#'||vNrGuiaEspecifica||'$'||vp.cd_prestador_executante||lpad(vp.cd_prestador_solicitante,6,0) ) = 0 
			 and vp.cd_convenio <> 3 then -- 284066
            vNrGuiaEspecifica := 'X';
            bGuiaEspecifica   := false;
          else
            bGuiaEspecifica   := true;
          end if;
          --
          if vNrGuiaUsada is null then
            /*pda 284313 - 30/04/2009 - Francisco Morais - referente ao aumento do codigo do prestador solicitante que passou de
                                        4 para 6 digitos, igual ao cliente 739.*/
            vNrGuiaUsada := '#'||vNrGuiaEspecifica||'$'||vp.cd_prestador_executante||lpad(vp.cd_prestador_solicitante,6,0);
          else
            /*pda 284313 - 30/04/2009 - Francisco Morais - referente ao aumento do codigo do prestador solicitante que passou de
                                        4 para 6 digitos, igual ao cliente 739.*/
            vNrGuiaUsada := vNrGuiaUsada ||'#'||vNrGuiaEspecifica||'$'||vp.cd_prestador_executante||lpad(vp.cd_prestador_solicitante,6,0);
          end if;
          --
        end if;
        --
      else
        -- 25/10/2007 - Caso a guia anterior tenha sido específica, altera o valor da vNrGuia para forçar entrar no IF para buscar nova numeração.
        if bGuiaEspecifica then
         --Inicio pda 209197
         --vNrGuia := 'Y';
          vNrGuia := auxNrGuia;
         --Fim pda 209197

          vNrGuiaEspecifica := 'X';
        else
          vNrGuiaEspecifica := null;
        end if;
        --
        bGuiaEspecifica := false;
        --
      end if;
      --
    end if;
    -->> Tratamento para Contas de Resumo de Internação.
    if vTpGuiaTiss = 'RI' then            -->> Inicio 3*
      --
      -->> Esse trecho de Ifs foi feito baseado no campo Ordem do modelo anterior na query de contas de intermação.
      -->> Ordem 1 = Numeracao 1 / Ordem 2 = Numeracao 2 e assim por diante. Esses campos serão usados mais abaixo para quebra
      -->> de linhas e páginas.
      If ((vp.Tp_Geracao_Guia_Sadt = 'H' and vp.tp_gru_pro  = 'SD') or vp.tp_gru_pro = 'SP') And
         (vp.Tp_Pagamento <> 'C') Then
        If  vp.cd_itlan_med is Not Null Then
          Numeracao := 1;
        Else
          Numeracao := 2;
        End If;
      Elsif (vp.Tp_Pagamento <> 'C') And (vp.Tp_Gru_Pro = 'OP') Then
        Numeracao := 4;
      Elsif (vp.Tp_Pagamento <> 'C') Then
        Numeracao := 3;
        --
        -- pda 221585 - 17/03/2008 - Amalia Araújo
        if dbamv.pkg_mv2000.le_cliente = 719 then
          if vp.tp_gru_pro in ('SP','SD') And vp.Tp_Pagamento <> 'C' Then
            If vp.cd_itlan_med is Not Null Then
              Numeracao := 1;
            Else
              Numeracao := 2;
            End If;
          end if;
        end if;
        -- pda 221585 - fim
        --
      End If;
      --
      If ( trunc(auxdtlancamento) <> trunc(vp.dt_lancamento) or
           vp.cd_pro_fat <> auxcdprofat or
          ( nvl(auxContratado, 'XXX') <> nvl(vp.cd_codigo_contratado, 'XXX')) or -- PDA.: 238453 - 29/07/2008 - Emanoel Deivison
          --( auxSnHorario <> vp.sn_horario_especial ) or     -- pda 221861  -- pda 236232 (comentado)
          ( auxvlpercentual <> vp.vl_percentual_multipla ) or               -- pda 274846 - 02/03/2009 - Francisco Morais - Quebra por valor percentual multipla
          ( auxSnHorario <> nvl(vp.sn_horario_especial,'N') or auxdtlanc <> vp.Dt_Lancamento ) or  -- pda 236232
            ( Numeracao = 2 and nvl(vp.cd_prestador_executante,0) <> nvl(auxcdprestador_exe,0) )
		 ) and Numeracao <> 4  then
        -- PDA 209459 - 07/12/2007 - quando variável for nula pegar backup pois deve ter tido um opme antes deste item
        if nregistro is null then
          nregistro := Auxnregistro;
        end if;
        --  fim pda 209459
        nregistro := nregistro + 1;
      End If;
      --
      If nregistro = 0 and Numeracao <> 4 then
         nregistro := 1;
      End if;
      --
      if Numeracao = 4 and --vp.Tp_Gru_Pro = 'OP' and
	     ( trunc(auxdtlancamento) <> trunc(vp.dt_lancamento) or vp.cd_pro_fat <> auxcdprofat ) then
        nopme := nopme + 1;
      end if;
      --
      if numeracao <> 4 and vp.tp_gru_pro <> 'SD' then
        nequipe := nequipe + 1;
      end if;
      --
      If (Numeracao = 4)  And (nprimeiroopme = 0) Then
        nfolha := 1;
        nopme := 1;
        nprimeiroopme := 1;
        -- pda 209459 - guardando variável antes de setar como nula
        if nregistro is not null then
          Auxnregistro := nregistro;
        end if;
        -- pda 209459
        nregistro := null;
      End If;
      --
      if vp.sn_somente_xml = 'N' or nvl(vGeraImpressao, 'N') = 'S' then -- pda 239133
        If ( (nequipe > 20 or nregistro > 15) and Numeracao in (1,2) ) or
           ( Numeracao = 3 and nregistro > 15 ) or
           ( nvl(auxContratado, 'XXX') <> nvl(vp.cd_codigo_contratado, 'XXX')) or -- PDA.: 238453 - 29/07/2008 - Emanoel Deivison
           ( Numeracao = 4 and nopme > 5 ) then
           --
           If  cTpQuebraResint = 'G' and nvl(vGeraImpressao, 'N') = 'N' then -- pda 239133
             vNrGuia := null;
             If (vNrGuia is null and Numeracao = 4) or Numeracao <> 4 Then
               vNrGuia := dbamv.pkg_ffcv_guia.fnc_retornar_faixa_guias(nCdConvenio, 'RE', vTpGuiaTiss || '@' || vp.cd_multi_empresa , sysdate, pvMsgErro);
               if pvMsgErro is not null then
                 return 'ERRO';
               end if;
             End if;
           End if;
           --
           -- PDA.: 267254 - 08/01/2009 - Emanoel Deivison (inicio)
           -- If nvl(auxContratado, 'XXX') <> nvl(vp.cd_codigo_contratado, 'XXX') and nvl(vGeraImpressao, 'N') = 'N' Then  -- pda 239133
              If nvl(auxContratado, 'XXX') <> nvl(vp.cd_codigo_contratado, 'XXX') Then
           -- PDA.: 267254 - 08/01/2009 - Emanoel Deivison (fim)
             nfolha := 1;
             nregistro := 1;
             nequipe := 1;
             nopme := 1;
             vNrGuia := dbamv.pkg_ffcv_guia.fnc_retornar_faixa_guias(nCdConvenio, 'RE', vTpGuiaTiss || '@' || vp.cd_multi_empresa , sysdate, pvMsgErro);
             if pvMsgErro is not null then
               return 'ERRO';
             end if;
           Else
             nfolha := nfolha + 1;
             nregistro := 1;
             nequipe := 1;
             nopme := 1;
           End if;
        End If;
      end if; -- fim pda 214757
      --
      If Numeracao = 4 then
        -- pda 209459 - guardando variável antes de setar como nula
        if nregistro is not null then
          Auxnregistro := nregistro;
        end if;
        -- pda 209459
        nregistro := null;
      End if;
      --
      /* PDA 290184 - 02/06/2009 - Francisco Morais
         A quebra não pode acontecer se a configuração "Totalizar itens de resumo de Internação" estiver como "Em uma unica data",
         pois a conta pode ter o mesmo procedimento com datas diferentes e com isso sera gerada duas linhas na tiss_nr_guia e
         sera gerada uma divergencia de valores.
      */
      -- PDA 260978 - se existir configuração de agrupamento , só quebrar pela data se o tipo de quebra do agrupamento
      -- for pela data, pois pode estar configurado p/ agrupar pela conta , e nestes casos não se deve-se quebrar pela data
      -- PDA 284066 - retirando o trunc
      if ( (auxdtlancamento <> vp.dt_lancamento and nvl(vp.tp_agrup_opme,'D') = 'D' and vTpTotalizaResInt <> 'U' ) or
           vp.cd_pro_fat <> nvl(auxcdprofat,'X') or
          ( nvl(auxContratado, 'XXX') <> nvl(vp.cd_codigo_contratado, 'XXX')) or -- PDA.: 238453 - 29/07/2008 - Emanoel Deivison
          ( auxvlpercentual <> vp.vl_percentual_multipla ) or               -- pda 211223
          --( auxSnHorario <> vp.sn_horario_especial ) or                   -- pda 221861 - pda 236232 (comentado)
          ( auxSnHorario <> nvl(vp.sn_horario_especial,'N') ) or            -- pda 236232
          ( Numeracao in (1,2) and nvl(vp.cd_prestador_executante,0) <> nvl(auxcdprestador_exe,0) ) ) then
        --
        -- pda 206976 - Thiago Miranda de Oliveira - retirando verificação por que ja esta sendo feita no select do loop
        /*if vp.tp_gru_pro = 'SD' then
          nPrestador := 0;
        else*/
--        end if;
        /* PDA 284714 - se for natureza , não inserir prestador e considerar o tipo de pagamento credenciado*/
		if vp.sn_natureza = 'S' then
		   nPrestador := null;
		   vTpPagamento:= 'C';
	    else
		   nPrestador := vp.cd_prestador_executante;
		   vTpPagamento:= null;
		end if;

		/* pda 284509 - Inserindo um LTRIM na variavel vNrGuiaPrincipal.*/
   	    insert into dbamv.tiss_nr_guia
         ( cd_atendimento, cd_reg_fat, tp_guia, nr_guia, cd_prestador, cd_pro_fat,
		   dt_lancamento, cd_multi_empresa,
           nr_folha, nr_linha, cd_codigo_contratado,
		   nr_guia_principal, cd_ati_med, vl_percentual_multipla
           , sn_horario_especial /*pda 221861 - pda 236232 (ok)*/,tp_pagamento
           )
         values( pnAtendimento, vp.cd_reg_fat, vTpGuiaTiss, LTRIM(vNrGuia), nPrestador, vp.cd_pro_fat, -->> 210355 Adcionado LTRIM na variavel da Guia.
		         vp.dt_lancamento, nEmpresa,  --vp.cd_multi_empresa,
                 nFolha, nregistro, vp.cd_codigo_contratado,
				 LTRIM(vNrGuiaPrincipal), vp.cd_ati_med, vp.vl_percentual_multipla
                 , vp.sn_horario_especial/*pda 221861 - pda 236232 (ok)*/,vTpPagamento
                 );
        --
      end if;
	  --
    elsif vTpGuiaTiss = 'HI' then
      --
      -- pda 214757 - Thiago Miranda de Oliveira - alterando condição quando flag da configuraçãio estiver como sim
      if vp.sn_somente_xml = 'N' then
        auxQtdRegistros := 10;
      else
        auxQtdRegistros := 999999;
      end if;
      --
      /* pda 287644 - 20/05/09 - Francisco Morais - Inserido nvl's nos campos referente ao codigo do prestador.*/
      --
      if vp.ordem_guia              <> nAuxOrdem
         --or  nregistro > 10  or
         or  nregistro > auxQtdRegistros  or
         -- fim -da 214757
		 Nvl(vp.cd_prestador_executante,9999) <> Nvl(auxcdprestador_exe,9999) or
		 vp.cd_ati_med              <> auxcdatimed    or
		 vp.cd_reg_fat              <> auxcdregfat    or   -- pda 217868 - 12/03/2008 - Amalia Araújo
		 vp.cd_codigo_contratado    <> auxContratado  then
		--
        nregistro := 0;
        nfolha    := 0;
        --
        -- Usa a guia guardada na variável global, na primeira guia de HI (específico cliente 719)  - 22/10/2007
        /* PDA 284020
        if vgGuiaPrincipalHI = '#' then    -- 24/10/2007
          vgGuiaPrincipalHI := null;
        end if;
        */
        --
        if vgGuiaPrincipalHI is not null then
          vNrGuia           := substr( vgGuiaPrincipalHI, 1, instr(vgGuiaPrincipalHI,'#')-1); /* PDA 284020 */
          vNrGuiaZerada     := vNrGuia;
          vgGuiaPrincipalHI := substr( vgGuiaPrincipalHI, instr(vgGuiaPrincipalHI,'#')+1, 100 ); /* PDA 284020 */
        else                                                                                       -- 16/10/2007 - fim
          if vNrGuiaEspecifica is null or vNrGuiaEspecifica = 'X' then
            vNrGuia := dbamv.pkg_ffcv_guia.fnc_retornar_faixa_guias( nCdConvenio, 'RE', vTpGuiaTiss||'@'||vp.cd_multi_empresa, sysdate, pvMsgErro);
            vNrGuiaZerada := null;
            if pvMsgErro is not null then
              return 'ERRO';
            end if;
          else
            vNrGuia := vNrGuiaEspecifica;
            vNrGuiaZerada := null;
          end if;
        end if;
        --
        -- pda 221258 - 13/03/2008 - Amalia Araújo - se a filha for igual à principal, pegar nova faixa
        if vNrGuia = vNrGuiaPrincipal then
          --
          vNrGuia := dbamv.pkg_ffcv_guia.fnc_retornar_faixa_guias( nCdConvenio, 'RE', vTpGuiaTiss||'@'||vp.cd_multi_empresa, sysdate, pvMsgErro);
          --
          -- pda 224554 - 15/04/2008 - Amalia Araújo
    	  update dbamv.reg_fat set nr_guia_envio_principal = vNrGuia
           where ( cd_reg_fat = pnConta or cd_conta_pai = pnConta )
             and nr_guia_envio_principal is null;
          -- pda 224554 - fim
          --
        end if;
        -- pda 221258 - fim
        --
        --
      end if;
      --
      /* pda 287644 - 20/05/09 - Francisco Morais - Inserido nvl's nos campos referente ao codigo do prestador.*/
      -- pda 217868 - 12/03/2008 - Amalia Araújo - para não duplicar registros
      if nvl(vp.cd_pro_fat,'X') <> nvl(auxcdprofat,'X') or
         Nvl(vp.cd_prestador_executante,9999)  <> Nvl(auxcdprestador_exe,9999) or
         vp.dt_lancamento  <> auxdtlancamento or
         --auxSnHorario <> vp.sn_horario_especial  or          -- pda 221861 - pda 236232 (comentado)
         auxSnHorario <> nvl(vp.sn_horario_especial,'N')  or   -- pda 236232
         auxvlpercentual <> vp.vl_percentual_multipla or       -- pda 224249 Renan Salvador
         vp.cd_ati_med  <> auxcdatimed then
      -- pda 217868 - fim
        --
        nregistro := nregistro + 1;
        /* pda 284509 - Inserindo um LTRIM na variavel vNrGuiaPrincipal.*/
        insert into dbamv.tiss_nr_guia
         ( cd_atendimento, cd_reg_fat, tp_guia, nr_guia, cd_prestador, cd_pro_fat,
		   dt_lancamento, cd_multi_empresa, nr_folha, nr_linha, cd_codigo_contratado,
		   nr_guia_principal, cd_ati_med, tp_pagamento,vl_percentual_multipla
           , sn_horario_especial  -- pda 221861 - pda 236232 (ok)
             )
         values( pnAtendimento, vp.cd_reg_fat, vTpGuiaTiss, ltrim(vNrGuia), vp.cd_prestador_executante, vp.cd_pro_fat, -->> 210355 Adcionado LTRIM na variavel da Guia.
		         vp.dt_lancamento, nEmpresa, nFolha, nregistro, vp.cd_codigo_contratado,
				 LTRIM(vNrGuiaPrincipal), vp.cd_ati_med, vp.tp_pagamento, vp.vl_percentual_multipla
                 , vp.sn_horario_especial  -- pda 221861 - pda 236232 (ok)
                 );
        --
      end if;
      --
      /* 22/10/2007 - Específico para o Santa Joana, que gera guais zeradas de SP e HI hospitalar na função
                      DBAMV.FNC_FFCV_GERA_TISS_719 que são deletadas neste momento, pois o número da guia foi
                      utilizado no insert acima. Este processo de deletar somente agora, e não na APAGA_GUIAS
                      é para não perder a guia em branco caso não haja nenhum procedimento para ela quando
                      esta função aqui for executada.                                                         */
      -- pda 221585 - 18/03/2008 - Amalia Araújo - Não estava deletando, causando divergência.
      /*
      if vNrGuia = vNrGuiaZerada then
        delete from dbamv.tiss_nr_guia
         where nr_guia = vNrGuiaZerada and cd_atendimento = pnAtendimento and cd_reg_fat = pnConta and nvl(cd_pro_fat,'0') = '0';
      end if;
      */
      delete from dbamv.tiss_nr_guia
       where cd_atendimento = pnAtendimento and nr_guia = vNrGuia and tp_guia = 'HI' and nvl(cd_pro_fat,'0') = '0';
      -- pda 221585 - fim
      --
    elsif vTpGuiaTiss = 'SP' then
      dbamv.prc_grava_log_erro('1','1','1','passou 1',14082009);
      --
      /* pda 287644 - 20/05/09 - Francisco Morais - Inserido nvl's nos campos referente ao codigo do prestador.*/
      if vp.ordem_guia               <> nAuxOrdem      or
         ( nregistro > 4 and
           ( nvl(vp.cd_pro_fat,'X') <> nvl(auxcdprofat,'X') or  -- pda 224532 - 11/04/2008 - Amalia Araújo
             nvl(auxdtlanc,trunc(sysdate)) <> nvl(vp.dt_lancamento,trunc(sysdate)) )  -- pda 236232 - 18/07/2008
          ) or
		 Nvl(vp.cd_prestador_executante,9999)  <> Nvl(auxcdprestador_exe,9999) or
		 Nvl(vp.cd_prestador_solicitante,9999) <> Nvl(auxcdprestador_sol,9999) or
		 vNrGuia                     <> nvl(vNrGuiaEspecifica,vNrGuia) or
		 vp.cd_codigo_contratado     <> auxContratado  then
		--
        nregistro := 0;
        nfolha    := 0;
        --
        -- Usa a guia guardada na variável global, na primeira guia de SP (específico cliente 719)  - 16/10/2007
        /* PDA 284020 - comentado
        if vgGuiaPrincipalSP = '#' then    -- 24/10/2007
          vgGuiaPrincipalSP := null;
        end if;
        */
        --
        if vgGuiaPrincipalSP is not null then
          vNrGuia           := substr( vgGuiaPrincipalSP, 1, instr(vgGuiaPrincipalSP,'#')-1); /* PDA 284020 */
          vNrGuiaZerada     := vNrGuia;
          vgGuiaPrincipalSP := substr( vgGuiaPrincipalSP, instr(vgGuiaPrincipalSP,'#')+1, 100 ); /* PDA 284020 */
        else                                                                                       -- 16/10/2007 - fim
          if vNrGuiaEspecifica is null or vNrGuiaEspecifica = 'X' then
            vNrGuia := dbamv.pkg_ffcv_guia.fnc_retornar_faixa_guias( nCdConvenio, 'RE', vTpGuiaTiss||'@'||vp.cd_multi_empresa, sysdate, pvMsgErro);
            vNrGuiaZerada := null;
            if pvMsgErro is not null then
              return 'ERRO';
            end if;
          else
            vNrGuia := vNrGuiaEspecifica;
            vNrGuiaZerada := null;
            --
            -- pda 221258 - 13/03/2008 - Amalia Araújo - se a filha for igual à principal, pegar nova faixa
            if vNrGuia = vNrGuiaPrincipal then
              vNrGuia := dbamv.pkg_ffcv_guia.fnc_retornar_faixa_guias( nCdConvenio, 'RE', vTpGuiaTiss||'@'||vp.cd_multi_empresa, sysdate, pvMsgErro);
            end if;
            -- pda 221258 - fim
            --
          end if;
        end if;
        --
      end if;
      --
      /* pda 287644 - 20/05/09 - Francisco Morais - Inserido nvl's nos campos referente ao codigo do prestador.*/
      if nvl(vp.cd_pro_fat,'X') <> nvl(auxcdprofat,'X') or      -- 17/10/2007
         Nvl(vp.cd_prestador_executante,9999)  <> Nvl(auxcdprestador_exe,9999) or   -- PDA 210550
         (vp.cd_ati_med  <>  auxcdatimed)  or 					-- pda 228700 devido ao pda 222504 - 16/05/2008
		 auxNrguia <> nvl(vNrGuiaEspecifica,vNrGuia) or         -- pda 221258 - 13/03/2008 - Amalia Araújo
         --( auxSnHorario <> vp.sn_horario_especial ) or  		-- pda 221861 - pda 236232 (comentado)
         ( auxSnHorario <> nvl(vp.sn_horario_especial,'N') ) or -- pda 236232
         nvl(auxdtlanc,trunc(sysdate)) <> nvl(vp.dt_lancamento,trunc(sysdate))  or -- pda 236232 - 18/07/2008 - Amalia Araújo
         Nvl(vp.cd_prestador_solicitante,9999) <> Nvl(auxcdprestador_sol,9999) then -- PDA 210550
        --
        nregistro := nregistro + 1;
        --
        auxNumero := vNrGuia; -- PDA 210550
        --
        /*pda 284313 - 30/04/2009 - Francisco Morais - referente ao aumento do codigo do prestador solicitante que passou de
                                  4 para 6 digitos, igual ao cliente 739.*/
        /* pda 284509 - Inserindo um LTRIM na variavel vNrGuiaPrincipal.*/
        insert into dbamv.tiss_nr_guia
           ( cd_atendimento, cd_reg_fat, tp_guia, nr_guia, cd_prestador,
		     cd_pro_fat, dt_lancamento, cd_multi_empresa, nr_folha, nr_linha, cd_codigo_contratado,
		     nr_guia_principal, cd_ati_med, tp_pagamento, vl_percentual_multipla
             , sn_horario_especial -- pda 221861 - pda 236232 (ok)
             )
         values( pnAtendimento, vp.cd_reg_fat, vTpGuiaTiss, ltrim(vNrGuia), vp.cd_prestador_executante||lpad(vp.cd_prestador_solicitante,6,'0'), -->> 210355 Adcionado LTRIM na variavel da Guia.
		         vp.cd_pro_fat, vp.dt_lancamento, nEmpresa, nFolha, nregistro, vp.cd_codigo_contratado,
				 LTRIM(vNrGuiaPrincipal), vp.cd_ati_med, vp.tp_pagamento, vp.vl_percentual_multipla
                 , vp.sn_horario_especial  -- pda 221861 - pda 236232 (ok)
                 );
        --
        /* 22/10/2007 - Específico para o Santa Joana, que gera guais zeradas de SP e HI hospitalar na função
                        DBAMV.FNC_FFCV_GERA_TISS_719 que são deletadas neste momento, pois o número da guia foi
                        utilizado no insert acima. Este processo de deletar somente agora, e não na APAGA_GUIAS
                        é para não perder a guia em branco caso não haja nenhum procedimento para ela quando
                        esta função aqui for executada.                                                         */
        -- pda 221585 - 18/03/2008 - Amalia Araújo - Não estava deletando, causando divergência.
        /*
        if vNrGuia = vNrGuiaZerada then
          delete from dbamv.tiss_nr_guia
           where nr_guia = vNrGuiaZerada and cd_atendimento = pnAtendimento and cd_reg_fat = pnConta and nvl(cd_pro_fat,'0') = '0';
        end if;
        */
        delete from dbamv.tiss_nr_guia
         where cd_atendimento = pnAtendimento
		   and nr_guia = vNrGuia
		   and tp_guia = 'SP'
		   and nvl(cd_pro_fat,'0') = '0';

        -- pda 221585 - fim
        --
      end if;
      --
    end if;  -->> Fim 3*
    --
    -- PDA 198883 inicio
    -- PDA 284066  - deixando só o update com o
    --if vTpTotalizaResInt = 'L' then
      --
      -- pda 217868 - 12/03/2008 - Amalia Araújo - Correções para o Sta Joana 719.
      -- Utilizando a conta do cursor ao invés do parãmetro, e deixando somente as condições de conta e lançamento.
      /*PDA 284714 - Renan Salvador - adicionando a condição  vp.sn_natureza = 'N',  p/ só marcar o nr_guia_envio se não possuir natureza*/
	  update dbamv.itreg_fat set nr_guia_envio = nvl(vNrGuia,auxNumero)  -- nvl(auxNumero,vNrGuia) -- pda 236232
       where cd_reg_fat = vp.cd_reg_fat
	     and cd_lancamento = vp.cd_lancamento
		 and vp.sn_natureza = 'N';
         -- and cd_ati_med = vp.cd_itlan_med and cd_prestador = vp.cd_prestador_executante;   -- pda 211781
      -- pda 217868 - fim
      --
    /*else
      --
      -- pda 217868 - 12/03/2008 - Amalia Araújo - Correções para o Sta Joana 719.
      -- Utilizando a conta do cursor ao invés do parãmetro.

      --PDA 221485(INICIO)
      open cHospital;
      fetch cHospital into vHosp;
      close cHospital;
      --PDA 221485(FIM)
      --
      -- pda 236232 - 14/07/2008 - Amalia Araújo
      -- A condição da cd_ati_med foi comentada porque o cursor cItensGravaHosp traz a coluna vp.cd_ati_med já
      -- convertida com o de-para configurado para a apresentação do meio magnético. Com esta condição descomentada
      -- este update não estava sendo feito.
      --
      if to_number(vHosp) = 719 then --PDA 221485
        /*pda 288240 - 21/05/2009 - Francisco Morais - Adicionado nvls nas colunas cd_prestador, vp.cd_pres_ext.
        /*pda 287625 - 18/05/2009 - Thiago Miranda de Oliveira - retirando o nvl do campo prestador pois não é uma informação
                       obrigatoria de ser preenchida e mesmo assim não poderia ser varchar com 'XXX' pois se trata de um campo numerico
        /*pda 286260 - 11/05/2009 - Francisco Morais - Adicionado nvls nas colunas cd_prestador, vp.cd_pres_ext, tp_pagamento, v.tp_pagamento para evitar divergencia.
		/*PDA 284714 - Renan Salvador - adicionando a condição  vp.sn_natureza = 'N',  p/ só marcar o nr_guia_envio se não possuir natureza
		/*PDA 298507 - Renan Salvador - igualando o vp.cd_pro_Fat com código agrupado , pois os OPMES podem possuir códigos agrupados e o prestador a 0 caso o vp.cd_prestador esteja com 0 (exames em guias de RI)--
        update dbamv.itreg_fat
           set nr_guia_envio    = nvl(auxNumero,vNrGuia)
         where cd_reg_fat               = vp.cd_reg_fat    -- pnConta
           and Nvl(decode(vp.cd_prestador_executante,'0','0',cd_prestador),9999)   = Nvl(vp.cd_prestador_executante,9999)
           /*and Cd_Pro_Fat               = vp.cd_pro_fat--
		   and decode(vp.tp_gru_pro,'OP',decode(nvl( dbamv.pkg_ffcv_meio_mag.fnc_ffcv_agrupa_proc( 'P@'||vp.cd_convenio, vp.cd_apr,itreg_fat.cd_pro_fat, null ), itreg_fat.cd_pro_fat ),
                itreg_fat.cd_pro_fat,itreg_fat.cd_pro_fat,dbamv.pkg_ffcv_meio_mag.fnc_ffcv_agrupa_proc('P@'||vp.cd_convenio, vp.cd_apr,itreg_fat.cd_pro_fat,null ) ),itreg_fat.cd_pro_fat) = vp.cd_pro_Fat
         --  and cd_ati_med       = vp.cd_ati_med  			-- pda 236232
           and Nvl(tp_pagamento, 'P')   = Nvl(vp.tp_pagamento, 'P')
           and cd_multi_empresa         = vp.cd_multi_empresa
		   and vp.sn_natureza           = 'N';
       --PDA 221485(inicio)
       else
           /*pda 286260 - 11/05/2009 - Francisco Morais - Adicionado nvls nas colunas cd_prestador, vp.cd_pres_ext, tp_pagamento, v.tp_pagamento para evitar divergencia.*/
           /*pda 288240 - 21/05/2009 - Francisco Morais - Adicionado nvls nas colunas cd_prestador, vp.cd_pres_ext.*/
		   /*PDA 284714 - Renan Salvador - adicionando a condição  vp.sn_natureza = 'N',  p/ só marcar o nr_guia_envio se não possuir natureza*/
           /*PDA 298507 - Renan Salvador - igualando o vp.cd_pro_Fat com código agrupado(caso seja OPME) , pois os OPMES podem possuir códigos agrupados e o prestador a 0 caso o vp.cd_prestador esteja com 0 (exames em guias de RI)--
		   update dbamv.itreg_fat
           set nr_guia_envio    = nvl(auxNumero,vNrGuia)
         where cd_reg_fat               = vp.cd_reg_fat    -- pnConta
           and Nvl(decode(vp.cd_pres_ext,'0','0',cd_prestador),9999)   = Nvl(vp.cd_pres_ext,9999)
           /*and Cd_Pro_Fat               = vp.cd_pro_fat--
           and decode(vp.tp_gru_pro,'OP',decode(nvl( dbamv.pkg_ffcv_meio_mag.fnc_ffcv_agrupa_proc( 'P@'||vp.cd_convenio, vp.cd_apr,itreg_fat.cd_pro_fat, null ), itreg_fat.cd_pro_fat ),
                itreg_fat.cd_pro_fat,itreg_fat.cd_pro_fat,dbamv.pkg_ffcv_meio_mag.fnc_ffcv_agrupa_proc('P@'||vp.cd_convenio, vp.cd_apr,itreg_fat.cd_pro_fat,null ) ),itreg_fat.cd_pro_fat) = vp.cd_pro_Fat
          -- and cd_ati_med       = vp.cd_ati_med			-- pda 236232
           and Nvl(tp_pagamento, 'P')   = Nvl(vp.tp_pagamento, 'P')
		   and vp.sn_natureza           = 'N';
       end if;
       --PDA 221485(fim)
      -- pda 217868 - fim
      -- pda 236232 - fim
      --
    end if;*/
    -- PDA 198883 fim
    --
    if vp.cd_itlan_med is not null then
      -- pda 217868 - 12/03/2008 - Amalia Araújo - Correções para o Sta Joana 719.
      -- Utilizando a conta do cursor ao invés do parãmetro.
      /*PDA 284714 - Renan Salvador - adicionando a condição  vp.sn_natureza = 'N',  p/ só marcar o nr_guia_envio se não possuir natureza*/
	  update dbamv.itlan_med set nr_guia_envio = nvl(vNrGuia,auxNumero)  -- nvl(auxNumero,vNrGuia) -- pda 236232
       where cd_reg_fat = vp.cd_reg_fat and cd_lancamento = vp.cd_lancamento
        --PDA 211781 Início
        -- and cd_ati_med = vp.cd_ati_med
         and cd_ati_med = vp.cd_itlan_med and cd_prestador = vp.cd_pres_ext  -- PDA 251806
		 and vp.sn_natureza = 'N';
        --PDA 211781 Fim
      -- pda 217868 - fim
	end if;
    --
    auxdtlancamento   	:= vp.dt_lancamento;
    auxcdprofat       	:= vp.cd_pro_fat;
    auxcdprestador_exe	:= vp.cd_prestador_executante;
    auxcdprestador_sol	:= vp.cd_prestador_solicitante;
    auxContratado     	:= vp.cd_codigo_contratado;
    auxcdatimed       	:= vp.cd_ati_med;
    auxcdregfat         := vp.cd_reg_fat;                	-- pda 217868 - 12/03/2008 - Amalia Araújo
    auxvlpercentual     := vp.vl_percentual_multipla;    	-- pda 211223
    --auxSnHorario          := vp.sn_horario_especial;     	-- pda 221861 - pda 236232 (comentado)
    auxSnHorario        := nvl(vp.sn_horario_especial,'N'); -- pda 236232
    auxdtlanc           := vp.dt_lancamento;                -- 11/07/2008
    --
    bPrimeiroRegistro := false;
    nAuxOrdem         := vp.ordem_guia;
    auxNrGuia      	    := vNrGuia;						-- pda 209197

  end loop;  -- Fim 0H*
  --
  -- Quantidade de itens na conta ambulatorial
  nQtItens := null;
  if pvTpConta = 'A' then
    open  cQtdItens;
    fetch cQtdItens into nQtItens;
    close cQtdItens;
  end if;
  --
  -- pda 222774 - 01/04/2008 - Amalia Araújo - Corrige nr_guia_principal
  if pvTpConta = 'H' and dbamv.pkg_mv2000.le_cliente = 719 then
    --
    for v in cGuiaLimpa( pnAtendimento ) loop
      --
      update dbamv.tiss_nr_guia set nr_guia_principal = v.nr_guia_principal
       where cd_atendimento = v.cd_atendimento
         -- pda 226291 - 25/04/2008 - Amalia Araújo
         and ( cd_reg_fat = v.cd_reg_fat or
               cd_reg_fat in ( select r.cd_reg_fat from dbamv.reg_fat r
                                where r.cd_conta_pai = v.cd_reg_fat )
              )
         -- pda 226291 - fim
         and nr_guia_principal is null;
      -- pda 226291 - 25/04/2008 - Amalia Araújo
      insert into dbamv.log_erro( id_log_erro, usuario, dt_erro, forms, ds_erro )
        values( dbamv.seq_log_erro.nextval, user, sysdate, dbamv.pkg_mv2000.le_formulario,
          'cGuiaLimpa 2 - atendimento:'||v.cd_atendimento||' - conta: '||v.cd_reg_fat
             ||' - conta pai:'||v.cd_conta_pai||' - nr_guia_principal:'||v.nr_guia_principal
             );
      -- pda 226291 - fim
    end loop;
    --
    -- pda 249143 - 15/09/2008 - Amalia Araújo
    -- Depois do fechamento da conta verifica-se que um honorário ficou de fora,
	-- então é aberta uma nova conta somente com este procedimento.
    -- Neste caso deve ser gerada uma guia de HI e não de RI.
    for v in cComplemento719( pnAtendimento, pnConta ) loop     -- 23/09/2008
      --
      update dbamv.tiss_nr_guia set tp_guia = 'HI'
       where cd_atendimento = v.cd_atendimento and cd_reg_fat = v.cd_reg_fat
         and tp_guia = 'RI' and nvl(cd_pro_fat,'0') <> '0' and cd_prestador is not null;
      --
      insert into dbamv.log_erro( id_log_erro, usuario, dt_erro, forms, ds_erro )
        values( dbamv.seq_log_erro.nextval, user, sysdate, dbamv.pkg_mv2000.le_formulario,
          'cComplemento719 - atendimento:'||v.cd_atendimento||' - conta: '||v.cd_reg_fat
              );
      --
    end loop;
    -- pda 249143 - fim
    --
    /*  -- pda 224554 - 15/04/2008 - comentado
	update dbamv.reg_fat set nr_guia_envio_principal = vNrGuiaPrincipal
     where cd_reg_fat = pnConta and nr_guia_envio_principal is null;
	*/
    --
    commit;
    --
  end if;
  -- pda 222774 - fim
  --
  vNrGuiaPrincipal := null;
  --
  -- Para Contas Ambulatoriais
  -- Executar o cursor principal para classificar os procedimentos. Realizar o Loop principal sobre o cursor
  For vp In cItensGravaAmb Loop       -- Inicio 0A*
    --
    -- Tipo de guia baseado na configuração do convênio (se utiliza guia de consulta) e a quantidade de itens na conta
    -- SP = SP/Sadt; CO = Consulta.
    if nvl(nQtItens,0) = 1 and vp.sn_guia_consulta = 'S' and nvl(vp.tp_consulta,'X') = 'E' then
      vTpGuiaTiss := 'CO';
    else
      vTpGuiaTiss := 'SP';
    end if;
    --
    if vNrGuiaLegado is not null then                                       -- 19/10/2007
      vNrGuiaPrincipal := vNrGuiaLegado;
      vNrGuiaLegado    := null;
    end if;
    --
    -- Busca numeração da guia principal (só uma vez) e já pega a primeira guia de envio do atendimento.
    if vNrGuiaPrincipal is null then   -- Inicio 1A*
      --
      -- - Ambulatoriais:
      --     - Ler ¿ATENDIME.NR_GUIA_PRINCIPAL_ENVIO¿,
      --     - Se tiver conteúdo (<>Null), atribuir à vGuiaPrinc.
      --     - Se for Null :
      --       - Pesquisar a tabela de Guia (tabela GUIA) por guia do tipo 'C' ou 'P'
      --         ¿Autorizada¿ referente ao atendimento, a primeira guia (menor CD_GUIA)
	  --	     que tenha pelo menos 1 lançamento (ITREG_AMB.CD_GUIA) com TP_PAGAMENTO='P'.
      --       - Se encontrar, atribuir à vGuiaPrinc.
      --       - Se não encontrar, obter faixa referente à Envio SP/SADT e atribuir à vGuiaPrinc.
      --
      -- pda 211289 - Thiago Miranda de Oliveira - 16/01/2008 - sempre considerar a guia do atendimento antes
      open  cGuiaAmbulatorio;
      fetch cGuiaAmbulatorio into vcGuiaAmbulatorio;
      close  cGuiaAmbulatorio;
      --
      -- pda 278456 - 23/03/2009 - Amalia Araújo
      -- Corrigindo a condição colocando o IF do cliente 719 mais externo, porque estava entrando no ELSE indevidamente
      -- e desconsiderando a configuração de não reutilizar a numeração das guias.
      -- pda 226051 - 25/04/2008 - Amalia Araújo - Somente se está reutilizando a numeração da guia.
      if dbamv.pkg_mv2000.le_cliente = 719 then
      --if vReutilizaNrGuia is null and dbamv.pkg_mv2000.le_cliente = 719 then
        if vReutilizaNrGuia is null then
      -- pda 226051 - fim
  	    -- pda 211289 - ordem das guias: atendimento, tiss_nr_guia e tela de guias
          vNrGuiaPrincipal := nvl( nvl(vcGuiaAmbulatorio.nr_guia_atend,vp.nr_guia_envio_principal),vcGuiaAmbulatorio.nr_guia);
        end if;
      else
        -- pda 248374 - colocando if trarando se for natureza - não pegar guia específica caso seja natureza
        if vp.ordem_natureza = '1' then
          vNrGuiaPrincipal := vp.nr_guia_envio_principal;
        else
          vNrGuiaPrincipal := nvl( nvl(vcGuiaAmbulatorio.nr_guia_atend,vp.nr_guia_envio_principal),vcGuiaAmbulatorio.nr_guia);
        end if;
      end if;
      -- pda 278456 - fim
      --
      -- fim pda 211289
      if vNrGuiaPrincipal is null then
       -- pda 207690 - 22/10/2007 - Thiago Miranda de Oliveira - colocando mais uma condição para pegar guia especifica se o mesmo tiver
        if vp.cd_guia_conta is not null then
          open  cGuiaAmbEsp(vp.cd_guia_conta);
          fetch cGuiaAmbEsp into vcGuiaAmbEsp;
          if cGuiaAmbEsp%found then
            vNrGuiaPrincipal := vcGuiaAmbEsp.nr_guia;
          else
            vNrGuiaPrincipal := dbamv.pkg_ffcv_guia.fnc_retornar_faixa_guias(nCdConvenio, 'RE', vTpGuiaTiss||'@'||vp.cd_multi_empresa , sysdate, pvMsgErro);
            if pvMsgErro is not null then
              return 'ERRO';
            end if;
          end if;
        -- fim pda 207690
        else
          vNrGuiaPrincipal := dbamv.pkg_ffcv_guia.fnc_retornar_faixa_guias(nCdConvenio, 'RE', vTpGuiaTiss||'@'||vp.cd_multi_empresa , sysdate, pvMsgErro);
          if pvMsgErro is not null then
            return 'ERRO';
          end if;
        end if;
        --
        nTamanhoFaixa := null;
        open  cTamanhoFaixa( vp.cd_multi_empresa, nCdConvenio, vTpGuiaTiss );
        fetch cTamanhoFaixa into nTamanhoFaixa;
        close cTamanhoFaixa;
        if nvl(nTamanhoFaixa,0) > 0 and length(vNrGuiaPrincipal) < nvl(nTamanhoFaixa,0) then
          vNrGuiaPrincipal := lpad( vNrGuiaPrincipal, nTamanhoFaixa, '0' );
        end if;
        --
        update dbamv.atendime set nr_guia_envio_principal = vNrGuiaPrincipal where cd_atendimento = pnAtendimento;
        --
      end if;
      vNrGuia := vNrGuiaPrincipal; -- Primeira guia é a guia Principal.
      --
    else -- Existindo a guia legado
       -- PDA 222241 Inicio
      If vNrGuia is null Then
         vNrGuia := vNrGuiaPrincipal;
      End if;
      -- PDA 222241 Fim
    end if;    -- fim *1A
    --
    --
    -- pda 280965 - 06/04/2009 - Francisco Morais - Adicionado o nvl pois a nr_guia_envio_principal da atendime estava nula e com isso
    -- estava acontecendo divergencia de remessa.
    --
    -- pda 209472 - 12/12/2007 - Amalia Araújo - atualizando a guia principal do atendimento caso já tenha sido
    -- gravado um número, mas a preferência for para a guia informada na tela do atendimento ambulatorial.
    if Nvl(vp.nr_guia_envio_atendime, 'XX') <> Nvl(vNrGuiaPrincipal, 'XX') then
      update dbamv.atendime set nr_guia_envio_principal = vNrGuiaPrincipal where cd_atendimento = pnAtendimento;
    end if;
    --
    if vTpGuiaTiss = 'CO' then     -- inicio *2A
      --
      nfolha    := null;
      nregistro := null;
      /*pda 284313 - 30/04/2009 - Francisco Morais - referente ao aumento do codigo do prestador solicitante que passou de
                                  4 para 6 digitos, igual ao cliente 739.*/
      /* pda 284509 - Inserindo um LTRIM na variavel vNrGuiaPrincipal.*/
      insert into dbamv.tiss_nr_guia
         ( cd_atendimento, cd_reg_amb, tp_guia, nr_guia, cd_prestador,
		   cd_pro_fat, dt_lancamento, cd_multi_empresa, nr_folha, nr_linha, cd_codigo_contratado,
		   nr_guia_principal, cd_ati_med, tp_pagamento      -- pda 211289 - colocar um nvl no numero de guia para pegar a do legado se tiver
		  ,sn_horario_especial 								-- pda 236232
		  )
         values( pnAtendimento, pnConta, vTpGuiaTiss, LTRIM(nvl(vNrGuia,vNrGuiaPrincipal)), vp.cd_prestador_executante||lpad(vp.cd_prestador_solicitante,6,0), -->> 210355 Adcionado LTRIM na variavel da Guia.
		         vp.cd_pro_fat, vp.dt_lancamento, vp.cd_multi_empresa, nFolha, nregistro, vp.cd_codigo_contratado,
				 LTRIM(vNrGuiaPrincipal), vp.cd_ati_med, vp.tp_pagamento
				,vp.sn_horario_especial						-- pda 236232
		   	   );
      --
    elsif vTpGuiaTiss = 'SP' then
      --
      /*pda 271551 - 04/02/2009 - Francisco Morais (Inicio)*/
      --Carregando as variaveis auxiliares com os dados dos prestadores principais da conta
      IF vNrGuiaPrinc IS NULL THEN
         vNrGuiaPrinc := vNrGuiaPrincipal;
         vPrestadorPrincExe := vp.cd_prestador_executante;
         vPrestadorPrincSol := vp.cd_prestador_solicitante;
      END IF;
      /*pda 271551 - 04/02/2009 - Francisco Morais (Fim)*/
      --
      if vp.cd_guia_conta is not null then
        open  cGuiaEspecifica( vp.cd_guia_conta );
        fetch cGuiaEspecifica into vNrGuiaEspecifica;
        close cGuiaEspecifica;
        --
        /* pda 287644 - 20/05/09 - Francisco Morais - Inserido nvl's nos campos referente ao codigo do prestador.
           Se houver guia específica no procedimento, mas já foi registrada com outro prestador, não utiliza*/
        /* pda 211289 - thiago Miranda de Oliveira - colocando condição qunado a guia especifica for a principal*/
        /* pda 272580 - 12/02/2009 - Francisco Morais -
          Complementando a validacao do pda 271551, adicionado a validacao o tipo de pagamento (vp.tp_pagamento <> 'C')*/
        --if vNrGuiaEspecifica is not null then
      --if (vNrGuiaEspecifica is not null) and ((vNrGuiaEspecifica = vNrGuiaPrincipal and auxcdprestador_exe = vp.cd_prestador_executante and auxcdprestador_sol = vp.cd_prestador_solicitante) --pda 271551
        if (vNrGuiaEspecifica is not null) and ((vNrGuiaEspecifica = vNrGuiaPrincipal and Nvl(vPrestadorPrincExe,9999) = Nvl(vp.cd_prestador_executante,9999) and Nvl(vPrestadorPrincSol,9999) = Nvl(vp.cd_prestador_solicitante,9999) and vp.tp_pagamento <> 'C') --pda 271551
        or (vNrGuiaEspecifica <> vNrGuiaPrincipal)) then
          --
          nTamanhoFaixa := null;
          open  cTamanhoFaixa( vp.cd_multi_empresa, nCdConvenio, vTpGuiaTiss );
          fetch cTamanhoFaixa into nTamanhoFaixa;
          close cTamanhoFaixa;
          if nvl(nTamanhoFaixa,0) > 0 and length(vNrGuiaEspecifica) < nvl(nTamanhoFaixa,0) then
            vNrGuiaEspecifica := lpad( vNrGuiaEspecifica, nTamanhoFaixa, '0' );
          end if;
          --
          if instr( nvl(vNrGuiaUsada,'#'), '#'||vNrGuiaEspecifica||'$' ) > 0 and vp.SN_SEPARA_PREST_GUIA = 'S' and --pda 236706
		     instr( nvl(vNrGuiaUsada,'#'), '#'||vNrGuiaEspecifica||'$'||vp.cd_prestador_executante||lpad(vp.cd_prestador_solicitante,6,0) ) = 0 THEN
            vNrGuiaEspecifica := 'X';
            bGuiaEspecifica   := false;
          else
            bGuiaEspecifica   := true;
          end if;
          --
          if vNrGuiaUsada is null then
            /*pda 284313 - 30/04/2009 - Francisco Morais - referente ao aumento do codigo do prestador solicitante que passou de
                                        4 para 6 digitos, igual ao cliente 739.*/
            vNrGuiaUsada := '#'||vNrGuiaEspecifica||'$'||vp.cd_prestador_executante||lpad(vp.cd_prestador_solicitante,6,0);
          else
            /*pda 284313 - 30/04/2009 - Francisco Morais - referente ao aumento do codigo do prestador solicitante que passou de
                                        4 para 6 digitos, igual ao cliente 739.*/
            vNrGuiaUsada := vNrGuiaUsada ||'#'||vNrGuiaEspecifica||'$'||vp.cd_prestador_executante||lpad(vp.cd_prestador_solicitante,6,0);
          end if;
          --
        -- pda 211289 - thiago Miranda de oliveira - colocando condição qunado a guia especifica for a principal
        else
          vNrGuiaEspecifica := 'X';
        end if;
        --
      else
        -- 25/10/2007 - Caso a guia anterior tenha sido específica, altera o valor da vNrGuia para forçar entrar no IF para buscar nova numeração.
        if bGuiaEspecifica then
          vNrGuia := 'Y';
          vNrGuiaEspecifica := 'X';
        else
          vNrGuiaEspecifica := null;
        end if;
        --
        bGuiaEspecifica := false;
        --
      end if;
      --
    --
    /* pda 287644 - 20/05/09 - Francisco Morais - Inserido nvl's nos campos referente ao codigo do prestador.*/
    /* pda 276287 - 11/03/09 - Francisco Morais
       A condicao foi alterada para nao quebrar pelo vl_percentual_multipla*/
	  -- pda 209472 - 12/12/2007 - Amalia Araújo
	  -- A condição foi alterada para considerar a futura configuração de separar ou não as guias por prestador
	  -- (conf.SN_SEPARA_PREST_GUIA), que no momento está com valro fixo para não separa, para ser avaliado no
	  -- cliente 703, apenas na 4.7.F
      /*
      if nregistro > 4  or
		 vp.cd_prestador_executante  <> auxcdprestador_exe or
		 vp.cd_prestador_solicitante <> auxcdprestador_sol or
		 vNrGuia                     <> nvl(vNrGuiaEspecifica,vNrGuia) or
		 nvl(vp.cd_codigo_contratado,'X') <> nvl(auxContratado,'X')  or
   		 nvl(vp.Tp_Pagamento,'X') <> nvl(auxTpPagamento,'X')  then
   	  */
      -- pda 239133
      if (
           (  vp.sn_somente_xml = 'S' and   nvl(vGeraImpressao, 'N') = 'N')
            and
           (
            nvl(vp.Tp_Pagamento,'X') <> nvl(auxTpPagamento,'X')
           )
         )
        or
         (
           (  vp.sn_somente_xml = 'N' and vp.SN_SEPARA_PREST_GUIA = 'N')
            and
	  	   (
             ( nregistro                    > 4 )  or
	   	     ( vNrGuia                     <> nvl(vNrGuiaEspecifica,vNrGuia ) ) or
	         ( nvl(vp.Tp_Pagamento,'X')    <> nvl(auxTpPagamento,'X') ) or
		     (nvl(vp.ordem_natureza,'X')       <> nvl(auxOrdemNatureza,'X')) or                 -- pda 248374
	  	     ( Nvl(vp.cd_prestador_executante,9999) <> Nvl(auxcdprestador_exe,9999) and nvl(vp.Tp_Pagamento,'X') = 'C' )
		   )
	  	 )
        or
         (
           (  vp.sn_somente_xml = 'N' and vp.SN_SEPARA_PREST_GUIA = 'S')
            and
           (
             (nregistro                         > 4) or
		     ( Nvl(vp.cd_prestador_executante,9999) <> Nvl(auxcdprestador_exe,9999) )or
             (vp.cd_ati_med                    <> auxcdatimed)  or
             --(vp.vl_percentual_multipla        <> auxVlPercMult)  or /* PDA.: 266927 - 09/01/2009 - Emanoel Deivison */ --pda 276287 - 11/03/09 - Francisco Morais
		     ( Nvl(vp.cd_prestador_solicitante,9999) <> Nvl(auxcdprestador_sol,9999) ) or
		     (vNrGuia                          <> nvl(vNrGuiaEspecifica,vNrGuia)) or
             (nvl(vp.Tp_Pagamento,'X')         <> nvl(auxTpPagamento,'X')) or
		     (nvl(vp.ordem_natureza,'X')       <> nvl(auxOrdemNatureza,'X')) or                 -- pda 248374
		     (nvl(vp.cd_codigo_contratado,'X') <> nvl(auxContratado,'X'))
           )
         )
        or
         (
           (  vp.sn_somente_xml = 'S' and nvl(vGeraImpressao, 'N') = 'S')
            and
           (
             (nregistro                         > 4) or
	         (nvl(vp.Tp_Pagamento,'X')         <> nvl(auxTpPagamento,'X')) or
		     (nvl(vp.cd_codigo_contratado,'X') <> nvl(auxContratado,'X'))
           )
         )
         then
		 --
         -- pda 209472 - 12/12/2007 - fim
  		--
        if  nvl(vGeraImpressao, 'N') = 'S' then
          /* pda 286700 - 29/05/2009 - Francisco Morais
            Caso o cliente tenha configurado para gerar guia unica nas configuracoes do tiss por convenio e for
            credenciado o sistema ira gerar uma guia diferente da principal evitando assim divergencia de valores.*/
          /*nFolhaAmb := nFolhaAmb + 1;
            nregistro := 0;*/
          if nvl(auxTpPagamento,'P')  = Nvl(vp.tp_pagamento,'P') then
            nFolhaAmb := nFolhaAmb + 1;
            nregistro := 0;
          else
            nFolhaAmb := 1;
            nregistro := 0;
            vNrGuia := dbamv.pkg_ffcv_guia.fnc_retornar_faixa_guias( nCdConvenio, 'RE', vTpGuiaTiss||'@'||vp.cd_multi_empresa, sysdate, pvMsgErro);
          end if;

        else
        /* pda 290106 - 01/06/09 - Francisco Morais - condicao estava comentada errada, pois quando a condicao de Gerar impressao estava como N,
                                                      o sistema estava continuando com o numero do registro e o numero da folha anterior e com
                                                      isso erram geradas varias guias com numero diferentes para o mesmo prestador.*/
          nregistro := 0;
          nFolhaAmb := 0;
          --
          if auxcdprestador_exe <> 0 then                                     -- 19/10/2007
            if vNrGuiaEspecifica is null or vNrGuiaEspecifica = 'X' then
              vNrGuia := dbamv.pkg_ffcv_guia.fnc_retornar_faixa_guias( nCdConvenio, 'RE', vTpGuiaTiss||'@'||vp.cd_multi_empresa, sysdate, pvMsgErro);
              if pvMsgErro is not null then
                return 'ERRO';
              end if;
            else
              vNrGuia := vNrGuiaEspecifica;
            end if;
          end if;
          --
          /* pda 287644 - 20/05/09 - Francisco Morais - Inserido nvl's nos campos referente ao codigo do prestador.*/
          -- pda 208925 - Thiago Miranda de Oliveira se os dados do item forem os mesmos do anterior onsiderar a mesma numeração
          if nregistro                   = 0
            and auxcdprofat              = vp.cd_pro_fat
            and Nvl(auxcdprestador_exe,9999) = Nvl(vp.cd_prestador_executante,9999)
            and Nvl(auxcdprestador_sol,9999) = Nvl(vp.cd_prestador_solicitante,9999)
            and nvl(auxContratado,'XXX') = nvl(vp.cd_codigo_contratado,'XXX') -- PDA.: 238453 - 29/07/2008 - Emanoel Deivison
            and nvl(auxcdatimed,'XXX')   = nvl(vp.cd_ati_med,'XXX') -- PDA.: 238453 - 29/07/2008 - Emanoel Deivison
            and nvl(auxVlPercMult,0)    = nvl(vp.vl_percentual_multipla,0) /* PDA.: 266927 - 09/01/2009 - Emanoel Deivison */
   		    and nvl(vp.Tp_Pagamento,'X') = nvl(auxTpPagamento,'X')  then
            --
            -- PDA 220755 Inicio
            IF vNrGuiaEspecifica is null or
              vNrGuiaEspecifica = 'X' Then
              auxNrGuia := nvl(vNrGuiaEspecifica,vNrGuia);
            End If;
            -- PDA 220755 Fim
          end if;
        end if;
      end if; -- pda 239133
      --
      -- pda 239133
      if  nvl(vGeraImpressao, 'N') = 'S' then
        if nvl(vp.cd_pro_fat,'X') <> nvl(auxcdprofat,'X') or
           auxNrGuia <> nvl(vNrGuiaEspecifica,vNrGuia)
           or (auxdtlancamento <> vp.dt_lancamento /*or auxCdLancAgrup <> vp.cd_lanc_agrup*/) then -- PDA 284066
          --
          nregistro := nregistro + 1;
     	  --
          auxNumero := LTRIM(vNrGuia); -- PDA 211289 - colocando novamente
          --
     	  if nvl(auxNrGuia,'XXX') <> nvl(vNrGuiaEspecifica,vNrGuia) then
     	    vPrestExecutante  := vp.cd_prestador_executante;
    	    vPrestSolicitante := vp.cd_prestador_solicitante;
     	  end if;
          /* pda 288240 - 21/05/2009 - Francisco Morais - Inserido o campo sn_horario_especial, pois o mesmo nao estava sendo inserido na tabela*/
          /* pda 284313 - 30/04/2009 - Francisco Morais - referente ao aumento do codigo do prestador solicitante que passou de
                                      4 para 6 digitos, igual ao cliente 739.*/
        /* pda 284509 - Inserindo um LTRIM na variavel vNrGuiaPrincipal.*/
          insert into dbamv.tiss_nr_guia
           ( cd_atendimento, cd_reg_amb, tp_guia, nr_guia, cd_prestador,
		   cd_pro_fat, dt_lancamento, cd_multi_empresa, nr_folha, nr_linha, cd_codigo_contratado,
		   nr_guia_principal, cd_ati_med, tp_pagamento, sn_horario_especial )       -- (**) linha de baixo prest executante
           values( pnAtendimento, pnConta, vTpGuiaTiss, LTRIM(vNrGuia),
                 vPrestExecutante||lpad(vPrestSolicitante,6,0), -->> 210355 Adcionado LTRIM na variavel da Guia.
		         vp.cd_pro_fat, vp.dt_lancamento, vp.cd_multi_empresa, nFolhaAmb, nregistro, vp.cd_codigo_contratado,
				 LTRIM(vNrGuiaPrincipal), vp.cd_ati_med, vp.tp_pagamento, vp.sn_horario_especial );
        end if;
      else
        -- pda 206435 - Thiago Miranda de Oliveira 07/11/2007 - colocando a comparação da numeração antiga
        if nvl(vp.cd_pro_fat,'X') <> nvl(auxcdprofat,'X') or auxNrGuia <> nvl(vNrGuiaEspecifica,vNrGuia)                                   -- 17/10/2007
           or nvl(auxcdatimed,'XXX') <> nvl(vp.cd_ati_med,'XXX') 	-- PDA.: 238453 - 29/07/2008 - Emanoel Deivison
           or nvl(auxVlPercMult,0) <> nvl(vp.vl_percentual_multipla,0) 	/* PDA.: 266927 - 09/01/2009 - Emanoel Deivison */
           --or (vp.sn_horario_especial  <>  auxSnHorario) 		-- pda 221861 - pda 236232 (comentado)
           or (nvl(vp.sn_horario_especial,'N') <> auxSnHorario)	-- pda 236232
           or (auxdtlancamento <> vp.dt_lancamento /*or auxCdLancAgrup <> vp.cd_lanc_agrup*/) then -- PDA 284066
                 --PDA 222090 20/03/2008 - Jansen Gallindo
          --
          nregistro := nregistro + 1;
     	  --
          auxNumero := LTRIM(vNrGuia); -- PDA 211289 - colocando novamente
          --
     	  -- pda 209472 (**) - e uso no insert abaixo (vPrestExecutante)
          -- pda 211289 - 14/01/2008 - Thiago Miranda de Oliveira - substituir codigo pela coluna de configuração
     	  if ( vp.SN_SEPARA_PREST_GUIA = 'N' and auxNrGuia <> nvl(vNrGuiaEspecifica,vNrGuia) ) or vPrestExecutante is null or vPrestSolicitante is null then
     	      vPrestExecutante := vp.cd_prestador_executante;
     	      vPrestSolicitante := vp.cd_prestador_solicitante;
     	  end if;
          -- pda 211289 - 14/01/2008 - Thiago Miranda de Oliveira - substituir codigo pela coluna de configuração
     	  if vp.SN_SEPARA_PREST_GUIA = 'S' then
     	    vPrestExecutante := vp.cd_prestador_executante;
   	        vPrestSolicitante := vp.cd_prestador_solicitante;
     	  end if;
        /*pda 284313 - 30/04/2009 - Francisco Morais - referente ao aumento do codigo do prestador solicitante que passou de
                                    4 para 6 digitos, igual ao cliente 739.*/
        /* pda 284509 - Inserindo um LTRIM na variavel vNrGuiaPrincipal.*/
          insert into dbamv.tiss_nr_guia
           ( cd_atendimento, cd_reg_amb, tp_guia, nr_guia, cd_prestador,
		     cd_pro_fat, dt_lancamento, cd_multi_empresa, nr_folha, nr_linha, cd_codigo_contratado,
		     nr_guia_principal, cd_ati_med, tp_pagamento
             , sn_horario_especial -- pda 221861 - pda 236232 (ok)
             , vl_percentual_multipla /* PDA.: 266927 - 09/01/2009 - Emanoel Deivison */
             )       -- (**) linha de baixo prest executante
            values( pnAtendimento, pnConta, vTpGuiaTiss, LTRIM(vNrGuia),
                --vp.cd_prestador_executante||lpad(vp.cd_prestador_solicitante,4,0), -->> 210355 Adcionado LTRIM na variavel da Guia.
                -- pda 211289 - 14/01/2008  - Thiago Miranda de Oliveira - Substituir prestador pela variavel para qunado tiver a quebra
                 vPrestExecutante||lpad(vPrestSolicitante,6,0), -->> 210355 Adcionado LTRIM na variavel da Guia.
		         vp.cd_pro_fat, vp.dt_lancamento, vp.cd_multi_empresa, nFolha, nregistro, vp.cd_codigo_contratado,
				 LTRIM(vNrGuiaPrincipal), vp.cd_ati_med, vp.tp_pagamento
                 , vp.sn_horario_especial -- pda 221861 - pda 236232 (ok)
                 , vp.vl_percentual_multipla /* PDA.: 266927 - 09/01/2009 - Emanoel Deivison */
                 );
        end if;
      end if; -- pda 239133
    end if;  -->> Fim *2A
    --
    update dbamv.itreg_amb set nr_guia_envio = nvl(auxNumero,vNrGuia) -- pda 211289 - colocando novamente a variavel
     where cd_reg_amb = pnConta and cd_atendimento = pnAtendimento and cd_lancamento = vp.cd_lancamento;
    --
    auxdtlancamento   	:= vp.dt_lancamento;
    auxcdprofat       	:= vp.cd_pro_fat;
    auxcdprestador_exe	:= vp.cd_prestador_executante;
    auxcdprestador_sol	:= vp.cd_prestador_solicitante;
    auxContratado     	:= vp.cd_codigo_contratado;
    auxcdatimed       	:= vp.cd_ati_med;
    auxVlPercMult       := vp.vl_percentual_multipla; /* PDA.: 266927 - 09/01/2009 - Emanoel Deivison */
    auxNrGuia      	    := vNrGuia;  							-- 206435 - Thiago Miranda de Oliveira - 07/11/2007 - guardando o ultimo numero
    auxTpPagamento    	:= vp.tp_pagamento; 					-->> Pda: 208700
    --auxSnHorario        := vp.sn_horario_especial; 			-- pda 221861 - pda 236232 (comentado)
    auxSnHorario        := nvl(vp.sn_horario_especial,'N');		-- pda 236232 - 30/06/2008 - Amalia Araújo
    auxOrdemNatureza    := vp.ordem_natureza; -- pda 248374
    --auxCdLancAgrup       := vp.cd_lanc_Agrup;

    --
  end loop;    -- fim *0A
  --
  -- pda 225224 - 28/04/2008 - Amalia Araújo - Marcando faixas que estavam neste atendimento
  --              mas que com o reprocesso foram limpas mas não reutilizadas, para não serem
  --              utilizadas em outro atendimento indevidamente.
  for nIndx in 1 .. dbamv.pkg_ffcv_tiss_aux.aRegFaixa.count loop
    update dbamv.item_faixa_guia_convenio
       set nr_guia = nr_sequencia, dt_lancamento = sysdate
     where cd_faixa_guia = dbamv.pkg_ffcv_tiss_aux.aRegFaixa(nIndx).cd_faixa_guia
       and cd_item_faixa_guia = dbamv.pkg_ffcv_tiss_aux.aRegFaixa(nIndx).cd_item_faixa_guia
       and nr_guia is null;
  end loop;
  -- pda 225224 - fim
  --
  return 'OK';
  --
End;
--
-- pda 208292 - 26/11/2007 - Thiago Miranda de Oliveira - criando função para so retornar o cd_guia qunado o mesmo não for o número da solicitação
function fnc_retorna_guia_conta( pnCdGuia in number
                               , pnCdAtendimento in number ) return number is
  --
  cursor cDadosGuia(nCdGuia in number) is
    select guia.tp_guia
         , guia.nr_guia
      from dbamv.guia
      where guia.cd_guia = nCdGuia;
  --
  cursor cGuiaInt(nCdAtendimento in number) is
    select guia.nr_guia
         , guia.cd_guia
      from dbamv.guia
     where guia.cd_atendimento = nCdAtendimento
       and guia.tp_guia        = 'I';
  --
  vcDadosGuia cDadosGuia%rowtype;
  vcGuiaInt cGuiaInt%rowtype;
  --
begin
  if pnCdGuia is null then
    return null;
  end if;
  --
  open cDadosGuia(pnCdGuia);
  fetch cDadosGuia into vcDadosGuia;
  close cDadosGuia;
  --
  open cGuiaInt(pnCdAtendimento);
  fetch cGuiaInt into vcGuiaInt;
  close cGuiaInt;
  --
  if vcDadosGuia.nr_guia is null then
    return null;
  end if;
  --
  if vcDadosGuia.tp_guia = 'I' then
    return null; -->> 210853
  end if;
  --
  if vcDadosGuia.nr_guia = vcGuiaInt.nr_guia then
    return null;
  end if;
  --
  return pnCdGuia;
  --
end fnc_retorna_guia_conta;
-- fim pda 208292
-- pda 211289
function fnc_retorna_versao_tiss( pnCdConvenio in number ) return varchar2 is
  cursor cVersao is
   select cd_versao_tiss cd_versao
     from dbamv.convenio_conf_tiss
    where cd_convenio = pnCdConvenio;
  --
  vcVersao dbamv.convenio_conf_tiss.cd_versao_tiss%type;
  --
  vMsgErro VARCHAR2(500);
  --
begin
 open cVersao;
 fetch cVersao into vcVersao;
 close cVersao;
 --
  /*pda 284313*/
  vMsgErro := dbamv.pkg_ffcv_tiss_pii.fnc_sincro_pda ('284313',null,'S','G');
  if vMsgErro <> 'OK' then
    raise_application_error( -20038, vMsgErro );
  end if;
 --
 return vcVersao;
end fnc_retorna_versao_tiss;
-- fim  pda 211289
-- pda 248374
function fnc_retorna_proc_natureza( pnCdConvenio in number, pnProFat in varchar2  ) return varchar2 is -- PDA.: 258657 - 02/12/2008 - Emanoel Deivison
  cursor cNatureza is
    select 'S'
      from dbamv.cod_pro
     where cod_pro.cd_convenio                = pnCdConvenio
       and cod_pro.cd_pro_fat                 = pnProFat
       and upper(cod_pro.ds_unidade_cobranca) = 'NATUREZA';

  vRet varchar2(1);
begin
  open cNatureza;
  fetch cNatureza into vRet;
  close cNatureza;
  --
  return nvl(vRet,'N');
  --
end fnc_retorna_proc_natureza;
-- pda 248374

END PKG_FFCV_TISS_AUX;
/


-- End of DDL Script for Package DBAMV.PKG_FFCV_TISS_AUX

