--<DS_SCRIPT>
-- DESCRIÇÃO..: FATURCONV-3011-  Ajuste para tradução das MSG utilizadas na função.
-- RESPONSAVEL: ALSI - AUGUSTO SILVA
-- DATA.......: 25/01/2017
-- APLICAÇÃO..: FFCV
--</DS_SCRIPT>
--<USUARIO=DBAMV>

CREATE OR REPLACE FUNCTION dbamv.val_proc_ffcv(
  cprocedimento    IN      VARCHAR2
, ddatarefer       IN      DATE
, dhorarefer       IN      DATE
, ncodconvenio     IN      NUMBER
, ncodplano        IN      DBAMV.CON_PLA.CD_CON_PLA%TYPE /*NUMBER PDA 254997*/
, ctipoatend       IN      VARCHAR2
, ncodtipoaco      IN      NUMBER
, ctpatimed        IN      VARCHAR2
, nvlpercirmult    IN      NUMBER
, cretmsg          in out nocopy     Varchar2
, nvloper          in out nocopy     number
, nvlhonor         in out nocopy     number
, nvlfilme         in out nocopy     number
, nvlporte         in out nocopy     number
, nvlchtotal       in out nocopy     number
, nvlchhonor       in out nocopy     number
, nvltaxa          in out nocopy     number
, nvldesconto      in out nocopy     number
, nvalproced       IN      NUMBER
, nqtde            IN      NUMBER DEFAULT 1
, nvlrtotal        in out nocopy     number
, nregra           IN      NUMBER DEFAULT NULL
, npercfranquia    IN      NUMBER DEFAULT NULL
, ncdfranquia      IN      NUMBER DEFAULT NULL
, ncdindice        IN      NUMBER DEFAULT NULL
, ncdregraacop     IN      NUMBER DEFAULT NULL
, cprofatexced     IN      VARCHAR2 DEFAULT NULL
, ctpconvenio      IN      VARCHAR2 DEFAULT NULL
, ncdconvacop      IN      NUMBER DEFAULT NULL
, ncdplanacop      IN      DBAMV.CON_PLA.CD_CON_PLA%TYPE /*NUMBER PDA 254997*/ DEFAULT NULL
, bprocessarvalor  IN      BOOLEAN DEFAULT NULL
, pncdprestador    IN      NUMBER DEFAULT NULL
, pncdsetor        IN      NUMBER DEFAULT NULL
, ncdconta         IN      DBAMV.REG_FAT.CD_REG_FAT%TYPE /*NUMBER PDA 254997*/ DEFAULT NULL
, ncdlancamento    IN      DBAMV.ITREG_FAT.CD_LANCAMENTO%TYPE /*NUMBER PDA 254997*/ DEFAULT NULL
 )  RETURN NUMBER IS
  --
  -- OP 21978 In?cio.
  --vprofat               VARCHAR2(8);
  vprofat               VARCHAR2(10);
  -- OP 21978 Fim.
  nmultiemp             NUMBER                                               := NULL;
  vvTpPag               varchar2(1):=null;  /* PDA.: 270509 */
  vddatarefer           DATE;                           /* PDA 292205 -- essa variavel substitui todas as chamadas do parametro ddatarefer */
  vdhorarefer           DATE;                           /* PDA 292205 -- essa variavel substitui todas as chamadas do parametro dhorarefer */
  vParam_Conv           dbamv.configuracao.valor%type;  /* PDA 292205 */
  --

   /*OP 1501*/
	nEmpresa number:= Dbamv.pkg_mv2000.le_empresa;
	nCliente  number := dbamv.pkg_mv2000.le_cliente;
	snNaoCalculaCentavos varchar2(5) := dbamv.pkg_mv2000.le_configuracao('FFCV', 'SN_NAO_CALCULA_CENTAVOS');
	snCredenciadoCentavos varchar2(5) := dbamv.pkg_mv2000.le_configuracao('FFCV', 'SN_CREDENCIADO_CENTAVOS');
	leFormulario varchar2(500):= dbamv.pkg_mv2000.le_formulario;
    /*OP 1501*/


  CURSOR c_valpro(cprofat IN VARCHAR2, ntabfat IN NUMBER, dreferencia IN DATE) IS
    SELECT NVL(val_pro.vl_total, 0) vl_total
         , NVL(val_pro.vl_operacional, 0) vl_operacional
         , NVL(val_pro.vl_honorario, 0) vl_honorario
      FROM dbamv.val_pro
     WHERE val_pro.cd_tab_fat = ntabfat AND val_pro.cd_pro_fat = cprofat
           AND NVL(val_pro.sn_ativo, 'S') = 'S'
           AND val_pro.dt_vigencia =
                (SELECT MAX(vl_pro.dt_vigencia)
                   FROM dbamv.val_pro vl_pro
                  WHERE vl_pro.cd_tab_fat = ntabfat AND vl_pro.cd_pro_fat = cprofat
                    AND NVL(vl_pro.sn_ativo, 'S') = 'S'
                    AND vl_pro.dt_vigencia <= dreferencia);
  --
  /* pda 538893 - 11/09/2012 - Amalia Ara?jo - corrigindo filtro pelo prestador e setor, porque quando havia um espec?fico estava
     trazendo o mais gen?rico se a data de vig?ncia fosse mais recente.   */
  /* pda 354906 - 16/03/2010 - Amalia Ara?jo
     - copiado o select, ficando o primeiro apenas para exce??o com regra espec?fica, com prioridade */
  /* pda 314713 - Thiago Miranda de Oliveira - incluindo o parametro de regra para a consulta, para qnuado a configuracao tiver a regra so trazer
                   as regras destinadas a aquela passada*/
  -- OP 47707
   CURSOR C_TabConvenio( nConvenio IN NUMBER,
                        nPlano IN NUMBER,
                        cProFat IN VARCHAR2,
                        dReferencia IN DATE,
						pnPrest	in number,
						pnSet	in number,
                        pnRegra in number
						  ) IS
    SELECT NVL( tab_convenio.vl_tab_convenio, 0 ) vl_tab_convenio,
           tab_convenio.sn_usar_indice,
           tab_convenio.sn_horario_especial,
           tab_convenio.sn_filme,
           tab_convenio.cd_regra,
           tab_convenio.cd_prestador,
           tab_convenio.cd_setor,
	   '1' nr_ordem
      FROM dbamv.tab_convenio
     WHERE tab_convenio.sn_ativo = 'S'
       AND tab_convenio.cd_convenio = nConvenio
       AND (tab_convenio.cd_con_pla = nPlano or tab_convenio.cd_con_pla is null)
       AND tab_convenio.cd_pro_fat = cProFat
       and tab_convenio.cd_multi_empresa = nMultiEmp
	   AND (tab_convenio.cd_prestador = pnPrest or tab_convenio.cd_prestador is null)
	   AND (tab_convenio.cd_setor = pnSet or tab_convenio.cd_setor is null)
	   AND tab_convenio.cd_regra = pnRegra
       AND tab_convenio.dt_vigencia = ( SELECT MAX( tab_conv.dt_vigencia )
                                                FROM dbamv.tab_convenio tab_conv
                                               WHERE tab_conv.sn_ativo = 'S'
                                                 AND tab_conv.cd_convenio = nConvenio
                                                 AND (tab_conv.cd_con_pla = nPlano or tab_conv.cd_con_pla is null)
                                                 AND tab_conv.cd_pro_fat = cProFat
                                                 AND tab_conv.dt_vigencia <= dReferencia
                                                 and tab_conv.cd_multi_empresa = nMultiEmp
                                       AND tab_convenio.cd_regra = pnRegra -- PDA 520412 - 19/06/2012 - Raphanelli de Barros
                           					 	 AND (tab_conv.cd_prestador = pnPrest or tab_conv.cd_prestador is null)
                           					 	 AND (tab_conv.cd_setor = pnSet or tab_conv.cd_setor is null)
						)
    union
    SELECT NVL( tab_convenio.vl_tab_convenio, 0 ) vl_tab_convenio,
           tab_convenio.sn_usar_indice,
           tab_convenio.sn_horario_especial,
           tab_convenio.sn_filme,
           tab_convenio.cd_regra,
           tab_convenio.cd_prestador,
           tab_convenio.cd_setor,
	   '2' nr_ordem
      FROM dbamv.tab_convenio
     WHERE tab_convenio.sn_ativo = 'S'
       AND tab_convenio.cd_convenio = nConvenio
       AND (tab_convenio.cd_con_pla = nPlano or tab_convenio.cd_con_pla is null)
       AND tab_convenio.cd_pro_fat = cProFat
       and tab_convenio.cd_multi_empresa = nMultiEmp
	   AND (tab_convenio.cd_prestador = pnPrest or tab_convenio.cd_prestador is null)
	   AND (tab_convenio.cd_setor = pnSet or tab_convenio.cd_setor is null)
	   AND (tab_convenio.cd_regra = pnRegra or tab_convenio.cd_regra is null)
       AND tab_convenio.dt_vigencia = ( SELECT MAX( tab_conv.dt_vigencia )
                                                FROM dbamv.tab_convenio tab_conv
                                               WHERE tab_conv.sn_ativo = 'S'
                                                 AND tab_conv.cd_convenio = nConvenio
                                                 AND (tab_conv.cd_con_pla = nPlano or tab_conv.cd_con_pla is null)
                                                 AND tab_conv.cd_pro_fat = cProFat
                                                 AND tab_conv.dt_vigencia <= dReferencia
                                                 and tab_conv.cd_multi_empresa = nMultiEmp
                                       AND (tab_conv.cd_regra = pnRegra or tab_conv.cd_regra is null) -- PDA 520412 - 19/06/2012 - Raphanelli de Barros
                           					 	 AND (tab_conv.cd_prestador = pnPrest or tab_conv.cd_prestador is null)
                           					 	 AND (tab_conv.cd_setor = pnSet or tab_conv.cd_setor is null)
						)
    ORDER BY 8,6,7,5 DESC;


  /* pda 354906 - 16/03/2010 - Amalia Ara?jo
     - apenas criada a coluna NR_ORDEM porque utiliza o mesmo ROWTYPE que o outro cursor */
  /* PDA 263722 (Inicio) - Jamerson Nunes Delfino - 10/12/2008 */
  CURSOR C_TabConvenio_429( nConvenio IN NUMBER,
                            nPlano IN NUMBER,
                            cProFat IN VARCHAR2,
                            dReferencia IN DATE,
                			pnPrest	in number,
		         			pnSet	in number,
                            pcdregra in number
				  ) IS
    SELECT NVL( tab_convenio.vl_tab_convenio, 0 ) vl_tab_convenio,
           tab_convenio.sn_usar_indice,
           tab_convenio.sn_horario_especial,
           tab_convenio.sn_filme,
           tab_convenio.cd_regra,
           /* PDA 262472 (Inicio) - Henrique Antunes - 03/12/2008 */
           tab_convenio.cd_prestador,
           tab_convenio.cd_setor
           /* PDA 262742 (Fim) */
	   ,'1' nr_ordem
      FROM dbamv.tab_convenio
     WHERE tab_convenio.sn_ativo = 'S'
       AND tab_convenio.cd_convenio = nConvenio
       /* pda 95672 - 07/12/2004 - Amalia Ara?jo - considerar registro com plano nulo
          AND tab_convenio.cd_con_pla = nPlano  */
       /* PDA 262472 (Inicio) - Henrique Antunes - 03/12/2008 */
       AND tab_convenio.cd_con_pla = nPlano
       AND tab_convenio.cd_pro_fat = cProFat
       AND tab_convenio.cd_regra = pcdregra
       and tab_convenio.cd_multi_empresa = nMultiEmp /* pda 110783 (considerar exce??es  baseadas na multi_empresa logada) */
       /* PDA 108041 06/11/2004 Sp?ndola (INICIO) Inserido o filtro por prestador e PDA 108039 por setor */
       AND (tab_convenio.cd_prestador = pnPrest or tab_convenio.cd_prestador is null)
	   AND (tab_convenio.cd_setor = pnSet or tab_convenio.cd_setor is null)
       AND tab_convenio.dt_vigencia = ( SELECT MAX( tab_conv.dt_vigencia )
                                                FROM dbamv.tab_convenio tab_conv
                                               WHERE tab_conv.sn_ativo = 'S'
                                                 AND tab_conv.cd_convenio = nConvenio
                                                 /* pda 95672 - 07/12/2004 - Amalia Ara?jo - considerar registro com plano nulo
                                                 AND tab_conv.cd_con_pla = nPlano  */
                                                 /* PDA 262472 (Inicio) - Henrique Antunes - 03/12/2008 */
                                                 AND tab_conv.cd_con_pla = nPlano
                                                 AND tab_conv.cd_pro_fat = cProFat
                                                 AND tab_conv.cd_regra = pcdregra
                                                 AND tab_conv.dt_vigencia <= dReferencia
                                                 and tab_conv.cd_multi_empresa = nMultiEmp /* pda 110783 (considerar exce??es  baseadas na multi_empresa logada) */
                                                 /* PDA 108041 06/11/2004 Sp?ndola (INICIO) Inserido o filtro por prestador e PDA 108039 por setor */
                                                 AND (tab_conv.cd_prestador = pnPrest or tab_conv.cd_prestador is null)
                           					 	 AND (tab_conv.cd_setor = pnSet or tab_conv.cd_setor is null)
						)
    /* PDA 262472 (Inicio) - Henrique Antunes - 03/12/2008 */
    union
    SELECT NVL( tab_convenio.vl_tab_convenio, 0 ) vl_tab_convenio,
                tab_convenio.sn_usar_indice,
                tab_convenio.sn_horario_especial,
                tab_convenio.sn_filme,
                tab_convenio.cd_regra,
                /* PDA 262472 (Inicio) - Henrique Antunes - 03/12/2008 */
                tab_convenio.cd_prestador,
                tab_convenio.cd_setor
                /* PDA 262742 (Fim) */
    	       ,'1' nr_ordem
           FROM dbamv.tab_convenio
          WHERE tab_convenio.sn_ativo = 'S'
            AND tab_convenio.cd_convenio = nConvenio
            AND tab_convenio.cd_con_pla is null
            AND tab_convenio.cd_pro_fat = cProFat
            AND tab_convenio.cd_regra = pcdregra
            and tab_convenio.cd_multi_empresa = nMultiEmp
			AND (tab_convenio.cd_prestador = pnPrest or tab_convenio.cd_prestador is null)
			AND (tab_convenio.cd_setor = pnSet or tab_convenio.cd_setor is null)
            AND tab_convenio.dt_vigencia = ( SELECT MAX( tab_conv.dt_vigencia )
                                                FROM dbamv.tab_convenio tab_conv
                                               WHERE tab_conv.sn_ativo = 'S'
                                                 AND tab_conv.cd_convenio = nConvenio
                                                 AND tab_conv.cd_con_pla is null
                                                 AND tab_conv.cd_pro_fat = cProFat
                                                 AND tab_conv.cd_regra = pcdregra
                                                 AND tab_conv.dt_vigencia <= dReferencia
                                                 and tab_conv.cd_multi_empresa = nMultiEmp
                           					 	 AND (tab_conv.cd_prestador = pnPrest or tab_conv.cd_prestador is null)
                           					 	 AND (tab_conv.cd_setor = pnSet or tab_conv.cd_setor is null))
            ORDER BY 6,7,5  DESC;
  /* PDA 263722 (Fim) -  Jamerson Nunes Delfino - 10/12/2008  */
  --
  --
  CURSOR c_acresdesc(nregra IN NUMBER, ngrupro IN NUMBER, ctpatdt IN VARCHAR2,dDtVigencia IN Date) IS
    SELECT NVL(acresc_descontos.vl_perc_acrescimo, 0) vl_perc_acrescimo
         , NVL(acresc_descontos.vl_perc_desconto, 0) vl_perc_desconto
         , NVL(acresc_descontos.sn_vl_filme, 'S') sn_vl_filme
         , NVL(acresc_descontos.sn_vl_honorario, 'S') sn_vl_honorario
         , NVL(acresc_descontos.sn_vl_operacional, 'S') sn_vl_operacional
         , DECODE(
             ctpatdt
           , 'E', acresc_descontos.tp_atend_externo
           , 'U', acresc_descontos.tp_atend_urgeme
           , 'I', acresc_descontos.tp_atend_internacao
           , 'A', acresc_descontos.tp_atend_ambulatorial
           , 'H', acresc_descontos.tp_atend_homecare) sn_acres_desc
    FROM   dbamv.acresc_descontos
     WHERE acresc_descontos.cd_regra(+) = nregra AND acresc_descontos.cd_gru_pro(+) = ngrupro
       AND trunc(dDtVigencia) BETWEEN trunc(dt_inicio_vigencia) AND Nvl(trunc(dt_final_vigencia), trunc(dDtVigencia)) ; -- Berenguer (trocar sysdate pelo parametro e truncar tudo)
  --
  CURSOR c_regra(nconvenio IN NUMBER, nplano IN DBAMV.EMPRESA_CON_PLA.CD_CON_PLA%TYPE /*NUMBER PDA 254997*/, ntpaco IN NUMBER) IS
    SELECT regra.cd_regra
         , indice_acomodacao.vl_percentual_pago vl_percentual_sp
         , indice_acomodacao.vl_percentual_sd
         , indice_acomodacao.vl_percentual_sh
         , regra.sn_paga_horario_especial
      FROM dbamv.con_pla
         , dbamv.regra
         , dbamv.indice_acomodacao
         , dbamv.empresa_con_pla                                             /* PDA 118607/131598 */
     WHERE empresa_con_pla.cd_convenio      = con_pla.cd_convenio            /* PDA 118607/131598 */
       AND empresa_con_pla.cd_con_pla       = con_pla.cd_con_pla             /* PDA 118607/131598 */
       AND empresa_con_pla.cd_multi_empresa = nEmpresa /* OP 1501 dbamv.pkg_mv2000.le_empresa*/
                                                                             /* PDA 118607/131598 */
       AND empresa_con_pla.cd_convenio = nconvenio
       AND empresa_con_pla.cd_con_pla  = nplano
       AND empresa_con_pla.cd_regra    = regra.cd_regra(+)
       AND regra.cd_regra = indice_acomodacao.cd_regra(+) AND indice_acomodacao.cd_tip_acom(+) = ntpaco;
  --
  CURSOR c_regraexplicita(nregra IN NUMBER, ntpaco IN NUMBER) IS
    SELECT regra.cd_regra
         , regra.sn_paga_horario_especial
         , indice_acomodacao.vl_percentual_pago vl_percentual_sp
         , indice_acomodacao.vl_percentual_sd
         , indice_acomodacao.vl_percentual_sh
      FROM dbamv.regra
         , dbamv.indice_acomodacao
     WHERE regra.cd_regra = nregra AND regra.cd_regra = indice_acomodacao.cd_regra(+)
           AND indice_acomodacao.cd_tip_acom(+) = ntpaco;
  --
  CURSOR c_grupro(cprofat IN VARCHAR2) IS
    SELECT gru_pro.cd_gru_pro, gru_pro.tp_gru_pro, pro_fat.cd_por_ane
      FROM dbamv.pro_fat
         , dbamv.gru_pro
     WHERE pro_fat.cd_gru_pro = gru_pro.cd_gru_pro AND pro_fat.cd_pro_fat = cprofat;
  --
  CURSOR c_por_ane_tab(cprofat IN VARCHAR2, dreferencia IN DATE, nregra IN NUMBER, ngrupro IN NUMBER) IS
    SELECT por_ane_tab.cd_por_ane
      FROM dbamv.por_ane_tab
         , dbamv.itregra
     WHERE itregra.cd_regra = nregra AND itregra.cd_gru_pro = ngrupro
           AND por_ane_tab.cd_tab_fat = itregra.cd_tab_fat AND por_ane_tab.cd_pro_fat = cprofat
           AND por_ane_tab.dt_vigencia =
                (SELECT MAX(porte.dt_vigencia)
                   FROM dbamv.por_ane_tab porte
                      , dbamv.itregra itregra
                  WHERE itregra.cd_regra = nregra AND itregra.cd_gru_pro = ngrupro
                        AND porte.cd_tab_fat = itregra.cd_tab_fat AND porte.cd_pro_fat = cprofat
                        AND porte.dt_vigencia <= dreferencia);
  --
  /* -- PDA.: 277331 - 17/03/2009 - Emanoel Deivison (inicio)
    Adicionado um NVL na coluna: "tp_hor_esp_sd" (tipo de hor?rio especial SD) do cursor: "c_itregra" para que quando a mesma vier nula preencher com o valor: "T"
    onde T = "Total" e H = "Honor?rio". Essas altera??es foram efetuadas devido ao relat?rio: "R_FATURA_GRU_FAT" N?o est? efetuando quebra de forma correta por
    causa do hor?rio especial. Pois algumas vezes o campo: "tp_hor_esp_sd" estava chegando nulo.
  */
  CURSOR c_itregra(nregra IN NUMBER, ngrupro IN NUMBER) IS
    SELECT NVL(itregra.vl_percetual_pago, 0) vl_percentual_itregra
         , itregra.cd_tab_fat
         , tab_fat.tp_tab_fat
         , nvl(itregra.tp_hor_esp_sd, 'T') tp_hor_esp_sd
         , itregra.cd_horario
         ,
       /* Inicio PDA 115562 - 04/04/2005 - Elias
           inserida esta coluna para calcular de acordo com o tipo do valor base, j? que o hospital pode trabalhar com
           valores diferentes em relacao a porte medico*/
           itregra.tp_valor_base
    FROM   dbamv.itregra
         , dbamv.tab_fat
     WHERE itregra.cd_tab_fat = tab_fat.cd_tab_fat AND itregra.cd_tab_fat = tab_fat.cd_tab_fat
           AND itregra.cd_regra = nregra AND itregra.cd_gru_pro = ngrupro;
  --
  CURSOR c_indice(nindice IN NUMBER, dreferencia IN DATE, ngrupro IN NUMBER, ctpatend IN VARCHAR2) IS
    SELECT NVL(val_indice_gru_pro.vl_indice
           , NVL(val_indice_tp_atend.vl_indice, val_indice.vl_indice)) vl_ind
         , NVL(val_indice_gru_pro.vl_honorario
           , NVL(val_indice_tp_atend.vl_honorario, val_indice.vl_honorario)) vl_honor
         , NVL(val_indice_gru_pro.vl_m2filme
           , NVL(val_indice_tp_atend.vl_m2filme, val_indice.vl_m2filme)) vl_m2filme
         ,
           NVL(val_indice_gru_pro.vl_uco, NVL(val_indice_tp_atend.vl_uco, val_indice.vl_uco)) vl_uco
    FROM   dbamv.indice
         , dbamv.val_indice
         , dbamv.val_indice_gru_pro
         , dbamv.val_indice_tp_atend
     WHERE indice.cd_indice = nindice AND indice.cd_indice = val_indice.cd_indice(+)
           AND val_indice.cd_val_indice = val_indice_gru_pro.cd_val_indice(+) AND val_indice_gru_pro.cd_gru_pro(+) =
                                                                                             ngrupro
           AND DECODE(val_indice_gru_pro.tp_atendimento(+), 'T', ctpatend, val_indice_gru_pro.tp_atendimento(+)) =
                                                                                            ctpatend
           AND val_indice_tp_atend.tp_atendimento(+) = ctpatend AND val_indice.cd_val_indice = val_indice_tp_atend.cd_val_indice(+)
           AND val_indice.dt_vigencia =
                                  (SELECT MAX(val.dt_vigencia)
                                     FROM dbamv.val_indice val
                                    WHERE val.cd_indice = nindice AND val.dt_vigencia <= dreferencia)
           AND val_indice.cd_val_indice = val_indice_gru_pro.cd_val_indice(+);
  CURSOR c_porteanest(nporte IN NUMBER, ntabfat IN NUMBER, dreferencia IN DATE) IS
    SELECT NVL(vl_porte, 0) vl_porte
      FROM dbamv.val_porte
     WHERE val_porte.cd_por_ane = nporte AND val_porte.cd_tab_fat = ntabfat
       AND val_porte.dt_vigencia =
                (SELECT MAX(vl_por.dt_vigencia)
                   FROM dbamv.val_porte vl_por
                  WHERE vl_por.cd_por_ane = nporte AND vl_por.cd_tab_fat = ntabfat
                        AND vl_por.dt_vigencia <= dreferencia);
  --
  CURSOR c_horesp(
    nhoresp  IN  NUMBER
  , nregra   IN  NUMBER
  , ndia     IN  NUMBER
  , dhora    IN  DATE
  , ctpatdt  IN  VARCHAR2) IS
    SELECT ithorario_especial.cd_horario
         , DECODE(
             ctpatdt
           , 'E', regra.tp_atend_externo
           , 'U', regra.tp_atend_urgeme
           , 'I', regra.tp_atend_internacao
           , 'A', regra.tp_atend_ambulatorial
           , 'H', regra.tp_atend_homecare) sn_hor_esp
      FROM dbamv.ithorario_especial
         , dbamv.regra
     WHERE ithorario_especial.cd_horario = nhoresp AND regra.cd_regra = nregra
           AND ithorario_especial.cd_dia = ndia
           AND TO_CHAR(dhora, 'hh24:mi') BETWEEN TO_CHAR(ithorario_especial.hr_inicio, 'hh24:mi')
                                             AND TO_CHAR(ithorario_especial.hr_fim, 'hh24:mi');
  --
  -- OP 19240 - 08/05/2014 - implementa??o da tabela FERIADO_EMPRESA
  CURSOR c_feriado(ddatareferencia IN DATE) IS
    SELECT feriado.ds_feriado
      FROM dbamv.feriado
     WHERE feriado.nr_dia = TO_CHAR(ddatareferencia, 'dd')
       AND feriado.nr_mes = TO_CHAR(ddatareferencia, 'mm')
       AND((feriado.nr_ano = 0) OR(feriado.nr_ano = TO_CHAR(ddatareferencia, 'yyyy')))
	   AND ( EXISTS (SELECT 1 FROM dbamv.feriado_empresa
		    		   WHERE cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
						 AND FERIADO.CD_FERIADO = FERIADO_EMPRESA.CD_FERIADO)
		  OR NOT EXISTS (SELECT 1 FROM DBAMV.FERIADO_EMPRESA
						  WHERE FERIADO.CD_FERIADO = FERIADO_EMPRESA.CD_FERIADO)
			 )
		   ;
  --
  CURSOR c_perchoresp(nhorario IN NUMBER) IS
    SELECT horario_especial.vl_percentual
      FROM dbamv.horario_especial
     WHERE horario_especial.cd_horario = nhorario;
  --
  CURSOR c_atimed IS
    SELECT ati_med.vl_percentual_pago, ati_med.tp_funcao
      FROM dbamv.ati_med
     WHERE ati_med.cd_ati_med = ctpatimed;
  --
  CURSOR c_tabfilme(ntabfat IN NUMBER, dreferencia IN DATE) IS
    SELECT filme_tab.qt_m2_filme
      FROM dbamv.filme_tab
     WHERE filme_tab.cd_tab_fat = ntabfat AND filme_tab.cd_pro_fat = vprofat
           AND filme_tab.dt_vigencia =
                (SELECT MAX(filme.dt_vigencia)
                   FROM dbamv.filme_tab filme
                  WHERE filme.cd_tab_fat = ntabfat AND filme.cd_pro_fat = vprofat
                        AND filme.dt_vigencia <= dreferencia);
  --
  CURSOR c_indice_profat(
    cprofat      IN  VARCHAR2
  , nregra       IN  NUMBER
  , ngrupro      IN  NUMBER
  , ncdtip_acom  IN  NUMBER) IS
    SELECT   indice_pro_fat.vl_percentual
        FROM dbamv.indice_pro_fat
       WHERE indice_pro_fat.cd_regra = nregra
             AND(indice_pro_fat.cd_pro_fat = cprofat OR indice_pro_fat.cd_pro_fat IS NULL)
             AND(indice_pro_fat.cd_tip_acom = ncdtip_acom OR indice_pro_fat.cd_tip_acom IS NULL)
             AND(indice_pro_fat.cd_gru_pro = ngrupro OR indice_pro_fat.cd_gru_pro IS NULL)
    ORDER BY NVL(cd_pro_fat, 0) DESC
           , NVL(cd_tip_acom, 0) DESC;
  --
  CURSOR c_valexced(dreferencia IN DATE, nregra IN NUMBER) IS
    SELECT val_exced.qt_inicial
         , val_exced.qt_subsequente
         , val_exced.vl_subsequente
         , val_exced.vl_percentual_sub
      FROM dbamv.val_exced
     WHERE val_exced.cd_pro_fat = NVL(cprofatexced, vprofat) AND val_exced.cd_regra = nregra
           AND val_exced.dt_vigencia =
                (SELECT MAX(exced.dt_vigencia)
                   FROM dbamv.val_exced exced
                  WHERE exced.cd_pro_fat = NVL(cprofatexced, vprofat) AND exced.cd_regra = nregra
                        AND exced.dt_vigencia <= dreferencia);
  --
  CURSOR csomaregtotal(ncta IN DBAMV.ITREG_FAT.CD_REG_FAT%TYPE /*NUMBER PDA 254997*/) IS
    SELECT SUM(itreg_fat.qt_lancamento) total
      FROM dbamv.itreg_fat
     WHERE itreg_fat.cd_reg_fat = ncta AND itreg_fat.cd_pro_fat = vprofat
                                                                         /* union all
                                                                          select sum(itreg_amb.qt_lancamento) total
                                                                            from dbamv.itreg_amb
                                                                           where itreg_amb.cd_reg_amb     =  nCta
                                                                             and itreg_amb.cd_atendimento = nAtend
                                                                             and itreg_amb.cd_pro_fat     = cProcedimento*/
  ;

  /*Cursor cSomaRegAtualH( nCta in Number, nAtend in Number, nLanc in Number ) is
    select sum(itreg_fat.qt_lancamento) total
      from dbamv.itreg_fat
     where itreg_fat.cd_reg_fat     =  nCta
       and itreg_fat.cd_lancamento  <= nLanc
       and itreg_fat.cd_pro_fat     = cProcedimento
     order by itreg_Fat.cd_reg_fat, itreg_fat.cd_lancamento;

  Cursor cSomaRegAtualA( nCta in Number, nAtend in Number, nLanc in Number ) is
    select sum(itreg_amb.qt_lancamento) total
      from dbamv.itreg_amb
     where itreg_amb.cd_reg_amb     =  nCta
       and itreg_amb.cd_atendimento = nAtend
       and itreg_amb.cd_lancamento  <= nLanc
       and itreg_amb.cd_pro_fat     = cProcedimento
     order by itreg_amb.cd_reg_amb, itreg_amb.cd_lancamento;*/
  --
  CURSOR c_franquia IS
    SELECT franquias.vl_particip, franquias.qt_pontos,
           franquias.vl_perc_particip                             /* pda 369072 - Amalia Ara?jo - 07/06/2010 */
      FROM dbamv.franquias
     WHERE franquias.cd_franquia = ncdfranquia
       AND ( (franquias.cd_gru_pro IS NULL and franquias.qt_pontos is not null)
           or franquias.vl_particip is not null
	   or franquias.vl_perc_particip is not null            /* pda 369072 - Amalia Ara?jo - 07/06/2010 */
	   );
  --
  CURSOR c_convpla IS
    SELECT empresa_con_pla.cd_indice
      FROM dbamv.convenio
         , dbamv.con_pla
         , dbamv.empresa_con_pla                                             /* PDA 118607/131598 */
     WHERE empresa_con_pla.cd_convenio = con_pla.cd_convenio                 /* PDA 118607/131598 */
           AND empresa_con_pla.cd_con_pla = con_pla.cd_con_pla               /* PDA 118607/131598 */
           AND empresa_con_pla.cd_multi_empresa = nEmpresa /*OP 1501 dbamv.pkg_mv2000.le_empresa*/
                                                                             /* PDA 118607/131598 */
           AND convenio.cd_convenio = ncodconvenio AND con_pla.cd_convenio = convenio.cd_convenio
           AND con_pla.cd_con_pla = ncodplano AND ncdconta IS NULL
    UNION
    SELECT empresa_con_pla.cd_indice
      FROM dbamv.convenio
         , dbamv.con_pla
         , dbamv.empresa_con_pla                                             /* PDA 118607/131598 */
     WHERE empresa_con_pla.cd_convenio = con_pla.cd_convenio                 /* PDA 118607/131598 */
           AND empresa_con_pla.cd_con_pla = con_pla.cd_con_pla               /* PDA 118607/131598 */
           AND empresa_con_pla.cd_multi_empresa IN(SELECT cd_multi_empresa
                                                     FROM dbamv.reg_fat
                                                    WHERE cd_reg_fat = ncdconta)
           AND convenio.cd_convenio = ncodconvenio AND con_pla.cd_convenio = convenio.cd_convenio
           AND con_pla.cd_con_pla = ncodplano AND ctipoatend = 'I'
    UNION
    SELECT empresa_con_pla.cd_indice
      FROM dbamv.convenio
         , dbamv.con_pla
         , dbamv.empresa_con_pla                                             /* PDA 118607/131598 */
     WHERE empresa_con_pla.cd_convenio = con_pla.cd_convenio                 /* PDA 118607/131598 */
           AND empresa_con_pla.cd_con_pla = con_pla.cd_con_pla               /* PDA 118607/131598 */
           AND empresa_con_pla.cd_multi_empresa IN(SELECT cd_multi_empresa
                                                     FROM dbamv.reg_amb
                                                    WHERE cd_reg_amb = ncdconta)
           AND convenio.cd_convenio = ncodconvenio AND con_pla.cd_convenio = convenio.cd_convenio
           AND con_pla.cd_con_pla = ncodplano AND ctipoatend <> 'I';
  --
  CURSOR c_acoplam IS
    SELECT reg_acop.vl_percentual
         , reg_acop.vl_particip
         , reg_acop.qt_pontos
         , reg_acop.cd_convenio_conta
         , reg_acop.cd_con_pla_conta
         , reg_acop.cd_convenio
         , reg_acop.cd_con_pla
      FROM dbamv.regra_acoplamento reg_acop
         , dbamv.empresa_convenio                                             /* pda 118607/130316*/
     WHERE reg_acop.cd_convenio = empresa_convenio.cd_convenio                /* pda 118607/130316*/
           AND empresa_convenio.cd_multi_empresa = nEmpresa /*OP 1501 dbamv.pkg_mv2000.le_empresa*/
                                                                              /* pda 118607/130316*/
           AND reg_acop.cd_regra_acoplamento = ncdregraacop;
  --
  CURSOR c_hospital IS
    SELECT cd_hospital
      FROM dbamv.hospital
     WHERE hospital.cd_multi_empresa =  nEmpresa; /*OP 1501 dbamv.pkg_mv2000.le_empresa;*/
  --
  CURSOR c_acresdesc_proc(nregra IN NUMBER, cprofat IN VARCHAR2, ctpatdt IN VARCHAR2,dDtVigencia IN Date) IS
    SELECT NVL(acresc_descontos_proc.vl_perc_acrescimo, 0) vl_perc_acrescimo
         , NVL(acresc_descontos_proc.vl_perc_desconto, 0) vl_perc_desconto
         , NVL(acresc_descontos_proc.sn_vl_filme, 'S') sn_vl_filme
         , NVL(acresc_descontos_proc.sn_vl_honorario, 'S') sn_vl_honorario
         , NVL(acresc_descontos_proc.sn_vl_operacional, 'S') sn_vl_operacional
         , DECODE(
             ctpatdt
           , 'E', acresc_descontos_proc.tp_atend_externo
           , 'U', acresc_descontos_proc.tp_atend_urgeme
           , 'I', acresc_descontos_proc.tp_atend_internacao
           , 'A', acresc_descontos_proc.tp_atend_ambulatorial
           , 'H', acresc_descontos_proc.tp_atend_homecare) sn_acres_desc
    FROM   dbamv.acresc_descontos_proc
     WHERE acresc_descontos_proc.cd_regra(+) = nregra AND acresc_descontos_proc.cd_pro_fat(+) = cprofat
       AND trunc(dDtVigencia) BETWEEN trunc(dt_inicio_vigencia) AND Nvl(trunc(dt_final_vigencia), trunc(dDtVigencia));
  --
  /* Porte de Ato Médico vigente para o Procedimento. */
  CURSOR cpormed IS
    SELECT p.cd_porte_medico, p.ds_porte_medico
      FROM dbamv.pro_fat_hierarquizado v
         , dbamv.porte_medico p
     WHERE v.cd_pro_fat = vprofat AND v.cd_porte_medico = p.cd_porte_medico;
  --
  /* Valor do Porte de Ato Médico vigente para a tabela de faturamento. */
  CURSOR cvalpormed(npormed IN NUMBER, ntabfat IN NUMBER) IS
    SELECT vl_porte_medico
      FROM dbamv.val_porte_medico
     WHERE cd_tab_fat = ntabfat AND cd_porte_medico = npormed
           AND TRUNC(dt_vigencia) =
                (SELECT TRUNC(MAX(v.dt_vigencia))
                   FROM dbamv.val_porte_medico v
                  WHERE v.cd_tab_fat = ntabfat AND v.cd_porte_medico = npormed
                        AND TRUNC(v.dt_vigencia) <= TRUNC(vddatarefer));
  --
  /* Valor do Custo Operacional vigente para a tabela de faturamento. */
  CURSOR cvaluco(ntabfat IN NUMBER) IS
    SELECT vl_uco
      FROM dbamv.val_uco
     WHERE cd_tab_fat = ntabfat
           AND TRUNC(dt_vigencia) =
                         (SELECT TRUNC(MAX(v.dt_vigencia))
                            FROM dbamv.val_uco v
                           WHERE v.cd_tab_fat = ntabfat AND TRUNC(v.dt_vigencia) <= TRUNC(vddatarefer));
  --
  /* Exce??es de Porte de Ato M?dico vigente para o Procedimento e tabela de faturamento. */
  CURSOR cpormedprofat(ntabfat IN NUMBER) IS
    SELECT p.cd_porte_medico, p.ds_porte_medico
      FROM dbamv.porte_medico_pro_fat e
         , dbamv.porte_medico p
     WHERE e.cd_tab_fat = ntabfat AND e.cd_pro_fat = vprofat
           AND e.cd_porte_medico = p.cd_porte_medico
           AND TRUNC(e.dt_vigencia) =
                (SELECT TRUNC(MAX(v.dt_vigencia))
                   FROM dbamv.porte_medico_pro_fat v
                  WHERE v.cd_tab_fat = ntabfat AND v.cd_pro_fat = vprofat
                        AND TRUNC(v.dt_vigencia) <= TRUNC(vddatarefer));
  --
  CURSOR c_itregra_porte(nregra IN NUMBER, ngrupro IN NUMBER) IS
    SELECT itregra.cd_tab_fat
      FROM dbamv.itregra
     WHERE itregra.cd_regra = nregra AND itregra.cd_gru_pro = ngrupro;
  --
  ncdtabfatporte        NUMBER;
  --
  CURSOR catend(ncta IN DBAMV.ITREG_AMB.CD_REG_AMB%TYPE /*NUMBER PDA 254997*/,
                nlct IN DBAMV.ITREG_AMB.CD_LANCAMENTO%TYPE /*NUMBER PDA 254997*/) IS
    SELECT i.cd_atendimento
      FROM dbamv.itreg_amb i
     WHERE i.cd_reg_amb = ncta AND i.cd_lancamento = nlct;
  --
  CURSOR cregraatend IS
    SELECT convenio.sn_regra_atendimento_conta
      FROM dbamv.convenio
     WHERE cd_convenio = ncodconvenio;
  --
  /* Cursor para pegar o primeiro lan?amento na conta hospitalar. */
  CURSOR clancminhosp(pncdgrupro IN NUMBER) IS
    SELECT MIN(itreg_fat.cd_lancamento)
      FROM dbamv.itreg_fat
         , dbamv.pro_fat
     WHERE itreg_fat.cd_reg_fat = ncdconta AND pro_fat.cd_gru_pro = pncdgrupro
           AND pro_fat.cd_pro_fat = itreg_fat.cd_pro_fat AND itreg_fat.sn_pertence_pacote = 'N'
           AND NVL(itreg_fat.tp_pagamento, 'P') <> 'C';
  --
  /* Cursor para pegar o primeiro lan?amento na conta ambulatorial. */
  CURSOR clancminamb(pncdgrupro IN NUMBER) IS
    SELECT MIN(itreg_amb.cd_lancamento)
      FROM dbamv.itreg_amb
         , dbamv.pro_fat
     WHERE itreg_amb.cd_reg_amb = ncdconta AND pro_fat.cd_gru_pro = pncdgrupro
        AND pro_fat.cd_pro_fat = itreg_amb.cd_pro_fat
        AND itreg_amb.cd_atendimento =
                                     (SELECT cd_atendimento
                                        FROM dbamv.itreg_amb
                                       WHERE cd_lancamento = ncdlancamento AND cd_reg_amb = ncdconta)
        AND itreg_amb.sn_pertence_pacote = 'N' AND NVL(itreg_amb.tp_pagamento, 'P') <> 'C';
  --
  CURSOR cvlpercent(pncdtabfat IN NUMBER, pncdgrupro IN NUMBER) IS
    SELECT vl_percentual
      FROM dbamv.tab_fat_gru_pro
     WHERE cd_tab_fat = pncdtabfat AND cd_gru_pro = pncdgrupro;
  --
  ncdatend              NUMBER                                               := 0;
  --
  CURSOR c_valentrega IS
    SELECT ender_coleta_entrega.vl_servico
      FROM dbamv.ender_coleta_entrega
         , dbamv.itreg_fat
     WHERE itreg_fat.cd_lancamento = ncdlancamento AND itreg_fat.cd_reg_fat = ncdconta
       AND itreg_fat.tp_mvto = 'SADT' AND itreg_fat.cd_mvto = ender_coleta_entrega.cd_ped_lab
       AND itreg_fat.cd_itmvto = ender_coleta_entrega.cd_ped_lab_ender
    UNION
    SELECT ender_coleta_entrega.vl_servico
      FROM dbamv.ender_coleta_entrega
         , dbamv.itreg_fat
     WHERE itreg_fat.cd_lancamento = ncdlancamento AND itreg_fat.cd_reg_fat = ncdconta
           AND itreg_fat.tp_mvto = 'Imagem' AND itreg_fat.cd_mvto = ender_coleta_entrega.cd_ped_rx
           AND itreg_fat.cd_itmvto = ender_coleta_entrega.cd_ped_lab_ender
    UNION
    SELECT ender_coleta_entrega.vl_servico
      FROM dbamv.ender_coleta_entrega
         , dbamv.itreg_amb
     WHERE itreg_amb.cd_lancamento = ncdlancamento AND itreg_amb.cd_reg_amb = ncdconta
           AND itreg_amb.tp_mvto = 'SADT' AND itreg_amb.cd_mvto = ender_coleta_entrega.cd_ped_lab
           AND itreg_amb.cd_itmvto = ender_coleta_entrega.cd_ped_lab_ender
    UNION
    SELECT ender_coleta_entrega.vl_servico
      FROM dbamv.itreg_amb
         , dbamv.ender_coleta_entrega
     WHERE itreg_amb.cd_lancamento = ncdlancamento AND itreg_amb.cd_reg_amb = ncdconta
           AND itreg_amb.tp_mvto = 'Imagem' AND itreg_amb.cd_mvto = ender_coleta_entrega.cd_ped_rx
           AND itreg_amb.cd_itmvto = ender_coleta_entrega.cd_ped_lab_ender;
  --
  CURSOR c_procentrega IS
    SELECT config_pssd.cd_pro_fat_coleta cd_pro_fat
      FROM dbamv.config_pssd
     WHERE config_pssd.cd_multi_empresa = nEmpresa /*OP 1501 dbamv.pkg_mv2000.le_empresa*/
           AND config_pssd.cd_pro_fat_coleta = vprofat
    UNION
    SELECT config_pssd.cd_pro_fat_laudo cd_pro_fat
      FROM dbamv.config_pssd
     WHERE config_pssd.cd_multi_empresa = nEmpresa /*OP 1501 dbamv.pkg_mv2000.le_empresa*/
           AND config_pssd.cd_pro_fat_laudo = vprofat
    UNION
    SELECT config_psdi.cd_pro_fat_laudo cd_pro_fat
      FROM dbamv.config_psdi
     WHERE config_psdi.cd_multi_empresa = nEmpresa /*OP 1501 dbamv.pkg_mv2000.le_empresa*/
           AND config_psdi.cd_pro_fat_laudo = vprofat;
  --
  CURSOR c_pacote IS
    SELECT DECODE(
             conta_pacote.sn_principal
           , 'S', 1
           ,
             dbamv.pkg_ffcv_it_conta.fnc_retorna_percentual_pacote(reg_fat.cd_atendimento
             , itreg_fat.cd_reg_fat, itreg_fat.cd_lancamento)) vl_perc_pac_secund
    ,      pacote.cd_pacote cd_pacote
         , reg_fat.cd_atendimento
      FROM dbamv.conta_pacote
         , dbamv.pacote
         , dbamv.itreg_fat
         , dbamv.reg_fat
     WHERE conta_pacote.cd_lancamento_fat = ncdlancamento AND conta_pacote.cd_reg_fat = ncdconta
           AND conta_pacote.cd_pacote = pacote.cd_pacote
           AND conta_pacote.cd_lancamento_fat = itreg_fat.cd_lancamento
           AND conta_pacote.cd_reg_fat = itreg_fat.cd_reg_fat
           AND reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat
           AND EXISTS(
                SELECT 'x'
                  FROM dbamv.itreg_fat l
                 WHERE l.cd_reg_fat = conta_pacote.cd_reg_fat
                       AND l.cd_conta_pacote = conta_pacote.cd_conta_pacote)
    UNION
    SELECT DECODE(
             conta_pacote.sn_principal
           , 'S', 1
           ,
             dbamv.pkg_ffcv_it_conta.fnc_retorna_percentual_pacote(itreg_amb.cd_atendimento
             , itreg_amb.cd_reg_amb, itreg_amb.cd_lancamento)) vl_perc_pac_secund
    ,      pacote.cd_pacote cd_pacote
         , itreg_amb.cd_atendimento
      FROM dbamv.conta_pacote
         , dbamv.pacote
         , dbamv.itreg_amb
     WHERE conta_pacote.cd_lancamento_amb = ncdlancamento AND conta_pacote.cd_reg_amb = ncdconta
           AND conta_pacote.cd_pacote = pacote.cd_pacote
           AND conta_pacote.cd_lancamento_amb = itreg_amb.cd_lancamento
           AND conta_pacote.cd_reg_amb = itreg_amb.cd_reg_amb
           AND EXISTS(
                SELECT 'x'
                  FROM dbamv.itreg_amb l
                 WHERE l.cd_reg_amb = conta_pacote.cd_reg_amb
                       AND l.cd_conta_pacote = conta_pacote.cd_conta_pacote);
  --
  CURSOR c_valorpacote(ncdpacote IN NUMBER, ncdatend IN NUMBER) IS
    SELECT vl_contrato_adiant
      FROM dbamv.contrato_adiantamento
     WHERE cd_pacote = ncdpacote AND cd_atendimento = ncdatend;
  --
  CURSOR c_agenda IS
    SELECT it_agenda_central.vl_negociado
      FROM dbamv.it_agenda_central
         , dbamv.itreg_amb
     WHERE itreg_amb.cd_lancamento = ncdlancamento AND itreg_amb.cd_reg_amb = ncdconta
           AND itreg_amb.cd_it_agenda_central = it_agenda_central.cd_it_agenda_central;
  --
  /* Percentual de acr?scimo da regra de Cobran?a do faturamento espec?fico para procedimentos que s?o exames.

     FFCV / TABELAS / Cobran?aS E TABELAS / REGRAS / 3-ACR?SCIMOS E DESCONTOS / 1-EXCE??O DE PROCEDIMENTOS
     PSDI / TABELAS / EXAMES
  */
  CURSOR cpercacresexame(nregra IN NUMBER, cprofat IN VARCHAR2, ctpatdt IN VARCHAR2) IS
    SELECT NVL(acresc_descontos_proc.vl_perc_acrescimo_exame, 0) vl_perc_acrescimo_exame
         , DECODE(
             ctpatdt
           , 'E', acresc_descontos_proc.tp_atend_externo
           , 'U', acresc_descontos_proc.tp_atend_urgeme
           , 'I', acresc_descontos_proc.tp_atend_internacao
           , 'A', acresc_descontos_proc.tp_atend_ambulatorial
           , 'H', acresc_descontos_proc.tp_atend_homecare) sn_incluir_acres_exame
      FROM dbamv.exa_rx
         , dbamv.acresc_descontos_proc
     WHERE acresc_descontos_proc.cd_regra(+) = nregra AND acresc_descontos_proc.cd_pro_fat(+) = cprofat
           AND exa_rx.exa_rx_cd_pro_fat = acresc_descontos_proc.cd_pro_fat
           AND NVL(exa_rx.sn_incluir_acresc, 'N') = 'S';
  --
  CURSOR cconvenioatendffis IS
    SELECT config_ffis.cd_convenio
      FROM dbamv.config_ffis
     WHERE config_ffis.cd_convenio = ncodconvenio
       AND cd_multi_empresa = nEmpresa ; /*OP 1501 dbamv.pkg_mv2000.le_empresa;*/
  --
  CURSOR cconvenioatendffas IS
    SELECT config_ffas.cd_convenio
      FROM dbamv.config_ffas
     WHERE config_ffas.cd_convenio = ncodconvenio
       AND cd_multi_empresa = nEmpresa ; /*OP 1501 dbamv.pkg_mv2000.le_empresa;*/
  --
  ncdconvatend          NUMBER                                               := NULL;
  v_percacresexame      cpercacresexame%ROWTYPE;
  --
  CURSOR cdadoscdgrufat IS
    SELECT gru_pro.cd_gru_fat
      FROM dbamv.gru_pro
         , dbamv.pro_fat
     WHERE pro_fat.cd_pro_fat = vprofat AND pro_fat.cd_gru_pro = gru_pro.cd_gru_pro;
  --
  CURSOR cdadosvlpercentual(ncdregra IN NUMBER, ngrupro IN NUMBER) IS
    SELECT horario_especial.vl_percentual,
           horario_especial.sn_replica_proc /*OP 35613 - 37315 - duplicar/inserir proc de HE na conta*/
      FROM dbamv.horario_especial
         , dbamv.regra
         , dbamv.itregra
    ,      dbamv.tab_fat
     WHERE itregra.cd_regra = regra.cd_regra
           AND itregra.cd_tab_fat = tab_fat.cd_tab_fat
           AND itregra.cd_horario = horario_especial.cd_horario AND itregra.cd_regra = ncdregra
           AND itregra.cd_gru_pro = ngrupro;
  --
  CURSOR cverconvprofat IS
    SELECT COUNT(*)
      FROM dbamv.convenio_pro_fat
     WHERE convenio_pro_fat.cd_convenio = ncodconvenio
       AND convenio_pro_fat.cd_pro_fat = cprocedimento;
  --
  nconvprofat           NUMBER;
  --
  CURSOR ccalcsemexcessao IS
    SELECT valor
      FROM dbamv.configuracao
     WHERE configuracao.cd_sistema = 'FFCV' AND configuracao.chave = 'SN_CALCULA_TAXA_EXCESSAO'
       AND configuracao.cd_multi_empresa = nEmpresa ; /*OP 1501 dbamv.pkg_mv2000.le_empresa;*/
  --
  vcalcsemexcessao      VARCHAR2(1);
  --
  -- pda 492733 - 10/02/2012 - Amalia Ara?jo - par?metro que indica se a acomoda??o ser? calculada no operacional cbhpm
  CURSOR cCalculaOperCbhpm IS
    SELECT valor
      FROM dbamv.configuracao
     WHERE configuracao.cd_sistema = 'FFCV' AND configuracao.chave = 'SN_CALCULA_ACOMODACAO_OPERACIONAL_CBHPM'
       AND configuracao.cd_multi_empresa = nEmpresa ; /*OP 1501 dbamv.pkg_mv2000.le_empresa;*/
  vCalculaOperCbhpm   varchar2(01);
  -- pda 492733 - fim
  --
  CURSOR c_tppagamento IS
    SELECT NVL(itreg_amb.tp_pagamento, 'P') tp_pagamento
      FROM dbamv.itreg_amb
     WHERE itreg_amb.cd_lancamento = ncdlancamento AND itreg_amb.cd_reg_amb = ncdconta
           AND ctipoatend IN('A', 'E', 'U')
    UNION
    SELECT NVL(itreg_fat.tp_pagamento, 'P') tp_pagamento
      FROM dbamv.itreg_fat
     WHERE itreg_fat.cd_lancamento = ncdlancamento AND itreg_fat.cd_reg_fat = ncdconta
           AND ctipoatend = 'I'
           AND NOT EXISTS(
                   SELECT 'x'
                     FROM dbamv.itlan_med
                    WHERE itlan_med.cd_reg_fat = ncdconta
                          AND itlan_med.cd_lancamento = ncdlancamento)
    UNION
    SELECT 'P' tp_pagamento
      FROM dbamv.itreg_fat
     WHERE itreg_fat.cd_lancamento = ncdlancamento AND itreg_fat.cd_reg_fat = ncdconta
           AND ctipoatend = 'I'
           AND EXISTS(
                SELECT 'x'
                  FROM dbamv.itlan_med
                 WHERE itlan_med.cd_reg_fat = ncdconta AND itlan_med.cd_lancamento = ncdlancamento
                       AND NVL(itlan_med.tp_pagamento, 'P') <> 'C')
    UNION
    SELECT 'C' tp_pagamento
      FROM dbamv.itreg_fat
     WHERE itreg_fat.cd_lancamento = ncdlancamento AND itreg_fat.cd_reg_fat = ncdconta
           AND ctipoatend = 'I'
           AND EXISTS(
                   SELECT 'x'
                     FROM dbamv.itlan_med
                    WHERE itlan_med.cd_reg_fat = ncdconta
                          AND itlan_med.cd_lancamento = ncdlancamento)
           AND NOT EXISTS(
                SELECT 'x'
                  FROM dbamv.itlan_med
                 WHERE itlan_med.cd_reg_fat = ncdconta AND itlan_med.cd_lancamento = ncdlancamento
                       AND NVL(itlan_med.tp_pagamento, 'P') <> 'C');
  --
  ctppagamento          VARCHAR2(1);
  --
  /* pda 369981 - 14/07/2010 - Amalia Ara?jo - acertando o LIKE para procurar o grupo cercado por v?rgulas */
  /*HSR - PDA - 145553 - Rodrigo Valentim - INICIO - Multiplos Exames
   *CURSOR QUE VAI BUSCAR A CONFIGURA?AO NA TABELA DE CONFIGURA??ES, LOCALIZANDO,
   *? POSS?VEL COBRAR A ROTINA DE MULTIPLOS EXAMES DE FORMA CORRETA.*/
  CURSOR clocgrupromult(pcdgfrupro IN NUMBER) IS
    SELECT COUNT(*) qtd_gru_pro
      FROM dbamv.configuracao
     WHERE chave = 'CD_GRU_MULTIPLOS'
       /*AND valor LIKE '%' || pcdgfrupro || '%'; */
       AND valor LIKE '%,' || pcdgfrupro || ',%'
			 AND configuracao.cd_multi_empresa = nEmpresa     -- OP 12525 - 29/10/2013 - filtro por empresa
			 ;
  /* pda 369981 - fim */
  --
  vnqtd_gru_pro         NUMBER;
  --
  CURSOR cincidencia IS
    SELECT rela.cd_pro_fat, rela.vl_percentual
	      ,rela.cd_val_pro_relacionado            -- OP 33841
      FROM dbamv.con_pla
         , dbamv.regra
         , dbamv.val_pro_relacionado rela
         , dbamv.empresa_con_pla                                             /* PDA 118607/131598 */
		 , dbamv.pro_fat    -- OP 33841
     WHERE empresa_con_pla.cd_convenio = con_pla.cd_convenio                 /* PDA 118607/131598 */
           AND empresa_con_pla.cd_con_pla = con_pla.cd_con_pla               /* PDA 118607/131598 */
           AND empresa_con_pla.cd_multi_empresa = nEmpresa /*OP 1501 dbamv.pkg_mv2000.le_empresa*/
		   -- OP 33841 - opção por procedimento ou por grupo de procedimento
		   --AND rela.cd_pro_fat = cprocedimento
		   and ( ( rela.cd_pro_fat_pai is not null and pro_fat.cd_pro_fat = rela.cd_pro_fat and Rela.Cd_Pro_Fat_Pai = cprocedimento )
		      or ( rela.cd_pro_fat_pai is null and rela.cd_gru_pro_pai = (SELECT p.cd_gru_pro FROM dbamv.pro_fat p WHERE cd_pro_fat = cprocedimento)
				   AND pro_fat.cd_pro_fat = cprocedimento )
			   )
		   -- OP 33841 - fim
		   AND con_pla.cd_convenio = ncodconvenio
           AND con_pla.cd_con_pla = ncodplano AND rela.tp_lancamento = 'A' AND rela.tp_valor = 'P'
           AND rela.sn_incidencia_exame = 'S'
           AND(  (ctipoatend = 'H' AND rela.tp_atend_homecare = 'S')
               OR(ctipoatend = 'E' AND rela.tp_atend_externo = 'S')
               OR(ctipoatend = 'U' AND rela.tp_atend_urgeme = 'S')
               OR(ctipoatend = 'A' AND rela.tp_atend_ambulatorial = 'S')
               OR(ctipoatend = 'I' AND rela.tp_atend_internacao = 'S')   )
           AND con_pla.cd_regra = regra.cd_regra AND rela.cd_regra = regra.cd_regra
           AND dt_vigencia IN(
                SELECT MAX(vpr.dt_vigencia)
                  FROM dbamv.val_pro_relacionado vpr
                 WHERE vpr.dt_vigencia <= vddatarefer AND vpr.cd_regra = rela.cd_regra
				   -- OP 33841 - opção por procedimento ou por grupo de procedimento
				   -- AND Vpr.Cd_Pro_Fat_Pai = Rela.Cd_Pro_Fat_Pai
				   -- AND Vpr.Cd_Pro_Fat = Rela.Cd_Pro_Fat
				   and ( ( Vpr.cd_pro_fat_pai is not null and pro_fat.cd_pro_fat = Vpr.cd_pro_fat and Vpr.Cd_Pro_Fat_Pai = cprocedimento )
					  or ( Vpr.cd_pro_fat_pai is null and Vpr.cd_gru_pro_pai = (SELECT p.cd_gru_pro FROM dbamv.pro_fat p WHERE cd_pro_fat = cprocedimento)
						   AND pro_fat.cd_pro_fat = cprocedimento )
					   )
					        );
  --
  -- OP 33841 - Implementação percentuais por faixa de valores na regra de relacionados.
  cursor cIncidenciaFaixa( pCodigo in number, pValor in number ) is
    select itrela.vl_percentual, itrela.vl_teto
	  from dbamv.itval_pro_relacionado itrela
	 where itrela.cd_val_pro_relacionado = pCodigo
	   and pValor between itrela.vl_faixa_inicial and itrela.vl_faixa_final;
  --
  CURSOR ckit IS
    /* ABA MAT/MED */
    SELECT DISTINCT 'S' valor
               FROM dbamv.itformula
                  , dbamv.formula
                  , dbamv.produto
              WHERE formula.cd_formula = itformula.cd_formula
                    AND produto.cd_produto = formula.cd_produto
                    AND produto.cd_pro_fat = cprocedimento
    UNION
    /* ABA EQUIPAMENTOS */
    SELECT DISTINCT 'S' valor
               FROM dbamv.itformula
                  , dbamv.formula
                  , dbamv.produto
                  , dbamv.kit_equip
              WHERE formula.cd_formula = itformula.cd_formula
                    AND produto.cd_produto = formula.cd_produto
                    AND formula.cd_formula = kit_equip.cd_formula
                    AND produto.cd_pro_fat = cprocedimento
    UNION
    /* ABA SANGUES/DERIVADOS */
    SELECT DISTINCT 'S' valor
               FROM dbamv.itformula
                  , dbamv.formula
                  , dbamv.produto
                  , dbamv.kit_sangue
              WHERE formula.cd_formula = itformula.cd_formula
                    AND produto.cd_produto = formula.cd_produto
                    AND formula.cd_formula = kit_sangue.cd_formula
                    AND produto.cd_pro_fat = cprocedimento
    UNION
    /* ABA PROCEDIMENTOS */
    SELECT DISTINCT 'S' valor
               FROM dbamv.itformula
                  , dbamv.formula
                  , dbamv.produto
                  , dbamv.kit_pro_fat
              WHERE formula.cd_formula = itformula.cd_formula
                    AND produto.cd_produto = formula.cd_produto
                    AND formula.cd_formula = kit_pro_fat.cd_formula
                    AND kit_pro_fat.cd_pro_fat = cprocedimento;
  --
  CURSOR cconfig IS
    SELECT NVL(valor, 'N') valor
      FROM dbamv.configuracao
     WHERE cd_sistema = 'FFCV' AND chave = 'SN_KIT_MGES_SEM_REGRA_NO_FFCV'
		   AND configuracao.cd_multi_empresa = nEmpresa     -- OP 12525 - 29/10/2013 - filtro por empresa
		 ;
  --
  vckit                 ckit%ROWTYPE;
  vcconfig              cconfig%ROWTYPE;
  baplicaregraexced     BOOLEAN;
  --
  CURSOR c_setorexec IS
    SELECT cd_setor_produziu
      FROM dbamv.itreg_amb
     WHERE itreg_amb.cd_lancamento = ncdlancamento AND itreg_amb.cd_reg_amb = ncdconta
           AND ctipoatend IN('A', 'E', 'U')
    UNION
    SELECT cd_setor_produziu
      FROM dbamv.itreg_fat
     WHERE itreg_fat.cd_lancamento = ncdlancamento AND itreg_fat.cd_reg_fat = ncdconta
           AND ctipoatend = 'I';
  --
  ncdsetorexec          dbamv.setor.cd_setor%TYPE;
  --
  CURSOR cvalrelac IS
    SELECT   COUNT(*)
        FROM dbamv.val_pro_relacionado
       WHERE val_pro_relacionado.cd_regra = nregra
             AND val_pro_relacionado.cd_pro_fat_pai = cprocedimento
             AND TRUNC(val_pro_relacionado.dt_vigencia) <= TRUNC(vddatarefer)
    ORDER BY val_pro_relacionado.dt_vigencia DESC;
  --
  nvalrelac             NUMBER;
  --
  CURSOR cregralanca IS
    SELECT cd_regra_lancamento
      FROM dbamv.itreg_fat
     WHERE cd_reg_fat = ncdconta AND cd_lancamento = ncdlancamento AND cd_pro_fat = cprocedimento
    UNION ALL
    SELECT cd_regra_lancamento
      FROM dbamv.itreg_amb
     WHERE cd_reg_amb = ncdconta AND cd_lancamento = ncdlancamento AND cd_pro_fat = cprocedimento;
  --
  Cursor cSnOpmeValCatPro is
   Select configuracao.valor
     from dbamv.configuracao
    where configuracao.cd_sistema       = 'FFCV'
      and upper(configuracao.chave)     = 'SN_OPME_VALORIZA_CAT_PRO'
      and configuracao.cd_multi_empresa = nEmpresa ; /*OP 1501 Dbamv.Pkg_Mv2000.Le_Empresa;*/
  --
  /* Se para o conv?nio estiver configurado para faturar data da alta, em contas ambulatoriais, buscar? a data pela data do atendimento
     se for conta hospitalar, buscar? a data pel a data da alta.  */
  CURSOR cFaturaDataAlta is
   SELECT Decode(c.sn_fatura_data_alta,'S',atendime.dt_atendimento,i.hr_lancamento) Data
      FROM dbamv.itreg_amb i,
           dbamv.convenio  c,
           dbamv.atendime
     WHERE atendime.cd_atendimento = i.cd_atendimento
       AND c.cd_convenio = atendime.cd_convenio
       AND c.cd_convenio= ncodconvenio
       AND i.cd_reg_amb = ncdconta
       AND i.cd_lancamento = ncdlancamento
  UNION ALL
   SELECT  Decode(c.sn_fatura_data_alta,'S',atendime.dt_alta,i.dt_lancamento) Data
      FROM dbamv.itreg_fat i,
           dbamv.reg_fat  r,
           dbamv.convenio  c,
           dbamv.atendime
     WHERE atendime.cd_atendimento = r.cd_atendimento
       AND r.cd_reg_fat  = i.cd_reg_fat
       AND c.cd_convenio = atendime.cd_convenio
       AND c.cd_convenio = ncodconvenio
       AND i.cd_reg_fat  = ncdconta
       AND i.cd_lancamento= ncdlancamento;
  --

   -- OP 6045 - cursor para identifica o tipo de movimenta??o do item (valores_conta_ambula e proc_valorizacao passam esses par?metros)
  CURSOR cInfItem IS
    SELECT itreg_amb.tp_mvto
      FROM dbamv.itreg_amb
     WHERE itreg_amb.cd_reg_amb = ncdconta AND itreg_amb.cd_lancamento = ncdlancamento
       AND ctipoatend IN ('A','E','U')
    UNION
    SELECT itreg_fat.tp_mvto
      FROM dbamv.itreg_fat
     WHERE itreg_fat.cd_reg_fat = ncdconta AND itreg_fat.cd_lancamento = ncdlancamento
       AND ctipoatend IN ('I','H')
       ;


  /* PDA 274932 -In?cio - 06/07/2009 - Raphanelli de Barros */
 /*Cursor que verifica para qual tipo do grupo de procedimento ser? calculado o servi?o */
 CURSOR cTpServico ( pnCdConvenio dbamv.convenio.cd_convenio%TYPE, pnCdCdPlano dbamv.empresa_con_pla.cd_con_pla%type) IS
   SELECT TP_PERCENT_ACOMOD_ITEM
     FROM dbamv.empresa_con_pla
    where cd_convenio = pnCdConvenio
      AND cd_con_pla = pnCdCdPlano
      AND cd_multi_empresa = nEmpresa ;/*OP 1501 Dbamv.pkg_mv2000.le_empresa;*/

  vTpServico dbamv.empresa_con_pla.TP_PERCENT_ACOMOD_ITEM%TYPE;

  /*Cursor para retornar a hr do lan?amento do procedimento na conta e o c?digo do atendimento*/
  cursor cVerHrLancamento is
    select itreg_fat.hr_lancamento,
           reg_fat.cd_atendimento
      FROM dbamv.itreg_fat,
            dbamv.reg_fat
      WHERE reg_fat.cd_reg_fat = ncdconta
        AND reg_fat.cd_reg_fat = itreg_fat.cd_reg_fat
        AND itreg_fat.cd_pro_fat = cprocedimento
        AND itreg_fat.cd_lancamento = ncdlancamento
      AND reg_fat.cd_multi_empresa = nEmpresa ;/*OP 1501 Dbamv.pkg_mv2000.le_empresa;*/

  vVerHrLancamento cVerHrLancamento%ROWTYPE;

  /* Cursor que verifica qual o tipo de acomoda??o na hora do lan?amento na conta */
    CURSOR cMovIntAcom( pnCdAtendi dbamv.atendime.cd_atendimento%TYPE,
                      pdDtlanca dbamv.itreg_fat.dt_lancamento%TYPE,
                      pdHrLanca  dbamv.itreg_fat.hr_lancamento%TYPE ) is
   /* OP 23258 - Incluido a tabela leito na query a baixo para pegar acomoda??o do leito caso na mov_int esteja nula */
    /*OP 22600*/
	/*SELECT mov_int.dt_mov_int ,
           To_char(mov_int.hr_mov_int,'hh24:mi:ss') hr_mov_int,
           mov_int.dt_lib_mov ,
           to_char(mov_int.hr_lib_mov,'hh24:mi:ss') hr_lib_mov,
           mov_int.cd_tip_acom
     FROM dbamv.mov_int
    WHERE mov_int.cd_atendimento = pnCdAtendi*/
      /* pda 543480 - 28/09/2012 - Amalia Ara?jo - colocando to_char ao tratar pdDtlanca nessa primeira condi??o */
      /*AND (Trunc(TO_DATE(to_char(pdDtlanca,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
            BETWEEN Trunc(mov_int.dt_mov_int) AND Trunc(Nvl(mov_int.dt_lib_mov,sysdate)))
      and To_char(pdHrLanca,'hh24:mi:ss') BETWEEN  To_char(mov_int.hr_mov_int,'hh24:mi:ss')AND To_char(Nvl(mov_int.hr_lib_mov,pdHrLanca),'hh24:mi:ss');*/
	  SELECT mov_int.dt_mov_int ,
           To_char(mov_int.hr_mov_int,'hh24:mi:ss') hr_mov_int,
           mov_int.dt_lib_mov ,
           to_char(mov_int.hr_lib_mov,'hh24:mi:ss') hr_lib_mov,
           Nvl(mov_int.cd_tip_acom,leito.cd_tip_acom) cd_tip_acom
     FROM dbamv.mov_int  , dbamv.leito
    WHERE mov_int.cd_atendimento = pnCdAtendi
      AND leito.cd_leito = mov_int.cd_leito
      /* pda 543480 - 28/09/2012 - Amalia Ara?jo - colocando to_char ao tratar pdDtlanca nessa primeira condi??o */
      AND (Trunc(TO_DATE(to_char(pdDtlanca,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
            BETWEEN Trunc(mov_int.dt_mov_int) AND Trunc(Nvl(mov_int.dt_lib_mov,sysdate)))
      and ( ( To_char(pdhrlanca,'hh24:mi:ss')
           BETWEEN  To_char(mov_int.hr_mov_int,'hh24:mi:ss')AND To_char(Nvl(mov_int.hr_lib_mov,pdhrlanca),'hh24:mi:ss')
           AND Trunc(mov_int.dt_mov_int) = Trunc(Nvl(mov_int.dt_lib_mov,sysdate)) )
           OR (Trunc(TO_DATE(to_char(pdDtlanca,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')) = Trunc(mov_int.dt_mov_int) AND
             To_char(pdhrlanca,'hh24:mi:ss') > To_char(mov_int.hr_mov_int,'hh24:mi:ss')
              )
              OR (Trunc(TO_DATE(to_char(pdDtlanca,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
			  -- = To_char(Nvl(mov_int.hr_lib_mov,pdhrlanca),'hh24:mi:ss')
              = trunc(TO_DATE(to_char(Nvl(mov_int.hr_lib_mov,pdhrlanca),'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
 AND
             To_char(pdhrlanca,'hh24:mi:ss') < To_char(Nvl(mov_int.dt_lib_mov,sysdate),'hh24:mi:ss')
              )
              OR (Trunc(TO_DATE(to_char(pdDtlanca,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')) <> Trunc(mov_int.dt_mov_int)
              AND Trunc(TO_DATE(to_char(pdDtlanca,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')) <> Trunc(Nvl(mov_int.dt_lib_mov,sysdate))) );
    /*OP 22600*/

  vMovIntAcom cMovIntAcom%ROWTYPE;
  /*Cursor que verifia o tipo do grupo de faturamento do procedimento */
  CURSOR cTpgrupro  ( pnCdprofat dbamv.pro_fat.cd_pro_fat%TYPE ) IS
    SELECT gru_pro.tp_gru_pro
      FROM dbamv.gru_pro,
           dbamv.pro_fat
     WHERE pro_fat.cd_gru_pro = gru_pro.cd_gru_pro
       AND pro_fat.cd_pro_fat = pnCdprofat
       AND gru_pro.tp_gru_pro IN ('SP','SD','SH');

  /* PDA 292205 (inicio) */

  /* pda 461171 - 15/09/2011 - Amalia Ara?jo - incluindo filtro pelo ctipoatend pois estava encontrando lote ambulatorial nesse select */
  cursor cDt_Atendimento (pCd_Reg_Fat in dbamv.reg_fat.cd_reg_fat%type) is
     select dt_atendimento, hr_atendimento
	   from dbamv.atendime, dbamv.reg_fat
	  where atendime.tp_atendimento in ('I', 'H')
      and reg_fat.cd_atendimento = atendime.cd_atendimento
	    and reg_fat.cd_reg_fat     = pCd_Reg_Fat
		AND ctipoatend IN ('I','H')
		;
  --
  cursor cParam_Conv is
      select valor
      from dbamv.configuracao
     where cd_sistema = 'FFCV'
       and (cd_multi_empresa = nEmpresa or /*OP 1501 dbamv.pkg_mv2000.le_empresa or --PDA 458885*/
            cd_multi_empresa is null)
       and chave = 'CD_CONVENIO_VALORIZA_DT_INTERNACAO';
  --
  cursor cBras_Indices is
     select 1
       from dbamv.imp_bra
      where cd_pro_fat = cprocedimento;
  /* PDA 292205 (fim) */

  vTpgrupro cTpgrupro%ROWTYPE;
  /* PDA 274932 - Fim */
  --
  /* pda 277748 - 06/07/2009 - Amalia Ara?jo - Cursor para identificar configura??o de conv?nios onde o valor N?o ser? arredondado. */
  cursor cConfConvTrunca is
    select valor
      from dbamv.configuracao
     where cd_sistema = 'FFCV'
       and cd_multi_empresa = nEmpresa /*OP 1501 dbamv.pkg_mv2000.le_empresa*/
       and chave = 'CD_CONV_NAO_ARREDONDA_VALOR';
  --
  /* OP 399 - 11/10/2013 - cursor que retorna exce??o de percentual de Cobran?a */
  cursor cExcPercCobranca(pvCdProFat in varchar, pvCdAtiMed in varchar, pnCdRegra in number, pnCdGruPro in number, pnCdTabFat in number) is
		select  exc.cd_gru_pro,
						exc.cd_tab_fat,
						exc.cd_regra,
						exc.cd_ati_med,
						exc.vl_percentual_pago
			from  dbamv.regra,
						dbamv.itregra,
						dbamv.pro_fat,
						dbamv.excecao_percentual_cobranca exc
			where regra.cd_regra                     = itregra.cd_regra
				and itregra.cd_gru_pro                 = pro_fat.cd_gru_pro
				and pro_fat.cd_pro_fat                 = Nvl(exc.cd_pro_fat, pro_fat.cd_pro_fat)
				and itregra.cd_regra                   = exc.cd_regra
				and itregra.cd_gru_pro                 = exc.cd_gru_pro(+)
				and itregra.cd_tab_fat                 = exc.cd_tab_fat(+)
				and (exc.cd_pro_fat                    = pvCdProFat         or exc.cd_pro_fat is null)
				and (exc.cd_ati_med                    = pvCdAtiMed         or exc.cd_ati_med is null)
				and exc.cd_regra                       = pnCdRegra
				and exc.cd_gru_pro                     = pnCdGruPro
				and exc.cd_tab_fat                     = pnCdTabFat;



  /*OP 26104 - buscando a data de lan?amento para o c?lulo do hor?rio especial*/
  cursor cDataRefHorarioEspec(pCdLancamento in number, pCdConta in Number, pTpAtendimento Varchar2) is
      select dt_lancamento dt_lancamento,
	         hr_lancamento hr_lancamento ,
           sn_horario_especial    /*OP 30533 - PDA 759752*/
	     from dbamv.itreg_Fat
		where  cd_reg_fat  = pCdConta
		  and  cd_lancamento = pCdLancamento
		  and  pTpAtendimento in ('I','H')
	 union all
	   select atendime.dt_atendimento dt_lancamento,
	          itreg_amb.hr_lancamento hr_lancamento,
            sn_horario_especial  /*OP 30533 - PDA 759752*/
	     from dbamv.itreg_amb,
              dbamv.atendime
         where itreg_amb.cd_atendimento = atendime.cd_atendimento
          and itreg_amb.cd_reg_amb = pCdConta
          and itreg_amb.cd_lancamento = pCdLancamento
          and pTpAtendimento in ('A','E','U');



  -- ALLS OP 30210 - PDA 758792
  CURSOR cSnCalculaRegraSubstituicao (pnCdConvenio dbamv.convenio.cd_convenio%TYPE) IS
    SELECT sn_calcula_regra_substituicao
    FROM dbamv.empresa_convenio
      WHERE cd_convenio = pnCdConvenio
      AND cd_multi_empresa = nEmpresa;
  --


  /*OP 35599 - Horário Especial por procedimento.*/
  /*OP 35613 - 37315 - duplicar/inserir procedimento de horário especial na conta*/
  CURSOR cHorarioEspecProced(nregra IN NUMBER,
                             ngrupro IN NUMBER,
                             pProFat IN VARCHAR2,
                             ndia     IN  NUMBER,
                             dhora    IN  DATE,
                             ctpatdt  IN  VARCHAR2) IS
   SELECT  hep.cd_horario
          ,horario_especial.sn_replica_proc
          ,dbamv.horario_especial.vl_percentual
         , DECODE(
             ctpatdt
           , 'E', regra.tp_atend_externo
           , 'U', regra.tp_atend_urgeme
           , 'I', regra.tp_atend_internacao
           , 'A', regra.tp_atend_ambulatorial
           , 'H', regra.tp_atend_homecare) sn_hor_esp
    FROM   dbamv.horario_especial_proced hep,
           dbamv.ithorario_especial,
           dbamv.regra,
           dbamv.horario_especial
     WHERE hep.cd_regra       = nregra
       AND hep.cd_gru_pro     = ngrupro
       AND hep.cd_pro_Fat     = pProFat
       AND horario_especial.cd_horario = ithorario_especial.cd_horario
       AND horario_especial.cd_horario = hep.cd_horario
       --AND hep.cd_horario     = nhoresp
       AND ithorario_especial.cd_dia = ndia
       AND ithorario_especial.cd_horario = hep.cd_horario
       AND regra.cd_regra = hep.cd_regra
       AND TO_CHAR(dhora, 'hh24:mi') BETWEEN TO_CHAR(ithorario_especial.hr_inicio, 'hh24:mi')
                                             AND TO_CHAR(ithorario_especial.hr_fim, 'hh24:mi');

   /*OP 35599*/



  -- ALLS OP 30420 - PDA 732086
  CURSOR cValorTetoCobranca(pnCdConvenio dbamv.convenio.cd_convenio%TYPE, nvalorunit in NUMBER, vRetPercntCnsg IN NUMBER) IS
    SELECT fpc.VL_TETO_COBRANCA
      FROM DBAMV.PERCENTUAL_CONSIGNADO pc,
           DBAMV.FAIXA_PERCENTUAL_CONSIGNADO fpc
        WHERE fpc.CD_MULTI_EMPRESA = pc.CD_MULTI_EMPRESA
        AND fpc.CD_CONVENIO  = pc.CD_CONVENIO
        AND fpc.SN_ATIVO = 'S'
        AND fpc.CD_CONVENIO = pnCdConvenio
        AND fpc.CD_MULTI_EMPRESA = nEmpresa
        AND pc.CD_PRO_FAT = vprofat
        and ( fpc.cd_percentual_consignado is null or fpc.cd_percentual_consignado = pc.cd_percentual_consignado )   -- OP 32555 - faixa geral ou específica
        AND nvalorunit BETWEEN fpc.VL_FAIXA_INICIAL AND fpc.VL_FAIXA_FINAL
        And nvalorunit IS NOT NULL
        AND fpc.VL_PERCENTUAL = vRetPercntCnsg;
  --
  -- OP 35103 - 07/01/2016 - Indica Qtde De Casas Decimais Serão Consideradas No Cálculo Do Valor Unitário Nas Contas Do Faturamento.
  cursor cQtCasasVlUnit is
    select To_Number(valor)  valor
      from dbamv.configuracao
     where cd_sistema = 'FFCV'
       and cd_multi_empresa = nEmpresa
       and chave = 'QT_CASAS_DECIMAIS_VL_UNITARIO';

  -- ALLS OP 41234 - Verifica chave de fechamendo de conta com valo zerado, para que, 
  --                 caso esteja configurado com valor 'S', n?o validar valor zerado do Procedimento lan?ado
  cursor cVerificSnFechaContaVlZero IS
    SELECT empresa_convenio.sn_permite_fechar_valor_zero 
     FROM dbamv.empresa_convenio, 
          dbamv.empresa_con_pla 
    WHERE empresa_convenio.cd_convenio = empresa_con_pla.cd_convenio
     AND empresa_convenio.cd_convenio = ncodconvenio
     AND empresa_con_pla.cd_con_pla = ncodplano  
     AND empresa_convenio.cd_multi_empresa = empresa_con_pla.cd_multi_empresa
     AND empresa_convenio.cd_multi_empresa = nEmpresa;

  CURSOR cIncidConvenio IS
    SELECT sn_incid_regr_conv_prod_consig
      FROM dbamv.empresa_convenio
    WHERE cd_convenio = ncodconvenio
      AND cd_multi_empresa = nEmpresa;

  vdatareferHorarioEspec DATE;
  vhorareferHorarioEspec DATE;
  vDataRefHorarioEspec cDataRefHorarioEspec%rowtype;
  vSnHorarioEspecial  VARCHAR2(1);    /*OP 30533 - PDA 759752*/

  vcregralanca          cregralanca%ROWTYPE;
  vdadosvlpercentual    cdadosvlpercentual%ROWTYPE;
  vdadoscdgrufat        cdadoscdgrufat%ROWTYPE;
  v_hospital            c_hospital%ROWTYPE;
  vcExcPercCobranca     cExcPercCobranca%rowtype;   -- OP 399
  bProcComExcPercCobranca BOOLEAN := FALSE;         -- OP 399

  nvalortotal           NUMBER;
  nvalorporte           NUMBER;
  nvalorfilme           NUMBER;
  nvalorhonor           NUMBER;
  nvaloropera           NUMBER;
  nvalorexced           NUMBER;
  nretval               NUMBER;
  nvlacres              NUMBER;
  nvldesc               NUMBER;
  nvlacresfilme         NUMBER;
  nvldescfilme          NUMBER;
  nvlacreshonor         NUMBER;
  nvldeschonor          NUMBER;
  nvlacresoper          NUMBER;
  nvldescoper           NUMBER;
  nvlacresexced         NUMBER;
  nvldescexced          NUMBER;
  bexcessao             BOOLEAN;
  bindice               BOOLEAN;
  bexcedente            BOOLEAN;
  v_grupro              c_grupro%ROWTYPE;
  v_por_ane_tab         c_por_ane_tab%ROWTYPE;
  v_regra               c_regra%ROWTYPE;
  v_acresdesc           c_acresdesc%ROWTYPE;
  v_tabconvenio         c_tabconvenio%ROWTYPE;
  v_itregra             c_itregra%ROWTYPE;
  v_indice              c_indice%ROWTYPE;
  v_horesp              c_horesp%ROWTYPE;
  v_feriado             c_feriado%ROWTYPE;
  v_indice_profat       c_indice_profat%ROWTYPE;
  v_valexced            c_valexced%ROWTYPE;
  v_convpla             c_convpla%ROWTYPE;
  v_regraexp            c_regraexplicita%ROWTYPE;
  v_acoplam             c_acoplam%ROWTYPE;
  vregraatend           cregraatend%ROWTYPE;
  nvlunitregra          NUMBER;
  ncdpormed             dbamv.porte_medico.cd_porte_medico%TYPE;
  vdspormed             dbamv.porte_medico.ds_porte_medico%TYPE;
  vvalorportemedico     dbamv.val_porte_medico.vl_porte_medico%TYPE;
  vvaloruco             dbamv.val_uco.vl_uco%TYPE;
  csnhorarioesp         VARCHAR2(1);
  nvlperchoresp         NUMBER;
  nvlpercatimed         NUMBER;
  cfuncatimed           VARCHAR2(1);
  nqtfilme              NUMBER;
  cexcesshoresp         VARCHAR2(1);
  nqtdeexced            NUMBER;
  ncdregra              NUMBER;
  nvlrfranquia          NUMBER;
  nvlpercsp             NUMBER;
  nvlpercsh             NUMBER;
  nvlpercsd             NUMBER;
  nqtpontos             NUMBER;
  npercentualdesconto   dbamv.acresc_descontos_proc.vl_perc_desconto%TYPE    := 0;
  npercentualacrescimo  dbamv.acresc_descontos_proc.vl_perc_acrescimo%TYPE   := 0;
  nvlprecototal         NUMBER;
  nvalorunit            NUMBER                                               := 0;
  vsnregrconsig         VARCHAR2(01)                                         := NULL;
  nsomatotal            NUMBER;
  nsomaatual            NUMBER;
  ncdlancmin            DBAMV.ITREG_AMB.CD_LANCAMENTO%TYPE /*NUMBER PDA 254997*/ := 0;
  llancamento           BOOLEAN;
  lvlpercentual         BOOLEAN;
  nvlpercentual         NUMBER                                               := 0;
  cprocentrega          VARCHAR2(8);
  nvltaxaentrega        NUMBER(11, 2);
  v_pacote              c_pacote%ROWTYPE;
  nvladiant             NUMBER(11, 2);
  nvlpercpacote         NUMBER(3, 2);
  bpacote               BOOLEAN                                              := FALSE;
  nvlagenda             NUMBER(11, 2);
  ncdfornecedor         dbamv.itcob_pre.cd_fornecedor%TYPE;
  vexcsubsproc          VARCHAR2(1);
  vprofatincid          dbamv.pro_fat.cd_pro_fat%TYPE;
  nvlpercincid          NUMBER;
  vSnOpmeValCatpro      dbamv.configuracao.valor%type;
  vFaturaDataAlta       date;
  /*PDA 274932 - in?cio - Raphanelli de Barros*/
  nVlRegraSP            dbamv.indice_acomodacao.vl_percentual_pago%TYPE ;
  nVlRegraSD            dbamv.indice_acomodacao.vl_percentual_pago%TYPE ;
  nVlRegraSH            dbamv.indice_acomodacao.vl_percentual_pago%TYPE ;
  /*PDA 274932 - Fim */
  vConfConvTrunca       dbamv.configuracao.valor%type;                            /* pda 277748 */
  vTruncaValor          varchar2(01) := 'N';                                      /* pda 277748 */
  nvlpercfranquia       number;                                                   /* pda 369072 - Amalia Ara?jo - 07/06/2010 */
  nNroCasasTrunc        NUMBER; --PDA 467341
  vSnRetiraValorUcoCbhpmAux    char := nvl(dbamv.pkg_mv2000.le_configuracao('FFCV', 'SN_RETIRA_VALOR_UCO_CBHPM_AUX'),'N'); -- pda 529876
  vTpMvto               dbamv.itreg_fat.tp_mvto%TYPE;   -- OP 6045
  vSnCalculaRegraSubstituicao  VARCHAR2(1); -- ALLS OP 30210 - PDA 758792
  vValorTetoCobranca    dbamv.faixa_percentual_consignado.vl_teto_cobranca%type; -- ALLS OP 30420 - PDA 732086
  vRetPercntCnsg        NUMBER; -- ALLS OP 30420 - PDA 732086
  nTetoIncid            number;   -- OP 33841
  nCodRelacionado       number;   -- OP 33841
  nvlpercincidfaixa     number;   -- OP 33841
  nQtCasasVlUnit        NUMBER;   -- OP 35103
  vHorarioEspecProced   cHorarioEspecProced%ROWTYPE;  /*OP 35599*/
  vSnPermiteValorZerado VARCHAR2(10);
  nRegraSubstituicao    NUMBER := NULL;    /*OP 44895*/
  vdtLancamento         itreg_fat.dt_lancamento%type;
 --
BEGIN
-- PDA 447562 (inicio)
  if nvl(dbamv.pkg_mv2000.le_configuracao('FFCV', 'SN_VALORIZA_DT_INTERNACAO'), 'N') = 'S' then
	  open  cParam_Conv;
    fetch cParam_Conv into vParam_Conv;
    close cParam_Conv;

    if instr(nvl(vParam_Conv,'X'),'#'||lpad(ncodconvenio,4,'0')) > 0 then
		   --
       --PDA 458885 (inicio) - Honorario,Mat/Med,Taxas,Servi?os etc...
       open  cDt_Atendimento (ncdconta);
       fetch cDt_Atendimento into vddatarefer, vdhorarefer;
       close cDt_Atendimento;
	   --PDA 458885 (fim)
		   --
		   if vddatarefer is null then
		      vddatarefer    := ddatarefer;
          vdhorarefer    := dhorarefer;
		   end if;
    else
       vddatarefer    := ddatarefer;
       vdhorarefer    := dhorarefer;
    end if;
  else
	  vddatarefer    := ddatarefer;
	  vdhorarefer    := dhorarefer;
  end if;
  -- PDA 447562  (fim)

  -- OP 35103 - 07/01/2016 - Indica Qtde De Casas Decimais Serão Consideradas No Cálculo Do Valor Unitário Nas Contas Do Faturamento.
  BEGIN
    nQtCasasVlUnit := 4;
    OPEN  cQtCasasVlUnit;
    FETCH cQtCasasVlUnit INTO nQtCasasVlUnit;
    CLOSE cQtCasasVlUnit;
  EXCEPTION
    WHEN OTHERS THEN
      nQtCasasVlUnit := 4;
  END;

  /* pda 277748 - 06/07/2009 - Amalia Ara?jo
     Buscando e tratando configura??o que define se os valores ser?o truncados ao inv?s de arredondados (como ? hoje).
     No par?metro CD_CONV_NAO_ARREDONDA_VALOR o hospital deve indicar, POR EMPRESA, quais os conv?nios onde N?o haver?
     o arredondamento, informando cada c?digo de conv?nio com 4 d?gitos com zeros ? esquerda e precedidos de #
     (exemplo : conv?nios 5 e 323 devem ser informados assim : "#0005#0323" ).
     Caso deseje que todos os conv?nios trabalhem deste modo, o valor deve ser preenchido com "#TODOS".                     */
  vConfConvTrunca := null;
  open  cConfConvTrunca;
  fetch cConfConvTrunca into vConfConvTrunca;
  close cConfConvTrunca;
  /* caso tenha sido colocada a palavra TODOS no valor, ? porque para qualquer conv?nio vai truncar os valores */
  if instr(nvl(vConfConvTrunca,'X'),'TODOS') > 0 then
    vTruncaValor := 'S';
  /* caso tenha sido especificado um ou mais conv?nios, verificar se para o conv?nio do par?metro vai truncar os valores */
  elsif instr(nvl(vConfConvTrunca,'X'),lpad(ncodconvenio,4,'0')) > 0 then
    vTruncaValor := 'S';
  /* caso N?o encontre informa??o neste par?metro, a rotina continua como est?, arredondando os valores */
  else
    vTruncaValor := 'N';
  end if;
  /* pda 277748 - fim */
  --
  OPEN c_setorexec;
  FETCH c_setorexec INTO ncdsetorexec;
  CLOSE c_setorexec;
  --
  Open cSnOpmeValCatpro;
  Fetch cSnOpmeValCatpro into vSnOpmeValCatpro;
  Close cSnOpmeValCatpro;
  --
  vFaturaDataAlta:=NULL;
  Open cFaturaDataAlta;
  Fetch cFaturaDataAlta into vFaturaDataAlta;
  Close cFaturaDataAlta;

  -- pda 468803 - 14/10/2011 - Amalia Ara?jo - estava passando data nula indevidamente mais abaixo, com essa vari?vel
  IF vFaturaDataAlta IS NULL THEN
    vFaturaDataAlta := dDataRefer;
  END IF;
  -- pda 468803 - fim
  --
  -- ALLS OP 30210 - PDA 758792
  OPEN cSnCalculaRegraSubstituicao(ncodconvenio);
  FETCH cSnCalculaRegraSubstituicao INTO vSnCalculaRegraSubstituicao;
  CLOSE cSnCalculaRegraSubstituicao;
  --
   -- OP 6045 - 21/03/2013 - Não verificar a regra de substituiàào se for lanàamento manual.
  vTpMvto := NULL;
  OPEN  cInfItem;
  FETCH cInfItem INTO vTpMvto;
  /*CLOSE cInfItem;*/ /*OP 17259*/
  IF Nvl(vTpMvto,'X') = 'Faturamento' OR cInfItem%NOTFOUND  THEN /*OP 17259*/
    vprofat := cprocedimento;
  else
  -- OP 6045 - fim
  -- ALLS OP 30210 - PDA 758792
    IF Nvl(vSnCalculaRegraSubstituicao, 'N') = 'S' then
      vprofat := dbamv.pack_lanca_ffcv.fnc_substituicao_procedimento(
                        dbamv.pkg_mv2000.le_empresa
                      , NVL(NVL(ncdsetorexec, pncdsetor), SUBSTR(cprocedimento, 9, 4)),
                        SUBSTR(cprocedimento, 1, 8),
                        vddatarefer, 
                        ctipoatend, 
                        'P',
						ncodconvenio, /*OP 28803*/
                        nRegraSubstituicao,  /*OP 44895*/
                        ncodplano,    /*OP 44895*/
                        nregra        /*OP 44895*/
                        );
    else
		-- ALLS OP 31562 - PDA 766465
		vprofat := cprocedimento;
    END IF;

  END IF;
  CLOSE cInfItem; /*OP 17259*/
  --
  /* --  Replica??o PDA RE(477082) - PDA(Erro) 476273 - Retirada valida??o de local atual para  um outro ponto do c?digo.
  IF NVL(pkg_mv2000.le_configuracao('FFCV', 'SN_NAO_CALCULA_CENTAVOS'), 'N') != 'S' THEN
    vexcsubsproc := dbamv.pack_ffcv_regra_lancamento.fnc_exclui_substitui_proc(ctipoatend
                                                                             , ncdconta
                                                                             , ncdlancamento
                                                                             , cprocedimento
                                                                             , vddatarefer
                                                                             , pncdsetor
                                                                             , ncodconvenio
                                                                             , ncodplano);
    --
    OPEN cregralanca;
    FETCH cregralanca INTO vcregralanca;
    CLOSE cregralanca;
    --
    -- pda 366296 - 11/05/2010 - Amalia Ara?jo - N?o considerar para a tela de consulta de valores
    IF nvl(dbamv.pkg_mv2000.le_formulario,'X') <> 'C_VAL_PROC' THEN
    -- pda 366296 - fim
      IF NVL(vexcsubsproc, 'N') = 'S' AND vcregralanca.cd_regra_lancamento IS NULL THEN
        nvloper := 0;
        nvlfilme := 0;
        nvlporte := 0;
        nvltaxa := 0;
        nvldesconto := 0;
        nvlhonor := 0.01;
        nvlrtotal := 0.01;
        RETURN(0.01);
      END IF;
    END IF;
  END IF;
  */
  --
  OPEN c_agenda;
  FETCH c_agenda INTO nvlagenda;
  IF NVL(nvlagenda, 0) > 0 THEN
    nvloper := 0;
    nvlfilme := 0;
    nvlporte := 0;
    nvltaxa := 0;
    nvldesconto := 0;
    nvlhonor := nvlagenda;
    nvlrtotal := nvlagenda;
    CLOSE c_agenda;
    RETURN(nvlagenda);
  END IF;
  CLOSE c_agenda;
  --
  OPEN c_pacote;
  FETCH c_pacote INTO v_pacote;
  IF c_pacote%FOUND THEN
    OPEN c_valorpacote(v_pacote.cd_pacote, v_pacote.cd_atendimento);
    FETCH c_valorpacote INTO nvladiant;
    CLOSE c_valorpacote;
    IF NVL(nvladiant, 0) > 0 THEN
      nvlrtotal := nvladiant;
      RETURN(nvladiant);
      nvlpercpacote := 1;
    ELSE
      nvlpercpacote := v_pacote.vl_perc_pac_secund;
    END IF;
    bpacote := TRUE;
  ELSE
    nvlpercpacote := 1;
    bpacote := FALSE;
  END IF;
	close c_pacote;    -- OP 14668 - 03/12/2013 - o cursor Não estava sendo fechado
  --
  OPEN c_procentrega;
  FETCH c_procentrega INTO cprocentrega;
  IF c_procentrega%FOUND THEN
    OPEN c_valentrega;
    FETCH c_valentrega INTO nvltaxaentrega;
    CLOSE c_valentrega;
    nvloper := 0;
    nvlhonor := 0;
    nvlfilme := 0;
    nvlporte := 0;
    nvltaxa := 0;
    nvldesconto := 0;
    IF NVL(nvltaxaentrega, 0) > 0 THEN
      nvlrtotal := nvltaxaentrega;
      RETURN(nvltaxaentrega);
    ELSE
      --cretmsg := 'Não existe Preço cadastrado para o Procedimento de coleta para a Área - ' || vprofat;
      cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_1', 'VAL_PROC_FFCV', 'Não existe Preço cadastrado para o Procedimento de coleta para a Área - %s', arg_list(vprofat));  -- OP 10402
      nvlrtotal := 0;
      RETURN(0);
    END IF;
  END IF;
  CLOSE c_procentrega;
  --
  /* Abrir o cursor no in?cio pois a vari?vel v_Hospital j? est? sendo utilizada. */
  OPEN c_hospital;
  FETCH c_hospital INTO v_hospital;
  CLOSE c_hospital;
  --
  /* Abertura do cursor que estava apenas declarado. ? utilizado no final da fun??o. */
  OPEN cregraatend;
  FETCH cregraatend INTO vregraatend;
  CLOSE cregraatend;
  --
  nmultiemp   := dbamv.pkg_mv2000.le_empresa();      /* pda 110783 */
  nvloper     := 0;
  nvlhonor    := 0;
  nvlfilme    := 0;
  nvlporte    := 0;
  nvlchtotal  := 0;
  nvlchhonor  := 0;
  nvltaxa     := 0;
  nvldesconto := 0;
  --
  OPEN c_grupro(vprofat);
  FETCH c_grupro INTO v_grupro;
  CLOSE c_grupro;
  --
  /* Verifica se o procedimento ? ?rtese e pr?tese. */
  IF v_grupro.tp_gru_pro = 'OP' OR dbamv.fnc_ffcv_sn_opme(vprofat) = 'S' THEN
    --
    /* O procedimento ? OPME ou ? um Medicamento ou um Material marcado como um OPME
       Se as vari?veis nCdConta e nCdLancamento N?o forem nulas entra na valida??o    */
    IF ncdconta IS NOT NULL AND ncdlancamento IS NOT NULL THEN
      /* Verifica o tipo de atendimento, a partir do par?metro de entrata "CTIPOATEND"
         Se o par?metro for "I", ou seja, temos um atendimento de interna??o (conta hospitalar), checa, na tabela
         "DBAMV.ITCOB_PRE", se o campo "VL_PRECO_TOTAL" ? maior que zeros.   */
      BEGIN
        vsnregrconsig := NULL;
        OPEN  cIncidConvenio;
        FETCH cIncidConvenio INTO vsnregrconsig;
        CLOSE cIncidConvenio;

        IF vsnregrconsig IS NULL THEN 
          SELECT sn_incid_regr_conv_prod_consig
            INTO vsnregrconsig
            FROM dbamv.config_ffcv
          WHERE cd_multi_empresa = nmultiemp;
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          cretmsg := '';
      END;
      --
      IF ctipoatend = 'I' THEN
        BEGIN
          SELECT vl_preco_unitario
               , vl_preco_total
               , cd_fornecedor
            INTO nvalorunit
               , nvalortotal
               , ncdfornecedor
            FROM dbamv.itcob_pre
           WHERE cd_reg_fat = ncdconta
             AND cd_lancamento = ncdlancamento;

		  -- OP 32555 - Nao calcular os procedimentos que tiverem Dados da Nota. Isso será feito ao inserir os registros.
          nretval := NVL(nvalorunit, 0);
          IF nretval <> 0 and nvl(vsnregrconsig,'N') = 'N'  THEN /*OP 33980*/
             nvlrtotal := nvalortotal;
             RETURN nretval;
          END IF;

          IF ncdfornecedor IS NULL AND dbamv.pack_aux_ffcv.fnc_procedimento_fatura_direto(vprofat) = 'S' THEN
            --cretmsg := '# Procedimento ' || vprofat || ' com faturamento direto precisa ter dados da nota fiscal informados.';
            cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_2', 'VAL_PROC_FFCV', '# Procedimento %s com faturamento direto precisa ter dados da nota fiscal informados.', arg_list(vprofat));  -- OP 10402
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            cretmsg := '';
        END;
        --
      /* Se o paràmetro for "A", "E" ou "U", ou seja, temos um atendimento de ambulatàrio, externo ou urgància respectivamente
         (conta ambulatorial), checa, na tabela "DBAMV.ITOOB_PRE_AMBU", se o campo "VL_PRECO_TOTAL" à maior que zeros.   */
      ELSIF ctipoatend IN('A', 'E', 'U') THEN
        BEGIN
          SELECT vl_preco_unitario
               , vl_preco_total
               , cd_fornecedor
            INTO nvalorunit
               , nvalortotal
               , ncdfornecedor
            FROM dbamv.itcob_pre_ambu
           WHERE cd_reg_amb = ncdconta AND cd_lancamento = ncdlancamento;

		  -- OP 32555 - Nao calcular os procedimentos que tiverem Dados da Nota. Isso será feito ao inserir os registros.
          nretval := NVL(nvalorunit, 0);
          IF nretval <> 0 and nvl(vsnregrconsig,'N') = 'N' THEN   -- OP 43491
             nvlrtotal := nvalortotal;
             RETURN nretval;
          END IF;

          IF ncdfornecedor IS NULL
             AND dbamv.pack_aux_ffcv.fnc_procedimento_fatura_direto(vprofat) = 'S' THEN
            --cretmsg := '# Procedimento ' || vprofat || ' com faturamento direto precisa ter dados da nota fiscal informados.';
            cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_2', 'VAL_PROC_FFCV', '# Procedimento %s com faturamento direto precisa ter dados da nota fiscal informados.', arg_list(vprofat));  -- OP 10402
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            cretmsg := '';
        END;
      END IF;
    /* Se a vari?vel "V_GruPro.tp_gru_pro" for "OP", mas os par?metros nCdConta e nCdLancamento forem nulos, retorna 1 (um) saindo da fun??o.  */
    /* pda 238816(In?cio) - Pedro Neiva - 15/07/2008
       elsif nCdConta Is Null And nCdLancamento Is Null then
       ELSIF ncdconta IS NULL OR ncdlancamento IS NULL THEN   */
    /* PDA 256929 - 12/11/2008 - Marinita Kommers (In?cio)
       Colocada a valida??o para verificar par?metro de valoriza??o da cat_pro para o hospital Moinhos de Vento.  */
    /* pda 288159 - 02/06/2009 - Amalia Ara?jo - o valor padr?o da vSnOpmeValCatpro deve ser 'N' e N?o 'S'
    Elsif ((nCdConta Is Null or nCdLancamento Is NULL) AND nvl(vSnOpmeValCatpro,'S') = 'S' ) THEN  */
    Elsif ((nCdConta Is Null or nCdLancamento Is NULL) AND nvl(vSnOpmeValCatpro,'N') = 'S' ) THEN
      nretval := 1;
      RETURN nretval;
    END IF;
  END IF;
  --
  IF ncdindice IS NULL THEN
    OPEN c_convpla;
    FETCH c_convpla INTO v_convpla;
    CLOSE c_convpla;
  END IF;
  --
  /* PDA 274932 - In?cio - 06/07/2009 - Raphanelli de Barros */
  OPEN cTpServico(ncodconvenio, ncodplano);
  FETCH cTpServico INTO vTpServico;
  CLOSE cTpServico;
	IF vTpServico <> 'N' THEN      /* valida??o para qual tipo de servi?os est? a configura??o  */
		OPEN cTpgrupro (cprocedimento);
		FETCH cTpgrupro INTO vTpgrupro ;
		IF cTpgrupro%FOUND THEN     /* valida se o procedimento ? de um dos servi?os configurados */

			Open cVerHrLancamento;
			fetch cVerHrLancamento into vVerHrLancamento;
			close cVerHrLancamento;

					/*OP 14324 - Jansen Gallindo*/
					/*IF vdhorarefer IS NULL THEN
						 vdhorarefer := vVerHrLancamento.hr_lancamento;
					END IF;*/
					/*OP 14324*/
			OPEN cMovIntAcom (vVerHrLancamento.cd_atendimento,vddatarefer,Nvl(vdhorarefer,vVerHrLancamento.hr_lancamento)); /*OP 14324*/
			FETCH cMovIntAcom INTO vMovIntAcom;
			CLOSE cMovIntAcom ;
			CLOSE cTpgrupro;
			IF nregra IS NULL THEN     /*Verifica a regra do tipo de acomoda??o*/
				OPEN c_regra(ncodconvenio, ncodplano, vMovIntAcom.cd_tip_acom);
				FETCH c_regra INTO v_regra;
				CLOSE c_regra;
				IF vTpServico = 'SP' THEN
					nVlRegraSP := v_regra.vl_percentual_sp;
				ELSIF vTpServico = 'SD' THEN
					nVlRegraSD := v_regra.vl_percentual_sd;
				ELSIF vTpServico = 'SH' THEN
					nVlRegraSH := v_regra.vl_percentual_sh;
				ELSE
					nVlRegraSP := v_regra.vl_percentual_sp;
					nVlRegraSD := v_regra.vl_percentual_sd;
					nVlRegraSH := v_regra.vl_percentual_sh;
				END IF;
			ELSE
				OPEN c_regraexplicita(nregra,vMovIntAcom.cd_tip_acom);
				FETCH c_regraexplicita INTO v_regraexp;
				CLOSE c_regraexplicita;
				IF vTpServico = 'SP' THEN
					nVlRegraSP := v_regraexp.vl_percentual_sp;
				ELSIF vTpServico = 'SD' THEN
					nVlRegraSD := v_regraexp.vl_percentual_sd;
				ELSIF vTpServico = 'SH' THEN
					nVlRegraSH := v_regraexp.vl_percentual_sh;
				ELSE
					nVlRegraSP := v_regraexp.vl_percentual_sp;
					nVlRegraSD := v_regraexp.vl_percentual_sd;
					nVlRegraSH := v_regraexp.vl_percentual_sh;
				END IF;
			END IF;
		ELSE
			CLOSE cTpgrupro;
		END IF;
	END IF;
	--
	-- OP 14426 - 28/11/2013 - Procurando regra padr?o antes de executar o cursor c_itregra.
  IF nregra IS NULL THEN
    OPEN c_regra(ncodconvenio, ncodplano, ncodtipoaco);
    FETCH c_regra INTO v_regra;
    CLOSE c_regra;
    ncdregra := v_regra.cd_regra;
  ELSE
    OPEN c_regraexplicita(nregra, ncodtipoaco);
    FETCH c_regraexplicita INTO v_regraexp;
    CLOSE c_regraexplicita;
    ncdregra := v_regraexp.cd_regra;
  end if;
	-- OP 14426 - fim
	--
	OPEN c_itregra(Nvl(nregra,ncdregra), v_grupro.cd_gru_pro);
  FETCH c_itregra INTO v_itregra;
  CLOSE c_itregra;
  --
  /* OP 399 - verificando exce??o de percentual de Cobran?a  */
	vcExcPercCobranca := null;
  open  cExcPercCobranca(vprofat, ctpatimed, Nvl(nregra,ncdregra), v_grupro.cd_gru_pro, v_itregra.cd_tab_fat);
  fetch cExcPercCobranca into vcExcPercCobranca;
  bProcComExcPercCobranca := cExcPercCobranca%found;
  close cExcPercCobranca;
  --
	/*Inclu?do os NVLs para caso a configura??o do plano esteja para algum tipo de servi?o*/
  IF nregra IS NULL THEN
    OPEN c_regra(ncodconvenio, ncodplano, ncodtipoaco);
    FETCH c_regra INTO v_regra;
    CLOSE c_regra;
    ncdregra := v_regra.cd_regra;
		/* OP 399 - aplicando exce??o de percentual de Cobran?a, se houver  */
    --nvlpercsp := Nvl(nVlRegraSP,v_regra.vl_percentual_sp);
    --nvlpercsh := Nvl(nVlRegraSH,v_regra.vl_percentual_sh);
    --nvlpercsd := Nvl(nVlRegraSD,v_regra.vl_percentual_sd);
    nvlpercsp := nvl(vcExcPercCobranca.vl_percentual_pago, Nvl(nVlRegraSP,v_regra.vl_percentual_sp));
    nvlpercsh := nvl(vcExcPercCobranca.vl_percentual_pago, Nvl(nVlRegraSH,v_regra.vl_percentual_sh));
    nvlpercsd := nvl(vcExcPercCobranca.vl_percentual_pago, Nvl(nVlRegraSD,v_regra.vl_percentual_sd));
  ELSE
    OPEN c_regraexplicita(nregra, ncodtipoaco);
    FETCH c_regraexplicita INTO v_regraexp;
    CLOSE c_regraexplicita;
    ncdregra := v_regraexp.cd_regra;
		/* OP 399 - aplicando exce??o de percentual de Cobran?a, se houver  */
    --nvlpercsp := Nvl(nVlRegraSP,v_regraexp.vl_percentual_sp);
    --nvlpercsh := Nvl(nVlRegraSH,v_regraexp.vl_percentual_sh);
    --nvlpercsd := Nvl(nVlRegraSD,v_regraexp.vl_percentual_sd);
    nvlpercsp := nvl(vcExcPercCobranca.vl_percentual_pago,Nvl(nVlRegraSP,v_regraexp.vl_percentual_sp));
    nvlpercsh := nvl(vcExcPercCobranca.vl_percentual_pago,Nvl(nVlRegraSH,v_regraexp.vl_percentual_sh));
    nvlpercsd := nvl(vcExcPercCobranca.vl_percentual_pago,Nvl(nVlRegraSD,v_regraexp.vl_percentual_sd));
  END IF;
  /*PDA 274932 - Fim */
  --
  IF v_itregra.cd_tab_fat IS NULL THEN
     /*OP 1501*/
    /*IF NVL(pkg_mv2000.le_configuracao('FFCV', 'SN_CREDENCIADO_CENTAVOS'), 'N') = 'S' THEN*/
	  IF NVL(snCredenciadoCentavos, 'N') = 'S' THEN /*OP 1501*/
      OPEN c_tppagamento;
      FETCH c_tppagamento INTO ctppagamento;
      CLOSE c_tppagamento;
      --
      /* PDA.: 270509 - 03/02/2009 - Emanoel Deivison (inicio)
         Caso o tipo de pagamento no item da conta esteja nulo ser? utilizada a fun??o abaixo, que ir?
         verificar o tipo de pagamento de acordo com as regras do conv?nio e credenciamento.
      */
      if ctppagamento is null then
        vvTpPag:=dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(
                                                                  pncdprestador,
                                                                  ncodconvenio,
                                                                  ctipoatend,
                                                                  vprofat,
                                                                  null,
																  null,
																  null,
																  ncodplano,
																  ncdregra,
																  v_grupro.cd_gru_pro
                                                                  );
      else
        vvTpPag:=ctppagamento;
      end if;
      /* PDA.: 270509 (fim)*/
      IF NVL(vvTpPag, 'P') = 'C' THEN  /* PDA.: 270509 - Trocado a vari?vel: "ctppagamento" pela: "vvTpPag" e ajustado o NVL que estava com "C'*/
        nvloper := 0;
        nvlfilme := 0;
        nvlporte := 0;
        nvltaxa := 0;
        nvldesconto := 0;
        nvlhonor := 0.01;
        nvlrtotal := 0.01;
        RETURN(0.01);
      END IF;
    END IF;
    --
    --cretmsg := 'Não existe Tabela de Cobranca Vinculada a Regra ' || TO_CHAR(ncdregra) || CHR(10)|| ' do Grupo de Procedimento ' || TO_CHAR(v_grupro.cd_gru_pro) || ' na Regra !';
    cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_3', 'VAL_PROC_FFCV', 'Não existe Tabela de Cobrançaa vinculada a Regra %s do Grupo de Procedimento %s na regra!', arg_list(TO_CHAR(ncdregra),TO_CHAR(v_grupro.cd_gru_pro)));  -- OP 10402
    --
    RETURN 0;
  END IF;
  --
  v_acresdesc.vl_perc_acrescimo := NULL;
  v_acresdesc.vl_perc_desconto := NULL;
  v_acresdesc.sn_vl_filme := NULL;
  v_acresdesc.sn_vl_honorario := NULL;
  v_acresdesc.sn_vl_operacional := NULL;
  v_acresdesc.sn_acres_desc := NULL;
  --
  /* OP 3738 - PDA 569190 - Jansen Gallindo (inicio) - for?ando a mascara no campo vFaturaDataAlta - Corre??o para aplicar desconto do filme*/
  OPEN c_acresdesc_proc(ncdregra, vprofat, ctipoatend,To_Date(To_Char(vFaturaDataAlta,'dd/mm/yyyy'),'dd/mm/yyyy'));
  FETCH c_acresdesc_proc INTO v_acresdesc;
  IF c_acresdesc_proc%NOTFOUND OR v_acresdesc.sn_acres_desc = 'N' THEN
    v_acresdesc.vl_perc_acrescimo := NULL;
    v_acresdesc.vl_perc_desconto := NULL;
    v_acresdesc.sn_vl_filme := NULL;
    v_acresdesc.sn_vl_honorario := NULL;
    v_acresdesc.sn_vl_operacional := NULL;
    v_acresdesc.sn_acres_desc := NULL;
    /* OP 3738 - PDA 569190 - Jansen Gallindo (inicio) - for?ando a mascara no campo vFaturaDataAlta - Corre??o para aplicar desconto do filme*/
    OPEN c_acresdesc(ncdregra, v_grupro.cd_gru_pro, ctipoatend,To_Date(To_Char(vFaturaDataAlta,'dd/mm/yyyy'),'dd/mm/yyyy'));
    FETCH c_acresdesc INTO v_acresdesc;
    CLOSE c_acresdesc;
  END IF;
  CLOSE c_acresdesc_proc;

  /* PDA.: 281430 - 13/04/2009 - Emanoel Deivison (inicio)
     Altera??es referentes as Regras de Excess?o de Tabelas de Faturamento,
     PDA 281833 - Retirado teste de periodo de validade de utiliza??o do cursor c_tabconvenio_429 at? 31/12/2009
  */

  /*if (dbamv.pkg_mv2000.le_cliente = 429) then*/
  if (nCliente = 429) then /*OP 1501*/
  /* PDA.: 281430 - 13/04/2009 - Emanoel Deivison (fim)*/
   /*PDA 297255 - Thiago Miranda de Oliveira - Na abertura do cursor o parametro nregra estava vindo nulo com isso em alguns casos
                Não estava trazendo a execeàào do procediemnto para este convànio em plano, caso a mesma Não venha preenchida con-
                siderar a variàvel ncdregra para o cursor onde retornara os dados da configuraàào de exceàào.
    --OPEN c_tabconvenio_429(ncodconvenio, ncodplano, vprofat, ddatarefer, pncdprestador, pncdsetor, nregra); */
    OPEN c_tabconvenio_429(ncodconvenio, ncodplano, vprofat, ddatarefer, pncdprestador, pncdsetor, nvl(nregra, ncdregra));
    FETCH c_tabconvenio_429 INTO v_tabconvenio;
    CLOSE c_tabconvenio_429;
  else
  /* pda 314713 - Thiago Miranda de Oliveira - incluindo o parametro de regra para a consulta, para qnuado a configuracao tiver a regra so trazer
                   as regras destinadas a aquela passada*/
    OPEN c_tabconvenio(ncodconvenio, ncodplano, vprofat, vddatarefer, pncdprestador, pncdsetor, nvl(nregra, ncdregra));
    FETCH c_tabconvenio INTO v_tabconvenio;
    CLOSE c_tabconvenio;
  end if;
  --

  IF NVL(nvalproced, 0) = 0 THEN
    IF v_tabconvenio.vl_tab_convenio IS NOT NULL THEN
      --
      nvalortotal := v_tabconvenio.vl_tab_convenio;
      ncdtabfatporte := NULL;
      cexcesshoresp := NVL(v_tabconvenio.sn_horario_especial, 'N');
      bexcessao := TRUE;
      nvaloropera := 0;
      ncdregra := NVL(v_tabconvenio.cd_regra, ncdregra);
      --
      OPEN c_itregra_porte(ncdregra, v_grupro.cd_gru_pro);
      FETCH c_itregra_porte INTO ncdtabfatporte;
      CLOSE c_itregra_porte;
      --
      IF v_grupro.tp_gru_pro IN('SP', 'SD') THEN
        nvalorhonor := v_tabconvenio.vl_tab_convenio;
      END IF;
      --
    ELSE
      --
      OPEN c_valpro(vprofat, v_itregra.cd_tab_fat, vddatarefer);
      FETCH c_valpro INTO nvalortotal, nvaloropera, nvalorhonor;
      CLOSE c_valpro;
      --
      ncdtabfatporte := NULL;
      bexcessao := FALSE;
      --
    END IF;
    --
    /* PDA 560559 - Raphanelli Santana
      Mesmo com valor em tabela o procedimento deve ser colocado com valor de 0.01 para regra de lan?amentos de exclusao. Colocado apenas para o M?e de Deus (420) */
    /* Replica??o PDA RE(477082) - PDA(Erro) 476273 - Retirada valida??o de local atual para  um outro ponto do c?digo.*/
    IF Nvl(nvalortotal,0) = 0  OR dbamv.pkg_mv2000.le_cliente = 420 THEN
      /*     PDA 476273 - Retirada valida??o de local atual para  um outro ponto do c?digo.*/
      /*IF NVL(pkg_mv2000.le_configuracao('FFCV', 'SN_NAO_CALCULA_CENTAVOS'), 'N') != 'S' THEN*/ /*OP 1501*/
	    IF NVL(snNaoCalculaCentavos, 'N') != 'S' THEN /*OP 1501*/
        vexcsubsproc := dbamv.pack_ffcv_regra_lancamento.fnc_exclui_substitui_proc(ctipoatend
                                                                             , ncdconta
                                                                             , ncdlancamento
                                                                             , cprocedimento
                                                                             , vddatarefer
                                                                             , pncdsetor
                                                                             , ncodconvenio
                                                                             , ncodplano);
				--
				OPEN cregralanca;
				FETCH cregralanca INTO vcregralanca;
				CLOSE cregralanca;
				--
				-- pda 366296 - 11/05/2010 - Amalia Ara?jo - N?o considerar para a tela de consulta de valores

				/*IF nvl(dbamv.pkg_mv2000.le_formulario,'X') <> 'C_VAL_PROC' THEN*/ /*OP 1501*/
				IF nvl(leFormulario,'X') <> 'C_VAL_PROC' THEN /*OP 1501*/
					-- pda 366296 - fim
					IF NVL(vexcsubsproc, 'N') = 'S' AND vcregralanca.cd_regra_lancamento IS NULL THEN
						nvloper := 0;
						nvlfilme := 0;
						nvlporte := 0;
						nvltaxa := 0;
						nvldesconto := 0;
						nvlhonor := 0.01;
						nvlrtotal := 0.01;
						RETURN(0.01);
					END IF;
				END IF;
		  END IF;

    END IF;
    /* PDA 476273(Fim)*/

  -- ALLS OP 30210 - PDA 758792
  OPEN cSnCalculaRegraSubstituicao(ncodconvenio);
  FETCH cSnCalculaRegraSubstituicao INTO vSnCalculaRegraSubstituicao;
  CLOSE cSnCalculaRegraSubstituicao;
  --

	/*OP 17259 - in?cio - N?o verificar regra de substitui??o em lan?amento manual*/
  OPEN  cInfItem;
  FETCH cInfItem INTO vTpMvto;
  IF Nvl(vTpMvto,'X') = 'Faturamento' OR cInfItem%NOTFOUND  THEN
    null;

	ELSE

    -- ALLS OP 30210 - PDA 758792
	IF Nvl(vSnCalculaRegraSubstituicao, 'N') = 'S' THEN

	  /*OP 17259 - fim*/
      nvalortotal := dbamv.pack_lanca_ffcv.fnc_substituicao_proced_fator(
                                      dbamv.pkg_mv2000.le_empresa
                                    , NVL(ncdsetorexec, pncdsetor),
                                      SUBSTR(cprocedimento, 1, 8),   -- vprofat,   -- OP 13847 - 05/11/2013
																		  vddatarefer, 
                                      ctipoatend, 
                                      'P', 
                                      nvalortotal,
												              ncodconvenio, /*OP 28803*/
                                      ncodplano,    /*OP 44895*/
                                      Nvl(ncdregra,nregra) /*OP 44895*/
                                      );
      nvaloropera := dbamv.pack_lanca_ffcv.fnc_substituicao_proced_fator(
                                      dbamv.pkg_mv2000.le_empresa
                                     ,NVL(ncdsetorexec, pncdsetor),
                                      SUBSTR(cprocedimento, 1, 8),   -- vprofat,   -- OP 13847 - 05/11/2013
																		  vddatarefer, 
                                      ctipoatend, 
                                      'P', 
                                      nvaloropera,
												              ncodconvenio, /*OP 28803*/
                                      ncodplano,    /*OP 44895*/
                                      Nvl(ncdregra,nregra) /*OP 44895*/
                                      );
      nvalorhonor :=dbamv.pack_lanca_ffcv.fnc_substituicao_proced_fator(
                                      dbamv.pkg_mv2000.le_empresa
                                     ,NVL(ncdsetorexec, pncdsetor),
                                      SUBSTR(cprocedimento, 1, 8),   -- vprofat,   -- OP 13847 - 05/11/2013
																		  vddatarefer, 
                                      ctipoatend, 
                                      'P', 
                                      nvalorhonor,
												              ncodconvenio, /*OP 28803*/
                                      ncodplano,    /*OP 44895*/
                                      Nvl(ncdregra,nregra) /*OP 44895*/
                                      );
    END IF;
  end if;
  CLOSE cInfItem;
																																				--
    /* Acrescentada a condi??o "AND NVL(nValorOpera,0) = 0", na checagem do Pre?o do procedimento.  */
    IF v_grupro.tp_gru_pro IN('SP', 'SD') AND NVL(nvalorhonor, 0) = 0 AND NVL(nvaloropera, 0) = 0 THEN

			-- OP 14668 - 03/12/2013 - Retirando condi??o espec?fica de clientes do MV2000.
			--IF nvalortotal IS NOT NULL AND ( v_hospital.cd_hospital = 312 OR ( v_hospital.cd_hospital = 734 AND ctipoatend IN('A', 'E', 'U')) ) THEN
      --  NULL;
      --ELSE

			/*IF nvl(dbamv.pkg_mv2000.le_formulario,'X') <> 'C_VAL_PROC' THEN*/ /*OP 1501*/
			IF nvl(leFormulario,'X') <> 'C_VAL_PROC' THEN /*OP 1501*/
				/*IF NVL(pkg_mv2000.le_configuracao('FFCV', 'SN_CREDENCIADO_CENTAVOS'), 'N') = 'S' THEN*/ /*OP 1501*/
				IF NVL(snCredenciadoCentavos, 'N') = 'S' THEN  /*OP 1501*/
					OPEN c_tppagamento;
					FETCH c_tppagamento INTO ctppagamento;
					CLOSE c_tppagamento;
					--
					/* PDA.: 270509 - 03/02/2009 - Emanoel Deivison (inicio)
						 Caso o tipo de pagamento no item da conta esteja nulo ser? utilizada a fun??o abaixo, que ir?
						 verificar o tipo de pagamento de acordo com as regras do conv?nio e credenciamento.
					*/
					if ctppagamento is null then
						vvTpPag:=dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(	pncdprestador,
																					ncodconvenio,
																					ctipoatend,
																					vprofat,
																					null,
																					null,
																					null,
																					ncodplano,
																					ncdregra,
																					v_grupro.cd_gru_pro
																					);
					else
						vvTpPag:=ctppagamento;
					end if;
					/* PDA.: 270509 (fim)*/
					IF NVL(vvTpPag, 'P') = 'C' THEN /* PDA.: 270509 - Trocado a vari?vel: "ctppagamento" pela: "vvTpPag" e ajustado o NVL que estava com "C'*/
						nvloper     := 0;
						nvlfilme    := 0;
						nvlporte    := 0;
						nvltaxa     := 0;
						nvldesconto := 0;
						nvlhonor    := 0.01;
						nvlrtotal   := 0.01;
						RETURN(0.01);
					END IF;
				END IF;
				--
				--cretmsg := 'N?o existe Pre?o Cadastrado para o Procedimento ' || vprofat || CHR(10) || 'na Tabela '
				--          || TO_CHAR(v_itregra.cd_tab_fat) || CHR(10) || 'com Data Inferior a '
				--          || TO_CHAR(vddatarefer, 'dd/mm/yyyy');

				
		        -- Inicio ALLS OP 41234 
		        OPEN cVerificSnFechaContaVlZero;
		        FETCH cVerificSnFechaContaVlZero INTO vSnPermiteValorZerado;
		        CLOSE cVerificSnFechaContaVlZero;
		
		        IF not(NVL(vSnPermiteValorZerado, 'N') = 'S' AND nvalorhonor = 0 AND nvaloropera = 0) THEN
		          -- OP 14668 - 03/12/2013 - Melhoria na mensagem para informar ao usu?rio a causa e como corrigir.
						  cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_4', 'VAL_PROC_FFCV',
						    ' Para serviços Profissionais e de Diagnóstico é necessário que a vigência possua valor Operacional e/ou Honorário. '||
							  'A vigência contém apenas o valor Total. Verificar o procedimento %s na tabela %s a última vigência com data inferior a %s, '||
							  'e criar nova vigência com os valores corretos.',
						    --'N?o existe Pre?o Cadastrado para o Procedimento %s na tabela %s com data inferior ? %s.',
													  arg_list(vprofat,TO_CHAR(v_itregra.cd_tab_fat),TO_CHAR(vddatarefer, 'dd/mm/yyyy')));  -- OP 10402
		        END IF;
		        -- Fim ALLS OP 41234 

			-- PDA 218812 (Fim)
			END IF;
      --END IF;   -- OP 14668 - 03/12/2013 - comentado if espec?fico do cliente
    END IF;
      --
    IF NVL(nvalortotal, 0) = 0 THEN
      IF v_grupro.tp_gru_pro <> 'OP' AND dbamv.fnc_ffcv_sn_opme(vprofat) <> 'S' THEN
        --
        /* O procedimento N?o ? um OPME nem ? um Medicamento nem um Material marcado como OPME */
        IF nvalortotal IS NOT NULL AND ( v_hospital.cd_hospital = 312 OR (v_hospital.cd_hospital = 734 AND ctipoatend IN('A', 'E', 'U')) ) THEN
          NULL;
        ELSE
          /*IF nvl(dbamv.pkg_mv2000.le_formulario,'X') <> 'C_VAL_PROC' THEN*/ /*OP 1501*/
		      IF nvl(leFormulario,'X') <> 'C_VAL_PROC' THEN /*OP 1501*/
            /*IF NVL(pkg_mv2000.le_configuracao('FFCV', 'SN_CREDENCIADO_CENTAVOS'), 'N') = 'S' THEN*/ /*OP 1501*/
			      IF NVL(snCredenciadoCentavos, 'N') = 'S' THEN /*OP 1501*/
              OPEN c_tppagamento;
              FETCH c_tppagamento INTO ctppagamento;
              CLOSE c_tppagamento;
              --
              /* PDA.: 270509 - 03/02/2009 - Emanoel Deivison (inicio)
                 Caso o tipo de pagamento no item da conta esteja nulo ser? utilizada a fun??o abaixo, que ir?
                 verificar o tipo de pagamento de acordo com as regras do conv?nio e credenciamento.
              */
              if ctppagamento is null then
                vvTpPag:=dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(
                                                                          pncdprestador,
                                                                          ncodconvenio,
                                                                          ctipoatend,
                                                                          vprofat,
                                                                          null,
																		  null,
																		  null,
																		  ncodplano,
																		  ncdregra,
																		  v_grupro.cd_gru_pro
                                                                          );
              else
                vvTpPag:=ctppagamento;
              end if;
              /* PDA.: 270509 (fim)*/
              IF NVL(vvTpPag, 'P') = 'C' THEN /* PDA.: 270509 - Trocado a vari?vel: "ctppagamento" pela: "vvTpPag" e ajustado o NVL que estava com "C'*/
                nvloper := 0;
                nvlfilme := 0;
                nvlporte := 0;
                nvltaxa := 0;
                nvldesconto := 0;
                nvlhonor := 0.01;
                nvlrtotal := 0.01;
                RETURN(0.01);
              END IF;
            END IF;
            --
            --cretmsg := 'N?o existe Pre?o Cadastrado para o Procedimento ' || vprofat || CHR(10)
            --          || 'na Tabela ' || TO_CHAR(v_itregra.cd_tab_fat) || CHR(10) || 'com Data Inferior a '
            --          || TO_CHAR(vddatarefer, 'dd/mm/yyyy');

            -- Inicio ALLS OP 41324 
            OPEN cVerificSnFechaContaVlZero;
            FETCH cVerificSnFechaContaVlZero INTO vSnPermiteValorZerado;
            CLOSE cVerificSnFechaContaVlZero;

            /*OP 44773*/
            /*IF not(NVL(vSnPermiteValorZerado, 'N') = 'S' AND nvalortotal = 0) THEN*/
            IF (
                (NVL(vSnPermiteValorZerado, 'N') = 'S' AND nvalortotal IS NULL)
                 OR
                (NVL(vSnPermiteValorZerado, 'N') = 'N' )
               )
                 THEN
            /*OP 44773*/
            
              cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_13', 'VAL_PROC_FFCV', 'Não existe Preço Cadastrado para o Procedimento %s na tabela %s com data inferior a %s.',
                          arg_list(vprofat,TO_CHAR(v_itregra.cd_tab_fat),TO_CHAR(vddatarefer, 'dd/mm/yyyy')));  -- OP 10402
            END IF;
            -- Fim ALLS OP 41324 

            nvlrtotal := 0; /*PDA 466974*/
          END IF;
        END IF;
      ELSE
        OPEN cverconvprofat;
        FETCH cverconvprofat INTO nconvprofat;
        CLOSE cverconvprofat;
        /*IF nvl(dbamv.pkg_mv2000.le_formulario,'X') <> 'C_VAL_PROC' AND*/ /*OP 1501*/
		    IF nvl(leFormulario,'X') <> 'C_VAL_PROC' AND /*OP 1501*/
           NVL(nconvprofat, 0) = 0 AND
           v_hospital.cd_hospital not in (429,338,420) AND     /* pda 556827 - 30/11/2012 - incluindo cliente 420 para funcionar como era do adiantamento */
           dbamv.fnc_ffcv_sn_opme(vprofat) = 'S' THEN
          --
          --cretmsg := '# Não existe Preço Cadastrado para o Procedimento ' || vprofat || CHR(10)
          --           || ' do Tipo "OP" na Tabela de Dados da Nota';
          cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_5', 'VAL_PROC_FFCV', '# Não existe Preço cadastrado para o Procedimento %s do Tipo "OP" na tabela de Dados da Nota.',
                       arg_list(vprofat));  -- OP 10402
        END IF;
      END IF;
      RETURN 0;
    END IF;
    --
    IF NVL(nvaloropera, 0) <> 0 OR NVL(nvalorhonor, 0) <> 0 THEN
      /* Round por causa da diferen?a de casas decimais nas colunas da tabela VAL_PRO. */
      IF ROUND(NVL(nvalortotal, 0), 4) <> ROUND(NVL(nvaloropera, 0) + NVL(nvalorhonor, 0), 4) THEN
        --cretmsg := 'Valor Total difere da soma do Valor de Honorários com o Valor Operacional !' || CHR(10)
        --          || 'para o procedimento ' || vprofat || CHR(10) || 'na Tabela '
        --          || TO_CHAR(v_itregra.cd_tab_fat) || CHR(10);
        cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_6', 'VAL_PROC_FFCV', 'Valor Total difere da soma do valor de Honorários com o valor Operacional para o procedimento %s na tabela %s.',
                     arg_list(vprofat,TO_CHAR(v_itregra.cd_tab_fat)));  -- OP 10402
        RETURN 0;
      END IF;
    END IF;
    --
    OPEN c_indice(NVL(ncdindice, v_convpla.cd_indice), vddatarefer, v_grupro.cd_gru_pro, ctipoatend);
    FETCH c_indice INTO v_indice;
    CLOSE c_indice;
    --
    IF v_itregra.tp_tab_fat = 'H' AND NOT bexcessao THEN
      --
      llancamento := FALSE;
      lvlpercentual := FALSE;
      --
      IF ctipoatend = 'I' THEN
        IF dbamv.pack_ffcv.fnc_retorna_perc_sd(vprofat, ncdregra, vddatarefer) IS NULL THEN
          OPEN clancminhosp(v_grupro.cd_gru_pro);
          FETCH clancminhosp INTO ncdlancmin;
          IF clancminhosp%FOUND THEN
            llancamento := TRUE;
          END IF;
          CLOSE clancminhosp;
        END IF;
      ELSE
        IF dbamv.pack_ffcv.fnc_retorna_perc_sd(vprofat, ncdregra, vddatarefer) IS NULL THEN
          OPEN clancminamb(v_grupro.cd_gru_pro);
          FETCH clancminamb INTO ncdlancmin;
          IF clancminamb%FOUND THEN
            llancamento := TRUE;
          END IF;
          CLOSE clancminamb;
        END IF;
      END IF;
      --
      IF llancamento THEN
        IF ncdlancmin <> ncdlancamento THEN
          IF dbamv.pack_ffcv.fnc_retorna_perc_sd(vprofat, ncdregra, vddatarefer) IS NULL THEN
            OPEN cvlpercent(v_itregra.cd_tab_fat, v_grupro.cd_gru_pro);
            FETCH cvlpercent INTO nvlpercentual;
            IF cvlpercent%FOUND THEN
              IF NVL(nvaloropera, 0) > 0 THEN
                nvaloropera := (nvaloropera * nvlpercentual) / 100;
              END IF;
            END IF;

            CLOSE cvlpercent;
          END IF;
        END IF;
      END IF;
      --
      OPEN cpormedprofat(v_itregra.cd_tab_fat);
      FETCH cpormedprofat INTO ncdpormed, vdspormed;
      IF cpormedprofat%NOTFOUND THEN
        OPEN cpormed;
        FETCH cpormed INTO ncdpormed, vdspormed;
        CLOSE cpormed;
      END IF;
      CLOSE cpormedprofat;
      --
      IF ncdpormed IS NULL THEN
        /*IF nvl(dbamv.pkg_mv2000.le_formulario,'X') <> 'C_VAL_PROC' THEN*/ /*OP 1501*/
		    IF nvl(leFormulario,'X') <> 'C_VAL_PROC' THEN /*OP 1501*/
          /*IF NVL(pkg_mv2000.le_configuracao('FFCV', 'SN_CREDENCIADO_CENTAVOS'), 'N') = 'S' THEN*/ /*OP 1501*/
		      IF NVL(snCredenciadoCentavos, 'N') = 'S' THEN /*OP 1501*/
            OPEN c_tppagamento;
            FETCH c_tppagamento INTO ctppagamento;
            CLOSE c_tppagamento;
            --
            /* PDA.: 270509 - 03/02/2009 - Emanoel Deivison (inicio)
               Caso o tipo de pagamento no item da conta esteja nulo ser? utilizada a fun??o abaixo, que ir?
               verificar o tipo de pagamento de acordo com as regras do conv?nio e credenciamento.
            */
            if ctppagamento is null then
              vvTpPag:=dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(
                                                                        pncdprestador,
                                                                        ncodconvenio,
                                                                        ctipoatend,
                                                                        vprofat,
                                                                        null,
																		null,
																		null,
																		ncodplano,
																		ncdregra,
																		v_grupro.cd_gru_pro
                                                                        );
            else
              vvTpPag:=ctppagamento;
            end if;
            /* PDA.: 270509 (fim)*/
            IF NVL(vvTpPag, 'P') = 'C' THEN /* PDA.: 270509 - Trocado a vari?vel: "ctppagamento" pela: "vvTpPag" e ajustado o NVL que estava com "C'*/
              nvloper := 0;
              nvlfilme := 0;
              nvlporte := 0;
              nvltaxa := 0;
              nvldesconto := 0;
              nvlhonor := 0.01;
              nvlrtotal := 0.01;
              RETURN(0.01);
            END IF;
          END IF;
          --
          --cretmsg := 'Não existe Porte de Ato Médico ' || 'para o procedimento ' || vprofat || CHR(10)
          --            || 'na Tabela tipo CBHPM' || TO_CHAR(v_itregra.cd_tab_fat) || CHR(10)
          --            || 'para Essa Regra !';
          cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_7', 'VAL_PROC_FFCV', 'Não existe cadastro para este procedimento na tela de cadastro de procedimentos CBHPM (Caminho: Faturamento > Tabelas > Gerais > Classificação Hierarquizada CBHPM > Procedimentos).',
                      arg_list(vprofat,TO_CHAR(v_itregra.cd_tab_fat)));  -- OP 10402
        END IF;
        RETURN 0;
      END IF;
      --
      OPEN cvalpormed(ncdpormed, v_itregra.cd_tab_fat);
      FETCH cvalpormed INTO vvalorportemedico;
      CLOSE cvalpormed;
      --
      IF vvalorportemedico IS NULL THEN
        /*IF nvl(dbamv.pkg_mv2000.le_formulario,'X') <> 'C_VAL_PROC' THEN*/ /*OP 1501*/
		    IF nvl(leFormulario,'X') <> 'C_VAL_PROC' THEN /*OP 1501*/
          /*IF NVL(pkg_mv2000.le_configuracao('FFCV', 'SN_CREDENCIADO_CENTAVOS'), 'N') = 'S' THEN*/ /*OP 1501*/
		      IF NVL(snCredenciadoCentavos, 'N') = 'S' THEN /*OP 1501*/
            OPEN c_tppagamento;
            FETCH c_tppagamento INTO ctppagamento;
            CLOSE c_tppagamento;
            --
            /* PDA.: 270509 - 03/02/2009 - Emanoel Deivison (inicio)
               Caso o tipo de pagamento no item da conta esteja nulo ser? utilizada a fun??o abaixo, que ir?
               verificar o tipo de pagamento de acordo com as regras do conv?nio e credenciamento.
            */
            if ctppagamento is null then
              vvTpPag:=dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(
                                                                        pncdprestador,
                                                                        ncodconvenio,
                                                                        ctipoatend,
                                                                        vprofat,
                                                                        null,
																		null,
																		null,
																		ncodplano,
																		ncdregra,
																		v_grupro.cd_gru_pro
                                                                        );
            else
              vvTpPag:=ctppagamento;
            end if;
            /* PDA.: 270509 (fim)*/
            IF NVL(vvTpPag, 'P') = 'C' THEN /* PDA.: 270509 - Trocado a vari?vel: "ctppagamento" pela: "vvTpPag" e ajustado o NVL que estava com "C'*/
              nvloper := 0;
              nvlfilme := 0;
              nvlporte := 0;
              nvltaxa := 0;
              nvldesconto := 0;
              nvlhonor := 0.01;
              nvlrtotal := 0.01;
              RETURN(0.01);
            END IF;
          END IF;
          --
          --cretmsg := 'Não existe Valor de Porte Médico ' || vdspormed || CHR(10)
          --          || ' para a Tabela de Faturamento tipo CBHPM ' || TO_CHAR(v_itregra.cd_tab_fat)
          --          || CHR(10) || ' com data de vigência Inferior a ' || TO_CHAR(vddatarefer, 'DD/MM/YYYY')
          --          || ' para Essa Regra !';
          cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_8', 'VAL_PROC_FFCV', 'Não existe valor de Porte Médico %s para a Tabela de Faturamento tipo CBHPM %s com data de vigência Inferior a %s para essa Regra.',
                      arg_list(vdspormed,TO_CHAR(v_itregra.cd_tab_fat),TO_CHAR(vddatarefer, 'DD/MM/YYYY')));  -- OP 10402
        -- PDA 218812 (Fim)
        END IF;

        RETURN 0;
      END IF;
      --
      nvalorhonor := nvalorhonor * vvalorportemedico;
      --
      IF NVL(nvaloropera, 0) > 0 THEN
        --
        vvaloruco := v_indice.vl_uco;
        --
        IF vvaloruco IS NULL THEN
          --
          --cretmsg := 'Não existe Valor de Unidade de Custo Operacional para o índice informado tipo CBHPM '
          --            || TO_CHAR(NVL(ncdindice, v_convpla.cd_indice)) || CHR(10)
          --            || 'com data de vigência Inferior a' || TO_CHAR(vddatarefer, 'DD/MM/YYYY')
          --            || ' para Essa Regra !';
          cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_9', 'VAL_PROC_FFCV', 'Não existe valor de Unidade de Custo Operacional para o índice informado tipo CBHPM %s com data de vigência inferior a %s para essa Regra.',
                      arg_list(TO_CHAR(NVL(ncdindice, v_convpla.cd_indice)),TO_CHAR(vddatarefer, 'DD/MM/YYYY')));  -- OP 10402
          -- PDA 218812 (Fim)
          RETURN 0;
        END IF;
        --
        nvaloropera := nvaloropera * vvaloruco;
        --
      END IF;
      --
      nvalortotal := NVL(nvaloropera, 0) + NVL(nvalorhonor, 0);
      --
    END IF;
  -- PDA 93269 (INICIO)
  ELSE
    bexcessao := FALSE;
    nvalortotal := nvalproced;
    nvalorhonor := 0;
    nvaloropera := 0;
  END IF;
  --
  OPEN c_valexced(vddatarefer, ncdregra);
  FETCH c_valexced INTO v_valexced;
  CLOSE c_valexced;
  --
  IF ctpatimed IS NOT NULL THEN
    OPEN c_atimed;
    FETCH c_atimed INTO nvlpercatimed, cfuncatimed;
    CLOSE c_atimed;
  ELSE
    nvlpercatimed := 0;
  END IF;
  --
  OPEN c_perchoresp(v_itregra.cd_horario);
  FETCH c_perchoresp INTO nvlperchoresp;
  CLOSE c_perchoresp;
  --
  OPEN c_por_ane_tab(vprofat, vddatarefer, ncdregra, v_grupro.cd_gru_pro);
  FETCH c_por_ane_tab INTO v_por_ane_tab;
  IF c_por_ane_tab%FOUND THEN
    v_grupro.cd_por_ane := v_por_ane_tab.cd_por_ane;
  END IF;
  CLOSE c_por_ane_tab;
  --
  IF v_grupro.cd_por_ane IS NOT NULL THEN
    OPEN c_porteanest(v_grupro.cd_por_ane, NVL(ncdtabfatporte, v_itregra.cd_tab_fat), vddatarefer);
    FETCH c_porteanest INTO nvalorporte;
    CLOSE c_porteanest;
  ELSE
    nvalorporte := 0;
  END IF;
  IF v_grupro.cd_por_ane IS NOT NULL AND NVL(nvalorporte, 0) = 0 THEN
    /*IF NVL(pkg_mv2000.le_configuracao('FFCV', 'SN_CREDENCIADO_CENTAVOS'), 'N') = 'S' THEN*/ /*OP 1501*/
		IF NVL(snCredenciadoCentavos, 'N') = 'S' THEN /*OP 1501*/
			OPEN c_tppagamento;
			FETCH c_tppagamento INTO ctppagamento;
			CLOSE c_tppagamento;
			--
			/* PDA.: 270509 - 03/02/2009 - Emanoel Deivison (inicio)
				 Caso o tipo de pagamento no item da conta esteja nulo ser? utilizada a fun??o abaixo, que ir?
				 verificar o tipo de pagamento de acordo com as regras do conv?nio e credenciamento.
			*/
			if ctppagamento is null then
				vvTpPag:=dbamv.pkg_ffcv_it_conta.fnc_retorna_tp_pagamento(	pncdprestador,
																			ncodconvenio,
																			ctipoatend,
																			vprofat,
																			null,
																			null,
																			null,
																			ncodplano,
																			ncdregra,
																			v_grupro.cd_gru_pro
																			);
			else
				vvTpPag:=ctppagamento;
			end if;
			/* PDA.: 270509 (fim)*/
			IF NVL(vvTpPag, 'P') = 'C' THEN /* PDA.: 270509 - Trocado a vari?vel: "ctppagamento" pela: "vvTpPag" e ajustado o NVL que estava com "C'*/
				nvloper := 0;
				nvlfilme := 0;
				nvlporte := 0;
				nvltaxa := 0;
				nvldesconto := 0;
				nvlhonor := 0.01;
				nvlrtotal := 0.01;
				RETURN(0.01);
			END IF;
		END IF;
    --
    --cretmsg :=
    --  'Não existe Valor de Porte ' || TO_CHAR(v_grupro.cd_por_ane) || CHR(10)
    --  || 'para a Tabela de Faturamento ' || TO_CHAR(v_itregra.cd_tab_fat) || CHR(10)
    --  || 'com data de vigência Inferior a ' || TO_CHAR(vddatarefer, 'DD/MM/YYYY')
    --  || 'para Essa Regra !';
    cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_10', 'VAL_PROC_FFCV', 'Não existe valor de Porte %s para a Tabela de Faturamento %s com data de vigência Inferior a %s para essa Regra.',
                arg_list(TO_CHAR(v_grupro.cd_por_ane),TO_CHAR(v_itregra.cd_tab_fat),TO_CHAR(vddatarefer, 'DD/MM/YYYY')));  -- OP 10402
    -- PDA 218812 (Fim)
    RETURN 0;
  END IF;
  --

  IF NVL(bprocessarvalor, TRUE) = FALSE THEN

    IF NVL(nvalortotal, 0) = 0 THEN
      /*IF nvl(dbamv.pkg_mv2000.le_formulario,'X') <> 'C_VAL_PROC' THEN*/ /*OP 1501*/
      IF nvl(leFormulario,'X') <> 'C_VAL_PROC' THEN /*OP 1501*/
        --cretmsg :=
        --  'Não existe Preço definido para o procedimento: ' || vprofat
        --  || ' , contacte o Faturamento!';
        cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_11', 'VAL_PROC_FFCV', 'Não existe Preço definido para o procedimento %s. Contacte o Faturamento!',
                    arg_list(vprofat));  -- OP 10402
      END IF;
    END IF;

    -- OP 35103 - 07/01/2016 - Indica Qtde De Casas Decimais Serão Consideradas No Cálculo Do Valor Unitário Nas Contas Do Faturamento.
    IF vTruncaValor = 'S' THEN
      IF nvalortotal IS NOT NULL then
        nvalortotal := trunc(round(nvalortotal,4),nQtCasasVlUnit);
      END IF;
    ELSE -- OP 42583 (Inicio)
      IF nvalortotal IS NOT NULL then
        nvalortotal := round(nvalortotal, nQtCasasVlUnit);
      END IF; -- OP 42583 (Fim)
    END IF;
    -- OP 35103 - fim
    RETURN NVL(nvalortotal, 0);
  END IF;

  --
  OPEN ckit;
  FETCH ckit INTO vckit;
  CLOSE ckit;
  --
  OPEN cconfig;
  FETCH cconfig INTO vcconfig;
  CLOSE cconfig;
  --
  IF NVL(vckit.valor, 'N') = 'S' AND NVL(vcconfig.valor, 'N') = 'S' THEN
    baplicaregraexced := FALSE;
  ELSE
    baplicaregraexced := TRUE;
  END IF;
  --
  IF baplicaregraexced THEN
    IF (NVL(v_valexced.vl_subsequente, 0) > 0 OR NVL(v_valexced.vl_percentual_sub, 0) > 0) AND v_valexced.qt_subsequente > 0 THEN
      --
      /* Ap?s atualiza??o da vers?o 4.5.G no H9J, eles verificaram altera??o no c?lculo dos
         procedimentos com regra de valores excedentes. Em conex?o com T?rcio que se encontra
         no hospital, foi verificado que a forma anterior ao pda 113438 ? a forma como eles
         querem que seja efetuado o c?lculo. Alexandre Erik consultou Henrique Antunes, Pereira
         e Gerluce, e foi verificado que o correto ? deixar como estava antes.
         At? a quantidade inicial configurada na tela de valores excedentes, o procedimento fica
         com o valor unit?rio (sem multiplicar pela quantidade). Passando desta quantidade, ?
         utilizada a quantidade excedente para calcular o percentual ou valor desejado.
         Abaixo foi comentado o c?digo implementado no pda 113438, e descomentado o c?digo
         anterior ao mesmo.                                                                  */
      --
      IF NVL(v_hospital.cd_hospital, 0) IN(312) THEN
        nsomatotal := 0;
        OPEN csomaregtotal(ncdconta);
        FETCH csomaregtotal INTO nsomatotal;
        CLOSE csomaregtotal;
        nqtdeexced := CEIL(NVL(nsomatotal, 1) - v_valexced.qt_inicial);
        IF nqtdeexced > 0 THEN
          nqtdeexced := nqtde;
          IF NVL(v_valexced.vl_percentual_sub, 0) > 0 THEN
            nvalorexced :=((nvalortotal * v_valexced.vl_percentual_sub) / 100);
          ELSE
            nvalorexced := v_valexced.vl_subsequente;
          END IF;
          bexcedente := TRUE;
        ELSE
          nqtdeexced := 0;
          nvalorexced := 0;
          bexcedente := FALSE;
        END IF;
      ELSE
        nqtdeexced := CEIL((NVL(nqtde, 1) - v_valexced.qt_inicial) / v_valexced.qt_subsequente);
        IF nqtdeexced > 0 THEN
          IF NVL(v_valexced.vl_percentual_sub, 0) > 0 THEN
            nvalorexced :=((nvalortotal * v_valexced.vl_percentual_sub) / 100);
          ELSE
            nvalorexced := v_valexced.vl_subsequente;
          END IF;
          bexcedente := TRUE;
        ELSE
          nvalorexced := 0;
          bexcedente := TRUE;
        END IF;
      END IF;
    ELSE
      nvalorexced := 0;
      bexcedente := FALSE;
    END IF;
  END IF;
  --
  /* caso exista regra de exce??o e regra de valores excedentes, desconsidera-se a regra de valor excedente */
  IF bexcedente AND nCliente = 737 THEN  /*dbamv.pkg_mv2000.le_cliente = 737 THEN*/ /*OP 1501*/
    OPEN cvalrelac;
    FETCH cvalrelac INTO nvalrelac;
    CLOSE cvalrelac;
    IF nvalrelac > 0 THEN
      bexcedente := FALSE;
    END IF;
  END IF;
  --
  /* Marcos Gatti
   * SUP-306831/FATURCONV-23617
   * Criada consulta para pegar a data de lançamento do item da conta, 
   * dessa forma o sistema consegue identificar se esse dia é um feriado
  */
  --
  begin
    select a.dt_lancamento
      into vdtLancamento
      from dbamv.itreg_fat a
     where a.cd_reg_fat    = ncdconta 
       and a.cd_lancamento = ncdlancamento;
  exception
    when others then
      --
      vdtLancamento := vddatarefer;
      --
  end;
  --
  OPEN c_feriado(vdtLancamento);
  FETCH c_feriado INTO v_feriado;
  CLOSE c_feriado;
  --


  /*OP 26104*/
  open cDataRefHorarioEspec (ncdlancamento, ncdconta, ctipoatend);
  fetch cDataRefHorarioEspec into vDataRefHorarioEspec ;
  if cDataRefHorarioEspec%found then
      vdatareferHorarioEspec :=  vDataRefHorarioEspec.dt_lancamento;
      vhorareferHorarioEspec := vDataRefHorarioEspec.hr_lancamento;
	  vSnHorarioEspecial     := vDataRefHorarioEspec.sn_horario_especial;/*OP 30533 - PDA 759752*/
  end if;
  close cDataRefHorarioEspec;
  /*OP 26104*/


  IF v_feriado.ds_feriado IS NOT NULL THEN
    /*OPEN c_horesp(v_itregra.cd_horario, ncdregra, 8, vdhorarefer, ctipoatend);*/ /*OP 26104*/
	OPEN c_horesp(v_itregra.cd_horario, ncdregra, 8, nvl(vhorareferHorarioEspec,vdhorarefer), ctipoatend); /*OP 26104*/
    FETCH c_horesp INTO v_horesp;
    CLOSE c_horesp;
    IF NVL(v_horesp.sn_hor_esp, 'N') = 'S'
       AND Nvl(vSnHorarioEspecial,'N') = 'S' /*OP 30533 - PDA 759752*/
       THEN
      csnhorarioesp := 'S';
    ELSE
      csnhorarioesp := 'N';
    END IF;

    /*OP 35599 - caso não tenha retornado o horário especial do item da regra, verificar se existe horário especial por procedimento
     para que a rotina de verificação de HE seja chamada abaixo*/
    IF csnhorarioesp = 'N' THEN
         OPEN cHorarioEspecProced(ncdregra,
                                  v_grupro.cd_gru_pro,
                                  vprofat,
                                  8 ,
                                  nvl(vhorareferHorarioEspec,vdhorarefer),
                                  ctipoatend);
         FETCH cHorarioEspecProced INTO vHorarioEspecProced;
         CLOSE cHorarioEspecProced;
         IF Nvl(vHorarioEspecProced.sn_hor_esp,'N') = 'S' AND vSnHorarioEspecial = 'S' THEN
            csnhorarioesp := 'S';
         END IF;
    END IF;
    /*OP 35599*/


  ELSE
    /*OPEN c_horesp(v_itregra.cd_horario, ncdregra, TO_NUMBER(TO_CHAR(vddatarefer, 'd')), vdhorarefer, ctipoatend);*/ /*OP 26104*/
	OPEN c_horesp(v_itregra.cd_horario, ncdregra, TO_NUMBER(TO_CHAR(nvl(vdatareferHorarioEspec,vddatarefer), 'd')), nvl(vhorareferHorarioEspec,vdhorarefer), ctipoatend); /*OP 26104*/
    FETCH c_horesp INTO v_horesp;
    CLOSE c_horesp;
    IF NVL(v_horesp.sn_hor_esp, 'N') = 'S'
       AND Nvl(vSnHorarioEspecial,'N') = 'S' /*OP 30533 - PDA 759752*/
       THEN
      csnhorarioesp := 'S';
    ELSE
      csnhorarioesp := 'N';
    END IF;

    /*OP 35599 - caso não tenha retornado o horário especial do item da regra, verificar se existe horário especial por procedimento
     para que a rotina de verificação de HE seja chamada abaixo*/
    IF csnhorarioesp = 'N' THEN
         OPEN cHorarioEspecProced(ncdregra,
                                  v_grupro.cd_gru_pro,
                                  vprofat,
                                  TO_NUMBER(TO_CHAR(nvl(vdatareferHorarioEspec,vddatarefer), 'd')),
                                  nvl(vhorareferHorarioEspec,vdhorarefer),
                                  ctipoatend);
         FETCH cHorarioEspecProced INTO vHorarioEspecProced;
         CLOSE cHorarioEspecProced;
         IF Nvl(vHorarioEspecProced.sn_hor_esp,'N') = 'S' AND vSnHorarioEspecial = 'S' THEN
            csnhorarioesp := 'S';
         END IF;
    END IF;
    /*OP 35599*/

  END IF;
  -- pda 475094 - Não calcular horàrio especial na C_VAL_PROC
  /*IF nvl(dbamv.pkg_mv2000.le_formulario,'X') = 'C_VAL_PROC' THEN*/ /*OP 1501*/
  IF nvl(leFormulario,'X') = 'C_VAL_PROC' THEN /*OP 1501*/
    csnhorarioesp := 'N';
  END IF;
  -- pda 475094 - fim
  --
  IF NVL(csnhorarioesp, 'N') = 'S' THEN
    OPEN cdadoscdgrufat;
    FETCH cdadoscdgrufat INTO vdadoscdgrufat;
    CLOSE cdadoscdgrufat;
    /*IF dbamv.pack_aux_ffcv.is_hor_esp(ncodconvenio, ncodplano, ctipoatend, vddatarefer, vdhorarefer, vdadoscdgrufat.cd_gru_fat, vprofat, ncdregra) THEN*/  /*OP 26104*/
	IF dbamv.pack_aux_ffcv.is_hor_esp(ncodconvenio, ncodplano, ctipoatend, nvl(vdatareferHorarioEspec,vddatarefer), nvl(vhorareferHorarioEspec,vdhorarefer), vdadoscdgrufat.cd_gru_fat, vprofat, ncdregra)  
     AND  Nvl(vTpMvto,'X')<>'HEReplica' THEN /*OP 26104  ALLS OP 42710*/ 
      
      /*OP 35599 - se existir horário especial, verificar se existe por procedimento primeiro, já que a tela de cadastro de Regra não deixa cadastrar
      regras conflitantes entre exceção de HR e HE por Procedimento.*/
      OPEN cHorarioEspecProced(ncdregra,
                                  v_grupro.cd_gru_pro,
                                  vprofat,
                                  TO_NUMBER(TO_CHAR(nvl(vdatareferHorarioEspec,vddatarefer), 'd')),
                                  nvl(vhorareferHorarioEspec,vdhorarefer),
                                  ctipoatend);
      FETCH cHorarioEspecProced INTO vHorarioEspecProced;
      CLOSE cHorarioEspecProced;
      IF Nvl(vHorarioEspecProced.sn_hor_esp,'N') = 'S' THEN
           /*OP 35613 - 37315 - inserir/duplicar procedimento de HE na conta */
           IF Nvl(vHorarioEspecProced.sn_replica_proc,'N') = 'S' 
             AND vTpMvto <> 'HEReplica' THEN
             DBAMV.PRC_FFCV_REPLICA_PROC_HE(ncdconta,
                                            ncdlancamento,
                                            ctipoatend,
                                            vHorarioEspecProced.vl_percentual,
                                            'N'); 


             nvlperchoresp := 0;
           ELSE
           /*OP 35613 - 37315*/
             nvlperchoresp := vHorarioEspecProced.vl_percentual;
           END IF;

      ELSE
      /*OP 35599*/
      
          OPEN cdadosvlpercentual(ncdregra, v_grupro.cd_gru_pro);
          FETCH cdadosvlpercentual INTO vdadosvlpercentual;
          CLOSE cdadosvlpercentual;
          IF vdadosvlpercentual.vl_percentual IS NOT NULL THEN
              /*OP 35613 - 37315 - inserir/duplicar procedimento de HE na conta */
             IF Nvl(vdadosvlpercentual.sn_replica_proc,'N') = 'S' 
             AND vTpMvto <> 'HEReplica' THEN 

               DBAMV.PRC_FFCV_REPLICA_PROC_HE(ncdconta,
                                            ncdlancamento,
                                            ctipoatend,
                                            vdadosvlpercentual.vl_percentual,
                                            'N'); 


               nvlperchoresp := 0;
             ELSE
             /*OP 35613 - 37315*/
               nvlperchoresp := vdadosvlpercentual.vl_percentual;
             END IF;

          END IF;

      END IF;
    ELSE
      nvlperchoresp := 0;
    END IF;
  END IF;
  --
  OPEN clocgrupromult(v_grupro.cd_gru_pro);
  FETCH clocgrupromult INTO vnqtd_gru_pro;
  CLOSE clocgrupromult;
  --
  -- pda 463268 - trazido mais para cima para calcular primeiro o indice de CH
  -- pda 369670 - 01/06/2010 - Amalia Ara?jo - calcular ?ndice para CBHPM quando houver exce??o usando ?ndice.
  --IF bexcessao AND v_itregra.tp_tab_fat <> 'H' THEN
  IF bexcessao THEN
  -- pda 369670 - fim
    IF v_tabconvenio.sn_usar_indice = 'S' THEN
      bindice := TRUE;
    ELSE
      bindice := FALSE;
    END IF;
  ELSE
    IF v_itregra.tp_tab_fat = 'C' THEN
      bindice := TRUE;
    ELSE
      bindice := FALSE;
    END IF;
  END IF;
  --
  v_indice_profat.vl_percentual := 0;
  OPEN c_indice_profat(vprofat, ncdregra, v_grupro.cd_gru_pro, ncodtipoaco);
  FETCH c_indice_profat INTO v_indice_profat;
  CLOSE c_indice_profat;
  --
  -- pda 492733 - 10/02/2012 - Amalia Ara?jo
  -- No Hosp Adv Bel?m, eles precisam calcular o percentual de acomoda??o em cima do operacional tamb?m, por isso foi criado o par?metro SN_CALCULA_ACOMODACAO_OPERACIONAL_CBHPM
  open  cCalculaOperCbhpm;
  fetch cCalculaOperCbhpm into vCalculaOperCbhpm;
  close cCalculaOperCbhpm;
  -- pda 492733 - fim
  --
  -- pda 288206 - 21/05/2009 - Amalia Ara?jo
  -- Para valores de tabela CBHPM, o acr?scimo da acomoda??o N?o ser? calculado para o valor operacional (UCO). Ver IFs abaixo na nvaloropera.
  IF NVL(v_indice_profat.vl_percentual, 0) > 0 THEN
    IF v_grupro.tp_gru_pro IN('SP', 'SD', 'SH') THEN
      nvalortotal := nvalortotal *(v_indice_profat.vl_percentual / 100);
      nvalorexced := nvalorexced *(v_indice_profat.vl_percentual / 100);
      nvalorhonor := nvalorhonor *(v_indice_profat.vl_percentual / 100);
      if v_itregra.tp_tab_fat <> 'H' or nvl(vCalculaOperCbhpm,'N') = 'S' then   -- pda 288206 -- pda 492733
        nvaloropera := nvaloropera *(v_indice_profat.vl_percentual / 100);
      end if;
      nvalorporte := nvalorporte *(v_indice_profat.vl_percentual / 100);
    END IF;
  ELSE
    IF NVL(nvlpercsp, 0) > 0 AND v_grupro.tp_gru_pro = 'SP' THEN
      nvalortotal := nvalortotal *(nvlpercsp / 100);
      nvalorexced := nvalorexced *(nvlpercsp / 100);
      nvalorhonor := nvalorhonor *(nvlpercsp / 100);
      nvalorporte := nvalorporte *(nvlpercsp / 100);
      if v_itregra.tp_tab_fat <> 'H' or nvl(vCalculaOperCbhpm,'N') = 'S' then   -- pda 288206 -- pda 492733
         nvaloropera := nvaloropera *(nvlpercsp / 100);
      end if;
    END IF;
    IF NVL(nvlpercsd, 0) > 0 AND v_grupro.tp_gru_pro = 'SD' THEN
      nvalortotal := nvalortotal *(nvlpercsd / 100);
      nvalorexced := nvalorexced *(nvlpercsd / 100);
      nvalorhonor := nvalorhonor *(nvlpercsd / 100);
      nvalorporte := nvalorporte *(nvlpercsd / 100);
      if v_itregra.tp_tab_fat <> 'H' or nvl(vCalculaOperCbhpm,'N') = 'S' then   -- pda 288206 -- pda 492733
        nvaloropera := nvaloropera *(nvlpercsd / 100);
      end if;
    END IF;
    IF NVL(nvlpercsh, 0) > 0 AND v_grupro.tp_gru_pro = 'SH' THEN
      nvalortotal := nvalortotal *(nvlpercsh / 100);
      nvalorexced := nvalorexced *(nvlpercsh / 100);
      nvalorhonor := nvalorhonor *(nvlpercsh / 100);
      nvalorporte := nvalorporte *(nvlpercsh / 100);
      if v_itregra.tp_tab_fat <> 'H' or nvl(vCalculaOperCbhpm,'N') = 'S' then   -- pda 288206 -- pda 492733
        nvaloropera := nvaloropera *(nvlpercsh / 100);
      end if;
    END IF;
    -- pda 288206 - fim
  END IF;
  -- pda 463268 - fim
  --
	-- OP 399 - 11/10/2013 - incluindo a condi??o da exce??o de percentual de Cobran?a "and not bProcComExcPercCobranca"
  -- pda 504861 - trazido mais para cima, pois N?o estava gravando corretamente a qt ch com hor?rio especial
  IF NVL(v_itregra.vl_percentual_itregra, 0) > 0 AND NOT bexcessao AND NOT bProcComExcPercCobranca THEN
    IF NVL(v_itregra.tp_valor_base, 'T') = 'T' THEN
      nvalortotal := nvalortotal *(v_itregra.vl_percentual_itregra / 100);
      nvalorexced := nvalorexced *(v_itregra.vl_percentual_itregra / 100);
      nvalorhonor := nvalorhonor *(v_itregra.vl_percentual_itregra / 100);
      nvaloropera := nvaloropera *(v_itregra.vl_percentual_itregra / 100);
      nvalorporte := nvalorporte *(v_itregra.vl_percentual_itregra / 100);
    ELSIF v_itregra.tp_valor_base = 'O' THEN
      nvaloropera := nvaloropera *(v_itregra.vl_percentual_itregra / 100);
      nvalortotal := NVL(nvaloropera, 0) + NVL(nvalorhonor, 0);
    ELSIF v_itregra.tp_valor_base = 'H' THEN
      nvalorhonor := nvalorhonor *(v_itregra.vl_percentual_itregra / 100);
      nvalortotal := NVL(nvaloropera, 0) + NVL(nvalorhonor, 0);
    /* pda 550703 - 20/11/2012 - tratando nova op??o de HONORARIO+PORTE incluindo o porte no c?lculo do percentual */
    ELSIF v_itregra.tp_valor_base = 'P' THEN
      nvalorporte := nvalorporte *(v_itregra.vl_percentual_itregra / 100);
      nvalorhonor := nvalorhonor *(v_itregra.vl_percentual_itregra / 100);
      nvalortotal := NVL(nvaloropera, 0) + NVL(nvalorhonor, 0);
    /* pda 550703 - fim */
    END IF;
  END IF;
  --
  IF csnhorarioesp = 'S' AND NVL(nvlperchoresp, 0) > 0 THEN
    IF v_grupro.tp_gru_pro <> 'SD' AND NOT bexcessao THEN
      nvalortotal := nvalortotal +(nvalortotal * nvlperchoresp / 100);
      nvalorexced := nvalorexced +(nvalorexced * nvlperchoresp / 100);
      nvalorhonor := nvalorhonor +(nvalorhonor * nvlperchoresp / 100);
      nvalorporte := nvalorporte +(nvalorporte * nvlperchoresp / 100);
    ELSIF v_grupro.tp_gru_pro = 'SD' AND NOT bexcessao THEN
      IF v_itregra.tp_hor_esp_sd = 'T' THEN
        nvalortotal := nvalortotal +(nvalortotal * nvlperchoresp / 100);
        nValorExced := nValorExced + ( nValorExced * nVlPercHorEsp / 100 ) ;
        nvalorhonor := nvalorhonor +(nvalorhonor * nvlperchoresp / 100);
        nvaloropera := nvaloropera +(nvaloropera * nvlperchoresp / 100);
        nvalorporte := nvalorporte +(nvalorporte * nvlperchoresp / 100);
      ELSIF v_itregra.tp_hor_esp_sd = 'H' THEN
        nvalorhonor := nvalorhonor +(nvalorhonor * nvlperchoresp / 100);
        nvalorporte := nvalorporte +(nvalorporte * nvlperchoresp / 100);
      END IF;
    ELSIF bexcessao AND cexcesshoresp = 'S' THEN
      nvalortotal := nvalortotal +(nvalortotal * nvlperchoresp / 100);
      nvalorexced := nvalorexced +(nvalorexced * nvlperchoresp / 100);
      nvalorhonor := nvalorhonor +(nvalorhonor * nvlperchoresp / 100);
      nvaloropera := nvaloropera +(nvaloropera * nvlperchoresp / 100);
      nvalorporte := nvalorporte +(nvalorporte * nvlperchoresp / 100);
    END IF;
  END IF;
  -- pda 504861 - fim

  -- pda 463268 - 10/11/2011 - Amalia Ara?jo - O c?lculo do ?ndice foi trazido mais para cima, antes de calcular
  -- os percentuais de atividade m?dica e %proc, por causa do c?lculo do Ipergs (truncamento).
  IF bindice THEN --Indice CH
    --
    IF NVL(v_indice.vl_ind, 0) = 0 THEN
      --cretmsg := 'N?o existe Valor de Indice Cadastrado !';
      cretmsg := pkg_rmi_traducao.extrair_pkg_msg('MSG_12', 'VAL_PROC_FFCV', 'Não existe valor de índice Cadastrado!',
                   arg_list());  -- OP 10402
      RETURN 0;
    END IF;
    --
    nvlchtotal := nvalortotal;
    nvlchhonor := nvalorhonor;
    --
    if vTruncaValor = 'S' then

      --PDA 467341(inicio)- Aplica??o do truncamento de 4 casas conforme PDA 364198 apenas se N?o tiver franquia.
      if (ncdfranquia is not null) or
         (npercfranquia is not null) then
        nNroCasasTrunc := 2;
      else
        nNroCasasTrunc := 4;
      end if;
      --PDA 467341(fim)

      IF NOT bexcessao THEN
        --PDA 364198(in?cio) - colocado 4 casas decimais no truncamento(estava 2), pois estava
        --truncando em duas casas antes de aplicar o percentual da franquia(paticipa??o do paciente)
        --nvalortotal,nvalorexced,nvalorhonor,nvaloropera,nvalorporte

        nvalortotal := Trunc(Round( nvalortotal * v_indice.vl_ind,4)  ,nNroCasasTrunc);
        nvalorexced := Trunc(Round( nvalorexced * v_indice.vl_ind,4)  ,nNroCasasTrunc);
        nvalorhonor := Trunc(Round( nvalorhonor * v_indice.vl_honor,4),nNroCasasTrunc);
        nvaloropera := Trunc(Round( nvaloropera * v_indice.vl_ind,4)  ,nNroCasasTrunc);
        nvalorporte := Trunc(Round( nvalorporte * v_indice.vl_honor,4),nNroCasasTrunc);

        --PDA 364198(fim)
      ELSE
        --PDA 364198(in?cio) - colocado 4 casas decimais no truncamento(estava 2), pois estava
        --truncando em duas casas antes de aplicar o percentual da franquia(paticipa??o do paciente)
        --nvalortotal,nvalorexced,nvalorhonor,nvaloropera,nvalorporte
        nvalortotal := Trunc(Round( nvalortotal * v_indice.vl_ind,4),nNroCasasTrunc);
        nvalorexced := Trunc(Round( nvalorexced * v_indice.vl_ind,4),nNroCasasTrunc);
        nvalorhonor := Trunc(Round( nvalorhonor * v_indice.vl_ind,4),nNroCasasTrunc);
        nvaloropera := Trunc(Round( nvaloropera * v_indice.vl_ind,4),nNroCasasTrunc);
        nvalorporte := Trunc(Round( nvalorporte * v_indice.vl_ind,4),nNroCasasTrunc);
        --PDA 364198(fim)
      END IF;
    else
    -- pda 463268 - fim
      IF NOT bexcessao THEN
        nvalortotal := nvalortotal * v_indice.vl_ind;
        nvalorexced := nvalorexced * v_indice.vl_ind;
        nvalorhonor := nvalorhonor * v_indice.vl_honor;
        nvaloropera := nvaloropera * v_indice.vl_ind;
        nvalorporte := nvalorporte * v_indice.vl_honor;
      ELSE
        nvalortotal := nvalortotal * v_indice.vl_ind;
        nvalorexced := nvalorexced * v_indice.vl_ind;
        nvalorhonor := nvalorhonor * v_indice.vl_ind;
        nvaloropera := nvaloropera * v_indice.vl_ind;
        nvalorporte := nvalorporte * v_indice.vl_ind;
      END IF;
    end if;
    --
    IF v_acresdesc.sn_vl_operacional = 'N' AND v_acresdesc.sn_vl_honorario = 'N' THEN
      IF cfuncatimed = 'N' THEN
        nvlacres :=(nvalorporte *(v_acresdesc.vl_perc_acrescimo / 100));         -- V_Indice.vl_ind;
        nvlacresexced :=(nvalorporte *(v_acresdesc.vl_perc_acrescimo / 100));    -- V_Indice.vl_ind;
        nvldesc :=(nvalorporte *(v_acresdesc.vl_perc_desconto / 100));           -- V_Indice.vl_ind;
        nvldescexced :=(nvalorporte *(v_acresdesc.vl_perc_desconto / 100));      -- V_Indice.vl_ind;
      ELSE
        nvlacres :=(nvalortotal *(v_acresdesc.vl_perc_acrescimo / 100));         -- V_Indice.vl_ind;
        nvlacresexced :=(nvalorexced *(v_acresdesc.vl_perc_acrescimo / 100));    -- V_Indice.vl_ind;
        nvldesc :=(nvalortotal *(v_acresdesc.vl_perc_desconto / 100));           -- V_Indice.vl_ind;
        nvldescexced :=(nvalortotal *(v_acresdesc.vl_perc_desconto / 100));      -- V_Indice.vl_ind;
      END IF;
    ELSE
      nvlacres := (nvlacreshonor * v_indice.vl_honor) +(nvlacresoper * v_indice.vl_ind);
      nvlacresexced := (nvlacreshonor * v_indice.vl_honor) +(nvlacresoper * v_indice.vl_ind);
      nvldesc := (nvldescoper * v_indice.vl_ind) +(nvldeschonor * v_indice.vl_honor);
      nvldescexced := (nvldescoper * v_indice.vl_ind) +(nvldeschonor * v_indice.vl_honor);
    END IF;
    --
  END IF; --Indice CH
  --
  nvlacres := nvlacres + nvlacresfilme;
  nvldesc := nvldesc + nvldescfilme;
  nvlacresexced := nvlacresexced + nvlacresfilme;
  nvldescexced := nvldescexced + nvldescfilme;
  -- pda 463268 - fim

  IF ctpatimed IS NOT NULL THEN
    /* pda 277748 - 07/06/2009 - Amalia Ara?jo - truncando os valores ao inv?s de arredondar */
    if vTruncaValor = 'S' then
      nvalortotal := Trunc(Round( Trunc(Round(nvalortotal,4),2) *(nvlpercatimed / 100),4),2);
      nvaloropera := Trunc(Round( Trunc(Round(nvaloropera,4),2) *(nvlpercatimed / 100),4),2);
      nvalorexced := Trunc(Round( Trunc(Round(nvalorexced,4),2) *(nvlpercatimed / 100),4),2);
      nvalorhonor := Trunc(Round( Trunc(Round(nvalorhonor,4),2) *(nvlpercatimed / 100),4),2);
      nvalorporte := Trunc(Round( Trunc(Round(nvalorporte,4),2) *(nvlpercatimed / 100),4),2);
    else
    /* pda 277748 - fim */
      nvalortotal := nvalortotal *(nvlpercatimed / 100);
      nvaloropera := nvaloropera *(nvlpercatimed / 100);
      nvalorexced := nvalorexced *(nvlpercatimed / 100);
      nvalorhonor := nvalorhonor *(nvlpercatimed / 100);
      nvalorporte := nvalorporte *(nvlpercatimed / 100);
    end if;
  END IF;
  --
  IF NVL(nvlpercirmult, 0) > 0 THEN
    IF (NVL(vnqtd_gru_pro, 0) > 0 AND NVL(nvlpercirmult, 0) <> 100) THEN
      --
      IF v_itregra.tp_tab_fat IN('C', 'R') THEN
        /*FORMA DE CALCULO SE FOR TABELA AMB*/
        nvalorhonor := nvalorhonor *(nvlpercirmult / 100);
        nvaloropera := nvaloropera *(nvlpercirmult / 100);
      ELSIF v_itregra.tp_tab_fat = 'H' THEN
        /*FORMA DE CALCULO SE FOR TABELA CBHPM*/
        nvaloropera := nvaloropera *(nvlpercirmult / 100);
        nvalorhonor := nvalorhonor;
      END IF;
      --
      nvalorexced := nvalorexced;
      nvalorporte := nvalorporte;
      nvalorfilme := nvalorfilme;
      /* PDA 145553 - RODRIGO VALENTIM - INICIO - Multiplos Exames
       * Essa implementa??o (Multiplos Exames) far? a correta Cobran?a com rela??o aos exames multiplos
       * que para AMB tem o calculo normal do Honor?rio e Operacional e para CBHPM o calculo ? somente em cima
       * do valor operacional.
       * Valor total tamb?m mudar? a rotina de calculo, ele passar? a ser composto pelo valor do porte + valor honor?rio,
       * + valor operacional + valor do filme. Dessa forma, o processo de Cobran?a ficar? correto, evitando glosas.
       */
      nvalortotal := NVL(nvalorporte, 0) + NVL(nvalorhonor, 0) + NVL(nvaloropera, 0) + NVL(nvalorfilme, 0);
    ELSE
      /* pda 331637 - 30/12/2009 - Amalia Ara?jo - acerto para o truncamento */
      if vTruncaValor = 'S' then
		    /* pda 503461 - 29/03/2012 - Amalia Ara?jo - estava ficando zerado itens com valor de tabela menor que 0,01 centavo  */
	      IF v_itregra.tp_tab_fat = 'R' AND (Nvl(nvaloropera,0) + Nvl(nvalorhonor,0) < 0.01) THEN
          nvalortotal := trunc(round(nvalortotal *(nvlpercirmult / 100),4),4);
          nvalorexced := trunc(round(nvalorexced *(nvlpercirmult / 100),4),4);
          nvalorporte := trunc(round(nvalorporte *(nvlpercirmult / 100),4),4);
          nvalorhonor := trunc(round(nvalorhonor *(nvlpercirmult / 100),4),4);
          nvaloropera := trunc(round(nvaloropera *(nvlpercirmult / 100),4),4);
        else
		    /* pda 503461 - fim */
          nvalortotal := trunc(round(nvalortotal *(nvlpercirmult / 100),4),2);
          nvalorexced := trunc(round(nvalorexced *(nvlpercirmult / 100),4),2);
          nvalorporte := trunc(round(nvalorporte *(nvlpercirmult / 100),4),2);
          nvalorhonor := trunc(round(nvalorhonor *(nvlpercirmult / 100),4),2);
          nvaloropera := trunc(round(nvaloropera *(nvlpercirmult / 100),4),2);
        END IF;
        nvalorfilme := nvalorfilme *(nvlpercirmult / 100);
        /* pda 331637 - fim */
      else
        nvalortotal := nvalortotal *(nvlpercirmult / 100);
        nvalorexced := nvalorexced *(nvlpercirmult / 100);
        nvalorporte := nvalorporte *(nvlpercirmult / 100);
        nvalorhonor := nvalorhonor *(nvlpercirmult / 100);
        nvaloropera := nvaloropera *(nvlpercirmult / 100);
        nvalorfilme := nvalorfilme *(nvlpercirmult / 100);
      end if;
    END IF;
  END IF;
  --
  -- pda 463268 - comentando aqui e colocando mais acima
  /*
  -- pda 369670 - 01/06/2010 - Amalia Araàjo - calcular índice para CBHPM quando houver exceàào usando índice.
  --IF bexcessao AND v_itregra.tp_tab_fat <> 'H' THEN
  IF bexcessao THEN
  -- pda 369670 - fim
    IF v_tabconvenio.sn_usar_indice = 'S' THEN
      bindice := TRUE;
    ELSE
      bindice := FALSE;
    END IF;
  ELSE
    IF v_itregra.tp_tab_fat = 'C' THEN
      bindice := TRUE;
    ELSE
      bindice := FALSE;
    END IF;
  END IF;
  --
  v_indice_profat.vl_percentual := 0;
  OPEN c_indice_profat(vprofat, ncdregra, v_grupro.cd_gru_pro, ncodtipoaco);
  FETCH c_indice_profat INTO v_indice_profat;
  CLOSE c_indice_profat;
  --
  -- pda 288206 - 21/05/2009 - Amalia Ara?jo
  -- Para valores de tabela CBHPM, o acr?scimo da acomoda??o N?o ser? calculado para o valor operacional (UCO). Ver IFs abaixo na nvaloropera.
  IF NVL(v_indice_profat.vl_percentual, 0) > 0 THEN
    IF v_grupro.tp_gru_pro IN('SP', 'SD', 'SH') THEN
      nvalortotal := nvalortotal *(v_indice_profat.vl_percentual / 100);
      nvalorexced := nvalorexced *(v_indice_profat.vl_percentual / 100);
      nvalorhonor := nvalorhonor *(v_indice_profat.vl_percentual / 100);
      if v_itregra.tp_tab_fat <> 'H' then
        nvaloropera := nvaloropera *(v_indice_profat.vl_percentual / 100);
      end if;
      nvalorporte := nvalorporte *(v_indice_profat.vl_percentual / 100);
    END IF;
  ELSE
    IF NVL(nvlpercsp, 0) > 0 AND v_grupro.tp_gru_pro = 'SP' THEN
      nvalortotal := nvalortotal *(nvlpercsp / 100);
      nvalorexced := nvalorexced *(nvlpercsp / 100);
      nvalorhonor := nvalorhonor *(nvlpercsp / 100);
      nvalorporte := nvalorporte *(nvlpercsp / 100);
      if v_itregra.tp_tab_fat <> 'H' then
         nvaloropera := nvaloropera *(nvlpercsp / 100);
      end if;
    END IF;
    IF NVL(nvlpercsd, 0) > 0 AND v_grupro.tp_gru_pro = 'SD' THEN
      nvalortotal := nvalortotal *(nvlpercsd / 100);
      nvalorexced := nvalorexced *(nvlpercsd / 100);
      nvalorhonor := nvalorhonor *(nvlpercsd / 100);
      nvalorporte := nvalorporte *(nvlpercsd / 100);
      if v_itregra.tp_tab_fat <> 'H' then
        nvaloropera := nvaloropera *(nvlpercsd / 100);
      end if;
    END IF;
    IF NVL(nvlpercsh, 0) > 0 AND v_grupro.tp_gru_pro = 'SH' THEN
      nvalortotal := nvalortotal *(nvlpercsh / 100);
      nvalorexced := nvalorexced *(nvlpercsh / 100);
      nvalorhonor := nvalorhonor *(nvlpercsh / 100);
      nvalorporte := nvalorporte *(nvlpercsh / 100);
      if v_itregra.tp_tab_fat <> 'H' then
        nvaloropera := nvaloropera *(nvlpercsh / 100);
      end if;
    END IF;
    -- pda 288206 - fim
  END IF;
  */
  -- pda 463268 - fim
  --
  -- pda 504861 - comentado aqui e colocado mais acima
  /*
  IF NVL(v_itregra.vl_percentual_itregra, 0) > 0 AND NOT bexcessao THEN
    IF NVL(v_itregra.tp_valor_base, 'T') = 'T' THEN
      nvalortotal := nvalortotal *(v_itregra.vl_percentual_itregra / 100);
      nvalorexced := nvalorexced *(v_itregra.vl_percentual_itregra / 100);
      nvalorhonor := nvalorhonor *(v_itregra.vl_percentual_itregra / 100);
      nvaloropera := nvaloropera *(v_itregra.vl_percentual_itregra / 100);
      nvalorporte := nvalorporte *(v_itregra.vl_percentual_itregra / 100);
    ELSIF v_itregra.tp_valor_base = 'O' THEN
      nvaloropera := nvaloropera *(v_itregra.vl_percentual_itregra / 100);
      nvalortotal := NVL(nvaloropera, 0) + NVL(nvalorhonor, 0);
    ELSIF v_itregra.tp_valor_base = 'H' THEN
      nvalorhonor := nvalorhonor *(v_itregra.vl_percentual_itregra / 100);
      nvalortotal := NVL(nvaloropera, 0) + NVL(nvalorhonor, 0);
    END IF;
  END IF;
  --
  IF csnhorarioesp = 'S' AND NVL(nvlperchoresp, 0) > 0 THEN
    IF v_grupro.tp_gru_pro <> 'SD' AND NOT bexcessao THEN
      nvalortotal := nvalortotal +(nvalortotal * nvlperchoresp / 100);
      nvalorexced := nvalorexced +(nvalorexced * nvlperchoresp / 100);
      nvalorhonor := nvalorhonor +(nvalorhonor * nvlperchoresp / 100);
      nvalorporte := nvalorporte +(nvalorporte * nvlperchoresp / 100);
    ELSIF v_grupro.tp_gru_pro = 'SD' AND NOT bexcessao THEN
      IF v_itregra.tp_hor_esp_sd = 'T' THEN
        nvalortotal := nvalortotal +(nvalortotal * nvlperchoresp / 100);
        nValorExced := nValorExced + ( nValorExced * nVlPercHorEsp / 100 ) ;
        nvalorhonor := nvalorhonor +(nvalorhonor * nvlperchoresp / 100);
        nvaloropera := nvaloropera +(nvaloropera * nvlperchoresp / 100);
        nvalorporte := nvalorporte +(nvalorporte * nvlperchoresp / 100);
      ELSIF v_itregra.tp_hor_esp_sd = 'H' THEN
        nvalorhonor := nvalorhonor +(nvalorhonor * nvlperchoresp / 100);
        nvalorporte := nvalorporte +(nvalorporte * nvlperchoresp / 100);
      END IF;
    ELSIF bexcessao AND cexcesshoresp = 'S' THEN
      nvalortotal := nvalortotal +(nvalortotal * nvlperchoresp / 100);
      nvalorexced := nvalorexced +(nvalorexced * nvlperchoresp / 100);
      nvalorhonor := nvalorhonor +(nvalorhonor * nvlperchoresp / 100);
      nvaloropera := nvaloropera +(nvaloropera * nvlperchoresp / 100);
      nvalorporte := nvalorporte +(nvalorporte * nvlperchoresp / 100);
    END IF;
  END IF;
  */
  -- pda 504861 - fim
  --
  --PDA 374059 - truncar o valor unitario, ap?s a aplica??o do percentual
  IF vTruncaValor = 'S' then
    -- pda 463268 - corrigindo erro de convers?o ora-06502
    --IF NVL(dbamv.pkg_mv2000.le_configuracao('FFCV', 'CD_CONV_NAO_ARREDONDA_VALOR_CCG'), '0') =  ncodconvenio THEN
    IF instr( nvl(dbamv.pkg_mv2000.le_configuracao('FFCV', 'CD_CONV_NAO_ARREDONDA_VALOR_CCG'),'X'), LPad(ncodconvenio,4,'0') ) > 0 THEN
      nvalortotal := trunc(round(nvalortotal,4),2);   /* pda 334528 - 31/12/2009 - trunc de 4 */
    END IF;
  END IF;
  --PDA 374059 -truncar o valor unitario para duas casas

  IF v_indice.vl_m2filme IS NOT NULL AND ((bexcessao AND v_tabconvenio.sn_filme = 'S') OR NOT bexcessao) THEN
    --
    OPEN c_tabfilme(v_itregra.cd_tab_fat, vddatarefer);
    FETCH c_tabfilme INTO nqtfilme;
    CLOSE c_tabfilme;
    --
    OPEN cincidencia;
    FETCH cincidencia INTO vprofatincid, nvlpercincid, nCodRelacionado;   -- OP 33841 - nova coluna do cursor
    IF cincidencia%FOUND THEN
      /* PDA 145551 - HSR
       * SE ACHOU A INCIDENCIA, CALCULA DE FORMA DIFERENTE A INCIDENCIA
       */
      IF nqtfilme IS NOT NULL THEN

		    -- OP 33841 - Verifica se tem percentual por faixa de valor, e também o limite do teto.
		    open  cIncidenciaFaixa( nCodRelacionado, v_indice.vl_m2filme );
		    fetch cIncidenciaFaixa into nvlpercincidfaixa, nTetoIncid;
		    close cIncidenciaFaixa;
		    if nvl(nvlpercincidfaixa,0) > 0 then
              nvalorfilme := v_indice.vl_m2filme *(nqtfilme *(nvlpercincidfaixa / 100));
		      if nvl(nvalorfilme,0) > nvl(nTetoIncid,0) then
		        nvalorfilme := nvl(nTetoIncid,0);
		      end if;
		    else
		    -- OP 33841 - fim
          nvalorfilme := v_indice.vl_m2filme *(nqtfilme *(nvlpercincid / 100));
    		end if;
      ELSE
        nvalorfilme := 0;
      END IF;
    ELSE
      IF nqtfilme IS NOT NULL THEN
        /* pda 334528 - 28/12/2009 - Amalia Ara?jo - retirando o TRUNC(ROUND daqui, pois arredondou indevidamente */
        /* pda 277748 - 06/07/2009 - Amalia Ara?jo - truncando ao inv?s de arredondar */
        /*if vTruncaValor = 'S' then
          nvalorfilme := TRUNC(ROUND(v_indice.vl_m2filme * nqtfilme,4),2);
        else*/
        /* pda 277748 - fim */
          nvalorfilme := v_indice.vl_m2filme * nqtfilme;
        /*end if;*/
      ELSE
        nvalorfilme := 0;
      END IF;
    END IF;
    CLOSE cincidencia;
  ELSE
    nvalorfilme := 0;
  END IF;
  --
  OPEN ccalcsemexcessao;
  FETCH ccalcsemexcessao INTO vcalcsemexcessao;
  CLOSE ccalcsemexcessao;
  --
  IF v_acresdesc.sn_acres_desc = 'S' AND(NOT bexcessao OR vcalcsemexcessao = 'S') THEN
    nvlacres := 0;
    nvlacreshonor := 0;
    nvlacresoper := 0;
    nvlacresfilme := 0;
    nvlacresexced := 0;
    nvldesc := 0;
    nvldeschonor := 0;
    nvldescoper := 0;
    nvldescfilme := 0;
    nvldescexced := 0;
    npercentualdesconto := NVL(v_acresdesc.vl_perc_desconto, 0);
    npercentualacrescimo := NVL(v_acresdesc.vl_perc_acrescimo, 0);
    --
    /*Calculo de acrescimo*/
    IF NVL(npercentualacrescimo, 0) > 0 THEN
      IF v_acresdesc.sn_vl_filme = 'S' THEN
        nvlacresfilme := nvalorfilme *(npercentualacrescimo / 100);
      END IF;
      IF v_acresdesc.sn_vl_operacional = 'S' THEN
        nvlacresoper := nvaloropera *(npercentualacrescimo / 100);
      END IF;
      IF v_acresdesc.sn_vl_honorario = 'S' THEN
        IF cfuncatimed = 'N' THEN
          nvlacreshonor := nvalorporte *(npercentualacrescimo / 100);
        ELSE
          nvlacreshonor := nvalorhonor *(npercentualacrescimo / 100);
        END IF;
      END IF;
      IF v_acresdesc.sn_vl_operacional = 'N' AND v_acresdesc.sn_vl_honorario = 'N' THEN
        IF cfuncatimed = 'N' THEN
          nvlacres := nvalorporte *(npercentualacrescimo / 100);
          nvlacresexced := nvalorporte *(npercentualacrescimo / 100);
        ELSE
          nvlacres := nvalortotal *(npercentualacrescimo / 100);
          nvlacresexced := nvalorexced *(npercentualacrescimo / 100);
        END IF;
      ELSE
        nvlacres := nvlacreshonor + nvlacresoper;
        nvlacresexced := nvlacres;
      END IF;
      IF NVL(nvalortotal, 0) > 0 AND NVL(nvalorfilme, 0) = 0 AND NVL(nvaloropera, 0) = 0
         AND NVL(nvalorhonor, 0) = 0 THEN
        nvlacres := nvalortotal *(npercentualacrescimo / 100);
      END IF;
    END IF;
    --
    /*Calculo de desconto*/
    IF NVL(npercentualdesconto, 0) > 0 THEN
      IF v_acresdesc.sn_vl_filme = 'S' THEN
        nvldescfilme := nvalorfilme *(npercentualdesconto / 100);
      END IF;
      IF v_acresdesc.sn_vl_operacional = 'S' THEN
        /* pda 364233 - 11/05/2010 - Amalia Ara?jo - N?o calcular desconto sobre operacional em tabela CBHPM */
        IF v_itregra.tp_tab_fat = 'H' AND nCliente = 734 THEN  /*dbamv.pkg_mv2000.le_cliente = 734 THEN*/ /*OP 1501*/
          NULL;
        else
        /* pda 364233 - fim */
          nvldescoper := nvaloropera *(npercentualdesconto / 100);
        END IF;
      END IF;
      IF v_acresdesc.sn_vl_honorario = 'S' THEN
        IF cfuncatimed = 'N' THEN
          nvldeschonor := nvalorporte *(npercentualdesconto / 100);
        ELSE
          nvldeschonor := nvalorhonor *(npercentualdesconto / 100);
        END IF;
      END IF;
      IF v_acresdesc.sn_vl_operacional = 'N' AND v_acresdesc.sn_vl_honorario = 'N' THEN
        IF cfuncatimed = 'N' THEN
          nvldesc := nvalorporte *(npercentualdesconto / 100);
          nvldescexced := nvalorporte *(npercentualdesconto / 100);
        ELSE
          nvldesc := nvalortotal *(npercentualdesconto / 100);
          nvldescexced := nvalorexced *(npercentualdesconto / 100);
        END IF;
      ELSE
        nvldesc := nvldescoper + nvldeschonor;
        nvldescexced := nvldesc;
      END IF;
      IF NVL(nvalortotal, 0) > 0 AND NVL(nvalorfilme, 0) = 0 AND NVL(nvaloropera, 0) = 0
         AND NVL(nvalorhonor, 0) = 0 THEN
        nvldesc := nvalortotal *(npercentualdesconto / 100);
      END IF;
    END IF;
  ELSE
    nvlacres := 0;
    nvldesc := 0;
    nvlacresexced := 0;
    nvldescexced := 0;
  END IF;
  --
  -- pda 501948 - 21/03/2012 - gravando corretamente a quantidade de CH ap?s c?lculo do %proc.
  IF bindice THEN --Indice CH
    nvlchtotal := nvlchtotal *(nvlpercirmult / 100);
    nvlchhonor := nvlchhonor *(nvlpercirmult / 100);
  END IF;
  -- pda 501948 - fim
  --
  -- pda 463268 - 10/11/2011 - Amalia Ara?jo - esse c?lculo ser? feito mais acima na fun??o e N?o aqui
  -- pda 277748 - 06/07/2009 - Amalia Ara?jo - O c?lculo do ?ndice ser? feito mais no in?cio da rotina de c?lculo
  /*
  IF bindice THEN --Indice CH
    --
    IF NVL(v_indice.vl_ind, 0) = 0 THEN
      cretmsg := 'N?o existe Valor de Indice Cadastrado !';
      RETURN 0;
    END IF;
    --
    nvlchtotal := nvalortotal;
    nvlchhonor := nvalorhonor;
    --


    if vTruncaValor = 'S' then

      --PDA 467341(inicio)- Aplicaàào do truncamento de 4 casas conforme PDA 364198 apenas se Não tiver franquia.
      if (ncdfranquia is not null) or
         (npercfranquia is not null) then
        nNroCasasTrunc := 2;
      else
        nNroCasasTrunc := 4;
      end if;
      --PDA 467341(fim)

      IF NOT bexcessao THEN
        --PDA 364198(in?cio) - colocado 4 casas decimais no truncamento(estava 2), pois estava
        --truncando em duas casas antes de aplicar o percentual da franquia(paticipa??o do paciente)
        --nvalortotal,nvalorexced,nvalorhonor,nvaloropera,nvalorporte
        nvalortotal := Trunc(Round( nvalortotal * v_indice.vl_ind,4)  ,nNroCasasTrunc);
        nvalorexced := Trunc(Round( nvalorexced * v_indice.vl_ind,4)  ,nNroCasasTrunc);
        nvalorhonor := Trunc(Round( nvalorhonor * v_indice.vl_honor,4),nNroCasasTrunc);
        nvaloropera := Trunc(Round( nvaloropera * v_indice.vl_ind,4)  ,nNroCasasTrunc);
        nvalorporte := Trunc(Round( nvalorporte * v_indice.vl_honor,4),nNroCasasTrunc);
        --PDA 364198(fim)
      ELSE
        --PDA 364198(in?cio) - colocado 4 casas decimais no truncamento(estava 2), pois estava
        --truncando em duas casas antes de aplicar o percentual da franquia(paticipa??o do paciente)
        --nvalortotal,nvalorexced,nvalorhonor,nvaloropera,nvalorporte
        nvalortotal := Trunc(Round( nvalortotal * v_indice.vl_ind,4),nNroCasasTrunc);
        nvalorexced := Trunc(Round( nvalorexced * v_indice.vl_ind,4),nNroCasasTrunc);
        nvalorhonor := Trunc(Round( nvalorhonor * v_indice.vl_ind,4),nNroCasasTrunc);
        nvaloropera := Trunc(Round( nvaloropera * v_indice.vl_ind,4),nNroCasasTrunc);
        nvalorporte := Trunc(Round( nvalorporte * v_indice.vl_ind,4),nNroCasasTrunc);
        --PDA 364198(fim)
      END IF;
    else


      IF NOT bexcessao THEN
        nvalortotal := nvalortotal * v_indice.vl_ind;
        nvalorexced := nvalorexced * v_indice.vl_ind;
        nvalorhonor := nvalorhonor * v_indice.vl_honor;
        nvaloropera := nvaloropera * v_indice.vl_ind;
        nvalorporte := nvalorporte * v_indice.vl_honor;
      ELSE
        nvalortotal := nvalortotal * v_indice.vl_ind;
        nvalorexced := nvalorexced * v_indice.vl_ind;
        nvalorhonor := nvalorhonor * v_indice.vl_ind;
        nvaloropera := nvaloropera * v_indice.vl_ind;
        nvalorporte := nvalorporte * v_indice.vl_ind;
      END IF;
    end if;
    --
    IF v_acresdesc.sn_vl_operacional = 'N' AND v_acresdesc.sn_vl_honorario = 'N' THEN
      IF cfuncatimed = 'N' THEN
        nvlacres :=(nvalorporte *(v_acresdesc.vl_perc_acrescimo / 100))         -- V_Indice.vl_ind;
        nvlacresexced :=(nvalorporte *(v_acresdesc.vl_perc_acrescimo / 100))    -- V_Indice.vl_ind;
        nvldesc :=(nvalorporte *(v_acresdesc.vl_perc_desconto / 100))           -- V_Indice.vl_ind;
        nvldescexced :=(nvalorporte *(v_acresdesc.vl_perc_desconto / 100))      -- V_Indice.vl_ind;
      ELSE
        nvlacres :=(nvalortotal *(v_acresdesc.vl_perc_acrescimo / 100))         -- V_Indice.vl_ind;
        nvlacresexced :=(nvalorexced *(v_acresdesc.vl_perc_acrescimo / 100))    -- V_Indice.vl_ind;
        nvldesc :=(nvalortotal *(v_acresdesc.vl_perc_desconto / 100))           -- V_Indice.vl_ind;
        nvldescexced :=(nvalortotal *(v_acresdesc.vl_perc_desconto / 100))      -- V_Indice.vl_ind;
      END IF;
    ELSE
      nvlacres := (nvlacreshonor * v_indice.vl_honor) +(nvlacresoper * v_indice.vl_ind);
      nvlacresexced := (nvlacreshonor * v_indice.vl_honor) +(nvlacresoper * v_indice.vl_ind);
      nvldesc := (nvldescoper * v_indice.vl_ind) +(nvldeschonor * v_indice.vl_honor);
      nvldescexced := (nvldescoper * v_indice.vl_ind) +(nvldeschonor * v_indice.vl_honor);
    END IF;
    --
  END IF; --Indice CH
  --
  nvlacres := nvlacres + nvlacresfilme;
  nvldesc := nvldesc + nvldescfilme;
  nvlacresexced := nvlacresexced + nvlacresfilme;
  nvldescexced := nvldescexced + nvldescfilme;
  */
  -- pda 463268 - fim

  /* OP 3738 - PDA 569190 - Jansen Gallindo (inicio) - for?ando a mascara no campo vFaturaDataAlta - Corre??o para aplicar desconto do filme - Tirando coment?rio do c?d abaixo*/
  nvlacres := nvlacres + nvlacresfilme;
  nvldesc := nvldesc + nvldescfilme;
  nvlacresexced := nvlacresexced + nvlacresfilme;
  nvldescexced := nvldescexced + nvldescfilme;
  /* OP 3738 - PDA 569190 - Jansen Gallindo (fim)*/

  --
  IF v_grupro.tp_gru_pro IN('SP', 'SD') THEN
    IF cfuncatimed = 'N' THEN
      /* pda 369072 - 03/12/2009 - Amalia Ara?jo - Estava somando indevidamente o valor operacional para o Anestesista. */
      nvaloropera := 0;
      /* pda 369072 - fim */
      nvalortotal := nvalorporte + nvaloropera;
    ELSE
      nvalortotal := nvalorhonor + nvaloropera;
    END IF;
  END IF;
  --
  /* pda 369072 - Amalia Ara?jo - 07/06/2010
     Retirando este cursor de dentro do IF abaixo e incluindo a terceira vari?vel nvlpercfranquia.
     O par?metro npercfranquia da fun??o, que est? recebendo o vl_percentual_pago do item da conta, est? vindo zerado e N?o pode ser
     utilizado abaixo para ver se h? franquia por percentual. Ent?o est? sendo substituido pela vari?vel nvlpercfranquia.
  */
  OPEN c_franquia;
  FETCH c_franquia INTO nvlrfranquia,
                        nqtpontos,
                        nvlpercfranquia
			  ;
  CLOSE c_franquia;
  /* pda 369072 - fim */
  --
  IF ncdfranquia IS NOT NULL AND NVL(nvlpercfranquia, 0) = 0 THEN   /* pda 369072 - Amalia Ara?jo - 07/06/2010 - substituindo npercfranquia por nvlpercfranquia */
    --
    IF ctpconvenio = 'P' THEN
      --
      /* pda 366106 - 18/05/2010 - Amalia Ara?jo
      IF nqtpontos IS NOT NULL THEN  */
      IF nvl(nqtpontos,0) > 0 then
      /* pda 366106 - fim */
        nvalortotal := dbamv.pack_aux_ffcv.val_ponto_franquia(ncodconvenio, vddatarefer, nqtpontos);
      ELSE
        nvalortotal := NVL(nvlrfranquia, 0);
      END IF;
      --
      IF NVL(nvalorhonor, 0) > 0 THEN
        nvalorhonor := NVL(nvlrfranquia, 0);
      END IF;
      --
      IF NVL(nvaloropera, 0) > 0 THEN
        nvaloropera := NVL(nvlrfranquia, 0);
      END IF;
      --
      nvalorfilme := 0;
      --
    ELSIF ctpconvenio = 'C' THEN
      --
      /* pda 366106 - 18/05/2010 - Amalia Ara?jo
      IF nqtpontos IS NOT NULL THEN  */
      IF nvl(nqtpontos,0) > 0 then
      /* pda 366106 - fim */
        nvalortotal :=
          nvalortotal - dbamv.pack_aux_ffcv.val_ponto_franquia(ncodconvenio, vddatarefer, nqtpontos);
      ELSE
        /*pda 319890 - Thiago miranda de oliveira - colocando condi??o para quando o valro da franquia for maior somar o filme*/
        -- pda 418611 - replica??o PDA 384492 - Sempre que houver franquia o valor do filme ser? somado
        IF nvlrfranquia is not null then --   >nvalortotal then
		-- pda 418611 - fim
          nvalortotal := nvalortotal + Nvl(nvalorfilme, 0) - NVL(nvlrfranquia, 0);
        ELSE
          nvalortotal := nvalortotal - NVL(nvlrfranquia, 0);
        END IF;
        /*fim pda 319890*/
        /* pda 369859 - 31/05/2010 - Amalia Ara?jo */
        IF nvalortotal < 0 THEN
          nvalortotal := 0;
        END IF;
        /* pda 369859 - fim */
      END IF;
      --
      IF NVL(nvalorhonor, 0) > 0 THEN
        nvalorhonor := nvalorhonor - NVL(nvlrfranquia, 0);
        /* pda 369859 - 31/05/2010 - Amalia Ara?jo */
        IF nvalorhonor < 0 THEN
          nvalorhonor := 0;
        END IF;
        /* pda 369859 - fim */
      END IF;
      --
      IF NVL(nvaloropera, 0) > 0 THEN
        nvaloropera := nvaloropera - NVL(nvlrfranquia, 0);
        /* pda 369859 - 31/05/2010 - Amalia Ara?jo */
        IF nvaloropera < 0 THEN
          nvaloropera := 0;
        END IF;
        /* pda 369859 - fim */
      END IF;
      --
    END IF;
  /* pda 420782 Andr? Piana RE pda 417078 - Francisco Morais - 14/03/11 - adicionado a variavel npercfranquia para o cliente 312, pois o valor do procedimento e baseado no percentual do valor pago*/
  /* pda 369072 - Amalia Ara?jo - 07/06/2010 - substituindo npercfranquia por nvlpercfranquia */
  ELSIF (NVL(nvlpercfranquia, 0) > 0) OR
        (NVL(npercfranquia  , 0) > 0) OR                /* pda 370030 - Amalia Ara?jo - 08/06/2010 */
        ( ( nvlpercfranquia = 0 OR npercfranquia = 0 ) AND v_hospital.cd_hospital = 312) THEN
    --
    nvlunitregra := nvalortotal;
    --
    nvalortotal :=((nvalortotal * npercfranquia) / 100);
    --
    /* OP 14394 - 27/11/2013 - Amalia Ara?jo
        sn_regra_atendimento_conta :
        Usado na pack_ffcv.regra_atendimento_hosp e regra_atendimento_ambu para gravar ou N?o o valor
        do desconto na coluna vl_desconto_conta nos itens de conta.
        Na val_proc_ffcv h? uma condi??o que s? calcula o percentual de franquia nos valores de honor?rio,
        operacional, porte e filme caso essa configura??o esteja diferente de S. Mas N?o vejo l?gica nisso,
        se N?o calcula o filme sai da val_proc_ffcv com 100% e ? gravado no item da conta, fica errado.
        Retirando essa condi??o.
     */
    --IF vregraatend.sn_regra_atendimento_conta <> 'S' THEN
      nvalorhonor :=((nvalorhonor * npercfranquia) / 100);
      nvaloropera :=((nvaloropera * npercfranquia) / 100);
      nvalorporte :=((nvalorporte * npercfranquia) / 100);
      nvalorfilme :=((nvalorfilme * npercfranquia) / 100);
      nvlunitregra := NULL;
    --END IF;
    --
  /* pda 369072 - fim */
    --
  END IF;
  --
  IF ncdregraacop IS NOT NULL THEN
    --
    OPEN c_acoplam;
    FETCH c_acoplam INTO v_acoplam;
    CLOSE c_acoplam;
    --
    IF v_acoplam.cd_convenio_conta = ncdconvacop AND v_acoplam.cd_con_pla_conta = ncdplanacop THEN
      IF v_acoplam.vl_percentual IS NOT NULL THEN
        --
        /* pda 296222 - 07/06/2009 - Amalia Ara?jo - truncando os valores ao inv?s de arredondar */
        if vTruncaValor = 'S' then
          -- pda 418806 - replica??o PDA 412173(inicio) - truncar em quatro casas
          nvalortotal := trunc(round(((nvalortotal *(100 - v_acoplam.vl_percentual)) / 100),4),4);
          nvalorfilme := trunc(round(((nvalorfilme *(100 - v_acoplam.vl_percentual)) / 100),4),4);
          -- pda 418806 - fim
          nvalorhonor := trunc(round(((nvalorhonor *(100 - v_acoplam.vl_percentual)) / 100),4),2);
          nvaloropera := trunc(round(((nvaloropera *(100 - v_acoplam.vl_percentual)) / 100),4),2);
          nvalorporte := trunc(round(((nvalorporte *(100 - v_acoplam.vl_percentual)) / 100),4),2);
        else
        /* pda 296222 - fim */
          nvalortotal := ((nvalortotal *(100 - v_acoplam.vl_percentual)) / 100);
          nvalorhonor := ((nvalorhonor *(100 - v_acoplam.vl_percentual)) / 100);
          nvaloropera := ((nvaloropera *(100 - v_acoplam.vl_percentual)) / 100);
          nvalorporte := ((nvalorporte *(100 - v_acoplam.vl_percentual)) / 100);
          nvalorfilme := ((nvalorfilme *(100 - v_acoplam.vl_percentual)) / 100);
        end if;
      ELSIF v_acoplam.vl_particip IS NOT NULL THEN
	    -- pda 456709 - càlculo de acoplamento por valor està invertido, corrigindo.
        nvalortotal := nvalortotal - v_acoplam.vl_particip;
        IF NVL(nvalorhonor, 0) > 0 THEN
          nvalorhonor := nvalorhonor - v_acoplam.vl_particip;
        END IF;
        IF NVL(nvaloropera, 0) > 0 THEN
          nvaloropera := nvaloropera - v_acoplam.vl_particip;
        END IF;
      END IF;
    ELSE
      IF v_acoplam.vl_percentual IS NOT NULL THEN
        --
        /* pda 296222 - 07/06/2009 - Amalia Ara?jo - truncando os valores ao inv?s de arredondar */
        if vTruncaValor = 'S' then
          -- pda 418806 - replica??o PDA 412173(inicio) - truncar em quatro casas
          nvalortotal := trunc(round(((nvalortotal * v_acoplam.vl_percentual) / 100),4),4);
          nvalorfilme := trunc(round(((nvalorfilme * v_acoplam.vl_percentual) / 100),4),4);
          -- pda 418806 - fim
          nvalorhonor := trunc(round(((nvalorhonor * v_acoplam.vl_percentual) / 100),4),2);
          nvaloropera := trunc(round(((nvaloropera * v_acoplam.vl_percentual) / 100),4),2);
          nvalorporte := trunc(round(((nvalorporte * v_acoplam.vl_percentual) / 100),4),2);
        else
        /* pda 296222 - fim */
          nvalortotal := ((nvalortotal * v_acoplam.vl_percentual) / 100);
          nvalorhonor := ((nvalorhonor * v_acoplam.vl_percentual) / 100);
          nvaloropera := ((nvaloropera * v_acoplam.vl_percentual) / 100);
          nvalorporte := ((nvalorporte * v_acoplam.vl_percentual) / 100);
          nvalorfilme := ((nvalorfilme * v_acoplam.vl_percentual) / 100);
        end if;
      ELSIF v_acoplam.vl_particip IS NOT NULL THEN
        -- pda 456709 - c?lculo de acoplamento por valor est? invertido, corrigindo.
        nvalortotal := v_acoplam.vl_particip;
        IF NVL(nvalorhonor, 0) > 0 THEN
          nvalorhonor := v_acoplam.vl_particip;
        END IF;
        IF NVL(nvaloropera, 0) > 0 THEN
          nvaloropera := v_acoplam.vl_particip;
        END IF;
      END IF;
    END IF;
  END IF;
  --
  IF bexcedente THEN
    IF NVL(v_hospital.cd_hospital, 0) IN(312) THEN
      nvlrtotal := nvalorexced * nqtdeexced;
    ELSE
      nvlrtotal := nvalortotal +(nvalorexced * nqtdeexced);
      nvlacres := nvlacres +(nvlacresexced * nqtdeexced);
      nvldesc := nvldesc +(nvldescexced * nqtdeexced);
    END IF;
    nvlacres := nvlacres +(nvlacresexced * nqtdeexced);
    nvldesc := nvldesc +(nvldescexced * nqtdeexced);
  ELSE
   	-- OP 42583 (Inicio)
     IF vTruncaValor = 'S' THEN
      IF nvalortotal IS NOT NULL then
        nvalortotal := trunc(round(nvalortotal,4),nQtCasasVlUnit);
      END IF;
    ELSE
      IF nvalortotal IS NOT NULL then
        nvalortotal := round(nvalortotal, nQtCasasVlUnit);
      END IF;
    END IF;			   
-- OP 42583 (Fim)
    nvlrtotal := nvalortotal * NVL(nqtde, 1);
    nvlacres := nvlacres * NVL(nqtde, 1);
    nvldesc := nvldesc * NVL(nqtde, 1);
  END IF;
  --
  OPEN cpercacresexame(ncdregra, vprofat, ctipoatend);
  FETCH cpercacresexame INTO v_percacresexame;
  CLOSE cpercacresexame;
  --
  IF ( NVL(v_percacresexame.vl_perc_acrescimo_exame, 0) > 0 AND
       NVL(v_percacresexame.sn_incluir_acres_exame, 'N') = 'S' AND NOT bexcessao ) THEN
    /* calcular o valor do acr?scimo do exame e adicion?-lo ao acr?scimo j? existente. */
    IF v_acresdesc.sn_vl_filme = 'S' THEN
      nvlacresfilme := nvalorfilme *(v_percacresexame.vl_perc_acrescimo_exame / 100);
    ELSE
      nvlacresfilme := 0;
    END IF;
    --
    IF v_acresdesc.sn_vl_operacional = 'S' THEN
      nvlacresoper := nvaloropera *(v_percacresexame.vl_perc_acrescimo_exame / 100);
    END IF;
    --
    IF v_acresdesc.sn_vl_honorario = 'S' THEN
      IF cfuncatimed = 'N' THEN
        nvlacreshonor := nvalorporte *(v_percacresexame.vl_perc_acrescimo_exame / 100);
      ELSE
        nvlacreshonor := nvalorhonor *(v_percacresexame.vl_perc_acrescimo_exame / 100);
      END IF;
    END IF;
    --
    IF v_acresdesc.sn_vl_operacional = 'N' AND v_acresdesc.sn_vl_honorario = 'N' THEN
      IF cfuncatimed = 'N' THEN
        nvlacres := nvalorporte *(v_percacresexame.vl_perc_acrescimo_exame / 100) + nvlacresfilme;
      ELSE
        nvlacres := nvalortotal *(v_percacresexame.vl_perc_acrescimo_exame / 100);
      END IF;
    ELSE
      nvlacres := nvlacreshonor + nvlacresoper + nvlacresfilme;
    END IF;
    --
  END IF;
  --
  /* pda 529876 - 24/09/2012 - Amalia Ara?jo - Antes o valor operacional era atribuido sem condi??es.
      Por solicita??o do cliente 1107 (S Vicente Funef) N?o dever? ser considerado o valor de UCO para os auxiliares, apenas para o cirurgi?o.
	  Para isso foi criado o par?metro SN_RETIRA_VALOR_UCO_CBHPM_AUX no Global (Cadastro Geral de Par?metros). N?o ir? considerar o UCO caso a fun??o
	  do prestador for Auxiliar, se o par?metro estiver S, se a tabela for CBHPM e N?o houver exce??o.
  */
  IF cfuncatimed = 'A' and vSnRetiraValorUcoCbhpmAux = 'S' AND v_itregra.tp_tab_fat = 'H' AND NOT bexcessao THEN
    nvloper     := 0;
  ELSE
    nvloper     := NVL(nvaloropera, 0);   /* condiàào existente antes do pda 529876 */
  END IF;
  /* pda 529876 - fim */
  --
  nvlhonor := NVL(nvalorhonor, 0);
  nvlfilme := NVL(nvalorfilme, 0);
  nvlporte := NVL(nvalorporte, 0);
  nvltaxa := NVL(nvlacres, 0);
  nvldesconto := NVL(nvldesc, 0);
  nvlrtotal := NVL(nvlrtotal, 0);
  nretval := NVL(nvalortotal, 0);
  --
  IF NVL(v_hospital.cd_hospital, 0) IN(312) THEN
    IF bexcedente THEN
      nretval := NVL(nvalorexced, 0);
    END IF;
  END IF;
  --
  IF bpacote THEN
    nvloper := nvloper * NVL(v_pacote.vl_perc_pac_secund, 1);
    nvlhonor := nvlhonor * NVL(v_pacote.vl_perc_pac_secund, 1);
    nvlfilme := nvlfilme * NVL(v_pacote.vl_perc_pac_secund, 1);
    nvlporte := nvlporte * NVL(v_pacote.vl_perc_pac_secund, 1);
    nvltaxa := nvltaxa * NVL(v_pacote.vl_perc_pac_secund, 1);
    nvldesconto := nvldesconto * NVL(v_pacote.vl_perc_pac_secund, 1);
    nvlrtotal := nvlrtotal * NVL(v_pacote.vl_perc_pac_secund, 1);
    nretval := nretval * NVL(v_pacote.vl_perc_pac_secund, 1);
    nvlunitregra := nvlunitregra * NVL(v_pacote.vl_perc_pac_secund, 1);
    --
    nvloper := dbamv.pkg_ffcv_it_conta.fnc_aplica_percentual_pacote(ncdconta, ncdlancamento, ctipoatend, nvloper);
    nvlhonor := dbamv.pkg_ffcv_it_conta.fnc_aplica_percentual_pacote(ncdconta, ncdlancamento, ctipoatend, nvlhonor);
    nvlfilme := dbamv.pkg_ffcv_it_conta.fnc_aplica_percentual_pacote(ncdconta, ncdlancamento, ctipoatend, nvlfilme);
    nvlporte := dbamv.pkg_ffcv_it_conta.fnc_aplica_percentual_pacote(ncdconta, ncdlancamento, ctipoatend, nvlporte);
    nvltaxa := dbamv.pkg_ffcv_it_conta.fnc_aplica_percentual_pacote(ncdconta, ncdlancamento, ctipoatend, nvltaxa);
    nvldesconto := dbamv.pkg_ffcv_it_conta.fnc_aplica_percentual_pacote(ncdconta, ncdlancamento, ctipoatend, nvldesconto);
    nvlrtotal := dbamv.pkg_ffcv_it_conta.fnc_aplica_percentual_pacote(ncdconta, ncdlancamento, ctipoatend, nvlrtotal);
    nretval := dbamv.pkg_ffcv_it_conta.fnc_aplica_percentual_pacote(ncdconta, ncdlancamento, ctipoatend, nretval);
    nvlunitregra := dbamv.pkg_ffcv_it_conta.fnc_aplica_percentual_pacote(ncdconta, ncdlancamento, ctipoatend, nvlunitregra);
  END IF;
  --
  /* pda 372785 - 11/06/2010 - Amalia Ara?jo - Apenas para procedimentos que N?o s?o pacote */
  /* pda 367453 - 13/05/2010 - Amalia Ara?jo - N?o retornar zerado se o valor for menor que 0.01 mas N?o for zero */
  IF not bPacote and ( nvlrtotal <> 0 AND nvlrtotal < 0.01 ) THEN
    nvlrtotal := 0.01;
  END IF;
  /* pda 367453 - fim */
  --

  -- OP 35103 - 07/01/2016 - Indica Qtde De Casas Decimais Serão Consideradas No Cálculo Do Valor Unitário Nas Contas Do Faturamento.
  IF vTruncaValor = 'S' THEN
    IF nvlunitregra IS NOT NULL then
      nvlunitregra := trunc(round(nvlunitregra,4),nQtCasasVlUnit);
    END IF;
    IF nretval IS NOT NULL then
      nretval := trunc(round(nretval,4),nQtCasasVlUnit);
    END IF;
  ELSE
    -- OP 42583 (Inicio)
    IF nvlunitregra IS NOT NULL then
      nvlunitregra := round(nvlunitregra,nQtCasasVlUnit);
    END IF;
    IF nretval IS NOT NULL then
      nretval := round(nretval,nQtCasasVlUnit);
    END IF;
    -- OP 42583 (Fim)
  END IF;
  -- OP 35103 - fim
  
  -- OP 39159 - In?cio
   IF(nvldesconto > NVL(nvlunitregra, nretval)) THEN
     nvldesconto:= NVL(nvlunitregra, nretval);
   END IF;
 -- OP 39159 - fim
  RETURN NVL(nvlunitregra, nretval);
  --
END;
/

CREATE OR REPLACE PUBLIC SYNONYM val_proc_ffcv FOR dbamv.val_proc_ffcv
/

GRANT EXECUTE ON dbamv.val_proc_ffcv TO dbaps
/
GRANT EXECUTE ON dbamv.val_proc_ffcv TO dbasgu
/
GRANT EXECUTE ON dbamv.val_proc_ffcv TO mv2000
/
GRANT EXECUTE ON dbamv.val_proc_ffcv TO mvintegra
/
