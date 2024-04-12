CREATE OR REPLACE PACKAGE dbamv.pkg_ffcv_tiss_v4  IS
    --
    -- ATENO:  a cada novo ajuste ou correo, incrementar o sequencial de evoluo abaixo ("EVO") antes de postar no CVS.
    --
    vNmAplicativo            CONSTANT varchar2(30)  :=  'MV-Tiss-V4';
    vDsVersao_aplicativo     CONSTANT varchar2(30)  :=  'V4.01.00-EVO012';
    vNmFabricante_aplicativo CONSTANT varchar2(30)  :=  'MV Sistemas';
    --
    CURSOR cSqItemGuia(pCdMvto in NUMBER, pTpMvto in VARCHAR2, pCdAtendimento in NUMBER, pCdConta in NUMBER, pTpAtendimento in VARCHAR2) IS
      SELECT tig.sq_item
        FROM dbamv.tiss_guia tg,
             dbamv.tiss_itguia tig
       WHERE pTpAtendimento    = 'A'
         AND tig.id_pai        = tg.id
         AND tg.cd_atendimento = pCdAtendimento
         AND tg.cd_reg_amb     = pCdConta
         AND tig.cd_mvto       = pCdMvto
         AND tig.tp_mvto       = pTpMvto
         AND tig.sn_principal  = 'S'
       UNION ALL
      SELECT tig.sq_item
        FROM dbamv.tiss_guia tg,
             dbamv.tiss_itguia tig
       WHERE pTpAtendimento    = 'I'
         AND tig.id_pai        = tg.id
         AND tg.cd_atendimento = pCdAtendimento
         AND tg.cd_reg_fat     = pCdConta
         AND tig.cd_mvto       = pCdMvto
         AND tig.tp_mvto       = pTpMvto
         AND tig.sn_principal  = 'S';
    --
    TYPE RecConf IS RECORD (cd_id_estrutura_srv     dbamv.config_proto.cd_id_estrutura_srv%type,
                            ds_tag                  dbamv.estrutura_srv.ds_tag%TYPE,
                            ds_estrutura_srv        dbamv.estrutura_srv.ds_estrutura_srv%TYPE,
                            sn_obrigatorio          dbamv.estrutura_srv.sn_obrigatorio%type,
                            tp_dado                 dbamv.estrutura_srv.tp_dado_schema%type,
                            tp_utilizacao           dbamv.config_proto.tp_utilizacao%type,
                            cd_condicao1            dbamv.config_proto.cd_condicao1%type,
                            cd_condicao2            dbamv.config_proto.cd_condicao2%type,
                            cd_condicao3            dbamv.config_proto.cd_condicao3%type,
                            ds_valor_fixo           dbamv.config_proto.ds_valor_fixo%type,
                            ds_query_alternativa    dbamv.config_proto.ds_query_alternativa%type,
                            tp_preenchimento        dbamv.config_proto.tp_preenchimento%TYPE,
                            ds_bloco                VARCHAR2(100));
    TYPE tableConf IS TABLE OF RecConf INDEX BY varchar2(1000);
    tConf   tableConf;  -- Tabela das configuraes completas indexada pela Tag.
    --
    TYPE tableConfChave IS TABLE OF dbamv.config_proto.cd_condicao1%type INDEX BY  varchar2(1000);
    tConfChave   tableConfChave;    -- configuraao do tipo CHAVE referente as 3 opes disponveis (p/acionamento tradicional)
    --
    TYPE RecConfUtil IS RECORD (sn_ja_ativada   varchar2(1) );
    TYPE tableConfUtil IS TABLE OF RecConfUtil INDEX BY varchar2(10);
    tConfUtil tableConfUtil;
    --
    TYPE RecBenef IS RECORD (   numeroCarteira         		varchar2(20),
                                atendimentoRN     		    varchar2(1),
                                nomeBeneficiario		      varchar2(70),
                                numeroCNS			            varchar2(15),
                                tipoIdent                 varchar2(2),
                                identificadorBeneficiario varchar2(4000),
                                templateBiometrico        varchar2(2000),
                                ausenciaCodValidacao    varchar2(2),
                                codValidacao            varchar2(10),
								nomeSocialBeneficiario  varchar2(70) --Oswaldo FATURCONV-26150
                                );
    --
    TYPE RecDeclaracoes IS RECORD ( declaracaoNascido   varchar2(20),
                                    diagnosticoObito    varchar2(20),
                                    declaracaoObito		varchar2(20),
                                    indicadorDORN	    varchar2(10)
                                    );
    TYPE tableDeclaracoes IS TABLE OF RecDeclaracoes index by binary_integer;
    --
    TYPE RecInternacaoDados IS RECORD ( caraterAtendimento      varchar2(10),
                                        tipoFaturamento         varchar2(10),
                                        dataInicioFaturamento	varchar2(20),
                                        horaInicioFaturamento	varchar2(20),
                                        dataFinalFaturamento    varchar2(20),
                                        horaFinalFaturamento    varchar2(20),
                                        tipoInternacao          varchar2(10),
                                        regimeInternacao        varchar2(10),
                                        indicadorAcidente        varchar2(1),
                                        motivoSaidaInternacao    varchar2(2),
                                        declaracoes             tableDeclaracoes
                                        ,diagnostico            varchar2(10)
                                        );
    --
    TYPE RecDiagnosticos IS RECORD ( TP_CID   varchar2(10),
                                     CD_CID   varchar2(10),
                                     DS_CID   varchar2(10)
                                    );
    TYPE tableDiagnosticos IS TABLE OF RecDiagnosticos index by binary_integer;
    TYPE RecInternacaoDadosSaida IS RECORD ( diagnostico              tableDiagnosticos,
                                             indicadorAcidente        varchar2(1),
                                             motivoSaidaInternacao    varchar2(2)
                                            );
    --
    TYPE RecCabec IS RECORD (   registroANS       		varchar2(6),
                                numeroGuiaPrestador     varchar2(20),
                                ID_GUIA                 number
                                );
    --
    TYPE RecContrat IS RECORD ( codigoPrestadorNaOperadora  varchar2(14),
                                cpfContratado     		    varchar2(11),
                                cnpjContratado		        varchar2(14),
                                nomeContratado              varchar2(70)
                                );
    --
    TYPE RecAutorizInt IS RECORD (  numeroGuiaOperadora     varchar2(20),
                                    dataAutorizacao     	varchar2(10),
                                    senha		            varchar2(20),
                                    dataValidadeSenha       varchar2(10),
                                    ausenciaCodValidacao    varchar2(2),
                                    codValidacao            varchar2(10)
                                    );
    --
    TYPE RecAutorizSadt IS RECORD ( numeroGuiaOperadora     varchar2(20),
                                    dataAutorizacao     	  varchar2(10),
                                    senha		                varchar2(20),
                                    dataValidadeSenha       varchar2(10),
                                    ausenciaCodValidacao    varchar2(2),
                                    codValidacao            varchar2(10)
                                    );
    --
    TYPE RecVlTotal IS RECORD ( valorProcedimentos          varchar2(14),
                                valorDiarias                varchar2(14),
                                valorTaxasAlugueis          varchar2(14),
                                valorMateriais              varchar2(14),
                                valorMedicamentos           varchar2(14),
                                valorOPME                   varchar2(14),
                                valorGasesMedicinais        varchar2(14),
                                valorTotalGeral             varchar2(14),
                                valorTotalGeralDesp         varchar2(14)
                            );
  --
  TYPE RecProcDados IS RECORD ( codigoTabela            varchar2(2),
                                codigoProcedimento      varchar2(10),
                                descricaoProcedimento   varchar2(150)
                            );
  --
  TYPE RecEquipe IS RECORD  (   grauPart                    varchar2(2),
                                codigoPrestadorNaOperadora  varchar2(20),
                                cpfContratado               varchar2(20),
                                nomeProf                    varchar2(1000),
                                conselho                    varchar2(2),
                                numeroConselhoProfissional  varchar2(20),
                                UF                          varchar2(2),
                                CBOS                        varchar2(10),
                                cd_prestador                NUMBER(12)  --  *** cdigo do sistema (apoio)
                            );
  TYPE tableEquipe IS TABLE OF RecEquipe index by binary_integer;
  --
  TYPE RecProcInt IS RECORD  (  sequencialItem          varchar2(20),
                                dataExecucao            varchar2(20),
                                horaInicial             varchar2(20),
                                horaFinal               varchar2(20),
                                procedimento            RecProcDados,
                                quantidadeExecutada     varchar2(20),
                                viaAcesso               varchar2(1),
                                tecnicaUtilizada        varchar2(1),
                                reducaoAcrescimo        varchar2(20),
                                valorUnitario           varchar2(30),
                                valorTotal              varchar2(30),
                                identificacaoEquipe     tableEquipe
                            );
  --
  TYPE RecOutDesp IS RECORD  (  sequencialItem              varchar2(20),
                                itemVinculado               varchar2(20),
                                dataExecucao                varchar2(20),
                                horaInicial                 varchar2(20),
                                horaFinal                   varchar2(20),
                                codigoTabela                varchar2(2),
                                codigoProcedimento          varchar2(10),
                                quantidadeExecutada         varchar2(30),
                                unidadeMedida               varchar2(3),
                                reducaoAcrescimo            varchar2(20),
                                valorUnitario               varchar2(30),
                                valorTotal                  varchar2(30),
                                descricaoProcedimento       varchar2(150),
                                registroANVISA              varchar2(20),
                                codigoRefFabricante         varchar2(30),
                                autorizacaoFuncionamento    varchar2(30)
                            );
    --
    TYPE RecPrestIdent IS RECORD (  codigoPrestadorNaOperadora  varchar2(14),
                                    CPF     		            varchar2(11),
                                    CNPJ		                varchar2(14)
                                );
    --
    TYPE RecCabecTransac IS RECORD (    tipoTransacao           varchar2(30),
                                        sequencialTransacao     varchar2(30),
                                        dataRegistroTransacao   varchar2(30),
                                        horaRegistroTransacao   varchar2(30),
                                        falhaNegocio            varchar2(10),
                                        identificacaoPrestador  RecPrestIdent,
                                        registroANS             varchar2(10),
                                        versaoPadrao            varchar2(30),
                                        assinaturaDigital       varchar2(1000),
                                        loginSenhaPrestador     varchar2(1000)
                                    );
    --
  TYPE RecEpilogo IS RECORD (   hash            varchar2(2000)
                            );
    --
  TYPE RecMensagemLote IS RECORD (  idMensagem  number,
                                    idLote      number,
                                    nrLote      varchar2(30)
                            );
  --
  TYPE RecProfissionais IS RECORD  (grauParticipacao            varchar2(2),
                                    codigoPrestadorNaOperadora  varchar2(20),
                                    cpfContratado               varchar2(20),
                                    nomeProfissional            varchar2(1000),
                                    conselhoProfissional        varchar2(2),
                                    numeroConselhoProfissional  varchar2(20),
                                    UF                          varchar2(2),
                                    CBO                         varchar2(10)
                                     );
  TYPE tableProfissionais IS TABLE OF RecProfissionais index by binary_integer;
  --
  TYPE RecProcHI IS RECORD  (   sequencialItem          varchar2(20),
                                dataExecucao            varchar2(20),
                                horaInicial             varchar2(20),
                                horaFinal               varchar2(20),
                                procedimento            RecProcDados,
                                quantidadeExecutada     varchar2(20),
                                viaAcesso               varchar2(1),
                                tecnicaUtilizada        varchar2(1),
                                reducaoAcrescimo        varchar2(20),
                                valorUnitario           varchar2(30),
                                valorTotal              varchar2(30),
                                profissionais           tableProfissionais
                            );
    --
  --
  TYPE RecProcSadt IS RECORD  ( sequencialItem          varchar2(20),
                                dataExecucao            varchar2(20),
                                horaInicial             varchar2(20),
                                horaFinal               varchar2(20),
                                procedimento            RecProcDados,
                                quantidadeExecutada     varchar2(20),
                                viaAcesso               varchar2(1),
                                tecnicaUtilizada        varchar2(1),
                                reducaoAcrescimo        varchar2(20),
                                valorUnitario           varchar2(30),
                                valorTotal              varchar2(30),
                                equipeSadt              tableEquipe
                            );
  --
  TYPE RecContrProf IS RECORD  (nomeProfissional            varchar2(1000),
                                conselhoProfissional        varchar2(2),
                                numeroConselhoProfissional  varchar2(20),
                                UF                          varchar2(2),
                                CBOS                        varchar2(10)
                            );
  --
  TYPE RecConsultaAtend IS RECORD ( dataAtendimento         varchar2(20),
                                    tipoConsulta            varchar2(10),
                                    codigoTabela            varchar2(2),
                                    codigoProcedimento      varchar2(10),
                                    valorProcedimento       varchar2(30),
                                    --Oswaldo FATURCONV-22404 inicio
                                    coberturaEspecial       VARCHAR2(2),
                                    regimeAtendimento       VARCHAR2(2),
                                    saudeOcupacional        VARCHAR2(2)
                                    --Oswaldo FATURCONV-22404 fim
                                    );
    --
    TYPE RecLocContrat IS RECORD (  codigoNaOperadora       varchar2(14),
                                    cnpjLocalExecutante		varchar2(14),
                                    nomeContratado          varchar2(70),
                                    cnes                    varchar2(10)
                                    );
  --
  TYPE RecContrExec IS RECORD   (   codigonaOperadora           varchar2(20),
                                    cpfContratado               varchar2(20),
                                    nomeContratadoExecutante    varchar2(1000),
                                    cnesContratadoExecutante    varchar2(10)
                                );
  --
  TYPE RecDadosAtendSpSadt  IS RECORD   (   tipoAtendimento     varchar2(2),
                                            indicacaoAcidente   varchar2(1),
                                            tipoConsulta        varchar2(1),
                                            motivoEncerramento  varchar2(2),
                                            --Oswaldo FATURCONV-22404 inicio
                                            regimeAtendimento   VARCHAR2(2),
                                            saudeOcupacional    VARCHAR2(2)
                                            --Oswaldo FATURCONV-22404 fim
                                        );

  --
  TYPE RecDadosSolicitacao  IS RECORD   (   dataSolicitacao     varchar2(20),
                                            caraterAtendimento  varchar2(1),
                                            indicacaoClinica    varchar2(500),
                                            indCobEspecial      VARCHAR2(2) --Oswaldo FATURCONV-22404
                                        );
  --
  TYPE RecAgrupIt IS RECORD ( quantidade  number := 0,
                              valorTotal  number := 0 );
  TotAgrupItRI  RecAgrupIt;
  TotAgrupItSP  RecAgrupIt;
  TotAgrupItHI  RecAgrupIt;
  --
  TYPE RecAgrupDesp IS RECORD ( quantidade  number := 0,
                                valorTotal  number := 0 );
  TotAgrupDesp  RecAgrupDesp;
  --
  TYPE RecTussRel IS RECORD (    CD_MULTI_EMPRESA       dbamv.multi_empresas.cd_multi_empresa%type
                                ,CD_CONVENIO            dbamv.convenio.cd_convenio%type
                                ,DT_VIGENCIA            dbamv.tuss.dt_inicio_vigencia%type
                                ,CD_PRO_FAT             dbamv.pro_fat.cd_pro_fat%type
                                ,CD_GRU_PRO             dbamv.gru_pro.cd_gru_pro%type
                                ,TP_GRU_PRO             dbamv.gru_pro.tp_gru_pro%type
                                ,TP_ATENDIMENTO         dbamv.atendime.tp_atendimento%type
                                ,TP_SERVICO_HOSPITALAR  dbamv.pro_fat.tp_serv_hospitalar%type
                                ,CD_ESPECIALIDADE       dbamv.especialid.cd_especialid%type
                                ,CD_ATI_MED             dbamv.ati_med.cd_ati_med%type
                                ,CD_CONSELHO            dbamv.conselho.cd_conselho%type
                                ,CD_MOTIVO_GLOSA        dbamv.motivo_glosa.cd_motivo_glosa%type
                                ,CD_MOT_ALT             dbamv.mot_alt.cd_mot_alt%type
                                ,TP_SEXO                dbamv.paciente.tp_sexo%type
                                ,CD_TIP_ACOM            dbamv.tip_acom.cd_tip_acom%type
                                ,CD_SERVICO             dbamv.servico.cd_servico%type
                                ,CD_SETOR               dbamv.setor.cd_setor%type   );
  --
  TYPE RecTuss IS RECORD (   CD_MULTI_EMPRESA               dbamv.tuss.cd_multi_empresa%type
                            ,CD_CONVENIO                    dbamv.tuss.cd_convenio%type
                            ,CD_TIP_TUSS                    dbamv.tuss.cd_tip_tuss%type
                            ,CD_TUSS                        dbamv.tuss.cd_tuss%type
                            ,DS_TUSS                        dbamv.tuss.ds_tuss%type
                            ,DT_INICIO_VIGENCIA             dbamv.tuss.dt_inicio_vigencia%type
                            ,DT_FIM_VIGENCIA                dbamv.tuss.dt_fim_vigencia%type
                            ,DT_FIM_IMPLANTACAO             dbamv.tuss.dt_fim_implantacao%type
                            ,DS_EDICAO_NORMA_OBSERVACOES    dbamv.tuss.ds_edicao_norma_observacoes%type
                            ,DS_DESCRICAO_DETALHADA         dbamv.tuss.ds_descricao_detalhada%type
                            ,DS_APRESENTACAO                dbamv.tuss.ds_apresentacao%type
                            ,NM_FABRICANTE                  dbamv.tuss.nm_fabricante%type
                            ,CD_REF_FABRICANTE              dbamv.tuss.cd_ref_fabricante%type
                            ,NM_LABORATORIO                 dbamv.tuss.nm_laboratorio%type
                            ,DS_SIGLA                       dbamv.tuss.ds_sigla%type
                            ,CD_REFERENCIA                  dbamv.tuss.cd_referencia%type );
  --
  TYPE RecAnexoCabec IS RECORD (registroANS       		varchar2(6),
                                numeroGuiaAnexo         varchar2(20),
                                numeroGuiaReferenciada  varchar2(20),
                                numeroGuiaOperadora     varchar2(20),
                                dataSolicitacao         varchar2(20),
                                senha                   varchar2(20),
                                dataAutorizacao         varchar2(20)
                              );
  --
  TYPE RecAnexoSolicitante IS RECORD (  nomeProfissional        varchar2(100),
                                        telefoneProfissional    varchar2(20),
                                        emailProfissional       varchar2(100)
                              );
  --
  TYPE RecDiagnosticoOnco IS RECORD (   dataDiagnostico             varchar2(20),
                                        diagnosticoCID              varchar2(4),
                                        estadiamento                varchar2(1),
                                        tumor                       VARCHAR2(1),
                                        nodulo                      VARCHAR2(1),
                                        metastase                   VARCHAR2(1),
                                        tipoQuimioterapia           varchar2(1),
                                        finalidade                  varchar2(1),
                                        ecog                        varchar2(1),
                                        planoTerapeutico            varchar2(1000),
                                        diagnosticoHispatologico    varchar2(1000),
                                        infoRelevantes              varchar2(1000)
                              );
  --
  TYPE RecFaixaGuias    IS RECORD (nr_guias   varchar2(1050) );
  TYPE tableFaixaGuias  IS TABLE OF RecFaixaGuias INDEX BY varchar2(10);
  tFaixaGuias  tableFaixaGuias;
  --
  nCdGuiaPrinc      dbamv.guia.cd_guia%type;
  nCdGuiaSecundaria dbamv.guia.cd_guia%type;
  vTissGuia_OLD     dbamv.tiss_guia%ROWTYPE;
  vTpTransacao      VARCHAR2(50);
  vTpGuiasTransacao VARCHAR2(50);
  vTpOrigemSol      varchar(50);
  nCdPrestExtSol    NUMBER;

  --
  nSqItem           NUMBER:=0;
  nSqItemOut        NUMBER:=0;
  --
  nEmpresaLogada    NUMBER := dbamv.pkg_mv2000.le_empresa; --adhospLeEmpresa (variavel global com o valor inicial carregado)
  --
  --================================================================================================================
  --
  PROCEDURE F_le_conf(   pIdMap     in number
                        ,pCdConv    in dbamv.convenio.cd_convenio%type
                        ,pModo      in varchar2
                        ,pReserva   in varchar2);
    --
    --
  FUNCTION  F_ct_beneficiarioDados( pModo           in varchar2,
                                    pIdMap          in number,
                                    pCdAtend        in dbamv.atendime.cd_atendimento%type,
                                    pCdConta        in dbamv.reg_fat.cd_reg_fat%type,
                                    pCdPaciente     in dbamv.paciente.cd_paciente%type,
                                    pCdConv         in dbamv.convenio.cd_convenio%type,
                                    pStElegPaciente IN VARCHAR2,
                                    vCt             OUT NOCOPY RecBenef,
                                    pMsg            OUT varchar2,
                                    pReserva        in VARCHAR2) return varchar2;
    --

  FUNCTION  F_ct_guiaCabecalho( pModo          in varchar2,
                                pIdMap         in number,
                                pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                pCdConv        in dbamv.convenio.cd_convenio%type,
                                pCdGuiaOrigem  in dbamv.guia.cd_guia%type,
                                pTpGuia        in varchar2,
                                vCt            OUT  NOCOPY RecCabec,
                                pMsg           OUT varchar2,
                                pReserva       in varchar2) return varchar2;



  --
  FUNCTION  F_ct_contratadoDados(   pModo           in varchar2,
                                    pIdMap          in number,
                                    pCdAtend        in dbamv.atendime.cd_atendimento%type,
                                    pCdConta        in dbamv.reg_fat.cd_reg_fat%type,
                                    pCdLanc         in dbamv.itreg_fat.cd_lancamento%type,
                                    pCdItLan        in varchar2,
                                    pCdPrestador    in dbamv.prestador.cd_prestador%type,
                                    pCdConv         in dbamv.convenio.cd_convenio%type,
                                    vCt             OUT NOCOPY RecContrat,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2;
    --
  FUNCTION  F_ct_autorizacaoInternacao( pModo               in varchar2,
                                        pIdMap              in number,
                                        pCdAtend            in dbamv.atendime.cd_atendimento%type,
                                        pCdConta            in dbamv.reg_fat.cd_reg_fat%type,
                                        pCdGuia             in dbamv.guia.cd_guia%type,
                                        pCdConv             in dbamv.convenio.cd_convenio%type,
                                        vCt                 OUT NOCOPY RecAutorizInt,
                                        pMsg                OUT varchar2,
                                        pReserva            in varchar2) return varchar2;
  --
  FUNCTION  F_ct_guiaValorTotal( pModo          in varchar2,
                                 pIdMap         in number,
                                 pIdTissGuia    in number,
                                 pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                 pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                 pCdConv        in dbamv.convenio.cd_convenio%type,
                                 vCt            OUT NOCOPY RecVlTotal,
                                 pMsg           OUT varchar2,
                                 pReserva       in varchar2) return varchar2;
    --
  function F_qry (  vQry      in varchar2,
                    par1      in varchar2,
                    par2      in varchar2,
                    par3      in varchar2,
                    par4      in varchar2,
                    par5      in VARCHAR2,
                    pValCor   IN VARCHAR2,
                    pNmCampo  IN VARCHAR2) return varchar2;
    --

  FUNCTION  F_ctm_internacaoResumoGuia( pModo          in varchar2,
                                        pIdMap         in number,
                                        pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                        pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                        pMsg           OUT varchar2,
                                        pReserva       in varchar2) return varchar2;

    --

  FUNCTION  F_TISS  (   pFnc        IN varchar2,
                        param1      IN varchar2,
                        param2      IN varchar2,
                        param3      IN varchar2,
                        param4      IN varchar2,
                        param5      IN varchar2,
                        param6      IN varchar2,
                        param7      IN varchar2,
                        param8      IN varchar2,
                        param9      IN varchar2)  RETURN  varchar2;
    --
  FUNCTION  F_ct_procedimentoDados( pModo       in varchar2,
                                    pIdMap      in number,
                                    pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                    pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                    pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                    pCdItLan    in varchar2,
                                    pCdProFat   in dbamv.pro_fat.cd_pro_fat%type,
                                    pCdConv     in dbamv.convenio.cd_convenio%type,
                                    pTpGuia     in varchar2,
                                    vCt         OUT NOCOPY RecProcDados,
                                    pMsg        OUT varchar2,
                                    pReserva    in varchar2) return varchar2;
    --

  FUNCTION  F_ct_identEquipe(   pModo       in varchar2,
                                pIdMap      in number,
                                pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                pCdItLan    in varchar2,
                                vCt         OUT NOCOPY tableEquipe,
                                pMsg        OUT varchar2,
                                pReserva    in varchar2) return varchar2;
    --
  FUNCTION  F_ct_procedimentoExecutadoInt(  pModo       in varchar2,
                                            pIdMap      in number,
                                            pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                            pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                            pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                            pCdItLan    in varchar2,
                                            vCt         OUT NOCOPY RecProcInt,
                                            pMsg        OUT varchar2,
                                            pReserva    in varchar2) return varchar2;
    --
  function F_ret_tp_grupro (    pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                pCdProFat   in dbamv.pro_fat.cd_pro_fat%type,
                                pCdConv     in dbamv.convenio.cd_convenio%type,
                                pReserva    in varchar2       ) return varchar2;
    --

  function F_ret_tp_pagamento ( pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                pCdItLan    in varchar2,
                                pTpGuia     in varchar2,
                                pReserva    in varchar2    ) return varchar2;
    --
  function F_ret_sn_pertence_pacote (   pTpGuia     in varchar2,
                                        pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                        pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                        pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                        pCdItLan    in varchar2,
                                        pReserva    in varchar2    ) return varchar2;
    --
  FUNCTION  F_ct_procedimentoExecutadoOutr( pModo       in varchar2,
                                            pIdMap      in number,
                                            pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                            pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                            pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                            pCdItLan    in varchar2,
                                            pTpGuia     in varchar2,
                                            vCt         OUT NOCOPY RecOutDesp,
                                            pMsg        OUT varchar2,
                                            pReserva    in varchar2) return varchar2;
    --
  FUNCTION  F_ct_prestadorIdentificacao(    pModo           in varchar2,
                                            pIdMap          in number,
											pTpTransacao    in varchar2, -- Oswaldo BH
                                            pCdMultiEmpresa in dbamv.multi_empresas.cd_multi_empresa%type,
                                            pCdConv         in dbamv.convenio.cd_convenio%type,
                                            vCt             OUT NOCOPY RecPrestIdent,
                                            pMsg            OUT varchar2,
                                            pReserva        in varchar2) return varchar2;
    --
  FUNCTION  F_cabecalhoTransacao(   pModo           in varchar2,
                                    pIdMap          in number,
                                    pTpTransacao    in varchar2,
                                    pCdMultiEmpresa in dbamv.multi_empresas.cd_multi_empresa%type,
                                    pCdConv         in dbamv.convenio.cd_convenio%type,
                                    vCt             OUT NOCOPY RecCabecTransac,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2;

    --
  FUNCTION  F_epilogo ( pModo           in varchar2,
                        pIdMap          in number,
                        pIdTransacao    in number,
                        pCdConv         in dbamv.convenio.cd_convenio%type,
                        vCt             OUT NOCOPY RecEpilogo,
                        pMsg            OUT varchar2,
                        pReserva        in varchar2) return varchar2;
    --
  FUNCTION  F_mensagemTISS (    pModo           in varchar2,
                                pIdMap          in number,
                                pTpTransacao    in varchar2,
                                pCdMultiEmpresa in dbamv.multi_empresas.cd_multi_empresa%type,
                                pCdConv         in dbamv.convenio.cd_convenio%type,
                                pNrDocumento    in varchar2,
                                vCt             OUT NOCOPY RecMensagemLote,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2;
    --
  FUNCTION  F_GERA_TISS( pModo         in varchar2,
                        pIdMap         in number,
                        pCdAtend       in dbamv.atendime.cd_atendimento%type,
                        pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                        pTpGeracao     in varchar2,
                        pMsg           OUT varchar2,
                        pReserva       in varchar2) return varchar2;
    --
  function F_apaga_tiss(pModo           in varchar2,
                        pCdAtend        in dbamv.atendime.cd_atendimento%type,
                        pCdConta        in dbamv.reg_fat.cd_reg_fat%type,
                        pCdRemessa      in dbamv.remessa_fatura.cd_remessa%type,
                        pCdRemessaGlosa in dbamv.remessa_glosa.cd_remessa_glosa%type,
                        pMsg            OUT varchar2,
                        pReserva        in varchar2) return varchar2;
    --
  FUNCTION  F_ct_procedimentoHonorIndiv(  pModo     in varchar2,
                                        pIdMap      in number,
                                        pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                        pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                        pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                        pCdItLan    in varchar2,
                                        vCt         OUT NOCOPY RecProcHI,
                                        pMsg        OUT varchar2,
                                        pReserva    in varchar2) return varchar2;
    --
  FUNCTION  F_ctm_honorarioIndividualGuia(pModo         in varchar2,
                                        pIdMap          in number,
                                        pCdAtend        in dbamv.atendime.cd_atendimento%type,
                                        pCdConta        in dbamv.reg_fat.cd_reg_fat%type,
                                        pCdPrest        in dbamv.prestador.cd_prestador%type,
                                        pNrGuia         in varchar2,
                                        pNrSenha        in varchar2,
                                        pMsg            OUT varchar2,
                                        pReserva        in varchar2) return varchar2;
    --

  FUNCTION  F_gravaTissGuia (   pModo           in varchar2,
                                pTpGuia         in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_guia%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2;
    --
  FUNCTION  F_gravaTissItGuia ( pModo           in varchar2,
                                pTpGuia         in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_itguia%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2;
    --
  FUNCTION  F_gravaTissItGuiaCid ( pModo           in varchar2,
                                   vRg             in OUT NOCOPY dbamv.tiss_itguia_cid%rowtype,
                                   pMsg            OUT varchar2,
                                   pReserva        in varchar2) return varchar2;
    --
  FUNCTION  F_gravaTissItGuiaEqu (  pModo       in varchar2,
                                    vRg         in OUT NOCOPY dbamv.tiss_itguia_equ%rowtype,
                                    pMsg        OUT varchar2,
                                    pReserva    in varchar2) return varchar2;
    --
  FUNCTION  F_gravaTissItGuiaOut( pModo         in varchar2,
                                pTpGuia         in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_itguia_out%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2;
    --
  FUNCTION  F_ct_autorizacaoSADT( pModo        in varchar2,
                                pIdMap         in number,
                                pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                pCdConta       in dbamv.reg_amb.cd_reg_amb%type,
                                pCdLanc        in dbamv.itreg_fat.cd_lancamento%type,
                                pCdItLan       in varchar2,
                                pCdGuia        in dbamv.guia.cd_guia%type,
                                pCdConv        in dbamv.convenio.cd_convenio%type,
                                vCt            OUT NOCOPY RecAutorizSadt,
                                pMsg           OUT varchar2,
                                pReserva       in varchar2) return varchar2;
    --
  FUNCTION  F_ct_identEquipeSADT(   pModo       in varchar2,
                                    pIdMap      in number,
                                    pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                    pCdConta    in dbamv.reg_amb.cd_reg_amb%type,
                                    pCdLanc     in dbamv.itreg_amb.cd_lancamento%type,
                                    pCdItLan    in varchar2,
                                    vCt         OUT NOCOPY tableEquipe,
                                    pMsg        OUT varchar2,
                                    pReserva    in varchar2) return varchar2;
    --
  FUNCTION  F_ct_procedimentoExecutadoSadt( pModo       in varchar2,
                                            pIdMap      in number,
                                            pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                            pCdConta    in dbamv.reg_amb.cd_reg_amb%type,
                                            pCdLanc     in dbamv.itreg_amb.cd_lancamento%type,
                                            pCdItLan    in varchar2,
											vGPrincipal in varchar2, --Oswaldo incio 210325
                                            vCt         OUT NOCOPY RecProcSadt,
                                            pMsg        OUT varchar2,
                                            pReserva    in varchar2) return varchar2;
    --
  FUNCTION  F_ct_contratadoProfissionalDad (pModo          in varchar2,
                                            pIdMap         in number,
                                            pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                            pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                            pCdPrestador   in dbamv.prestador.cd_prestador%type,
                                            pCdConv        in dbamv.convenio.cd_convenio%type,
                                            vCt            OUT NOCOPY RecContrProf,
                                            pMsg           OUT varchar2,
                                            pReserva       in varchar2) return varchar2;

    --
  FUNCTION  F_ctm_sp_sadtGuia(  pModo          in varchar2,
                                pIdMap         in number,
                                pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                pCdConta       in dbamv.reg_amb.cd_reg_amb%type,
                                pTpClasse      in varchar2,
                                pCdPrest       in dbamv.prestador.cd_prestador%type,
                                pMsg           OUT varchar2,
                                pReserva       in varchar2) return varchar2;
    --
  FUNCTION  F_ctm_consultaAtendimento(pModo     in varchar2,
                                    pIdMap      in number,
                                    pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                    pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                    pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                    pCdProFat   in dbamv.pro_fat.cd_pro_fat%type,
                                    pCdConv     in dbamv.convenio.cd_convenio%type,
                                    vCt         OUT NOCOPY RecConsultaAtend,
                                    pMsg        OUT varchar2,
                                    pReserva    in varchar2) return varchar2;
  --
  FUNCTION  F_ctm_consultaGuia(   pModo        in varchar2,
                                pIdMap         in number,
                                pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                pCdConta       in dbamv.reg_amb.cd_reg_amb%type,
                                pCdLanc        in dbamv.itreg_fat.cd_lancamento%type,
                                pMsg           OUT varchar2,
                                pReserva       in varchar2) return varchar2;
  --
  FUNCTION  F_ctm_internacaoDados ( pModo       in varchar2,
                                    pIdMap      in number,
                                    pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                    pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                    vCt         OUT NOCOPY RecInternacaoDados,
                                    pMsg        OUT varchar2,
                                    pReserva    in varchar2) return varchar2;
  --
  FUNCTION  F_ctm_internacaoDadosSaida ( pModo       in varchar2,
                                    pIdMap      in number,
                                    pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                    pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                    vCt         OUT NOCOPY RecInternacaoDadosSaida,
                                    pMsg        OUT varchar2,
                                    pReserva    in varchar2) return varchar2;
  --
  FUNCTION  F_gravaTissItGuiaDecl (   pModo         in varchar2,
                                    vRg             in OUT NOCOPY dbamv.tiss_itguia_declaracao%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2;
  --
  FUNCTION f_cancela_envio (pnCdRemessa                 in number,       -- 1 Opo  ou
                            pnCdRemessaGlosa            in number,       -- 2 Opo
                            --
                            pnReserva                   in varchar2,
                            --
                            pvMsgErro                   out varchar2) return varchar;
  --
  FUNCTION  F_GERA_ENVIO (  pModo           in varchar2,
                            pIdMap          in number,
                            pCdRemessa      in dbamv.remessa_fatura.cd_remessa%type,
                            pCdRemessaGlosa in dbamv.remessa_glosa.cd_remessa_glosa%type,
                            pTpGeracao      in varchar2, -- G = Gera normal(caso no exista) ou retorna ID's se j existentes / R = Regera todas e retorna ID's gerados
                            pMsg            OUT varchar2,
                            pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_gravaTissMensagem (   pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.tiss_mensagem%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_gravaTissLote ( pModo         in varchar2,
                            vRg             in OUT NOCOPY dbamv.tiss_lote%rowtype,
                            pMsg            OUT varchar2,
                            pReserva        in varchar2) return varchar2;


  function FNC_CONF(  pChave    in varchar2,
                    pCdConv     in number,
                    pReserva    in varchar2) return  varchar2;
  --
  function F_ST(pChave      in varchar2,
                pValor      in varchar2,
                pCpo        in varchar2,
				par1		in varchar2,
				par2		in varchar2,
				par3		in varchar2,
				par4		in varchar2,
				par5		in varchar2) return  varchar2;
  --
  function F_ST(pChave      in varchar2,
                pValor      in varchar2,
                pCpo        in varchar2) return  varchar2;

  FUNCTION  F_ct_localContratado(   pModo          in varchar2,
                                    pIdMap         in number,
                                    pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                    pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                    pCdPrestador   in dbamv.prestador.cd_prestador%type,
                                    pCdConv        in dbamv.convenio.cd_convenio%type,
                                    vCt            OUT NOCOPY RecLocContrat,
                                    pMsg           OUT varchar2,
                                    pReserva       in varchar2) return varchar2;
  --
  FUNCTION  F_ct_dadosContratadoExecutante (  pModo          in varchar2,
                                            pIdMap         in number,
                                            pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                            pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                            pCdPrestador   in dbamv.prestador.cd_prestador%type,
                                            pCdConv        in dbamv.convenio.cd_convenio%type,
                                            vCt            OUT NOCOPY RecContrExec,
                                            pMsg           OUT varchar2,
                                            pReserva       in varchar2) return varchar2;
  --
  FUNCTION  F_ctm_sp_sadtAtendimento (pModo       in varchar2,
                                    pIdMap      in number,
                                    pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                    pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                    vCt         OUT NOCOPY RecDadosAtendSpSadt,
                                    pMsg        OUT varchar2,
                                    pReserva    in varchar2) return varchar2;
  --
  FUNCTION  F_dadosSolicitacao( pModo          in varchar2,
                                pIdMap         in number,
                                pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                pCdConta       in dbamv.reg_amb.cd_reg_amb%type,
                                pCdGuia        in dbamv.guia.cd_guia%type,
                                pIdTmp         IN dbamv.tmpmv_tiss_sol_guia.id_tmp%type,
                                vCt            OUT NOCOPY RecDadosSolicitacao,
                                pMsg           OUT varchar2,
                                pReserva       in varchar2) return varchar2;
  --
  FUNCTION F_ret_sn_equipe (pTpGuia     in varchar2,
                            pCdAtend    in dbamv.atendime.cd_atendimento%type,
                            pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                            pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                            pCdItLan    in varchar2,
                            pReserva    in varchar2    ) return varchar2;
  --
  FUNCTION F_ret_sn_HI (pCdAtend    in dbamv.atendime.cd_atendimento%type,
                        pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                        pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                        pCdItLan    in varchar2,
                        pReserva    in varchar2    ) return varchar2;
  --
  FUNCTION  F_gravaTissSolGuia (pModo           in varchar2,
                                pTpGuia         in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_sol_guia%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_gravaTissItSolGuia (pModo           in varchar2,
                                  pTpGuia         in varchar2,
                                  vRg             in OUT NOCOPY dbamv.tiss_itsol_guia%rowtype,
                                  pMsg            OUT varchar2,
                                  pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_ctm_sp_sadtSolicitacaoGuia  ( pModo       in varchar2,
                                            pIdMap      in number,
                                            pCdAtend    in dbamv.atendime.cd_atendimento%type,          --  <- opt 1
                                            pCdConta    in dbamv.reg_amb.cd_reg_amb%type,               --  <- opt 1
                                            pCdCarteira in number,-- dbamv.carteira.cd_carteira%type    --  <- opt 2
                                            pCdPrestSol in dbamv.prestador.cd_prestador%type,   	    --  <- opt 1,2
                                            pCdOrigem   in number,                                      --  <- opt 2,3
                                            pTpOrigem   in varchar2,                                    --  <- opt 2,3
                                            pMsg        OUT varchar2,
                                            pReserva    in varchar2) return varchar2;
  --
  FUNCTION  F_ctm_internacaoSolicitacaoGui  ( pModo     in varchar2,
                                            pIdMap      in number,
                                            pCdAtend    in dbamv.atendime.cd_atendimento%type,          --  <- opt 1
                                            pCdConta    in dbamv.reg_amb.cd_reg_amb%type,               --  <- opt 1
                                            pCdCarteira in number,-- dbamv.carteira.cd_carteira%type    --  <- opt 2
                                            pCdPrestSol in dbamv.prestador.cd_prestador%type,           --  <- opt 1,2
                                            pCdOrigem   in number,                                      --  <- opt 2,3
                                            pTpOrigem   in varchar2,                                    --  <- opt 2,3
                                            pMsg        OUT varchar2,
                                            pReserva    in varchar2) return varchar2;
  --
  FUNCTION  F_ctm_prorrogacaoSolicitacaoGu  ( pModo     in varchar2,
                                            pIdMap      in number,
                                            pCdAtend    in dbamv.atendime.cd_atendimento%type,          --  <- opt 1
                                            pCdConta    in dbamv.reg_amb.cd_reg_amb%type,               --  <- opt 1
                                            pCdCarteira in number,-- dbamv.carteira.cd_carteira%type    --  <- opt 2
                                            pCdPrestSol in dbamv.prestador.cd_prestador%type,   	      --  <- opt 1,2
                                            pCdOrigem   in number,                                      --  <- opt 2,3
                                            pTpOrigem   in varchar2,                                    --  <- opt 2,3
                                            pMsg        OUT varchar2,
                                            pReserva    in varchar2) return varchar2;
  --
  FUNCTION  F_DM  (pCdTipTuss in varchar2,
                 pCdAtend   in dbamv.atendime.cd_atendimento%type,
                 pCdConta   in dbamv.reg_fat.cd_reg_fat%type,
                 pCdLanc    in dbamv.itreg_fat.cd_lancamento%type,
                 pCdItLan   in varchar2,
                 pTussRel   in OUT RecTussRel,
                 pTuss      OUT RecTuss,
                 pMsg       OUT varchar2,
                 pReserva   in varchar2) return varchar2;
  --
  function fnc_retornar_guia_faixa( pnCdConvenio in dbamv.convenio.cd_convenio%type,
                                    pnCdMultiEmp in dbamv.multi_empresas.cd_multi_empresa%type,
                                    pvTpGuia     in varchar2,
                                    pvReserva    in varchar2,
                                    pvMsgErro    out varchar2 ) return varchar2;
  --
  FUNCTION  F_GERA_ELEGIBILIDADE( pModo           in varchar2,
                                pIdMap          in number,
                                pTpAcao         in varchar2,    -- 'G' - gerar dados / 'S' - Status
                                --
                                pCdAtend        dbamv.atendime.cd_atendimento%type, --1a.opt
                                pCdConta        dbamv.reg_fat.cd_reg_fat%type,      --1a.opt
                                pCdPaciente     dbamv.paciente.cd_paciente%type,    --2a.opt
                                pCdConvenio     dbamv.convenio.cd_convenio%type,    --2a.opt
                                pCdConPla       dbamv.con_pla.cd_con_pla%type,      --2a.opt
                                pIdBeneficiario varchar2,                           --   opt
                                --
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_gravaTissSolEleg (  pModo           in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_sol_eleg%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_ct_anexoCabecalho( pModo          in varchar2,
                                 pIdMap         in number,
                                 pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                 pCdConv        in dbamv.convenio.cd_convenio%type,
                                 pCdGuia        in dbamv.guia.cd_guia%type,
                                 pTpGuia        in varchar2,
                                 vCt            OUT NOCOPY RecAnexoCabec,
                                 pMsg           OUT varchar2,
                                 pReserva       in varchar2) return varchar2;
  --
  FUNCTION  F_ct_diagnosticoOncologico( pModo          in varchar2,
                                        pIdMap         in number,
                                        pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                        pCdPreMed      in dbamv.pre_med.cd_pre_med%type,
                                        pCdConv        in dbamv.convenio.cd_convenio%type,
                                        pTpGuia        in varchar2,
                                        vCt            OUT NOCOPY RecDiagnosticoOnco,
                                        pMsg           OUT varchar2,
                                        pReserva       in varchar2) return varchar2;
  --
  FUNCTION  F_ctm_anexoSolicitante( pModo          in varchar2,
                                    pIdMap         in number,
                                    pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                    pCdPrestador   in dbamv.prestador.cd_prestador%type,
                                    pCdConv        in dbamv.convenio.cd_convenio%type,
                                    vCt            OUT NOCOPY RecAnexoSolicitante,
                                    pMsg           OUT varchar2,
                                    pReserva       in varchar2) return varchar2;
  --
  FUNCTION  F_ctm_anexoSolicitacaoQuimio  ( pModo           in varchar2,
                                            pIdMap          in number,
                                            pCdAtend        in dbamv.atendime.cd_atendimento%type,
				                            pCdPreMed       in dbamv.pre_med.cd_pre_med%type,
				                            pCdTratamento   in dbamv.tratamento.cd_tratamento%type,
				                            pNrCiclo        in dbamv.ciclo_tratamento.nr_ciclo%type,
				                            pNrSessao       in dbamv.sessao_tratamento.nr_sessao%type,
				                            pCdGuia         in dbamv.guia.cd_guia%type,
                                            pMsg            OUT varchar2,
                                            pReserva        in varchar2) return varchar2;

  FUNCTION  F_gravaTissItSolGuiaTratAnt (pModo           in varchar2,
                                         pTpGuia         in varchar2,
                                         vRg             in OUT NOCOPY dbamv.TISS_ITSOL_GUIA_TRAT_ANTERIOR%rowtype,
                                         pMsg            OUT varchar2,
                                         pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_ctm_anexoSolicitacaoRadio   ( pModo           in varchar2,
                                            pIdMap          in number,
                                            pCdAtend        in dbamv.atendime.cd_atendimento%type,
				                            pCdPreMed       in dbamv.pre_med.cd_pre_med%type,
                                            pCdGuia         in dbamv.guia.cd_guia%type,
                                            pMsg            OUT varchar2,
                                            pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_ctm_anexoSolicitacaoOPME   (  pModo           in varchar2,
                                            pIdMap          in number,
                                            pCdAtend        in dbamv.atendime.cd_atendimento%type,
				                            pCdGuia         in dbamv.pre_med.cd_pre_med%type,
                                            pMsg            OUT varchar2,
                                            pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_GERA_SOL_STATUS ( pModo           in varchar2,
                                pIdMap          in number,
                                --
                                pIdTissSolGuia  dbamv.tiss_sol_guia.id%type,
                                --
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_gravaTissItSolStatus (pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.TISS_ITEM_SOLICITA_STATUS_AUT%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_GERA_SOLIC (  pModo           in varchar2,
                            pIdMap          in number,
                            --
                            pIdTissSolGuia  dbamv.tiss_sol_guia.id%type,
                            --
                            pMsg            OUT varchar2,
                            pReserva        in varchar2) return varchar2;
  --

  FUNCTION  F_gravaTissItSolCancGuia (pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.TISS_ITSOL_CANCELA_GUIA%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_gravaTissSolCancGuia (  pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.TISS_SOL_CANCELA_GUIA%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_GERA_GUIA_CANCELAMENTO (    pModo           in varchar2,
                                        pIdMap          in number,
                                        --
                                        pTpGuia         varchar2,
                                        pIdMensagemEnv  dbamv.tiss_mensagem.id%type,    -- 1a. opt
                                        pIdTissSolGuia  dbamv.tiss_sol_guia.id%type,    -- 2a. opt -- caso Solicitao
                                        pIdTissGuia     dbamv.tiss_guia.id%type,        -- 2a. opt -- caso Envio
                                        pTpCancelamento VARCHAR2,  --Oswaldo FATURCONV-22406
                                        --
                                        pMsg            OUT varchar2,
                                        pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_gravaTissSolStatProto ( pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.TISS_SOL_PROTOCOLO%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_GERA_SOL_STATUS_PROTOCOLO ( pModo           in varchar2,
                                        pIdMap          in number,
                                        --
                                        pIdMensagemEnv  dbamv.tiss_mensagem.id%type,
                                        --
                                        pMsg            OUT varchar2,
                                        pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_concilia_id_it_envio  ( pModo           in varchar2,
                                    pIdItEnvio      in dbamv.tiss_itguia.id%type,
                                    pCdAtend        in dbamv.atendime.cd_atendimento%type,
                                    pCdConta        in dbamv.reg_fat.cd_reg_fat%type,
                                    pCdLanc         in dbamv.itreg_fat.cd_lancamento%type,
                                    pCdItLan        in varchar2,
                                    pCdGlosas       in dbamv.glosas.cd_glosas%type,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2;
  --
  function FNC_TRADUZ_REVERSO    (  pModo           in varchar2,              --'CD_PRO_FAT'        --  obg
                                    pCdTuss         in dbamv.tuss.cd_tuss%type,                     --  obg
                                    pCdConvenio     in dbamv.convenio.cd_convenio%type,             --  obg
                                    pCdTipTuss      in dbamv.tip_tuss.cd_tip_tuss%type,             --  opt
                                    pCdMultiEmpresa in dbamv.multi_empresas.cd_multi_empresa%type,  --  opt
                                    pTpAtendimento  in dbamv.atendime.tp_atendimento%type,          --  opt
                                    pCdSetor        in dbamv.setor.cd_setor%type,                   --  opt
                                    pData           in dbamv.tuss.dt_fim_vigencia%type,             --  opt
                                    pReserva        in varchar2) return  varchar2;
  --
  FUNCTION  F_gravaTissLoteGuia (   pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.tiss_lote_guia%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_GERA_ENVIO_RECURSO (pModo           in varchar2,
                                pIdMap          in number,
                                pCdRemessaGlosa in dbamv.remessa_glosa.cd_remessa_glosa%type,
                                pTpGeracao      in varchar2, -- G = Gera normal(caso no exista) ou retorna ID's se j existentes / R = Regera todas e retorna ID's gerados
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2;
  --
  function F_apaga_tiss_sol(pModo           in varchar2,
                            pIdTissSol      in dbamv.guia.cd_guia%type,
                            pMsg            OUT varchar2,
                            pReserva        in varchar2) return varchar2;
  --
  function fnc_recebe_protocolo(pnIdMensEnvio        in number,
                                pvNrProtocolo        in varchar2,
                                --
                                pMsg                 out varchar2,
                                --
                                pReserva             in varchar2) return varchar2;
  --
  FUNCTION  F_GERA_SOL_DEMONSTRATIVO (pModo           in varchar2,
                                      pIdMap          in number,
                                      pTpDemon        in varchar2,    -- '1' - Dem.Pagamento / '2' - Dem.AnaliseConta
                                      --
                                      pIdMensagemEnv  dbamv.tiss_mensagem.id%type,    -- pTpDemon = 2
                                      pCdConvenio     dbamv.convenio.cd_convenio%type,-- pTpDemon = 1
                                      pDtPagamento    varchar2,                       -- pTpDemon = 1
                                      pCompetencia    varchar2,                       -- pTpDemon = 1 (AAAAMM)
                                      --
                                      pMsg            OUT varchar2,
                                      pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_gravaTissSolDemon ( pModo           in varchar2,
                                  vRg             in OUT NOCOPY dbamv.tiss_sol_demon%rowtype,
                                  pMsg            OUT varchar2,
                                  pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_gravaTissComunBenef ( pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.tiss_comunicacao_beneficiario%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2;
  --
  FUNCTION  F_GERA_NOTIFICACAO_INTERN ( pModo           in varchar2,
                                        pIdMap          in number,
                                        pTpAcao         in varchar2,    -- 'I' - Internao / 'A' - Alta
                                        --
                                        pCdAtend        dbamv.atendime.cd_atendimento%type,
                                        --
                                        pMsg            OUT varchar2,
                                        pReserva        in varchar2) return varchar2;
  --
  function F_ret_info_guias   ( pModo       in varchar2,
                                pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                pCdItLan    in varchar2,
                                pTpGuia     in varchar2,
                                pCdGuia     in dbamv.guia.cd_guia%type,
                                pReserva    in varchar2    ) return varchar2;
  --
  function F_ret_prestador (   pCdAtend       in dbamv.atendime.cd_atendimento%type,
                             pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                             pCdLanc        in dbamv.itreg_fat.cd_lancamento%type,
                             pCdItLan       in varchar2,
                             pCdPrestador   in dbamv.prestador.cd_prestador%type,
                             pCdConv        in dbamv.convenio.cd_convenio%type,
                             pTpGuia        in varchar2,
                             pTpClasse      IN varchar2,
                             pReserva       in varchar2    ) return varchar2;
  --
  FUNCTION  F_gravaTissGuiaJustificaGlosa ( pModo           in varchar2,
                                            vRg             in OUT NOCOPY dbamv.TISS_GUIA_JUSTIFICA_GLOSA%rowtype,
                                            pMsg            OUT varchar2,
                                            pReserva        in varchar2) return VARCHAR2;
  --
  --================================================================================================================
    --
  --
  --==================================================================
  --

FUNCTION  F_GERA_REENVIO( pModo           in varchar2,
                         pIdMap          in number,
                         pCdRemessa      in dbamv.remessa_fatura.cd_remessa%type,
                         pMsg            OUT varchar2,
                         pReserva        in varchar2) return VARCHAR2;

--Oswaldo FATURCONV-22406 inicio
FUNCTION  F_ENVIO_DOCUMENTOS( pModo        in varchar2,
                              pIdMap       in number,
                              pEnvioDocId  in dbamv.tiss_envio_documentos.id%type,
                              pMsg         OUT varchar2,
                              pReserva     in varchar2) return varchar2;

FUNCTION  F_gravaTissEnviaDoc( pModo           in varchar2,
                               pTpGuia         in varchar2,
                               vRg             in OUT NOCOPY dbamv.tiss_envio_documentos%rowtype,
                               pMsg            OUT varchar2,
                               pReserva        in varchar2) return varchar2;
--Oswaldo FATURCONV-22406 fim


FUNCTION f_retorna_campo_tiss(nMultiEmp in NUMBER
                              ,nConvenio in NUMBER
                              ,nTpAtendimento IN VARCHAR2
                              ,nCdOriAte IN NUMBER
                              ,cProFat in VARCHAR2
                              ,nCampoTiss in VARCHAR2
                                ,nDt_vigencia IN DATE ) RETURN VARCHAR2;

END;
/

CREATE OR REPLACE PACKAGE BODY dbamv.pkg_ffcv_tiss_v4 IS
--
-- Purpose: Package de funcionalidades do TISS vers真o 3;
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -----------------------------------------------------------------------------
--  Oswaldo    01-11-21  Cria真真o da Pkg iniciando pela fun真真o de retornar configura真真es
----------------------------------------------------
--vcConv  cConv%rowtype;
----------------------------------------------------
--
    cursor cAtendimento(pnAtend in number) is
    select nvl(a.tp_carater_internacao,decode(a.tp_atendimento,'U','U','E'))                   tp_carater_internacao,
           to_char(a.dt_atendimento,'yyyy-mm-dd')                                              dt_atendimento,
           a.dt_atendimento                                                                    dt_atendPac,--OSWALDO
           to_char(a.hr_atendimento,'hh24:mi:ss')                                              hr_atendimento,
           to_char(a.dt_atendimento,'yyyy-mm-dd')||'T'||to_char(a.hr_atendimento,'hh24:mi:ss') dh_atendimento,
           to_char(a.dt_alta,'yyyy-mm-dd')                                                     dt_alta,
           to_char(a.hr_alta,'hh24:mi:ss')                                                     hr_alta,
           decode(a.dt_alta, null, null,
                  to_char(a.dt_alta,'yyyy-mm-dd')||'T'||to_char(a.hr_alta,'hh24:mi:ss'))       dh_alta,
           decode( nvl(a.sn_gestacao_tiss,'N')       , 'S', 'true', 'false' )                  sn_gestacao_tiss,
           decode( nvl(a.sn_aborto_tiss,'N')         , 'S', 'true', 'false' )                  sn_aborto_tiss,
           decode( nvl(a.sn_transtorno_tiss,'N')     , 'S', 'true', 'false' )                  sn_transtorno_tiss,
           decode( nvl(a.sn_complicacao_tiss,'N')    , 'S', 'true', 'false' )                  sn_complicacao_tiss,
           decode( nvl(a.sn_atend_neo_tiss,'N')      , 'S', 'true', 'false' )                  sn_atend_neo_tiss,
           decode( nvl(a.sn_complicacao_neo_tiss,'N'), 'S', 'true', 'false' )                  sn_complicacao_neo_tiss,
           decode( nvl(a.sn_baixo_peso_tiss,'N')     , 'S', 'true', 'false' )                  sn_baixo_peso_tiss,
           decode( nvl(a.sn_cesario_tiss,'N')        , 'S', 'true', 'false' )                  sn_cesario_tiss,
           decode( nvl(a.sn_normal_tiss,'N')         , 'S', 'true', 'false' )                  sn_normal_tiss,
           a.tp_obito_mulher                                                                   tp_obito_mulher,
           a.tp_acidente_tiss                                                                  tp_acidente_tiss,
           a.nr_declaracao_obito                                                               nr_declaracao_obito,
           a.tp_atendimento                                                                    tp_atendimento_original,
           decode(a.tp_atendimento,'H','I',a.tp_atendimento)                                   tp_atendimento,
           a.tp_doenca                                                                         tp_doenca,
           a.nr_tempo_doenca                                                                   nr_tempo_doenca,
           a.tp_tempo_doenca                                                                   tp_tempo_doenca,
           a.tp_atendimento_tiss                                                               tp_atendimento_tiss,
           a.cd_cid                                                                            cd_cid,
           decode(a.cd_cid,null,null,'CID-10')                                                 tp_cid,
           a.cd_prestador                                                                      cd_prestador,
           a.cd_atendimento                                                                    cd_atendimento,
           a.cd_especialid                                                                     cd_especialid,
           a.cd_convenio                                                                       cd_convenio_atd,
           a.cd_con_pla                                                                        cd_con_pla,
           a.cd_paciente                                                                       cd_paciente,
           decode(nvl(a.sn_retorno, 'N'), 'S', 2, 'N', 1)                                      tp_consulta_tiss,
           a.cd_mot_alt                                                                        cd_mot_alt,
           a.cd_guia                                                                           cd_guia,
           a.nr_carteira                                                                       nr_carteira,
           a.cd_casos_atd                                                                      cd_casos_atd,
           a.cd_pro_int                                                                        cd_pro_int,
           nvl(a.sn_retorno,'N')                                                               sn_retorno,
           a.nr_guia_envio_principal                                                           nr_guia_envio_principal,
           a.sn_recem_nato                                                                     sn_recem_nato,
           a.cd_tip_acom                                                                       cd_tip_acom,
           a.cd_servico                                                                        cd_servico,
           a.cd_multi_empresa                                                                  cd_multi_empresa,
           a.cd_atendimento_pai                                                                cd_atendimento_pai,
           a.cd_ser_dis                                                                        cd_ser_dis,
           --Oswaldo FATURCONV-20760 inicio
           a.cd_programas_homecare                                                             cd_programas_homecare,
           a.cd_atendimento_tiss                                                               cd_atendimento_tiss,
           --Oswaldo FATURCONV-20760 fim
           --Oswaldo FATURCONV-22468 inicio
           a.tp_cobertura_especial                                                             tp_cobertura_especial,
           a.tp_regime_atendimento                                                             tp_regime_atendimento,
           a.tp_saude_ocupacional                                                              tp_saude_ocupacional,
           a.cd_ori_ate                                                                        cd_ori_ate
           --Oswaldo FATURCONV-22468 fim
      from dbamv.atendime a
     where a.cd_atendimento      = pnAtend;
  --
  -- informa真真es auxiliares da tabela atendime com join com outras tabelas.
  cursor cAtendimentoAUX(pnAtend in number) is
    select ate.cd_atendimento                                                                   cd_atendimento,
           ate.tp_atendimento                                                                   tp_atendimento,
           ate.cd_prestador                                                                     cd_prestador,
           nvl(tip_res.tp_saida_tiss,
                 decode(ate.tp_atendimento, 'I',
                        decode( ate.dt_alta, null, 4, 5 ), 5))                                  tp_saida,
           substr(cid.ds_cid,1,70)                                                              ds_cid,
           ate.cd_ori_ate                                                                       cd_ori_ate,
           ori.cd_setor                                                                         cd_setor_ori,
           ateinfo.ds_info_atendimento                                                          ds_info_atendimento,
           unid_int.sn_hospital_dia                                                             sn_hospital_dia,
           ape.cd_pres_ext                                                                      cd_pres_ext
      from dbamv.atendime ate
         , dbamv.tip_res tip_res
         , dbamv.cid
         , dbamv.ori_ate ori
         , dbamv.atendime_info  ateinfo
         , dbamv.leito
         , dbamv.unid_int
         , dbamv.atendime_prestador_externo ape
     where ate.cd_atendimento      = pnAtend
       and tip_res.cd_tip_res(+)   = ate.cd_tip_res
       and cid.cd_cid(+)           = ate.cd_cid
       and ori.cd_ori_ate(+)       = ate.cd_ori_ate
       and ateinfo.cd_atendimento(+) = ate.cd_atendimento
       and leito.cd_leito(+)       = ate.cd_leito
       and unid_int.cd_unid_int(+) = leito.cd_unid_int
       AND ape.cd_atendimento(+)   = ate.cd_atendimento;
  --
  cursor cAtendimentoMag(pnAtend in number, pnCdApr in number) is
    select tia.tp_tp_aco_meio_mag tp_aco,
           mot.cd_mot_alt_meio_mag,
           tip.cd_tip_int_meio_mag,
           ate.cd_atendimento,
           pnCdApr cd_apr_conta_meio_mag,
           tip.cd_tipo_internacao,
           tse.tp_servico_meio_mag
      from dbamv.atendime           ate,
           dbamv.mot_alt_meio_mag   mot,
           dbamv.tip_int_meio_mag   tip,
           dbamv.tip_aco_meio_mag   tia,
           dbamv.servico_meio_mag   tse
     where ate.cd_atendimento           = pnAtend
       and tia.cd_apr_conta_meio_mag(+) = pnCdApr
       and tia.cd_tip_acom(+)           = ate.cd_tip_acom
       and tip.cd_apr_conta_meio_mag(+) = pnCdApr
       and tip.cd_tipo_internacao(+)    = ate.cd_tipo_internacao
       and mot.cd_apr_conta_meio_mag(+) = pnCdApr
       and mot.cd_mot_alt(+)            = ate.cd_mot_alt
       and tse.cd_apr_conta_meio_mag(+) = pnCdApr
       and tse.cd_servico(+)            = ate.cd_ser_dis;
    --
  cursor cConta(pnConta in dbamv.reg_fat.cd_reg_fat%type, pnAtend in dbamv.atendime.cd_atendimento%type, pvTpConta in varchar2) is
    select to_char(r.dt_inicio, 'yyyy-mm-dd')      dt_emissao,
           r.cd_con_pla                            cd_con_pla,
           r.cd_convenio                           cd_convenio,
           r.cd_atendimento                        cd_atendimento,
           r.cd_reg_fat                            cd_conta,
           r.cd_tip_acom                           cd_tip_acom,
           'H'                                     tp_conta,
           r.cd_guia                               cd_guia,
           r.cd_remessa                            cd_remessa,
           r.cd_mot_alt                            cd_mot_alt,
           r.sn_fechada                            sn_fechada,
           r.nr_guia_envio_principal               nr_guia_envio_principal,
           r.cd_multi_empresa                      cd_multi_empresa,
           to_char(r.dt_inicio,'yyyy-mm-dd')       dt_inicio,
           to_char(r.dt_inicio,'hh24:mi:ss')       hr_inicio,
           to_char(r.dt_final,'yyyy-mm-dd')        dt_final,
           to_char(r.dt_final,'hh24:mi:ss')        hr_final,
           r.cd_conta_pai                          cd_conta_pai
      from dbamv.reg_fat r
     where cd_reg_fat = pnConta
       and pvTpConta  = 'I'
    union all
    select to_char(a.dt_atendimento, 'yyyy-mm-dd') dt_emissao,
           ita.cd_con_pla                          cd_con_pla,
           ita.cd_convenio                         cd_convenio,
           a.cd_atendimento                        cd_atendimento,
           pnConta                                 cd_conta,
           a.cd_tip_Acom                           cd_tip_acom,
           'A'                                     tp_conta,
           a.cd_guia                               cd_guia,
           ra.cd_remessa                           cd_remessa,
           a.cd_mot_alt                            cd_mot_alt,
           nvl(ita.sn_fechada, 'N')                sn_fechada,
           a.nr_guia_envio_principal               nr_guia_envio_principal,
         --nvl(ra.cd_multi_empresa, dbamv.pkg_mv2000.le_empresa)                 cd_multi_empresa,
           nvl(ra.cd_multi_empresa, nEmpresaLogada )                 cd_multi_empresa,  --adhospLeEmpresa
           to_char(a.dt_atendimento,'yyyy-mm-dd')  dt_inicio,
           to_char(a.hr_atendimento,'hh24:mi:ss')  hr_inicio,
           to_char(a.dt_alta,'yyyy-mm-dd')         dt_final,
           to_char(a.hr_alta,'hh24:mi:ss')         hr_final,
           null                                    cd_conta_pai
      from dbamv.atendime a
           ,(select cd_atendimento, cd_reg_amb, sn_fechada, cd_convenio, cd_con_pla
                from dbamv.itreg_amb
                where cd_reg_amb = pnConta
                and cd_atendimento = pnAtend
                group by cd_atendimento, cd_reg_amb, sn_fechada, cd_convenio, cd_con_pla) ita
           , dbamv.reg_amb ra
     where a.cd_atendimento = pnAtend
       and pvTpConta  <> 'I'
       and ita.cd_atendimento(+) = a.cd_atendimento
       and ra.cd_reg_amb (+) = ita.cd_reg_amb;
    --
    --
    --
  cursor cPaciente(pnPaciente in number, pnConv in number, pnPlano in number, pnCdAtend in NUMBER, pStElegPaciente IN VARCHAR2, pDtAtendimento IN DATE) IS --OSWALDO
    select substr(replace(replace(replace(replace(replace
           (c2.nr_carteira,' ',''),'/',''),'-',''),'.',''),',',''),1,20    )        nr_carteira,
           pa.nm_paciente                                                          nm_titular,
           c2.nm_titular                                                            nm_titular_carteira,
           to_char( c2.dt_validade, 'yyyy-mm-dd')                                   dt_validade_carteira,
           pa.nr_cns                                                               nr_cns,
           pa.cd_paciente                                                          cd_paciente,
           pa.tp_sexo                                                              tp_sexo,
           to_char(pa.dt_nascimento, 'yyyy-mm-dd')                                 dt_nascimento,
           c2.cd_con_pla                                                            cd_con_pla,
           c2.ds_con_pla                                                            ds_con_pla,
           c2.carteira_atendimento                                                  carteira_atendimento,
           c2.tp_ident_beneficiario                                                 tp_ident_beneficiario,
           c2.nr_id_beneficiario                                                    nr_id_beneficiario,
           c2.ds_template_ident_beneficiario                                        ds_template_ident_beneficiario,
           c2.cd_validacao                                                          cd_validacao,
           c2.cd_ausencia_validacao                                                 cd_ausencia_validacao,
           pa.nm_social_paciente                                                    nm_social_paciente
      from dbamv.paciente pa,
           (select  c.cd_paciente,
                    Nvl(eleg.nr_carteira,c.nr_carteira) nr_carteira,
                    c.nm_titular,
                    Nvl(eleg.dt_val_carteira, c.dt_validade) dt_validade,
                    c.cd_con_pla,
                    cp.ds_con_pla,
                    atend.nr_carteira carteira_atendimento,
                    eleg.tp_ident_beneficiario,
                    eleg.nr_id_beneficiario,
                    eleg.ds_template_ident_beneficiario,
                    eleg.cd_validacao,
                    eleg.cd_ausencia_validacao,
					c.sn_carteira_ativo
              from dbamv.carteira c
                  ,dbamv.con_pla cp
                  ,(select nr_carteira from dbamv.atendime ate where ate.cd_atendimento = pnCdAtend) atend
                  ,(select cd_paciente
                         , nr_carteira
                         , dt_val_carteira
                         , tp_ident_beneficiario
                         , nr_id_beneficiario
                         , ds_template_ident_beneficiario
                         , cd_ausencia_validacao
                         , cd_validacao
                         , tp_status
                      from dbamv.elegibilidade_paciente eleg
                      --OSWALDO IN真CIO
                         , (select max(dh_elegibilidade) dh_elegibilidade
                              from dbamv.elegibilidade_paciente
                             where cd_paciente = pnPaciente
                               and ((pStElegPaciente is not null and tp_status = pStElegPaciente) or (pStElegPaciente is null))
                               and ((pDtAtendimento is not null and trunc(dh_elegibilidade) = trunc(pDtAtendimento)) or (pDtAtendimento is null))
                               ) maxdt
                               --OSWALDO FIM
                     where eleg.dh_elegibilidade = maxDt.dh_elegibilidade
                       and cd_paciente = pnPaciente) eleg
             where c.cd_paciente = pnPaciente
               and c.cd_convenio = pnConv
               and c.cd_con_pla  = nvl(pnPlano,c.cd_con_pla)
               and atend.nr_carteira(+) = c.nr_carteira
               and cp.cd_convenio(+) = c.cd_convenio
               and cp.cd_con_pla(+)  = c.cd_con_pla
               and eleg.cd_paciente(+) = c.cd_paciente  ) c2
     where pa.cd_paciente                     = pnPaciente
       and c2.cd_paciente (+)                  = pa.cd_paciente
     Order by c2.carteira_atendimento, Decode(c2.sn_carteira_ativo, 'S', 1, 2), Nvl(c2.dt_validade,sysdate) desc; -- Oswaldo BH
    --
  cursor cConv(pnCdConv in number) is
    select lpad(c.nr_cgc,14,'0') nr_cgc
         , c.nr_registro_operadora_ans
         , c.cd_convenio
         , c.nm_convenio
         , cct.cd_versao_tiss
         , cd_proto
      from dbamv.convenio c
          ,dbamv.convenio_conf_tiss cct
          ,dbamv.tiss_versao t
     where c.cd_convenio      = pnCdConv
       and cct.cd_convenio(+) = c.cd_convenio
       and t.cd_versao_tiss   = cct.cd_versao_tiss;
  --

  cursor cPrestador(pcdprestador in number, pcdPresCon in number, pcdConvenio in number, pReserva in varchar2, pCdConPla in number ) is
    select pr.nr_cpf_cgc                                                                      nr_cpf_cgc,
           pres_con.cd_prestador_conveniado                                                   cd_prestador_conveniado,
           pr.nm_prestador                                                                    nm_prestador,
           pr.ds_codigo_conselho                                                              numero_conselho,
           decode( conselho.tp_conselho, 1, 'CRM', 2, 'CRO', 3, 'CREFITO', 4, 'CRP',
                   5, 'CRF', 6, 'CREFONO', 7, 'COREN', 8, 'CRESS', 9, 'CRV', 10, 'CRN', 'OUT' )   tipo_conselho,
            Decode (nvl( conselho.cd_uf,
                          substr( conselho.ds_conselho,
                                  instr(replace(replace(conselho.ds_conselho,'/','#'),'-','#'),'#')+1, 2 ))
                    ,'AC', 12, 'AL', 27, 'AP', 16, 'AM', 13, 'BA', 29, 'CE', 23, 'DF', 53, 'ES', 32, 'GO', 52,
                     'MA', 21, 'MT', 51, 'MS', 50, 'MG', 31, 'PR', 41, 'PB', 25, 'PA', 15, 'PE', 26, 'PI', 22,
                     'RN', 24, 'RS', 43, 'RJ', 33, 'RO', 11, 'RR', 14, 'SC', 42, 'SE', 28, 'SP', 35, 'TO', 17, 98) uf_prestador,
           pr.nr_cnes                                                                         codigo_cnes,
           pr.ds_endereco                                                                     ds_endereco,
           pr.nr_endereco                                                                     nr_endereco,
           pr.ds_bairro                                                                       ds_bairro,
           pr.ds_complemento                                                                  ds_complemento,
           pr.cd_prestador                                                                    cd_prestador,
           pr.cd_conselho                                                                     cd_conselho,
           cidade.nm_cidade                                                                   nm_cidade,
           cidade.cd_ibge                                                                     cd_ibge,
           pr.nr_cep                                                                          nr_cep,
           pr.cd_tipo_logradouro                                                              tipo_logradouro,
           pcdConvenio                                                                        cd_convenio,
           esp_princ.cd_especialid                                                            cd_especialid,
           pres_con.cd_unidade_origem                                                         cd_unidade_origem,
           pr.tp_vinculo                                                                      tp_vinculo,
           pr.nr_fone_contato                                                                 nr_fone_contato,
           pr.ds_email                                                                        ds_email
			    ,Nvl(pres_con.sn_paga_pelo_convenio,'N')																						sn_ativo_credenciamento
      from dbamv.prestador       pr,
           dbamv.conselho        conselho,
           dbamv.cidade          cidade,
            ( select pc.cd_prestador
                    ,pc.cd_prestador_conveniado
                    ,pc.cd_unidade_origem
					          ,pc.sn_paga_pelo_convenio --PROD-2542
                from dbamv.pres_con pc
                where (pcdPresCon is not null and pcdPresCon = pc.cd_pres_con)
                   or (pcdPresCon is null
                       and pc.cd_prestador = pcdprestador
                       and pc.cd_convenio  = pcdConvenio
                       and pc.sn_paga_pelo_convenio = 'S'
                     --and (pc.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                       and (pc.cd_multi_empresa = nEmpresaLogada               --adhospLeEmpresa
                            or pc.cd_multi_empresa is null ) )
				  and ( pc.cd_con_pla = pCdConPla or pc.cd_con_pla is null ) -- pda FATURCONV-1372
				  and ( pc.cd_regra = (SELECT p.cd_regra  -- pda FATURCONV-1372
										 FROM dbamv.empresa_con_pla p, dbamv.empresa_convenio c
										WHERE p.cd_convenio = c.cd_convenio
										  AND p.cd_convenio = pcdConvenio
										  AND p.cd_con_pla  = pCdConPla
										  AND p.cd_multi_empresa = c.cd_multi_empresa
										--AND c.cd_multi_empresa = DBAMV.PKG_MV2000.LE_EMPRESA ) or pc.cd_regra is null ) -- pda FATURCONV-1372
                      AND c.cd_multi_empresa = nEmpresaLogada ) or pc.cd_regra is null ) --adhospLeEmpresa
							) pres_con,
           ( select esp_med.cd_prestador,
                    esp_med.cd_especialid
               from dbamv.especialid,
                    dbamv.esp_med
              where esp_med.cd_especialid                       = especialid.cd_especialid
                and esp_med.sn_especial_principal = 'S'
                and especialid.sn_ativo           = 'S'
                and esp_med.cd_prestador                        = pcdprestador
            ) esp_princ
     where pr.cd_prestador           = pcdprestador
       and conselho.cd_conselho(+)   = pr.cd_conselho
       and cidade.cd_cidade(+)       = pr.cd_cidade
       and pres_con.cd_prestador(+)  = pr.cd_prestador
       and esp_princ.cd_prestador(+) = pr.cd_prestador;
  --
  -- SR_TISS0304 cd_ausencia_validacao, cd_validacao
  -- #PEND Gravar na guia ou buscar da elegibilidade?
  cursor cAutorizacao ( pCdGuia in dbamv.guia.cd_guia%type, pReserva in varchar2) is
    --
    select cd_guia,
           nr_guia,
           cd_senha       nr_senha,
           to_char(dt_autorizacao, 'yyyy-mm-dd')     					    dt_autorizacao,
           Decode(guia.cd_senha, null, to_char(null), to_char(dt_validade, 'yyyy-mm-dd') )  dt_validade,
           tp_situacao,
           ds_justificativa,
           ds_observacao,
           to_char(dt_solicitacao, 'yyyy-mm-dd')     					    dt_solicitacao
           --OSWALDO IN真CIO
          -- NULL cd_ausencia_validacao,
          -- NULL cd_validacao
          --OSWALDO FIM
      from dbamv.guia
     where guia.cd_guia = pCdGuia;
    --
  cursor cHospital(pcdMultiEmpresa in number) is
        select lpad(multi_empresas.cd_cgc,14,'0') cd_cgc,
               multi_empresas.ds_razao_social,
               multi_empresas.cd_multi_empresa,
               multi_empresas.ds_endereco,
               multi_empresas.nr_endereco,
               multi_empresas.nm_bairro,
               cidade.nm_cidade,
               cidade.cd_ibge,
               cidade.cd_uf,
               multi_empresas.cd_tipo_logradouro,
               multi_empresas.nr_cep,
               multi_empresas.nr_cnes
          from dbamv.multi_empresas,
               dbamv.cidade
         where multi_empresas.cd_multi_empresa = pcdMultiEmpresa
           and cidade.cd_cidade(+)             = multi_empresas.cd_cidade;
    --
  cursor cEmpresaConv(pcdMultiEmpresa in number, pcdConv in number) is
        select emp.cd_hospital_no_convenio,
               emp.cd_apr_conta_meio_mag,
               emp.cd_convenio_unificado,
               nvl( emp.nr_seq_lote, 0 ) nr_lote,
               emp.cd_convenio,
               emp.cd_multi_empresa
         from dbamv.empresa_convenio emp
        where emp.cd_convenio         = pcdConv
          and emp.cd_multi_empresa    = pcdMultiEmpresa;
    --
  cursor cProFat(pcdProFat in varchar2) is
        select pro_fat.cd_pro_fat,
               pro_fat.ds_pro_fat,
               pro_fat.ds_unidade,
               pro_fat.tp_serv_hospitalar,
               pro_fat.nr_auxiliar,
               pro_fat.cd_por_ane,
               pro_fat.sn_pacote,
               pro_fat.tp_consulta
          from dbamv.pro_fat
         where pro_fat.cd_pro_fat  = pcdProFat;
    --
  cursor cProFatAux(pcdProFat in varchar2, pReserva in varchar2) is
        select gru_pro.tp_gru_pro,
               gru_pro.cd_gru_pro,
               pro_fat.cd_pro_fat,
               pro_fat.tp_serv_hospitalar
          from dbamv.pro_fat,
               dbamv.gru_pro
         where pro_fat.cd_pro_fat  = pcdProFat
           and gru_pro.cd_gru_pro  = pro_fat.cd_gru_pro;
    --

  cursor cItem( pTpConta in varchar2, pcdAtendimento in number,
                pcdConta in number, pcdLancamento in dbamv.itreg_amb.CD_LANCAMENTO%TYPE,
                pcdItLan in varchar2, pReserva in varchar2) is

              select ita.cd_pro_fat
                   , nvl(ita.tp_pagamento,'P') tp_pagamento
                   , ita.cd_convenio
                   , null cd_conta_pai
                   , ita.cd_prestador
                   , ita.cd_ati_med    			 cd_ati_med
                   , null                        cd_itlan_med
                   , ita.cd_setor_produziu
                   , ita.vl_percentual_multipla
                   , ita.cd_mvto
                   , ita.cd_itmvto
                   , ita.tp_mvto
                   , Nvl(r.cd_regra,ecp.cd_regra) cd_regra
                   , to_char(ate.dt_atendimento,'yyyy-mm-dd') dt_lancamento
                   , to_char(ita.hr_lancamento,'hh24:mi:ss') hr_lancamento
                   , ita.sn_horario_especial
                   , null dt_inicio
                   , ita.cd_lancamento
                   , ita.cd_setor
                   , to_char(ita.dt_sessao, 'yyyy-mm-dd') dt_sessao
                   , ita.cd_reg_amb cd_conta
                   , ita.cd_atendimento
                   , ita.cd_guia
                   , ita.vl_total_conta
                   , ita.qt_lancamento
                   , ita.sn_pertence_pacote
                   , to_char(ita.hr_lancamento_final, 'hh24:mi:ss') hr_lancamento_final
                   , ita.cd_prestador cd_prestador_item
                   , nvl(ita.sn_paciente_paga,'N')  sn_paciente_paga
                   ,ita.cd_con_pla -- FATURCONV-1372
                from dbamv.itreg_amb ita,
                     dbamv.reg_amb r,
                     dbamv.atendime ate,
                     dbamv.empresa_con_pla ecp
               where pTpConta           <> 'I'
                 and ita.cd_lancamento  = pcdLancamento
                 and ita.cd_atendimento = pcdAtendimento
                 and ita.cd_reg_amb     = pcdConta
                 and ita.cd_reg_amb     = r.cd_reg_amb
                 and ate.cd_atendimento = ita.cd_atendimento
                 AND ecp.cd_multi_empresa = r.cd_multi_empresa
                 AND ecp.cd_convenio      = r.cd_convenio
                 AND ecp.cd_con_Pla       = ita.cd_con_pla
               union all
              select itf.cd_pro_fat
                   , nvl(nvl(itl.tp_pagamento, itf.tp_pagamento),'P') tp_pagamento
                   , r.cd_convenio
                   , itf.cd_conta_pai cd_conta_pai
                   , nvl(itl.cd_prestador,itf.cd_prestador) cd_prestador
                   , itf.cd_ati_med                         cd_ati_med
                   , itl.cd_ati_med                         cd_itlan_med    -- ???
                   , itf.cd_setor_produziu
                   , itf.vl_percentual_multipla
                   , itf.cd_mvto
                   , itf.cd_itmvto
                   , itf.tp_mvto
                   , r.cd_regra
                   , to_char(itf.dt_lancamento,'yyyy-mm-dd') dt_lancamento
                   , to_char(itf.hr_lancamento,'hh24:mi:ss') hr_lancamento
                   , itf.sn_horario_especial
                   , to_char(r.dt_inicio, 'yyyy-mm-dd') dt_inicio
                   , itf.cd_lancamento
                   , itf.cd_setor
                   , to_char(to_date(null),'yyyy-mm-dd') dt_sessao
                   , r.cd_reg_fat  cd_conta
                   , r.cd_Atendimento
                   , itf.cd_guia
                   , nvl(itl.vl_liquido, itf.vl_total_conta)  vl_total_conta
                   , itf.qt_lancamento
                   , itf.sn_pertence_pacote
                   , to_char(itf.hr_lancamento_final, 'hh24:mi:ss')     hr_lancamento_final
                   , itf.cd_prestador cd_prestador_item
                   , nvl(nvl(itl.sn_paciente_paga,itf.sn_paciente_paga),'N') sn_paciente_paga
                   , r.cd_con_pla
                from dbamv.itreg_fat itf,
                     dbamv.reg_fat r,
                     (select itlan_med.cd_lancamento
                           , itlan_med.tp_pagamento
                           , itlan_med.cd_reg_fat
                           , itlan_med.cd_prestador
                           , itlan_med.cd_ati_med
                           , itlan_med.vl_liquido
                           , itlan_med.sn_paciente_paga
                        from dbamv.itlan_med
                       where itlan_med.cd_reg_fat      = pcdConta
                         and itlan_med.cd_lancamento   = pcdLancamento
                         and itlan_med.cd_ati_med      = pcdItLan -- substr(pcdItLan,1,2)
                         ) itl
                         -- and itlan_med.cd_prestador    = nvl(to_number(substr(pcdItLan,4)),itlan_med.cd_prestador)) itl
                where pTpConta              = 'I'
                  and itf.cd_reg_fat        = pcdConta
                  and itf.cd_reg_fat        = r.cd_reg_fat
                  and itf.cd_lancamento     = pcdLancamento
                  and itl.cd_reg_fat(+)     = itf.cd_reg_fat
                  and itl.cd_lancamento(+)  = itf.cd_lancamento;
    --
  cursor cItemAux( pTpConta in varchar2,
                   pcdAtendimento in number,
                   pcdConta in DBAMV.ITREG_AMB.CD_REG_AMB%TYPE,
                   pcdLancamento in DBAMV.ITREG_AMB.CD_LANCAMENTO%TYPE,
                   pcdItLan in varchar2, pReserva in varchar2) is
              select  ita.cd_lancamento
                     ,null cd_itlan_med
                     ,ita.tp_mvto
                     ,ita.cd_mvto
                     -- Pedidos Imagem e Laborat真rio
                     ,to_char(nvl(prx.dt_pedido,plab.dt_pedido), 'yyyy-mm-dd') dt_pedido
                     ,to_char(prx.dt_solicitacao_guia, 'yyyy-mm-dd') dt_solicitacao_guia
                     ,to_char(prx.dt_autorizacao_guia, 'yyyy-mm-dd') dt_autorizacao_guia
                     -- Aviso Cirurgia
                     ,to_char(ac.dt_realizacao, 'yyyy-mm-dd')     dt_realizacao_cir
                     ,to_char(ac.dt_realizacao, 'hh24:mi:ss')     entrada_sala
                     ,to_char(ac.dt_fim_cirurgia, 'hh24:mi:ss')   fim_cirurgia
                     ,ac.tp_tecnica_utilizada                     tp_tecnica_utilizada
                     ,sn_robotica                                 sn_robotica
                     -- Cirurgia -
                     ,ca.cd_cirurgia                              cd_cirurgia
                     ,ca.cd_via_de_acesso                         cd_via_acesso
                     ,ca.sn_principal                             sn_principal
                     ,ita.cd_atendimento                          cd_atendimento
                     ,ita.cd_reg_amb                              cd_conta
                     ,itcob.cd_fornecedor                         cd_fornecedor
                     ,estoq.cd_produto                            cd_produto
                     ,estoq.CD_SOLSAI_PRO
                     ,ca.cd_cirurgia_aviso
                     ,ca.cd_aviso_cirurgia
                     ,Decode(ita.tp_mvto, 'Cirurgia', ca.cd_cirurgia_aviso, ita.cd_itmvto) cd_itmvto
                from dbamv.itreg_amb ita,
                     dbamv.Itcob_Pre_Ambu itcob,
                     (select rx.cd_ped_rx, irx.cd_itped_rx, irx.dt_solicitacao_guia, irx.dt_autorizacao_guia, dt_pedido, 'Imagem' tp_mvto
                            from dbamv.ped_rx rx, dbamv.itped_rx irx  where rx.cd_atendimento = pcdAtendimento AND irx.cd_ped_rx = rx.cd_ped_rx ) prx,
                     (select cd_ped_lab, dt_pedido, 'SADT' tp_mvto
                            from dbamv.ped_lab where cd_atendimento = pcdAtendimento ) plab,
                     (select cd_aviso_cirurgia, dt_realizacao, dt_fim_cirurgia, tp_tecnica_utilizada, sn_robotica, 'Cirurgia' tp_mvto
                            from dbamv.aviso_cirurgia where cd_atendimento = pcdAtendimento ) ac,
                     (select cav.cd_aviso_cirurgia, cav.cd_cirurgia_aviso, cav.cd_cirurgia, cir.cd_pro_fat, cav.cd_via_de_acesso, cav.sn_principal, 'Cirurgia' tp_mvto
                            from dbamv.cirurgia_aviso cav, dbamv.cirurgia cir
                            where cir.cd_cirurgia       = cav.cd_cirurgia
                              and cav.cd_aviso_cirurgia in (select cd_aviso_cirurgia
                                                              from dbamv.aviso_cirurgia
                                                             where cd_atendimento = pcdAtendimento)) ca,
                     (select it.cd_itmvto_estoque cd_itmvto, 'Produto' tp_mvto, it.cd_produto, mv.CD_SOLSAI_PRO
                            from dbamv.itmvto_estoque it, dbamv.mvto_estoque mv
                             where mv.cd_atendimento = pcdAtendimento
                               and it.cd_mvto_estoque = mv.cd_mvto_estoque) estoq
               where pTpConta           <> 'I'
                 and ita.cd_lancamento  = pcdLancamento
                 and ita.cd_atendimento = pcdAtendimento
                 and ita.cd_reg_amb     = pcdConta
                 -- Pedido Imagem
                 and prx.cd_ped_rx(+)   = ita.cd_mvto
                 and prx.tp_mvto(+)     = ita.tp_mvto
                 AND prx.cd_itped_rx(+) = ita.cd_itmvto
                 -- Pedido Laboratorio
                 and plab.cd_ped_lab(+) = ita.cd_mvto
                 and plab.tp_mvto(+)    = ita.tp_mvto
                 -- Aviso de Cirurgia
                 and ac.cd_aviso_cirurgia(+) = ita.cd_mvto
                 and ac.tp_mvto(+)           = ita.tp_mvto
                 -- Cirurgia do Aviso
                 and ca.cd_aviso_cirurgia(+) = ita.cd_mvto
                 and ca.cd_pro_fat(+)        = ita.cd_pro_fat
                 and ca.tp_mvto(+)           = ita.tp_mvto
                 -- itcob_pre
                 and itcob.cd_reg_amb(+)    = ita.cd_reg_amb
                 and itcob.cd_lancamento(+) = ita.cd_lancamento
                 -- itmvto
                 and estoq.tp_mvto(+)   = ita.tp_mvto
                 and estoq.cd_itmvto(+) = ita.cd_itmvto

              union all

              select  itr.cd_lancamento
                     ,pcdItLan cd_itlan_med
                     ,itr.tp_mvto
                     ,itr.cd_mvto
                     -- Pedidos Imagem e Laborat真rio
                     ,to_char(nvl(prx.dt_pedido,plab.dt_pedido), 'yyyy-mm-dd') dt_pedido
                     ,to_char(prx.dt_solicitacao_guia, 'yyyy-mm-dd') dt_solicitacao_guia
                     ,to_char(prx.dt_autorizacao_guia, 'yyyy-mm-dd') dt_autorizacao_guia
                     -- Aviso Cirurgia
                     ,to_char(ac.dt_realizacao, 'yyyy-mm-dd')     dt_realizacao_cir
                     ,to_char(ac.dt_realizacao, 'hh24:mi:ss')     entrada_sala
                     ,to_char(ac.dt_fim_cirurgia, 'hh24:mi:ss')   fim_cirurgia
                     ,ac.tp_tecnica_utilizada                     tp_tecnica_utilizada
                     ,sn_robotica                                 sn_robotica
                     -- Cirurgia
                     ,ca.cd_cirurgia                              cd_cirurgia
                     ,ca.cd_via_de_acesso                         cd_via_acesso
                     ,ca.sn_principal                             sn_principal
                     ,pcdAtendimento                              cd_atendimento
                     ,itr.cd_reg_fat                              cd_conta
                     ,itcob.cd_fornecedor                         cd_fornecedor
                     ,estoq.cd_produto                            cd_produto
                     ,estoq.CD_SOLSAI_PRO
                     ,ca.cd_cirurgia_aviso
                     ,ca.cd_aviso_cirurgia
                     ,Decode(itr.tp_mvto, 'Cirurgia', ca.cd_cirurgia_aviso, itr.cd_itmvto) cd_itmvto
                from dbamv.itreg_fat itr,
                     dbamv.Itcob_Pre itcob,
                     (select rx.cd_ped_rx, irx.cd_itped_rx, irx.dt_solicitacao_guia,irx.dt_autorizacao_guia, dt_pedido, 'Imagem' tp_mvto
                            from dbamv.ped_rx rx, dbamv.itped_rx irx  where rx.cd_atendimento = pcdAtendimento AND irx.cd_ped_rx = rx.cd_ped_rx ) prx,
                     (select cd_ped_lab, dt_pedido, 'SADT' tp_mvto
                            from dbamv.ped_lab where cd_atendimento = pcdAtendimento ) plab,
                     (select cd_aviso_cirurgia, dt_realizacao, dt_fim_cirurgia, tp_tecnica_utilizada, sn_robotica, 'Cirurgia' tp_mvto
                            from dbamv.aviso_cirurgia where cd_atendimento = pcdAtendimento ) ac,
                     (select cav.cd_aviso_cirurgia, cav.cd_cirurgia_aviso, cav.cd_cirurgia, cir.cd_pro_fat, cav.cd_via_de_acesso, cav.sn_principal, 'Cirurgia' tp_mvto
                            from dbamv.cirurgia_aviso cav, dbamv.cirurgia cir
                            where cir.cd_cirurgia       = cav.cd_cirurgia
                              and cav.cd_aviso_cirurgia in (select cd_aviso_cirurgia
                                                              from dbamv.aviso_cirurgia
                                                             where cd_atendimento = pcdAtendimento)) ca,
                     (select it.cd_itmvto_estoque cd_itmvto, 'Produto' tp_mvto, it.cd_produto, mv.CD_SOLSAI_PRO
                            from dbamv.itmvto_estoque it, dbamv.mvto_estoque mv
                             where mv.cd_atendimento = pcdAtendimento
                               and it.cd_mvto_estoque = mv.cd_mvto_estoque) estoq
               where pTpConta           = 'I'
                 and itr.cd_lancamento  = pcdLancamento
                 and itr.cd_reg_fat     = pcdConta
                 -- Pedido Imagem
                 and prx.cd_ped_rx(+)   = itr.cd_mvto
                 and prx.tp_mvto(+)     = itr.tp_mvto
                 AND prx.cd_itped_rx(+) = itr.cd_itmvto
                 -- Pedido Laboratorio
                 and plab.cd_ped_lab(+) = itr.cd_mvto
                 and plab.tp_mvto(+)    = itr.tp_mvto
                 -- Aviso de Cirurgia
                 and ac.cd_aviso_cirurgia(+) = itr.cd_mvto
                 and ac.tp_mvto(+)           = itr.tp_mvto
                 -- Cirurgia do Aviso
                 and ca.cd_aviso_cirurgia(+) = itr.cd_mvto
                 and ca.cd_pro_fat(+)        = itr.cd_pro_fat
                 and ca.tp_mvto(+)           = itr.tp_mvto
                 -- itcob_pre
                 and itcob.cd_reg_fat(+)    = itr.cd_reg_fat
                 and itcob.cd_lancamento(+) = itr.cd_lancamento
                 -- itmvto
                 and estoq.tp_mvto(+)   = itr.tp_mvto
                 and estoq.cd_itmvto(+) = itr.cd_itmvto;
    --
  Cursor cTissRI_Proc(pCdAtend in dbamv.atendime.cd_atendimento%type,
                      pCdConta in dbamv.reg_fat.cd_reg_fat%type,
                      pReserva in varchar2)
   IS
   SELECT
   	 --dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_contratadoDados','nomeContratado',1047,cd_atend,cd_reg_fat,null,null,null,null,null)                   nm_contratado_exe --  <-+
    dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_autorizacaoInternacao','numeroGuiaOperadora',1036,cd_atend,cd_reg_fat,cd_guia,null,null,null,null)     nr_guia_conv      --    | QUEBRA GUIAS
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_autorizacaoInternacao','senha',1036,cd_atend,cd_reg_fat,cd_guia,null,null,null,null)                   nr_senha_conv     --  <-+
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoInt','dataExecucao',1072,cd_atend,cd_reg_fat,cd_lanc,null,null,null,null)     	  data                --  <-+
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoInt','horaInicial',1072,cd_atend,cd_reg_fat,cd_lanc,null,null,null,null)      	  hr_ini              --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoInt','horaFinal',1072,cd_atend,cd_reg_fat,cd_lanc,null,null,null,null)        	  hr_fim              --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoDados','codigoTabela',1078,cd_atend,cd_reg_fat,cd_lanc,null,null,null,'RI')        		    tp_tabela           --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoDados','codigoProcedimento',1078,cd_atend,cd_reg_fat,cd_lanc,null,null,null,'RI')          cod_proc            --    | QUEBRA ITENS
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoDados','descricaoProcedimento',1078,cd_atend,cd_reg_fat,cd_lanc,null,null,null,'RI')       ds_proc             --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoInt','viaAcesso',1072,cd_atend,cd_reg_fat,cd_lanc,null,null,null,null)        	  tp_via_acesso       --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoInt','tecnicaUtilizada',1072,cd_atend,cd_reg_fat,cd_lanc,null,null,null,null)	    tp_tecnica          --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoInt','reducaoAcrescimo',1072,cd_atend,cd_reg_fat,cd_lanc,null,null,null,null)	    vl_perc_reduc_acres --  <-+
    ,cd_lanc
    ,cd_pro_fat
    ,tp_pagamento
    ,cd_itlan_med
    ,cd_guia
    ,cd_prestador_equ
      FROM ( select pCdAtend                                cd_atend,
                    itf.cd_reg_fat                          cd_reg_fat,
                    itf.cd_lancamento                	    cd_lanc,
                    nvl(itl.cd_ati_med,itf.cd_ati_med)      cd_ati_med,
                    itl.cd_ati_med                          cd_itlan_med,
                    itf.cd_pro_fat                          cd_pro_fat,
                    nvl(nvl(itl.tp_pagamento,itf.tp_pagamento),'P')  tp_pagamento,
                    itf.cd_guia
                     ,itf.cd_prestador cd_prestador_equ
               from dbamv.itreg_fat itf,
                   (select eq.cd_reg_fat, eq.cd_lancamento, eq.cd_ati_med, eq.cd_prestador, eq.id_it_envio, eq.tp_pagamento
                      from dbamv.itlan_med eq
                     where eq.cd_reg_fat =  pCdConta
                       and ( dbamv.pkg_ffcv_tiss_v4.fnc_conf('TP_EQUIPE_RI',null,lpad(pCdAtend,10,'0')||'#'||lpad(pCdConta,10,'0')) = '1' -- equipe aberta
                            AND
                             dbamv.pkg_ffcv_tiss_v4.fnc_conf('TP_PROC_GERA_EQUIPE_RI',null,lpad(pCdAtend,10,'0')||'#'||lpad(pCdConta,10,'0')) <> '0' --senao tiver equipe nao 真 para gerar
                            )
                       --and dbamv.pkg_ffcv_tiss_v4.F_ret_sn_equipe('RI',pCdAtend,pCdConta,eq.cd_lancamento,eq.cd_ati_med,null) = 'S'
                       ) itl
              where itf.cd_reg_fat       = pCdConta
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('RI',pCdAtend,itf.cd_reg_fat,itf.cd_lancamento, itl.cd_ati_med, null ) <> 'S'
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( pCdAtend,itf.cd_reg_fat,itf.cd_lancamento, itl.cd_ati_med,'RI' ,null ) = 'P'
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_grupro(pCdAtend,itf.cd_reg_fat,itf.cd_lancamento,null,null,null) in ('SP','SD')
                and dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('NR_GUIA_ESPECIFICA',pCdAtend,pCdConta,itf.cd_lancamento,null,'SPH',null,null)<>'S'
                and itl.cd_reg_fat(+)    = itf.cd_reg_fat
                and itl.cd_lancamento(+) = itf.cd_lancamento
				and decode(itl.cd_ati_med,null,itf.id_it_envio,itl.id_it_envio) IS NULL  )	-- <<-- s真 itens n真o gerados ainda
     ORDER BY	--nm_contratado_exe,
     			nr_guia_conv,
     			nr_senha_conv,
           		data,
           		hr_ini,
           		hr_fim,
           		tp_tabela,
           		cod_proc,
           		ds_proc,
           		tp_via_acesso,
           		tp_tecnica,
           		vl_perc_reduc_acres,
                cd_itlan_med;

    --
  Cursor cTissOutDesp ( pTpAtend in varchar2,
                        pCdAtend in dbamv.atendime.cd_atendimento%type,
                        pCdConta in dbamv.reg_fat.cd_reg_fat%type,
                        pCdPrest in dbamv.prestador.cd_prestador%type,
                        pCdGuia  in dbamv.guia.cd_guia%type,
                        pReserva in varchar2)
   IS
   SELECT
   	 --dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_contratadoDados','nomeContratado',1047,cd_atend,cd_conta,null,null,null,null,null)                       nm_contratado_exe   --  <-- QUEBRA GUIAS
    dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoOutr','dataExecucao',1108,cd_atend,cd_conta,cd_lanc,null,tp_guia_despesa,null,null)     	    data                --  <-+
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoOutr','horaInicial',1108,cd_atend,cd_conta,cd_lanc,null,tp_guia_despesa,null,null)      	    hr_ini              --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoOutr','horaFinal',1108,cd_atend,cd_conta,cd_lanc,null,tp_guia_despesa,null,null)        	    hr_fim              --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoOutr','codigoTabela',1108,cd_atend,cd_conta,cd_lanc,null,tp_guia_despesa,null,null)        	  tp_tabela           --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoOutr','codigoProcedimento',1108,cd_atend,cd_conta,cd_lanc,null,tp_guia_despesa,null,null)     cod_proc            --    | QUEBRA ITENS
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoOutr','descricaoProcedimento',1108,cd_atend,cd_conta,cd_lanc,null,tp_guia_despesa,null,null)  ds_proc             --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoOutr','reducaoAcrescimo',1108,cd_atend,cd_conta,cd_lanc,null,tp_guia_despesa,null,null)       vl_perc_reduc_acres --  <-+
    ,cd_lanc
    ,cd_pro_fat
    ,cd_prestador
      FROM ( select pCdAtend                            cd_atend,
                    itf.cd_reg_fat                      cd_conta,
                    itf.cd_lancamento                	cd_lanc,
                    itf.cd_pro_fat                      cd_pro_fat
                    ,'RI' tp_guia_despesa
                    ,itf.cd_prestador
               from dbamv.itreg_fat itf
              where pTpAtend             = 'I'
                and itf.cd_reg_fat       = pCdConta
                and pCdPrest is NULL
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('OU_RI',pCdAtend,cd_reg_fat,itf.cd_lancamento, null, null ) <> 'S'
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( pCdAtend,cd_reg_fat,itf.cd_lancamento, null,'DE',null ) = 'P'
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_grupro(pCdAtend,cd_reg_fat,itf.cd_lancamento,null,null,null) NOT in ('SP','SD')
                and dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('SN_DESPESA_DA_GUIA',pCdAtend,pCdConta,itf.cd_lancamento,null,'SPH',pCdGuia,null) = 'S'
				and itf.id_it_envio IS NULL
            Union all
              -- Despesas de Credenciado - especial
              select pCdAtend                            cd_atend,
                     itf.cd_reg_fat                      cd_conta,
                     itf.cd_lancamento                	 cd_lanc,
                     itf.cd_pro_fat                      cd_pro_fat
                     ,'RI' tp_guia_despesa
                     ,itf.cd_prestador
               from dbamv.itreg_fat itf
              where pTpAtend             = 'I'
                and itf.cd_reg_fat       = pCdConta
                and itf.cd_prestador is not null
                and pCdPrest is NOT NULL
                and pCdPrest = dbamv.pkg_ffcv_tiss_v4.F_ret_prestador (pCdAtend,pCdConta,itf.cd_lancamento,null,null,null,'SPH','CRED_INTERNACAO',null)
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('OU_RI',pCdAtend,cd_reg_fat,itf.cd_lancamento, null, null ) <> 'S'
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( pCdAtend,cd_reg_fat,itf.cd_lancamento, null,'DE',null ) = 'C'
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_grupro(pCdAtend,cd_reg_fat,itf.cd_lancamento,null,null,null) NOT in ('SP','SD')
				and itf.id_it_envio IS NULL
            Union all
              select pCdAtend                           cd_atend,
                    ita.cd_reg_amb                      cd_conta,
                    ita.cd_lancamento                	cd_lanc,
                    ita.cd_pro_fat                      cd_pro_fat
                    ,'SP' tp_guia_despesa
                    ,ita.cd_prestador
               from dbamv.itreg_amb ita
              where pTpAtend            <> 'I'
                and ita.cd_reg_amb       = pCdConta
                and ita.cd_atendimento   = pCdAtend
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('OU_SP', pCdAtend,cd_reg_amb,ita.cd_lancamento, null, null ) <> 'S'
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( pCdAtend,cd_reg_amb,ita.cd_lancamento, null,'DE', null ) = 'P'
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_grupro(pCdAtend,cd_reg_amb,ita.cd_lancamento,null,null,null) NOT in ('SP','SD')
                and dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('SN_DESPESA_DA_GUIA',pCdAtend,pCdConta,ita.cd_lancamento,null,'SPA',pCdGuia,null) = 'S'
				and ita.id_it_envio IS NULL -- <<-- s真 itens n真o gerados ainda
            Union all
              -- Despesas de Credenciado - especial
              select pCdAtend                            cd_atend,
                     ita.cd_reg_amb                      cd_conta,
                     ita.cd_lancamento                	 cd_lanc,
                     ita.cd_pro_fat                      cd_pro_fat
                     ,'RI' tp_guia_despesa
                     ,ita.cd_prestador
               from dbamv.itreg_amb ita
              where pTpAtend            <> 'I'
                and ita.cd_reg_amb       = pCdConta
                and ita.cd_atendimento   = pCdAtend
                and ita.cd_prestador is not null
                and pCdPrest is NOT NULL
                and pCdPrest = dbamv.pkg_ffcv_tiss_v4.F_ret_prestador (pCdAtend,pCdConta,ita.cd_lancamento,null,null,null,'SPA','CREDENCIADOS',null)
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('OU_SP',pCdAtend,cd_reg_amb,ita.cd_lancamento, null, null ) <> 'S'
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( pCdAtend,cd_reg_amb,ita.cd_lancamento, null,'DE',null ) = 'C'
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_grupro(pCdAtend,cd_reg_amb,ita.cd_lancamento,null,null,null) NOT in ('SP','SD')
				and ita.id_it_envio IS NULL
                 )
     ORDER BY	--nm_contratado_exe,
           		data,
           		hr_ini,
           		hr_fim,
           		tp_tabela,
           		cod_proc,
           		ds_proc,
           		vl_perc_reduc_acres;
  --
  cursor cTissGuiasCta (pTpConta in varchar2,pCdAtendimento in number, pCdConta in number, pCdRemessaGlosa in number ,pReserva in varchar2) is
     Select id,
            id_pai,
            cd_remessa_glosa,
            nr_guia,
            decode(nm_xml,'guiaResumoInternacao','RI','guiaSP_SADT','SP','guiaHonorarioIndividual','HI','guiaConsulta','CO','XX') tp_guia
       from (Select tg.id,
                    tg.id_pai,
                    tg.cd_remessa_glosa,
                    tg.nr_guia,
                    tg.nm_xml
               from dbamv.tiss_guia tg
              where pTpConta = 'I'
                and tg.cd_reg_fat     = pCdConta
              union all
             Select tg.id,
                    tg.id_pai,
                    tg.cd_remessa_glosa,
                    tg.nr_guia,
                    tg.nm_xml
               from dbamv.tiss_guia tg
              where pTpConta <> 'I'
                and tg.cd_atendimento = pCdAtendimento
                and ((tg.cd_reg_amb is not null and tg.cd_reg_amb   = pCdConta) or tg.cd_reg_amb is null)

            ) guias
       where ( (pCdRemessaGlosa is null)
                or (pCdRemessaGlosa is not null and cd_remessa_glosa = pCdRemessaGlosa) )
     Order by id_pai desc;
    --
  Cursor cTissHI (  pCdAtend in dbamv.atendime.cd_atendimento%type,
                    pCdConta in dbamv.reg_fat.cd_reg_fat%type,
                    pReserva in varchar2)
   IS
   SELECT
     dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_dadosContratadoExecutante','codigonaOperadora',1158,cd_atend,cd_conta,cd_prestador,null,null,null,null) cd_oper_contratado_exe   --  <-+ QUEBRA GUIAS
    ,nr_guia                                                                                                                                     nr_guia_conv             --    |
    ,nr_senha                                                                                                                                    nr_senha_conv            --  <-+
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoHonorIndiv','grauParticipacao',1170,cd_atend,cd_conta,cd_lanc,null,null,null,null)     grauPart            --  <-+
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoHonorIndiv','dataExecucao',1170,cd_atend,cd_conta,cd_lanc,null,null,null,null)     	  data                --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoHonorIndiv','horaInicial',1170,cd_atend,cd_conta,cd_lanc,null,null,null,null)      	  hr_ini              --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoHonorIndiv','horaFinal',1170,cd_atend,cd_conta,cd_lanc,null,null,null,null)        	  hr_fim              --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoDados','codigoTabela',1177,cd_atend,cd_conta,cd_lanc,null,null,null,'HI')        	    tp_tabela           --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoDados','codigoProcedimento',1177,cd_atend,cd_conta,cd_lanc,null,null,null,'HI')        cod_proc            --    | QUEBRA ITENS
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoDados','descricaoProcedimento',1177,cd_atend,cd_conta,cd_lanc,null,null,null,'HI')     ds_proc             --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoHonorIndiv','viaAcesso',1170,cd_atend,cd_conta,cd_lanc,null,null,null,null)        	  tp_via_acesso       --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoHonorIndiv','tecnicaUtilizada',1170,cd_atend,cd_conta,cd_lanc,null,null,null,null)	    tp_tecnica          --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoHonorIndiv','reducaoAcrescimo',1170,cd_atend,cd_conta,cd_lanc,null,null,null,null)	    vl_perc_reduc_acres --  <-+
    ,cd_lanc
    ,cd_prestador
    ,cd_itlan_med
    ,cd_pro_fat
    ,tp_pagamento
    ,cd_conta
    ,cd_prest_equipe
      FROM ( select pCdAtend                                cd_atend,
                    itf.cd_reg_fat                          cd_conta,
                    itf.cd_lancamento                	    cd_lanc,
                    itl.cd_ati_med                          cd_itlan_med,
                    To_Number(dbamv.pkg_ffcv_tiss_v4.F_ret_prestador (pCdAtend,itf.cd_reg_fat,itf.cd_lancamento,itl.cd_ati_med,null,null,'HI','CRED_INTERNACAO',null)) cd_prestador,
                    nvl(itl.cd_prestador,itf.cd_prestador)  cd_prest_equipe,
                    itf.cd_pro_fat                          cd_pro_fat,
                    nvl(itl.tp_pagamento,itf.tp_pagamento)  tp_pagamento
                    ,dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('RET_GUIA_ESPECIFICA',pCdAtend,itf.cd_reg_fat,itf.cd_lancamento,null,'HI',null,null) nr_guia
                    ,dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('RET_SENHA_ESPECIFICA',pCdAtend,itf.cd_reg_fat,itf.cd_lancamento,null,'HI',null,null) nr_senha
               from dbamv.itreg_fat itf,
                   (select eq.cd_reg_fat, eq.cd_lancamento, eq.cd_ati_med, eq.cd_prestador, eq.id_it_envio, eq.tp_pagamento
                      from dbamv.itlan_med eq
                     where (eq.cd_reg_fat in (select cd_reg_fat from dbamv.reg_fat where cd_reg_fat =  pCdConta AND cd_conta_pai is null)) --FATURCONV-7309
                       ) itl
              where nvl(pReserva,'I') = 'I'
                and itf.cd_reg_fat = pCdConta
                AND itf.cd_conta_pai = itf.cd_reg_fat
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('HI',pCdAtend,itf.cd_reg_fat,itf.cd_lancamento, itl.cd_ati_med, null ) <> 'S'
                and dbamv.pkg_ffcv_tiss_v4.F_ret_sn_HI( pCdAtend,itf.cd_reg_fat,itf.cd_lancamento, itl.cd_ati_med, null ) = 'S'
                and itl.cd_reg_fat(+)    = itf.cd_reg_fat
                and itl.cd_lancamento(+) = itf.cd_lancamento
				        -- (pode gerar credenciados na principal e na guia separada tamb真m, se configurado) -- and decode(itl.cd_ati_med,null,itf.id_it_envio,itl.id_it_envio) IS NULL
              UNION ALL
             --cursor sta joana
             select pCdAtend                                cd_atend,
                    itf.cd_reg_fat                          cd_conta,
                    itf.cd_lancamento                	    cd_lanc,
                    itl.cd_ati_med                          cd_itlan_med,
                    To_Number(dbamv.pkg_ffcv_tiss_v4.F_ret_prestador (pCdAtend,itf.cd_reg_fat,itf.cd_lancamento,itl.cd_ati_med,null,null,'HI','CRED_INTERNACAO',null)) cd_prestador,
                    nvl(itl.cd_prestador,itf.cd_prestador)  cd_prest_equipe,
                    itf.cd_pro_fat                          cd_pro_fat,
                    nvl(itl.tp_pagamento,itf.tp_pagamento)  tp_pagamento
                    ,dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('RET_GUIA_ESPECIFICA',pCdAtend,itf.cd_reg_fat,itf.cd_lancamento,null,'HI',null,null) nr_guia
                    ,dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('RET_SENHA_ESPECIFICA',pCdAtend,itf.cd_reg_fat,itf.cd_lancamento,null,'HI',null,null) nr_senha
               from dbamv.itreg_fat itf,
                   (select eq.cd_reg_fat, eq.cd_lancamento, eq.cd_ati_med, eq.cd_prestador, eq.id_it_envio, eq.tp_pagamento
                      from dbamv.itlan_med eq
                     where (eq.cd_reg_fat in (select cd_reg_fat from dbamv.reg_fat where cd_conta_pai = pCdConta AND cd_conta_pai <> cd_reg_fat))

                       ) itl
              where nvl(pReserva,'I') = 'I'
                and itf.cd_conta_pai = pCdConta
                AND itf.cd_conta_pai  <> itf.cd_reg_fat
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('HI',pCdAtend,itf.cd_reg_fat,itf.cd_lancamento, itl.cd_ati_med, null ) <> 'S'
                and dbamv.pkg_ffcv_tiss_v4.F_ret_sn_HI( pCdAtend,itf.cd_reg_fat,itf.cd_lancamento, itl.cd_ati_med, null ) = 'S'
                and itl.cd_reg_fat(+)    = itf.cd_reg_fat
                and itl.cd_lancamento(+) = itf.cd_lancamento

			  --
              union all
              --
              select pCdAtend                               cd_atend,
                    ita.cd_reg_amb                          cd_conta,
                    ita.cd_lancamento                	    cd_lanc,
                    null                                    cd_itlan_med,
                    ita.cd_prestador                        cd_prestador,
                    ita.cd_prestador                        cd_prest_equipe,
                    ita.cd_pro_fat                          cd_pro_fat,
                    ita.tp_pagamento                        tp_pagamento
                    ,dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('RET_GUIA_ESPECIFICA',pCdAtend,pCdConta,ita.cd_lancamento,null,'HI',null,null) nr_guia
                    ,dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('RET_SENHA_ESPECIFICA',pCdAtend,pCdConta,ita.cd_lancamento,null,'HI',null,null) nr_senha
               from dbamv.itreg_amb ita
              where nvl(pReserva,'I') <> 'I'
                and ita.cd_atendimento = pCdAtend
                and ita.cd_reg_amb = pCdConta
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('HI',pCdAtend,ita.cd_reg_amb,ita.cd_lancamento, null, null ) <> 'S'
                and dbamv.pkg_ffcv_tiss_v4.F_ret_sn_HI( pCdAtend,ita.cd_reg_amb,ita.cd_lancamento, null, null ) = 'S'
				and ita.id_it_envio IS NULL
                  )
     ORDER BY	cd_conta,
                cd_oper_contratado_exe,
                dbamv.pkg_ffcv_tiss_v4.F_ret_prestador (pCdAtend,pCdConta,cd_lanc,cd_itlan_med,null,null,'HI','CRED_INTERNACAO',null),
     			nr_guia_conv,
     			nr_senha_conv,
           		data,
           		hr_ini,
           		hr_fim,
           		tp_tabela,
           		cod_proc,
           		ds_proc,
           		tp_via_acesso,
           		tp_tecnica,
           		vl_perc_reduc_acres;
    --
  Cursor cTissSP_Proc(pCdAtend  in dbamv.atendime.cd_atendimento%type,
                      pCdConta  in dbamv.reg_amb.cd_reg_amb%type,
                      pTpClasse in varchar2,
                      pReserva  in varchar2)
   IS
   SELECT
     DISTINCT
   	 --dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_contratadoDados','nomeContratado',1444,cd_atend,cd_conta,cd_lanc,null,null,null,'SOLIC_SP')            nm_contratado_sol          --  <-+ --Oswaldo FATURCONV-22404
   	dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_contratadoProfissionalDad','nomeProfissional',1444,cd_atend,cd_conta,null,null,null,null,'SOLIC_SP')   nm_contratado_prof_sol     --    |
   	--,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_contratadoDados','nomeContratado',1460,cd_atend,cd_conta,null,null,cd_prestador,null,null)             nm_contratado_exe          --    | QUEBRA GUIAS --Oswaldo FATURCONV-22404
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_autorizacaoSADT','numeroGuiaOperadora',1433,cd_atend,cd_conta,cd_lanc,null,null,null,null)             nr_guia_conv               --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_autorizacaoSADT','senha',1433,cd_atend,cd_conta,cd_lanc,null,null,null,null)                           nr_senha_conv              --  <-+

    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoSadt','dataExecucao',1469,cd_atend,cd_conta,cd_lanc,null,null,null,null)    	data                --  <-+
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoSadt','horaInicial',1469,cd_atend,cd_conta,cd_lanc,null,null,null,null)      	hr_ini              --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoSadt','horaFinal',1469,cd_atend,cd_conta,cd_lanc,null,null,null,null)        	hr_fim              --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoDados','codigoTabela',1469,cd_atend,cd_conta,cd_lanc,null,null,null,'SP')        		  tp_tabela           --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoDados','codigoProcedimento',1469,cd_atend,cd_conta,cd_lanc,null,null,null,'SP')        cod_proc            --    | QUEBRA ITENS
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoDados','descricaoProcedimento',1469,cd_atend,cd_conta,cd_lanc,null,null,null,'SP')     ds_proc             --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoSadt','viaAcesso',1469,cd_atend,cd_conta,cd_lanc,null,null,null,null)     	  tp_via_acesso       --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoSadt','tecnicaUtilizada',1469,cd_atend,cd_conta,cd_lanc,null,null,null,null)	tp_tecnica          --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoSadt','reducaoAcrescimo',1469,cd_atend,cd_conta,cd_lanc,null,null,null,null)	vl_perc_reduc_acres --  <-+
    ,cd_lanc
    ,cd_pro_fat
    ,tp_pagamento
    ,cd_prestador
    ,cd_prestador_equ
    ,cd_itlan_med  --Oswaldo FATURCONV-20760
    ,cd_conta
    ,cd_guia
    ,cd_convenio
      FROM ( select ita.cd_atendimento                  cd_atend,
                    ita.cd_reg_amb                      cd_conta,
                    ita.cd_lancamento                	cd_lanc,
                    ita.cd_ati_med                      cd_ati_med,
                    null                                cd_itlan_med,
                    ita.cd_pro_fat                      cd_pro_fat,
                    nvl(ita.tp_pagamento,'P')           tp_pagamento,
                    dbamv.pkg_ffcv_tiss_v4.F_ret_prestador (pCdAtend,pCdConta,ita.cd_lancamento,null,null,null,'SPA',pTpClasse,null)  cd_prestador
                    ,ita.cd_prestador cd_prestador_equ
                    --decode(nvl(dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_CONTRAT_CRED_SP_AMBUL',null,lpad(pCdAtend,10,'0')||'#'||lpad(pCdConta,10,'0')),'1'),'1',
                    ,ita.cd_guia
                    ,ita.cd_convenio
               from dbamv.itreg_amb ita
              where pTpClasse in ('PRINCIPAL','CREDENCIADOS','SECUNDARIAS')
                and ita.cd_atendimento   = pCdAtend
                and ita.cd_reg_amb       = pCdConta
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('SP',ita.cd_atendimento,ita.cd_reg_amb,ita.cd_lancamento, null, null ) <> 'S'
                and (  (pTpClasse in ('PRINCIPAL','SECUNDARIAS') and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( ita.cd_atendimento,ita.cd_reg_amb,ita.cd_lancamento, ita.cd_ati_med,'SP',null ) = 'P')
                     or(pTpClasse='CREDENCIADOS' and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( ita.cd_atendimento,ita.cd_reg_amb,ita.cd_lancamento, ita.cd_ati_med,'SPC',null ) = 'C'))
                and (   (pTpClasse = 'PRINCIPAL' and dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('NR_GUIA_ESPECIFICA',pCdAtend,pCdConta,ita.cd_lancamento,null,'SPA',null,null) = 'N')
                     or ( pTpClasse = 'SECUNDARIAS' and dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('NR_GUIA_ESPECIFICA',pCdAtend,pCdConta,ita.cd_lancamento,null,'SPA',null,null) = 'S')
                     or   pTpClasse ='CREDENCIADOS' )
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_grupro(ita.cd_atendimento,ita.cd_reg_amb,ita.cd_lancamento,null,null,null) in ('SP','SD')
				        and Decode (pTpClasse,'CREDENCIADOS',null,ita.id_it_envio) IS NULL -- <<-- s真 itens n真o gerados ainda (exceto Credenciados que podem ser gerados na principal e nas secund真rias simultaneamente se configurado)
             --
             union all
             --
             select rf.cd_atendimento                       cd_atend,
                    itf.cd_reg_fat                          cd_conta,
                    itf.cd_lancamento                	    cd_lanc,
                    nvl(itl.cd_ati_med,itf.cd_ati_med)      cd_ati_med,
                    itl.cd_ati_med                          cd_itlan_med,
                    itf.cd_pro_fat                          cd_pro_fat,
                    nvl(nvl(itl.tp_pagamento,itf.tp_pagamento),'P')  tp_pagamento,
                    dbamv.pkg_ffcv_tiss_v4.F_ret_prestador (pCdAtend,pCdConta,itf.cd_lancamento,itl.cd_ati_med,null,null,'SPH',pTpClasse,null)  cd_prestador
                    ,itf.cd_prestador cd_prestador_equ
                    ,itf.cd_guia
                    ,rf.cd_convenio
               from dbamv.itreg_fat itf, dbamv.reg_fat rf
                   ,(select eq.cd_reg_fat, eq.cd_lancamento, eq.cd_ati_med, eq.cd_prestador, eq.id_it_envio, eq.tp_pagamento, eq.vl_liquido
                      from dbamv.itlan_med eq
					 where (eq.cd_reg_fat in (select cd_reg_fat from dbamv.reg_fat where cd_reg_fat =  pCdConta AND cd_conta_pai is null)) --FATURCONV-7309
                       ) itl                                                                                                               --FATURCONV-7309
              where pTpClasse in ('CRED_INTERNACAO','SECUNDARIAS')
                and rf.cd_atendimento   = pCdAtend
				        and itf.cd_reg_fat = pCdConta             --FATURCONV-7309
                AND ( itf.cd_reg_fat      = rf.cd_reg_fat
                      OR
                      itf.cd_conta_pai <> itf.cd_reg_fat
                    )
                and itl.cd_reg_fat(+)   = itf.cd_reg_fat
                and itl.cd_lancamento(+)= itf.cd_lancamento
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('SP',rf.cd_atendimento,itf.cd_reg_fat,itf.cd_lancamento, null, null ) <> 'S'
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_grupro(rf.cd_atendimento,itf.cd_reg_fat,itf.cd_lancamento,null,null,null) in ('SP','SD')
                and (  (pTpClasse in ('SECUNDARIAS') and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( rf.cd_atendimento,itf.cd_reg_fat,itf.cd_lancamento, itl.cd_ati_med,'SPH',null ) = 'P')
                     or(pTpClasse='CRED_INTERNACAO' and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( rf.cd_atendimento,itf.cd_reg_fat,itf.cd_lancamento, itl.cd_ati_med,'SPC',null ) = 'C'))
                and (  ( pTpClasse = 'SECUNDARIAS' and dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('NR_GUIA_ESPECIFICA',pCdAtend,pCdConta,itf.cd_lancamento,itl.cd_ati_med,'SPH',null,null) = 'S')
                     or   pTpClasse ='CRED_INTERNACAO' )
 				        and Decode (pTpClasse,'CREDENCIADOS',null,decode(itl.cd_ati_med,null,itf.id_it_envio,itl.id_it_envio)) IS NULL -- <<-- s真 itens n真o gerados ainda (exceto Credenciados que podem ser gerados
                                                                                                                                    -- na principal e nas secund真rias simultaneamente se configurado)
          --FATURCONV-7309 - sta joana
          UNION ALL
             select rf.cd_atendimento                       cd_atend,
                    itf.cd_reg_fat                          cd_conta,
                    itf.cd_lancamento                	    cd_lanc,
                    nvl(itl.cd_ati_med,itf.cd_ati_med)      cd_ati_med,
                    itl.cd_ati_med                          cd_itlan_med,
                    itf.cd_pro_fat                          cd_pro_fat,
                    nvl(nvl(itl.tp_pagamento,itf.tp_pagamento),'P')  tp_pagamento,
                    dbamv.pkg_ffcv_tiss_v4.F_ret_prestador (pCdAtend,pCdConta,itf.cd_lancamento,itl.cd_ati_med,null,null,'SPH',pTpClasse,null)  cd_prestador
                    ,itf.cd_prestador cd_prestador_equ
                    ,itf.cd_guia
                    ,rf.cd_convenio
               from dbamv.itreg_fat itf, dbamv.reg_fat rf
                   ,(select eq.cd_reg_fat, eq.cd_lancamento, eq.cd_ati_med, eq.cd_prestador, eq.id_it_envio, eq.tp_pagamento, eq.vl_liquido
                      from dbamv.itlan_med eq
					 where (eq.cd_reg_fat in (select cd_reg_fat from dbamv.reg_fat where cd_conta_pai = pCdConta AND cd_conta_pai is not null))  --FATURCONV-7309
                       ) itl                                                                                                           --FATURCONV-7309
              where pTpClasse in ('CRED_INTERNACAO','SECUNDARIAS')
                and rf.cd_atendimento   = pCdAtend
              --and rf.cd_conta_pai = pCdConta
              --AND rf.cd_conta_pai <> rf.cd_reg_fat
                and itf.cd_conta_pai = pCdConta         --FATURCONV-7309
                AND itf.cd_conta_pai  <> itf.cd_reg_fat --FATURCONV-7309
              --FATURCONV-7309 - Inicio
                AND (
                      ( dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_HOSP',rf.cd_convenio,null) = '2' AND itf.cd_guia IS NOT NULL )
                      OR
                      ( dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_HOSP',rf.cd_convenio,null) = '1')
                   )
              --FATURCONV-7309 - Fim
                and itf.cd_reg_fat      = rf.cd_reg_fat
                and itl.cd_reg_fat(+)   = itf.cd_reg_fat
                and itl.cd_lancamento(+)= itf.cd_lancamento
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('SP',rf.cd_atendimento,itf.cd_reg_fat,itf.cd_lancamento, null, null ) <> 'S'
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_grupro(rf.cd_atendimento,itf.cd_reg_fat,itf.cd_lancamento,null,null,null) in ('SP','SD')
                and (  (pTpClasse in ('SECUNDARIAS') and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( rf.cd_atendimento,itf.cd_reg_fat,itf.cd_lancamento, itf.cd_ati_med,'SPH',null ) = 'P')
                     or(pTpClasse='CRED_INTERNACAO' and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( rf.cd_atendimento,itf.cd_reg_fat,itf.cd_lancamento, itf.cd_ati_med,'SPC',null ) = 'C'))
              --and (  ( pTpClasse = 'SECUNDARIAS' and dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('NR_GUIA_ESPECIFICA',pCdAtend,pCdConta,itf.cd_lancamento,null,'SPH',null,null) = 'S')
                and (  ( pTpClasse = 'SECUNDARIAS' and dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('NR_GUIA_ESPECIFICA',rf.cd_atendimento,itf.cd_reg_fat,itf.cd_lancamento,null,'SPH',null,null) = 'S')
                     or   pTpClasse ='CRED_INTERNACAO' )
 				        and Decode (pTpClasse,'CREDENCIADOS',null,decode(itl.cd_ati_med,null,itf.id_it_envio,itl.id_it_envio)) IS NULL
              --FATURCONV-7309 - sta joana - fim
                )
     ORDER BY	nr_guia_conv,
     			    nr_senha_conv,
              Decode(FNC_CONF('TP_NR_GUIA_PREST_SP',cd_convenio,null), '4', cd_guia, NULL),
              --nm_contratado_sol, --Oswaldo FATURCONV-22404
              nm_contratado_prof_sol,
              --nm_contratado_exe, --Oswaldo FATURCONV-22404
           		data,
           		hr_ini,
           		hr_fim,
           		tp_tabela,
           		cod_proc,
           		ds_proc,
           		tp_via_acesso,
           		tp_tecnica,
           		vl_perc_reduc_acres desc;               -- fabio marques 05-03-2024
--              vl_perc_reduc_acres;
  --
  Cursor cDeclaracoes(  pCdAtend in dbamv.atendime.cd_atendimento%type,
                        pCdConta in dbamv.reg_fat.cd_reg_fat%type,
                        pReserva in varchar2)
    is
    -- informa真真es do RN (nascimento e/ou 真bito)
    select   ate.cd_atendimento_pai         cd_atendimento_mae
            ,r.cd_atendimento               cd_atendimento_rn
            ,r.cd_recem_nascido             cd_recem_nascido
            ,r.cd_declaracao_nascido_vivo   cd_declaracao_nascido_vivo
            ,ate.nr_declaracao_obito        nr_declaracao_obito
            ,decode(ate.nr_declaracao_obito,null,'N','S') sn_indicador_DO_RN
            ,decode(ate.nr_declaracao_obito,null,null,nvl(ate.cd_cid_obito,ate.cd_cid)) cd_cid_obito
        from dbamv.admissao_co aco, dbamv.recem_nascido r, dbamv.atendime ate
        where aco.cd_atendimento    = pCdAtend
          and r.cd_admissao_co      = aco.cd_admissao_co
          and ate.cd_atendimento(+) = r.cd_atendimento
    --
    union all
    --
    -- informa真真es de 真bito de pacientes (exceto RN)
    select   ate.cd_atendimento         		cd_atendimento_mae
            ,null                       		cd_atendimento_rn
            ,null                       		cd_recem_nascido
            ,null                       		cd_declaracao_nascido_vivo
            ,ate.nr_declaracao_obito    		nr_declaracao_obito
            ,Decode ( Nvl(ate.SN_RECEM_NATO,'N'), decode(ate.nr_declaracao_obito,null,'X','S'), 'S', 'N')   sn_indicador_DO_RN
            ,nvl(ate.cd_cid_obito,ate.cd_cid)	cd_cid_obito
        from dbamv.atendime ate, dbamv.mot_alt ma
        where ate.cd_atendimento = pCdAtend
          and ma.cd_mot_alt(+)   = ate.cd_mot_alt
          and nvl(ma.tp_mot_alta,'X')='O'
    order by sn_indicador_DO_RN desc,cd_declaracao_nascido_vivo,nr_declaracao_obito;
  --
  Cursor cRemessa (pRemessa in number, pReserva in varchar2) is
    select  rf.cd_remessa,
            rf.sn_fechada,
            f.cd_convenio,
            rf.nr_remessa_convenio,
            f.cd_multi_empresa
        from  dbamv.remessa_fatura rf,
              dbamv.fatura f
        where rf.cd_remessa = pRemessa
          and f.cd_fatura   = rf.cd_fatura;
  --
  Cursor cObtemMsgEnvio (nCdRemessa in number, nCdRemGlosa in number, nReserva in varchar2) is
        select msg_envio.id,
               msg_envio.tp_transacao,
               msg_envio.nr_protocolo_retorno,
               msg_envio.id_tl,
               msg_envio.id_tlg,
               lote_posterior.id_envio_posterior
         from (select  tm.id
                      ,tm.tp_transacao
                      ,tm.nr_protocolo_retorno
                      ,tm.nr_documento
                      ,tl.id    id_tl
                      ,tlg.id   id_tlg
                 from dbamv.tiss_mensagem tm,
                      dbamv.tiss_lote tl,
                      dbamv.tiss_lote_guia tlg,
                      dbamv.tiss_guia tg
                where tg.cd_remessa_glosa = nCdRemGlosa
                  and tlg.id = tg.id_pai
                  and tl.id = tlg.id_pai
                  and tm.id = tl.id_pai
                  and nvl(tm.cd_status,'PE') <> 'CA'
                  and tm.tp_transacao = 'RECURSO_GLOSA'
                  AND (tm.id = nReserva OR nReserva IS null)
                union
               select  tm.id
                      ,tm.tp_transacao
                      ,tm.nr_protocolo_retorno
                      ,tm.nr_documento
                      ,tl.id     id_tl
                      ,to_number( null)      id_tlg
                 from dbamv.tiss_mensagem tm,
                      dbamv.tiss_lote tl
                where tm.nr_documento = to_char(nCdRemessa)
                  and nvl(tm.cd_status,'PE') <> 'CA'
                  and tm.tp_transacao = 'ENVIO_LOTE_GUIAS'
                  and tm.id = tl.id_pai
                  AND (tm.id = nReserva OR nReserva IS null)) msg_envio,
              (select  tm.nr_documento -- GLOSA
                      ,tm.id id_envio_posterior
                 from  dbamv.tiss_mensagem tm
                      ,dbamv.tiss_lote tl
                      ,dbamv.tiss_guia tg
                      ,dbamv.remessa_glosa rg
                where rg.cd_remessa in (select rg2.cd_remessa
                                         from dbamv.remessa_glosa rg2
                                        where rg2.cd_remessa_glosa = nCdRemGlosa)
                  and rg.cd_remessa_glosa > nCdRemGlosa
                  and tg.cd_remessa = rg.cd_remessa
                  and tl.id = tg.id_pai
                  and tm.id = tl.id_pai
                  and nvl(tm.cd_status,'PE') <> 'CA'
                  AND (tm.id = nReserva OR nReserva IS null)
                union
                -- FATURAMENTO
               select  tm.nr_documento
                      ,tm.id id_envio_posterior
                from  dbamv.tiss_mensagem tm
                     ,dbamv.tiss_lote tl
                     ,dbamv.tiss_guia tg
                     ,dbamv.remessa_glosa rg
               where rg.cd_remessa = nCdRemessa
                 and tg.cd_remessa = rg.cd_remessa
                 and tl.id = tg.id_pai
                 and tm.id = tl.id_pai
                 and nvl(tm.cd_status,'PE') <> 'CA'
                 AND (tm.id = nReserva OR nReserva IS null)) lote_posterior
        where msg_envio.nr_documento = lote_posterior.nr_documento (+)
     order by msg_envio.nr_protocolo_retorno desc,lote_posterior.id_envio_posterior desc, msg_envio.id;
  --
  cursor cContaTotTiss ( pTpConta in varchar2,
                         pCdAtendimento in number,
                         pCdConta in number,
                         pReserva in varchar2) is
    select  cd_remessa,
            cd_remessa_glosa,
            cd_atendimento,
            nvl(cd_reg_fat,cd_reg_amb) cd_conta,
            decode(cd_reg_amb,null,'H','A') tp_conta,
            sum(to_number( nvl(tiss_guia.vl_procedimento_co,tiss_guia.vl_tot_geral), '999999999999999.99' )) vl_total_conta
      from dbamv.tiss_guia
     where tiss_guia.id_pai is null
       and tiss_guia.cd_atendimento                       = pCdAtendimento
       and nvl(tiss_guia.cd_reg_fat,tiss_guia.cd_reg_amb) = pCdConta
       and ( ( nvl(pReserva,'E')='E' and instr(nm_xml,'Reapresentacao')=0 )
          or ( nvl(pReserva,'E')='R' and instr(nm_xml,'Reapresentacao')>0 ) )
       and tiss_guia.nm_xml  not in ( 'guiaHonorarioIndividual' )
       and substr(nvl(substr(tiss_guia.nm_autorizador_conv,1,1),'P'),1,1) <> 'C'
       group by cd_remessa, cd_remessa_glosa, cd_atendimento, nvl(cd_reg_fat,cd_reg_amb), decode(cd_reg_amb,null,'H','A');

  --
  cursor cGuiasGeradas (pRemessa in number, pRemessaGlosa in number, pReserva in varchar2) is
    --
    -- Se tiver configura真真o para n真o quebrar Lote de SP/SADT de credenciados, ent真o campos TP_PAGAMENTO e Ident.Contr.Exe ficam NULOS
    -- para n真o ter crit真rio de quebra.
    select guias.nm_xml
          ,guias.tp_pagamento_guia
          ,decode(pReserva,null,guias.cd_convenio,null) cd_convenio
          ,decode(pReserva,null,guias.id_envio,null) id_envio
          ,decode(pReserva,null,guias.nr_lote,null) nr_lote
          ,decode(pReserva,null,guias.ordem_guia,null) ordem_guia
          ,decode(pReserva,null,guias.nr_guia,null) nr_guia
          ,decode(pReserva,null,guias.nr_guia_operadora,null) nr_guia_operadora
          ,decode(pReserva,null,guias.tp_conta,null) tp_conta
          ,decode(pReserva,null,guias.cd_atendimento,null) cd_atendimento
          ,decode(pReserva,null,guias.cd_conta,null) cd_conta
          ,decode(pReserva,null,guias.id,null) id
          ,decode(pReserva,null,guias.ident_contr_exe_quebra,null) ident_contr_exe_quebra
          ,decode(pReserva,null,guias.nm_paciente,null) nm_paciente
          ,decode(pReserva,null,guias.tp_guia,null) tp_guia
          ,count(guias.id) tt
      from (

            select nm_xml,
                   tp_pagamento_guia,
                   cd_convenio,
                   id_envio,
                   nr_lote,
                   ordem_guia,
                   nr_guia,
                   nr_guia_operadora,
                   tp_conta,
                   cd_atendimento,
                   cd_conta,
                   id
                   ,Decode(nvl(dbamv.pkg_ffcv_tiss_v4.fnc_conf('TP_QUEBRA_LOTE_CRED_SP_CO',cd_convenio,null),'1'),'2',ident_contr_exe_quebra,Decode(InStr(NM_PRESTADOR_CONTRATADO,'COOP'),0,NULL,ident_contr_exe_quebra)) ident_contr_exe_quebra
                   ,nm_paciente
                   ,decode(tipo_guia||SubStr(tp_pagamento_guia,1,1),'SPC','SP_CRED',tipo_guia) tp_guia
              from (select tg.id,
                           decode (substr(tg.nm_xml,1,6),'guiaCo',1,'guiaRe',1,'guiaHo',2,'guiaSP',3,4) ordem_guia,
                           tg.nr_guia_operadora,
                           tg.nr_guia,
                           tg.nm_xml,
                           decode(nm_xml,'guiaResumoInternacao','RI','guiaSP_SADT','SP','guiaHonorarioIndividual','HI','guiaConsulta','CO','XX') tipo_guia,
                           -- Campo "nm_autorizador_conv" reutilizado para tp_pagto_guia. Aten真真o conf.Global que desconsidera quebra de tp_pagto.na SP
                           tg.nm_autorizador_conv tp_pagamento_guia, --nvl(tg.nm_autorizador_conv,'P') tp_pagamento_guia,
                           tg.nr_lote,
                           to_number(tg.nr_lote) id_envio,
                           tg.cd_convenio,
                           decode (tg.cd_reg_amb,null,'H','A') tp_conta,
                           cd_atendimento,
                           nvl(tg.cd_reg_fat, tg.cd_reg_amb) cd_conta,
                           tg.nm_autorizador_conv tp_pagamento_guia_original
                           --,decode(substr(tg.nm_xml,1,6),'guiaCo',tg.CD_OPERADORA_EXE,'guiaSP',tg.CD_OPERADORA_EXE,'guiaHo',tg.CD_OPERADORA_EXE,null) ident_contr_exe_quebra
                           --Oswaldo in真cio 210325
						   ,decode(substr(tg.nm_xml,1,6),'guiaCo',
						    Decode(tg.CD_OPERADORA_EXE,NULL,
							Decode(tg.CD_CGC_EXE,NULL,
							Decode(tg.CD_CPF_EXE,NULL,NULL,'CPF0@'||tg.CD_CPF_EXE),'CNPJ@'||tg.CD_CGC_EXE),'OPER@'||tg.CD_OPERADORA_EXE),'guiaSP',
							Decode(tg.CD_OPERADORA_EXE,NULL,
							Decode(tg.CD_CGC_EXE,NULL,
							Decode(tg.CD_CPF_EXE,NULL,NULL,'CPF0@'||tg.CD_CPF_EXE),'CNPJ@'||tg.CD_CGC_EXE),'OPER@'||tg.CD_OPERADORA_EXE),'guiaHo',tg.CD_OPERADORA_EXE,null) ident_contr_exe_quebra
							--Oswaldo fim 210325
						   ,nm_paciente
                           ,tg.nm_prestador_contratado
                      from (
                            -- query principal (guias da remessa
                            select tg1.id, tg1.nm_xml, tg1.nm_autorizador_conv,tg1.cd_convenio,tg1.cd_operadora_sol,
                                   tg1.nr_guia_operadora,tg1.nr_guia,tg1.nr_lote,tg1.cd_reg_amb,tg1.cd_atendimento,tg1.cd_reg_fat
                                   ,tg1.CD_OPERADORA_EXE, tg1.CD_CPF_EXE, tg1.CD_CGC_EXE
                                   ,tg1.nm_paciente
                                   ,tg1.NM_PRESTADOR_CONTRATADO
                              from dbamv.tiss_guia tg1
                             where  pRemessa is not null and (tg1.cd_reg_fat in (select cd_reg_fat from dbamv.reg_fat where cd_remessa = pRemessa))
                               and tg1.id_pai IS null
                             union
                            select tg1.id, tg1.nm_xml, tg1.nm_autorizador_conv,tg1.cd_convenio,tg1.cd_operadora_sol,
                                   tg1.nr_guia_operadora,tg1.nr_guia,tg1.nr_lote,tg1.cd_reg_amb,tg1.cd_atendimento,tg1.cd_reg_fat
                                   ,tg1.CD_OPERADORA_EXE, tg1.CD_CPF_EXE, tg1.CD_CGC_EXE
                                   ,tg1.nm_paciente
                                   ,tg1.NM_PRESTADOR_CONTRATADO
                              from dbamv.tiss_guia tg1
                             where  NULL is not null and tg1.cd_remessa_glosa = NULL
                               and tg1.id_pai IS null
                             union
                            select tg1.id, tg1.nm_xml, tg1.nm_autorizador_conv,tg1.cd_convenio,tg1.cd_operadora_sol,
                                   tg1.nr_guia_operadora,tg1.nr_guia,tg1.nr_lote,tg1.cd_reg_amb,tg1.cd_atendimento,tg1.cd_reg_fat
                                   ,tg1.CD_OPERADORA_EXE, tg1.CD_CPF_EXE, tg1.CD_CGC_EXE
                                   ,tg1.nm_paciente
                                   ,tg1.NM_PRESTADOR_CONTRATADO
                              from dbamv.tiss_guia tg1
                             where  pRemessa is not null
                               and exists (select 'x' from dbamv.reg_amb ra, dbamv.itreg_amb ita where ra.cd_remessa = pRemessa and ita.cd_reg_amb = ra.cd_reg_amb and ita.cd_atendimento = tg1.cd_atendimento)
                               and tg1.id_pai IS null
                    --
                    union
                    -- Query opcional (passa-se tp_atend+atend+conta na Reserva e ele adiciona as guias desta conta na contagem da remessa;
                    select tg2.id, tg2.nm_xml, tg2.nm_autorizador_conv,tg2.cd_convenio,tg2.cd_operadora_sol,tg2.nr_guia_operadora
                          ,tg2.nr_guia,tg2.nr_lote,tg2.cd_reg_amb,tg2.cd_atendimento,tg2.cd_reg_fat
                          ,tg2.CD_OPERADORA_EXE, tg2.CD_CPF_EXE, tg2.CD_CGC_EXE
                          ,tg2.nm_paciente
                          ,tg2.NM_PRESTADOR_CONTRATADO
                      from dbamv.tiss_guia tg2
                     where pReserva is not null
                       and ( tg2.cd_atendimento = substr(pReserva,3,10) and
                           ( substr(pReserva,1,1)='I' and tg2.cd_reg_fat = substr(pReserva,14,10) ) or
                           ( substr(pReserva,1,1)<>'I' and tg2.cd_reg_amb = substr(pReserva,14,10) ) )

                    ) tg
                  )
           )  guias
    group by
             guias.nm_xml
            ,guias.tp_pagamento_guia
            ,guias.ident_contr_exe_quebra
            ,decode(pReserva,null,guias.cd_convenio,null)
            ,decode(pReserva,null,guias.id_envio,null)
            ,decode(pReserva,null,guias.nr_lote,null)
            ,decode(pReserva,null,guias.ordem_guia,null)
            ,decode(pReserva,null,guias.nr_guia,null)
            ,decode(pReserva,null,guias.nr_guia_operadora,null)
            ,decode(pReserva,null,guias.tp_conta,null)
            ,decode(pReserva,null,guias.cd_atendimento,null)
            ,decode(pReserva,null,guias.cd_conta,null)
            ,decode(pReserva,null,guias.id,null)
            ,decode(pReserva,null,guias.nm_paciente,null)
            ,decode(pReserva,null,guias.tp_guia,null)
    order by nvl(substr(tp_pagamento_guia,1,1),'P') desc, substr(tp_pagamento_guia,2), ordem_guia,
             Nvl(ident_contr_exe_quebra,' '),
             decode( dbamv.fnc_ffcv_conf_tiss('TP_ORDENACAO_GUIAS',cd_convenio,null),'N', nm_paciente,'G', nr_guia,cd_atendimento ),
             cd_atendimento, cd_conta, nvl(nr_guia_operadora,nr_guia);
  --
  cursor cRemessaCtas (pRemessa in number) is
    select pRemessa cd_remessa,
           a.cd_atendimento,
           cta_tot.cd_conta,
           decode(a.tp_atendimento,'I','H','A') tp_conta,
           cta_tot.vl_total_conta,
           pac.nm_paciente
      from dbamv.atendime a, dbamv.paciente pac,
           ( select rf.cd_atendimento,
                    rf.cd_reg_fat cd_conta,
                    rf.vl_total_conta
               from dbamv.reg_fat rf
              where rf.cd_remessa = pRemessa
              union all
             Select ita.cd_atendimento,
                    ra.cd_reg_amb cd_conta,
                    sum(decode(ita.tp_pagamento,'C',0,ita.vl_total_conta)) vl_total_conta
               from dbamv.reg_amb ra,
                    dbamv.itreg_amb ita
              where ra.cd_remessa  = pRemessa
                and ita.cd_reg_amb = ra.cd_reg_amb
                and ita.sn_pertence_pacote <> 'S'
                --and nvl(ita.tp_pagamento, 'P') <> 'C'
              group by ita.cd_atendimento, ra.cd_reg_amb
           ) cta_tot
     where a.cd_atendimento = cta_tot.cd_atendimento
       and pac.cd_paciente = a.cd_paciente
     order by pac.nm_paciente, a.cd_atendimento, tp_conta, cta_tot.cd_conta;
  --
    cursor cVlTotGuia(pIdPai in number, pTpItem in varchar2, pReserva in varchar2)
        is
        --
        select   '00' cd_despesa
                ,'valorProcedimentos' tp_despesa
                ,sum(to_number( tit.vl_total, '999999999999999.99' )) valor
            from dbamv.tiss_itguia tit, dbamv.tiss_guia tg
            where tg.id = pIdPai
              and tit.id_pai = tg.id
              and (  (substr(tg.nm_autorizador_conv,1,1) = 'P' and tit.tp_pagamento <> 'C')
                  or substr(tg.nm_autorizador_conv,1,1) = 'C' )
              and nvl(pTpItem,'valorProcedimentos') = 'valorProcedimentos'
          group by '00','valorProcedimentos'
        --
        union all
        --
        select  tio.tp_despesa cd_despesa
                ,decode(tio.tp_despesa,'01','valorGasesMedicinais','02','valorMedicamentos','03','valorMateriais','05','valorDiarias'
                                      ,'07','valorTaxasAlugueis','08','valorOPME','??????') tp_despesa
                ,sum(to_number( tio.vl_total, '999999999999999.99' )) valor
            from dbamv.tiss_itguia_out tio
            where tio.id_pai = pIdPai
            and nvl(pTpItem,'DESPESA') = 'DESPESA'
          group by 'DESPESA',tio.tp_despesa
        --
        order by 1 desc, 2;
  --
  cursor cAprTiss( Reserva in varchar2 ) is
    select apr.cd_apr_conta_meio_mag cd_apr_tiss
      from dbamv.apr_conta_meio_mag apr
     where apr.nm_funcao_banco = 'GERA_ARQMAG_TISS'
     order by cd_apr_tiss;
  --
  cursor cTipInternacao( pnApr in number, pnTipoInt in number ) is
    select tip.cd_tip_int_meio_mag cd_tipo
      from dbamv.tip_int_meio_mag tip
     where tip.cd_apr_conta_meio_mag = pnApr
       and tip.cd_tipo_internacao    = pnTipoInt;
  --
  Cursor cTissCO    (pCdAtend in dbamv.atendime.cd_atendimento%type,
                     pCdConta in dbamv.reg_amb.cd_reg_amb%type,
                     pReserva in varchar2)
   IS
   SELECT
     'S'  SN_TEM_CONSULTA
   	--,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_contratadoDados','nomeContratado',1407,cd_atend,cd_conta,null,null,null,null,null)              nm_contratado_exe       --  <-+ --Oswaldo FATURCONV-22404
   	,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_contratadoProfissionalDad','nomeProfissional',1413,cd_atend,cd_conta,null,null,null,null,null)  nm_contratado_prof_exe  --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ctm_consultaAtendimento','codigoTabela',1420,cd_atend,cd_conta,cd_lanc,null,null,null,null)        tp_tabela               --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ctm_consultaAtendimento','codigoProcedimento',1420,cd_atend,cd_conta,cd_lanc,null,null,null,null)  cod_proc                --  <-+
    ,cd_lanc
    ,cd_pro_fat
    ,tp_pagamento
      FROM ( select ita.cd_atendimento                  cd_atend,
                    ita.cd_reg_amb                      cd_conta,
                    ita.cd_lancamento                	cd_lanc,
                    ita.cd_ati_med                      cd_ati_med,
                    ita.cd_pro_fat                      cd_pro_fat,
                    ita.tp_pagamento                    tp_pagamento
               from dbamv.itreg_amb ita
              where ita.cd_atendimento   = pCdAtend
                and ita.cd_reg_amb       = pCdConta
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('CO',ita.cd_atendimento,ita.cd_reg_amb,ita.cd_lancamento, null, null ) <> 'S'
                and ( nvl(dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_GERACAO_GUIA_CONSULTA',ita.cd_convenio,null),'A') = 'A' or
                      dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_GERACAO_GUIA_CONSULTA',ita.cd_convenio,null)
                      in ( dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( ita.cd_atendimento,ita.cd_reg_amb,ita.cd_lancamento, null,'CO', null ), 'F'))
                and exists (select 'CONSULTA' from dbamv.pro_fat pf where pf.cd_pro_fat = ita.cd_pro_fat and pf.tp_consulta is not null)
                and NOT exists (select 'OUTROS_ITENS' from dbamv.itreg_amb ita1 where ita1.cd_atendimento = ita.cd_atendimento and ita1.cd_reg_amb = ita.cd_reg_amb and ita1.cd_lancamento<>ita.cd_lancamento)
				and ita.id_it_envio IS NULL  )	-- <<-- s真 itens n真o gerados ainda
     ORDER BY	--nm_contratado_exe,  --Oswaldo FATURCONV-22404
                nm_contratado_prof_exe,
           		tp_tabela,
           		cod_proc;
  --
  cursor cCodPro(pnEmpresa in dbamv.multi_empresas.cd_multi_empresa%type,
                 pnConvenio in dbamv.convenio.cd_convenio%type,
                 pvProFat dbamv.pro_fat.cd_pro_fat%type,
                 pvTpAtend dbamv.atendime.tp_atendimento%type ) is
    select cod_pro.ds_codigo_cobranca,
           cod_pro.ds_nome_cobranca,
           cod_pro.ds_unidade_cobranca,
           cod_pro.cd_multi_empresa,
           cod_pro.cd_convenio,
           cod_pro.cd_pro_fat,
           cod_pro.tp_atendimento,
           pvTpAtend    tp_atendimento_ori
      from dbamv.cod_pro
     where cod_pro.cd_pro_fat       = pvProFat
       and cod_pro.cd_convenio      = pnConvenio
       and cod_pro.cd_multi_empresa = pnEmpresa
       and ( cod_pro.tp_atendimento = pvTpAtend or cod_pro.tp_atendimento = 'T' );
  --
  cursor cTUSS_old (pvProFat in dbamv.pro_fat.cd_pro_fat%type,
                pdVigencia in dbamv.procedimento_tuss.dt_vigencia_pro_tuss%type,
                pReserva in varchar2 )  is
    select tuss.cd_pro_tuss,
           tuss.ds_pro_tuss,
           tuss.cd_pro_fat,
           tuss.dt_vigencia_pro_tuss
      from dbamv.procedimento_tuss tuss
     where tuss.cd_pro_fat = pvProFat
       and tuss.dt_vigencia_pro_tuss <= pdVigencia; --
  --
  cursor cCbosVersao(pnEspecialid in number, pvVersao in varchar2, pReserva in varchar2 ) is
    select decode(length(tvc.cd_cbos), 6,
           substr(tvc.cd_cbos,1,4)||'.'||substr(tvc.cd_cbos,5,6),
           tvc.cd_cbos)
      from dbamv.tiss_versao_cbos tvc
     where tvc.cd_versao_tiss = pvVersao
       and tvc.cd_especialid  = pnEspecialid;
  --
  Cursor cCarteira (pCdCarteira in number, /*dbamv.carteira.cd_carteira%type*/ pReserva in varchar2) is
    select  null cd_carteira,       -- c.cd_carteira
            c.cd_convenio,
            c.cd_con_pla,
            c.cd_paciente,
            c.nr_carteira,
            c.dt_validade
        from dbamv.carteira c
        where pCdCarteira = 'x';   -- PENDENTE !!!!  c.cd_carteira
  --
  Cursor cItensSolProc  (pTpOrigem dbamv.tiss_sol_guia.tp_origem_sol%type,
                         pCdOrigem dbamv.tiss_sol_guia.cd_origem_sol%type,
                         pReserva in varchar2) is
    --
    select  it.cd_pre_med                                               CD_ORIGEM,
            pTpOrigem                                                   TP_ORIGEM,
            it.cd_itpre_med                                             CD_IT_ORIGEM,
            nvl(nvl(lb.cd_pro_fat,rx.exa_rx_cd_pro_fat),tp.cd_pro_fat)  CD_PRO_FAT,
            decode(it.qt_itpre_med,0,1,null,1,it.qt_itpre_med)          QT_ITEM,
            it.ds_justificativa                                         DS_JUSTIFICATIVA,
            decode(eq.sn_exa_lab,'S','L'
                  ,decode(eq.sn_exa_rx,'S','I','P'))                    TP_PROCEDIMENTO,
            tp.ds_tip_presc                                             DS_DESCRICAO_ITEM,
            it.ds_itpre_med                                             DS_OBSERVACAO_ITEM,
            it.cd_set_exa                                               CD_SETOR_ITEM,
            nvl(ped_lab.cd_ped_lab,ped_rx.cd_ped_rx)                    CD_PEDIDO
      from dbamv.itpre_med it,
           dbamv.tip_presc tp,
           dbamv.tip_esq   eq,
         --dbamv.exa_lab   lb, --OP 36461
         --dbamv.exa_rx    rx, --OP 36461
           (select itped_lab.cd_itpre_med, max(ped_lab.cd_ped_lab) cd_ped_lab
              from dbamv.ped_lab, dbamv.itped_lab
             where itped_lab.cd_ped_lab = ped_lab.cd_ped_lab
               and ped_lab.cd_pre_med = pCdOrigem
             group by itped_lab.cd_itpre_med) ped_lab,
           (select itped_rx.cd_itpre_med, max(ped_rx.cd_ped_rx) cd_ped_rx
              from dbamv.ped_rx, dbamv.itped_rx
             where itped_rx.cd_ped_rx = ped_rx.cd_ped_rx
               and ped_rx.cd_pre_med = pCdOrigem
             group by itped_rx.cd_itpre_med) ped_rx
           --OP 36461 - inicio
           ,(SELECT b.cd_exa_lab, a.cd_exa_lab cd_exa_lab_secundario, a.cd_pro_fat
               FROM dbamv.exa_lab a, dbamv.exa_lab_secundario b
              WHERE a.cd_exa_lab = b.cd_exa_lab_secundario
             UNION
             SELECT a.cd_exa_lab, a.cd_exa_lab cd_exa_lab_secundario, a.cd_pro_fat FROM dbamv.exa_lab a ) lb

           ,(SELECT b.cd_exa_rx, a.cd_exa_rx cd_exa_rx_secundario, a.exa_rx_cd_pro_fat
               FROM dbamv.exa_rx a, dbamv.exa_rx_secundario b
              WHERE a.cd_exa_rx = b.cd_exa_rx_secundario
             UNION
             SELECT a.cd_exa_rx, a.cd_exa_rx cd_exa_rx_secundario, a.exa_rx_cd_pro_fat FROM dbamv.exa_rx a ) rx
           --OP 36461 - Fim
           ,dbamv.gru_pro gp
           ,dbamv.pro_fat pf
     where pTpOrigem = 'PRESCRICAO'
       and it.cd_pre_med = pCdOrigem
       and nvl(it.sn_cancelado,'N') = 'N'
       and tp.cd_tip_presc   = it.cd_tip_presc
       and eq.cd_tip_esq     = tp.cd_tip_esq
       and lb.cd_exa_lab(+)  = tp.cd_exa_lab
       and rx.cd_exa_rx(+)   = tp.cd_exa_rx
       and ped_lab.cd_itpre_med(+) = it.cd_itpre_med
       and ped_rx.cd_itpre_med(+)  = it.cd_itpre_med
       and ( tp.cd_exa_lab is not null or tp.cd_exa_rx is not NULL or tp.cd_pro_fat is not NULL)
       and nvl(nvl(lb.cd_pro_fat,rx.exa_rx_cd_pro_fat),tp.cd_pro_fat) = pf.cd_pro_fat
       and pf.cd_gru_pro = gp.cd_gru_pro
       and gp.tp_gru_pro IN ( 'SD', 'SP' )
    --
    UNION ALL
    --
    select  g.cd_guia                                                   CD_ORIGEM,
            pTpOrigem                                                   TP_ORIGEM,
            it.cd_it_guia                                               CD_IT_ORIGEM,
            it.cd_pro_fat                                               CD_PRO_FAT,
            it.qt_autorizado                                            QT_ITEM,
            g.ds_justificativa                                          DS_JUSTIFICATIVA,
            decode(lb.cd_pro_fat,null
                    ,decode(rx.cd_pro_fat,null,'P','I'),'L')            TP_PROCEDIMENTO,
            it.ds_procedimento                                          DS_DESCRICAO_ITEM,
            it.ds_observacao                                            DS_OBSERVACAO_ITEM,
            null                                                        CD_SETOR_ITEM,
            null                                                        CD_PEDIDO
       from dbamv.guia g
            , dbamv.it_guia it
            ,(select distinct cd_pro_fat from dbamv.exa_lab where cd_pro_fat is not null) lb
            ,(select distinct exa_rx_cd_pro_fat cd_pro_fat from dbamv.exa_rx  where exa_rx_cd_pro_fat is not null) rx
        where pTpOrigem = 'GUIA'
          and g.cd_guia = pCdOrigem
          and it.cd_guia = g.cd_guia
          and lb.cd_pro_fat(+)=it.cd_pro_fat
          and rx.cd_pro_fat(+)=it.cd_pro_fat
    --
    UNION ALL
    --
    select  it.id_tmp                                                   CD_ORIGEM,
            pTpOrigem                                                   TP_ORIGEM,
            it.id_prc                                                   CD_IT_ORIGEM,
            it.cd_pro_fat                                               CD_PRO_FAT,
            it.qt_solicitada                                            QT_ITEM,
            null                                                        DS_JUSTIFICATIVA,
            'P'                                                         TP_PROCEDIMENTO,
            null                                                        DS_DESCRICAO_ITEM,
            null                                                        DS_OBSERVACAO_ITEM,
            null                                                        CD_SETOR_ITEM,
            null                                                        CD_PEDIDO
       from dbamv.TMPMV_TISS_ITSOL_GUIA it
        where pTpOrigem = 'SOLICITACAO'
          and it.id_tmp = pCdOrigem
    --
    --
    order by TP_PROCEDIMENTO, CD_SETOR_ITEM, CD_PEDIDO, DS_JUSTIFICATIVA;
  --
  Cursor cItensSolInt   (pTpOrigem dbamv.tiss_sol_guia.tp_origem_sol%type,
                         pCdOrigem dbamv.tiss_sol_guia.cd_origem_sol%type,
                         pReserva in varchar2) is
    --
    select  g.cd_guia                                                   CD_ORIGEM,
            pTpOrigem                                                   TP_ORIGEM,
            it.cd_it_guia                                               CD_IT_ORIGEM,
            it.cd_pro_fat                                               CD_PRO_FAT,
            it.qt_autorizado                                            QT_ITEM,
            g.ds_justificativa                                          DS_JUSTIFICATIVA,
            decode(lb.cd_pro_fat,null
                    ,decode(rx.cd_pro_fat,null,'P','I'),'L')            TP_PROCEDIMENTO,
            it.ds_procedimento                                          DS_DESCRICAO_ITEM,
            it.ds_observacao                                            DS_OBSERVACAO_ITEM,
            null                                                        CD_SETOR_ITEM,
            null                                                        CD_PEDIDO
       from dbamv.guia g
            , dbamv.it_guia it
            ,(select distinct cd_pro_fat from dbamv.exa_lab where cd_pro_fat is not null) lb
            ,(select distinct exa_rx_cd_pro_fat cd_pro_fat from dbamv.exa_rx  where exa_rx_cd_pro_fat is not null) rx
        where pTpOrigem = 'GUIA'
          and g.cd_guia = pCdOrigem
          and it.cd_guia = g.cd_guia
          and lb.cd_pro_fat(+)=it.cd_pro_fat
          and rx.cd_pro_fat(+)=it.cd_pro_fat
    --
    UNION ALL
    --
    select  it.id_tmp                                                   CD_ORIGEM,
            pTpOrigem                                                   TP_ORIGEM,
            it.id_prc                                                   CD_IT_ORIGEM,
            it.cd_pro_fat                                               CD_PRO_FAT,
            it.qt_solicitada                                            QT_ITEM,
            null                                                        DS_JUSTIFICATIVA,
            'P'                                                         TP_PROCEDIMENTO,
            null                                                        DS_DESCRICAO_ITEM,
            null                                                        DS_OBSERVACAO_ITEM,
            null                                                        CD_SETOR_ITEM,
            null                                                        CD_PEDIDO
       from dbamv.TMPMV_TISS_ITSOL_GUIA it
        where pTpOrigem = 'SOLICITACAO'
          and it.id_tmp = pCdOrigem
    --
    order by TP_PROCEDIMENTO, CD_SETOR_ITEM, CD_PEDIDO, DS_JUSTIFICATIVA;
  --
  Cursor cItensSolProrrog   (pTpOrigem dbamv.tiss_sol_guia.tp_origem_sol%type,
                             pCdOrigem dbamv.tiss_sol_guia.cd_origem_sol%type,
                             pReserva in varchar2) is
    --
    select  g.cd_guia                                                   CD_ORIGEM,
            pTpOrigem                                                   TP_ORIGEM,
            it.cd_it_guia                                               CD_IT_ORIGEM,
            it.cd_pro_fat                                               CD_PRO_FAT,
            it.qt_autorizado                                            QT_ITEM,
            g.ds_justificativa                                          DS_JUSTIFICATIVA,
            decode(lb.cd_pro_fat,null
                    ,decode(rx.cd_pro_fat,null,'P','I'),'L')            TP_PROCEDIMENTO,
            it.ds_procedimento                                          DS_DESCRICAO_ITEM,
            it.ds_observacao                                            DS_OBSERVACAO_ITEM,
            null                                                        CD_SETOR_ITEM,
            null                                                        CD_PEDIDO
       from dbamv.guia g
            , dbamv.it_guia it
            ,(select distinct cd_pro_fat from dbamv.exa_lab where cd_pro_fat is not null) lb
            ,(select distinct exa_rx_cd_pro_fat cd_pro_fat from dbamv.exa_rx  where exa_rx_cd_pro_fat is not null) rx
        where pTpOrigem = 'GUIA'
          and g.cd_guia = pCdOrigem
          and it.cd_guia = g.cd_guia
          and lb.cd_pro_fat(+)=it.cd_pro_fat
          and rx.cd_pro_fat(+)=it.cd_pro_fat
    --
    UNION ALL
    --
    select  it.id_tmp                                                   CD_ORIGEM,
            pTpOrigem                                                   TP_ORIGEM,
            it.id_prc                                                   CD_IT_ORIGEM,
            it.cd_pro_fat                                               CD_PRO_FAT,
            it.qt_solicitada                                            QT_ITEM,
            null                                                        DS_JUSTIFICATIVA,
            'P'                                                         TP_PROCEDIMENTO,
            null                                                        DS_DESCRICAO_ITEM,
            null                                                        DS_OBSERVACAO_ITEM,
            null                                                        CD_SETOR_ITEM,
            null                                                        CD_PEDIDO
       from dbamv.TMPMV_TISS_ITSOL_GUIA it
        where pTpOrigem = 'SOLICITACAO'
          and it.id_tmp = pCdOrigem
    --
    order by tp_procedimento, cd_setor_item, cd_pedido, ds_justificativa;
  --
  --
  Cursor cTuss ( pCdTipTuss           in dbamv.tip_tuss.cd_tip_tuss%type
                ,parTussRel           in RecTussRel
                ,pReserva             in varchar2) is
        -- ATEN真真O:  Colunas SELECT manter os mesmos e mesma sequ真ncia de record  RECTUSS

        select    cd_multi_empresa, cd_convenio, cd_tip_tuss, cd_tuss, ds_tuss, dt_inicio_vigencia, dt_fim_vigencia, dt_fim_implantacao
                , ds_edicao_norma_observacoes, ds_descricao_detalhada, ds_apresentacao, nm_fabricante, cd_ref_fabricante, nm_laboratorio, ds_sigla, cd_referencia
            from (
        select    cd_multi_empresa, cd_convenio,cd_tip_tuss, cd_tuss, ds_tuss, dt_inicio_vigencia, dt_fim_vigencia
                , dt_fim_implantacao, ds_edicao_norma_observacoes, ds_descricao_detalhada, ds_apresentacao, nm_fabricante
                , cd_ref_fabricante, nm_laboratorio, ds_sigla
                ,sn_cd_pro_fat,sn_tp_atendimento,sn_cd_gru_pro,sn_tp_gru_pro,sn_cd_especialidade,sn_cd_tip_acom
                ,sn_cd_mot_alt,sn_tp_serv_hospitalar,sn_cd_servico,sn_cd_ati_med,sn_cd_conselho,sn_tp_sexo,sn_cd_motivo_glosa, sn_cd_setor
                ,cd_especialidade,cd_tip_acom,cd_mot_alt,cd_servico,cd_gru_pro,cd_pro_fat,cd_ati_med
                ,cd_conselho,cd_motivo_glosa,tp_atendimento,tp_sexo,tp_gru_pro,tp_servico_hospitalar,cd_referencia, cd_setor
           from (
        select    t.cd_multi_empresa, t.cd_convenio,t.cd_tip_tuss, t.cd_tuss, ds_tuss, t.dt_inicio_vigencia, t.dt_fim_vigencia
                , t.dt_fim_implantacao, t.ds_edicao_norma_observacoes, t.ds_descricao_detalhada, t.ds_apresentacao, t.nm_fabricante
                , t.cd_ref_fabricante, t.nm_laboratorio, t.ds_sigla
                ,tip.sn_cd_pro_fat,tip.sn_tp_atendimento,tip.sn_cd_gru_pro,tip.sn_tp_gru_pro,tip.sn_cd_especialidade,tip.sn_cd_tip_acom
                ,tip.sn_cd_mot_alt,tip.sn_tp_serv_hospitalar,tip.sn_cd_servico,tip.sn_cd_ati_med,tip.sn_cd_conselho,tip.sn_tp_sexo,tip.sn_cd_motivo_glosa, tip.sn_cd_setor
                ,t.cd_especialidade,t.cd_tip_acom,t.cd_mot_alt,t.cd_servico,t.cd_gru_pro,t.cd_pro_fat,t.cd_ati_med
                ,t.cd_conselho,t.cd_motivo_glosa,t.tp_atendimento,t.tp_sexo,t.tp_gru_pro,t.tp_servico_hospitalar, t.cd_referencia, t.cd_setor
        from dbamv.tuss t, dbamv.tip_tuss tip
        where decode(pCdTipTuss,00,999,98,999,18,999,19,999,20,999,22,999,pCdTipTuss)= tip.cd_tip_tuss
          and tip.cd_tip_tuss = pCdTipTuss
          and tip.cd_tip_tuss = t.cd_tip_tuss
           --
          and ((t.cd_multi_empresa is not null and t.cd_multi_empresa = parTussRel.cd_multi_empresa) or t.cd_multi_empresa is null)
          and ((t.cd_convenio is not null and t.cd_convenio = parTussRel.cd_convenio) or t.cd_convenio is null)
           --
          and t.dt_inicio_vigencia<=parTussRel.DT_VIGENCIA
          and ((t.dt_fim_vigencia is not null and t.dt_fim_vigencia>=parTussRel.DT_VIGENCIA) or t.dt_fim_vigencia is null)
           --
          and (t.cd_pro_fat = nvl(parTussRel.cd_pro_fat,'9999999999') or t.cd_pro_fat is null) -- <<= aten真真o --OP 19358 parTussRel.cd_pro_fat is null
          -- Oswaldo BH in真cio
		  --SUP-273226 Decode acrestando para que no fluxo de pr真-internacao o cursor retorne o tipo de regime interna真真o
          and (t.tp_atendimento = nvl(parTussRel.tp_atendimento,Decode(parTussRel.cd_tip_acom,NULL,'Z','I')) or t.tp_atendimento is null)
		  -- Oswaldo BH fim
          and (t.cd_gru_pro = nvl(parTussRel.cd_gru_pro,999999) or t.cd_gru_pro is null)
          and (t.tp_gru_pro = nvl(parTussRel.tp_gru_pro,'ZZ') or t.tp_gru_pro is null)
          and (t.cd_especialidade = nvl(parTussRel.cd_especialidade,999) or t.cd_especialidade is null)
          and (t.cd_tip_acom = nvl(parTussRel.cd_tip_acom,999) or t.cd_tip_acom is null)
          and (t.cd_mot_alt = nvl(parTussRel.cd_mot_alt,999) or t.cd_mot_alt is null)
          and (t.tp_servico_hospitalar = nvl(parTussRel.tp_servico_hospitalar,'ZZ') or t.tp_servico_hospitalar is null)
          and (t.cd_servico = nvl(parTussRel.cd_servico,999999) or t.cd_servico is null)
          and (t.cd_ati_med = nvl(parTussRel.cd_ati_med,'999') or t.cd_ati_med is null)
          and (t.cd_conselho = nvl(parTussRel.cd_conselho,999999) or t.cd_conselho is null)
          and (t.tp_sexo = nvl(parTussRel.tp_sexo,'Z') or t.tp_sexo is null)
          and (t.cd_setor = nvl(parTussRel.cd_setor,999) or t.cd_setor is null)
          and (t.cd_motivo_glosa = nvl(parTussRel.cd_motivo_glosa,99999999) or t.cd_motivo_glosa is null)
          and ( t.cd_multi_empresa is NOT NULL OR t.cd_convenio is NOT NULL OR null is NOT NULL OR t.tp_atendimento is NOT NULL OR t.cd_gru_pro is NOT null or t.tp_gru_pro is NOT NULL
                or t.cd_especialidade is NOT null or t.cd_tip_acom is NOT null or t.cd_mot_alt is NOT null or t.tp_servico_hospitalar is NOT null or t.cd_servico is NOT null
                or t.cd_ati_med is NOT null or t.cd_conselho is NOT null or t.tp_sexo is NOT null or t.cd_motivo_glosa is NOT null or t.cd_pro_fat is NOT NULL ) --((pCdTipTuss in (18,19,20,22) or t.cd_tip_tuss in (98,00)) or pCdTipTuss is null)   )
        --
       UNION ALL
        --
        select    t.cd_multi_empresa, t.cd_convenio,t.cd_tip_tuss, t.cd_tuss, ds_tuss, t.dt_inicio_vigencia, t.dt_fim_vigencia
                , t.dt_fim_implantacao, t.ds_edicao_norma_observacoes, t.ds_descricao_detalhada, t.ds_apresentacao, t.nm_fabricante
                , t.cd_ref_fabricante, t.nm_laboratorio, t.ds_sigla
                ,tip.sn_cd_pro_fat,tip.sn_tp_atendimento,tip.sn_cd_gru_pro,tip.sn_tp_gru_pro,tip.sn_cd_especialidade,tip.sn_cd_tip_acom
                ,tip.sn_cd_mot_alt,tip.sn_tp_serv_hospitalar,tip.sn_cd_servico,tip.sn_cd_ati_med,tip.sn_cd_conselho,tip.sn_tp_sexo,tip.sn_cd_motivo_glosa, tip.sn_cd_setor
                ,t.cd_especialidade,t.cd_tip_acom,t.cd_mot_alt,t.cd_servico,t.cd_gru_pro,t.cd_pro_fat,t.cd_ati_med
                ,t.cd_conselho,t.cd_motivo_glosa,t.tp_atendimento,t.tp_sexo,t.tp_gru_pro,t.tp_servico_hospitalar,t.cd_referencia, t.cd_setor
        from dbamv.tuss t, dbamv.tip_tuss tip
      --where pCdTipTuss is null
        where (pCdTipTuss is null or pCdTipTuss in (00,98,18,19,20,22)) -- Performance(1)
          --and ((pCdTipTuss is NOT null and tip.cd_tip_tuss = pCdTipTuss) or pCdTipTuss is null)
          and parTussRel.cd_pro_fat is not null
          and t.cd_pro_fat = parTussRel.cd_pro_fat
          and tip.cd_tip_tuss = t.cd_tip_tuss
          and tip.cd_tip_tuss in (00,98,18,19,20,22)
           --
          and ((t.cd_multi_empresa is not null and t.cd_multi_empresa = parTussRel.cd_multi_empresa) or t.cd_multi_empresa is null)
          and ((t.cd_convenio is not null and t.cd_convenio = parTussRel.cd_convenio) or t.cd_convenio is null)
           --
          and t.dt_inicio_vigencia<=parTussRel.DT_VIGENCIA
          and ((t.dt_fim_vigencia is not null and t.dt_fim_vigencia>=parTussRel.DT_VIGENCIA) or t.dt_fim_vigencia is null)
          --
		  -- Oswaldo BH in真cio
          --SUP-273226 Decode acrestando para que no fluxo de pr真-internacao o cursor retorne o tipo de regime interna真真o
          and (t.tp_atendimento = nvl(parTussRel.tp_atendimento,Decode(parTussRel.cd_tip_acom,NULL,'Z','I')) or t.tp_atendimento is null)
		  -- Oswaldo BH fim
          and (t.cd_gru_pro = nvl(parTussRel.cd_gru_pro,999999) or t.cd_gru_pro is null)
          and (t.tp_gru_pro = nvl(parTussRel.tp_gru_pro,'ZZ') or t.tp_gru_pro is null)
          and (t.cd_especialidade = nvl(parTussRel.cd_especialidade,999) or t.cd_especialidade is null)
          and (t.cd_tip_acom = nvl(parTussRel.cd_tip_acom,999) or t.cd_tip_acom is null)
          and (t.tp_servico_hospitalar = nvl(parTussRel.tp_servico_hospitalar,'ZZ') or t.tp_servico_hospitalar is null)
          and (t.cd_servico = nvl(parTussRel.cd_servico,999999) or t.cd_servico is null)
          and (t.cd_ati_med = nvl(parTussRel.cd_ati_med,'999') or t.cd_ati_med is null)
          and (t.tp_sexo = nvl(parTussRel.tp_sexo,'Z') or t.tp_sexo is null)
          and (t.cd_setor = nvl(parTussRel.cd_setor,999) or t.cd_setor is null)
          and ( t.cd_multi_empresa is NOT NULL OR t.cd_convenio is NOT NULL OR null is NOT NULL OR t.tp_atendimento is NOT NULL OR t.cd_gru_pro is NOT null or t.tp_gru_pro is NOT NULL
                or t.cd_especialidade is NOT null or t.cd_tip_acom is NOT null or t.cd_mot_alt is NOT null or t.tp_servico_hospitalar is NOT null or t.cd_servico is NOT null
                or t.cd_ati_med is NOT null or t.cd_conselho is NOT null or t.tp_sexo is NOT null or t.cd_motivo_glosa is NOT null or t.cd_pro_fat is NOT NULL )
            )
        order by     decode(cd_multi_empresa,parTussRel.cd_multi_empresa,1,2)
				    ,decode(cd_convenio,parTussRel.cd_convenio,1,2)
				    ,decode(sn_cd_pro_fat,'S',decode(parTussRel.cd_pro_fat,null,decode(cd_pro_fat,null,1,2),decode(cd_pro_fat,null,2,1)),null)
                    ,decode(sn_tp_atendimento,'S',decode(parTussRel.tp_atendimento,null,decode(tp_atendimento,null,1,2),decode(tp_atendimento,null,2,1)),null)
                    ,decode(sn_cd_gru_pro,'S',decode(parTussRel.cd_gru_pro,null,decode(cd_gru_pro,null,1,2),decode(cd_gru_pro,null,2,1)),null)
                    ,decode(sn_tp_gru_pro,'S',decode(parTussRel.tp_gru_pro,null,decode(tp_gru_pro,null,1,2),decode(tp_gru_pro,null,2,1)),null)
                    ,decode(sn_cd_especialidade,'S',decode(parTussRel.cd_especialidade,null,decode(cd_especialidade,null,1,2),decode(cd_especialidade,null,2,1)),null)
                    ,decode(sn_cd_tip_acom,'S',decode(parTussRel.cd_tip_acom,null,decode(cd_tip_acom,null,1,2),decode(cd_tip_acom,null,2,1)),null)
                    ,decode(sn_cd_mot_alt,'S',decode(parTussRel.cd_mot_alt,null,decode(cd_mot_alt,null,1,2),decode(cd_mot_alt,null,2,1)),null)
                    ,decode(sn_tp_serv_hospitalar,'S',decode(parTussRel.tp_servico_hospitalar,null,decode(tp_servico_hospitalar,null,1,2),decode(tp_servico_hospitalar,null,2,1)),null)
                    ,decode(sn_cd_servico,'S',decode(parTussRel.cd_servico,null,decode(cd_servico,null,1,2),decode(cd_servico,null,2,1)),null)
                    ,decode(sn_cd_ati_med,'S',decode(parTussRel.cd_ati_med,null,decode(cd_ati_med,null,1,2),decode(cd_ati_med,null,2,1)),null)
                    ,decode(sn_cd_conselho,'S',decode(parTussRel.cd_conselho,null,decode(cd_conselho,null,1,2),decode(cd_conselho,null,2,1)),null)
                    ,decode(sn_tp_sexo,'S',decode(parTussRel.tp_sexo,null,decode(tp_sexo,null,1,2),decode(tp_sexo,null,2,1)),null)
                    ,decode(sn_cd_motivo_glosa,'S',decode(parTussRel.cd_motivo_glosa,null,decode(cd_motivo_glosa,null,1,2),decode(cd_motivo_glosa,null,2,1)),null)
                    ,decode(sn_cd_setor,'S',decode(parTussRel.cd_setor,null,decode(cd_setor,null,1,2),decode(cd_setor,null,2,1)),null)
                    ,dt_inicio_vigencia DESC
                    ,cd_tuss );
  --
  Cursor cTipTuss (pCdTipTuss in dbamv.tip_tuss.cd_tip_tuss%type, pReserva in varchar2) is
    select   tt.cd_tip_tuss,tt.sn_cd_pro_fat,tt.sn_cd_gru_pro,tt.sn_tp_gru_pro,tt.sn_tp_atendimento,tt.sn_tp_serv_hospitalar
            ,tt.sn_cd_especialidade,tt.sn_cd_ati_med,tt.sn_cd_conselho,tt.sn_cd_motivo_glosa,tt.sn_cd_mot_alt,tt.sn_tp_sexo
            ,tt.sn_cd_tip_acom,tt.sn_cd_servico
     from dbamv.tip_tuss tt
     where tt.cd_tip_tuss = pCdTipTuss;
  --
  cursor cDsHda( pnCdCasosAtd in number ) is
    select c.cd_casos_atd
         , substr( c.ds_hda, 1, 499) ds_hda
      from dbamv.casos_atd c
     where c.cd_casos_atd = pnCdCasosAtd
       and c.ds_hda is not null
     order by 1 desc;
  --
  cursor cDiagnosticoAtendimento(pnCdAtendimento in number, pvReserva in varchar2 ) is
    select    diagaten.cd_atendimento
            , diagaten.cd_diagnostico_atendime
            , SubStr(diag.ds_diagnostico,1,499) ds_diagnostico
            , to_char(dh_diagnostico,'yyyy-mm-dd') dh_diagnostico
            , cd_cid
            , cd_histologia
         --, ds_observacao
            ,Decode (diagaten.ds_estadiamento, NULL, 5,                                      --N真O SE APLICA
               Decode ( instr( diagaten.ds_estadiamento, 'IV' ),0,                           --IV
                        Decode ( instr( diagaten.ds_estadiamento, 'III' ),0,                 --III
                                 Decode ( instr( diagaten.ds_estadiamento, 'II' ),0,         --II
                                          Decode ( instr( diagaten.ds_estadiamento, 'I' ),0, --I
                                                   5,1)
                                          ,2)
                                 ,3)
                        ,4)
                ) ds_estadiamento
      from dbamv.diagnostico_atendime diagaten, dbamv.diagnostico diag
     where diagaten.cd_diagnostico = diag.cd_diagnostico (+)
       and Nvl(diag.sn_ativo,'S') = 'S'
       and diagaten.cd_atendimento = pncdatendimento
     --and ROWNUM = 1
       ORDER BY cd_diagnostico_atendime desc;
  --
  --Horario do procedimento do modulo de Gases
  cursor cHoraGases(pcdAtendimento in number, pcdMvto in number, pReserva in varchar2) is
    select to_char(dt_liga,'yyyy-mm-dd')    dt_inicio,
           to_char(hr_liga,'hh24:mi:ss')    hr_inicio,
           to_char(dt_liga,'yyyy-mm-dd')||' '||to_char(hr_liga,'hh24:mi:ss') dh_inicio,

           to_char(dt_desliga,'yyyy-mm-dd') dt_fim,
           to_char(hr_desliga,'hh24:mi:ss') hr_fim,
           to_char(dt_desliga,'yyyy-mm-dd')||' '||to_char(hr_desliga,'hh24:mi:ss') dh_fim
      from dbamv.mvto_gases
     where cd_atendimento = pcdAtendimento
       and cd_mvto_gases  = pcdMvto;
  --
  -- Configura真真o Antiga de Identifica真真o do Contratado (uso customizado UNIMED-BH)
  cursor cContratado(   pnConvenio  in dbamv.atendime.cd_convenio%type,
                        pTpAtend    in dbamv.atendime.tp_atendimento%type,
                        pCdOriAte   in dbamv.atendime.cd_ori_ate%type,
                        pCdServico  in dbamv.atendime.cd_servico%type,
                        pCdCenCus   in dbamv.setor.cd_cen_cus%type,
                        pnSetor     in dbamv.setor.cd_setor%type,
                        pvTpGrupo   in dbamv.gru_pro.tp_gru_pro%type,
                        pncdGrupo   in dbamv.gru_pro.cd_gru_pro%type,
                        pvProced    in dbamv.pro_fat.cd_pro_fat%type,
						            pCdSerDis   in dbamv.atendime.cd_ser_dis%type  ) is

    select cod.cd_convenio_conf_tiss_contr,
           pnConvenio cd_convenio,
           cod.cd_codigo_contratado,
           decode( cod.cd_pro_fat, null,
   --        decode( cod.cd_gru_pro, null,


                      decode( cod.cd_ser_dis, null,
                         decode( cod.cd_servico, null,
                            decode( cod.cd_ori_ate, null,
   --                          decode( cod.tp_atendimento, 'T', 9, 10 ), 8 ), 7 ), 6 ), 2 ), 1 ) ord_ref
                               decode( cod.tp_atendimento, 'T', 10, 9 ), 8 ), 7 ), 6 ), 1 ) ord_ref
   -- from dbamv.convenio_conf_tiss_contratado cod, dbamv.pro_fat pf
      from dbamv.convenio_conf_tiss_contratado cod
     where cod.cd_convenio         = pnConvenio
   --  and pf.cd_pro_fat(+)        = pvProced
       and ( cod.tp_atendimento    = pTpAtend or cod.tp_atendimento = 'T' )
       and ( cod.cd_ori_ate        = pCdOriAte  or cod.cd_ori_ate is null )
       and ( cod.cd_servico        = pCdServico or cod.cd_servico is null )
       and ( cod.cd_ser_dis        = pCdSerDis  or cod.cd_ser_dis is null )
   --  and ( cod.cd_gru_pro        = pf.cd_gru_pro or cod.cd_gru_pro is null )
       and ( cod.cd_pro_fat        = pvProced  or cod.cd_pro_fat  is null )
    union all
    select cod.cd_convenio_conf_tiss_contr,
           pnConvenio cd_convenio,
           cod.cd_codigo_contratado,
           0 ord_ref
      from dbamv.convenio_conf_tiss_contratado cod
     where cod.cd_convenio         = pnConvenio
       and cod.tp_atendimento      = pTpAtend
       and ( cod.cd_ori_ate     is null )
	   and ( cod.cd_ser_dis     is null )
       and ( cod.cd_servico     is null )
       and ( cod.cd_cen_cus     is null )
       and ( cod.cd_setor       is null )
       and ( cod.tp_gru_pro     is null )
       and ( cod.cd_gru_pro     is null )
       and ( cod.cd_pro_fat     is null )
       and not exists( select c.cd_codigo_contratado
                         from dbamv.convenio_conf_tiss_contratado c
                        where c.tp_atendimento = pTpAtend
                          and ( c.cd_ori_ate     is not null
							or  c.cd_ser_dis     is not null
                            or  c.cd_servico     is not null
                            or  c.cd_cen_cus     is not null
                            or  c.cd_setor       is not null
                            or  c.tp_gru_pro     is not null
                            or  c.cd_gru_pro     is not null
                            or  c.cd_pro_fat     is not null  )  )

    union all
    --
    -- (*) performance
    select max(nvl(cod.cd_convenio_conf_tiss_contr,0)) cd_convenio_conf_tiss_contr,
           pnConvenio cd_convenio,
           null cd_codigo_contratado,
           999999 ord_ref
      from dbamv.convenio_conf_tiss_contratado cod
          ,dbamv.convenio cv
     where cv.cd_convenio = pnConvenio
       and cod.cd_convenio(+)      = pnConvenio
    --
    order by 4;
  --
  cursor cTiposGuiaLote (pIdMensagem in number, pReserva in varchar2) is
    select    distinct
              lt.id_pai
            , lt.tp_guia
            ,decode(lt.min_contr_exe,lt.max_contr_exe,lt.max_contr_exe,'v真rios') nm_contratado_exe
      from ( select   gui.id_pai
                    , gui.tp_guia
                    , min(gui.nm_contratado_exe) min_contr_exe
                    , max(gui.nm_contratado_exe) max_contr_exe
               from ( select tg.id_pai,
                             decode (substr(tg.nm_xml,1,6),'guiaRe','RI','guiaHo','HI','guiaSP','SP','guiaCo','CO') tp_guia,
                             nvl(tg.nm_prestador_exe,tg.nm_prestador_contratado) nm_contratado_exe
                        from dbamv.tiss_guia tg
                       where tg.id_pai in (select id from dbamv.tiss_lote where id_pai = pIdMensagem )) gui
              group by gui.id_pai, gui.tp_guia ) lt;
  --
  cursor cTissSolGuia ( pId in dbamv.tiss_sol_guia.id%type, pCdGuia in dbamv.tiss_sol_guia.cd_guia%type, pNrGuia in dbamv.tiss_sol_guia.nr_guia%type, pReserva in varchar2) is
    --
    select id,
           id_pai,
           nm_xml,
           nr_guia,
           nr_guia_operadora,
           nr_guia_principal,
           cd_convenio,
           cd_paciente,
           nr_carteira,
           nr_cns,
           sn_atendimento_rn,
           nm_paciente,
           NR_REGISTRO_OPERADORA_ANS,
           CD_OPERADORA,
           CD_CPF,
           CD_CGC,
           NM_PRESTADOR_CONTRATADO,
           CD_GUIA,
           TP_IDENT_BENEFICIARIO,
           NR_ID_BENEFICIARIO,
           DS_TEMPLATE_IDENT_BENEFICIARIO,
		   CD_ATENDIMENTO -- Oswaldo BH
      from dbamv.tiss_sol_guia
     where ((pId is not null and id = pId)
         or (pCdGuia is not null and CD_GUIA = pCdGuia))
	   and nr_guia = nvl(pNrGuia, nr_guia);
  --
  cursor cCidsSecundarios( pnAtend in number ) is
    select tp_cid,
           substr( cd_cid, 1, 5 ) cd_cid,
           substr(ds_cid,1,70)    ds_cid
      from ( select 'CID-10' tp_cid,
                    cid_ate.cd_cid,
                    cid.ds_cid
               from dbamv.cid_ate,
                    dbamv.cid
              where cid.cd_cid = cid_ate.cd_cid
                and cid_ate.cd_atendimento = pnAtend )
     where rownum <= 3;
  --
  Cursor cGuia (pCdGuia in dbamv.guia.cd_guia%type, pReserva in varchar2) is
    --
    select   g.cd_guia
            ,g.nr_guia
            ,g.cd_senha
            ,g.cd_paciente
            ,g.cd_convenio
            ,g.ds_justificativa
            ,g.ds_observacao
            ,g.nr_dias_solicitados
            ,g.dt_solicitacao
            ,g.cd_tip_acom
            ,g.cd_atendimento
            ,g.cd_res_lei
            ,g.cd_aviso_cirurgia
            ,(select g1.nr_guia from dbamv.guia g1
               where g1.cd_atendimento = g.cd_atendimento
                 AND g1.tp_guia = 'I') nr_guia_principal
        from dbamv.guia g
        where g.cd_guia = pCdGuia;
  --
  Cursor cProdutoOPME (pCdProFat in dbamv.pro_fat.cd_pro_fat%type, pReserva in varchar2) is
    --
    SELECT SubStr( ds_especificacao, 1,499 ) ds_especificacao
      FROM ( SELECT pr.ds_especificacao, pr.cd_pro_fat, pr.cd_produto
               FROM dbamv.produto pr
              WHERE pr.ds_especificacao IS NOT NULL
                AND pr.cd_pro_fat = pCdProFat
              ORDER BY 3 DESC ) --mais recente
     WHERE ROWNUM = 1;
  --
  Cursor cItGuia (pCdGuia in dbamv.guia.cd_guia%type, pCdPreMed in dbamv.pre_med.cd_pre_med%type, pReserva in varchar2) is
    --
    select   it.cd_it_guia cd_ordem
            ,it.cd_it_guia
            ,null cd_itpre_med
            ,it.cd_pro_fat
            ,it.qt_autorizado
            ,it_val.vl_unitario
            ,it_val.cd_rms
            ,null ds_especificacao
            ,it_val.cd_fornecedor
            ,null qt_dose_padrao
            ,null ds_for_apl
            , to_char(null) dh_inicial
            , it_val.nr_registro_operadora_ans
        from dbamv.it_guia it
            ,(select cd_it_guia, vl_unitario, cd_rms, cd_fornecedor, nr_registro_operadora_ans
                from dbamv.val_opme_it_guia it_val
                where cd_guia = pCdGuia
                --and sn_fornecedor_autorizado = 'S'
                  ) it_val
        where it.cd_guia = pCdGuia
          and it_val.cd_it_guia(+) = it.cd_it_guia
		  AND Nvl(pReserva,'X') <> 'SOLICITACAO'
    --
    --
    union all
    --
    select   it.cd_itpre_med cd_ordem
            ,null cd_it_guia
            ,it.cd_itpre_med
            ,produto.cd_pro_fat
            ,it.qt_itpre_med qt_autorizado
            ,null vl_unitario
            ,null cd_rms
            ,null ds_especificacao
            ,null cd_fornecedor
            ,/*it.qt_dose_padrao*/ null qt_dose_padrao
            ,for_apl.ds_for_apl
            , to_char(it.dh_inicial,'yyyy-mm-dd') dh_inicial
            , '' nr_registro_operadora_ans
        from  dbamv.itpre_med it
            , dbamv.produto
            , dbamv.for_apl
            , dbamv.tip_presc tp
       where it.cd_pre_med = pCdPreMed
         AND tp.cd_tip_presc = it.cd_tip_presc
         and tp.cd_produto = produto.cd_produto
         and it.cd_for_apl = for_apl.cd_for_apl(+)
         and produto.cd_pro_fat is not null
    --
    --Oswaldo FATURCONV-18977 inicio
    union all
    select null cd_ordem
          ,it.id_tmp cd_it_guia
          ,null cd_itpre_med
          ,it.cd_pro_fat
          ,Decode(tsg.tp_atendimento, 'O', it.qt_solicitada, null) qt_autorizado
          ,null vl_unitario
          ,null cd_rms
          ,null ds_especificacao
          ,Decode(tsg.tp_atendimento, 'O', it.cd_fornecedor, null) cd_fornecedor
          ,null qt_dose_padrao
          ,null ds_for_apl
          , null dh_inicial
          , '' nr_registro_operadora_ans
      from dbamv.TMPMV_TISS_ITSOL_GUIA it
          ,dbamv.TMPMV_TISS_SOL_GUIA tsg
     where tsg.id_tmp = it.id_tmp
       AND pReserva = 'SOLICITACAO'
       and it.id_tmp = pCdGuia
    --Oswaldo FATURCONV-18977 fim
    --
    order by cd_ordem;
    --
  Cursor cMensagem (pId dbamv.tiss_mensagem.id%type, pTpTransacao dbamv.tiss_mensagem.tp_transacao%type,
                    pNrDocumento dbamv.tiss_mensagem.nr_documento%type, pReserva in varchar2) is
    --
    select tm.id, tm.tp_transacao, tm.dt_transacao, tm.hr_transacao, tm.cd_seq_transacao, tm.cd_origem, tm.cd_destino, tm.nr_registro_ans_origem, tm.nr_registro_ans_destino, tm.cd_versao,
           tm.dt_gerou_xml, tm.dt_retorno, tm.nr_protocolo_retorno, tm.cd_status_protocolo, tm.ds_msg_erro, tm.nr_lote, tm.nm_xml, tm.nr_documento, tm.cd_convenio, tm.tp_mensagem_tiss,
           tm.cd_motivo_glosa, tm.ds_motivo_glosa, tm.id_mensagem_envio, tm.cd_cgc_origem, tm.cd_cpf_origem, tm.cd_cgc_destino, tm.cd_cpf_destino, tm.ds_motivo_cancelamento, tm.cd_usuario_cancelou,
           tm.dt_cancelamento, tm.dt_enviou_xml, tm.cd_status, tm.id_cancelamento, tm.ds_hash, tm.id_mensagem_origem, tm.sn_retorno, tm.nm_aplicativo, tm.ds_versao_aplicativo, tm.nm_fabricante_aplicativo,
           tm.cd_operadora_prestador_origem, tm.cd_operadora_prestador_destino
      from dbamv.tiss_mensagem tm
     where (pId is not null and tm.id = pId)
        or (pId is null and tm.tp_transacao = pTpTransacao and tm.nr_documento = pNrDocumento);
  --
  cursor cTipoSetor( nCdAprConta in number, nCdSetor in Number ) is
    select ts.cd_setor_meio_mag,
           ts.cd_apr_conta_meio_mag cd_apr,
           ts.cd_setor
      from dbamv.tip_setor_meio_mag ts
     where ts.cd_apr_conta_meio_mag = nCdAprConta
       and ts.cd_setor = nCdSetor;
	--


  Cursor cTussReverso ( pCdTuss in dbamv.tuss.cd_tuss%type,
                        pCdConvenio in dbamv.convenio.cd_convenio%type,
                        pCdMultiEmpresa in dbamv.multi_empresas.cd_multi_empresa%type,
                        pTpAtendimento in dbamv.atendime.tp_atendimento%type,
                        pCdSetor in dbamv.setor.cd_setor%type,
                        pData in dbamv.tuss.dt_fim_vigencia%type,
                        pCdTipTuss in dbamv.tip_tuss.cd_tip_tuss%type,
                        pReserva in varchar2) is
    select tuss.cd_Pro_fat
          ,tuss.cd_motivo_glosa
	   from (select tuss.cd_pro_fat
	               ,tuss.cd_motivo_glosa
    		  from dbamv.tuss tuss
    		  where ((pCdTipTuss is not null and cd_tip_tuss = pCdTipTuss) or cd_tip_tuss in (18,19,20,22,98,00))
     		    and cd_tuss = pCdTuss
                and ((cd_multi_empresa is not null and cd_multi_empresa = pCdMultiEmpresa) or cd_multi_empresa is null)
     		    and ((cd_convenio is not null and cd_convenio = pCdConvenio) or cd_convenio is null)
     		    and ((tp_atendimento is not null and tp_atendimento = pTpAtendimento) or tp_atendimento is null)
     		    and ((cd_setor is not null and cd_setor = pCdSetor) or cd_setor is null)
     		    and ((pData is not null and nvl(dt_fim_vigencia,pData)>=pData) or pData is null)
   			  order by decode(cd_multi_empresa,38,1,2),decode(cd_convenio,null,2,1),decode(cd_convenio,null,2,1)) TUSS
    where rownum = 1;
  --
  cursor cRemessaGlosa (nCdRemessaGlosa dbamv.remessa_glosa.cd_remessa_glosa%type) is
	select	 rg.cd_remessa_glosa
	        ,rg.cd_remessa
	        ,rg.cd_convenio
	        ,rg.cd_multi_empresa
	   		  ,rg.vl_total_remessa
          ,tm.id id_mensagem_envio
          ,Sum(glr.vl_reapresentado) vl_reapresentado_lote
		--from dbamv.remessa_glosa rg, dbamv.glosas glr, dbamv.itfat_nota_fiscal itf, dbamv.tiss_mensagem tm, dbamv.tiss_lote tl
		from dbamv.remessa_glosa rg, dbamv.glosas glr, dbamv.itfat_nota_fiscal itf, dbamv.tiss_mensagem tm, dbamv.tiss_lote tl, dbamv.remessa_fatura rm --FATURCONV-7309
		where rg.cd_remessa_glosa = nCdRemessaGlosa
	  	  and rg.vl_total_remessa>0
        AND glr.cd_remessa_glosa = rg.cd_remessa_glosa
		and rm.cd_remessa = rg.cd_remessa --FATURCONV-7309
        AND itf.cd_itfat_nf = glr.cd_itfat_nf
        AND tm.cd_convenio = rg.cd_convenio
        AND tm.tp_transacao = 'ENVIO_LOTE_GUIAS'
      --AND tm.nr_documento = To_Char(rg.cd_remessa)
		AND tm.nr_documento = To_Char(nvl(rm.cd_remessa_pai,rm.cd_remessa))--FATURCONV-7309
        AND tl.id_pai = tm.id
		AND exists (SELECT 'X' FROM dbamv.tiss_guia tg, dbamv.tiss_itguia tig WHERE tg.id_pai = tl.id AND tig.id_pai = tg.id AND tig.id = itf.id_it_envio
                              UNION
                            SELECT 'X' FROM dbamv.tiss_guia tg, dbamv.tiss_itguia_out tio WHERE tg.id_pai = tl.id AND tio.id_pai = tg.id AND tio.id = itf.id_it_envio
                              UNION
                            SELECT 'X' FROM dbamv.tiss_guia tg WHERE tg.nm_xml = 'guiaConsulta' AND tg.id_pai = tl.id AND tg.cd_reg_amb = itf.cd_reg_amb)

  --
  GROUP BY rg.cd_remessa_glosa
	        ,rg.cd_remessa
	        ,rg.cd_convenio
	        ,rg.cd_multi_empresa
	   		  ,rg.vl_total_remessa
          ,tm.id
  --
  ORDER BY tm.id;
  --
  cursor cRemessaGlosaCtas (nCdRemessaGlosa dbamv.remessa_glosa.cd_remessa_glosa%type, pIdMensagemEnvio dbamv.tiss_mensagem.id%type) IS

    SELECT ctas.cd_atendimento, ctas.cd_reg_fat, ctas.cd_reg_amb, ctas.id_guia_envio
          ,(SELECT gl.cd_glosas FROM dbamv.glosas gl, dbamv.motivo_glosa mg
              WHERE gl.cd_remessa_glosa = nCdRemessaGlosa
                AND ((CTAS.cd_reg_fat IS NOT NULL AND CTAS.cd_reg_fat = gl.cd_reg_fat) OR (CTAS.cd_reg_amb IS NOT NULL AND CTAS.cd_reg_amb = gl.cd_reg_amb))
                AND mg.cd_motivo_glosa = gl.cd_motivo_glosa AND mg.sn_glosa_total = 'S' AND nvl(gl.vl_reapresentado,0) <> 0 AND ROWNUM = 1) CD_GLOSA_TOTAL
      FROM (
            select glr.cd_atendimento, glr.cd_reg_fat, glr.cd_reg_amb
                  ,Nvl(Nvl(tit.id_pai,tio.id_pai),tc.id) id_guia_envio
            from dbamv.remessa_glosa rg, dbamv.glosas glr, dbamv.itfat_nota_fiscal itf, dbamv.tiss_mensagem tm, dbamv.tiss_lote tl
                  ,dbamv.tiss_itguia tit, dbamv.tiss_itguia_out tio
                  , (SELECT tgc.cd_atendimento, tgc.id FROM dbamv.tiss_guia tgc, dbamv.tiss_lote tlc WHERE tlc.id_pai = pIdMensagemEnvio AND tgc.id_pai = tlc.id AND tgc.nm_xml = 'guiaConsulta') tc
            where rg.cd_remessa_glosa = nCdRemessaGlosa
                and rg.vl_total_remessa>0
                AND glr.cd_remessa_glosa = rg.cd_remessa_glosa
                AND Nvl(glr.vl_reapresentado,0)>0
                AND itf.cd_itfat_nf = glr.cd_itfat_nf
                AND tm.cd_convenio = rg.cd_convenio
                AND tm.nr_documento = To_Char(rg.cd_remessa)
                and tl.id_pai = pIdMensagemEnvio
                AND tl.id_pai = tm.id
                AND tit.id(+) = itf.id_it_envio
                AND tio.id(+) = itf.id_it_envio
                AND tc.cd_atendimento(+) = itf.cd_atendimento
            --
            group by glr.cd_atendimento,glr.cd_reg_fat,glr.cd_reg_amb ,Nvl(Nvl(tit.id_pai,tio.id_pai),tc.id)
            order by id_guia_envio
            ) CTAS
     WHERE ctas.id_guia_envio IS NOT NULL;
  --
  cursor cTissGuiaOrigem (nId dbamv.tiss_guia.id%type) is
    select   tg.ID
            ,tg.nr_guia
            ,tg.nr_guia_operadora
            ,tg.cd_senha
            ,tg.nr_guia_sol
            ,tg.cd_convenio
            ,tg.cd_atendimento
            ,nvl(tg.cd_reg_amb,tg.cd_reg_fat) cd_conta
            ,tg.dt_final_faturamento
            ,tg.cd_guia
        from dbamv.tiss_guia tg
        where tg.id = nId;
  --
  cursor cTissItGuiaOrigem (nIdIt dbamv.tiss_itguia.id%type) is
    select   tig.id
            ,tig.dt_realizado
            ,tig.TP_TAB_FAT
            ,tig.CD_PROCEDIMENTO
            ,tig.DS_PROCEDIMENTO
            ,tie.CD_ATI_MED
            ,tig.vl_total
            ,tig.ds_justificativa_revisao
			,tig.sq_item
        from dbamv.tiss_itguia tig, dbamv.tiss_itguia_equ tie
        where tig.id = nIdIt
          and tie.id_pai(+) = tig.id
     union all
    select   tio.id
            ,tio.dt_realizado
            ,tio.TP_TAB_FAT
            ,tio.CD_PROCEDIMENTO
            ,tio.DS_PROCEDIMENTO
            ,null CD_ATI_MED
            ,tio.vl_total
            ,tio.ds_justificativa_revisao
			,tio.sq_item
        from dbamv.tiss_itguia_out tio
        where tio.id = nIdIt
        order by 1;
  --
  cursor cGlosas (pCdRemessaGlosa dbamv.remessa_glosa.cd_remessa_glosa%type, pIdGuiaEnvio dbamv.tiss_guia.id%TYPE, pCdGlosas dbamv.glosas.cd_glosas%type) is
    select   Min(gl.cd_glosas)    cd_glosas
            ,Min(gl.cd_itfat_nf)  cd_itfat_nf
            ,itf.id_it_envio
            ,Sum(gl.vl_reapresentado) vl_reapresentado
            ,Min(gl.cd_motivo_glosa)  cd_motivo_glosa
            ,Min(gl.ds_observacao_recurso) ds_observacao_recurso
            ,Min(gl.cd_pro_fat) cd_pro_fat
            ,itf.cd_atendimento
            ,itf.cd_reg_fat
            ,itf.cd_reg_amb
            ,Min(itf.cd_lancamento_fat) cd_lancamento_fat
            ,Min(itf.cd_lancamento_amb) cd_lancamento_amb
            ,Min(itf.cd_ati_med) cd_ati_med
            ,Min(gl.ds_complemento_justifica) ds_complemento_justifica
            ,Min(j.ds_justifica_glosa) ds_justifica_glosa
            ,Min(gl.cd_justifica_glosa) cd_justifica_glosa
        from dbamv.glosas gl, dbamv.itfat_nota_fiscal itf, dbamv.justifica_glosa j
        where gl.cd_remessa_glosa = pCdRemessaGlosa
          AND gl.cd_glosas = Nvl(pCdGlosas,gl.cd_glosas) -- opcional
          and itf.cd_itfat_nf(+) = gl.cd_itfat_nf
          and j.cd_justifica_glosa(+) = gl.cd_justifica_glosa
          and Nvl(gl.vl_reapresentado,0)>0
		  and (( itf.id_it_envio IN (SELECT tio.id FROM dbamv.tiss_itguia_out tio, dbamv.tiss_guia tg WHERE tg.id = pIdGuiaEnvio AND tio.id = itf.id_it_envio AND tio.id_pai = tg.id
                 					  UNION
                   					 SELECT tig.id FROM dbamv.tiss_itguia tig, dbamv.tiss_guia tg WHERE tg.id = pIdGuiaEnvio AND tig.id = itf.id_it_envio AND tig.id_pai = tg.id))
      			 OR   EXISTS  (SELECT 'X' FROM dbamv.tiss_guia tg WHERE tg.id = pIdGuiaEnvio AND tg.cd_reg_amb = itf.cd_reg_amb AND tg.nm_xml = 'guiaConsulta') )
      --
      GROUP BY  itf.id_it_envio,itf.cd_atendimento,itf.cd_reg_fat,itf.cd_reg_amb
      --
      ORDER BY itf.id_it_envio;
  --
  -- Retorna pedidos (laborat真rio e imagem) por ordem da Data.
  Cursor cPedidoPrincipal (pnCdAtendimento in dbamv.atendime.cd_atendimento%type, pvReserva in varchar2) is
    --
    select   cd_atendimento
            ,cd_pedido
            ,dt_pedido
            ,hr_pedido
            ,cd_prest_pedido
            ,cd_pres_ext
            ,tp_pedido
            --
        from (select pl.cd_atendimento  cd_atendimento
                    ,pl.cd_ped_lab      cd_pedido
                    ,'Lab'              tp_pedido
                    ,pl.dt_pedido       dt_pedido
                    ,pl.hr_ped_lab      hr_pedido
                    ,pl.cd_prestador    cd_prest_pedido
                    ,ple.cd_pres_ext    cd_pres_ext
                from dbamv.ped_lab pl
                    ,dbamv.ped_lab_prestador_externo ple
                where ((pvReserva IS NULL AND pl.cd_atendimento = pnCdAtendimento)
                      OR (pvReserva IS NOT NULL AND pl.cd_ped_lab = pvReserva AND pl.cd_atendimento = pnCdAtendimento))
                  and ple.cd_ped_lab(+) = pl.cd_ped_lab
                --
                union all
                --
              select pr.cd_atendimento  cd_atendimento
                    ,pr.cd_ped_rx       cd_pedido
                    ,'Rx'               tp_pedido
                    ,pr.dt_pedido       dt_pedido
                    ,pr.hr_pedido       hr_pedido
                    ,pr.cd_prestador    cd_prest_pedido
                    ,pre.cd_pres_ext    cd_pres_ext
                from dbamv.ped_rx pr
                    ,dbamv.ped_rx_prestador_externo pre
                where ((pvReserva IS NULL AND pr.cd_atendimento = pnCdAtendimento)
                      OR (pvReserva IS NOT NULL AND pr.cd_ped_rx = pvReserva AND pr.cd_atendimento = pnCdAtendimento))
                  and pre.cd_ped_rx(+)  = pr.cd_ped_rx )
        --
        Order by dt_pedido, hr_pedido;
  --
  cursor cPrestadorExterno(pcdprestador in number, pReserva in varchar2) is
      select pr.nr_cpf_cgc                                                                        cgc_cpf_prestador,
             decode( pr.nr_cpf_cgc, null, 'CONSELHO', 'CPF' )                                     tipo_cpf_conselho,
             pr.nm_pres_ext                                                                       nome_prestador,
             pr.nr_conselho                                                                       numero_conselho,
             conselho.tp_conselho                                                                 tipo_conselho,
             conselho.cd_conselho                                                                 cd_conselho,
             Decode (nvl( conselho.cd_uf,
                          substr( conselho.ds_conselho,
                                  instr(replace(replace(conselho.ds_conselho,'/','#'),'-','#'),'#')+1, 2 ))
                    ,'AC', 12, 'AL', 27, 'AP', 16, 'AM', 13, 'BA', 29, 'CE', 23, 'DF', 53, 'ES', 32, 'GO', 52,
                     'MA', 21, 'MT', 51, 'MS', 50, 'MG', 31, 'PR', 41, 'PB', 25, 'PA', 15, 'PE', 26, 'PI', 22,
                     'RN', 24, 'RS', 43, 'RJ', 33, 'RO', 11, 'RR', 14, 'SC', 42, 'SE', 28, 'SP', 35, 'TO', 17, 98) uf_prestador,
             pr.nr_cnes                                                                           codigo_cnes,
             pr.cd_cbos                                                                           codigo_cbos,
             pr.nm_hospital                                                                       nm_hospital,
             pr.nr_cgc_hospital                                                                   nr_cgc_hospital,
             pr.cd_pres_ext                                                                       cd_pres_ext,
             pr.cd_especialid                                                                     cd_especialid
        from dbamv.prestador_externo pr,
             dbamv.conselho
       where pr.cd_pres_ext = pcdprestador
         and conselho.cd_conselho(+) = pr.cd_conselho;
  --
  cursor cSolicAvulsa (pCdPaciente number --dbamv.paciente.cd_paciente%type
                       ,pTpGuia varchar2
                       ,pDtSolic date
                       ,pCdAtendimento dbamv.atendime.cd_atendimento%type
                       ,pReserva in varchar2) is
    --
    select id,
           nr_guia,
           nr_guia_operadora,
           nr_guia_principal,
           cd_convenio,
           cd_paciente,
           nr_carteira,
           nm_paciente,
           NR_REGISTRO_OPERADORA_ANS
      from dbamv.tiss_sol_guia
     where cd_atendimento is null
       and cd_paciente = pCdPaciente
       and tp_atendimento = pTpGuia
       and trunc(dh_solicitado) = pDtSolic
    --
    order by id desc;
  --
   -- Rafael Pereira Ramos - FATURCONV-6178 - PROD-4209 - ajustado no FATURCONV-14777
  cursor cPrimeiraGuiaAut(pCdPaciente number, pCdAtendimento number) is
	Select guia.nr_guia nr_guia,
         guia.cd_guia
    From dbamv.guia
         ,dbamv.atendime
     Where atendime.cd_atendimento = guia.cd_atendimento
	   And atendime.cd_atendimento = pCdAtendimento
	   And atendime.cd_paciente = pCdPaciente
	   And guia.tp_situacao = 'A'
  ORDER BY 2;
  cursor cPreInt (pCdResLei dbamv.res_lei.cd_res_lei%type) is
    select   cd_res_lei
            ,cd_prestador
            ,cd_cid
            ,cd_con_pla
            ,cd_atendimento
            ,cd_paciente
            ,to_char(dt_prev_internacao,'yyyy-mm-dd') dt_prev_internacao
            ,nr_carteira
			-- Oswaldo BH in真cio
			--SUP-273226 Coluna acrescentada para que no fluxo de pr真-internacao o campo cd_tip_acom esteja preenchido no cursor cTuss
            ,cd_tip_acom
			,cd_ori_ate
            ,cd_servico
			-- Oswaldo BH fim
			,cd_tipo_internacao
        from dbamv.res_lei
        where cd_res_lei = pCdResLei;
  --
  cursor cAviCir (pCdAviCir dbamv.aviso_cirurgia.cd_aviso_cirurgia%type) is
    select  ac.cd_aviso_cirurgia,
            ac.cd_paciente,
            ac.cd_atendimento,
            ac.cd_cid,
            ac.sn_ambulatorial,
            ac.tp_cirurgias,
            pa.cd_prestador
        from dbamv.aviso_cirurgia ac,
            (select cd_aviso_cirurgia, cd_cirurgia_aviso
                from dbamv.cirurgia_aviso
                where cd_aviso_cirurgia = pCdAviCir
                  and sn_principal = 'S') ca,
            (select cd_cirurgia_aviso, cd_prestador
                from dbamv.prestador_aviso
                where cd_aviso_cirurgia = pCdAviCir
                  and sn_principal = 'S') pa
        where ac.cd_aviso_cirurgia = pCdAviCir
          and ca.cd_aviso_cirurgia(+) = ac.cd_aviso_cirurgia
          and pa.cd_cirurgia_aviso(+) = ca.cd_cirurgia_aviso;
  --
  cursor cFornecedor (pCdFornecedor dbamv.fornecedor.cd_fornecedor%type) is
    select   fn.cd_fornecedor
            ,fn.cd_afe
            ,fn.nm_fornecedor
        from dbamv.fornecedor fn
        where fn.cd_fornecedor = pCdFornecedor;
  --
  cursor cProdutoFornecedor(pCdProFat dbamv.pro_fat.cd_pro_fat%type, pCdFornecedor dbamv.fornecedor.cd_fornecedor%type) is
    select   pf.cd_fornecedor
            ,pf.cd_produto
            ,pf.cd_prod_forn
        from dbamv.produto_fornecedor pf
            ,dbamv.produto pr
        where pf.cd_fornecedor  = pCdFornecedor
          and pr.cd_produto     = pf.cd_produto
          and pr.cd_pro_fat     = pCdProFat;
  --
  cursor cProduto (pCdProduto  dbamv.produto.cd_produto%type, pCdLaborator dbamv.laborator.cd_laborator%type) is
    select   pd.cd_produto
            ,lp.cd_laborator
            ,lp.cd_registro
        from dbamv.produto pd, dbamv.lab_pro lp
        where pd.cd_produto = pCdProduto
          and lp.cd_produto = pd.cd_produto
          and (pCdlaborator is null or (pCdLaborator is not null and lp.cd_laborator = pCdLaborator));
  --
  cursor cTipoProc( pcdApres in number, nProfat in varchar2 ) is
    select tp_pro_fat_meio_mag.tp_gru_pro,
           tp_pro_fat_meio_mag.tp_unidade,
           tp_pro_fat_meio_mag.cd_apr_conta_meio_mag cd_apr,
           tp_pro_fat_meio_mag.cd_pro_fat,
           tp_pro_fat_meio_mag.cd_pro_fat_vinculado
      from dbamv.tp_pro_fat_meio_mag
     where  tp_pro_fat_meio_mag.cd_apr_conta_meio_mag = pcdApres
       and  tp_pro_fat_meio_mag.cd_pro_fat = nProfat;
  --
  -- verificar o percentual p/ hor真rio especial
  cursor cIndiceHE( pnCdRegra  in dbamv.regra.cd_regra%type,
                    pnGruPro   in dbamv.gru_pro.cd_gru_pro%type) is

    select  irg.cd_regra,
            irg.cd_gru_pro,
            he.vl_percentual
      from dbamv.horario_especial he,
           dbamv.itregra irg
    where irg.cd_regra      = pnCdRegra
      and irg.cd_gru_pro    = pnGruPro
      and irg.cd_horario    is not null
      and he.cd_horario     = irg.cd_horario;
  --
  cursor cAcomod(pnCdRegra  in dbamv.regra.cd_regra%type,
                 pnTpAcom   in dbamv.tip_acom.cd_tip_acom%type,
                 pvTpGruPro in dbamv.gru_pro.tp_gru_pro%type,
                 pnGruPro   in dbamv.gru_pro.cd_gru_pro%type,
                 pvProFat   in dbamv.pro_fat.cd_pro_fat%type) is

    select  ia.cd_regra,
            ia.cd_tip_acom,
            pvTpGruPro tp_gru_pro,
            pnGruPro cd_gru_pro,
            pvProFat cd_pro_fat,
            nvl(ipf.vl_percentual,nvl(igp.vl_percentual,
                decode(pvTpGruPro,'SP',ia.vl_percentual_pago,'SD',ia.vl_percentual_sd,'SH',ia.vl_percentual_sh)))  vl_percentual
      from dbamv.indice_acomodacao ia,
           dbamv.indice_pro_fat ipf,
           dbamv.indice_pro_fat igp
    where ia.cd_regra = pnCdRegra
      and ia.cd_tip_acom = pnTpAcom
      and ipf.cd_regra(+)   = ia.cd_regra
      and ipf.cd_pro_fat(+) = pvProFat
      and igp.cd_regra(+)   = ia.cd_regra
      and igp.cd_gru_pro(+) = pnGruPro
      and nvl(igp.cd_tip_acom(+),pnTpAcom) = pnTpAcom
      and nvl(ipf.cd_tip_acom(+),pnTpAcom) = pnTpAcom;
  --
  --PROD-2892 - cadastro das atividades medicas
  cursor cAtiMed( pvCdAtiMed  in dbamv.ati_med.cd_ati_med%type,
                  pvReserva   in VARCHAR2 ) is
    SELECT CD_ATI_MED, VL_PERCENTUAL_PAGO, TP_FUNCAO
      FROM DBAMV.ATI_MED
     WHERE CD_ATI_MED = pvCdAtiMed;
  --
  cursor cTissSolGuiaTpOrigem(pCdAtend in number, pCdPreMed in number, pTpOrig in varchar2) is
   select tsg.id
         ,tsg.id_pai
     from dbamv.tiss_sol_guia tsg
     where tsg.cd_atendimento = pCdAtend
       and tsg.cd_origem_sol  = pCdPreMed
       and tsg.tp_origem_sol  = pTpOrig;
  --
  cursor cRegraGasesItem( pnCdConvenio in number, pnCdConPla in number, pvCdProFat in varchar2, pvReserva in varchar2) is
    Select  rg.cd_convenio,
            rg.cd_con_pla,
            rg.cd_pro_fat,
            rg.tp_unidade
      from dbamv.regra_gases rg
     Where rg.cd_pro_fat = pvCdProFat
       and ( rg.cd_convenio = pnCdConvenio
             or rg.cd_convenio is null )
       and ( (rg.cd_con_pla = pnCdConPla and rg.Cd_Convenio = pnCdConvenio)
             or rg.cd_con_pla is null )
     --and nvl(rg.cd_multi_empresa,dbamv.pkg_mv2000.le_empresa) = dbamv.pkg_mv2000.le_empresa
       and nvl(rg.cd_multi_empresa, nEmpresaLogada) = nEmpresaLogada  --adhospLeEmpresa
     Order By rg.Cd_Con_Pla, rg.Cd_Convenio, rg.Cd_Regra_Gases;
  --
  cursor cPreMed (pCdPreMed in dbamv.pre_med.cd_pre_med%type, pvReserva in varchar2) is
    select pre_med.cd_pre_med
         , pre_med.hr_pre_med
         , pre_med.cd_prestador
      from dbamv.pre_med
     where pre_med.cd_pre_med   = pCdPreMed;
  --
  cursor cCid (pCdCid in dbamv.cid.cd_cid%type, pvReserva in varchar2) is
    select cid.cd_cid
          ,cid.ds_cid
          ,cid.ds_cid_aux
        from dbamv.cid
        where cd_cid = pCdCid;
  --
  -- modificado por motivo de atualiza真真o de estrutura do pagu/pep (gisele/leonardo)
  cursor cTratamento (pCdPreMed in dbamv.pre_med.cd_pre_med%type, pvReserva in varchar2) is
    select tr.qt_ciclo
         , to_char(tr.dh_inicio,'yyyy-mm-dd') dh_inicio
         , pr.nr_ciclo       nr_ciclo_atual
         , tr.tp_quimioterapia
         , tr.tp_finalidade
         , tr.tp_ecog
         , p.nr_tot_dia
      from dbamv.tratamento tr
         , dbamv.pre_med pr
         , dbamv.protocolo p
     where pr.cd_pre_med     = pCdPreMed
       and pr.cd_tratamento  = tr.cd_tratamento
       and tr.cd_protocolo = p.cd_protocolo;

  CURSOR cTmpSol(pId IN DBAMV.TMPMV_TISS_SOL_GUIA.id_tmp%TYPE) IS
    select id_tmp, id_sol, cd_multi_empresa, dt_solicitacao, cd_guia, tp_atendimento_tiss, cd_paciente, cd_atendimento,
           tp_atendimento, nr_carteira, dt_validade_carteira, cd_convenio, cd_con_pla, nr_guia_prestador, cd_cid_principal, cd_prestador,
           cd_cbos, cd_especialid, tp_transacao, cd_sistema_origem, nr_codigo_barras,
           (SELECT Max(cd_pres_ext)cd_pres_ext FROM dbamv.prestador_externo WHERE cd_conselho = tmp.cd_conselho AND nr_conselho = tmp.nr_conselho) cd_pres_ext,
           tp_ident_beneficiario --OSWALDO
      FROM DBAMV.TMPMV_TISS_SOL_GUIA tmp
      WHERE id_tmp = pId;

  CURSOR cGuiaAtend (pCdAtendimento IN dbamv.atendime.cd_atendimento%TYPE, pTpGuia IN dbamv.guia.tp_guia%TYPE, pReserva VARCHAR2) IS
    SELECT cd_guia
      FROM dbamv.guia
      WHERE cd_atendimento = pCdAtendimento
        AND tp_guia = pTpGuia
        AND tp_situacao NOT IN ('C','N')
      ORDER BY cd_guia DESC;

  CURSOR cDiasSolicitadosTmp(pIdTmp IN dbamv.TMPMV_TISS_SOL_GUIA.id_tmp%TYPE) IS
    select sum( tmp.qt_solicitada ) qt_diarias
     from dbamv.TMPMV_TISS_ITSOL_GUIA tmp
     where tmp.id_tmp = pIdTmp
       and exists ( select 'X' from dbamv.pro_fat pf where pf.cd_pro_fat = tmp.cd_pro_fat AND pf.tp_serv_hospitalar in ('DI','DU') );

  --Oswaldo FATURCONV-20760 - inicio
  CURSOR cProgramasHomecare (pcdProgramasHomecare in number) IS
    SELECT CD_PROGRAMAS_HOMECARE, TP_GUIA
      FROM DBAMV.PROGRAMAS_HOMECARE
     WHERE CD_PROGRAMAS_HOMECARE = pcdProgramasHomecare;
  --Oswaldo FATURCONV-20760 - fim

--FATURCONV-7309 - sta joana - inicio
  CURSOR cSnFatDistribuido IS
    SELECT SN_ATIVA_FAT_DISTRIBUIDO
      FROM dbamv.config_ffcv
     WHERE cd_multi_empresa = nEmpresaLogada;

  vcSnFatDistribuido        VARCHAR2(2):=null;
--FATURCONV-7309 - sta joana - fim

  vcAtendimento             cAtendimento%rowtype;
  vcAtendimentoAUX          cAtendimentoAUX%rowtype;
  vcAtendimentoMag          cAtendimentoMag%rowtype;
  vcConta                   cConta%rowtype;
  vcPaciente                cPaciente%rowtype;
  vcConv                    cConv%rowtype;
  vcRemessa                 cRemessa%rowtype;
  vcPrestador               cPrestador%rowtype;
  vcAutorizacao             cAutorizacao%rowtype;
  vcHospital                cHospital%rowtype;
  vcEmpresaConv             cEmpresaConv%rowtype;
  vcProFat                  cProFat%rowtype;
  vcProFatAux               cProFatAux%rowtype;
  vcItem                    cItem%rowtype;
  vcItemAux                 cItemAux%rowtype;
  vcTissHI                  cTissHI%rowtype;
  vcTissSP_Proc             cTissSP_Proc%rowtype;
  vcTissCO                  cTissCO%rowtype;
  vcAprTiss                 cAprTiss%rowtype;
  vcCodPro                  cCodPro%rowtype;
  vcTUSS_old                cTUSS_old%rowtype;
  vcCarteira                cCarteira%rowtype;
  vcTuss                    cTuss%rowtype;
  vcTipTuss                 cTipTuss%rowtype;
  pTussRel_Old              RecTussRel;
  pTuss_Old                 RecTuss;
  vcDsHda                   cDsHda%rowtype;
  vDiagnosticoAtendimento   cDiagnosticoAtendimento%rowtype;
  vcHoraGases               cHoraGases%rowtype;
  vcContratado              cContratado%rowtype;
  vcTissSolGuia             cTissSolGuia%rowtype;
  vcCidsSecundarios         cCidsSecundarios%rowtype;
  vcGuia                    cGuia%rowtype;
  vcPedidoPrincipal         cPedidoPrincipal%rowtype;
  vcPrestadorExterno        cPrestadorExterno%rowtype;
  vCodUnid                  varchar2(2000);
  vTermoUnid                varchar2(2000);
  vDescUnid                 varchar2(2000);
  vPendenciaGuia            varchar2(4000);
  vcIndiceHE                cIndiceHE%rowtype;
  vcAcomod                  cAcomod%rowtype;
  vcAtiMed                  cAtiMed%rowtype; --PROD-2892
  vcRegraGasesItem          cRegraGasesItem%rowtype;
  vGerandoGuia              VARCHAR2(20) := 'N';
  nLastIdMap                NUMBER;
  vcDadosTissMensagem       dbamv.tiss_mensagem%rowtype; --OP 48413
  --Oswaldo FATURCONV-20760 inicio
  vcProgramasHomecare  cProgramasHomecare%rowtype;
  vHomecareTpGuiaSP           VARCHAR2(1) := 'N';
  --Oswaldo FATURCONV-20760 fim
  --
procedure F_le_conf( pIdMap     in number
                    ,pCdConv    in dbamv.convenio.cd_convenio%type
                    ,pModo      in varchar2
                    ,pReserva   in varchar2)  is
    --
    nCdProto    dbamv.proto.cd_proto%type;
    --
    Cursor cConfig is
        select es.ds_tag, es.ds_complex_type, es.tp_dado_schema, es.ds_opcoes_condicao1, es.ds_opcoes_condicao2, es.ds_opcoes_condicao3, es.sn_obrigatorio, es.ds_estrutura_srv
              ,cp.cd_id_estrutura_srv, cp.tp_utilizacao, cp.cd_condicao1, cp.cd_condicao2, cp.cd_condicao3, cp.ds_valor_fixo, cp.ds_query_alternativa, cp.tp_preenchimento
              ,es.sn_escolha
                from dbamv.config_proto cp, dbamv.estrutura_srv es, dbamv.estrutura_srv es2
                where es2.cd_id_estrutura_srv = pIdMap -- busca configura真真o pontual
                  and es.ds_rota_estrutura_srv like es2.ds_rota_estrutura_srv||'%' -- busca poss真veis outras conf. do mesmo CT
                  and cp.cd_id_estrutura_srv = es.cd_id_estrutura_srv
                  AND es.ds_versoes_atend LIKE '%'||vcConv.cd_versao_tiss||'%'
                  and cp.cd_proto = nCdProto
                --and nvl(cp.cd_multi_empresa,dbamv.pkg_mv2000.le_empresa) = dbamv.pkg_mv2000.le_empresa
                  and nvl(cp.cd_multi_empresa, nEmpresaLogada) = nEmpresaLogada --adhospLeEmpresa
                  and (cp.ds_id_cliente = vcConv.nr_registro_operadora_ans or cp.ds_id_cliente is null) -- prioridade p/configura真真o de ANS
                  and not exists (select 'x' from dbamv.config_proto cp2 -- se tiver configura真真o p/ANS, ent真o default n真o retorna
                                    where cp2.cd_id_estrutura_srv = cp.cd_id_estrutura_srv
                                    --and cp2.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
                                      and cp2.cd_multi_empresa = nEmpresaLogada --adhospLeEmpresa
                                      and cp.ds_id_cliente is NULL
                                      and cp2.cd_proto = cp.cd_proto
                                      and cp2.ds_id_cliente = vcConv.nr_registro_operadora_ans)
           ORDER BY es.sq_schema; -- order necess真rio para identificar bloco da tag
    --
    type RecConfig is record (  ds_tag                  dbamv.estrutura_srv.ds_tag%type,
                                ds_complex_type         dbamv.estrutura_srv.ds_complex_type%type,
                                tp_dado_schema          dbamv.estrutura_srv.tp_dado_schema%type,
                                ds_opcoes_condicao1     dbamv.estrutura_srv.ds_opcoes_condicao1%type,
                                ds_opcoes_condicao2     dbamv.estrutura_srv.ds_opcoes_condicao2%type,
                                ds_opcoes_condicao3     dbamv.estrutura_srv.ds_opcoes_condicao3%type,
                                sn_obrigatorio          dbamv.estrutura_srv.sn_obrigatorio%type,
                                ds_estrutura_srv        dbamv.estrutura_srv.ds_estrutura_srv%TYPE,
                                cd_id_estrutura_srv     dbamv.config_proto.cd_id_estrutura_srv%type,
                                tp_utilizacao           dbamv.config_proto.tp_utilizacao%type,
                                cd_condicao1            dbamv.config_proto.cd_condicao1%type,
                                cd_condicao2            dbamv.config_proto.cd_condicao2%type,
                                cd_condicao3            dbamv.config_proto.cd_condicao3%type,
                                ds_valor_fixo           dbamv.config_proto.ds_valor_fixo%type,
                                ds_query_alternativa    dbamv.config_proto.ds_query_alternativa%type,
                                tp_preenchimento        dbamv.config_proto.tp_preenchimento%TYPE,
                                sn_escolha              dbamv.estrutura_srv.sn_escolha%TYPE);
    type tabConfig is table of RecConfig index by binary_integer;
    tConfig     tabConfig;
    vBloco      VARCHAR2(100);
    --
begin
  --
  if (tConfUtil.exists(pIdMap) and (nvl(pModo,'X')<>'Reler' OR (Nvl(nLastIdMap,0)=pIdMap))) AND nvl(vcConv.cd_convenio,9999) = nvl(pCdConv,0)  THEN
    RETURN; -- J真 tem configura真真o carregada e n真o 真 op真真o "Reler" (ou 真 "Reler" mas a 真ltima Releitura foi das mesmas configura真真es), ent真o retorna;
  end if;
  --
  if nvl(vcConv.cd_convenio,9999) <> nvl(pCdConv,0) THEN
    vcConv := NULL;
    open  cConv(pCdConv);
    fetch cConv into vcConv;
    close cConv;
  end if;
  nCdProto := Nvl(vcConv.cd_proto,3);
  --
  open  cConfig;
  fetch cConfig BULK COLLECT into tConfig;
  close cConfig;
  --
  for i in 1 .. nvl(tConfig.last,0) LOOP
    -- monta configura真真es Completas por Tag pra ser lidas pela package toda;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).cd_id_estrutura_srv   :=  tConfig(i).cd_id_estrutura_srv;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).ds_tag                :=  tConfig(i).ds_tag;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).ds_estrutura_srv      :=  tConfig(i).ds_estrutura_srv;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).sn_obrigatorio        :=  tConfig(i).sn_obrigatorio;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).tp_dado               :=  tConfig(i).tp_dado_schema;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).tp_utilizacao         :=  tConfig(i).tp_utilizacao;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).cd_condicao1          :=  tConfig(i).cd_condicao1;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).cd_condicao2          :=  tConfig(i).cd_condicao2;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).cd_condicao3          :=  tConfig(i).cd_condicao3;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).ds_valor_fixo         :=  tConfig(i).ds_valor_fixo;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).ds_query_alternativa  :=  tConfig(i).ds_query_alternativa;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).tp_preenchimento      :=  tConfig(i).tp_preenchimento;
      IF tConfig(i).ds_tag IS NULL THEN -- identifica bloco que pertence o campo/tag e seta pra indicar quando ocorrer inconsistencias
        IF InStr(tConfig(i).ds_estrutura_srv,'_')>0 then
          vBloco := tConfig(i).sn_obrigatorio||'#'||SubStr(tConfig(i).ds_estrutura_srv,1,InStr(tConfig(i).ds_estrutura_srv,'_')-1);
        else
          vBloco := tConfig(i).sn_obrigatorio||'#'||SubStr(tConfig(i).ds_estrutura_srv,1,Length(tConfig(i).ds_estrutura_srv));
        END IF;
      END IF;
      tConf(nvl(tConfig(i).ds_tag,tConfig(i).ds_complex_type)).ds_bloco := tConfig(i).sn_escolha||'#'||vBloco;
      --
      -- sinaliza configura真真es j真 lidas (evitar releitura)
      tConfUtil(tConfig(i).cd_id_estrutura_srv).sn_ja_ativada := 'S';
      -- monta configura真真o por CHAVE tradicional das 3 op真真es para ser lida pela fun真真o tradicional FNC_CONF() compat真vel PII.
      -- Ex: tConfChave('SN_GERA_CREDENCIADO') = 'S'
      if tConfig(i).cd_condicao1 is not null and tConfig(i).ds_opcoes_condicao1 is not null then
        tConfChave(substr(tConfig(i).ds_opcoes_condicao1,2,instr(tConfig(i).ds_opcoes_condicao1,'#')-2)) := tConfig(i).cd_condicao1;
      end if;
      if tConfig(i).cd_condicao2 is not null and tConfig(i).ds_opcoes_condicao2 is not null then
        tConfChave(substr(tConfig(i).ds_opcoes_condicao2,2,instr(tConfig(i).ds_opcoes_condicao2,'#')-2)) := tConfig(i).cd_condicao2;
      end if;
      if tConfig(i).cd_condicao3 is not null and tConfig(i).ds_opcoes_condicao3 is not null then
        tConfChave(substr(tConfig(i).ds_opcoes_condicao3,2,instr(tConfig(i).ds_opcoes_condicao3,'#')-2)) := tConfig(i).cd_condicao3;
      end if;
      --
  end loop;
  --
  nLastIdMap := pIdMap;
  --
end;
--
function F_qry (vQry      in varchar2,
                par1      in varchar2,
                par2      in varchar2,
                par3      in varchar2,
                par4      in varchar2,
                par5      in VARCHAR2,
                pValCor   IN VARCHAR2,
                pNmCampo  IN varchar2) return varchar2 is
--
vTemp   varchar2(4000);
vTemp1  varchar2(4000);
vTemp2  varchar2(1000);
vResult varchar2(4000);
vFalha  varchar2(4000);
--
begin
  -- padroniza par真metros
  vTemp := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(vQry,':par1',':PAR1'),':par2',':PAR2'),':par3',':PAR3'),':par4',':PAR4'),':par5',':PAR5'),':val',':VAL');
  vTemp := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(vTemp,':Par1',':PAR1'),':Par2',':PAR2'),':Par3',':PAR3'),':Par4',':PAR4'),':Par5',':PAR5'),':Val',':VAL');
  -- substitui par真metros
  vTemp := replace(vTemp, ':PAR1',chr(39)||par1||chr(39));
  vTemp := replace(vTemp,':PAR2',chr(39)||par2||chr(39));
  vTemp := replace(vTemp,':PAR3',chr(39)||par3||chr(39));
  vTemp := replace(vTemp,':PAR4',chr(39)||par4||chr(39));
  vTemp := replace(vTemp,':PAR5',chr(39)||par5||chr(39));
--vTemp := REPLACE(vTemp,':VAL',chr(39)||pValCor||chr(39)); --OP 36461
  vTemp := REPLACE(vTemp,':VAL',chr(39)|| REPLACE(pValCor,'''','''''')||chr(39)); --OP 36461
  -- for真a retorno de apenas 1 linha
  if instr(Upper(vTemp),'WHERE',1)>0 then
    vTemp2 := ' and rownum = 1 ';
  else
    vTemp2 := ' where rownum = 1 ';
  end if;
  if instr(Upper(vTemp),'GROUP BY',1)>0 then
    vTemp1 := substr(vTemp,1,instr(Upper(vTemp),'GROUP BY',1)-1);
    vTemp1 := vTemp1||vTemp2||substr(vTemp,instr(Upper(vTemp),'GROUP BY',1));
    vTemp  := vTemp1;
  elsif instr(Upper(vTemp),'ORDER BY',1)>0 then
    vTemp1 := substr(vTemp,1,instr(Upper(vTemp),'ORDER BY',1)-1);
    vTemp1 := vTemp1||vTemp2||substr(vTemp,instr(Upper(vTemp),'ORDER BY',1));
    vTemp  := vTemp1;
  else
    vTemp := vTemp||vTemp2;
  end if;
  --
  -- renomeia coluna da query para melhor identifica真真o em caso de Trace
  vTemp := SubStr(vTemp,1,inStr(Upper(vTemp),' FROM'))||' QryCliente_'||SubStr(pNmCampo,1,19)||' '||SubStr(vTemp,inStr(Upper(vTemp),' FROM'));
  --
  BEGIN
    EXECUTE IMMEDIATE vTemp INTO vResult;
  exception
    WHEN NO_DATA_FOUND THEN
        vResult := null;
    when others then
        vFalha := '#FALHA'||' PARAMETROS: :par1='||par1||', :par2='||par2||', :par3='||par3||', par4='||par4||', :par5='||par5||', :val='||pValCor||CHR(10)
                 ||'ERRO: '||SQLERRM||Chr(10)
                 ||'QUERY: '||vTemp;
  end;
  --
  if vFalha is not null then
    RETURN vFalha;
  else
    RETURN vResult;
  end if;
  --
end;
--
--==================================================
FUNCTION  F_TISS
  ( pFnc        IN varchar2,
    param1      IN varchar2,
    param2      IN varchar2,
    param3      IN varchar2,
    param4      IN varchar2,
    param5      IN varchar2,
    param6      IN varchar2,
    param7      IN varchar2,
    param8      IN varchar2,
    param9      IN varchar2)
  RETURN  varchar2 IS
  --
  vResult           varchar2(2000);
  pMsg              varchar2(2000);
  pCdConv           dbamv.convenio.cd_convenio%type;
  vCtBenef          RecBenef;
  vCtRecContrat     RecContrat;
  vCtCabec          RecCabec;
  vCtRecAutorizInt  RecAutorizInt;
  vCtProcInt        RecProcInt;
  vCtProcSadt       RecProcSadt;
  vProcDados        RecProcDados;
  vCtProDesp        RecOutDesp;
  vCtContrProf      RecContrProf;
  vCtRecLocContrat  RecLocContrat;
  vCtContrExec      RecContrExec;
  vCtProHonInd      RecProcHI;
  vCtConsultaAtend  RecConsultaAtend;
  vCtAutorizSadt    RecAutorizSadt;
BEGIN
  ---------------------------------------------------
  if pFnc = 'F_ct_beneficiarioDados' then
    vResult := F_ct_beneficiarioDados(param1,param2,param3,param4,param5,param6,param7,vCtBenef,pMsg,param9);
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ct_contratadoDados' then
    vResult := F_ct_contratadoDados(param1,param2,param3,param4,param5,param6,param7,param8,vCtRecContrat,pMsg,param9);
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ct_guiaCabecalho' then
    vResult := F_ct_guiaCabecalho(param1,param2,param3,param4,param5,param6,param7,vCtCabec,pMsg,param9);
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ct_autorizacaoInternacao' then
    vResult := F_ct_autorizacaoInternacao(param1,param2,param3,param4,param5,param6,vCtRecAutorizInt,pMsg,param9);
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ct_procedimentoExecutadoInt' then
    vResult := F_ct_procedimentoExecutadoInt(param1,param2,param3,param4,param5,param6,vCtProcInt,pMsg,param9);
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ct_procedimentoDados' then
    vResult := F_ct_procedimentoDados(param1,param2,param3,param4,param5,param6,param7,param8,param9,vProcDados,pMsg,param9);
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ct_procedimentoExecutadoOutr' then
    vResult := F_ct_procedimentoExecutadoOutr(param1,param2,param3,param4,param5,param6,param7,vCtProDesp,pMsg,param9);
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ct_contratadoProfissionalDad' then
    vResult := F_ct_contratadoProfissionalDad(param1,param2,param3,param4,param5,param6,vCtContrProf,pMsg,param9);
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ct_localContratado' then
    vResult := F_ct_localContratado(param1,param2,param3,param4,param5,param6,vCtRecLocContrat,pMsg,param9);
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ct_dadosContratadoExecutante' then
    vResult := F_ct_dadosContratadoExecutante(param1,param2,param3,param4,param5,param6,vCtContrExec,pMsg,param9);
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ct_procedimentoHonorIndiv' then
    vResult := F_ct_procedimentoHonorIndiv(param1,param2,param3,param4,param5,param6,vCtProHonInd,pMsg,param9);
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ctm_consultaAtendimento' then
    vResult := F_ctm_consultaAtendimento(param1,param2,param3,param4,param5,param6,param7,vCtConsultaAtend,pMsg,param9);
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ct_procedimentoExecutadoSadt' then
    vResult := F_ct_procedimentoExecutadoSadt(param1,param2,param3,param4,param5,param6,param7,vCtProcSadt,pMsg,param9); -- Oswaldo in真cio 210325
  end if;
  ---------------------------------------------------
  if pFnc = 'F_ct_autorizacaoSADT' then
    vResult := F_ct_autorizacaoSADT(param1,param2,param3,param4,param5,param6,param7,param8,vCtAutorizSadt,pMsg,param9);
  end if;
  ---------------------------------------------------
  return vResult;
  --
EXCEPTION
	WHEN OTHERS THEN
--  		 RETURN 'Falha '||SQLERRM;
  		RETURN null;
  --
END;
--
--==================================================
FUNCTION  F_ct_beneficiarioDados(pModo           in varchar2,
                                 pIdMap          in number,
                                 pCdAtend        in dbamv.atendime.cd_atendimento%type,
                                 pCdConta        in dbamv.reg_fat.cd_reg_fat%type,
                                 pCdPaciente     in dbamv.paciente.cd_paciente%type,
                                 pCdConv         in dbamv.convenio.cd_convenio%type,
                                 pStElegPaciente IN VARCHAR2,
                                 vCt             OUT NOCOPY RecBenef,
                                 pMsg            OUT varchar2,
                                 pReserva        in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(1000);
  pCdConvTmp        dbamv.convenio.cd_convenio%type;
  pCdPacienteTmp    dbamv.paciente.cd_paciente%type;
  pNrCarteiraTmp    dbamv.carteira.nr_carteira%TYPE;
  vCp               varchar2(1000);

BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    vcConta := null;
    if pCdConta is not null then
      if pCdConta<>nvl(vcConta.cd_conta,0) then
        open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
        fetch cConta into vcConta;
        close cConta;
      end if;
    end if;
  else
    vcAtendimento := null;
    vcConta       := null;
  end if;
  --
  ------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdPacienteTmp    :=  nvl(pCdPaciente,vcAtendimento.cd_paciente);
  pCdConvTmp        :=  nvl(pCdConv,nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
  --
  if pCdPacienteTmp <> nvl(vcPaciente.cd_paciente, 0) OR nvl(SubStr(pReserva,1,8),'x') = 'RelerPac' THEN -- releitura
    vcPaciente := null ;
    open  cPaciente(pCdPacienteTmp, pCdConvTmp, nvl(vcConta.cd_con_pla,vcAtendimento.cd_con_pla),pCdAtend,pStElegPaciente,vcAtendimento.dt_atendPac);--OSWALDO
    fetch cPaciente into vcPaciente;
    close cPaciente;
  end if;
  pNrCarteiraTmp    := coalesce(vcPaciente.nr_carteira,vcAtendimento.nr_carteira,SubStr(pReserva,10));
  ------------------------------------------------------
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ct_beneficiarioDados').tp_utilizacao > 0 then
    --
    -- numeroCarteira-----------------------------------
    vCp := 'numeroCarteira'; vTemp := null;
    if Nvl(pModo,vCp) = SubStr(vCp,1,Length(Nvl(pModo,vCp))) and tConf(vCp).tp_utilizacao>0 then
      vTemp := pNrCarteiraTmp;
      vCt.numeroCarteira := F_ST(null,vTemp,vCp,pCdPacienteTmp,pCdConvTmp,pCdAtend,pCdConta,null);
      vResult := vCt.numeroCarteira;
    end if;
    --
    -- atendimentoRN------------------------------------
    -- obs: este 真 o 真nico campo que depende do atendimento, se n真o passar ele fica nulo.
    vCp := 'atendimentoRN'; vTemp := null;
    if Nvl(pModo,vCp) = SubStr(vCp,1,Length(Nvl(pModo,vCp))) and tConf(vCp).tp_utilizacao>0 then
      vTemp := nvl(vcAtendimento.sn_recem_nato,'N');
      if vcAtendimento.sn_recem_nato is null and vcAtendimento.tp_atendimento<>'I' then
        if vcAtendimento.cd_atendimento_pai is not null then
          vTemp := 'S';
        elsif pCdAtend is not null and vcAtendimento.cd_guia is not null then
          if nvl(vcTissSolGuia.cd_guia,0)<>vcAtendimento.cd_guia then
            vcTissSolGuia := null;
            open  cTissSolGuia(null,vcAtendimento.cd_guia, null, null);
            fetch cTissSolGuia into vcTissSolGuia;
            close cTissSolGuia;
          end if;
          if nvl(vcTissSolGuia.sn_atendimento_rn,'N') = 'S' then
            vTemp := 'S';
          end if;
        end if;
        if vTemp = 'N' and substr(vcPaciente.nm_titular,1,2)='RN' then
          vTemp := 'S';
        end if;
      end if;
      vCt.atendimentoRN := F_ST(null,vTemp,vCp,pCdAtend,pCdPacienteTmp,pCdConta,null,null);   --  dm_simNao
      vResult := vCt.atendimentoRN;
    end if;
    --
    -- nomeBeneficiario---------------------------------
    --Oswaldo FATURCONV-2418 inicio
    --As Tags nomeBeneficiario e numeroCNS n真o s真o necess真rias na vers真o 4.00.00, por真m por motivos
    --de impress真o e vizualiza真真o de dados interno 真 feito a necessidade do preenchimento dessas informa真真es
    vCp := 'nomeBeneficiario'; vTemp := null;
    --if Nvl(pModo,vCp) = SubStr(vCp,1,Length(Nvl(pModo,vCp))) and tConf(vCp).tp_utilizacao>0 then
    if vCp = nvl(pModo,vCp) THEN

      vTemp := vcPaciente.nm_titular;
    --vCt.nomeBeneficiario := F_ST(null,vTemp,vCp,pCdPacienteTmp,pCdConvTmp,pCdAtend,pCdConta,null);
      vCt.nomeBeneficiario := SubStr(vTemp,1,70);
      vResult := vCt.nomeBeneficiario;
    end if;
    --
	--Oswaldo FATURCONV-26150 inicio
    vCp := 'nomeSocialBeneficiario'; vTemp := null;
    if vCp = nvl(pModo,vCp) THEN
      vTemp := vcPaciente.nm_social_paciente;
      vCt.nomeSocialBeneficiario := SubStr(vTemp,1,70);
      vResult := vCt.nomeSocialBeneficiario;
    end if;
    --Oswaldo FATURCONV-26150 fim
    --
    -- numeroCNS----------------------------------------
    vCp := 'numeroCNS'; vTemp := null;
    --if Nvl(pModo,vCp) = SubStr(vCp,1,Length(Nvl(pModo,vCp))) and tConf(vCp).tp_utilizacao>0 then
    if vCp = nvl(pModo,vCp) THEN
      vTemp := vcPaciente.nr_cns;
    --vCt.numeroCNS := F_ST(null,vTemp,vCp,pCdPacienteTmp,pCdAtend,pCdConta,null,null);
      vCt.numeroCNS := SubStr(vTemp,1,7);
      vResult := vCt.numeroCNS;
    end if;
    --Oswaldo FATURCONV-2418 fim
    --
    -- tipoIdent----------------------------------------
    vCp := 'tipoIdent'; vTemp := null;
    if tconf.EXISTS(vCp) AND  Nvl(pModo,vCp) = SubStr(vCp,1,Length(Nvl(pModo,vCp))) and tConf(vCp).tp_utilizacao>0 THEN
      vTemp := vcPaciente.tp_ident_beneficiario;
      vCt.tipoIdent  := F_ST(null,vTemp,vCp,pCdPacienteTmp,pCdConvTmp,null,null,null);   -- base64Binary
      vResult := vCt.tipoIdent ;
    end if;
    --
    -- identificadorBeneficiario------------------------
    vCp := 'identificadorBeneficiario'; vTemp := null;
    if tconf.EXISTS(vCp) AND Nvl(pModo,vCp) = SubStr(vCp,1,Length(Nvl(pModo,vCp))) and tConf(vCp).tp_utilizacao>0 then
      vTemp := vcPaciente.nr_id_beneficiario;



      vCt.identificadorBeneficiario := F_ST(null,vTemp,vCp,pCdPacienteTmp,pCdConvTmp,null,null,null);   -- base64Binary
      vResult := vCt.identificadorBeneficiario;
    end if;
    --
    -- templateBiometrico----------------------------------------
    --Oswaldo FATURCONV-22404 inicio
    /*
    vCp := 'templateBiometrico'; vTemp := null;
    if tconf.EXISTS(vCp) AND Nvl(pModo,vCp) = SubStr(vCp,1,Length(Nvl(pModo,vCp))) and tConf(vCp).tp_utilizacao>0 then
      vTemp := vcPaciente.DS_TEMPLATE_IDENT_BENEFICIARIO ;
      vCt.templateBiometrico  := F_ST(null,vTemp,vCp,pCdPacienteTmp,pCdConvTmp,null,null,null);   -- base64Binary
      vResult := vCt.templateBiometrico ;
    end if;
    */
    --Oswaldo FATURCONV-22404 fim
    --
    -- ausenciaCodValidacao----------------------------------------
    vCp := 'ausenciaCodValidacao'; vTemp := null;
    if tconf.EXISTS(vCp) AND Nvl(pModo,vCp) = SubStr(vCp,1,Length(Nvl(pModo,vCp))) and tConf(vCp).tp_utilizacao>0 then
      vTemp := vcPaciente.CD_AUSENCIA_VALIDACAO ;
      vCt.ausenciaCodValidacao  := F_ST(null,vTemp,vCp,pCdPacienteTmp,pCdConvTmp,null,null,null);   -- base64Binary
      vResult := vCt.ausenciaCodValidacao ;
    end if;
    --
    -- codValidacao----------------------------------------
    vCp := 'codValidacao'; vTemp := null;
    if tconf.EXISTS(vCp) AND Nvl(pModo,vCp) = SubStr(vCp,1,Length(Nvl(pModo,vCp))) and tConf(vCp).tp_utilizacao>0 then
      vTemp := vcPaciente.CD_VALIDACAO ;
      vCt.codValidacao  := F_ST(null,vTemp,vCp,pCdPacienteTmp,pCdConvTmp,null,null,null);   -- base64Binary
      vResult := vCt.codValidacao;
    end if;
    --

  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_guiaCabecalho(    pModo          in varchar2,
                                 pIdMap         in number,
                                 pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                 pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                 pCdConv        in dbamv.convenio.cd_convenio%type,
                                 pCdGuiaOrigem  in dbamv.guia.cd_guia%type,
                                 pTpGuia        in varchar2,
                                 vCt            OUT NOCOPY RecCabec,
                                 pMsg           OUT varchar2,
                                 pReserva       in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  pCdEmpTmp     dbamv.multi_empresas.cd_multi_empresa%type;
  vCp	          varchar2(1000);
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
  end if;
  if pCdConta is not null then
	  if pCdConta<>nvl(vcConta.cd_conta,0) then
	    vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  end if;
  ------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
--pCdEmpTmp     :=  nvl(nvl(pCdEmpTmp,nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa)),dbamv.pkg_mv2000.le_empresa);
  pCdEmpTmp     :=  nvl(nvl(pCdEmpTmp,nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa)),nEmpresaLogada); --adhospLeEmpresa
  pCdConvTmp    :=  nvl(pCdConv,nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
  ------------------------------------------------------
  if nvl(vcConv.cd_convenio,0)<>pCdConvTmp then
    open  cConv(pCdConvTmp);
    fetch cConv into vcConv;
    close cConv;
  end if;
  --
  IF Nvl(pTpGuia, 'XXXX') = 'SOL_SPSADT' then
    dbamv.pkg_ffcv_tiss_v4.f_le_conf(1533,pCdConvTmp,'Reler',null);
  end IF;
  --
  if pModo is NOT null or tConf('ct_guiaCabecalho').tp_utilizacao > 0 then
    --
    -- registroANS--------------------------------------
    vCp := 'registroANS'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      vTemp := vcConv.nr_registro_operadora_ans;
      vCt.registroANS := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.registroANS;
    end if;
    --
    -- numeroGuiaPrestador------------------------------
    vCp := 'numeroGuiaPrestador'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if pTpGuia = 'RI' then
          if FNC_CONF('TP_NR_GUIA_PREST_RI',pCdConvTmp,null) = '1' then
            select dbamv.seq_tiss_guia.nextval into vTemp from sys.dual;
            vCt.ID_GUIA := vTemp;
          elsif FNC_CONF('TP_NR_GUIA_PREST_RI',pCdConvTmp,null) = '2' then
            vTemp := pCdConta;
          elsif FNC_CONF('TP_NR_GUIA_PREST_RI',pCdConvTmp,null) = '3' then
            vTemp := pCdConta||'000000';    -- ???  implementar incremento
          elsif FNC_CONF('TP_NR_GUIA_PREST_RI',pCdConvTmp,null) = '4' then
            vTemp := fnc_retornar_guia_faixa ( pCdConvTmp,pCdEmpTmp,substr(pTpGuia,1,2),vcAtendimento.cd_paciente,pMsg);
            if pMsg is not null then
              RETURN NULL;
            end if;
          elsif FNC_CONF('TP_NR_GUIA_PREST_RI',pCdConvTmp,null) = '5' then
            select dbamv.seq_tiss_guia.nextval into vTemp from sys.dual; -- caso n真o hj.GuiOperadora posteriormente ser真 este sequencial
            vCt.ID_GUIA := vTemp;
          end if;
        elsif pTpGuia = 'SP' then
          if FNC_CONF('TP_NR_GUIA_PREST_SP',pCdConvTmp,null) = '1' then
            vTemp := pCdAtend||'000000';
          elsif FNC_CONF('TP_NR_GUIA_PREST_SP',pCdConvTmp,null) = '2' then
            vTemp := fnc_retornar_guia_faixa ( pCdConvTmp, pCdEmpTmp,substr(pTpGuia,1,2),vcAtendimento.cd_paciente,pMsg);
            if pMsg is not null then
              RETURN NULL;
            end if;
          elsif FNC_CONF('TP_NR_GUIA_PREST_SP',pCdConvTmp,null) = '3' then
            select dbamv.seq_tiss_guia.nextval into vTemp from sys.dual;
            vCt.ID_GUIA := vTemp;
          elsif FNC_CONF('TP_NR_GUIA_PREST_SP',pCdConvTmp,null) = '4' then
            select dbamv.seq_tiss_guia.nextval into vTemp from sys.dual; -- caso n真o hj.GuiOperadora posteriormente ser真 este sequencial
            vCt.ID_GUIA := vTemp;
          elsif FNC_CONF('TP_NR_GUIA_PREST_SP',pCdConvTmp,null) = '5' then
            vTemp := pCdAtend;
          end if;
        elsif pTpGuia = 'HI' then
          if FNC_CONF('TP_NR_GUIA_PREST_HI',pCdConvTmp,null) = '1' then
            vTemp := pCdAtend||'000000';
          elsif FNC_CONF('TP_NR_GUIA_PREST_HI',pCdConvTmp,null) = '2' then
            vTemp := fnc_retornar_guia_faixa ( pCdConvTmp, pCdEmpTmp,substr(pTpGuia,1,2),vcAtendimento.cd_paciente,pMsg);
            if pMsg is not null then
              RETURN NULL;
            end if;
          elsif FNC_CONF('TP_NR_GUIA_PREST_HI',pCdConvTmp,null) = '3' then
            select dbamv.seq_tiss_guia.nextval into vTemp from sys.dual;
            vCt.ID_GUIA := vTemp;
          elsif FNC_CONF('TP_NR_GUIA_PREST_HI',pCdConvTmp,null) = '4' then
            select dbamv.seq_tiss_guia.nextval into vTemp from sys.dual; -- caso n真o hj.GuiOperadora posteriormente ser真 este sequencial
            vCt.ID_GUIA := vTemp;
          end if;
        elsif pTpGuia = 'CO' then
          if FNC_CONF('TP_NR_GUIA_PREST_CO',pCdConvTmp,null) = '1' then
            vTemp := pCdAtend;
          elsif FNC_CONF('TP_NR_GUIA_PREST_CO',pCdConvTmp,null) = '2' then
            vTemp := fnc_retornar_guia_faixa ( pCdConvTmp, pCdEmpTmp,substr(pTpGuia,1,2),vcAtendimento.cd_paciente,pMsg);
            if pMsg is not null then
              RETURN NULL;
            end if;
          elsif FNC_CONF('TP_NR_GUIA_PREST_CO',pCdConvTmp,null) = '3' then
            select dbamv.seq_tiss_guia.nextval into vTemp from sys.dual;
            vCt.ID_GUIA := vTemp;
          elsif FNC_CONF('TP_NR_GUIA_PREST_CO',pCdConvTmp,null) = '4' then
            select dbamv.seq_tiss_guia.nextval into vTemp from sys.dual; -- caso n真o hj.GuiOperadora posteriormente ser真 este sequencial
            vCt.ID_GUIA := vTemp;
          end if;
        elsif pTpGuia = 'SOL_SPSADT' THEN
          if pCdGuiaOrigem is not null then
            if pCdGuiaOrigem<>nvl(vcGuia.cd_guia,0) then
              vcGuia := null;
              open  cGuia(pCdGuiaOrigem,null);
              fetch cGuia into vcGuia;
              close cGuia;
            end if;
          end if;
          if pCdGuiaOrigem is not null and vcGuia.nr_guia is not null then
            vTemp := vcGuia.nr_guia;
          else
          --vTemp := fnc_retornar_guia_faixa ( pCdConv,dbamv.pkg_mv2000.le_empresa,'SP',vcAtendimento.cd_paciente,pMsg);
            vTemp := fnc_retornar_guia_faixa ( pCdConv,nEmpresaLogada,'SP',vcAtendimento.cd_paciente,pMsg); --adhospLeEmpresa
            if pMsg is not null then
              RETURN NULL;
            end if;
          end if;
        else
          vTemp := pCdAtend;    --- provis真rio, implementar mais
        end if;
      vCt.numeroGuiaPrestador := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vResult := vCt.numeroGuiaPrestador;
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_contratadoDados(  pModo          in varchar2,
                                 pIdMap         in number,
                                 pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                 pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                 pCdLanc        in dbamv.itreg_fat.cd_lancamento%type,
                                 pCdItLan       in varchar2,
                                 pCdPrestador   in dbamv.prestador.cd_prestador%type,
                                 pCdConv        in dbamv.convenio.cd_convenio%type,
                                 vCt            OUT NOCOPY RecContrat,
                                 pMsg           OUT varchar2,
                                 pReserva       in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(1000);
  pCdConvTmp        dbamv.convenio.cd_convenio%type;
  vCp	            varchar2(1000);
  vCdPrestadorTmp   dbamv.prestador.cd_prestador%type;
  vCdPrestExterno   dbamv.prestador_externo.cd_pres_ext%type;
  vCdMultiEmpresa   dbamv.multi_empresas.cd_multi_empresa%type;
  pCdPed            NUMBER;
  vTpClasse         VARCHAR2(50);
  -- Oswaldo BH in真cio
  idGuia            NUMBER;
  vcPreInt          cPreInt%ROWTYPE;
  vPReserva         VARCHAR2(200);
  -- Oswaldo BH fim
BEGIN
  vPReserva := pReserva; -- Oswaldo BH
  -- leitura de cursores de uso geral
  if pCdAtend is not null then
    --Retirada do IF para que n真o seja preciso sair do sistema para que as informa真真es sejam atualizadas
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;

      open cAtendimentoAUX(pCdAtend);
      fetch cAtendimentoAUX into vcAtendimentoAUX;
      close cAtendimentoAUX;

  ELSE
    vcAtendimento := null;
	vcAtendimentoAUX := null;
  end if;
  if pCdConta is not null then
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  else
    vcConta := null;
  end if;
  IF pCdLanc IS NOT null then
    if pCdAtend||pCdConta||pCdLanc||pCdItLan <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento||vcItem.cd_itlan_med, 'XXXX') then
      open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      fetch cItem into vcItem;
      close cItem;
    end if;
    IF vcItemAux.tp_mvto IN ('Imagem','SADT') then
      pCdPed := vcItem.cd_mvto;
    END IF;
  END IF;
  --
  -- Oswaldo BH in真cio
  IF SubStr(vPReserva,1,InStr(vPReserva,'@')-1) = 'INTER#GUIA' THEN
    idGuia := To_Number(SubStr(vPReserva,InStr(vPReserva,'@')+1,Length(vPReserva)));
    vPReserva := NULL;
  ELSIF SubStr(vPReserva,1,InStr(vPReserva,'@')-1) = 'INTER#SOLICITACAO' THEN
    vPReserva := NULL;
  ELSIF SubStr(vPReserva,1,InStr(vPReserva,'@')-1) = 'SOLIC_INT#GUIA' THEN
    idGuia := To_Number(SubStr(vPReserva,InStr(vPReserva,'@')+1,Length(vPReserva)));
    vPReserva := 'SOLIC_INT';
  ELSIF SubStr(vPReserva,1,InStr(vPReserva,'@')-1) = 'SOLIC_INT#SOLICITACAO' THEN
    vPReserva := 'SOLIC_INT';
  END IF;
  --
  IF vPReserva = 'SOLIC_SP' AND FNC_CONF('TP_PREST_CONTRATADO_SOLIC_SP',pCdConvTmp,null) = '2' and FNC_CONF('TP_PROF_CONTRATADO_SOLIC_SP',pCdConvTmp,null) = '2' then
  -- Oswaldo BH fim
    IF vcAtendimentoAUX.cd_pres_ext IS NOT NULL THEN
      vCdPrestExterno := vcAtendimentoAUX.cd_pres_ext;
    elsif pCdPed IS NOT NULL OR 1 = 1 THEN
      if nvl(vcPedidoPrincipal.cd_atendimento||vcPedidoPrincipal.cd_pedido,0)<>pCdAtend||pCdPed then
        vcPedidoPrincipal := null;
        open  cPedidoPrincipal(pCdAtend, pCdPed);
        fetch cPedidoPrincipal into vcPedidoPrincipal;
        close cPedidoPrincipal;
      end if;
      IF vcPedidoPrincipal.cd_pres_ext IS NOT NULL THEN
        vCdPrestExterno := vcPedidoPrincipal.cd_pres_ext;
      END IF;
    else
      vcPedidoPrincipal   := null;
    end if;
  END IF;
  --
  IF nCdPrestExtSol IS NOT NULL AND vCdPrestExterno IS NULL THEN
    vCdPrestExterno := nCdPrestExtSol;
  END IF;

  IF vCdPrestExterno IS NOT NULL THEN
    IF Nvl(vcPrestadorExterno.cd_pres_ext,0)<>vCdPrestExterno then
      vcPrestadorExterno := null;
      open  cPrestadorExterno(vCdPrestExterno,null);
      fetch cPrestadorExterno into vcPrestadorExterno;
      close cPrestadorExterno;
    END IF;
  else
    vcPrestadorExterno := null;
  END IF;
  --
  ---------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp      :=  nvl(pCdConv,nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));

  vCdPrestadorTmp := Nvl(Nvl(pCdPrestador,vcPedidoPrincipal.cd_prest_pedido),vcAtendimento.cd_prestador);
  Dbms_Output.Put_Line('vCdPrestadorTmp1: '||vCdPrestadorTmp);
  -- Oswaldo BH in真cio
  IF instr(nvl(vPReserva,'X'),'@')>0 THEN
    vTpClasse := substr(vPReserva,instr(vPReserva,'@')+1); -- Tipo Classe da guia (ex: PRINCIPAL, SECUNDARIA, CREDENCIADOS, CRED_INTERNACAO)
	-- Oswaldo BH fim
  END IF;
  IF vTpClasse IS NULL AND  Nvl(vPReserva,'X')<>'SOLIC_SP' AND pCdPrestador IS NULL THEN -- Oswaldo BH
    vTpClasse := 'PRINCIPAL';
  END IF;
  IF vCdPrestExterno IS NOT NULL OR (Nvl(vPReserva,'X') = 'SOLIC_SP' AND FNC_CONF('TP_PREST_CONTRATADO_SOLIC_SP',pCdConvTmp,null) <> '2') OR vTpClasse = 'PRINCIPAL' OR (Nvl(vPReserva,'X') <> 'SOLIC_SP' AND pCdPrestador IS NULL) THEN -- Oswaldo BH
    vCdPrestadorTmp := NULL;
    Dbms_Output.Put_Line('vCdPrestadorTmp2: '||vCdPrestadorTmp);
  END IF;
--vCdMultiEmpresa := nvl(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa),dbamv.pkg_mv2000.le_empresa);
  vCdMultiEmpresa := nvl(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa),nEmpresaLogada); --adhospLeEmpresa
  -- Oswaldo BH in真cio
  if instr(nvl(vPReserva,'X'),'#')>0 THEN --Oswaldo FATURCONV-22468
    vCdMultiEmpresa := Nvl( substr(vPReserva,instr(vPReserva,'#')+1,4), vCdMultiEmpresa ); -- empresa forcada --Oswaldo FATURCONV-22468
	-- Oswaldo BH fim
  end if;
  ---------------------------------------------------------
  if vcConv.cd_convenio<>nvl(pCdConvTmp,0) then
    open  cConv(pCdConvTmp);
    fetch cConv into vcConv;
    close cConv;
  end if;
  --
  Dbms_Output.Put_Line('vCdPrestadorTmp3: '||vCdPrestadorTmp);
  if vCdPrestadorTmp is not null then
    if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>vCdPrestadorTmp||pCdConvTmp then
      vcPrestador := null;
      open  cPrestador(vCdPrestadorTmp,null, pCdConvTmp, null,vcItem.cd_con_pla); -- pda FATURCONV-1372
      fetch cPrestador into vcPrestador;
      close cPrestador;
    end if;
  else
    vcPrestador := null;
    if vCdMultiEmpresa <> nvl(vcHospital.cd_multi_empresa, 0) then
      open  cHospital(vCdMultiEmpresa);
      fetch cHospital into vcHospital;
      close cHospital;
    end if;
    if NVL(vcEmpresaConv.cd_multi_empresa||vcEmpresaConv.cd_convenio,'XX') <> vCdMultiEmpresa||pCdConvTmp then
      open  cEmpresaConv(vCdMultiEmpresa, pCdConvTmp);
      fetch cEmpresaConv into vcEmpresaConv;
      close cEmpresaConv;
    end if;
    IF pCdAtend IS NOT NULL then
      vcContratado := null;
      open  cContratado( pCdConvTmp,vcAtendimento.tp_atendimento_original,vcAtendimentoAUX.cd_ori_ate,vcAtendimento.cd_servico,null,null,null,null,vcAtendimento.cd_pro_int,vcAtendimento.cd_ser_dis);
      fetch cContratado into vcContratado;
      close cContratado;
	-- Oswaldo BH in真cio
	ELSIF idGuia IS NOT null then
      IF idGuia <> vcGuia.CD_GUIA then
        vcGuia := NULL;
        OPEN cGuia (idGuia, null);
        FETCH cGuia INTO vcGuia;
        CLOSE cGuia;
      END IF;
      IF vcGuia.cd_res_lei IS NOT NULL AND Nvl(vcPreInt.cd_res_lei,0) <> Nvl(vcGuia.cd_res_lei,0) then
        OPEN cPreInt (vcGuia.cd_res_lei);
        FETCH cPreInt INTO vcPreInt;
        CLOSE cPreInt;
      END IF;
      vcContratado := NULL;
      open  cContratado( pCdConv,'I',vcPreInt.cd_ori_ate, vcPreInt.cd_servico,null,null,null,null,NULL,null);
      fetch cContratado into vcContratado;
      close cContratado;
	-- Oswaldo BH fim
    ELSE
      vcContratado := NULL;
    END IF;
  END IF;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ct_contratadoDados').tp_utilizacao > 0 then
    -- Contratado Solicitante 真 o M真dico
    --
    FOR I in 1..3 LOOP -- os 3 campos abaixo s真o CHOICE ================
      --
      -- codigoPrestadorNaOperadora------------------------
      vCp := 'codigoPrestadorNaOperadora'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I then
        Dbms_Output.Put_Line('P1');
        Dbms_Output.Put_Line('vCdPrestadorTmp4: '||vCdPrestadorTmp);
        if vCdPrestadorTmp is not null then
          --PROD-2542 - so vai gerar se o credenciamento estiver ativo
          Dbms_Output.Put_Line('P2');
          if vcPrestador.sn_ativo_credenciamento = 'S' then
            vTemp := vcPrestador.cd_prestador_conveniado;
            Dbms_Output.Put_Line('P3');
          ELSE
            Dbms_Output.Put_Line('P4');
            vTemp := NULL;
          end if;
        elsif vCdPrestExterno is not null THEN
          Dbms_Output.Put_Line('P5');
          vTemp := Nvl(vcPrestadorExterno.cgc_cpf_prestador, Nvl(vcPrestadorExterno.nr_cgc_hospital, vcPrestadorExterno.NUMERO_CONSELHO));
        else -- 真 o Hospital
          if vcContratado.cd_codigo_contratado is not null then
            Dbms_Output.Put_Line('P6');
            vTemp := vcContratado.cd_codigo_contratado;
          ELSE
          Dbms_Output.Put_Line('P7');
            vTemp := vcEmpresaConv.cd_hospital_no_convenio;
          end if;
        end if;


	   -- em caso de profissional como contratado de solicita真真o avulsa (tela nova) sem informar prestador, poder真 ficar sem solicitante pra preencher no editor posteriormente
        IF vTpOrigemSol = 'SOLICITACAO' AND pCdPrestador IS NULL AND vCdPrestExterno IS NULL THEN
          vTemp := NULL;
        END IF;
        --
        IF Nvl(vPReserva,'XX') = 'RECURSO_GLOSA' AND vcDadosTissMensagem.cd_origem IS NOT NULL THEN --OP 48413 - ajuste no codigoPrestadorNaOperadora do cabe真alho do envio do Recurso -- Oswaldo BH
          vTemp :=   vcDadosTissMensagem.cd_origem;
        END IF;
        --
        vCt.codigoPrestadorNaOperadora := F_ST(null,vTemp,vCp,pCdConvTmp,vTpClasse,pCdAtend,pCdConta,null);
        vResult := vCt.codigoPrestadorNaOperadora;
        EXIT when vCt.codigoPrestadorNaOperadora is NOT null;
      end if;
      --
      -- cpfContratado-------------------------------------
      vCp := 'cpfContratado'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I then
        if vCdPrestadorTmp is not null then
          if length(vcPrestador.nr_cpf_cgc)<=11 then
            vTemp := vcPrestador.nr_cpf_cgc;
          end if;
        elsif vCdPrestExterno is not null then
          vTemp := null;  -- PENDENTE ?
        else
          vTemp := null;
        end if;
        -- em caso de profissional como contratado de solicita真真o avulsa (tela nova) sem informar prestador, poder真 ficar sem solicitante pra preencher no editor posteriormente
        IF vTpOrigemSol = 'SOLICITACAO' AND pCdPrestador IS NULL AND vCdPrestExterno IS NULL THEN
          vTemp := NULL;
        END IF;
        --
        vCt.cpfContratado := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,vTpClasse,null,null);
        vResult := vCt.cpfContratado;
        EXIT when vCt.cpfContratado is NOT null;
      end if;
      --
      -- cnpjContratado------------------------------------
      vCp := 'cnpjContratado'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I then
        if vCdPrestadorTmp is not null then
          if length(vcPrestador.nr_cpf_cgc)>11 then
            vTemp := vcPrestador.nr_cpf_cgc;
          end if;
        elsif vCdPrestExterno is not null then
          vTemp := vcPrestadorExterno.nr_cgc_hospital;
        else
          vTemp := vcHospital.cd_cgc;
        end if;
        -- em caso de profissional como contratado de solicita真真o avulsa (tela nova) sem informar prestador, poder真 ficar sem solicitante pra preencher no editor posteriormente
        IF vTpOrigemSol = 'SOLICITACAO' AND pCdPrestador IS NULL AND vCdPrestExterno IS NULL THEN
          vTemp := NULL;
        END IF;
        --
        vCt.cnpjContratado := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,vTpClasse,null,null);
        vResult := vCt.cnpjContratado;
        EXIT when vCt.cnpjContratado is NOT null;
      end if;
      --
    END LOOP; -- fim do CHOICE ============================
    --
    --Oswaldo FATURCONV-22404
    --Tag nomeContratado ir真 continuar aqui para que o valor seja preenchido e retornado para as F_ctm que chama essa,
    --pois na V4 a Tag nomeContratado saiu de dentro da F_ct_contratadoDados e foi para F_ctm que chama essa, e de acordo com Saulo.Rocha
    --essa nova Tag (nomeContratadoSolicitante) se trata da mesma informa真真o
    -- nomeContratado--------------------------------------
    vCp := 'nomeContratado'; vTemp := null;
    if vCp = nvl(pModo,vCp) THEN --and tConf(vCp).tp_utilizacao>0 then
      if vCdPrestadorTmp is not null then
        vTemp := vcPrestador.nm_prestador;
      elsif vCdPrestExterno is not null then
		    IF FNC_CONF('TP_PREST_CONTRATADO_SOLIC_SP',pCdConvTmp,null) = '2' AND -- se prof for o contratado
          vcPrestadorExterno.nome_prestador IS NOT NULL
          and vcPrestadorExterno.nm_hospital IS NULL
        THEN
          vTemp := vcPrestadorExterno.nome_prestador;
        ELSE
          vTemp := Nvl(vcPrestadorExterno.nm_hospital,vcHospital.ds_razao_social);
        END IF;
      ELSE
        vTemp := vcHospital.ds_razao_social;
      end if;
      -- em caso de profissional como contratado de solicita真真o avulsa (tela nova) sem informar prestador, poder真 ficar sem solicitante pra preencher no editor posteriormente
      IF vTpOrigemSol = 'SOLICITACAO' AND pCdPrestador IS NULL AND vCdPrestExterno IS NULL THEN
        vTemp := NULL;
      END IF;
      --
      vCt.nomeContratado := vTemp;
      vResult := vCt.nomeContratado;
    end if;
    --
    -- CIMP-4580 - inicio
    -- Guia de Solicita真真o de Interna真真o
    IF Nvl(vPReserva,'XX') = 'SOLIC_INT' then -- Oswaldo BH
      --
      -- codigoIndicadonaOperadora------------------------------------
      vCp := 'codigoIndicadonaOperadora'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        -- 真 o Hospital
        if vcContratado.cd_codigo_contratado is not null then
          vTemp := vcContratado.cd_codigo_contratado;
        else
          vTemp := vcEmpresaConv.cd_hospital_no_convenio;
        end if;

        vResult := vTemp;
      end if;
      --
      -- codigoIndicadonaOperadora------------------------------------
      vCp := 'nomeContratadoIndicado'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        -- 真 o Hospital
        vTemp := vcHospital.ds_razao_social;
        vResult := vTemp;
      end if;
    END IF;
    -- CIMP-4580 - fim
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_guiaValorTotal(   pModo          in varchar2,
                                 pIdMap         in number,
                                 pIdTissGuia    in number,
                                 pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                 pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                 pCdConv        in dbamv.convenio.cd_convenio%type,
                                 vCt            OUT NOCOPY RecVlTotal,
                                 pMsg           OUT varchar2,
                                 pReserva       in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	        varchar2(1000);
  TYPE RecTotGuia IS RECORD (cd_despesa varchar2(2), valor  number);
  TYPE tableTotGuia IS TABLE OF RecTotGuia INDEX BY varchar2(50);
  tTotGuia tableTotGuia;
  --
BEGIN
  -- leitura de cursores de uso geral
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  -- soma totais por despesa (os servi真os ficam numa despesa ficticia "00") e atribui num table indexado pelo tipo da despesa/totalizador.
  -- e totaliza o Geral num tipo ficticio "99"
  tTotGuia('valorTotalGeral').valor     := 0;   -- inicia o totalizador
  tTotGuia('valorTotalGeralDesp').valor := 0;   -- inicia o totalizador despesas (s真 tem efeito em relat真rio impresso)
  for i in cVlTotGuia(pIdTissGuia,null,null) loop
    tTotGuia(i.tp_despesa).cd_despesa := i.cd_despesa;
    tTotGuia(i.tp_despesa).valor      := i.valor;
    tTotGuia('valorTotalGeral').valor := nvl(tTotGuia('valorTotalGeral').valor,0)+i.valor;
    if i.cd_despesa<>'00' then -- soma despesa (tudo que n真o 真 servi真o "00")
       tTotGuia('valorTotalGeralDesp').valor := nvl(tTotGuia('valorTotalGeralDesp').valor,0)+i.valor;
    end if;
  end loop;
  --
  vCp := 'ct_guiaValorTotal'; vTemp := null;
  if pModo is NOT null or tConf(vCp).tp_utilizacao > 0 then
    --
    -- valorProcedimentos-------------------------------
    vCp := 'valorProcedimentos';
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if tTotGuia.exists(vCp) then
          vTemp := tTotGuia(vCp).valor;
        else
          vTemp := 0;
        end if;
      vCt.valorProcedimentos := F_ST(null,vTemp,vCp,pIdTissGuia,pCdAtend,pCdConta,null,null);
      vResult := vCt.valorProcedimentos;
    end if;
    --
    -- valorDi真rias-------------------------------------
    vCp := 'valorDiarias'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if tTotGuia.exists(vCp) then
          vTemp := tTotGuia(vCp).valor;
        else
          vTemp := 0;
        end if;
      vCt.valorDiarias := F_ST(null,vTemp,vCp,pIdTissGuia,pCdAtend,pCdConta,null,null);
      vResult := vCt.valorDiarias;
    end if;
    --
    -- valorTaxasAlugueis-------------------------------
    vCp := 'valorTaxasAlugueis'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if tTotGuia.exists(vCp) then
          vTemp := tTotGuia(vCp).valor;
        else
          vTemp := 0;
        end if;
      vCt.valorTaxasAlugueis := F_ST(null,vTemp,vCp,pIdTissGuia,pCdAtend,pCdConta,null,null);
      vResult := vCt.valorTaxasAlugueis;
    end if;
    --
    -- valorMateriais-----------------------------------
    vCp := 'valorMateriais'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if tTotGuia.exists(vCp) then
          vTemp := tTotGuia(vCp).valor;
        else
          vTemp := 0;
        end if;
      vCt.valorMateriais := F_ST(null,vTemp,vCp,pIdTissGuia,pCdAtend,pCdConta,null,null);
      vResult := vCt.valorMateriais;
    end if;
    --
    -- valorMedicamentos--------------------------------
    vCp := 'valorMedicamentos'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if tTotGuia.exists(vCp) then
          vTemp := tTotGuia(vCp).valor;
        else
          vTemp := 0;
        end if;
      vCt.valorMedicamentos := F_ST(null,vTemp,vCp,pIdTissGuia,pCdAtend,pCdConta,null,null);
      vResult := vCt.valorMedicamentos;
    end if;
    --
    -- valorOPME----------------------------------------
    vCp := 'valorOPME'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if tTotGuia.exists(vCp) then
          vTemp := tTotGuia(vCp).valor;
        else
          vTemp := 0;
        end if;
      vCt.valorOPME := F_ST(null,vTemp,vCp,pIdTissGuia,pCdAtend,pCdConta,null,null);
      vResult := vCt.valorOPME;
    end if;
    --
    -- valorGasesMedicinais-----------------------------
    vCp := 'valorGasesMedicinais'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if tTotGuia.exists(vCp) then
          vTemp := tTotGuia(vCp).valor;
        else
          vTemp := 0;
        end if;
      vCt.valorGasesMedicinais := F_ST(null,vTemp,vCp,pIdTissGuia,pCdAtend,pCdConta,null,null);
      vResult := vCt.valorGasesMedicinais;
    end if;
    --
    -- valorTotalGeral----------------------------------
    vCp := 'valorTotalGeral'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if tTotGuia.exists(vCp) then
          vTemp := tTotGuia(vCp).valor;
        else
          vTemp := 0;
        end if;
      vCt.valorTotalGeral := F_ST(null,vTemp,vCp,pIdTissGuia,pCdAtend,pCdConta,null,null);
      vResult := vCt.valorTotalGeral;
    end if;
    --
    -- campo especial para totalizador de despesas APENAS para relat真rio, utiliza mesma m真scara (vCp) do TotalGeral
    IF tTotGuia('valorTotalGeralDesp').valor > 0 THEN -- somente se tiver valor, sen真o fica nulo neste caso apenas
      vTemp := tTotGuia('valorTotalGeralDesp').valor;
      vCt.valorTotalGeralDesp := F_ST(null,vTemp,vCp,pIdTissGuia,pCdAtend,pCdConta,pCdConv,null);
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_autorizacaoInternacao(   pModo          in varchar2,
                                        pIdMap         in number,
                                        pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                        pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                        pCdGuia        in dbamv.guia.cd_guia%type,
                                        pCdConv        in dbamv.convenio.cd_convenio%type,
                                        vCt            OUT NOCOPY RecAutorizInt,
                                        pMsg           OUT varchar2,
                                        pReserva       in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  pCdGuiaTmp    dbamv.guia.cd_guia%type;
  vcGuiaAtend   cGuiaAtend%ROWTYPE;
  vCp	        varchar2(1000);
  --
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    --
  end if;
  ------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(pCdConv,nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
  if pCdGuia is not null and nvl(FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_HOSP',pCdConv,null),'1') = '2' THEN -- considera guia espec真fica do item
    pCdGuiaTmp  :=  pCdGuia;
  end if;
  if pCdGuiaTmp is null then
    if nCdGuiaPrinc is not null then -- guia principal j真 obtida antes, sen真o obtem abaixo conforme configura真真o
      pCdGuiaTmp := nCdGuiaPrinc;
    else
      if FNC_CONF('TP_DADOS_AUTORIZACAO_RI',pCdConvTmp,null) = 'C' then
        pCdGuiaTmp := vcConta.cd_guia;
      elsif FNC_CONF('TP_DADOS_AUTORIZACAO_RI',pCdConvTmp,null) IN ('A','O') then --condicao nova CONTA/ATENDIMENTO
        pCdGuiaTmp := vcAtendimento.cd_guia;
        IF pCdGuiaTmp IS NULL THEN  -- for真a obter guia da Interna真真o mesmo se n真o tiver associada
          OPEN  cGuiaAtend(pCdAtend,'I',NULL);
          FETCH cGuiaAtend INTO vcGuiaAtend;
          CLOSE cGuiaAtend;
          pCdGuiaTmp := vcGuiaAtend.cd_guia;
        END IF;
        --
        if FNC_CONF('TP_DADOS_AUTORIZACAO_RI',pCdConvTmp,null) = 'O' then --condicao nova CONTA/ATENDIMENTO
          pCdGuiaTmp := Nvl(vcConta.cd_guia,vcGuiaAtend.cd_guia);
        end if;
      end if;
      nCdGuiaPrinc := pCdGuiaTmp; -- Guia principal guardada em Global
    end if;
  end if;
  if pCdGuiaTmp is not null then
    if nvl(vcAutorizacao.cd_guia,0)<>pCdGuiaTmp then
      open  cAutorizacao(pCdGuiaTmp,null);
      fetch cAutorizacao into vcAutorizacao;
      close cAutorizacao;
    end if;
  else
    vcAutorizacao := null;
  end if;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  vCp := 'ct_autorizacaoInternacao'; vTemp := null;
  if pModo is NOT null or tConf(vCp).tp_utilizacao > 0 then
    --
    pCdGuiaTmp     :=  pCdGuia;
    --
    if FNC_CONF('TP_DADOS_AUTORIZACAO_RI',pCdConvTmp,null) = 'C' then
      pCdGuiaTmp := vcConta.cd_guia;
    elsif FNC_CONF('TP_DADOS_AUTORIZACAO_RI',pCdConvTmp,null) = 'A' then
      pCdGuiaTmp := vcAtendimento.cd_guia;
    elsif FNC_CONF('TP_DADOS_AUTORIZACAO_RI',pCdConvTmp,null) = 'O' then --condicao nova CONTA/ATENDIMENTO
      pCdGuiaTmp := Nvl(vcConta.cd_guia,vcAtendimento.cd_guia);
    end if;
    --
    if pCdGuiaTmp is not null then
      if nvl(vcAutorizacao.cd_guia,0)<>pCdGuiaTmp then
        open  cAutorizacao(pCdGuiaTmp,null);
        fetch cAutorizacao into vcAutorizacao;
        close cAutorizacao;
      end if;
    end if;
    --
    -- numeroGuiaOperadora------------------------------
    vCp := 'numeroGuiaOperadora'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if pCdGuiaTmp is not null then
          vTemp := vcAutorizacao.nr_guia;
        else
          vTemp := null;
        end if;
      vCt.numeroGuiaOperadora := F_ST(null,vTemp,vCp,pCdGuiaTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.numeroGuiaOperadora;
    end if;
    --
    -- dataAutorizacao----------------------------------
    vCp := 'dataAutorizacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if pCdGuiaTmp is not null then
          vTemp := vcAutorizacao.dt_autorizacao;
        else
          vTemp := null;
        end if;
      vCt.dataAutorizacao := F_ST(null,vTemp,vCp,pCdGuiaTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.dataAutorizacao;
    end if;
    --
    -- senha--------------------------------------------
    vCp := 'senha'; vTemp := null;

    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if pCdGuiaTmp is not null then
          if FNC_CONF('TP_DADOS_AUTORIZACAO_SENHA_RI',pCdConvTmp,null) = 'S' then --S-Senha
            vTemp := vcAutorizacao.nr_senha;
          elsif FNC_CONF('TP_DADOS_AUTORIZACAO_SENHA_RI',pCdConvTmp,null) = 'N' then --N-N真mero da Guia
            vTemp := vcAutorizacao.nr_guia;
          end if;
        else
          vTemp := null;
        end if;
      vCt.senha := F_ST(null,vTemp,vCp,pCdGuiaTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.senha;
    end if;
    --
    -- dataValidadeSenha--------------------------------
    vCp := 'dataValidadeSenha'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if pCdGuiaTmp is not null then
          vTemp := vcAutorizacao.dt_validade;
        else
          vTemp := null;
        end if;
      vCt.dataValidadeSenha := F_ST(null,vTemp,vCp,pCdGuiaTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.dataValidadeSenha;
    end if;
    --
    -- ausenciaCodValidacao-----------------------------
    vCp := 'ausenciaCodValidacao'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
      --OSWALDO IN真CIO
      if FNC_CONF('TP_ORIGEM_COD_VALIDACAO',pCdConvTmp,null) = 'ELEG' then
          vTemp := vcPaciente.cd_ausencia_validacao;
          --OSWALDO FIM
        else
          vTemp := null;
        end if;
      vCt.ausenciaCodValidacao := F_ST(null,vTemp,vCp,pCdGuiaTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.ausenciaCodValidacao;
    end if;
    --
    -- codValidacao-------------------------------------
    vCp := 'codValidacao'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
      --OSWALDO IN真CIO
      if FNC_CONF('TP_ORIGEM_COD_VALIDACAO',pCdConvTmp,null) = 'ELEG' then
          vTemp := vcPaciente.cd_ausencia_validacao;
          --OSWALDO FIM
        else
          vTemp := null;
        end if;
      vCt.codValidacao := F_ST(null,vTemp,vCp,pCdGuiaTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.codValidacao;
    end if;
    --


  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ctm_internacaoResumoGuia(   pModo          in varchar2,
                                        pIdMap         in number,
                                        pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                        pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                        pMsg           OUT varchar2,
                                        pReserva       in varchar2) return varchar2 IS
  --
  vTemp	                varchar2(1000);
  vResult               varchar2(1000);
  vCp                   varchar2(1000);
  vRet                  varchar2(1000);
  vTissGuia             dbamv.tiss_guia%rowtype;
  vTissItGuia           dbamv.tiss_itguia%rowtype;
  vTissItGuiaEqu        dbamv.tiss_itguia_equ%rowtype;
  vTissItGuiaOut        dbamv.tiss_itguia_out%rowtype;
  vTissItGuiaDecl       dbamv.tiss_itguia_declaracao%rowtype;
  vTissItGuiaCid        dbamv.tiss_itguia_cid%rowtype;
  pCdConv               dbamv.convenio.cd_convenio%type;
  vCtAutorizInt         RecAutorizInt;
  vCtBenef              RecBenef;
  vCtCabec              RecCabec;
  vCtContrat            RecContrat;
  vCtVlTotal            RecVlTotal;
  vCtProcInt            RecProcInt;
  vCtOutDesp            RecOutDesp;
  vCtInternacaoDados    RecInternacaoDados;
  vCtInternacaoDadosSaida    RecInternacaoDadosSaida;
  vcTissRI_Proc         cTissRI_Proc%rowtype;
  vcTissOutDesp         cTissOutDesp%rowtype;
  vcItemAux             cItemAux%ROWTYPE;
  pModoIt               varchar2(1000);
  pModoOut              varchar2(1000);
  itemVinculadoSeq      NUMBER;
  bImagemPrincipal      BOOLEAN := TRUE;
  bSADTPrincipal        BOOLEAN := TRUE;
  bAtendimentoPrincipal BOOLEAN := TRUE;
  bPrescricaoPrincipal  BOOLEAN := TRUE;
  --
  vTussRel      RecTussRel;
  vTuss         RecTuss;
BEGIN
  --
  if pModo IS NULL THEN  vGerandoGuia := 'S'; END IF;
  --
  -- Inicia o sequenciamento dos itens
  nSqItem:=0;
  nSqItemOut:=0;
  --
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    ---------------------------------------------------
    -- Campos b真sicos para esta CT, caso n真o venham via par真metro
    pCdConv     :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
    --
    if nvl(vcConv.cd_convenio,9999) <> nvl(pCdConv,0) THEN
      vcConv := NULL;
      open  cConv(pCdConv);
      fetch cConv into vcConv;
      close cConv;
    end if;
    ---------------------------------------------------
  end if;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  vCp := 'ctm_internacaoResumoGuia'; vTemp := null;
  if tConf(vCp).tp_utilizacao > 0 then
    --
    -- cabecalhoGuia-----------------------------------
    vRet := F_ct_guiaCabecalho(null,1032,pCdAtend,pCdConta,pCdConv,null,'RI',vCtCabec,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.nr_registro_operadora_ans   := vCtCabec.registroANS;
      vTissGuia.NR_GUIA                     := vCtCabec.numeroGuiaPrestador;
      --
      vTissGuia.ID                          := vCtCabec.ID_GUIA; -- op真真o
    else
      RETURN NULL;
    end if;
    --
    -- numeroGuiaSolicitacaoInternacao-----------------
    vCp := 'numeroGuiaSolicitacaoInternacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 THEN
        if FNC_CONF('TP_GUIA_SOLICITACAO_RI',pCdConv,null) = 'C' then
          if nvl(vcAutorizacao.cd_guia,0)<>vcConta.cd_guia then
            open  cAutorizacao(vcConta.cd_guia,null);
            fetch cAutorizacao into vcAutorizacao;
            close cAutorizacao;
          end if;
          vTemp := vcAutorizacao.nr_guia;
        elsif FNC_CONF('TP_GUIA_SOLICITACAO_RI',pCdConv,null) = 'A' then
          if nvl(vcAutorizacao.cd_guia,0)<>vcAtendimento.cd_guia then
            open  cAutorizacao(vcAtendimento.cd_guia,null);
            fetch cAutorizacao into vcAutorizacao;
            close cAutorizacao;
          end if;
          vTemp := vcAutorizacao.nr_guia;
        elsif FNC_CONF('TP_GUIA_SOLICITACAO_RI',pCdConv,null) = 'O' then
          if nvl(vcAutorizacao.cd_guia,0)<>Nvl(vcConta.cd_guia, vcAtendimento.cd_guia) then
            open  cAutorizacao(Nvl(vcConta.cd_guia, vcAtendimento.cd_guia),null);
            fetch cAutorizacao into vcAutorizacao;
            close cAutorizacao;
          end if;
          vTemp := vcAutorizacao.nr_guia;
        else
          vTemp := Null;
        end if;
      vTissGuia.NR_GUIA_SOL := F_ST(null,vTemp,vCp,vcAtendimento.cd_guia,pCdAtend,pCdConta,null,null);
    end if;
    --
    -- dadosAutorizacao--------------------------------
    vRet := F_ct_autorizacaoInternacao(null,1036,pCdAtend,pCdConta,null,null,vCtAutorizInt,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.NR_GUIA_OPERADORA       := vCtAutorizInt.numeroGuiaOperadora;
      vTissGuia.DT_AUTORIZACAO          := vCtAutorizInt.dataAutorizacao;
      vTissGuia.CD_SENHA                := vCtAutorizInt.senha;
      vTissGuia.DT_VALIDADE_AUTORIZADA  := vCtAutorizInt.dataValidadeSenha;
      vTissGuia.CD_AUSENCIA_VALIDACAO   := vCtAutorizInt.ausenciaCodValidacao;
      vTissGuia.CD_VALIDACAO            := vCtAutorizInt.codValidacao;

    end if;
    --
    -- dadosBeneficiario-------------------------------
    vRet := F_ct_beneficiarioDados(null,1041,pCdAtend,pCdConta,null,null,'E',vCtBenef,pMsg,'RelerPac');
    if vRet = 'OK' then
      vTissGuia.NR_CARTEIRA                    := vCtBenef.numeroCarteira;
      vTissGuia.sn_atendimento_rn              := vCtBenef.atendimentoRN;
      vTissGuia.NM_PACIENTE                    := vCtBenef.nomeBeneficiario;
	  vTissGuia.NM_SOCIAL_PACIENTE             := vCtBenef.nomeSocialBeneficiario; --Oswaldo FATURCONV-26150
      vTissGuia.NR_CNS                         := vCtBenef.numeroCNS;
      --OSWALDO IN真CIO
	  IF nvl(fnc_conf('SN_GRAVA_ID_BENEFICIARIO_RI',pCdConv,null),'N')='S' then
	    vTissGuia.TP_IDENT_BENEFICIARIO          := vCtBenef.tipoIdent;
	    vTissGuia.NR_ID_BENEFICIARIO             := vCtBenef.identificadorBeneficiario;
	    --vTissGuia.DS_TEMPLATE_IDENT_BENEFICIARIO := vCtBenef.templateBiometrico; --Oswaldo FATURCONV-22404
	  end if;
	  --OSWALDO FIM
    end if;
    --
    -- dadosExecutante
    -- contratadoExecutante----------------------------
    vRet := F_ct_contratadoDados(null,1047,pCdAtend,pCdConta,null,null,null,null,vCtContrat,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.CD_OPERADORA_EXE    := vCtContrat.codigoPrestadorNaOperadora;
      vTissGuia.CD_CPF_EXE          := vCtContrat.cpfContratado;
      vTissGuia.CD_CGC_EXE          := vCtContrat.cnpjContratado;
      vTissGuia.NM_PRESTADOR_EXE    := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404
    end if;
    --
    -- CNES--------------------------------------------
    vCp := 'CNES'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        if nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa) <> nvl(vcHospital.cd_multi_empresa, 0) then
          open cHospital(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa));
          fetch cHospital into vcHospital;
          close cHospital;
        end if;
        vTemp := nvl(to_char(vcHospital.nr_cnes),'9999999');
      vTissGuia.CD_CNES_EXE := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
    end if;
    --
    -- dadosInternacao
    -- ctm_internacaoDados-----------------------------
    vRet := F_ctm_internacaoDados(null,1054,pCdAtend,pCdConta,vCtInternacaoDados,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.CD_CARATER_SOLICITACAO  := vCtInternacaoDados.caraterAtendimento;
      vTissGuia.TP_FATURAMENTO          := vCtInternacaoDados.tipoFaturamento;
      vTissGuia.DT_INICIO_FATURAMENTO   := vCtInternacaoDados.dataInicioFaturamento;
      vTissGuia.HR_INICIO_FATURAMENTO   := vCtInternacaoDados.horaInicioFaturamento;
      vTissGuia.DT_FINAL_FATURAMENTO    := vCtInternacaoDados.dataFinalFaturamento;
      vTissGuia.HR_FINAL_FATURAMENTO    := vCtInternacaoDados.horaFinalFaturamento;
      vTissGuia.CD_TIPO_INTERNACAO      := vCtInternacaoDados.tipoInternacao;
      vTissGuia.TP_REGIME_INTERNACAO    := vCtInternacaoDados.regimeInternacao;
      --
      vTissGuia.TP_ACIDENTE             := vCtInternacaoDados.indicadorAcidente;
      vTissGuia.CD_MOTIVO_ALTA          := vCtInternacaoDados.motivoSaidaInternacao;
      --
      vTissGuia.cd_cid                    := vCtInternacaoDados.diagnostico; --vcAtendimento.cd_cid;
    --
    -- ATEN真真O:  a CT filha "vCtInternacaoDados.declaracoes" 真 inclu真da ap真s grava真真o da guia (mais abaixo, pois 真 tabela filha);
    --
    end if;
    --
    --
    -- observacao--------------------------------------
    vCp := 'observacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        --
        if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_OBS_JUSTIFIC_MED_RI',pCdConv,null) = 'O' then --O - Observacao da tela de guias
          if nvl(vcAutorizacao.cd_guia,0)<>vcAtendimento.cd_guia then
            open  cAutorizacao(vcAtendimento.cd_guia,null);
            fetch cAutorizacao into vcAutorizacao;
            close cAutorizacao;
          end if;
          --
          vTemp := substr(vcAutorizacao.ds_observacao,1,1000);
          --
        elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_OBS_JUSTIFIC_MED_RI',pCdConv,null) = 'J' then --J - Justificativa da tela de guias
          if nvl(vcAutorizacao.cd_guia,0)<>vcAtendimento.cd_guia then
            open  cAutorizacao(vcAtendimento.cd_guia,null);
            fetch cAutorizacao into vcAutorizacao;
            close cAutorizacao;
          end if;
          --
          vTemp := substr(vcAutorizacao.ds_justificativa,1,1000);
          --
        elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_OBS_JUSTIFIC_MED_RI',pCdConv,null) = 'A' then --A - Informa真真o/Observacao do atendimento
          if nvl(vcAtendimentoAUX.cd_atendimento,0)<>pCdAtend then
            open cAtendimentoAUX(pCdAtend);
            fetch cAtendimentoAUX into vcAtendimentoAUX;
            close cAtendimentoAUX;
          end if;
          --
          vTemp := substr(vcAtendimentoAUX.ds_info_atendimento,1,1000); -- ???
          --
        end if;
        --
    --cafl
        vTemp := replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                   vTemp
                 ,'3.02.00','3-02-00')
                 ,'3.02.01','3-02-01')
                 ,'3.02.02','3-02-02')
                 ,'3.03.00','3-03-00')
                 ,'3.03.01','3-03-01')
                 ,'3.03.02','3-03-02')
                 ,'3.03.03','3-03-03')
                 ,'3.04.00','3-04-00')
                 ,'3.04.01','3-04-01')
                 ,'3.05.00','3-05-00')
                 ,'4.00.00','4-00-00')
                 ,'4.00.01','4-00-01')
                 ,'4.01.00','4-01-00');
      vTissGuia.DS_OBSERVACAO := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
    end if;
    --

    -- assinaturaDigital-------------------------------
    --vRet := F_assinaturaDigital(null,9999,null,null,null,null,null,null);
    --
    -- GRAVA真真O DO REGISTRO DA GUIA--------------------
    --
    -- informa真真es complementares de apoio
     vTissGuia.cd_versao_tiss_gerada := vcConv.cd_versao_tiss;
    vTissGuia.cd_convenio := pCdConv;
    vTissGuia.cd_atendimento := pCdAtend;
    vTissGuia.dt_validade := vcPaciente.dt_validade_carteira;
    vTissGuia.cd_reg_fat := pCdConta;
    vTissGuia.cd_remessa := vcConta.cd_remessa;
    vTissGuia.nm_autorizador_conv := 'P';
    vTissGuia.sn_tratou_retorno := 'N';
    if FNC_CONF('TP_NR_GUIA_PREST_RI',pCdConv,null) = '5' and vTissGuia.NR_GUIA_OPERADORA is not null then
      vTissGuia.NR_GUIA := vTissGuia.NR_GUIA_OPERADORA;
    end if;
    --
    -- Grava真真o
    vResult := F_gravaTissGuia('INSERE','RI',vTissGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
    -- ctm_internacaoDadosSaida------------------------
    vRet := F_ctm_internacaoDadosSaida(null,1068,pCdAtend,pCdConta,vCtInternacaoDadosSaida,pMsg,null);
    if vRet = 'OK' then
        FOR K in 1..nvl(vCtInternacaoDadosSaida.diagnostico.Last,0) LOOP
          vTissItGuiaCid.ID_PAI               := vTissGuia.ID;
          vTissItGuiaCid.TP_CID               := vCtInternacaoDadosSaida.diagnostico(K).TP_CID;
          vTissItGuiaCid.CD_CID               := vCtInternacaoDadosSaida.diagnostico(K).CD_CID;
          vTissItGuiaCid.DS_CID               := vCtInternacaoDadosSaida.diagnostico(K).DS_CID;
          -- Grava真真o
          vRet := F_gravaTissItGuiaCid (null,vTissItGuiaCid,pMsg,null);
          if pMsg is not null then
            RETURN NULL;
          end if;
          --
        END LOOP;
    end if;
    ---------------------------------------------------
    -- dadosInternacao
    -- ctm_internacaoDados
    -- declaracoes-------------------------------------
  -- verificar, pois o relatorio ve a tiss_itguia_obito
    for k in 1..nvl(vCtInternacaoDados.declaracoes.last,0) LOOP
      vTissItGuiaDecl.ID_PAI                    := vTissGuia.ID;
      vTissItGuiaDecl.CD_DECL_NASCIDOS_VIVOS    := vCtInternacaoDados.declaracoes(k).declaracaoNascido;
      vTissItGuiaDecl.CD_CID_OBITO              := vCtInternacaoDados.declaracoes(k).diagnosticoObito;
      vTissItGuiaDecl.CD_DECLARACAO_OBITO       := vCtInternacaoDados.declaracoes(k).declaracaoObito;
      vTissItGuiaDecl.CD_INDICADOR_DO_RN        := vCtInternacaoDados.declaracoes(k).indicadorDORN;
      vRet := F_gravaTissItGuiaDecl (null,vTissItGuiaDecl,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
    end loop;
    --
    -- procedimentosExecutados
    -- ct_procedimentoExecutadoInt-----------------------------
    --

    OPEN  cTissRI_Proc(pCdAtend,pCdConta,null);
    --
    LOOP
      --
      vGerandoGuia := 'N';
      FETCH cTissRI_Proc into vcTissRI_Proc;
      vGerandoGuia := 'S';
      EXIT WHEN cTissRI_Proc%NOTFOUND;
      --
      if cTissRI_Proc%FOUND THEN
        if fnc_conf('TP_TOTALIZA_RES_INT',pCdConv,null) <> 'N'
          and Nvl(vcTissRI_Proc.data,'X')                 = nvl(vTissItGuia.DT_REALIZADO,'X')
          and Nvl(vcTissRI_Proc.hr_ini,'X')               = nvl(vTissItGuia.HR_INICIO,'X')
          and Nvl(vcTissRI_Proc.hr_fim,'X')               = nvl(vTissItGuia.HR_FIM,'X')
          and Nvl(vcTissRI_Proc.cod_proc,'X')             = nvl(vTissItGuia.CD_PROCEDIMENTO,'X')
          and Nvl(vcTissRI_Proc.ds_proc,'X')              = nvl(vTissItGuia.DS_PROCEDIMENTO,'X')
          and Nvl(vcTissRI_Proc.vl_perc_reduc_acres,'X')  = nvl(vTissItGuia.VL_PERCENTUAL_MULTIPLA,'X')
          and Nvl(vcTissRI_Proc.tp_pagamento,'X')         = nvl(vTissItGuia.TP_PAGAMENTO,'X') -- +tp_pagamento(???, reordenar ctiss se preciso)
          and
             (
               nvl(vCTProcInt.identificacaoEquipe.Last,0)=0
               or
               (Nvl(vCTProcInt.identificacaoEquipe.Last,0) = 1 AND Nvl(vCTProcInt.identificacaoEquipe(1).cd_prestador,0) = vcTissRI_Proc.cd_prestador_equ )
              )
          then
          pModoIt := 'ATUALIZA_TOTAIS';
        else
          pModoIt := 'INSERE';
          TotAgrupItRI.quantidade := 0; TotAgrupItRI.valortotal := 0; -- zera acumulador de agrupamento
        end if;
        --
        vGerandoGuia := vGerandoGuia||vcTissRI_Proc.cod_proc;
        --
        -- insert
        vRet := F_ct_procedimentoExecutadoInt(null,1072,pCdAtend,pCdConta,vcTissRI_Proc.cd_lanc,vcTissRI_Proc.cd_itlan_med,vCTProcInt,pMsg,null);
        if vRet = 'OK' then
          vTissItGuia.ID_PAI                    := vTissGuia.ID;
          vTissItGuia.SQ_ITEM                   := vCTProcInt.sequencialItem;
          vTissItGuia.DT_REALIZADO              := vCTProcInt.dataExecucao;
          vTissItGuia.HR_INICIO                 := vCTProcInt.horaInicial;
          vTissItGuia.HR_FIM                    := vCTProcInt.horaFinal;
          vTissItGuia.TP_TAB_FAT                := vCTProcInt.procedimento.codigoTabela;
          vTissItGuia.CD_PROCEDIMENTO           := vCTProcInt.procedimento.codigoProcedimento;
          vTissItGuia.DS_PROCEDIMENTO           := vCTProcInt.procedimento.descricaoProcedimento;
          vTissItGuia.QT_REALIZADA              := vCTProcInt.quantidadeExecutada;
          vTissItGuia.CD_VIA_ACESSO             := vCTProcInt.viaAcesso;
          vTissItGuia.TP_TECNICA_UTILIZADA      := vCTProcInt.tecnicaUtilizada;
          vTissItGuia.VL_PERCENTUAL_MULTIPLA    := vCTProcInt.reducaoAcrescimo;
          vTissItGuia.VL_UNITARIO               := vCTProcInt.valorUnitario;
          vTissItGuia.VL_TOTAL                  := vCTProcInt.valorTotal;
          -- informa真真es complementares de apoio
          vTissItGuia.CD_PRO_FAT    := vcTissRI_Proc.cd_pro_fat;
          vTissItGuia.TP_PAGAMENTO  := vcTissRI_Proc.tp_pagamento;
          --OSWALDO IN真CIO
          vTissItGuia.cd_mvto       := vcItemAux.cd_mvto;
          vTissItGuia.tp_mvto       := vcItemAux.tp_mvto;
          vTissItGuia.cd_itmvto     := vcItemAux.cd_itmvto;
          vTissItGuia.sn_principal  := Nvl(vTissItGuia.sn_principal,'N');

          IF vTissItGuia.tp_mvto = 'Imagem' AND  bImagemPrincipal THEN
             bImagemPrincipal:= FALSE;
             vTissItGuia.sn_principal  := 'S';
          elsIF vTissItGuia.tp_mvto = 'SADT' and  bSADTPrincipal THEN
             bSADTPrincipal:= FALSE;
             vTissItGuia.sn_principal  := 'S';
          elsIF vTissItGuia.tp_mvto = 'Cirurgia'  AND   vcItemAux.sn_principal = 'S' THEN
             vTissItGuia.sn_principal  := 'S';
          elsIF vTissItGuia.tp_mvto = 'Atendimento'  AND  bAtendimentoPrincipal THEN
             bAtendimentoPrincipal:= FALSE;
             vTissItGuia.sn_principal  := 'S';
          elsIF vTissItGuia.tp_mvto = 'Prescricao' and   bPrescricaoPrincipal THEN
             bPrescricaoPrincipal := FALSE;
             vTissItGuia.sn_principal  := 'S';
          END IF;
          --OSWALDO FIM
          -- Grava真真o
          vRet := F_gravaTissItGuia (pModoIt,'RI',vTissItGuia,pMsg,null);
          if pMsg is not null then
            RETURN null;
          end if;
          -- Concilia真真o
          vRet := F_concilia_id_it_envio('ITREG_FAT',vTissItGuia.ID,pCdAtend,pCdConta,vcTissRI_Proc.cd_lanc,null,null,pMsg,null);
          if pMsg is not null then
            RETURN null;
          end if;
          --
          if pModoIt = 'INSERE' then -- s真 gera equipe se n真o tiver equipe ou apenas no primeiro item se tiver
            FOR K in 1..nvl(vCTProcInt.identificacaoEquipe.Last,0) LOOP
              vTissItGuiaEqu.ID_PAI               := vTissItGuia.ID;
              vTissItGuiaEqu.CD_ATI_MED           := vCTProcInt.identificacaoEquipe(K).grauPart;
              vTissItGuiaEqu.CD_OPERADORA         := vCTProcInt.identificacaoEquipe(K).codigoPrestadorNaOperadora;
              vTissItGuiaEqu.CD_CPF               := vCTProcInt.identificacaoEquipe(K).cpfContratado;
              vTissItGuiaEqu.NM_PRESTADOR         := vCTProcInt.identificacaoEquipe(K).nomeProf;
              vTissItGuiaEqu.DS_CONSELHO          := vCTProcInt.identificacaoEquipe(K).conselho;
              vTissItGuiaEqu.DS_CODIGO_CONSELHO   := vCTProcInt.identificacaoEquipe(K).numeroConselhoProfissional;
              vTissItGuiaEqu.UF_CONSELHO          := vCTProcInt.identificacaoEquipe(K).UF;
              vTissItGuiaEqu.CD_CBOS              := vCTProcInt.identificacaoEquipe(K).CBOS;
              --OSWALDO
              vTissItGuiaEqu.SQ_REF               := vCTProcInt.sequencialItem;
              -- Grava真真o
              vRet := F_gravaTissItGuiaEqu ('RI',vTissItGuiaEqu,pMsg,null);
              if pMsg is not null then
                close cTissRI_Proc;
                RETURN null;
              end if;
              -- Concilia真真o
              vRet := F_concilia_id_it_envio('ITLAN_MED',vTissItGuia.ID,pCdAtend,pCdConta,vcTissRI_Proc.cd_lanc,vcTissRI_Proc.cd_itlan_med,null,pMsg,null);
              if pMsg is not null then
                RETURN null;
              end if;
            END LOOP;
          end if;
        end if;
      end if;
      --
    END LOOP;
    --
    vGerandoGuia := SubStr(vGerandoGuia,1,1);
    --
    close cTissRI_Proc;
    --
    -- outrasDespesas
    -- ct_outrasDespesas---------------------------------------
    OPEN  cTissOutDesp('I',pCdAtend,pCdConta,null,null,null);
    --
    LOOP
      --
      vGerandoGuia := 'N';
      FETCH cTissOutDesp into vcTissOutDesp;
      vGerandoGuia := 'S';
      EXIT WHEN cTissOutDesp%NOTFOUND;
      --
      if cTissOutDesp%FOUND then
        --
        if fnc_conf('TP_TOTALIZA_OUTRAS_DESP',pCdConv,null) <> 'N'
          and Nvl(vcTissOutDesp.data,'X')                 = nvl(vTissItGuiaOut.DT_REALIZADO,'X')
          and Nvl(vcTissOutDesp.hr_ini,'X')               = nvl(vTissItGuiaOut.HR_INICIO,'X')
          and Nvl(vcTissOutDesp.hr_fim,'X')               = nvl(vTissItGuiaOut.HR_FIM,'X')
          and Nvl(vcTissOutDesp.cod_proc,'X')             = nvl(vTissItGuiaOut.CD_PROCEDIMENTO,'X')
          and Nvl(vcTissOutDesp.ds_proc,'X')              = nvl(vTissItGuiaOut.DS_PROCEDIMENTO,'X')
          and Nvl(vcTissOutDesp.vl_perc_reduc_acres,'X')  = nvl(vTissItGuiaOut.VL_PERCENTUAL_MULTIPLA,'X')
          then
          pModoOut := 'ATUALIZA_TOTAIS';
        else
          pModoOut := 'INSERE';
          TotAgrupDesp.quantidade := 0; TotAgrupDesp.valortotal := 0; -- zera acumulador de agrupamento
        end if;
        --
        vGerandoGuia := vGerandoGuia||vcTissOutDesp.cod_proc;
        --
        -- sequencialItem -------------------------------------
        vCp := 'sequencialItem'; vTemp := null;
        IF tconf.EXISTS(vCp) AND tConf(vCp).tp_utilizacao>0 then --OSWALDO
          -- Continua de onde o nSqItem parou
          IF nSqItemOut = 0 THEN
            nSqItemOut:= nSqItem;
          END IF;
          nSqItemOut:= nSqItemOut + 1;
          vTemp := nSqItemOut;
          vTissItGuiaOut.sq_item := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,null);
        end if;
        --
        -- codigoDespesa---------------------------------------
        vCp := 'codigoDespesa'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
            if vcTissOutDesp.cd_pro_fat <> nvl(vcProFat.cd_pro_fat,'X') then
              open  cProFat(vcTissOutDesp.cd_pro_fat);
              fetch cProFat into vcProFat;
              close cProFat;
            end if;
            if vcTissOutDesp.cd_pro_fat <> nvl(vcProFatAux.cd_pro_fat,'X') then
              open  cProFatAux(vcTissOutDesp.cd_pro_fat, null);
              fetch cProFatAux into vcProFatAux;
              close cProFatAux;
            end if;
            vTussRel := null;
            vRet  := F_DM(25,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,vTussRel,vTuss,pMsg,null);
            vTemp := vTuss.CD_TUSS;
          vTissItGuiaOut.TP_DESPESA := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,null);   -- dm_outrasDespesas
        end if;
        --
        vRet := F_ct_procedimentoExecutadoOutr(null,1108,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,'RI',vCTOutDesp,pMsg,vTissItGuiaOut.TP_DESPESA);
        if vRet = 'OK' then
          vTissItGuiaOut.ID_PAI                 := vTissGuia.ID;
          vTissItGuiaOut.DT_REALIZADO           := vCTOutDesp.dataExecucao;
          vTissItGuiaOut.HR_INICIO              := vCTOutDesp.horaInicial;
          vTissItGuiaOut.HR_FIM                 := vCTOutDesp.horaFinal;
          vTissItGuiaOut.TP_TAB_FAT             := vCTOutDesp.codigoTabela;
          vTissItGuiaOut.CD_PROCEDIMENTO        := vCTOutDesp.codigoProcedimento;
          vTissItGuiaOut.QT_REALIZADA           := vCTOutDesp.quantidadeExecutada;
          vTissItGuiaOut.CD_UNIDADE_MEDIDA      := vCTOutDesp.unidadeMedida;
          vTissItGuiaOut.VL_PERCENTUAL_MULTIPLA := vCTOutDesp.reducaoAcrescimo;
          vTissItGuiaOut.VL_UNITARIO            := vCTOutDesp.valorUnitario;
          vTissItGuiaOut.VL_TOTAL               := vCTOutDesp.valorTotal;
          vTissItGuiaOut.DS_PROCEDIMENTO        := vCTOutDesp.descricaoProcedimento;
          vTissItGuiaOut.CD_REGISTRO_ANVISA     := vCTOutDesp.registroANVISA;
          vTissItGuiaOut.CD_CODIGO_FABRICANTE   := vCTOutDesp.codigoRefFabricante;
          vTissItGuiaOut.NR_AUTORIZACAO         := vCTOutDesp.autorizacaoFuncionamento;
          --
          --OSWALDO IN真CIO
          -- itemVinculado-------------------------------------
          vCp := 'itemVinculado'; vTemp := null;
          IF tconf.EXISTS(vCp) AND tConf(vCp).tp_utilizacao>0 then
            vTemp := vCTOutDesp.itemVinculado;
            vTissItGuiaOut.SQ_REF := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,null);
          end if;
          --OSWALDO FIM
          --
          -- informa真真es complementares de apoio
          vTissItGuiaOut.CD_PRO_FAT             := vcTissOutDesp.cd_pro_fat;
          -- Grava真真o
          vRet := F_gravaTissItGuiaOut (pModoOut,'RI',vTissItGuiaOut,pMsg,null);
          if pMsg is not null then
            close cTissOutDesp;
            RETURN null;
          end if;
          -- Concilia真真o
          vRet := F_concilia_id_it_envio('ITREG_FAT',vTissItGuiaOut.ID,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,null,pMsg,null);
          if pMsg is not null then
            RETURN null;
          end if;
          --
        end if;
      end if;
      --
    END LOOP;
    --
    vGerandoGuia := SubStr(vGerandoGuia,1,1);
    --
    close cTissOutDesp;
    --
    -- valorTotal----------------------------------------------
    vRet := F_ct_guiaValorTotal(null,1098,vTissGuia.ID,pCdAtend,pCdConta,pCdConv,vCtVlTotal,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.VL_TOT_SERVICOS         := vCtVlTotal.valorProcedimentos;
      vTissGuia.VL_TOT_DIARIAS          := vCtVlTotal.valorDiarias;
      vTissGuia.VL_TOT_TAXAS            := vCtVlTotal.valorTaxasAlugueis;
      vTissGuia.VL_TOT_MATERIAIS        := vCtVlTotal.valorMateriais;
      vTissGuia.VL_TOT_MEDICAMENTOS     := vCtVlTotal.valorMedicamentos;
      vTissGuia.VL_TOT_OPME             := vCtVlTotal.valorOPME;
      vTissGuia.VL_TOT_GASES            := vCtVlTotal.valorGasesMedicinais;
      vTissGuia.VL_TOT_GERAL            := vCtVlTotal.valorTotalGeral;
      vTissGuia.VL_TOTAL_GERAL_OUTRAS   := vCtVlTotal.valorTotalGeralDesp;
      -- Grava真真o
      vRet := F_gravaTissGuia('ATUALIZA_TOTAIS','RI',vTissGuia,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
      --
    end if;
    --
    vRet := F_gravaTissGuia('ATUALIZA_INCONSISTENCIA','RI',vTissGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
  end if;
  --
  vGerandoGuia := 'N';
  --
  if pMsg is NULL then
    RETURN vResult;
  else
    RETURN NULL;
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_procedimentoDados(   pModo       in varchar2,
                                    pIdMap      in number,
                                    pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                    pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                    pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                    pCdItLan    in varchar2,
                                    pCdProFat   in dbamv.pro_fat.cd_pro_fat%type,
                                    pCdConv     in dbamv.convenio.cd_convenio%type,
                                    pTpGuia     in varchar2,
                                    vCt         OUT NOCOPY RecProcDados,
                                    pMsg        OUT varchar2,
                                    pReserva    in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  pCdProFatTmp  dbamv.pro_fat.cd_pro_fat%type;
  vCp	        varchar2(1000);
  vTussRel      RecTussRel;
  vTuss         RecTuss;
  vcTipoSetor   cTipoSetor%rowtype;
  pcdTipTuss    NUMBER; --Oswaldo FATURCONV-18980
  --
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdLanc is not null then
      if pCdAtend||pCdConta||pCdLanc||pCdItLan <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento||vcItem.cd_ati_med, 'XXXX') then
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
        fetch cItem into vcItem;
        close cItem;
      end if;
    end if;
  end if;
  ------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(pCdConv,nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
  pCdProFatTmp  :=  nvl(pCdProFat,vcItem.cd_pro_fat);
  ------------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ct_procedimentoDados').tp_utilizacao > 0 then
    --
    vTussRel.cd_convenio := pCdConvTmp;
    vTussRel.cd_pro_fat  := pCdProFatTmp;
  --vTussRel.cd_multi_empresa := dbamv.pkg_mv2000.le_empresa;
    vTussRel.cd_multi_empresa := nEmpresaLogada; --adhospLeEmpresa
    --
    --Oswaldo FATURCONV-18980 inicio
    IF pTpGuia = 'SOL_OPME' THEN
      pcdTipTuss := 19;
    ELSE
      pcdTipTuss := 22;
    END IF;
    --Oswaldo FATURCONV-18980 fim
    vTemp := F_DM(pcdTipTuss,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null); --Oswaldo FATURCONV-18980
    if pMsg is not null or vTuss.cd_tuss is null then
      vcProFat := null;

        open  cProFat(pCdProFatTmp);
        fetch cProFat into vcProFat;
        close cProFat;

    end if;
    --
    -- codigoTabela-------------------------------------
    vCp := 'codigoTabela'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      vTemp := vTuss.CD_TIP_TUSS;
      vCt.codigoTabela := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);    -- dm_tabela
      vResult := vCt.codigoTabela;
    end if;
    --
    -- codigoProcedimento-------------------------------
    vCp := 'codigoProcedimento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vTuss.CD_TUSS is not null then
          vTemp := vTuss.CD_TUSS;
        else
          vTemp := vcProFat.cd_pro_fat; --senao tiver o relacionamento novo
        end if;
      vCt.codigoProcedimento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.codigoProcedimento;
    end if;
    --
    -- descricaoProcedimento----------------------------
    vCp := 'descricaoProcedimento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      if ((pTpGuia = 'RI' and nvl(fnc_conf('TP_DESCR_PROC_RI',pCdConvTmp,null),'01')= '01')
       or (pTpGuia = 'SP' and nvl(fnc_conf('TP_DESCR_PROC_SP',pCdConvTmp,null),'01')= '01')
       or Nvl(pTpGuia,'X') NOT IN ('RI','SP')) then
        if vTuss.DS_TUSS is not null then
          vTemp := substr(vTuss.DS_TUSS,1,70); -- PENDENTE, limita真真o coluna TISS_ITSOL_GUIA nao comporta st_texto150
        else
          vTemp := vcProFat.ds_pro_fat; --quando nao tem relacionamento
        end if;
      elsif ((pTpGuia = 'RI' and nvl(fnc_conf('TP_DESCR_PROC_RI',pCdConvTmp,null),'01')= '02')
        or   (pTpGuia = 'SP' and nvl(fnc_conf('TP_DESCR_PROC_SP',pCdConvTmp,null),'01')= '02')) then
        if nvl(vcAprTiss.cd_apr_tiss, 0) = 0 then
          open  cAprTiss(NULL);
          fetch cAprTiss into vcAprTiss;
          close cAprTiss;
        end if;
        vcTipoSetor := null;
        open  cTipoSetor( vcAprTiss.cd_apr_tiss, vcItem.cd_setor);
        fetch cTipoSetor into vcTipoSetor;
        close cTipoSetor;
        --
        vTemp := vcTipoSetor.CD_SETOR_MEIO_MAG||'#'||NVL(vTuss.DS_TUSS,vcProFat.ds_pro_fat);
        --
      END IF;
      vCt.descricaoProcedimento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.descricaoProcedimento;
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_identEquipe( pModo       in varchar2,
                            pIdMap      in number,
                            pCdAtend    in dbamv.atendime.cd_atendimento%type,
                            pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                            pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                            pCdItLan    in varchar2,
                            vCt         OUT NOCOPY tableEquipe,
                            pMsg        OUT varchar2,
                            pReserva    in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	        varchar2(1000);
  nCount        number := 0;
  --
  vTussRel      RecTussRel;
  vTuss         RecTuss;
  --
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdLanc is not null then
      if pCdAtend||pCdConta||pCdLanc||pCdItLan <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento||pCdItLan, 'XXXX') then
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
        fetch cItem into vcItem;
        close cItem;
      end if;
    end if;
    --
    if vcConv.cd_convenio<>nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd) then
      open  cConv(nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
      fetch cConv into vcConv;
      close cConv;
    end if;
  --
  end if;
  --------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  --------------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ct_identEquipe').tp_utilizacao > 0 then
    --
    FOR vcTissEquipe in (select cd_prestador, cd_ati_med, nvl(tp_pagamento,'P') tp_pagamento
                            from dbamv.itlan_med
                            where cd_reg_fat = pCdConta
                              and cd_lancamento = pCdLanc
                              and (pCdItLan is null or (pCdItLan is not null and cd_ati_med = pCdItLan))
                              and F_ret_sn_equipe('RI',pCdAtend,pCdConta,pCdLanc,nvl(pCdItLan,cd_ati_med),null) = 'S'
                              AND ((dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_EQUIPE_RI',pCdConvTmp,NULL)='1' AND ROWNUM = 1)
                                   OR dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_EQUIPE_RI',pCdConvTmp,NULL)<>'1')
                              AND id_it_envio IS null
                         union all
                         select vcItem.cd_prestador, vcItem.cd_ati_med, vcItem.tp_pagamento
                            from sys.dual
                            where vcItem.cd_prestador_item is not null
                            and F_ret_sn_equipe('RI',pCdAtend,pCdConta,pCdLanc,null,null) = 'S'
                         order by cd_ati_med)
      LOOP
      --
      nCount := nCount + 1; -- contador de elementos v真lidos da equipe;
      --
      if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>vcTissEquipe.cd_prestador||pCdConvTmp then
        vcPrestador := null;
        open  cPrestador(vcTissEquipe.cd_prestador,null, pCdConvTmp, NULL , vcItem.cd_con_pla); -- pda FATURCONV-1372
        fetch cPrestador into vcPrestador;
        close cPrestador;
      end if;
      --
      -- grauPart-----------------------------------------
      vCp := 'grauPart'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
        --
        vTussRel := null;
        vTemp := F_DM(35,pCdAtend,pCdConta,pCdLanc,vcTissEquipe.cd_ati_med,vTussRel,vTuss,pMsg,null);
        --
        vTemp := vTuss.CD_TUSS;
        vCt(nCount).grauPart := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);  -- dm_grauPart
        vResult := vCt(nCount).grauPart;
      end if;
      --
      FOR I in 1..2 LOOP -- os 2 campos abaixo s真o CHOICE ===================
        --
        -- codigoPrestadorNaOperadora---------------------
        vCp := 'codigoPrestadorNaOperadora'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I THEN
			--PROD-2542 - so vai gerar se o credenciamento estiver ativo ou com a configuracao ativa
          if vcPrestador.sn_ativo_credenciamento = 'S' OR nvl(fnc_conf('TP_CONDICAO_CREDENC_PROF_EQ_RI',pCdConvTmp,null),'1') = '3' then
            vTemp := vcPrestador.cd_prestador_conveniado;
          else
            vTemp := NULL;
          end if;

			  if nvl(fnc_conf('TP_CONDICAO_CREDENC_PROF_EQ_RI',pCdConvTmp,null),'1') = '2' and vcTissEquipe.tp_pagamento<>'C' then
              vTemp := null; -- s真 gera se o servi真o for credenciado nesta condi真真o
            end if;
            IF vTemp IS NULL then
              IF fnc_conf('SN_COD_HOSP_PROF_N_CRED_EQ_RI',pCdConvTmp,null)='S' THEN
                if NVL(vcEmpresaConv.cd_multi_empresa||vcEmpresaConv.cd_convenio,'XX') <> nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa)||pCdConvTmp then
                  open  cEmpresaConv(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa), pCdConvTmp);
                  fetch cEmpresaConv into vcEmpresaConv;
                  close cEmpresaConv;
                END IF;
                vTemp := vcEmpresaConv.cd_hospital_no_convenio;
              END IF;
            end if;
          vCt(nCount).codigoPrestadorNaOperadora := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
          vResult := vCt(nCount).codigoPrestadorNaOperadora;
          EXIT when vCt(nCount).codigoPrestadorNaOperadora is NOT null;
        end if;
        --
        -- cpfContratado----------------------------------
        vCp := 'cpfContratado'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I THEN
          if length(vcPrestador.nr_cpf_cgc)<=11 then
            vTemp := vcPrestador.nr_cpf_cgc;
          end if;
          vCt(nCount).cpfContratado := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
          vResult := vCt(nCount).cpfContratado;
          EXIT when vCt(nCount).cpfContratado is NOT null;
        end if;
        --
      END LOOP; -- fim do CHOICE ================================
      --
      -- nomeProf-----------------------------------------
      vCp := 'nomeProf'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcPrestador.nm_prestador;
        vCt(nCount).nomeProf := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
        vResult := vCt(nCount).nomeProf;
      end if;
      --
      -- conselho-----------------------------------------
      vCp := 'conselho'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTussRel.CD_CONSELHO := vcPrestador.CD_CONSELHO;
        vTemp := F_DM(26,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
        vTemp := vTuss.CD_TUSS;
        vCt(nCount).conselho := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);  -- dm_conselhoProfissional
      end if;
      --
      -- numeroConselhoProfissional-----------------------
      vCp := 'numeroConselhoProfissional'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcPrestador.numero_conselho;
        vCt(nCount).numeroConselhoProfissional := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
        vResult := vCt(nCount).numeroConselhoProfissional;
      end if;
      --
      -- UF-----------------------------------------------
      vCp := 'UF'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcPrestador.uf_prestador;
        vCt(nCount).UF := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);    -- dm_UF
        vResult := vCt(nCount).UF;
      end if;
      --
      -- CBOS---------------------------------------------
      vCp := 'CBOS'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTussRel := null;
        vTussRel.CD_ESPECIALIDADE := vcPrestador.cd_especialid; --Possivel configuracao
        vTemp := F_DM(24,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
        vTemp := vTuss.CD_TUSS;
        vCt(nCount).CBOS := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);  -- dm_CBOS
        vResult := vCt(nCount).CBOS;
      end if;
    --
      -- informaes complementares de apoio
      vCt(nCount).cd_prestador := vcTissEquipe.cd_prestador;
	  --
    END LOOP;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_procedimentoExecutadoInt(    pModo       in varchar2,
                                            pIdMap      in number,
                                            pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                            pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                            pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                            pCdItLan    in varchar2,
                                            vCt         OUT NOCOPY RecProcInt,
                                            pMsg        OUT varchar2,
                                            pReserva    in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  vRet          varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	        varchar2(1000);
  vCtProcDados  RecProcDados;
  vCtEquipe     tableEquipe;
  nVlTemp       number;
  nVlAcresDesc  number;
  vcTipoProc    cTipoProc%rowtype;
  --
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdAtend||'-'||pCdConta||'-'||pCdLanc||'-'||pCdItLan <> nvl(vcItem.cd_atendimento||'-'||vcItem.cd_conta||'-'||vcItem.cd_lancamento||'-'||vcItem.cd_itlan_med, 'XXXX') THEN
      open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      fetch cItem into vcItem;
      close cItem;
    end if;
    if nvl(vcItemAux.cd_atendimento||vcItemAux.cd_conta||vcItemAux.cd_lancamento||vcItemAux.cd_itlan_med,'XXXX')<>pCdAtend||pCdConta||pCdLanc||pCdItLan then
      open  cItemAux(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      fetch cItemAux into vcItemAux;
      close cItemAux;
    end if;
    if vcItem.cd_pro_fat <> nvl(vcProFatAux.cd_pro_fat,'X') then
      open  cProFatAux(vcItem.cd_pro_fat, null);
      fetch cProFatAux into vcProFatAux;
      close cProFatAux;
    end if;
  end if;
  ------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  ------------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp, 'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ct_procedimentoExecutadoInt').tp_utilizacao > 0 then
    --
    -- sequencialItem -------------------------------------
    vCp := 'sequencialItem'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then --OSWALDO
      nSqItem:= nSqItem + 1;
      vTemp := nSqItem;
      vCt.sequencialItem := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.sequencialItem;
    end if;
    --
    -- dataExecucao-------------------------------------
    vCp := 'dataExecucao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if fnc_conf('TP_TOTALIZA_RES_INT',pCdConvTmp,null) = 'U' then --verifica se esta configurado para Agrupar em 真nica data (dt.in真cio da conta);
          vTemp := vcConta.dt_inicio;
        elsif fnc_conf('TP_TOTALIZA_RES_INT',pCdConvTmp,null) = 'L' then --verifica se esta configurado para Agrupar por dia de Lan真amento
          vTemp := vcItem.dt_lancamento;
        else
          --Opcao 1 - senao tiver agrupamento
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_RI',pCdConvTmp,null) = 'L' then    --Data do Lan真amento do Item
            vTemp := vcItem.dt_lancamento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_RI',pCdConvTmp,null) = 'A' then --Data do Atendimento
            vTemp := vcAtendimento.dt_atendimento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_RI',pCdConvTmp,null) = 'C' then --Data Inicio da Conta
            vTemp := vcConta.dt_inicio;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_RI',pCdConvTmp,null) = 'F' then --Data Fim da Conta
            vTemp := vcConta.dt_final;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_RI',pCdConvTmp,null) = 'H' then --Data da Alta (atendimento)
            vTemp := vcAtendimento.dt_alta;
          end if;
          --
          --Opcao 2
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_EXEC_COMPL_RI',pCdConvTmp,null) = 'C' then --Data inicio da cirurgia
            --
            if vcItemAux.dt_realizacao_cir is not null then
              vTemp := vcItemAux.dt_realizacao_cir;
            end if;
            --
          end if;
          --
        end if;
      --
      vCt.dataExecucao := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.dataExecucao;
    end if;
    --
    -- horaInicial--------------------------------------
    vCp := 'horaInicial'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if fnc_conf('TP_TOTALIZA_RES_INT',pCdConvTmp,null) <> 'N' AND FNC_CONF('TP_HR_INI_BASICO_RI',pCdConvTmp,null) <> 'N' then --verifica se esta configurado para Agrupar em 真nica data (dt.in真cio da conta);
          vTemp := vcConta.hr_inicio;
        else
          -- sem agrupamento
          --Opcao 1
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_RI',pCdConvTmp,null) = 'L' then    --Hora do Lan真amento do Item
            vTemp := vcItem.hr_lancamento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_RI',pCdConvTmp,null) = 'A' then --Hora do Atendimento
            vTemp := vcAtendimento.hr_atendimento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_RI',pCdConvTmp,null) = 'C' then --Hora Inicio da Conta
            vTemp := vcConta.hr_inicio;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_RI',pCdConvTmp,null) = 'F' then --Hora Fim da Conta
            vTemp := vcConta.hr_final;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_RI',pCdConvTmp,null) = 'H' then --Hora da Alta (atendimento)
            vTemp := vcAtendimento.hr_alta;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_RI',pCdConvTmp,null) = 'N' then    --N真o gera Hora
            vTemp := NULL;
          end if;
          --
          --Opcao 2
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_EXEC_COMPL_RI',pCdConvTmp,null) = 'C' then --Hora inicial da cirurgia
            if nvl(vcItemAux.cd_atendimento||vcItemAux.cd_conta||vcItemAux.cd_lancamento||vcItemAux.cd_itlan_med,'XXXX')<>pCdAtend||pCdConta||pCdLanc||pCdItLan then
              open  cItemAux(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
              fetch cItemAux into vcItemAux;
              close cItemAux;
            end if;
            --
            if vcItemAux.entrada_sala is not null then
              vTemp := vcItemAux.entrada_sala;
            end if;
            --
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_EXEC_COMPL_RI',pCdConvTmp,null) = 'E'
            and nvl(vcItem.sn_horario_especial,'N') = 'S' then --Hor真rio Especial
            vTemp := vcItem.hr_lancamento;
          end if;
          --
        end if;
        --
      vCt.horaInicial := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.horaInicial;
    end if;
    --
    -- horaFinal----------------------------------------
    vCp := 'horaFinal'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if fnc_conf('TP_TOTALIZA_RES_INT',pCdConvTmp,null) <> 'N' AND FNC_CONF('TP_HR_FIM_BASICO_RI',pCdConvTmp,null) <> 'N' then --verifica se esta configurado para Agrupar em 真nica data (dt.in真cio da conta);
          vTemp := vcConta.hr_inicio;
        else
          -- sem agrupamento
          --Opcao 1
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_RI',pCdConvTmp,null) = 'L' then    --Hora do Lan真amento do Item
            vTemp := vcItem.hr_lancamento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_RI',pCdConvTmp,null) = 'A' then --Hora do Atendimento
            vTemp := vcAtendimento.hr_atendimento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_RI',pCdConvTmp,null) = 'C' then --Hora Inicio da Conta
            vTemp := vcConta.hr_inicio;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_RI',pCdConvTmp,null) = 'F' then --Hora Fim da Conta
            vTemp := vcConta.hr_final;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_RI',pCdConvTmp,null) = 'H' then --Hora da Alta (atendimento)
            vTemp := vcAtendimento.hr_alta;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_RI',pCdConvTmp,null) = 'N' then    --N真o gera Hora
            vTemp := NULL;
          end if;
          --
          --Opcao 2
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_EXEC_COMPL_RI',pCdConvTmp,null) = 'C' then --Hora final da cirurgia
            if nvl(vcItemAux.cd_atendimento||vcItemAux.cd_conta||vcItemAux.cd_lancamento||vcItemAux.cd_itlan_med,'XXXX')<>pCdAtend||pCdConta||pCdLanc||pCdItLan then
              open  cItemAux(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
              fetch cItemAux into vcItemAux;
              close cItemAux;
            end if;
            --
            if vcItemAux.fim_cirurgia is not null then
              vTemp := vcItemAux.fim_cirurgia;
            end if;
            --
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_EXEC_COMPL_RI',pCdConvTmp,null) = 'E'
            and nvl(vcItem.sn_horario_especial,'N') = 'S' then --Hor真rio Especial
            vTemp := vcItem.hr_lancamento;
          end if;
          --
        end if;
        --
      vCt.horaFinal := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.horaFinal;
    end if;
    --
    -- procedimentosExecutados--------------------------
    IF pModo IS NULL then
      vRet := F_ct_procedimentoDados(null,1072,pCdAtend,pCdConta,pCdLanc,pCdItLan,null,null,'RI',vCtProcDados,pMsg,null);
      if vRet = 'OK' then
        vCt.procedimento.codigoTabela            := vCtProcDados.codigoTabela;            -- codigoTabela
        vCt.procedimento.codigoProcedimento      := vCtProcDados.codigoProcedimento;      -- codigoProcedimento
        vCt.procedimento.descricaoProcedimento   := vCtProcDados.descricaoProcedimento;   -- descricaoProcedimento
      end if;
    END IF;
    --
    -- quantidadeExecutada------------------------------
    vCp := 'quantidadeExecutada'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        nVlTemp := vcItem.qt_lancamento;
        if pModo is null then
          TotAgrupItRI.quantidade := TotAgrupItRI.quantidade + nVlTemp; -- acumulador em caso de agrupamento
          nVlTemp := TotAgrupItRI.quantidade;
        end if;
        vTemp := nVlTemp;   -- ???  PENDENTE, avaliar configura真真o de minutos p/ Gases
      vCt.quantidadeExecutada := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.quantidadeExecutada;
    end if;
    --
    -- viaAcesso----------------------------------------
    vCp := 'viaAcesso'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --FUTURO RELACIONAMENTO COM A TELA
        --vTussRel.vl_percentual_multipla := vcItem.vl_percentual_multipla;
        --vTemp := F_DM(61,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
        --vTemp := vTuss.CD_TUSS;
        if nvl(fnc_conf('TP_SERV_INFORMA_VIA_HOSP',pCdConvTmp,null),'1')>'1' then
          if nvl(vcAprTiss.cd_apr_tiss, 0) = 0 then
            open  cAprTiss(NULL);
            fetch cAprTiss into vcAprTiss;
            close cAprTiss;
          end if;
          open  cTipoProc( vcAprTiss.cd_apr_tiss, vcItem.cd_pro_fat);
          fetch cTipoProc into vcTipoProc;
          close cTipoProc;
        end if;
        if vcItem.cd_pro_fat <> nvl(vcProFat.cd_pro_fat,'X') then
          open  cProFat(vcItem.cd_pro_fat);
          fetch cProFat into vcProFat;
          close cProFat;
        end if;
        if (nvl(vcProFat.nr_auxiliar,0) >0 or vcProFat.cd_por_ane is not null)
           or (vcTipoProc.cd_pro_fat_vinculado is not null and Upper(vcTipoProc.cd_pro_fat_vinculado) = 'VIA') then
          if vcItem.vl_percentual_multipla = '50' then
            vTemp := '2';
          elsif vcItem.vl_percentual_multipla = '70' then
            vTemp := '3';
          else
            vTemp := '1';
          end if;
        end if;
      vCt.viaAcesso := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);   -- dm_viaDeAcesso
      vResult := vCt.viaAcesso;
    end if;
    --
    -- tecnicaUtilizada---------------------------------
    vCp := 'tecnicaUtilizada'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --FUTURO RELACIONAMENTO COM A TELA
        --vTemp := F_DM(48,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
        --vTemp := vTuss.CD_TUSS;
        if nvl(vcItemAux.cd_atendimento||vcItemAux.cd_conta||vcItemAux.cd_lancamento||vcItemAux.cd_itlan_med,'XXXX')<>pCdAtend||pCdConta||pCdLanc||pCdItLan then
          open  cItemAux(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
          fetch cItemAux into vcItemAux;
          close cItemAux;
        end if;
        if (nvl(vcProFat.nr_auxiliar,0)>0 or vcProFat.cd_por_ane is not null) then
          if nvl(vcItemAux.tp_tecnica_utilizada,'C') ='V' then
            vTemp := '2';
          elsif nvl(vcItemAux.sn_robotica,'N') = 'S' then
            vTemp := '3';
          else
            vTemp := '1';
          end if;
        end if;
      vCt.tecnicaUtilizada := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);    -- dm_tecnicaUtilizada
      vResult := vCt.tecnicaUtilizada;
    end if;
    --
    -- reducaoAcrescimo---------------------------------
    vCp := 'reducaoAcrescimo'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        nVlAcresDesc := vcItem.vl_percentual_multipla;
        --
        if nvl(fnc_conf('TP_PERC_ACRES_DESC_RI',pCdConvTmp,null),'1') in ('3','4') and vcConta.cd_tip_acom is not null then
          -- verifica se h真 configura真真o para representar % de acomoda真真o superior
          if vcItem.cd_regra||vcConta.cd_tip_acom||vcProFatAux.cd_gru_pro||vcItem.cd_pro_fat<>nvl(vcAcomod.cd_regra||vcAcomod.cd_tip_acom||vcAcomod.cd_gru_pro||vcAcomod.cd_pro_fat,'XXXX') then
            vcAcomod := null;
            open  cAcomod(vcItem.cd_regra,vcConta.cd_tip_acom,vcProFatAux.tp_gru_pro,vcProFatAux.cd_gru_pro,vcItem.cd_pro_fat);
            fetch cAcomod into vcAcomod;
            close cAcomod;
          end if;
          if vcAcomod.vl_percentual is not null AND vcAcomod.vl_percentual <> 100 AND Nvl(vcAcomod.vl_percentual,0) > 0 THEN
            nVlAcresDesc := vcAcomod.vl_percentual;
          end if;
        end if;
      --PROD-2892 - FATURCONV-4111 - Regra de percentual, de acordo com o acadastro de Atividade m真dica - opcao 5
        IF nvl(fnc_conf('TP_PERC_ACRES_DESC_RI',pCdConvTmp,null),'1') = '5' AND
           vcItem.cd_itlan_med IS NOT NULL -- so vai gerar se for equipe medica
        THEN
          --
          vcAtiMed := null;
          open  cAtiMed(vcItem.cd_itlan_med,null);
          fetch cAtiMed into vcAtiMed;
          close cAtiMed;
          --
          IF vcAtiMed.VL_PERCENTUAL_PAGO IS NOT NULL AND Nvl(vcItem.vl_percentual_multipla,0) > 0 then
            nVlAcresDesc := ( vcAtiMed.VL_PERCENTUAL_PAGO * vcItem.vl_percentual_multipla ) / 100 ;
          END IF;
        END IF;
        --
        -- verifica se h真 configura真真o para representar H.E. no Percentual (+30%) e soma ao j真 obtido se houver
        if nvl(fnc_conf('TP_PERC_ACRES_DESC_RI',pCdConvTmp,null),'1') IN ('2','4') and vcItem.sn_horario_especial = 'S' then
          --
          if vcItem.cd_regra||vcProFatAux.cd_gru_pro<>nvl(vcIndiceHE.cd_regra||vcIndiceHE.cd_gru_pro,'XX') then
            vcIndiceHE := null;
            open  cIndiceHE(vcItem.cd_regra,vcProFatAux.cd_gru_pro);
            fetch cIndiceHE into vcIndiceHE;
            close cIndiceHE;
          end if;
          if vcIndiceHE.vl_percentual is not null then
            nVlAcresDesc := nvl(nVlAcresDesc,100) + vcIndiceHE.vl_percentual;
          end if;
        end if;
        --
        vTemp := (nVlAcresDesc/100);
        --
      vCt.reducaoAcrescimo := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vTemp := vCt.reducaoAcrescimo;
      vResult := vCt.reducaoAcrescimo;
      nVlAcresDesc := To_Number(vCt.reducaoAcrescimo,'999.99')*100; -- Guarda percentual para c真lculo valor unit真rio qdo.agrupado
    end if;
    --
    -- valorUnitario------------------------------------
    -- Campo deslocado mais abaixo por quest真es t真cnicas de c真lculo
    --
    -- valorTotal---------------------------------------
    vCp := 'valorTotal'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        nVlTemp := vcItem.vl_total_conta;
        --
        if vcItem.sn_pertence_pacote = 'S' then
          nVlTemp := 0; -- Pertence Pacote, zera
        end if;
        --
        if vcItem.tp_pagamento = 'C' then -- zerar credenciados
          if fnc_conf('TP_ZERA_VALOR_CRED_RI',pCdConvTmp,null) = 'S' OR fnc_conf('TP_ZERA_VALOR_CRED_RI',pCdConvTmp,null)=substr(vcProFatAux.tp_gru_pro,2,1) then
            nVlTemp := 0;
          end if;
        end if;
        --
        if pModo is null then
          TotAgrupItRI.valortotal := TotAgrupItRI.valortotal + nVlTemp;
          nVlTemp := TotAgrupItRI.valortotal;
        end if;
        vTemp := nVlTemp;   -- ???  PENDENTE, analisar op真真es j真 existentes como zerar valores por op真真o, etc.
      vCt.valorTotal := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,pCdConvTmp);
      vResult := vCt.valorTotal;
    end if;
    --

	-- valorUnitario------------------------------------
    vCp := 'valorUnitario'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if nvl(fnc_conf('TP_VALOR_UNITARIO_RI',pCdConvTmp,null),'1') = '2' AND
           nvl(fnc_conf('TP_PERC_ACRES_DESC_RI',pCdConvTmp,null),'1') <> '5' --PROD-2892 - FATURCONV-4111 - Nao pode entrar se for a configuracao nova (nao gera calculo)
        then
          vTemp := ((TotAgrupItRI.valortotal/nvl(TotAgrupItRI.quantidade,1))/nvl(nVlAcresDesc/100,1) );
        else
          vTemp := (vcItem.vl_total_conta/vcItem.qt_lancamento);   -- ??? PENDENTE, analisar op真真es j真 existentes
        end if;
        --
        if vcItem.tp_pagamento = 'C' then -- zerar credenciados
          if fnc_conf('TP_ZERA_VALOR_CRED_RI',pCdConvTmp,null) = 'S' OR fnc_conf('TP_ZERA_VALOR_CRED_RI',pCdConvTmp,null)=substr(vcProFatAux.tp_gru_pro,2,1) then
            vTemp := 0;
          end if;
        end if;
      vCt.valorUnitario := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,pCdConvTmp);
      vResult := vCt.valorUnitario;
    end if;
    --
    -- identificacaoEquipe------------------------------
    IF pModo IS NULL then
      vRet := F_ct_identEquipe(null,1072,pCdAtend,pCdConta,pCdLanc,pCdItLan,vCtEquipe,pMsg,null);
      if vRet = 'OK' then
        vCt.identificacaoEquipe := vCtEquipe;
      end if;
    END IF;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
function F_ret_tp_grupro (  pCdAtend    in dbamv.atendime.cd_atendimento%type,
                            pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                            pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                            pCdProFat   in dbamv.pro_fat.cd_pro_fat%type,
                            pCdConv     in dbamv.convenio.cd_convenio%type,
                            pReserva    in varchar2    ) return varchar2 is
  --
  vResult	    varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  pCdProFatTmp  dbamv.pro_fat.cd_pro_fat%type;
  --
begin
  --
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdLanc is not null then
      if pCdAtend||pCdConta||pCdLanc <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento, 'XXX') then
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,null,null);
        fetch cItem into vcItem;
        close cItem;
      end if;
    end if;
  end if;
  -------------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(pCdConv,nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
  pCdProFatTmp  :=  nvl(pCdProFat,vcItem.cd_pro_fat);
  -------------------------------------------------------------
  if pCdProFatTmp <> nvl(vcProFatAux.cd_pro_fat,'X') then
    open  cProFatAux(pCdProFatTmp, null);
    fetch cProFatAux into vcProFatAux;
    close cProFatAux;
  end if;
  --
  if vcProFatAux.tp_gru_pro = 'SH' and vcProFatAux.tp_serv_hospitalar is null then
    vResult := 'SP'; -- pacote de servi真os
  else
    vResult := vcProFatAux.tp_gru_pro;
  end if;
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS then
      raise_application_error( -20001, pkg_rmi_traducao.extrair_pkg_msg('MSG_3', 'pkg_ffcv_tiss_v4', 'FALHA em f_ret_tp_grupro ', arg_list(SQLERRM)));
      RETURN NULL;
  --
end;
--
--==================================================
function F_ret_tp_pagamento (   pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                pCdItLan    in varchar2,
                                pTpGuia     in varchar2,
                                pReserva    in varchar2    ) return varchar2 is
  --
  vResult	    varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  --
  Cursor cContaEquipe is
    select tp_pagamento, TT_CRED,TT_GERAL
        from (select distinct tp_pagamento
                    ,count(1) over (partition by tp_pagamento) TT_CRED
                    ,count(1) over () TT_GERAL
                from dbamv.itlan_med
                where cd_reg_fat = pCdConta
                  and cd_lancamento = pCdLanc)
        where tp_pagamento = 'C';
  --
  vcContaEquipe  cContaEquipe%rowtype;
  --
begin
  --
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdLanc is not null then
      if pCdAtend||pCdConta||pCdLanc||pCdItLan <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento||vcItem.cd_itlan_med, 'XXXX') then
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
        fetch cItem into vcItem;
        close cItem;
      end if;
      if vcItem.cd_pro_fat <> nvl(vcProFat.cd_pro_fat,'X') then
        open  cProFat(vcItem.cd_pro_fat);
        fetch cProFat into vcProFat;
        close cProFat;
      end if;
    end if;
  end if;
  -------------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  -------------------------------------------------------------
  vResult := vcItem.tp_pagamento; -- FALTA AS REGRAS !!!!!!!!!!!
  --
  -- tem equipe, mas n真o selecionou nenhuma itlan_med.  Verificar se a equipe toda 真 Credenciada e for真ar o Tp_pagamento
  if ( nvl(vcProFat.nr_auxiliar,0) > 0 or vcProFat.cd_por_ane is not null) and vcItem.cd_prestador_item is null and pCdItLan is null then
    open  cContaEquipe;
    fetch cContaEquipe into vcContaEquipe;
    close cContaEquipe;
    if vcContaEquipe.TT_GERAL is not null then
      if vcContaEquipe.TT_GERAL = vcContaEquipe.TT_CRED then
        vcItem.tp_pagamento := 'C'; -- equipe s真 tem credenciados
      else
        vcItem.tp_pagamento := 'P'; -- equipe tem pelo menos 1 pagamento;
      end if;
    else
      vcItem.tp_pagamento := 'P';   -- N真o tem equipe, nem tp_pagamento (embora pro_fat indique), for真a "P";
    end if;
  end if;
  --
  -- Credenciados
  if (vcItem.tp_pagamento = 'C' or nvl(vcItem.cd_conta_pai,vcItem.cd_conta)<>vcItem.cd_conta)
    and pTpGuia in ('RI','SP','SPC') and (vcItem.cd_prestador IS NOT NULL or ((nvl(vcProFat.nr_auxiliar,0) >0 or vcProFat.cd_por_ane is not null)))then
    --
    if vcItem.cd_pro_fat <> nvl(vcProFatAux.cd_pro_fat,'X') then
      open  cProFatAux(vcItem.cd_pro_fat, null);
      fetch cProFatAux into vcProFatAux;
      close cProFatAux;
    end if;
    if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>vcItem.cd_prestador||pCdConvTmp then
      vcPrestador := null;
      open  cPrestador(vcItem.cd_prestador,null, pCdConvTmp, NULL ,vcItem.cd_con_pla); -- pda FATURCONV-1372
      fetch cPrestador into vcPrestador;
      close cPrestador;
    end if;
    --
    if pTpGuia = 'RI' then -- internacoes
      if    FNC_CONF('TP_SERV_CRED_PRINC_RI',pCdConvTmp,null) = '1'
        or (FNC_CONF('TP_SERV_CRED_PRINC_RI',pCdConvTmp,null) = '3' and vcProFatAux.tp_gru_pro<>'SP' )
        or (FNC_CONF('TP_SERV_CRED_PRINC_RI',pCdConvTmp,null) = '4' and vcProFatAux.tp_gru_pro<>'SD' )
        or (FNC_CONF('TP_SERV_CRED_PRINC_RI',pCdConvTmp,null) = '5' and vcProFatAux.tp_gru_pro in('SP','SD') and nvl(vcPrestador.tp_vinculo,'X')='J' )
        then
        vResult := 'N'; -- N真O GERA.
      else
        vResult := 'P'; -- GERAR, for真ar 'P' para gerar credenciado na guia principal

        if FNC_CONF('TP_GERA_CRED_SP_HOSP',pCdConvTmp,null) = '6' and substr(nvl(vcPrestador.cd_unidade_origem,'X'),1,4)='COOP' then
          vResult := 'N'; -- exceto se 真 um Terceirizado/Cooperativa, a真 n真o gera na principal e sim em guia pr真pria
        end if;
      end if;
    elsif pTpGuia = 'SP' then -- ambulatorial (guia Principal)
      if    FNC_CONF('TP_SERV_CRED_PRINC_SP',pCdConvTmp,null) = '1'
        or (FNC_CONF('TP_SERV_CRED_PRINC_SP',pCdConvTmp,null) = '3' and vcProFatAux.tp_gru_pro<>'SP' )
        or (FNC_CONF('TP_SERV_CRED_PRINC_SP',pCdConvTmp,null) = '4' and vcProFatAux.tp_gru_pro<>'SD' )
        or (FNC_CONF('TP_SERV_CRED_PRINC_SP',pCdConvTmp,null) = '5' and vcProFatAux.tp_gru_pro in('SP','SD') and nvl(vcPrestador.tp_vinculo,'X')='J' )
        then
        vResult := 'N'; -- N真O GERA.
      else
        vResult := 'P'; -- GERAR, for真ar 'P' para gerar credenciado na guia principal

        if FNC_CONF('TP_GERA_CRED_SP',pCdConvTmp,null) = '6' and substr(nvl(vcPrestador.cd_unidade_origem,'X'),1,4)='COOP' then
          vResult := 'N'; -- exceto se 真 um Terceirizado/Cooperativa, a真 n真o gera na principal e sim em guia pr真pria
        end if;
      end if;
    elsif pTpGuia = 'SPC' then -- Credenciados na SP (ambulatorial ou interna真真o)
      if vcAtendimento.tp_atendimento <> 'I' and
        ( FNC_CONF('TP_GERA_CRED_SP',pCdConvTmp,null) = '1'
        or (FNC_CONF('TP_GERA_CRED_SP',pCdConvTmp,null) = '3' and vcProFatAux.tp_gru_pro<>'SP' )
        or (FNC_CONF('TP_GERA_CRED_SP',pCdConvTmp,null) = '4' and vcProFatAux.tp_gru_pro<>'SD' )
        or (FNC_CONF('TP_GERA_CRED_SP',pCdConvTmp,null) = '5' and vcProFatAux.tp_gru_pro in('SP','SD') and nvl(vcPrestador.tp_vinculo,'X')<>'J' )

        or (FNC_CONF('TP_GERA_CRED_SP',pCdConvTmp,null) = '6' and substr(nvl(vcPrestador.cd_unidade_origem,'X'),1,4)<>'COOP' ) )
        then
        vResult := 'N'; -- N真O GERA.
      elsif vcAtendimento.tp_atendimento = 'I' and
        ( FNC_CONF('TP_GERA_CRED_SP_HOSP',pCdConvTmp,null) = '1'
        or (FNC_CONF('TP_GERA_CRED_SP_HOSP',pCdConvTmp,null) = '3' and vcProFatAux.tp_gru_pro<>'SP' )
        or (FNC_CONF('TP_GERA_CRED_SP_HOSP',pCdConvTmp,null) = '4' and vcProFatAux.tp_gru_pro<>'SD' )
        or (FNC_CONF('TP_GERA_CRED_SP_HOSP',pCdConvTmp,null) = '5' and vcProFatAux.tp_gru_pro in('SP','SD') and nvl(vcPrestador.tp_vinculo,'X')<>'J' )

        or (FNC_CONF('TP_GERA_CRED_SP_HOSP',pCdConvTmp,null) = '6' and substr(nvl(vcPrestador.cd_unidade_origem,'X'),1,4)<>'COOP' ) )
        then
        vResult := 'N'; -- N真O GERA.
      else
        vResult := 'C'; -- GERAR, for真ar 'C';
      end if;
    end if;
    --
  else
    if vcItem.tp_pagamento = 'C' and pTpGuia in ('DE','SPH') then
      vResult := 'C';
    else
      vResult := 'P'; -- GERAR, for真ar 'P';
    end if;
  end if;
  --
  -- Condi真真o especial: Faturamento de Empresa-Distribu真do (ex: Sta.Joana SP) nunca gera credenciado tipo "C" para empresas Filhas.
  if vcItem.tp_pagamento = 'C' and nvl(vcItem.cd_conta_pai,vcItem.cd_conta)<>vcItem.cd_conta then
    vResult := 'N'; -- N真O GERA.
  end if;
  --
  -- Se for item que o paciente paga (na tela, 真 o tp_pagamento = 'X'), n真o gera-se no Tiss (n真o 真 nem cobran真a do hospital nem pra credenciado)
  if vcItem.tp_pagamento = 'C' and vcItem.sn_paciente_paga = 'S' then
    vResult := 'N'; -- N真O GERA.
  end if;
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS then
      raise_application_error( -20001, pkg_rmi_traducao.extrair_pkg_msg('MSG_3', 'pkg_ffcv_tiss_v4', 'FALHA em f_ret_tp_pagamento ', arg_list(SQLERRM)));
      RETURN NULL;
  --
end;
--
--==================================================
function F_ret_sn_pertence_pacote ( pTpGuia     in varchar2,
                                    pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                    pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                    pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                    pCdItLan    in varchar2,
                                    pReserva    in varchar2    ) return varchar2 is
  --
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
begin
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdLanc is not null then
      if pCdAtend||pCdConta||pCdLanc <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento, 'XXX') then
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,null,null);
        fetch cItem into vcItem;
        close cItem;
      end if;
    end if;
  end if;
  -------------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  -------------------------------------------------------------
  vResult := vcItem.sn_pertence_pacote; -- orginal, default
  --
  if vcItem.sn_pertence_pacote='S' then
    --
    if vcItem.cd_pro_fat <> nvl(vcProFatAux.cd_pro_fat,'X') then
      open  cProFatAux(vcItem.cd_pro_fat, null);
      fetch cProFatAux into vcProFatAux;
      close cProFatAux;
    end if;
    --
    if pTpGuia = 'RI' and vcProFatAux.tp_gru_pro in ('SP','SD') then
      if fnc_conf('TP_GERA_ITENS_PACOTE_RI',pCdConvTmp,null)='S' OR (fnc_conf('TP_GERA_ITENS_PACOTE_RI',pCdConvTmp,null)='P' and vcProFatAux.tp_gru_pro = 'SP') then
        vResult := 'N';
      end if;
    elsif pTpGuia = 'SP' and vcProFatAux.tp_gru_pro in ('SP','SD') then
      if fnc_conf('TP_GERA_ITENS_PACOTE_SP',pCdConvTmp,null)='S' OR (fnc_conf('TP_GERA_ITENS_PACOTE_SP',pCdConvTmp,null)='P' and vcProFatAux.tp_gru_pro = 'SP') then
        vResult := 'N';
      end if;
    end if;
    --
  end if;
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS then
      raise_application_error( -20001, pkg_rmi_traducao.extrair_pkg_msg('MSG_3', 'pkg_ffcv_tiss_v4', 'FALHA em F_ret_sn_pertence_pacote ', arg_list(SQLERRM)));
      RETURN null;
  --
end;
--
--==================================================
     --   F_ct_procedimentoExecutadoOutras -- muito longo
FUNCTION  F_ct_procedimentoExecutadoOutr(   pModo       in varchar2,
                                            pIdMap      in number,
                                            pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                            pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                            pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                            pCdItLan    in varchar2,
                                            pTpGuia     in varchar2,
                                            vCt         OUT NOCOPY RecOutDesp,
                                            pMsg        OUT varchar2,
                                            pReserva    in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vTmpConf      varchar2(4000); --PROD-2893
  vResult       varchar2(1000);
  vRet          varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	          varchar2(1000);
  nVlTemp       number;
  vPesqUnid     varchar2(1000);
  --
  vTussRel      RecTussRel;
  vTuss         RecTuss;
  nVlTempCod    number;
  vcTipoSetor   cTipoSetor%rowtype;
  vCdTipTussTmp dbamv.tip_tuss.cd_tip_tuss%type;
  vcFornecedor  cFornecedor%rowtype;
  vcProdutoFornecedor   cProdutoFornecedor%rowtype;
  vcProduto     cProduto%rowtype;
  nVlAcresDesc  number;
  vUnidadeSubs  dbamv.regra_substituicao_proced.ds_unidade_xml%TYPE;    -- OP 44895

  itemVinculadoSeq  number;
  vItemCirurgVinc   number;
  vItemAtendVinc    number;

  pTP_ITEM_VINCULADO_RI VARCHAR2(2) := null;
  pTP_ITEM_VINCULADO_SP VARCHAR2(2) := null;

BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    --
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    --
    if pCdAtend||pCdConta||pCdLanc <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento, 'XXX') then
      open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,null,null);
      fetch cItem into vcItem;
      close cItem;
    end if;
    if nvl(vcItemAux.cd_atendimento||vcItemAux.cd_conta||vcItemAux.cd_lancamento,'XXX')<>pCdAtend||pCdConta||pCdLanc then
      open  cItemAux(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,null,null);
      fetch cItemAux into vcItemAux;
      close cItemAux;

    end if;
    --
    if vcItem.cd_pro_fat <> nvl(vcProFat.cd_pro_fat,'X') then
      open  cProFat(vcItem.cd_pro_fat);
      fetch cProFat into vcProFat;
      close cProFat;
    end if;
    --
    if vcItem.cd_pro_fat <> nvl(vcProFatAux.cd_pro_fat,'X') then
      open  cProFatAux(vcItem.cd_pro_fat, null);
      fetch cProFatAux into vcProFatAux;
      close cProFatAux;
    end if;
    --
  end if;
  ------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  ------------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ct_procedimentoExecutadoOutras').tp_utilizacao > 0 then
    --
    vTemp := null;
    if  (pTpGuia = 'RI' and   ((NVL(fnc_conf('TP_TRADUZ_DIAR_TAXAS_RI',pCdConvTmp,null),'1') = '2' and vcProFatAux.tp_gru_pro = 'SH')
       or (NVL(fnc_conf('TP_TRADUZ_MEDICAM_RI',pCdConvTmp,null),'1') = '2' and vcProFatAux.tp_gru_pro = 'MD')
       or (NVL(fnc_conf('TP_TRADUZ_MAT_OPME_RI',pCdConvTmp,null),'1') = '2' and vcProFatAux.tp_gru_pro IN ('MT','OP'))))
       or
       (pTpGuia = 'SP' and   ((NVL(fnc_conf('TP_TRADUZ_DIAR_TAXAS_SP',pCdConvTmp,null),'1') = '2' and vcProFatAux.tp_gru_pro = 'SH')
       or (NVL(fnc_conf('TP_TRADUZ_MEDICAM_SP',pCdConvTmp,null),'1') = '2' and vcProFatAux.tp_gru_pro = 'MD')
       or (NVL(fnc_conf('TP_TRADUZ_MAT_OPME_SP',pCdConvTmp,null),'1') = '2' and vcProFatAux.tp_gru_pro IN ('MT','OP'))))
       then   -- Configura真真es TISS vers真o 2
      vTuss.CD_TIP_TUSS :=  '00';
      vTuss.CD_TUSS := SubStr(dbamv.FNC_FFCV_GERA_TISS(pCdConvTmp,'FNC_TRADUZ_PROC','C',pCdAtend,pCdConta,pCdLanc,null,null,null,null,null,vRet,'VERSAO_2'),1,10);
      vTuss.DS_TUSS := dbamv.FNC_FFCV_GERA_TISS(pCdConvTmp,'FNC_TRADUZ_PROC','D',pCdAtend,pCdConta,pCdLanc,null,null,null,null,null,vRet,'VERSAO_2');
    else
      vTemp := F_DM(NULL,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
    end if;
    --
    -- dataExecucao-------------------------------------
    vCp := 'dataExecucao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --
        vTemp := vcItem.dt_lancamento;  -- Default

        if pTpGuia = 'SP' then
          --
          if fnc_conf('TP_TOTALIZA_OUTRAS_DESP_SP',pCdConvTmp,null) <> 'N' then --se tiver para agrupar, o horario 真 sempre o da conta
            if fnc_conf('TP_TOTALIZA_OUTRAS_DESP_SP',pCdConvTmp,null) = 'C' then ---Agrupa por dia de Lan真amento
              vTemp := vcItem.dt_lancamento;
            ELSE
              vTemp := vcConta.dt_inicio;
            END IF;
          else
            --Opcao 1
            if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'L' then    --Hora do Lan真amento do Item
              vTemp := nvl(vcItem.dt_sessao,vcItem.dt_lancamento); --vcItem.dt_lancamento;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'A' then --Hora do Atendimento
              vTemp := vcAtendimento.dt_atendimento;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'C' then --Hora Inicio da Conta
              vTemp := vcConta.dt_inicio;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'F' then --Hora Fim da Conta
              vTemp := vcConta.dt_final;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'H' then --Hora da Alta (atendimento)
              vTemp := vcAtendimento.dt_alta;
            end if;
            --
          end if;
        elsif pTpGuia = 'RI' then
          --
          if fnc_conf('TP_TOTALIZA_OUTRAS_DESP',pCdConvTmp,null) <> 'N' then --se tiver para agrupar, o horario 真 sempre o da conta
            if fnc_conf('TP_TOTALIZA_OUTRAS_DESP',pCdConvTmp,null) = 'C' then ---Agrupa por dia de Lan真amento
              vTemp := vcItem.dt_lancamento;
            elsif fnc_conf('TP_TOTALIZA_OUTRAS_DESP',pCdConvTmp,null) = 'U' then --PROD-2893 - Agrupa por dt.Fim da conta, senao tiver vai ser a data inicio da conta
              vTemp := Nvl(vcConta.dt_final,vcConta.dt_inicio);
            else
              vTemp := vcConta.dt_inicio;
            --PROD-2893
            --CHAVE CRIADA PARA AGRUPAR DETERMINADOS GRUPOS DE OUTRAS DESPESAS HOSPITALARES.
            --A CONFIGURACAO DEVE TER O CODIGO DO CONVENIO COM 3 DIGITOS E OS GRUPOS SEPARADOS POR # COM 2 DIGITOS, EXEMPLO @006#06#10@010#01#20
              if instr(nvl(dbamv.fnc_ffcv_conf_tiss('PARAM_GRUPOS_AGRUP_OUT_TISS',Null,null),'X'),lpad(pCdConvTmp,3,'0'))>0 then
                vTmpConf := dbamv.fnc_ffcv_conf_tiss('PARAM_GRUPOS_AGRUP_OUT_TISS',Null,null);
                vTmpConf := substr(vTmpConf,instr(vTmpConf,'@'||lpad(pCdConvTmp,3,'0')), (instr(vTmpConf||'@'
                            ,'@',instr(vTmpConf,'@'||lpad(pCdConvTmp,3,'0'))+1) - (instr(vTmpConf,'@'||lpad(pCdConvTmp,3,'0')))));
                --
                if instr(vTmpConf||'#','#'||lpad(vcProFatAux.cd_gru_pro,2,'0')||'#') > 0  -- << gru_pro
                then
                  vTemp := Nvl(vcConta.dt_final,vcConta.dt_inicio);
                end if;
                --
              end if;
            end if;
		  else
            --Opcao 1
            if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_OUT_RI',pCdConvTmp,null) = 'L' then    --Hora do Lan真amento do Item
              vTemp := vcItem.dt_lancamento;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_OUT_RI',pCdConvTmp,null) = 'A' then --Hora do Atendimento
              vTemp := vcAtendimento.dt_atendimento;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_OUT_RI',pCdConvTmp,null) = 'C' then --Hora Inicio da Conta
              vTemp := vcConta.dt_inicio;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_OUT_RI',pCdConvTmp,null) = 'F' then --Hora Fim da Conta
              vTemp := vcConta.dt_final;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_OUT_RI',pCdConvTmp,null) = 'H' then --Hora da Alta (atendimento)
              vTemp := vcAtendimento.dt_alta;
            end if;
            --
          end if;
        end if;
      vCt.dataExecucao := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);
      vResult := vCt.dataExecucao;
    end if;
    --
    -- horaInicial--------------------------------------
    vCp := 'horaInicial'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcItem.hr_lancamento;   -- ??? default
        --
        if pTpGuia = 'SP' then
          --
          if fnc_conf('TP_TOTALIZA_OUTRAS_DESP_SP',pCdConvTmp,null) <> 'N' then --se tiver para agrupar, o horario 真 sempre o da conta
			if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'N' then --N真o gera Hora
              vTemp := NULL;
			elsif fnc_conf('TP_TOTALIZA_OUTRAS_DESP_SP',pCdConvTmp,null) = 'C' then ---Agrupa por dia de Lan真amento
              vTemp := vcItem.hr_lancamento;
            ELSE
              vTemp := vcConta.hr_inicio;
            END IF;
          else
            --Opcao 1
            if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'L' then    --Hora do Lan真amento do Item
              vTemp := vcItem.hr_lancamento;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'A' then --Hora do Atendimento
              vTemp := vcAtendimento.hr_atendimento;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'C' then --Hora Inicio da Conta
              vTemp := vcConta.hr_inicio;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'F' then --Hora Fim da Conta
              vTemp := vcConta.hr_final;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'H' then --Hora da Alta (atendimento)
              vTemp := vcAtendimento.hr_alta;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'N' then --N真o gera Hora
              vTemp := NULL;
            end if;
            --
            --Opcao 2
            if Nvl(vcItem.tp_mvto,'X') = 'Gases' and
               dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_COMPL_OUT_SP',pCdConvTmp,null) = 'G' then --Hora do inicio do Gases
              --
              open  cHoraGases(pCdAtend, vcItem.cd_mvto, NULL);
              fetch cHoraGases into vcHoraGases;
              close cHoraGases;
              --
              if vcHoraGases.hr_inicio is not null then
                vTemp := vcHoraGases.hr_inicio;
              end if;
              --
            end if;
          end if;
        elsif pTpGuia = 'RI' then
          --
          if fnc_conf('TP_TOTALIZA_OUTRAS_DESP',pCdConvTmp,null) <> 'N' then --se tiver para agrupar, o horario 真 sempre o da conta
			if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_SP',pCdConvTmp,null) = 'N' then --N真o gera Hora
              vTemp := NULL;
			elsif fnc_conf('TP_TOTALIZA_OUTRAS_DESP',pCdConvTmp,null) = 'C' then ---Agrupa por dia de Lan真amento
              vTemp := vcItem.hr_lancamento;
            elsif fnc_conf('TP_TOTALIZA_OUTRAS_DESP',pCdConvTmp,null) = 'U' then --PROD-2893 - Agrupa por dt.Fim da conta, senao tiver vai ser a data inicio da conta
              vTemp := Nvl(vcConta.hr_final,vcConta.hr_inicio);
            ELSE
              vTemp := vcConta.hr_inicio;
            END IF;

            --PROD-2893
            --CHAVE CRIADA PARA AGRUPAR DETERMINADOS GRUPOS DE OUTRAS DESPESAS HOSPITALARES.
            --A CONFIGURACAO DEVE TER O CODIGO DO CONVENIO COM 3 DIGITOS E OS GRUPOS SEPARADOS POR # COM 2 DIGITOS, EXEMPLO @006#06#10@010#01#20
            if instr(nvl(dbamv.fnc_ffcv_conf_tiss('PARAM_GRUPOS_AGRUP_OUT_TISS',Null,null),'X'),lpad(pCdConvTmp,3,'0'))>0 then
              vTmpConf := dbamv.fnc_ffcv_conf_tiss('PARAM_GRUPOS_AGRUP_OUT_TISS',Null,null);
              vTmpConf := substr(vTmpConf,instr(vTmpConf,'@'||lpad(pCdConvTmp,3,'0')), (instr(vTmpConf||'@'
                          ,'@',instr(vTmpConf,'@'||lpad(pCdConvTmp,3,'0'))+1) - (instr(vTmpConf,'@'||lpad(pCdConvTmp,3,'0')))));
              --
              if instr(vTmpConf||'#','#'||lpad(vcProFatAux.cd_gru_pro,2,'0')||'#') > 0  -- << gru_pro
              then
                vTemp := Nvl(vcConta.hr_final,vcConta.hr_inicio);
              end if;
            --
            end if;
          else
            --Opcao 1
            if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_RI',pCdConvTmp,null) = 'L' then    --Hora do Lan真amento do Item
              vTemp := vcItem.hr_lancamento;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_RI',pCdConvTmp,null) = 'A' then --Hora do Atendimento
              vTemp := vcAtendimento.hr_atendimento;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_RI',pCdConvTmp,null) = 'C' then --Hora Inicio da Conta
              vTemp := vcConta.hr_inicio;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_RI',pCdConvTmp,null) = 'F' then --Hora Fim da Conta
              vTemp := vcConta.hr_final;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_RI',pCdConvTmp,null) = 'H' then --Hora da Alta (atendimento)
              vTemp := vcAtendimento.hr_alta;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_OUT_RI',pCdConvTmp,null) = 'N' then --N真o gera Hora
              vTemp := NULL;
            end if;
            --
            --Opcao 2
            if Nvl(vcItem.tp_mvto,'X') = 'Gases' and
               dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_COMPL_OUT_RI',pCdConvTmp,null) = 'G' then --Hora do inicio do Gases
              --
              open  cHoraGases(pCdAtend, vcItem.cd_mvto, NULL);
              fetch cHoraGases into vcHoraGases;
              close cHoraGases;
              --
              if vcHoraGases.hr_inicio is not null then
                vTemp := vcHoraGases.hr_inicio;
              end if;
              --
            end if;
          end if;
        end if;
      --
      vCt.horaInicial := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);
      vResult := vCt.horaInicial;
    end if;
    --
    -- horaFinal----------------------------------------
    vCp := 'horaFinal'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if pTpGuia = 'SP' then
          --
          if fnc_conf('TP_TOTALIZA_OUTRAS_DESP_SP',pCdConvTmp,null) <> 'N' then --se tiver para agrupar, o horario 真 sempre o da conta
			if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_SP',pCdConvTmp,null) = 'N' then --N真o gera Hora
              vTemp := NULL;
			elsif fnc_conf('TP_TOTALIZA_OUTRAS_DESP_SP',pCdConvTmp,null) = 'C' then ---Agrupa por dia de Lan真amento
              vTemp := vcItem.hr_lancamento;
            ELSE
              vTemp := vcConta.hr_inicio;
            END IF;
          else
            --Opcao 1
            if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_SP',pCdConvTmp,null) = 'L' then    --Hora do Lan真amento do Item
              vTemp := vcItem.hr_lancamento;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_SP',pCdConvTmp,null) = 'A' then --Hora do Atendimento
              vTemp := vcAtendimento.hr_atendimento;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_SP',pCdConvTmp,null) = 'C' then --Hora Inicio da Conta
              vTemp := vcConta.hr_inicio;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_SP',pCdConvTmp,null) = 'F' then --Hora Fim da Conta
              vTemp := vcConta.hr_final;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_SP',pCdConvTmp,null) = 'H' then --Hora da Alta (atendimento)
              vTemp := vcAtendimento.hr_alta;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_SP',pCdConvTmp,null) = 'N' then --N真o gera Hora
              vTemp := NULL;
            end if;
            --
            --Opcao 2
            if Nvl(vcItem.tp_mvto,'X') = 'Gases' and
               dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_COMPL_OUT_SP',pCdConvTmp,null) = 'G' then --Hora do inicio do Gases
              --
              open  cHoraGases(pCdAtend, vcItem.cd_mvto, NULL);
              fetch cHoraGases into vcHoraGases;
              close cHoraGases;
              --
              if vcHoraGases.hr_fim is not null then
                vTemp := vcHoraGases.hr_fim;
              end if;
              --
            end if;
          end if;
        elsif pTpGuia = 'RI' then
          --
          vTemp := vcItem.hr_lancamento;   -- ??? default
          --
          if fnc_conf('TP_TOTALIZA_OUTRAS_DESP',pCdConvTmp,null) <> 'N' then --se tiver para agrupar, o horario 真 sempre o da conta
			if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_SP',pCdConvTmp,null) = 'N' then --N真o gera Hora
              vTemp := NULL;
			elsif fnc_conf('TP_TOTALIZA_OUTRAS_DESP',pCdConvTmp,null) = 'C' then ---Agrupa por dia de Lan真amento
              vTemp := vcItem.hr_lancamento;
			elsif fnc_conf('TP_TOTALIZA_OUTRAS_DESP',pCdConvTmp,null) = 'U' then --PROD-2893 - Agrupa por dt.Fim da conta, senao tiver vai ser a data inicio da conta
              vTemp := Nvl(vcConta.hr_final,vcConta.hr_inicio);
            ELSE
              vTemp := vcConta.hr_inicio;
            END IF;

          --PROD-2893
          --CHAVE CRIADA PARA AGRUPAR DETERMINADOS GRUPOS DE OUTRAS DESPESAS HOSPITALARES.
          --A CONFIGURACAO DEVE TER O CODIGO DO CONVENIO COM 3 DIGITOS E OS GRUPOS SEPARADOS POR # COM 2 DIGITOS, EXEMPLO @006#06#10@010#01#20
            if instr(nvl(dbamv.fnc_ffcv_conf_tiss('PARAM_GRUPOS_AGRUP_OUT_TISS',Null,null),'X'),lpad(pCdConvTmp,3,'0'))>0 then
              vTmpConf := dbamv.fnc_ffcv_conf_tiss('PARAM_GRUPOS_AGRUP_OUT_TISS',Null,null);
              vTmpConf := substr(vTmpConf,instr(vTmpConf,'@'||lpad(pCdConvTmp,3,'0')), (instr(vTmpConf||'@'
                         ,'@',instr(vTmpConf,'@'||lpad(pCdConvTmp,3,'0'))+1) - (instr(vTmpConf,'@'||lpad(pCdConvTmp,3,'0')))));
              --
              if instr(vTmpConf||'#','#'||lpad(vcProFatAux.cd_gru_pro,2,'0')||'#') > 0  -- << gru_pro
              then
                vTemp := Nvl(vcConta.hr_final,vcConta.hr_inicio);
              end if;
              --
            end if;
  		  else
            --Opcao 1
            if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_RI',pCdConvTmp,null) = 'L' then    --Hora do Lan真amento do Item
              vTemp := vcItem.hr_lancamento;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_RI',pCdConvTmp,null) = 'A' then --Hora do Atendimento
              vTemp := vcAtendimento.hr_atendimento;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_RI',pCdConvTmp,null) = 'C' then --Hora Inicio da Conta
              vTemp := vcConta.hr_inicio;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_RI',pCdConvTmp,null) = 'F' then --Hora Fim da Conta
              vTemp := vcConta.hr_final;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_RI',pCdConvTmp,null) = 'H' then --Hora da Alta (atendimento)
              vTemp := vcAtendimento.hr_alta;
            elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_OUT_RI',pCdConvTmp,null) = 'N' then --N真o gera Hora
              vTemp := NULL;
            end if;
            --
            --Opcao 2
            if Nvl(vcItem.tp_mvto,'X') = 'Gases' and
               dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_COMPL_OUT_RI',pCdConvTmp,null) = 'G' then --Hora do inicio do Gases
              --
              open  cHoraGases(pCdAtend, vcItem.cd_mvto, NULL);
              fetch cHoraGases into vcHoraGases;
              close cHoraGases;
              --
              if vcHoraGases.hr_fim is not null then
                vTemp := vcHoraGases.hr_fim;
              end if;
              --
            end if;
          end if;
        end if;
      vCt.horaFinal := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);
      vResult := vCt.horaFinal;
    end if;
    --
    -- codigoTabela-------------------------------------
    vCp := 'codigoTabela'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vTuss.CD_TIP_TUSS;
      vCt.codigoTabela := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);    -- dm_tabela
      vResult := vCt.codigoTabela;
    end if;
    --
    --
    -- codigoProcedimento-------------------------------
    vCp := 'codigoProcedimento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vTuss.CD_TUSS is not null then
          vTemp := vTuss.CD_TUSS;
        else
          vTemp := vcProFat.cd_pro_fat; --senao tiver o relacionamento novo (Para o usuario saber o procedimento)
        end if;
      vCt.codigoProcedimento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);
      vResult := vCt.codigoProcedimento;
    end if;
    --
    -- quantidadeExecutada------------------------------
    vCp := 'quantidadeExecutada'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        nVlTemp := vcItem.qt_lancamento;
        if ( (pTpGuia = 'RI' and nvl(FNC_CONF('TP_INFORMACAO_QTD_RI',pCdConvTmp,null),'1') = '2')
          or (pTpGuia = 'SP' and nvl(FNC_CONF('TP_INFORMACAO_QTD_SP',pCdConvTmp,null),'1') = '2') )  then
          if vcConta.cd_convenio||vcConta.cd_con_pla||vcItem.cd_pro_fat<>NVL(vcRegraGasesItem.cd_convenio||vcRegraGasesItem.cd_con_pla||vcRegraGasesItem.cd_pro_fat,'XXX') Then
            vcRegraGasesItem := null;
            open  cRegraGasesItem(vcConta.cd_convenio,vcConta.cd_con_pla,vcItem.cd_pro_fat,null);
            fetch cRegraGasesItem into vcRegraGasesItem;
            close cRegraGasesItem;
          end if;
          if vcRegraGasesItem.tp_unidade = 'M' then
            nVlTemp := nVlTemp / 60;
          end if;
        end if;
        if pModo is null then
          TotAgrupDesp.quantidade := TotAgrupDesp.quantidade + nVlTemp; -- acumulador em caso de agrupamento
          nVlTemp := TotAgrupDesp.quantidade;
        end if;
        vTemp := nVlTemp;
      vCt.quantidadeExecutada := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);
      vResult := vCt.quantidadeExecutada;
    end if;
    --
    -- OP 44895 - 03/02/2017 - A unidade gravada no item da conta pela regra de substitui真真o ter真 prioridade sobre a unidade do procedimento.
    vUnidadeSubs := dbamv.FNC_FFCV_GERA_TISS(vcConta.cd_convenio,'FNC_FFCV_RET_UNID_SUBSTITUICAO',vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,null,null,null,null,null,vRet,null);
    -- unidadeMedida------------------------------------
    vCp := 'unidadeMedida'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --FUTURO RELACIONAMENTO COM A TELA
        --vTemp := F_DM(60,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
        --vTemp := vTuss.CD_TUSS;
        if vCodUnid is null then
          declare
            type rUnid is record (cd_tuss dbamv.tuss.cd_tuss%type, ds_tuss dbamv.tuss.ds_tuss%type, ds_descricao_detalhada dbamv.tuss.ds_descricao_detalhada%type);
            type tUnid is table of rUnid;
            vUnid tUnid;
          begin
            --
            SELECT distinct cd_tuss, ds_tuss, ds_descricao_detalhada BULK COLLECT into vUnid from dbamv.tuss where cd_tip_tuss = 60 order by cd_tuss;
            --
            for i in vUnid.first..vUnid.last loop
              vCodUnid      := vCodUnid||','||vUnid(i).cd_tuss;
              vTermoUnid    := vTermoUnid||','||vUnid(i).ds_tuss;
              vDescUnid     := vDescUnid||','||UPPER(vUnid(i).ds_descricao_detalhada);
            end loop;
          exception
            when others then
              null;
          end;
        end if;
        --
        declare
          k number; k2 number;
        begin
          vPesqUnid := vTermoUnid; -- procura por termo EXATO
          k := instr(vTermoUnid||',',','||Nvl(vUnidadeSubs,vcProFat.ds_unidade)||','); --k := instr(vTermoUnid,','||vcProFat.ds_unidade);   -- OP 44895 - NVL com a vUnidadeSubs.
          IF k=0 THEN              -- procura por termo em 3 d真gitos
            k := instr(vTermoUnid,','||SubStr(Nvl(vUnidadeSubs,vcProFat.ds_unidade),1,3));   -- OP 44895 - NVL com a vUnidadeSubs.
          END IF;
          IF k=0 THEN              -- procura por termo em 2 d真gitos
            k := instr(vTermoUnid,','||SubStr(nvl(vUnidadeSubs,vcProFat.ds_unidade),1,2));    -- OP 44895 - NVL com a vUnidadeSubs.
          END IF;
          if k=0 then
            vPesqUnid := vDescUnid; -- procura por descri真真o detalhada
            k := instr(vPesqUnid,','||nvl(vUnidadeSubs,vcProFat.ds_unidade));                 -- OP 44895 - NVL com a vUnidadeSubs.
          end if;
          if k<>0 then
            for k1 in 1..100 loop
              k2 := instr(vPesqUnid,',',1,k1);
              if k2 = k then
                vTemp := substr(vCodUnid,k1*4-2,3);
                EXIT;
              end if;
            end loop;
          end if;
        exception
           when others then
             null;
        end;
      vCt.unidadeMedida := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);     -- dm_unidadeMedida
      vResult := vCt.unidadeMedida;
    end if;
    --
    -- reducaoAcrescimo---------------------------------
    vCp := 'reducaoAcrescimo'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      nVlAcresDesc := vcItem.vl_percentual_multipla;
      if ( ( pTpGuia = 'RI' AND nvl(fnc_conf('TP_PERC_ACRES_DESC_DESP_RI',pCdConvTmp,null),'1') = '2' ) OR
           ( pTpGuia = 'SP' AND nvl(fnc_conf('TP_PERC_ACRES_DESC_DESP_SP',pCdConvTmp,null),'1') = '2' ) ) and vcItem.sn_horario_especial = 'S' then
        --
        if vcItem.cd_regra||vcProFatAux.cd_gru_pro<>nvl(vcIndiceHE.cd_regra||vcIndiceHE.cd_gru_pro,'XX') then
          vcIndiceHE := null;
          open  cIndiceHE(vcItem.cd_regra,vcProFatAux.cd_gru_pro);
          fetch cIndiceHE into vcIndiceHE;
          close cIndiceHE;
        end if;
        if vcIndiceHE.vl_percentual is not null then
          nVlAcresDesc := nvl(nVlAcresDesc,100) + vcIndiceHE.vl_percentual;
        end if;
      end if;
      -- OP 31752 - pda 767230 - fim
      --vTemp := (nVlAcresDesc/100);
	  --cliente informou um valor de menos de 1% no item da conta (0,11%)
	  IF nVlAcresDesc >= 1 then
        vTemp := (nVlAcresDesc/100);
      ELSE
        vTemp := nVlAcresDesc;
      END IF;

      vCt.reducaoAcrescimo := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);
      vResult := vCt.reducaoAcrescimo;
      --nVlAcresDesc := To_Number(vCt.reducaoAcrescimo,'999.99')*100; -- Guarda percentual para c真lculo valor unit真rio qdo.agrupado
	  --cliente informou um valor de menos de 1% no item da conta (0,11%)
	  IF nVlAcresDesc >= 1 then
        nVlAcresDesc := To_Number(vCt.reducaoAcrescimo,'999.99')*100; -- Guarda percentual para c真lculo valor unit真rio qdo.agrupado
      END IF;
    end if;
    --
    -- valorUnitario----------------------------------------
    -- Campo deslocado mais abaixo por quest真es t真cnicas de c真lculo
    --
    -- valorTotal---------------------------------------
    vCp := 'valorTotal'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        nVlTemp := vcItem.vl_total_conta;
        if pModo is null then
          TotAgrupDesp.valortotal := TotAgrupDesp.valortotal + nVlTemp;
          nVlTemp := TotAgrupDesp.valortotal;
        end if;
        vTemp := nVlTemp;   -- ???  PENDENTE, analisar op真真es j真 existentes como zerar valores por op真真o, etc.
      vCt.valorTotal := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,pCdConvTmp);
      vResult := vCt.valorTotal;
    end if;
    --
    -- valorUnitario------------------------------------
    vCp := 'valorUnitario'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      if   (pTpGuia = 'RI' and nvl(fnc_conf('TP_VALOR_UNITARIO_DESP_RI',pCdConvTmp,null),'1') = '2')
        or (pTpGuia = 'SP' and nvl(fnc_conf('TP_VALOR_UNITARIO_DESP_SP',pCdConvTmp,null),'1') = '2')
        then
      --vTemp := (vcItem.vl_total_conta/vcItem.qt_lancamento)/nvl(nVlAcresDesc/100,1);
        vTemp := ((TotAgrupDesp.valortotal/nvl(TotAgrupDesp.quantidade,1))/nvl(nVlAcresDesc/100,1) ); --OP 44475
      else
        vTemp := vcItem.vl_total_conta/vcItem.qt_lancamento;
      end if;
      vCt.valorUnitario := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,pCdConvTmp);
      vResult := vCt.valorUnitario;
    end if;
    --
    -- descricaoProcedimento----------------------------
    vCp := 'descricaoProcedimento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if   ((pTpGuia = 'RI' and nvl(fnc_conf('TP_DESCR_OUT_DESP_RI',pCdConvTmp,null),'01')= '01')
           or (pTpGuia = 'SP' and nvl(fnc_conf('TP_DESCR_OUT_DESP_SP',pCdConvTmp,null),'01')= '01')) and vTuss.DS_TUSS is not null then
          vTemp := vTuss.DS_TUSS;
        elsif ((pTpGuia = 'RI' and nvl(fnc_conf('TP_DESCR_OUT_DESP_RI',pCdConvTmp,null),'01')= '02')
            or (pTpGuia = 'SP' and nvl(fnc_conf('TP_DESCR_OUT_DESP_SP',pCdConvTmp,null),'01')= '02')) then
          vTemp := vcProFat.ds_pro_fat;
        elsif ((pTpGuia = 'RI' and nvl(fnc_conf('TP_DESCR_OUT_DESP_RI',pCdConvTmp,null),'01')= '03')
            or (pTpGuia = 'SP' and nvl(fnc_conf('TP_DESCR_OUT_DESP_SP',pCdConvTmp,null),'01')= '03')) then
            if nvl(pReserva,'X') in ('01','05','07') and vTuss.CD_TIP_TUSS = 18 then -- somente TAXAS em geral
             --if dbamv.pkg_mv2000.le_empresa||pCdConvTmp||vcItem.cd_pro_fat||vcAtendimento.tp_atendimento
             --  <> NVL(vcCodPro.cd_multi_empresa||vcCodPro.cd_convenio||vcCodPro.cd_pro_fat||vcCodPro.tp_atendimento_ori,'XXXX')
             --  then
                  vcCodPro := null;
                --open  cCodPro(dbamv.pkg_mv2000.le_empresa,pCdConvTmp,vcItem.cd_pro_fat,vcAtendimento.tp_atendimento);
                  open  cCodPro(nEmpresaLogada,pCdConvTmp,vcItem.cd_pro_fat,vcAtendimento.tp_atendimento); --adhospLeEmpresa
                  fetch cCodPro into vcCodPro;
                  close cCodPro;
             --end if;
              if vcCodPro.ds_codigo_cobranca is not null then
                vTemp := vcCodPro.ds_codigo_cobranca||'-'||vcCodPro.ds_nome_cobranca||'|'||vcItem.cd_pro_fat||'-'||vcProFat.ds_pro_fat;
              else
                vTemp := vcItem.cd_pro_fat||'-'||vcProFat.ds_pro_fat||'|'||vcItem.cd_pro_fat||'-'||vcProFat.ds_pro_fat;
              end if;

            else
              vTemp := vTuss.DS_TUSS;
            end if;
        elsif ((pTpGuia = 'RI' and nvl(fnc_conf('TP_DESCR_OUT_DESP_RI',pCdConvTmp,null),'01')= '04')
            or (pTpGuia = 'SP' and nvl(fnc_conf('TP_DESCR_OUT_DESP_SP',pCdConvTmp,null),'01')= '04')) then
            if nvl(vcAprTiss.cd_apr_tiss, 0) = 0 then
              open  cAprTiss(NULL);
              fetch cAprTiss into vcAprTiss;
              close cAprTiss;
            end if;
            if vcItem.cd_setor||vcAprTiss.cd_apr_tiss <> nvl(vcTipoSetor.cd_setor||vcTipoSetor.cd_apr,'XX') THEN
              vcTipoSetor := null;
              open  cTipoSetor( vcAprTiss.cd_apr_tiss, vcItem.cd_setor);
              fetch cTipoSetor into vcTipoSetor;
              close cTipoSetor;
            end if;
            --
            vTemp := vcTipoSetor.CD_SETOR_MEIO_MAG||'#'||NVL(vTuss.DS_TUSS,vcProFat.ds_pro_fat);
            --
        elsif ((pTpGuia = 'RI' and nvl(fnc_conf('TP_DESCR_OUT_DESP_RI',pCdConvTmp,null),'01')= '05')
            or (pTpGuia = 'SP' and nvl(fnc_conf('TP_DESCR_OUT_DESP_SP',pCdConvTmp,null),'01')= '05')) and vTuss.DS_TUSS is not null  then
            if vTuss.DS_APRESENTACAO is not null then
              vTemp := vTuss.DS_TUSS||' - '||vTuss.DS_APRESENTACAO;
            else
              vTemp := vTuss.DS_TUSS;
            end if;
        elsif ((pTpGuia = 'RI' and nvl(fnc_conf('TP_DESCR_OUT_DESP_RI',pCdConvTmp,null),'01')= '06')
            or (pTpGuia = 'SP' and nvl(fnc_conf('TP_DESCR_OUT_DESP_SP',pCdConvTmp,null),'01')= '06')) and vTuss.DS_TUSS is not null  then
            if vTuss.NM_LABORATORIO is not null then
              vTemp := vTuss.DS_TUSS||' - '||vTuss.NM_LABORATORIO;
            else
              vTemp := vTuss.DS_TUSS;
            end if;
        else
          vTemp := vcProFat.ds_pro_fat; --quando nao tem relacionamento, para ajudar ao usuario a saber o procedimento
        end if;
      vTemp := substr(vTemp,1,100); -- limita真ao provis真ria (ha descricoes maior que 100)
      vCt.descricaoProcedimento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);
      vResult := vCt.descricaoProcedimento;
    end if;
    --
    -- registroANVISA-----------------------------------
    vCp := 'registroANVISA'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vCt.codigoTabela = '00' then
          if vTuss.CD_REFERENCIA is not null then
            vTemp := vTuss.CD_REFERENCIA;
          elsif vcItemAux.cd_produto is not null then
            open  cProduto(vcItemAux.cd_produto, NULL);
            fetch cProduto into vcProduto;
            close cProduto;
            if vcProduto.CD_REGISTRO is not null then
              vTemp := vcProduto.CD_REGISTRO;
            end if;
          end if;
        end if;
      vCt.registroANVISA := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);
      vResult := vCt.registroANVISA;
    end if;
    --
    -- codigoRefFabricante------------------------------
    vCp := 'codigoRefFabricante'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vCt.codigoTabela = '00' then
          if vTuss.CD_REF_FABRICANTE is not null then
			vTemp := vTuss.CD_REF_FABRICANTE;
            vTemp := SubStr(vTuss.CD_REF_FABRICANTE,1,20);
          elsif vcItemAux.cd_fornecedor is not null then
            vcProdutoFornecedor := null;
            open  cProdutoFornecedor(vcItem.cd_pro_fat,vcItemAux.cd_fornecedor);
            fetch cProdutoFornecedor into vcProdutoFornecedor;
            close cProdutoFornecedor;
            vTemp := vcProdutoFornecedor.cd_prod_forn;
          end if;
        end if;
      vCt.codigoRefFabricante := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);
      vResult := vCt.codigoRefFabricante;
    end if;
    --
    -- autorizacaoFuncionamento-------------------------
    vCp := 'autorizacaoFuncionamento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vcItemAux.cd_fornecedor is not null then
          open  cFornecedor(vcItemAux.cd_fornecedor);
          fetch cFornecedor into vcFornecedor;
          close cFornecedor;
          vTemp := vcFornecedor.cd_afe;
        end if;
      vCt.autorizacaoFuncionamento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);
      vResult := vCt.autorizacaoFuncionamento;
    end if;
    --
    --OSWALDO IN真CIO
    -- itemVinculado-------------------------------------
    vCp := 'itemVinculado'; vTemp := null;
    IF vCp = nvl(pModo,vCp) AND tconf.EXISTS(vCp) AND tConf(vCp).tp_utilizacao>0 THEN
      IF pTpGuia = 'RI' THEN
        pTP_ITEM_VINCULADO_RI:=  Nvl(fnc_conf('TP_ITEM_VINCULADO_RI',pCdConvTmp,null),'00');
        IF pTP_ITEM_VINCULADO_RI <> '00' THEN
          --01 (Do atendimento) ou 03 (Vinculados ao av de cirurgia/atendimento)
          IF vItemAtendVinc IS NULL AND pTP_ITEM_VINCULADO_RI IN ('01','03')  THEN
            OPEN cSqItemGuia(pCdAtend, 'Atendimento', pCdAtend, pCdConta, 'I');
            FETCH cSqItemGuia INTO vItemAtendVinc;
            CLOSE cSqItemGuia;
          END IF;
          --02 (Vinculados ao av de cirurgia "cir principal") ou 03 (Vinculados ao av de cirurgia/atendimento)
          IF vcItemAux.CD_SOLSAI_PRO IS NOT NULL AND
             vcItemAux.cd_aviso_cirurgia IS NOT NULL AND
             pTP_ITEM_VINCULADO_RI IN ('02','03')
          THEN
            OPEN cSqItemGuia(vcItemAux.cd_aviso_cirurgia, 'Cirurgia', pCdAtend, pCdConta, 'I');
            FETCH cSqItemGuia INTO vItemCirurgVinc;
            CLOSE cSqItemGuia;
          END IF;

          itemVinculadoSeq := Nvl(vItemCirurgVinc,vItemAtendVinc); --Nvl para atender a op真真o 03 que engloba as duas condicoes acima

        ELSE
          itemVinculadoSeq := NULL;
        END IF;
      ELSIF pTpGuia = 'SP' THEN
        pTP_ITEM_VINCULADO_SP:=  Nvl(fnc_conf('TP_ITEM_VINCULADO_SP',pCdConvTmp,null),'00');
        IF pTP_ITEM_VINCULADO_SP <> '00' THEN
          --01 (Do atendimento) ou 03 (Vinculados ao av de cirurgia/atendimento)
          IF vItemAtendVinc IS NULL AND pTP_ITEM_VINCULADO_SP IN ('01','03') THEN
            OPEN  cSqItemGuia(pCdAtend, 'Atendimento', pCdAtend, pCdConta, 'A');
            FETCH cSqItemGuia INTO vItemAtendVinc;
            CLOSE cSqItemGuia;
          END IF;
          --02 (Vinculados ao av de cirurgia "cir principal") ou 03 (Vinculados ao av de cirurgia/atendimento)
          IF vcItemAux.CD_SOLSAI_PRO IS NOT NULL AND
             vcItemAux.cd_aviso_cirurgia IS NOT NULL AND
             pTP_ITEM_VINCULADO_SP IN ('02', '03')
          THEN
            vItemCirurgVinc := NULL;
            OPEN cSqItemGuia(vcItemAux.cd_aviso_cirurgia, 'Cirurgia', pCdAtend, pCdConta, 'A');
            FETCH cSqItemGuia INTO vItemCirurgVinc;
            CLOSE cSqItemGuia;
          END IF;

          itemVinculadoSeq := Nvl(vItemCirurgVinc,vItemAtendVinc); --Nvl para atender a op真真o 03 que engloba as duas condicoes acima

        ELSE
          itemVinculadoSeq := NULL;
        END IF;
      END IF;
      vTemp	:= itemVinculadoSeq;
      vCt.itemVinculado := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcItem.cd_pro_fat,null);
      vResult := vCt.itemVinculado;
    end if;
    --OSWALDO FIM
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_prestadorIdentificacao(  pModo           in varchar2,
                                        pIdMap          in number,
										pTpTransacao    in varchar2, -- tmdo
                                        pCdMultiEmpresa in dbamv.multi_empresas.cd_multi_empresa%type,
                                        pCdConv         in dbamv.convenio.cd_convenio%type,
                                        vCt             OUT NOCOPY RecPrestIdent,
                                        pMsg            OUT varchar2,
                                        pReserva        in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  vCp	          varchar2(1000);
  vCdAtendTmp   dbamv.atendime.cd_atendimento%type;
  nCdRemessa    number;
  -- Oswaldo BH in真cio
  nID_TISS_MSG  number;
  vcPreInt      cPreInt%ROWTYPE;
  -- Oswaldo BH fim
BEGIN
  -- leitura de cursores de uso geral
  -------------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  -------------------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ct_prestadorIdentificacao').tp_utilizacao > 0 then
    --
    if pCdMultiEmpresa <> nvl(vcHospital.cd_multi_empresa, 0) then
      open cHospital(pCdMultiEmpresa);
      fetch cHospital into vcHospital;
      close cHospital;
    end if;
    --
	-- Oswaldo BH in真cio
    --SUP-273226 Acrescentado essa condi真真o pois o nID_TISS_MSG vai receber o ID da TISS_SOL_GUIA
    --TISS-475 Acrescentado o OR para que seja poss真vel pegar as informa真真es da pr真-interna真真o quando for solicita真真o de status autoriza真真o
	IF SubStr(pReserva,1,InStr(pReserva,'#')-1) = 'SOLICITACAO_PROCEDIMENTOS' OR SubStr(pReserva,1,InStr(pReserva,'#')-1) = 'SOLICITA_STATUS_AUTORIZACAO' THEN
      nID_TISS_MSG := To_Number(SubStr(pReserva,InStr(pReserva,'#')+1,Length(pReserva)));
      -- AQUI PEGAR O CD_RES_LEI
    ELSIF pTpTransacao = 'SOLICITA_STATUS_AUTORIZACAO' THEN
      vCdAtendTmp:= pReserva;
	ELSE
      nCdRemessa := pReserva;
    END IF;
	-- Oswaldo BH fim
    --
    FOR I in 1..3 LOOP -- os 3 campos abaixo s真o CHOICE =========================
      --
      -- CNPJ------------------------------------------------
      --
      vCp := 'CNPJ'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I then
        vTemp := vcHospital.cd_cgc;
        vCt.CNPJ := F_ST(null,vTemp,vCp,pCdMultiEmpresa,pCdConv,vTpTransacao,vTpGuiasTransacao,nCdRemessa);
        vResult := vCt.CNPJ;
        EXIT when vCt.CNPJ is NOT null;
      end if;
      --
      -- CPF-------------------------------------------------
      --
      vCp := 'CPF'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I then
        vTemp := null;
        vCt.CPF := F_ST(null,vTemp,vCp,pCdMultiEmpresa,pCdConv,vTpTransacao,vTpGuiasTransacao,nCdRemessa);
        vResult := vCt.CPF;
        EXIT when vCt.CPF is NOT null;
      end if;
      --
      -- codigoPrestadorNaOperadora--------------------------
      --
      vCp := 'codigoPrestadorNaOperadora'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I then
          if NVL(vcEmpresaConv.cd_multi_empresa||vcEmpresaConv.cd_convenio,'XX') <> pCdMultiEmpresa||pCdConv then
            open  cEmpresaConv(pCdMultiEmpresa, pCdConv);
            fetch cEmpresaConv into vcEmpresaConv;
            close cEmpresaConv;
          end if;
          if    nvl(fnc_conf('TP_COD_PRESTADOR_CABECALHO',pCdConv,null),'01')='01' then
            vTemp := vcEmpresaConv.cd_hospital_no_convenio;
          elsif nvl(fnc_conf('TP_COD_PRESTADOR_CABECALHO',pCdConv,null),'01')='02' then
              vcContratado := null;
              begin
                 SELECT  cd_atendimento INTO vCdAtendTmp
                   from( select cd_atendimento  from dbamv.tiss_guia tg
                           WHERE tg.cd_convenio = pCdConv AND tg.cd_reg_fat IN (SELECT cd_reg_fat FROM dbamv.reg_fat rf WHERE   rf.cd_remessa = nCdRemessa) AND rownum = 1
                          UNION ALL
                          select cd_atendimento from dbamv.tiss_guia tg
                           WHERE tg.cd_convenio = pCdConv
                             AND tg.cd_atendimento IN (SELECT DISTINCT(cd_atendimento) FROM dbamv.itreg_amb ia, dbamv.reg_amb ra WHERE  ra.cd_reg_amb = ia.cd_reg_amb AND ra.cd_remessa = nCdRemessa) AND rownum = 1);
              exception
                when others THEN
                IF pTpTransacao <> 'SOLICITA_STATUS_AUTORIZACAO' then
                  vCdAtendTmp:= Nvl(vcAtendimento.cd_atendimento,vcAtendimentoAUX.cd_atendimento); --Oswaldo 09/12
                END IF;
                null;
              end;
			  --
              if vCdAtendTmp is not null then

                vcAtendimento := null;
                open  cAtendimento(vCdAtendTmp);
                fetch cAtendimento into vcAtendimento;
                close cAtendimento;

                open cAtendimentoAUX(vCdAtendTmp);
                fetch cAtendimentoAUX into vcAtendimentoAUX;
                close cAtendimentoAUX;

                open  cContratado( pCdConv,vcAtendimento.tp_atendimento_original,vcAtendimentoAUX.cd_ori_ate,vcAtendimento.cd_servico,null,null,null,null,vcAtendimento.cd_pro_int,vcAtendimento.cd_ser_dis);
                fetch cContratado into vcContratado;
                close cContratado;
                -- Oswaldo BH in真cio
				if vcContratado.cd_codigo_contratado is not null then
                  vTemp := vcContratado.cd_codigo_contratado;
                else
                  vTemp := vcEmpresaConv.cd_hospital_no_convenio;
                end if;
			  --SUP-273226 Trecho de c真digo para que ele pegue o c真digo do prestador na aba contratado da tela M_CONVENIO_CONF_TISS mesmo sem atendimento atrelado,
              --apenas com o c真digo da pr真-interna真真o
              ELSIF  vCdAtendTmp is NULL AND nID_TISS_MSG IS NOT NULL THEN
                IF Nvl(vcTissSolGuia.id,0) <> Nvl(nID_TISS_MSG,0) THEN
                  vcTissSolGuia := NULL;
                  OPEN cTissSolGuia (nID_TISS_MSG, null,null,null);
                  FETCH cTissSolGuia INTO vcTissSolGuia;
                  CLOSE cTissSolGuia;
                END IF;
                IF vcTissSolGuia.cd_guia IS NOT NULL AND Nvl(vcGuia.cd_guia,0) <> Nvl(vcTissSolGuia.cd_guia,0) THEN
                  vcGuia := NULL;
                  OPEN cGuia (vcTissSolGuia.cd_guia, null);
                  FETCH cGuia INTO vcGuia;
                  CLOSE cGuia;
                END IF;
                IF vcGuia.cd_res_lei IS NOT NULL AND Nvl(vcPreInt.cd_res_lei,0) <> Nvl(vcGuia.cd_res_lei,0) then
                  OPEN cPreInt (vcGuia.cd_res_lei);
                  FETCH cPreInt INTO vcPreInt;
                  CLOSE cPreInt;
                END IF;
                open  cContratado( pCdConv,'I',vcPreInt.cd_ori_ate, vcPreInt.cd_servico,null,null,null,null,NULL,null);
                fetch cContratado into vcContratado;
                close cContratado;
				-- Oswaldo BH fim
                if vcContratado.cd_codigo_contratado is not null then
                  vTemp := vcContratado.cd_codigo_contratado;
                else
                  vTemp := vcEmpresaConv.cd_hospital_no_convenio;
                end if;
              else
                vTemp := vcEmpresaConv.cd_hospital_no_convenio;
              end if;
--            end if;
          end if;
        vCt.codigoPrestadorNaOperadora := F_ST(null,vTemp,vCp,pCdMultiEmpresa,pCdConv,vTpTransacao,vTpGuiasTransacao,nCdRemessa);
        vResult := vCt.codigoPrestadorNaOperadora;
        EXIT when vCt.codigoPrestadorNaOperadora is NOT null;
      end if;
      --
    END LOOP; -- fim do CHOICE ==============================
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_cabecalhoTransacao( pModo           in varchar2,
                                pIdMap          in number,
                                pTpTransacao    in varchar2, -- Oswaldo BH
                                pCdMultiEmpresa in dbamv.multi_empresas.cd_multi_empresa%type,
                                pCdConv         in dbamv.convenio.cd_convenio%type,
                                vCt             OUT NOCOPY RecCabecTransac,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  vRet          varchar2(1000);
  vCp	        varchar2(1000);
  vNrDocumento  varchar2(1000); --Oswaldo 09/12
  vCtPrestIdent RecPrestIdent;
BEGIN
  -- leitura de cursores de uso geral
  ------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  ------------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  --Oswaldo 09/12
  vNrDocumento:= pReserva;
  IF pTpTransacao = 'SOLICITACAO_PROCEDIMENTOS' THEN
    -- Neste momento o pReserva est真 preenchido com a remessa;
    vNrDocumento:= 'SOLICITACAO_PROCEDIMENTOS#'||vNrDocumento; -- Oswaldo BH
  ELSIF Nvl(pTpTransacao,'X') = 'VERIFICA_ELEGIBILIDADE' THEN
    vNrDocumento:= NULL; --QND 真 ELEGIBILIDADE PASSA A CARTEIRA, NAO SENDO NECESSARIO DOCUMENTO (REMESSA)
  END IF;
  --Oswaldo 09/12
  --
  if pModo is NOT null or tConf('cabecalhoTransacao').tp_utilizacao > 0 then
    --
    if vcConv.cd_convenio<>nvl(pCdConv,0) then
      open  cConv(pCdConv);
      fetch cConv into vcConv;
      close cConv;
    end if;
    --
    -- tipoTransacao------------------------------------
    vCp := 'tipoTransacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := pTpTransacao;
      vCt.tipoTransacao := F_ST(null,vTemp,vCp,pCdConv,pTpTransacao,pCdMultiEmpresa,null,null);   -- dm_tipoTransacao
      vResult := vCt.tipoTransacao;
    end if;
    --
    -- sequencialTransacao------------------------------
    vCp := 'sequencialTransacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        select dbamv.seq_transacao_tiss.nextval into vTemp from sys.dual;
      vCt.sequencialTransacao := F_ST(null,vTemp,vCp,pCdConv,pTpTransacao,pCdMultiEmpresa,null,null);
      vResult := vCt.sequencialTransacao;
    end if;
    --
    -- dataRegistroTransacao----------------------------
    vCp := 'dataRegistroTransacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := to_char( sysdate, 'yyyy-mm-dd');
      vCt.dataRegistroTransacao := F_ST(null,vTemp,vCp,pCdConv,pTpTransacao,pCdMultiEmpresa,null,null);
      vResult := vCt.dataRegistroTransacao;
    end if;
    --
    -- horaRegistroTransacao----------------------------
    vCp := 'horaRegistroTransacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := to_char( sysdate, 'hh24:mi:ss');
      vCt.horaRegistroTransacao := F_ST(null,vTemp,vCp,pCdConv,pTpTransacao,pCdMultiEmpresa,null,null);
      vResult := vCt.horaRegistroTransacao;
    end if;
    --
    -- falhaNegocio-------------------------------------
    --
    -- **** preenchido autom真tico pelo webservice em caso de falha
    --
    -- origem-------------------------------------------
    -- identificacaoPrestador---------------------------
    vRet := F_ct_prestadorIdentificacao(null,1010,pTpTransacao,pCdMultiEmpresa,pCdConv,vCtPrestIdent,pMsg,vNrDocumento); -- Oswaldo BH
    if vRet = 'OK' then
      vCt.identificacaoPrestador.codigoPrestadorNaOperadora := vCtPrestIdent.codigoPrestadorNaOperadora;    -- codigoPrestadorNaOperadora
      vCt.identificacaoPrestador.CPF                        := vCtPrestIdent.CPF;                           -- CPF
      vCt.identificacaoPrestador.CNPJ                       := vCtPrestIdent.CNPJ;                          -- CNPJ
    end if;
    --
    -- destino------------------------------------------
    -- registroANS--------------------------------------
    vCp := 'registroANS'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
      vTemp := vcConv.nr_registro_operadora_ans;
      vCt.registroANS := F_ST(null,vTemp,vCp,pCdConv,pTpTransacao,pCdMultiEmpresa,null,null);
      vResult := vCt.registroANS;
    end if;
    --
    -- versaoPadrao-------------------------------------
    vCp := 'versaoPadrao'; vTemp := null;
    if  tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcConv.cd_versao_tiss;
      vCt.versaoPadrao := F_ST(null,vTemp,vCp,pCdConv,pTpTransacao,pCdMultiEmpresa,null,null);    -- dm_versao
      vResult := vCt.versaoPadrao;
    end if;
    --
    -- versaoPadrao-------------------------------------
    vCp := 'Padrao'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcConv.cd_versao_tiss;
      vCt.versaoPadrao := F_ST(null,vTemp,vCp,pCdConv,pTpTransacao,pCdMultiEmpresa,null,null);    -- dm_versao
      vResult := vCt.versaoPadrao;
    end if;
    --
    -- assinaturaDigital-------------------------------------
    -- *** definir CT
    -- loginSenhaPrestador-----------------------------------
    -- *** definir CT
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_epilogo (   pModo           in varchar2,
                        pIdMap          in number,
                        pIdTransacao    in number,
                        pCdConv         in dbamv.convenio.cd_convenio%type,
                        vCt             OUT NOCOPY RecEpilogo,
                        pMsg            OUT varchar2,
                        pReserva        in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  vCp	        varchar2(1000);
BEGIN
  -- leitura de cursores de uso geral
  -------------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  -------------------------------------------------------------
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('epilogo').tp_utilizacao > 0 then
    --
    -- hash---------------------------------------------
    vCp := 'hash'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := null;  -- ???
      vCt.hash := vTemp;
    --vNaoDeletar.hash := F_ST(null,vTemp,vCp,null,null,null,null,null);
      vResult := vCt.hash;
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_mensagemTISS (  pModo           in varchar2,
                            pIdMap          in number,
                            pTpTransacao    in varchar2,
                            pCdMultiEmpresa in dbamv.multi_empresas.cd_multi_empresa%type,
                            pCdConv         in dbamv.convenio.cd_convenio%type,
                            pNrDocumento    in varchar2,
                            vCt             OUT NOCOPY RecMensagemLote,
                            pMsg            OUT varchar2,
                            pReserva        in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(1000);
  vCp	            varchar2(1000);
  vRet              varchar2(1000);
  vTissMensagem     dbamv.tiss_mensagem%rowtype;
  vTissLote         dbamv.tiss_lote%rowtype;
  vTissLoteGuia     dbamv.tiss_lote_guia%rowtype;
  vCtCabecTransac   RecCabecTransac;
  vCtEpilogo        RecEpilogo;
  vCtContrat        RecContrat;
  pCdMultiEmpresaTmp    dbamv.multi_empresas.cd_multi_empresa%type;
  -- Oswaldo in真cio 210325
  pContrOrigemHard_VAL  varchar2(100);
  pContrOrigemHard_TAG  varchar2(100);
  -- Oswaldo fim 210325
  -- Oswaldo BH in真cio
  vDocumento VARCHAR2(100);
  vNrGuia    VARCHAR2(100);
  -- Oswaldo BH fim
BEGIN
  -- leitura de cursores de uso geral
  -------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdMultiEmpresaTmp := pCdMultiEmpresa; -- vari真vel para empresa Filha (caso multi_empresa distribu真do);
  --if pReserva is not null and length(pReserva)>=3 AND SubStr(pReserva,1,InStr(pReserva,'#')-1) <> 'SOLICITA_STATUS_AUTORIZACAO' then
  if ( pReserva is not null and length(pReserva)>=3 AND SubStr(pReserva,1,InStr(pReserva,'#')-1) <> 'SOLICITA_STATUS_AUTORIZACAO' )
     OR
     ( pReserva is not null and length(pReserva)>=3 AND Nvl(vcSnFatDistribuido,'N') = 'S')
  THEN
    pCdMultiEmpresaTmp := substr(pReserva,2,2);
  end if;
  if instr(pReserva,'#')>0  AND SubStr(pReserva,1,InStr(pReserva,'#')-1) <> 'SOLICITA_STATUS_AUTORIZACAO' then
	-- Oswaldo in真cio 210325
	pContrOrigemHard_TAG := NULL;
    pContrOrigemHard_VAL := substr(pReserva,instr(pReserva,'#')+1);
  end if;
  if instr(pReserva,'@')>0 then
	pContrOrigemHard_TAG := substr(pReserva,instr(pReserva,'#')+1,4);
	pContrOrigemHard_VAL := substr(pReserva,instr(pReserva,'@')+1);
  end if;
  -- Oswaldo fim 210325
  vTpOrigemSol := NULL;
  -------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  --if pModo is NOT null or tConf('mensagemTISS').tp_utilizacao > 0 then
    --
	-- Oswaldo BH in真cio
	IF pTpTransacao in ( 'ENVIO_ANEXO', 'CANCELA_GUIA', 'SOLICITA_STATUS_AUTORIZACAO') THEN
     vDocumento:= pReserva;
    ELSE
      IF InStr(pNrDocumento, '@') > 0 THEN
        vNrGuia := SubStr(pNrDocumento,1,InStr(pNrDocumento,'@')-1);
        vDocumento := To_Number(SubStr(pNrDocumento,InStr(pNrDocumento,'@')+1,Length(pNrDocumento)));
      else
        vDocumento:= pNrDocumento;
      END IF;
    END IF;
	-- Oswaldo BH fim
    -- cabecalho-----------------------------------
    vRet := F_cabecalhoTransacao(null,1002,pTpTransacao,pCdMultiEmpresaTmp,pCdConv,vCtCabecTransac,pMsg,vDocumento); -- Oswaldo BH
    if vRet = 'OK' then
      vTissMensagem.tp_transacao            := vCtCabecTransac.tipoTransacao;                                       -- tipoTransacao
      vTissMensagem.cd_seq_transacao        := vCtCabecTransac.sequencialTransacao;                                 -- sequencialTransacao
      vTissMensagem.DT_TRANSACAO            := vCtCabecTransac.dataRegistroTransacao;                               -- dataRegistroTransacao
      vTissMensagem.HR_TRANSACAO            := vCtCabecTransac.horaRegistroTransacao;                               -- horaRegistroTransacao
      vTissMensagem.CD_CGC_ORIGEM           := vCtCabecTransac.identificacaoPrestador.CNPJ;                         -- CNPJ
      vTissMensagem.CD_CPF_ORIGEM           := vCtCabecTransac.identificacaoPrestador.CPF;                          -- CPF
      vTissMensagem.CD_ORIGEM               := vCtCabecTransac.identificacaoPrestador.codigoPrestadorNaOperadora;   -- codigoPrestadorNaOperadora
      vTissMensagem.NR_REGISTRO_ANS_DESTINO := vCtCabecTransac.registroANS;                                         -- registroANS
      vTissMensagem.CD_VERSAO               := vCtCabecTransac.versaoPadrao;                                        -- versaoPadrao
      --
      -- For真a Contratado igual da guia de credenciado (obedencendo configura真真o de quebra lote por Prestador Credenciado)
      -- Oswaldo in真cio 210325
	  IF pContrOrigemHard_VAL IS NOT NULL THEN
        vTissMensagem.CD_CGC_ORIGEM := null;
		vTissMensagem.CD_CPF_ORIGEM := null;
		vTissMensagem.CD_ORIGEM     := null;
		IF pContrOrigemHard_TAG = 'CPF0' THEN
		  vTissMensagem.CD_CPF_ORIGEM := pContrOrigemHard_VAL;
		ELSIF pContrOrigemHard_TAG = 'OPER' THEN
		  vTissMensagem.CD_ORIGEM := pContrOrigemHard_VAL;
		ELSE
		  vTissMensagem.CD_CGC_ORIGEM := pContrOrigemHard_VAL;
		END IF;
		-- Oswaldo fim 210325
      end if;
      --
      -- informa真真es complementares de apoio
      vTissMensagem.nr_documento            := Nvl(vNrGuia,pNrDocumento); -- Oswaldo BH
      vTissMensagem.cd_convenio             := pCdConv;
      vTissMensagem.tp_mensagem_tiss        := pModo;
      --
      vcDadosTissMensagem := NULL;
      vcDadosTissMensagem := vTissMensagem;
      --
      vRet := F_gravaTissMensagem ('INSERE',vTissMensagem,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
      --
    --end if;
    --
    -- prestadorParaOperadora----------------------
    if pTpTransacao IN ('ENVIO_LOTE_GUIAS','RECURSO_GLOSA','ENVIO_ANEXO') then
      --
--op 46827 - adicionado o reler
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(1028,pCdConv,'Reler',null); -- reler
      -- ctm_guiaLote------------------------------
      vCp := 'numeroLote'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          if FNC_CONF('TP_NR_LOTE',pCdConv,null)='S' or pTpTransacao <> 'ENVIO_LOTE_GUIAS' then
            --
            open  cEmpresaConv(pCdMultiEmpresa, pCdConv);
            fetch cEmpresaConv into vcEmpresaConv;
            close cEmpresaConv;
            vTemp := vcEmpresaConv.nr_lote  + 1;
            update dbamv.empresa_convenio set nr_seq_lote = vTemp -- CONFERIR ????
              where cd_convenio      = pCdConv
                and cd_multi_empresa = pCdMultiEmpresa;
          else -- = 'C'
            --
            open  cRemessa(pNrDocumento, null);  -- pNrDocumento cont真m a remessa no caso de ENVIO_LOTE
            fetch cRemessa into vcRemessa;
            close cRemessa;
            vTemp := vcRemessa.nr_remessa_convenio;
          end if;
        vTissLote.nr_lote := F_ST(null,vTemp,vCp,pCdConv,vcRemessa.cd_remessa,vTissMensagem.id,pTpTransacao,substr(vTissMensagem.tp_mensagem_tiss,1,2));
      end if;
      --
      vTissLote.id_pai := vTissMensagem.id;
      --
      vRet := F_gravaTissLote (null,vTissLote,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
      --
      vTissMensagem.CD_STATUS   := 'PS';
      vTissMensagem.NR_LOTE     := vTissLote.nr_lote;
      --
      vRet := F_gravaTissMensagem ('ATUALIZA',vTissMensagem,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
    end if;
    --
    if pTpTransacao = 'RECURSO_GLOSA' and vTissLote.id is not null then
      --
      -- ctm_recursoGlosa--------------------------
      vTissLoteGuia.id_pai := vTissLote.id;
      -- registroANS-------------------------------
      vTissLoteGuia.NR_REGISTRO_ANS := vCtCabecTransac.registroANS;
      -- numeroGuiaRecGlosaPrestador---------------
      -- vTissLoteGuia.NR_GUIA_REC_GLOSA_PREST := pNrDocumento;
      -- nomeOperadora-----------------------------
      if nvl(vcConv.cd_convenio,9999) <> nvl(pCdConv,0) then
        open  cConv(pCdConv);
        fetch cConv into vcConv;
        close cConv;
      end if;
      vTissLoteGuia.NM_OPERADORA := vcConv.nm_convenio;
      -- objetoRecurso-----------------------------
      vTissLoteGuia.TP_OBJETO_RECURSO := '2'; -- dm_objetoRecurso
      -- numeroGuiaRecGlosaOperadora---------------
      vTissLoteGuia.NR_GUIA_REC_GLOSA_OPER := null;
      -- dadosContratado---------------------------
    --vRet := F_ct_contratadoDados(null,1834,null,null,null,null,null,pCdConv,vCtContrat,pMsg,null);
      vRet := F_ct_contratadoDados(null,1834,null,null,null,null,null,pCdConv,vCtContrat,pMsg,'RECURSO_GLOSA'); --OP 48413 - ajuste no codigoPrestadorNaOperadora do cabe真alho do envio do Recurso
      if vRet = 'OK' then
        vTissLoteGuia.CD_OPERADORA_EXE    := vCtContrat.codigoPrestadorNaOperadora;   -- codigoPrestadorNaOperadora
        vTissLoteGuia.CD_CPF_EXE          := vCtContrat.cpfContratado;                -- cpfContratado
        vTissLoteGuia.CD_CGC_EXE          := vCtContrat.cnpjContratado;               -- cnpjContratado
        vTissLoteGuia.NM_PRESTADOR_EXE    := vCtContrat.nomeContratado;               -- nomeContratado --Oswaldo FATURCONV-22404
      end if;
      -- numeroLote--------------------------------
    /*open  cEmpresaConv(pCdMultiEmpresa, pCdConv);
      fetch cEmpresaConv into vcEmpresaConv;
      close cEmpresaConv;
      vTemp := vcEmpresaConv.nr_lote  + 1;
      update dbamv.empresa_convenio set nr_seq_lote = vTemp -- CONFERIR ????
        where cd_convenio      = pCdConv
          and cd_multi_empresa = pCdMultiEmpresa;
      vTissLoteGuia.NR_LOTE := vTemp; */
      --
      vRet := F_gravaTissLoteGuia ('INSERE',vTissLoteGuia,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
      --
    end if;
    --
    -- epilogo--------------------------
    vRet := F_epilogo(null,1139,vTissMensagem.id,pCdConv,vCtEpilogo,pMsg,null);
    if vRet = 'OK' then
    --vTissMensagem.nr_hash := vCtEpilogo.hash; -- DEFINIR coluna !!!
    -- realizar Update na TISS_MENSAGEM ???  (j真 gravada mais acima)
      null;
    end if;
    ------------------------------------
    vCt.idMensagem  := vTissMensagem.id;
    vCt.nrLote      := nvl(vTissLoteGuia.NR_LOTE,vTissLote.NR_LOTE);
    vCt.idLote      := nvl(vTissLoteGuia.id,vTissLote.id);
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_GERA_TISS(  pModo         in varchar2,
                        pIdMap         in number,
                        pCdAtend       in dbamv.atendime.cd_atendimento%type,
                        pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                        pTpGeracao     in varchar2, -- G = Gera normal(caso n真o exista) ou retorna ID's se j真 existentes / R = Regera todas e retorna ID's gerados
                        pMsg           OUT varchar2,
                        pReserva       in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(4000);
  vCp	            varchar2(1000);
  vRet              varchar2(1000);
  pCdConv           dbamv.convenio.cd_convenio%type;
  vcTissGuiasCta    cTissGuiasCta%rowtype;
  vNrGuiaPrincipal  varchar2(100);
  pCdContaOrig      number;
  vcTissOutDesp     cTissOutDesp%rowtype;
  vParamAux         VARCHAR2(100);
  vTpAtend         varchar2(1);--Oswaldo FATURCONV-20760
BEGIN
  -- Reinicializa真真o de vari真veis globais caso haja mudan真a nos dados
  vcPaciente        := null;
  vcAtendimento     := null;
  vcAtendimentoAUX  := NULL;
  nCdGuiaPrinc      := null;
  pTussRel_old      := null;
  pTuss_Old         := null;
  vTpOrigemSol      := NULL;
  vcAutorizacao     := NULL;
  vPendenciaGuia    := NULL;
  vGerandoGuia      := 'N';
  vcItem            := NULL;  --OP 44582
  nEmpresaLogada    := dbamv.pkg_mv2000.le_empresa; --adhospLeEmpresa - ADICIONEI A VARIAVEL AQUI

  --
  -- leitura de cursores de uso geral
  if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
    vcAtendimento := null;
    open  cAtendimento(pCdAtend);
    fetch cAtendimento into vcAtendimento;
    close cAtendimento;
  end if;
  if pCdConta<>nvl(vcConta.cd_conta,0) then
    vcConta := null;
    open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
    fetch cConta into vcConta;
    close cConta;
  end if;
  -------------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv       :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  pCdContaOrig  :=  pCdConta;
  vTpAtend      :=  vcAtendimento.tp_atendimento; --Oswaldo FATURCONV-20760
  IF SubStr(pTpGeracao,1,12)='VAL_QT_GUIAS' then
    vParamAux   :=  pTpGeracao; -- parametro com outro conte真do (espec真fico), e o parametro passa a serconsiderado "G" para o uso original
  END IF;
  ------------------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(1001,pCdConv,null,null);       -- leitura geral (para pegar configura真真es gerais a primeira vez
  ------------------------------------------------------------
  if Nvl(pTpGeracao,'G') = 'R' or ( Nvl(pTpGeracao,'G') <> 'R' and vcConta.sn_fechada = 'N') then
    --
    vRet := F_apaga_tiss('APAGA_GUIAS_ENVIO',pCdAtend,pCdContaOrig,vcConta.cd_remessa,null,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
  end if;
  --
  vResult := null;
  for vcTissGuiasCta in cTissGuiasCta(vcAtendimento.tp_atendimento,pCdAtend,pCdContaOrig,null,null) LOOP
    vResult := vResult||LPAD(vcTissGuiasCta.id,20,'0')||',';
  end loop;
  -- s真 Gera guias se n真o houver (ou porque apagou pelo 'R' ou porque n真o tinha mesmo)
  if vResult is null then
    --
    --Oswaldo FATURCONV-20760 inicio
    vHomecareTpGuiaSP := 'N';
    IF vcAtendimento.tp_atendimento_original = 'H' AND vcAtendimento.cd_programas_homecare IS NOT NULL THEN
      Dbms_Output.Put_Line('Passou aqui 0');
        OPEN cProgramasHomecare (vcAtendimento.cd_programas_homecare);
        FETCH cProgramasHomecare INTO vcProgramasHomecare;
        CLOSE cProgramasHomecare;
      IF vcAtendimento.cd_atendimento_tiss IS NOT NULL AND vcProgramasHomecare.tp_guia = 'SP' THEN
        Dbms_Output.Put_Line('Passou aqui 1');
        vTpAtend := 'A';
        vHomecareTpGuiaSP := 'S';
      END IF;
    END IF;

    --if vcAtendimento.tp_atendimento = 'I' THEN
    if vTpAtend = 'I' THEN
    --Oswaldo FATURCONV-20760 fim
      --
      -- GERAR R.I. --------------------------------------------
      vResult := F_ctm_internacaoResumoGuia(null,1031,pCdAtend,pCdContaOrig,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
      vNrGuiaPrincipal := substr(vResult,1,20);
      --
      -- GERAR S.P. (Guias Espec真ficas) ------------------------
      vcTissSP_Proc := null;
      if nvl(FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_HOSP',pCdConv,null),'1') = '2' then
        open cTissSP_Proc(pCdAtend,pCdContaOrig,'SECUNDARIAS',null);
        fetch cTissSP_Proc into vcTissSP_Proc;
        IF cTissSP_Proc%FOUND THEN
          LOOP
          --vRet := F_ctm_sp_sadtGuia(null,1141,pCdAtend,pCdContaOrig          ,'SECUNDARIAS',null,pMsg,vNrGuiaPrincipal);
            vRet := F_ctm_sp_sadtGuia(null,1141,pCdAtend,vcTissSP_Proc.cd_conta,'SECUNDARIAS',null,pMsg,vNrGuiaPrincipal);
            if pMsg is not null then
              if cTissSP_Proc%isOpen then
                close cTissSP_Proc;
              end if;
              RETURN NULL;
            end if;
            vResult := vResult||vRet;
            EXIT when NOT cTissSP_Proc%isOpen or cTissSP_Proc%NOTFOUND;
          END LOOP;
        END IF;
        if cTissSP_Proc%isOpen then
          close cTissSP_Proc;
        end if;
        --
        -- espec真fica residual despesas (despesas sem servi真o e espec真ficas)
        for i in (select distinct cd_guia from dbamv.itreg_fat where cd_reg_fat = pCdConta
                        and id_it_envio is null and nvl(tp_pagamento,'P') = 'P' and sn_pertence_pacote = 'N' and cd_guia is not null
                        and f_ret_tp_grupro(pCdAtend,pCdConta,cd_lancamento,null,null,null) NOT in ('SP','SD')) loop
          vcTissSP_Proc := null;
          nCdGuiaSecundaria := i.cd_guia;
          vRet := F_ctm_sp_sadtGuia(null,1141,pCdAtend,pCdContaOrig,'SECUNDARIAS',null,pMsg,vNrGuiaPrincipal);
          if pMsg is not null then
            RETURN NULL;
          end if;
          vResult := vResult||vRet;
        end loop;
        nCdGuiaSecundaria := null;
      end if;
      --
      -- GERAR H.I. ---------------------------------
      if tConf('ctm_honorarioIndividualGuia').tp_utilizacao > 0 then
        open cTissHI( pCdAtend,pCdContaOrig,null);
        fetch cTissHI into vcTissHI;
        IF cTissHI%FOUND THEN
          LOOP
            vRet := f_ctm_honorarioIndividualGuia(null,1142,pCdAtend,vcTissHI.cd_conta,vcTissHI.cd_prestador,vcTissHI.nr_guia_conv,vcTissHI.nr_senha_conv,pMsg,null);
            if pMsg is not null then
              if cTissHI%isOpen then
                close cTissHI;
              end if;
              RETURN NULL;
            end if;
            vResult := vResult||vRet;
            EXIT when NOT cTissHI%isOpen;
          END LOOP;
        END IF;
        if cTissHI%isOpen then
          close cTissHI;
        end if;
      end if;
      --
      -- GERAR S.P. (Credenciados) ------------------
      if tConf('ctm_sp-sadtGuia').tp_utilizacao > 0 and FNC_CONF('TP_GERA_CRED_SP_HOSP',pCdConv,null)> '1'then
        if cTissSP_Proc%isOpen then
          close cTissSP_Proc;
        end if;
        open cTissSP_Proc(pCdAtend,pCdContaOrig,'CRED_INTERNACAO',null);
        fetch cTissSP_Proc into vcTissSP_Proc;
        IF cTissSP_Proc%FOUND THEN
          LOOP
            vRet := F_ctm_sp_sadtGuia(null,1141,pCdAtend,vcTissSP_Proc.cd_conta,'CRED_INTERNACAO',vcTissSP_Proc.cd_prestador,pMsg,vNrGuiaPrincipal);
            if pMsg is not null then
              if cTissSP_Proc%isOpen then
                close cTissSP_Proc;
              end if;
              RETURN 'FALHA';
            end if;
            vResult := vResult||vRet;
            EXIT when NOT cTissSP_Proc%isOpen;
          END LOOP;
        END IF;
        if cTissSP_Proc%isOpen then
          close cTissSP_Proc;
        end if;
      end if;
      --
      -- Credenciado residual despesas (despesas sem servi真o e credenciada)
      for i in (select distinct CD_PRESTADOR from dbamv.itreg_fat where cd_reg_fat = pCdConta
                    and cd_prestador is NOT null and id_it_envio is null and nvl(tp_pagamento,'P') = 'C' and sn_pertence_pacote = 'N'
                    and f_ret_tp_grupro(pCdAtend,pCdConta,cd_lancamento,null,null,null) NOT in ('SP','SD')) loop
        --
        vcTissSP_Proc := null;
        vRet := F_ctm_sp_sadtGuia(null,1141,pCdAtend,pCdConta,'CRED_INTERNACAO',i.cd_prestador,pMsg,vNrGuiaPrincipal);
        if pMsg is not null then
          RETURN 'FALHA';
        end if;
        vResult := vResult||vRet;
        --
      end loop;
      --
    else
      --
      vcTissCO := null;
      if FNC_CONF('SN_GUIA_CONSULTA',pCdConv,null) = 'S' then
        open  cTissCO(pCdAtend,pCdContaOrig,null);
        fetch cTissCO into vcTissCO;
        close cTissCO;
      end if;
      if nvl(vcTissCO.SN_TEM_CONSULTA,'N') = 'S' then
        --
        -- GERAR C.O. -------------------------------
        --
        vResult := F_ctm_consultaGuia(null,1190,pCdAtend,pCdContaOrig,vcTissCO.cd_lanc,pMsg,null);
        if pMsg is not null then
          RETURN NULL;
        end if;
        --
      end if;
      --
      if vResult is null then
        --
        if nvl(FNC_CONF('TP_CONTA_HONORARIO_HI',pCdConv,null),'1') = '2' then
          --
          -- GERAR H.I. (casos especiais d eambulat真rios) -------------------
          if tConf('ctm_honorarioIndividualGuia').tp_utilizacao > 0 then
            open cTissHI( pCdAtend,pCdContaOrig,vcAtendimento.tp_atendimento);
            fetch cTissHI into vcTissHI;
            IF cTissHI%FOUND THEN
              LOOP
                vRet := f_ctm_honorarioIndividualGuia(null,1142,pCdAtend,vcTissHI.cd_conta,vcTissHI.cd_prestador,vcTissHI.nr_guia_conv,vcTissHI.nr_senha_conv,pMsg,null);
                if pMsg is not null then
                  if cTissHI%isOpen then
                    close cTissHI;
                  end if;
                  RETURN NULL;
                end if;
                vResult := vResult||vRet;
                EXIT when NOT cTissHI%isOpen;
              END LOOP;
            END IF;
            if cTissHI%isOpen then
              close cTissHI;
            end if;
          end if;
        end if;
      end if;
      --
      if vResult is null then
        --
        -- GERAR S.P. (Principal) -----------------------------------
        -- Processo normal, gera apenas a guia principal.  Qdo. Guia espec真fica, gera a principal (primeira) e secund真rias se houver (todas "P")
        --
        vcTissSP_Proc := null;
        open cTissSP_Proc(pCdAtend,pCdContaOrig,'PRINCIPAL',null);
        fetch cTissSP_Proc into vcTissSP_Proc;
        close cTissSP_Proc;
        vcTissOutDesp := NULL;
        open  cTissOutDesp('A',pCdAtend,pCdContaOrig,null,null,null);
        fetch cTissOutDesp into vcTissOutDesp;
        close cTissOutDesp;
        --
        if (vcTissSP_Proc.cd_lanc is not null or vcTissOutDesp.cd_lanc is not NULL) or pCdContaOrig IS null THEN
          vResult := F_ctm_sp_sadtGuia(null,1141,pCdAtend,pCdContaOrig,'PRINCIPAL',null,pMsg,null);
          if pMsg is not null then
            RETURN NULL;
          end if;
          vNrGuiaPrincipal := substr(vResult,1,20);
        end if;
        --
        -- Guias secund真rias (espec真ficas)
        vcTissSP_Proc := null;
        if nvl(FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_AMB',pCdConv,null),'1') = '2' then
          open cTissSP_Proc(pCdAtend,pCdContaOrig,'SECUNDARIAS',null);
          fetch cTissSP_Proc into vcTissSP_Proc;
          IF cTissSP_Proc%FOUND THEN
            LOOP
              vRet := F_ctm_sp_sadtGuia(null,1141,pCdAtend,pCdContaOrig,'SECUNDARIAS',null,pMsg,vNrGuiaPrincipal);
              if pMsg is not null then
                if cTissSP_Proc%isOpen then
                  close cTissSP_Proc;
                end if;
                RETURN NULL;
              end if;
              vResult := vResult||vRet;
              EXIT when NOT cTissSP_Proc%isOpen or cTissSP_Proc%NOTFOUND;
            END LOOP;
          END IF;
          if cTissSP_Proc%isOpen then
            close cTissSP_Proc;
          end if;
          --
          -- espec真fica residual despesas (despesas sem servi真o e espec真ficas)
          for i in (select distinct cd_guia from dbamv.itreg_amb where cd_atendimento = pCdAtend and cd_reg_amb = pCdConta
                          and id_it_envio is null and nvl(tp_pagamento,'P') = 'P' and sn_pertence_pacote = 'N' and cd_guia is not null
                          and f_ret_tp_grupro(pCdAtend,pCdConta,cd_lancamento,null,null,null) NOT in ('SP','SD')) loop
            vcTissSP_Proc := null;
            nCdGuiaSecundaria := i.cd_guia;
            vRet := F_ctm_sp_sadtGuia(null,1141,pCdAtend,pCdContaOrig,'SECUNDARIAS',null,pMsg,vNrGuiaPrincipal);
            if pMsg is not null then
              RETURN NULL;
            end if;
            vResult := vResult||vRet;
          end loop;
          nCdGuiaSecundaria := null;
        end if;
        --
        -- GERAR S.P. (Credenciados) --------------------------------
        open cTissSP_Proc(pCdAtend,pCdContaOrig,'CREDENCIADOS',null);
        fetch cTissSP_Proc into vcTissSP_Proc;
        IF cTissSP_Proc%FOUND THEN
          LOOP
            vRet := F_ctm_sp_sadtGuia(null,1141,pCdAtend,pCdContaOrig,'CREDENCIADOS',vcTissSP_Proc.cd_prestador,pMsg,vNrGuiaPrincipal);
            if pMsg is not null then
              if cTissSP_Proc%isOpen then
                close cTissSP_Proc;
              end if;
              RETURN NULL;
            end if;
            vResult := vResult||vRet;
            EXIT when NOT cTissSP_Proc%isOpen;
          END LOOP;
        END IF;
        if cTissSP_Proc%isOpen then
          close cTissSP_Proc;
        end if;
      end if;
      --
      -- Credenciado residual despesas (despesas sem servi真o e credenciada)
      for i in (select distinct CD_PRESTADOR from dbamv.itreg_amb where cd_atendimento = pCdAtend and cd_reg_amb = pCdConta
                    and cd_prestador is NOT null and id_it_envio is null and nvl(tp_pagamento,'P') = 'C' and sn_pertence_pacote = 'N'
                    and f_ret_tp_grupro(pCdAtend,pCdConta,cd_lancamento,null,null,null) NOT in ('SP','SD')) loop
        --
        vcTissSP_Proc := null;
        vRet := F_ctm_sp_sadtGuia(null,1141,pCdAtend,pCdConta,'CRED_INTERNACAO',i.cd_prestador,pMsg,vNrGuiaPrincipal);
        if pMsg is not null then
          RETURN 'FALHA';
        end if;
        vResult := vResult||vRet;
        --
      end loop;
      --
    end if;
    --
  end if;
  ----------------------
  -- reinicializa vari真veis para o caso destes modelos de guias serem acionados por outra rotina de forma avulsa (guia em branco) devem estar "limpas" na mem真ria.
  vcTissSP_Proc := null;
  vcTissHI      := null;
  ----------------------
  --
  -- Funcionalidade alternativa:  Confere se guias desta conta cabem nos lotes da remessa informada (considerando conf.qtde.guia)
  -- SINTAXE:  VAL_QT_GUIAS#99999999 (sendo 99999999 o n真mero da remessa desejada)
  --
  if SubStr(Nvl(vParamAux,'X'),1,12) = 'VAL_QT_GUIAS' and pCdConta is not null then
    --
    for vcGuiasGeradas in cGuiasGeradas( substr(vParamAux,14),null,vcAtendimento.tp_atendimento||'#'||lpad(pCdAtend,10,'0')||'#'||lpad(pCdConta,10,'0') ) LOOP
      if vcGuiasGeradas.tt > FNC_CONF('NR_LIMITE_GUIAS',pCdConv,null) then
        -- O termo "ATENCAO" deve ser mantido, pois ele sinalizar真 a resposta diferenciada desta fun真真o alternativa.
        pMsg := 'Aten真真o: o(s) lote(s) de guias TISS desta remessa ultrapassa o limite de '
                    ||FNC_CONF('NR_LIMITE_GUIAS',pCdConv,null)||' guias.';
      end if;
    end loop;
    --
  end if;
  --
  if vResult is null THEN
    IF Nvl(pReserva,'X')<>'P_SEM_COMMIT' then
      ROLLBACK;
    END IF;
    IF pMsg IS NULL THEN
      pMsg := 'N真o foram geradas Guias TISS';
    END IF;
    return NULL;
  else
    IF Nvl(pReserva,'X')<>'P_SEM_COMMIT' then
      COMMIT;
    END IF;
    return vResult;
  end if;
  --
  EXCEPTION
    when OTHERS THEN
      if cTissSP_Proc%isOpen then
        close cTissSP_Proc;
      end if;
      if cTissHI%isOpen then
        close cTissHI;
      end if;
      pMsg := 'FALHA na gera真真o de guias :'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
function F_apaga_tiss(  pModo           in varchar2,
                        pCdAtend        in dbamv.atendime.cd_atendimento%type,
                        pCdConta        in dbamv.reg_fat.cd_reg_fat%type,
                        pCdRemessa      in dbamv.remessa_fatura.cd_remessa%type,
                        pCdRemessaGlosa in dbamv.remessa_glosa.cd_remessa_glosa%type,
                        pMsg            OUT varchar2,
                        pReserva        in varchar2) return varchar2 IS
  --
  cursor cLoteEnvio is
     select  tm.id
            ,tm.tp_transacao
            ,tm.nr_protocolo_retorno
            ,tm.nr_documento
            ,tl.id     id_tl
       from dbamv.tiss_mensagem tm, dbamv.tiss_lote tl
       where tm.nr_documento = to_char(pCdRemessa)
         and tm.tp_transacao = 'ENVIO_LOTE_GUIAS'
         and tm.id = tl.id_pai
         -- se tiver outro tipo de mensagem da mesma remess真o n真o cancela pois pode ser envio de recursos (n真o pode retroceder)
         and not exists (select 'X'
                            from dbamv.tiss_mensagem tm1
                            where tm1.nr_documento = to_char(pCdRemessa)
                              and tm1.tp_transacao = 'RECURSO_GLOSA');
  --
  vResult	          varchar2(1000);
  --
begin
  -- Rotina que apaga lotes de ENVIO da remessa e desvincula guias
  if pModo = 'APAGA_LOTE_ENVIO' and pCdRemessa is not null then
    --
    for vcLoteEnvio in cLoteEnvio loop
      --
      update dbamv.tiss_guia
         set id_pai = NULL
        where id_pai = vcLoteEnvio.id_tl;
      --
      delete dbamv.tiss_lote
        where id = vcLoteEnvio.id_tl;
      --
      delete dbamv.tiss_log
        where id_mensagem = vcLoteEnvio.id;
      --
      delete dbamv.tiss_mensagem
        where id = vcLoteEnvio.id;
      --
    end loop;
    --
    COMMIT;
    --
    vResult := 'OK';
    --
  end if;
  --
  -- Rotina que apaga guias de ENVIO das contas
--  if pModo = 'APAGA_GUIAS_ENVIO' and (pCdAtend is not null and pCdConta is not null) then
  if pModo = 'APAGA_GUIAS_ENVIO' and ((pCdAtend is not null and pCdConta is not null) or (pCdAtend is not null and vcAtendimento.tp_atendimento = 'A')) then
--  if pModo = 'APAGA_GUIAS_ENVIO' then
    -- leitura de cursores de uso geral
    --
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    --
    -- apagar legado e/ou contas mudadas de remessa ap真s ter o XML gerado
    delete from dbamv.tiss_guia  where id in (select tg.id
                                                from dbamv.tiss_mensagem tm
                                                    ,dbamv.tiss_lote tl
                                                    ,dbamv.tiss_guia tg
                                                    ,dbamv.reg_fat rf
                                                where tm.id = tl.id_pai
                                                  AND tm.tp_transacao = 'ENVIO_LOTE_GUIAS'
                                                  and tl.id = tg.id_pai
                                                  and tg.cd_reg_fat = rf.cd_reg_fat
                                                  and rf.cd_remessa = pCdRemessa
                                                  and rf.cd_remessa <> to_number(tm.nr_documento) UNION
                                                select tg.id
                                                from dbamv.tiss_mensagem tm
                                                    ,dbamv.tiss_lote tl
                                                    ,dbamv.tiss_guia tg
                                                    ,dbamv.reg_amb ra
                                                    , dbamv.itreg_amb it
                                                where tm.id = tl.id_pai
                                                  AND tm.tp_transacao = 'ENVIO_LOTE_GUIAS'
                                                  and tl.id = tg.id_pai
                                                  and tg.cd_reg_amb = it.cd_reg_amb
                                                  and tg.cd_atendimento = it.cd_atendimento
                                                  and ra.cd_reg_amb = it.cd_reg_amb
                                                  and ra.cd_remessa = pCdRemessa
                                                  and ra.cd_remessa <> to_number(tm.nr_documento)  );
    --
    -- apagar legado de guias ambulatoriais que mudaram o REG_AMB (ex: ao excluir toda a conta e digitar novamente, o sistema cria novo REG_AMB)
    DELETE from dbamv.tiss_guia tg
      WHERE tg.cd_atendimento = pCdAtend
        AND tg.cd_reg_amb IS NOT null
        AND NOT EXISTS ( SELECT 'X' FROM dbamv.itreg_amb WHERE cd_reg_amb = tg.cd_reg_amb AND cd_atendimento = pCdAtend);
    --
    tFaixaGuias.delete; -- guardar真 guias j真 utilizadas
    --
    for vTissGuia in cTissGuiasCta(vcAtendimento.tp_atendimento, pCdAtend, pCdConta, pCdRemessaGlosa, null) loop --  CONFERIR cursor !!!!!
      if vTissGuia.id_pai is not null AND pCdRemessa is not null then
        pMsg:= 'Guias TISS do atendimento '||pCdAtend||' n真o podem ser apagadas, pois j真 est真o em Lote de Envio XML-Tiss. Cancele o Lote para poder regerar as guias.';
        vResult := NULL;
        EXIT;
      end if;
      --
      delete dbamv.tiss_itguia_equ        where id_pai in (select id from dbamv.tiss_itguia where id_pai = vTissGuia.id);
      delete dbamv.tiss_itguia_op         where id_pai = vTissGuia.id;
      delete dbamv.tiss_itguia_op_sol     where id_pai = vTissGuia.id;
      delete dbamv.tiss_itguia_out        where id_pai = vTissGuia.id;
      delete dbamv.tiss_itguia            where id_pai = vTissGuia.id;
      delete dbamv.tiss_itguia_cid        where id_pai = vTissGuia.id;
      delete dbamv.tiss_itguia_obito      where id_pai = vTissGuia.id;
      delete dbamv.tiss_itguia_declaracao where id_pai = vTissGuia.id;
      delete from dbamv.tiss_guia         where id = vTissGuia.id;
      --
      -- Guardar guias utilizadas antes de apagar, caso precise de reuso.
      if NOT tFaixaGuias.exists(vTissGuia.tp_guia) then
        tFaixaGuias(vTissGuia.tp_guia).nr_guias := ''; -- inicializa record do tipo de guia
      end if;
      tFaixaGuias(vTissGuia.tp_guia).nr_guias := lpad(vTissGuia.nr_guia,20,' ')||','||tFaixaGuias(vTissGuia.tp_guia).nr_guias;
      --
    end loop;
    --
    if vcAtendimento.tp_atendimento = 'I' then
      update dbamv.itreg_fat set id_it_envio = NULL where cd_reg_fat = pCdConta; -- or cd_conta_pai = pCdConta;
      update dbamv.itlan_med set id_it_envio = NULL where cd_reg_fat = pCdConta; --in (select cd_reg_fat from dbamv.reg_fat where cd_reg_fat = pCdConta or cd_conta_pai = pCdConta);    -- << CONFERIR
	  --FATURCONV-7309 - inicio
      if vcSnFatDistribuido IS NULL then
        OPEN  cSnFatDistribuido;
        FETCH cSnFatDistribuido INTO vcSnFatDistribuido;
        CLOSE cSnFatDistribuido;
      end if;

      IF Nvl(vcSnFatDistribuido,'N') = 'S' THEN
        update dbamv.itreg_fat set id_it_envio = NULL where cd_conta_pai = pCdConta;
        update dbamv.itlan_med set id_it_envio = NULL where cd_reg_fat in (select cd_reg_fat from dbamv.reg_fat where cd_conta_pai = pCdConta);    -- << CONFERIR
      END IF;
      --FATURCONV-7309 - fim
    else
      update dbamv.itreg_amb set id_it_envio = NULL where cd_atendimento = pCdAtend and cd_reg_amb = pCdConta;
    end if;
    --
    vResult := 'OK';
    --
  end if;
  --
  return vResult;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'Erro ao apagar informa真真es anteriores do TISS. FALHA: '||SQLERRM;
      RETURN NULL;
  --
end;
--
--==================================================
FUNCTION  F_ctm_honorarioIndividualGuia(pModo           in varchar2,
                                        pIdMap          in number,
                                        pCdAtend        in dbamv.atendime.cd_atendimento%type,
                                        pCdConta        in dbamv.reg_fat.cd_reg_fat%type,
                                        pCdPrest        in dbamv.prestador.cd_prestador%type,
                                        pNrGuia         in varchar2,
                                        pNrSenha        in varchar2,
                                        pMsg            OUT varchar2,
                                        pReserva        in varchar2) return varchar2 IS
  --
  vTemp	                varchar2(4000);
  vResult               varchar2(1000);
  vCp	                  varchar2(1000);
  vRet                  varchar2(1000);
  vTissGuia             dbamv.tiss_guia%rowtype;
  vTissItGuia           dbamv.tiss_itguia%rowtype;
  vTissItGuiaEqu        dbamv.tiss_itguia_equ%rowtype;
  pCdConv               dbamv.convenio.cd_convenio%type;
  vCtAutorizInt         RecAutorizInt;
  vCtBenef              RecBenef;
  vCtCabec              RecCabec;
  vCtProcHI             RecProcHI;
  vCtRecLocContrat      RecLocContrat;
  vCtContrExec          RecContrExec;
  vCtVlTotal            RecVlTotal; --add verificar
  pCdPrestTmp           number;
  pCdPrestContr         number;
  nVlTotalHI            number := 0;
  pCdContaOrig          number;
  pCdEmpresaTmp         dbamv.multi_empresas.cd_multi_empresa%type;
  pModoIt               varchar2(1000);
  vCdPresEquipeTMP      dbamv.prestador.cd_prestador%type;
  vNrGuiaTmp            VARCHAR2(1000);
  vNrSenhaTmp           VARCHAR2(1000);
BEGIN
  --
  if pModo IS NULL THEN  vGerandoGuia := 'S'; END IF;
  --
  -- Inicia o sequenciamento dos itens
  nSqItem:=0;
  --
  -- leitura de cursores de uso geral
  if pCdAtend is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
  end if;
  if pCdConta is not null then
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  else
    vcConta := null;
  end if;
  --
  pCdConv         :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  ------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdPrestTmp     :=  pCdPrest;    --  BUG !!!  vari真vel pra contornar erro do sistema que altera variavel pCdPrest dentro do programa!
  pCdContaOrig    :=  pCdConta;
  pCdEmpresaTmp   :=  nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa);
  if instr(nvl(pReserva,'X'),'#')>0 then
    pCdEmpresaTmp := substr(pReserva,instr(pReserva,'#')+1,4); -- empresa for真ada para uso aqui na guia
  end if;
  --
  if nvl(vcConv.cd_convenio,9999) <> nvl(pCdConv,0) THEN
    vcConv := NULL;
    open  cConv(pCdConv);
    fetch cConv into vcConv;
    close cConv;
  end if;
  --
  -- condi真真o especial, verifica se pode haver prestador Terceirizado (configura真真o especial de prestador associado 真 Servi真o do Atendimento)
  -- Somente para o caso da HI ser gerada com prestadores agrupados.
  if pCdPrestTmp is null and  nvl(FNC_CONF('TP_CONTA_HONORARIO_HI',pCdConv,null),'1') = '2' then
    pCdPrestContr := F_ret_prestador (pCdAtend,pCdConta,null,null,null,null,'HI','CONTRATADO_EXTERNO',null);
  end if;
  vNrGuiaTmp    := pNrGuia;
  vNrSenhaTmp   := pNrSenha;
  ------------------------------------------------------
  vCp := 'ctm_honorarioIndividualGuia'; vTemp := null;
  if tConf(vCp).tp_utilizacao > 0 then
    --
    -- cabecalhoGuia------------------------------------
    vRet := F_ct_guiaCabecalho(null,1143,pCdAtend,pCdContaOrig,pCdConv,null,'HI',vCtCabec,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.nr_registro_operadora_ans   := vCtCabec.registroANS;
      vTissGuia.NR_GUIA                     := vCtCabec.numeroGuiaPrestador;
      --
      vTissGuia.ID                          := vCtCabec.ID_GUIA; -- op真真o
    else
      RETURN NULL;
    end if;
    --
    -- guiaSolicInternacao------------------------------
    vCp := 'guiaSolicInternacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        --
        -- ???  PENDENTE - criar op真真es iguais ao RI
        --
        if nvl(vcAutorizacao.cd_guia,0)<>vcAtendimento.cd_guia THEN
          vcAutorizacao := NULL;
          open  cAutorizacao(vcAtendimento.cd_guia,null);
          fetch cAutorizacao into vcAutorizacao;
          close cAutorizacao;
        end if;
        vTemp := vcAutorizacao.nr_guia;
      vTissGuia.NR_GUIA_PRINCIPAL := F_ST(null,vTemp,vCp,vcAtendimento.cd_guia,pCdAtend,pCdContaOrig,null,null); -- trocado NR_GUIA_SOL
    end if;
    --
    -- senha--------------------------------------------
    vCp := 'senha'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
      vTemp := Nvl(vNrSenhaTmp,vcAutorizacao.nr_senha);
      vTissGuia.CD_SENHA := F_ST(null,vTemp,vCp,pCdAtend,pCdContaOrig,pCdPrestTmp,null,null);
    end if;
    --
    -- numeroGuiaOperadora------------------------------
    vCp := 'numeroGuiaOperadora'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
      vTemp := Nvl(vNrGuiaTmp,vcAutorizacao.nr_guia);
      vTissGuia.NR_GUIA_OPERADORA := F_ST(null,vTemp,vCp,pCdAtend,pCdContaOrig,pCdPrestTmp,null,null);
    end if;
    --
    -- beneficiario-------------------------------------
    vTissGuia.NR_CARTEIRA       := F_ct_beneficiarioDados('numeroCarteira',1673,pCdAtend,pCdConta,null,null,'E',vCtBenef,pMsg,'RelerPac');
    vTissGuia.NM_PACIENTE       := F_ct_beneficiarioDados('nomeBeneficiario',1674,pCdAtend,pCdConta,null,null,'E',vCtBenef,pMsg,null);
	vTissGuia.NM_SOCIAL_PACIENTE := F_ct_beneficiarioDados('nomeSocialBeneficiario',1674,pCdAtend,pCdConta,null,null,'E',vCtBenef,pMsg,null); --Oswaldo FATURCONV-26150
    vTissGuia.sn_atendimento_rn := F_ct_beneficiarioDados('atendimentoRN',1675,pCdAtend,pCdConta,null,null,'E',vCtBenef,pMsg,null);
    --
    -- localContratado----------------------------------
    vRet := F_ct_localContratado(null,1152,pCdAtend,pCdContaOrig,NULL,pCdConv,vCtRecLocContrat,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.CD_OPERADORA_SOL := vCtRecLocContrat.codigoNaOperadora;
      vTissGuia.CD_CGC_SOL       := vCtRecLocContrat.cnpjLocalExecutante;
      vTissGuia.NM_PRESTADOR_SOL := vCtRecLocContrat.nomeContratado;
      vTissGuia.CD_CNES_SOL      := vCtRecLocContrat.cnes;
    end if;
    --
    -- dadosContratadoExecutante------------------------
    vRet := F_ct_dadosContratadoExecutante(null,1158,pCdAtend,pCdContaOrig,nvl(pCdPrestTmp,pCdPrestContr),pCdConv,vCtContrExec,pMsg,pReserva);
    if vRet = 'OK' then
      vTissGuia.CD_OPERADORA_EXE        :=  vCtContrExec.codigonaOperadora;
      vTissGuia.NM_PRESTADOR_CONTRATADO :=  vCtContrExec.nomeContratadoExecutante; --Oswaldo FATURCONV-22404
      vTissGuia.CD_CNES_EXE             :=  vCtContrExec.cnesContratadoExecutante;
    end if;
    --
    -- dadosInternacao----------------------------------
    -- dataInicioFaturamento----------------------------
    vCp := 'dataInicioFaturamento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcConta.dt_inicio;
      vTissGuia.DT_INICIO_FATURAMENTO := F_ST(null,vTemp,vCp,pCdAtend,pCdContaOrig,null,null,null);
    end if;
    --
    -- dataFinalFaturamento-----------------------------
    vCp := 'dataFimFaturamento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcConta.dt_final;
      vTissGuia.DT_FINAL_FATURAMENTO := F_ST(null,vTemp,vCp,pCdAtend,pCdContaOrig,null,null,null);
    end if;
    --
    -- observacao---------------------------------------
    vCp := 'observacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        --
        if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_OBS_JUSTIFIC_MED_HI',pCdConv,null) = 'O' then --O - Observacao da tela de guias
          if nvl(vcAutorizacao.cd_guia,0)<>vcAtendimento.cd_guia then
            open  cAutorizacao(vcAtendimento.cd_guia,null);
            fetch cAutorizacao into vcAutorizacao;
            close cAutorizacao;
          end if;
          --
          vTemp := substr(vcAutorizacao.ds_observacao,1,1000);
          --
        elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_OBS_JUSTIFIC_MED_HI',pCdConv,null) = 'J' then --J - Justificativa da tela de guias
          if nvl(vcAutorizacao.cd_guia,0)<>vcAtendimento.cd_guia then
            open  cAutorizacao(vcAtendimento.cd_guia,null);
            fetch cAutorizacao into vcAutorizacao;
            close cAutorizacao;
          end if;
          --
          vTemp := substr(vcAutorizacao.ds_justificativa,1,1000);
          --
        elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_OBS_JUSTIFIC_MED_HI',pCdConv,null) = 'A' then --A - Informa真真o/Observacao do atendimento
          if nvl(vcAtendimentoAUX.cd_atendimento,0)<>pCdAtend then
            open cAtendimentoAUX(pCdAtend);
            fetch cAtendimentoAUX into vcAtendimentoAUX;
            close cAtendimentoAUX;
          end if;
          --
          vTemp := substr(vcAtendimentoAUX.ds_info_atendimento,1,1000); -- ???
          --
        end if;
        --CAFL
        vTemp := replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                   vTemp
                 ,'3.02.00','3-02-00')
                 ,'3.02.01','3-02-01')
                 ,'3.02.02','3-02-02')
                 ,'3.03.00','3-03-00')
                 ,'3.03.01','3-03-01')
                 ,'3.03.02','3-03-02')
                 ,'3.03.03','3-03-03')
                 ,'3.04.00','3-04-00')
                 ,'3.04.01','3-04-01')
                 ,'3.05.00','3-05-00')
                 ,'4.00.00','4-00-00')
                 ,'4.00.01','4-00-01')
                 ,'4.01.00','4-01-00');
      -- ATEN真真O, coluna aumentada em 30/09/2014 -- vTemp := substr(vTemp,1,100); -- limita真ao provis真ria (de 500 p 100)
      -- vTemp := F_ST(null,vTemp,vCp,pCdAtend,pCdContaOrig,pCdPrestTmp,null,null);
      vTissGuia.DS_OBSERVACAO := F_ST(null,vTemp,vCp,pCdAtend,pCdContaOrig,pCdPrestTmp,null,null);
    end if;
    --
    -- dataEmissaoGuia----------------------------------
    vCp := 'dataEmissaoGuia'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := to_char(sysdate,'yyyy-mm-dd');
      vTissGuia.DT_EMISSAO := F_ST(null,vTemp,vCp,pCdAtend,pCdContaOrig,null,null,null);
    end if;
    --
    -- assinaturaDigital--------------------------------
    --vRet := F_assinaturaDigital(null,9999,null,null,null,null,null,null);
    --
    -- GRAVA真真O DO REGISTRO DA GUIA---------------------
    --
    -- informa真真es complementares de apoio
     vTissGuia.cd_versao_tiss_gerada := vcConv.cd_versao_tiss;
    vTissGuia.cd_convenio := pCdConv;
    vTissGuia.cd_atendimento := pCdAtend;
    if vcAtendimento.tp_atendimento = 'I' then
      vTissGuia.cd_reg_fat := nvl(vcConta.cd_conta_pai,pCdContaOrig);
    else
      vTissGuia.cd_reg_amb := pCdContaOrig;
    end if;
    vTissGuia.cd_remessa := vcConta.cd_remessa;
    vTissGuia.nm_autorizador_conv := 'C'||lpad(pCdEmpresaTmp,2,'0');
    vTissGuia.sn_tratou_retorno := 'N';
    if FNC_CONF('TP_NR_GUIA_PREST_HI',pCdConv,null) = '4' and vTissGuia.NR_GUIA_OPERADORA is not null then
      vTissGuia.NR_GUIA := vTissGuia.NR_GUIA_OPERADORA;
    end if;
    --
    -- Grava真真o
    vResult := F_gravaTissGuia('INSERE','HI',vTissGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    ---------------------------------------------------
    --
    -- procedimentosRealizados
    -- procedimentoRealizado----------------------------
    --
    -- Zera sequenciamento dos itens
    nSqItem:=0;
    nSqItemOut:=0;
    --
    if NOT cTissHI%isOpen THEN
      vGerandoGuia := 'N';
      open cTissHI( pCdAtend,pCdContaOrig,vcAtendimento.tp_atendimento);
      fetch cTissHI into vcTissHI;
      vGerandoGuia := 'S';
    end if;
    LOOP
      --
      if   pCdContaOrig         <>  vcTissHI.cd_conta
        or NVL(pCdPrestTmp,0)   <>  NVL(vcTissHI.cd_prestador,0)
        or NVL(vNrGuiaTmp,'Z')     <>  NVL(vcTissHI.nr_guia_conv,'Z')
        or NVL(vNrSenhaTmp,'Z')    <>  NVL(vcTissHI.nr_senha_conv,'Z')
        OR cTissHI%NOTFOUND then
        --
        if cTissHI%NOTFOUND then
          close cTissHI;
        end if;
        --
        EXIT;
      end if;
      --
      if fnc_conf('TP_TOTALIZA_HI',pCdConv,null) <> 'N'
        and Nvl(vcTissHI.data,'X')                = nvl(vTissItGuia.DT_REALIZADO,'X')
        and Nvl(vcTissHI.hr_ini,'X')              = nvl(vTissItGuia.HR_INICIO,'X')
        and Nvl(vcTissHI.hr_fim,'X')              = nvl(vTissItGuia.HR_FIM,'X')
        and Nvl(vcTissHI.cod_proc,'X')            = nvl(vTissItGuia.CD_PROCEDIMENTO,'X')
        and Nvl(vcTissHI.ds_proc,'X')             = nvl(vTissItGuia.DS_PROCEDIMENTO,'X')
        and Nvl(vcTissHI.vl_perc_reduc_acres,'X') = nvl(vTissItGuia.VL_PERCENTUAL_MULTIPLA,'X')
        and Nvl(vcTissHI.tp_pagamento,'X')        = nvl(vTissItGuia.TP_PAGAMENTO,'X') -- +tp_pagamento(???, reordenar ctiss se preciso)
        and nvl(vcTissHI.cd_prest_equipe,0)       = nvl(vCdPresEquipeTMP,0)
        then
          pModoIt := 'ATUALIZA_TOTAIS';
		  nSqItem:= nSqItem - 1;
      else
        pModoIt := 'INSERE';
        TotAgrupItHI.quantidade := 0; TotAgrupItHI.valortotal := 0; -- zera acumulador de agrupamento
        vCdPresEquipeTMP := vcTissHI.cd_prest_equipe; -- controle qdo.agrupamento, s真 permite mesmo prestador ao n真vel de equipe
      end if;
      --
      vGerandoGuia := vGerandoGuia||vcTissHI.cod_proc;
      vRet := F_ct_procedimentoHonorIndiv(null,1170,pCdAtend,pCdContaOrig,vcTissHI.cd_lanc,vcTissHI.cd_itlan_med,vCtProcHI,pMsg,vcTissHI.cd_prest_equipe);
      if vRet = 'OK' then
        vTissItGuia.ID_PAI                    := vTissGuia.ID;
        vTissItGuia.SQ_ITEM                   := vCtProcHI.sequencialItem;
        vTissItGuia.DT_REALIZADO              := vCtProcHI.dataExecucao;
        vTissItGuia.HR_INICIO                 := vCtProcHI.horaInicial;
        vTissItGuia.HR_FIM                    := vCtProcHI.horaFinal;
        vTissItGuia.TP_TAB_FAT                := vCtProcHI.procedimento.codigoTabela;
        vTissItGuia.CD_PROCEDIMENTO           := vCtProcHI.procedimento.codigoProcedimento;
        vTissItGuia.DS_PROCEDIMENTO           := vCtProcHI.procedimento.descricaoProcedimento;
        vTissItGuia.QT_REALIZADA              := vCtProcHI.quantidadeExecutada;
        vTissItGuia.CD_VIA_ACESSO             := vCtProcHI.viaAcesso;
        vTissItGuia.TP_TECNICA_UTILIZADA      := vCtProcHI.tecnicaUtilizada;
        vTissItGuia.VL_PERCENTUAL_MULTIPLA    := vCtProcHI.reducaoAcrescimo;
        vTissItGuia.VL_UNITARIO               := vCtProcHI.valorUnitario;
        vTissItGuia.VL_TOTAL                  := vCtProcHI.valorTotal;
        -- informa真真es complementares de apoio
        vTissItGuia.CD_PRO_FAT                := vcTissHI.cd_pro_fat;
        vTissItGuia.TP_PAGAMENTO              := vcTissHI.tp_pagamento;
        -- Grava真真o
        vTissItGuia.sn_principal  := Nvl(vTissItGuia.sn_principal,'N');
        vRet := F_gravaTissItGuia (pModoIt,'HI',vTissItGuia,pMsg,null);
        if pMsg is not null then
          RETURN null;
        end if;
        -- Concilia真真o
        if vcAtendimento.tp_atendimento<>'I' then
          vRet := F_concilia_id_it_envio('ITREG_AMB',vTissItGuia.ID,pCdAtend,pCdContaOrig,vcTissHI.cd_lanc,null,null,pMsg,null);
        else
          vRet := F_concilia_id_it_envio('ITREG_FAT',vTissItGuia.ID,pCdAtend,pCdContaOrig,vcTissHI.cd_lanc,null,null,pMsg,null);
        end if;
        if pMsg is not null then
          RETURN null;
        end if;
        --
        -- N真o repete profissional de equipe (caso de agrupamentos)
        if pModoIt <> 'ATUALIZA_TOTAIS' then
          --
          FOR K in 1..nvl(vCtProcHI.profissionais.Last,0) LOOP
            vTissItGuiaEqu.ID_PAI               := vTissItGuia.ID;
            vTissItGuiaEqu.CD_ATI_MED           := vCtProcHI.profissionais(K).grauParticipacao;
            vTissItGuiaEqu.CD_OPERADORA         := vCtProcHI.profissionais(K).codigoPrestadorNaOperadora;
            vTissItGuiaEqu.CD_CPF               := vCtProcHI.profissionais(K).cpfContratado;
            vTissItGuiaEqu.NM_PRESTADOR         := vCtProcHI.profissionais(K).nomeProfissional;
            vTissItGuiaEqu.DS_CONSELHO          := vCtProcHI.profissionais(K).conselhoProfissional;
            vTissItGuiaEqu.DS_CODIGO_CONSELHO   := vCtProcHI.profissionais(K).numeroConselhoProfissional;
            vTissItGuiaEqu.UF_CONSELHO          := vCtProcHI.profissionais(K).UF;
            vTissItGuiaEqu.CD_CBOS              := vCtProcHI.profissionais(K).CBO;
            --OSWALDO
            vTissItGuiaEqu.SQ_REF               := vCtProcHI.sequencialItem;
            -- Grava真真o
            vRet := F_gravaTissItGuiaEqu ('HI',vTissItGuiaEqu,pMsg,null);
            if pMsg is not null then
              close cTissHI;
              RETURN NULL;
            end if;
            --
            -- Concilia真真o
            vRet := F_concilia_id_it_envio('ITLAN_MED',vTissItGuia.ID,pCdAtend,pCdContaOrig,vcTissHI.cd_lanc,vcTissHI.cd_itlan_med,null,pMsg,null);
            if pMsg is not null then
              RETURN null;
            end if;
            --
          END LOOP;
          --
        end if;
        --
      end if;
      vGerandoGuia := 'N';
      fetch cTissHI into vcTissHI;
      vGerandoGuia := 'S';
      --
    END LOOP;
    --
    -- valorTotalHonorarios-----------------------------
    vCp := 'valorTotalHonorarios'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vRet := F_ct_guiaValorTotal(null,1098,vTissGuia.ID,pCdAtend,pCdContaOrig,pCdConv,vCtVlTotal,pMsg,null);
        if vRet = 'OK' then
          vTemp := vCtVlTotal.valorTotalGeral;
        end if;
      vTissGuia.VL_TOTAL_GERAL_HONO := vTemp; -- j真 formatado, dispensa F_ST() -- F_ST(null,vTemp,vCp,null,null,null,null,null);
    end if;
    --
    -- Grava真真o
    vResult := F_gravaTissGuia('ATUALIZA_TOTAIS','HI',vTissGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
    vRet := F_gravaTissGuia('ATUALIZA_INCONSISTENCIA','HI',vTissGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
  end if;
  --
  vGerandoGuia := 'N';
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_procedimentoHonorIndiv(  pModo       in varchar2,
                                        pIdMap      in number,
                                        pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                        pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                        pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                        pCdItLan    in varchar2,
                                        vCt         OUT NOCOPY RecProcHI,
                                        pMsg        OUT varchar2,
                                        pReserva    in varchar2) return varchar2 IS

  -- FUNCTION f_ct_procedimentoExecutadoHonorIndiv(...  [N_RETIRAR]
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  nEqCount      number := 0;
  vRet          varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	        varchar2(1000);
  vCtProcDados  RecProcDados;
  nVlAcresDesc  number;
  --
  vTussRel      RecTussRel;
  vTuss         RecTuss;
  vcTipoProc    cTipoProc%rowtype;
  nVlTemp       number;
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdAtend||pCdConta||pCdLanc||pCdItLan <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento||vcItem.cd_itlan_med,'XXXX') then
      open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      fetch cItem into vcItem;
      close cItem;
    end if;
    if nvl(vcItemAux.cd_atendimento||vcItemAux.cd_conta||vcItemAux.cd_lancamento||vcItemAux.cd_itlan_med,'XXXX')<>pCdAtend||pCdConta||pCdLanc||pCdItLan then
      open  cItemAux(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      fetch cItemAux into vcItemAux;
      close cItemAux;
    end if;
    if vcItem.cd_pro_fat <> nvl(vcProFatAux.cd_pro_fat,'X') then
      open  cProFatAux(vcItem.cd_pro_fat, null);
      fetch cProFatAux into vcProFatAux;
      close cProFatAux;
    end if;
  end if;
  ------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  ------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ct_procedimentoExecutadoHonorIndiv').tp_utilizacao > 0 then
    --
    -- sequencialItem -------------------------------------
    vCp := 'sequencialItem'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then --OSWALDO
      nSqItem:= nSqItem + 1;
      vTemp := nSqItem;
      vCt.sequencialItem := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.sequencialItem;
    end if;
    --
    -- dataExecucao-----------------------------------------
    vCp := 'dataExecucao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcItem.dt_lancamento;  -- ??? default
        if fnc_conf('TP_TOTALIZA_HI',pCdConvTmp,null) = 'U' then --verifica se esta configurado para Agrupar em 真nica data (dt.in真cio da conta);
          vTemp := vcConta.dt_inicio;
        elsif fnc_conf('TP_TOTALIZA_HI',pCdConvTmp,null) = 'L' then --verifica se esta configurado para Agrupar por dia de Lan真amento
          vTemp := vcItem.dt_lancamento;
        else
          --Opcao 1 - senao tiver agrupamento
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_HI',pCdConvTmp,null) = 'L' then    --Data do Lan真amento do Item
            vTemp := vcItem.dt_lancamento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_HI',pCdConvTmp,null) = 'A' then --Data do Atendimento
            vTemp := vcAtendimento.dt_atendimento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_HI',pCdConvTmp,null) = 'C' then --Data Inicio da Conta
            vTemp := vcConta.dt_inicio;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_HI',pCdConvTmp,null) = 'F' then --Data Fim da Conta
            vTemp := vcConta.dt_final;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_HI',pCdConvTmp,null) = 'H' then --Data da Alta (atendimento)
            vTemp := vcAtendimento.dt_alta;
          end if;
          --
          --Opcao 2
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_EXEC_COMPL_HI',pCdConvTmp,null) = 'C' then --Data inicio da cirurgia
            if nvl(vcItemAux.cd_atendimento||vcItemAux.cd_conta||vcItemAux.cd_lancamento||vcItemAux.cd_itlan_med,'XXXX')<>pCdAtend||pCdConta||pCdLanc||pCdItLan then
              open  cItemAux(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
              fetch cItemAux into vcItemAux;
              close cItemAux;
            end if;
            --
            if vcItemAux.dt_realizacao_cir is not null then
              vTemp := vcItemAux.dt_realizacao_cir;
            end if;
            --
          end if;
          --
      end if;
      vCt.dataExecucao := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      vResult := vCt.dataExecucao;
    end if;
    --
    -- horaInicial------------------------------------------
    vCp := 'horaInicial'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --
        vTemp := vcItem.hr_lancamento;   -- ??? default
        --
        if fnc_conf('TP_TOTALIZA_HI',pCdConvTmp,null) <> 'N' AND FNC_CONF('TP_HR_INI_BASICO_HI',pCdConvTmp,null) <> 'N' then --verifica se esta configurado para Agrupar em 真nica data (dt.in真cio da conta);
          vTemp := vcConta.hr_inicio;
        else
          --Opcao 1 - senao tiver agrupamento
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_HI',pCdConvTmp,null) = 'L' then    --Hora do Lan真amento do Item
            vTemp := vcItem.hr_lancamento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_HI',pCdConvTmp,null) = 'A' then --Hora do Atendimento
            vTemp := vcAtendimento.hr_atendimento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_HI',pCdConvTmp,null) = 'C' then --Hora Inicio da Conta
            vTemp := vcConta.hr_inicio;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_HI',pCdConvTmp,null) = 'F' then --Hora Fim da Conta
            vTemp := vcConta.hr_final;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_HI',pCdConvTmp,null) = 'H' then --Hora da Alta (atendimento)
            vTemp := vcAtendimento.hr_alta;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_HI',pCdConvTmp,null) = 'N' then --N真o gera Hora
            vTemp := NULL;
          end if;
          --
          --Opcao 2
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_EXEC_COMPL_HI',pCdConvTmp,null) = 'C' then --Hora inicio da cirurgia
            if nvl(vcItemAux.cd_atendimento||vcItemAux.cd_conta||vcItemAux.cd_lancamento||vcItemAux.cd_itlan_med,'XXXX')<>pCdAtend||pCdConta||pCdLanc||pCdItLan then
              open  cItemAux(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
              fetch cItemAux into vcItemAux;
              close cItemAux;
            end if;
            --
            if vcItemAux.entrada_sala is not null then
              vTemp := vcItemAux.entrada_sala;
            end if;
            --
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_EXEC_COMPL_HI',pCdConvTmp,null) = 'E'
            and nvl(vcItem.sn_horario_especial,'N') = 'S' then --Hor真rio Especial

            vTemp := vcItem.hr_lancamento;
          end if;
          --
        end if;
      vCt.horaInicial := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      vResult := vCt.horaInicial;
    end if;
    --
    -- horaFinal--------------------------------------------
    vCp := 'horaFinal'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --
        vTemp := vcItem.hr_lancamento;   -- ??? default
        --
        if fnc_conf('TP_TOTALIZA_HI',pCdConvTmp,null) <> 'N' AND FNC_CONF('TP_HR_FIM_BASICO_HI',pCdConvTmp,null) <> 'N' then --verifica se esta configurado para Agrupar em 真nica data (dt.in真cio da conta);
          vTemp := vcConta.hr_inicio;
        else
          --Opcao 1 - senao tiver agrupamento
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_HI',pCdConvTmp,null) = 'L' then    --Hora do Lan真amento do Item
            vTemp := vcItem.hr_lancamento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_HI',pCdConvTmp,null) = 'A' then --Hora do Atendimento
            vTemp := vcAtendimento.hr_atendimento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_HI',pCdConvTmp,null) = 'C' then --Hora Inicio da Conta
            vTemp := vcConta.hr_inicio;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_HI',pCdConvTmp,null) = 'F' then --Hora Fim da Conta
            vTemp := vcConta.hr_final;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_HI',pCdConvTmp,null) = 'H' then --Hora da Alta (atendimento)
            vTemp := vcAtendimento.hr_alta;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_HI',pCdConvTmp,null) = 'N' then --N真o gera Hora
            vTemp := NULL;
          end if;
          --
          --Opcao 2
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_EXEC_COMPL_HI',pCdConvTmp,null) = 'C' then --Hora final da cirurgia
            if nvl(vcItemAux.cd_atendimento||vcItemAux.cd_conta||vcItemAux.cd_lancamento||vcItemAux.cd_itlan_med,'XXXX')<>pCdAtend||pCdConta||pCdLanc||pCdItLan then
              open  cItemAux(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
              fetch cItemAux into vcItemAux;
              close cItemAux;
            end if;
            --
            if vcItemAux.fim_cirurgia is not null then
              vTemp := vcItemAux.fim_cirurgia;
            end if;
            --
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_EXEC_COMPL_HI',pCdConvTmp,null) = 'E' then --Hor真rio Especial
            vTemp := vcItem.hr_lancamento;
          end if;
          --
        end if;
      vCt.horaFinal := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      vResult := vCt.horaFinal;
    end if;
    --
    -- procedimentosExecutados------------------------------
    IF pModo IS NULL then
      vRet := F_ct_procedimentoDados(null,1176,pCdAtend,pCdConta,pCdLanc,pCdItLan,null,null,'HI',vCtProcDados,pMsg,null);
      if vRet = 'OK' then
        vCt.procedimento.codigoTabela            := vCtProcDados.codigoTabela;
        vCt.procedimento.codigoProcedimento      := vCtProcDados.codigoProcedimento;
        vCt.procedimento.descricaoProcedimento   := vCtProcDados.descricaoProcedimento;
      end if;
    END IF;
    --
    -- quantidadeExecutada----------------------------------
    vCp := 'quantidadeExecutada'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        nVlTemp := vcItem.qt_lancamento;
        if pModo is null then
          TotAgrupItHI.quantidade := TotAgrupItHI.quantidade + nVlTemp; -- acumulador em caso de agrupamento
          nVlTemp := TotAgrupItHI.quantidade;
        end if;
        vTemp := nVlTemp;
      vCt.quantidadeExecutada := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      vResult := vCt.QuantidadeExecutada;
    end if;
    --
    -- viaAcesso--------------------------------------------
    vCp := 'viaAcesso'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --FUTURO RELACIONAMENTO COM A TELA
        --vTemp := F_DM(61,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
        --vTemp := vTuss.CD_TUSS;
        if nvl(fnc_conf('TP_SERV_INFORMA_VIA_HON',pCdConvTmp,null),'1')>'1' then
          if nvl(vcAprTiss.cd_apr_tiss, 0) = 0 then
            open  cAprTiss(NULL);
            fetch cAprTiss into vcAprTiss;
            close cAprTiss;
          end if;
          open  cTipoProc( vcAprTiss.cd_apr_tiss, vcItem.cd_pro_fat);
          fetch cTipoProc into vcTipoProc;
          close cTipoProc;
        end if;
        if vcItem.cd_pro_fat <> nvl(vcProFat.cd_pro_fat,'X') then
          open  cProFat(vcItem.cd_pro_fat);
          fetch cProFat into vcProFat;
          close cProFat;
        end if;
        if ( nvl(vcProFat.nr_auxiliar,0)>0 or vcProFat.cd_por_ane is not null)
           or (vcTipoProc.cd_pro_fat_vinculado is not null and Upper(vcTipoProc.cd_pro_fat_vinculado) = 'VIA') then
          if vcItem.vl_percentual_multipla = '50' then
            vTemp := '2';
          elsif vcItem.vl_percentual_multipla = '70' then
            vTemp := '3';
          else
            vTemp := '1';
          end if;
        end if;
      vCt.viaAcesso := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      vResult := vCt.viaAcesso;
    end if;
    --
    -- tecnicaUtilizada-------------------------------------
    vCp := 'tecnicaUtilizada'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --FUTURO RELACIONAMENTO COM A TELA
        --vTemp := F_DM(48,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
        --vTemp := vTuss.CD_TUSS;
        if (nvl(vcProFat.nr_auxiliar,0) >0 or vcProFat.cd_por_ane is not null) then
          if nvl(vcItemAux.tp_tecnica_utilizada,'C') ='V' then
            vTemp := '2';
          elsif nvl(vcItemAux.sn_robotica,'N') = 'S' then
            vTemp := '3';
          else
            vTemp := '1';
          end if;
        end if;
      vCt.tecnicaUtilizada := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      vResult := vCt.tecnicaUtilizada;
    end if;
    --
    -- reducaoAcrescimo-------------------------------------
    vCp := 'reducaoAcrescimo'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        nVlAcresDesc := vcItem.vl_percentual_multipla;
        --
        if nvl(fnc_conf('TP_PERC_ACRES_DESC_HI',pCdConvTmp,null),'1') in ('3','4') and vcConta.cd_tip_acom is not null then
          -- verifica se h真 configura真真o para representar % de acomoda真真o superior
          if vcItem.cd_regra||vcConta.cd_tip_acom||vcProFatAux.cd_gru_pro||vcItem.cd_pro_fat<>nvl(vcAcomod.cd_regra||vcAcomod.cd_tip_acom||vcAcomod.cd_gru_pro||vcAcomod.cd_pro_fat,'XXXX') then
            vcAcomod := null;
            open  cAcomod(vcItem.cd_regra,vcConta.cd_tip_acom,vcProFatAux.tp_gru_pro,vcProFatAux.cd_gru_pro,vcItem.cd_pro_fat);
            fetch cAcomod into vcAcomod;
            close cAcomod;
          end if;
          if vcAcomod.vl_percentual is not null AND vcAcomod.vl_percentual <> 100 then
            nVlAcresDesc := vcAcomod.vl_percentual;
          end if;
        end if;
        -- verifica se h真 configura真真o para representar H.E. no Percentual (+30%) e soma ao j真 obtido se houver
        if nvl(fnc_conf('TP_PERC_ACRES_DESC_HI',pCdConvTmp,null),'1') IN ('2','4') and vcItem.sn_horario_especial = 'S' then
          --
          if vcItem.cd_regra||vcProFatAux.cd_gru_pro<>nvl(vcIndiceHE.cd_regra||vcIndiceHE.cd_gru_pro,'XX') then
            vcIndiceHE := null;
            open  cIndiceHE(vcItem.cd_regra,vcProFatAux.cd_gru_pro);
            fetch cIndiceHE into vcIndiceHE;
            close cIndiceHE;
          end if;
          if vcIndiceHE.vl_percentual is not null then
            nVlAcresDesc := nvl(nVlAcresDesc,100) + vcIndiceHE.vl_percentual;
          end if;
        end if;
        --
        vTemp := (nVlAcresDesc/100);
        --
      vCt.reducaoAcrescimo := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      vResult := vCt.reducaoAcrescimo;
      nVlAcresDesc := To_Number(vCt.reducaoAcrescimo,'999.99')*100; -- Guarda percentual para c真lculo valor unit真rio qdo.agrupado
    end if;
    --
    -- valorUnitario----------------------------------------
    -- Campo deslocado mais abaixo por quest真es t真cnicas de c真lculo
    --
    -- valorTotal-------------------------------------------
    vCp := 'valorTotal'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        nVlTemp := vcItem.vl_total_conta;
        --
        if vcItem.sn_pertence_pacote = 'S' then
          nVlTemp := 0; -- Pertence Pacote, zera
        end if;
        --
        if vcItem.tp_pagamento = 'C' then -- zerar credenciados
          if fnc_conf('TP_ZERA_VALOR_CRED_HI',pCdConvTmp,null) = 'S' OR fnc_conf('TP_ZERA_VALOR_CRED_HI',pCdConvTmp,null)=substr(vcProFatAux.tp_gru_pro,2,1) then
            nVlTemp := 0;
          end if;
        end if;
        if pModo is null then
          TotAgrupItHI.valortotal := TotAgrupItHI.valortotal + nVlTemp;
          nVlTemp := TotAgrupItHI.valortotal;
        end if;
        vTemp := nVlTemp;
      vCt.valorTotal := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      vResult := vCt.valorTotal;
    end if;
    --
    -- valorUnitario----------------------------------------
    vCp := 'valorUnitario'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if nvl(fnc_conf('TP_VALOR_UNITARIO_HI',pCdConvTmp,null),'1') = '2' then
          vTemp := ((TotAgrupItHI.valortotal/nvl(TotAgrupItHI.quantidade,1))/nvl(nVlAcresDesc/100,1) );
        else
          vTemp := (vcItem.vl_total_conta/vcItem.qt_lancamento);   -- ??? PENDENTE, analisar op真真es j真 existentes
        end if;
        --
        if vcItem.tp_pagamento = 'C' then -- zerar credenciados
          if fnc_conf('TP_ZERA_VALOR_CRED_HI',pCdConvTmp,null) = 'S' OR fnc_conf('TP_ZERA_VALOR_CRED_HI',pCdConvTmp,null)=substr(vcProFatAux.tp_gru_pro,2,1) then
            vTemp := 0;
          end if;
        end if;
      vCt.valorUnitario := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      vResult := vCt.valorUnitario;
    end if;
    --
    -- profissionais----------------------------------------
    if pModo IS NULL or tConf('profissionais').tp_utilizacao > 0 then
      --
        nEqCount := nEqCount + 1; -- contador de elementos v真lidos da equipe;
        --
        if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>pReserva||pCdConvTmp then
          vcPrestador := null;
          open  cPrestador(pReserva,null, pCdConvTmp, NULL ,vcItem.cd_con_pla); -- pda FATURCONV-1372
          fetch cPrestador into vcPrestador;
          close cPrestador;
        end if;
        --
        -- grauPart-----------------------------------------
        vCp := 'grauParticipacao'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          vTussRel := null;
          vTussRel.cd_ati_med := vcItem.cd_ati_med;
          vTemp := F_DM(35,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
          vTemp := vTuss.CD_TUSS;
          vCt.profissionais(nEqCount).grauParticipacao := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);    -- dm_grauPart
          vResult := vCt.profissionais(nEqCount).grauParticipacao;
        end if;
        --
      -- codProfissional
      FOR I in 1..2 LOOP -- os 2 campos abaixo s真o CHOICE ============
        --
        -- codigoPrestadorNaOperadora-----------------------
        vCp := 'codigoPrestadorNaOperadora'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I then
		  --PROD-2542 - so vai gerar se o credenciamento estiver ativo
          if vcPrestador.sn_ativo_credenciamento = 'S' then
            vTemp := vcPrestador.cd_prestador_conveniado;
          else
            vTemp := NULL;
          end if;
		  vCt.profissionais(nEqCount).codigoPrestadorNaOperadora := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
          vResult := vCt.profissionais(nEqCount).codigoPrestadorNaOperadora;
          EXIT when vCt.profissionais(nEqCount).codigoPrestadorNaOperadora is NOT null;
        end if;
        --
        -- cpfContratado------------------------------------
        vCp := 'cpfContratado'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I then
          if length(vcPrestador.nr_cpf_cgc)<=11 then
            vTemp := vcPrestador.nr_cpf_cgc;
          end if;
          vCt.profissionais(nEqCount).cpfContratado := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
          vResult := vCt.profissionais(nEqCount).cpfContratado;
          EXIT when vCt.profissionais(nEqCount).cpfContratado is NOT null;
        end if;
        --
      END LOOP; -- fim do CHOICE ===========================
      --
      /*-- codigoContratado---------------------------------
        vCp := 'codigoContratado'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          if vTemp is null then
            vTemp := vcPrestador.cd_prestador_conveniado;
          end if;
          vCt.profissionais(nEqCount).codigoContratado := F_ST(null,vTemp,vCp,pCdConvTmp,null,null,null,null);
          vResult := vCt.profissionais(nEqCount).codigoContratado;
        end if; */
        --
        -- nomeProfissional---------------------------------
        vCp := 'nomeProfissional'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          vTemp := vcPrestador.nm_prestador;
          vCt.profissionais(nEqCount).nomeProfissional := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
          vResult := vCt.profissionais(nEqCount).nomeProfissional;
        end if;
        --
        -- conselhoProfissional-----------------------------
        vCp := 'conselhoProfissional'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          vTussRel := null;
          vTussRel.CD_CONSELHO := vcPrestador.CD_CONSELHO;
          vTemp := F_DM(26,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
          vTemp := vTuss.CD_TUSS;
          vCt.profissionais(nEqCount).conselhoProfissional := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);    -- dm_conselhoProfissional
          vResult := vCt.profissionais(nEqCount).conselhoProfissional;
        end if;
        --
        -- numeroConselhoProfissional-----------------------
        vCp := 'numeroConselhoProfissional'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          vTemp := vcPrestador.numero_conselho;
          vCt.profissionais(nEqCount).numeroConselhoProfissional := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
          vResult := vCt.profissionais(nEqCount).numeroConselhoProfissional;
        end if;
        --
        -- UF-----------------------------------------------
        vCp := 'UF'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          --FUTURO RELACIONAMENTO COM A TELA (Terminologia 59)
          --vTemp := vTuss.CD_TUSS;
          vTemp := vcPrestador.uf_prestador;
          vCt.profissionais(nEqCount).UF := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);  -- dm_UF
          vResult := vCt.profissionais(nEqCount).UF;
        end if;
        --
        -- CBO----------------------------------------------
        vCp := 'CBO'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          vTussRel := null;
          vTussRel.CD_ESPECIALIDADE := vcPrestador.cd_especialid;
          vTussRel.CD_ATI_MED := vcItem.cd_ati_med;
          vTemp := F_DM(24,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
          vTemp := vTuss.CD_TUSS;
          vCt.profissionais(nEqCount).CBO := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);    -- dm_CBOS
          vResult := vCt.profissionais(nEqCount).CBO;
        end if;
   -- END LOOP;
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissGuia ( pModo           in varchar2,
                            pTpGuia         in varchar2,
                            vRg             in OUT NOCOPY dbamv.tiss_guia%rowtype,
                            pMsg            OUT varchar2,
                            pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
  --
BEGIN
  --
  if pModo = 'INSERE' then
    --
    if pTpGuia = 'RI' then
      vRg.NM_XML := 'guiaResumoInternacao';
    elsif pTpGuia = 'SP' then
      vRg.NM_XML := 'guiaSP_SADT';
    elsif pTpGuia = 'HI' then
      vRg.NM_XML := 'guiaHonorarioIndividual';
    elsif pTpGuia = 'CO' then
      vRg.NM_XML := 'guiaConsulta';
    elsif pTpGuia = 'RECURSO' then
      vRg.NM_XML := 'guiaRecurso';
    end if;
    --
    if vRg.id is null then -- o Id (sequence) pode j真 vir de fora pelas op真真es de gerar Nr.Guia sequencial
      select dbamv.seq_tiss_guia.nextval into vRg.id from sys.dual;
    end if;
    --
    insert into dbamv.tiss_guia
        (   id, id_pai, nm_xml, nr_registro_operadora_ans, cd_prestador_na_operadora, nr_guia, nr_guia_operadora, nr_id_beneficiario, dt_emissao, nr_guia_principal,
            dt_emissao_principal, nr_carteira, dt_validade, nm_paciente, ds_con_pla, nm_titular, nr_cns, cd_cgc_cpf_sol, nm_prestador_sol, ds_codigo_conselho_sol,
            ds_conselho_sol, uf_conselho_sol, cd_cbos_sol, cd_cgc_sol, cd_cpf_sol, cd_operadora_sol, cd_tipo_logradouro_sol, ds_endereco_sol, nr_endereco_sol,
            cd_ibge_sol, uf_sol, nr_cep_sol, cd_cnes_sol, ds_complemento_sol, cd_cgc_cpf_exe, nm_prestador_exe, cd_cnes_exe, cd_tipo_logradouro_exe, ds_endereco_exe,
            nr_endereco_exe, nm_bairro_exe, cd_ibge_exe, uf_exe, nr_cep_exe, cd_cgc_exe, cd_cpf_exe, cd_operadora_exe, ds_conselho_exe, ds_codigo_conselho_exe,
            uf_conselho_exe, ds_complemento_exe, nm_cidade_exe, cd_cbos_exe, cd_ati_med_exe, ds_hda, cd_carater_solicitacao, dh_atendimento, tp_saida, tp_atendimento,
            tp_faturamento, tp_cid, cd_cid, ds_cid, dt_autorizacao, cd_senha, dt_validade_autorizada, nm_autorizador_conv, vl_tot_servicos, vl_tot_diarias, vl_tot_taxas,
            vl_tot_materiais, vl_tot_medicamentos, vl_tot_gases, vl_tot_geral, cd_tip_acom, dh_alta, cd_tipo_internacao, tp_doenca, nr_tempo_doenca, tp_tempo_doenca,
            ds_observacao, nr_guia_sol, tp_regime_internacao, sn_gestacao, sn_aborto, sn_transtorno, sn_complicacao, sn_atend_sl_parto, sn_complicacao_neo, sn_baixo_peso,
            sn_cesareo, sn_normal, cd_decl_nascidos_vivos, qt_nascidos_vivos, qt_nascidos_prematuros, qt_nascidos_mortos, tp_obito_mulher, qt_obito_precoce, qt_obito_tardio,
            tp_acidente, cd_motivo_alta, cd_sus, nr_diarias_uti, tp_cid_obito, cd_cid_obito, ds_cid_obito, nr_declaracao_obito, cd_tipo_faturamento, vl_total_geral_proc,
            vl_total_geral_opme, vl_total_geral_outras, vl_total_geral_hono, nr_lote, sn_tratou_retorno, cd_seq_transacao, cd_remessa, cd_atendimento, cd_reg_fat, cd_reg_amb,
            cd_convenio, cd_guia, nm_prestador_exe_compl, cd_cgc_exe_compl, cd_cpf_exe_compl, cd_operadora_exe_compl, nm_cidade_sol, cd_status_cancelamento, nm_prestador_contratado,
            cd_cgc_contratado, cd_cpf_contratado, cd_operadora_contratado, cd_remessa_glosa, ds_conselho_contratado, ds_cod_conselho_contratado, uf_conselho_contratado, cd_fonte_pagadora,
            sn_atendimento_rn,dt_inicio_faturamento,hr_inicio_faturamento,dt_final_faturamento,hr_final_faturamento,vl_tot_opme,tp_consulta,tp_tab_fat_co,cd_procedimento_co,vl_procedimento_co
            ,ds_inconsistencias, cd_versao_tiss_gerada, tp_cobertura_especial, tp_regime_atendimento, tp_saude_ocupacional, nm_social_paciente --Oswaldo FATURCONV-26150
        )
    values
        (   vRg.id, vRg.id_pai, vRg.nm_xml, vRg.nr_registro_operadora_ans, vRg.cd_prestador_na_operadora, vRg.nr_guia, vRg.nr_guia_operadora, vRg.nr_id_beneficiario, vRg.dt_emissao, vRg.nr_guia_principal,
            vRg.dt_emissao_principal, vRg.nr_carteira, vRg.dt_validade, vRg.nm_paciente, vRg.ds_con_pla, vRg.nm_titular, vRg.nr_cns, vRg.cd_cgc_cpf_sol, vRg.nm_prestador_sol, vRg.ds_codigo_conselho_sol,
            vRg.ds_conselho_sol, vRg.uf_conselho_sol, vRg.cd_cbos_sol, vRg.cd_cgc_sol, vRg.cd_cpf_sol, vRg.cd_operadora_sol, vRg.cd_tipo_logradouro_sol, vRg.ds_endereco_sol, vRg.nr_endereco_sol,
            vRg.cd_ibge_sol, vRg.uf_sol, vRg.nr_cep_sol, vRg.cd_cnes_sol, vRg.ds_complemento_sol, vRg.cd_cgc_cpf_exe, vRg.nm_prestador_exe, vRg.cd_cnes_exe, vRg.cd_tipo_logradouro_exe, vRg.ds_endereco_exe,
            vRg.nr_endereco_exe, vRg.nm_bairro_exe, vRg.cd_ibge_exe, vRg.uf_exe, vRg.nr_cep_exe, vRg.cd_cgc_exe, vRg.cd_cpf_exe, vRg.cd_operadora_exe, vRg.ds_conselho_exe, vRg.ds_codigo_conselho_exe,
            vRg.uf_conselho_exe, vRg.ds_complemento_exe, vRg.nm_cidade_exe, vRg.cd_cbos_exe, vRg.cd_ati_med_exe, vRg.ds_hda, vRg.cd_carater_solicitacao, vRg.dh_atendimento, vRg.tp_saida, vRg.tp_atendimento,
            vRg.tp_faturamento, vRg.tp_cid, vRg.cd_cid, vRg.ds_cid, vRg.dt_autorizacao, vRg.cd_senha, vRg.dt_validade_autorizada, vRg.nm_autorizador_conv, vRg.vl_tot_servicos, vRg.vl_tot_diarias, vRg.vl_tot_taxas,
            vRg.vl_tot_materiais, vRg.vl_tot_medicamentos, vRg.vl_tot_gases, vRg.vl_tot_geral, vRg.cd_tip_acom, vRg.dh_alta, vRg.cd_tipo_internacao, vRg.tp_doenca, vRg.nr_tempo_doenca, vRg.tp_tempo_doenca,
            vRg.ds_observacao, vRg.nr_guia_sol, vRg.tp_regime_internacao, vRg.sn_gestacao, vRg.sn_aborto, vRg.sn_transtorno, vRg.sn_complicacao, vRg.sn_atend_sl_parto, vRg.sn_complicacao_neo, vRg.sn_baixo_peso,
            vRg.sn_cesareo, vRg.sn_normal, vRg.cd_decl_nascidos_vivos, vRg.qt_nascidos_vivos, vRg.qt_nascidos_prematuros, vRg.qt_nascidos_mortos, vRg.tp_obito_mulher, vRg.qt_obito_precoce, vRg.qt_obito_tardio,
            vRg.tp_acidente, vRg.cd_motivo_alta, vRg.cd_sus, vRg.nr_diarias_uti, vRg.tp_cid_obito, vRg.cd_cid_obito, vRg.ds_cid_obito, vRg.nr_declaracao_obito, vRg.cd_tipo_faturamento, vRg.vl_total_geral_proc,
            vRg.vl_total_geral_opme, vRg.vl_total_geral_outras, vRg.vl_total_geral_hono, vRg.nr_lote, vRg.sn_tratou_retorno, vRg.cd_seq_transacao, vRg.cd_remessa, vRg.cd_atendimento, vRg.cd_reg_fat, vRg.cd_reg_amb,
            vRg.cd_convenio, vRg.cd_guia, vRg.nm_prestador_exe_compl, vRg.cd_cgc_exe_compl, vRg.cd_cpf_exe_compl, vRg.cd_operadora_exe_compl, vRg.nm_cidade_sol, vRg.cd_status_cancelamento, vRg.nm_prestador_contratado,
            vRg.cd_cgc_contratado, vRg.cd_cpf_contratado, vRg.cd_operadora_contratado, vRg.cd_remessa_glosa, vRg.ds_conselho_contratado, vRg.ds_cod_conselho_contratado, vRg.uf_conselho_contratado, vRg.cd_fonte_pagadora,
            vRg.sn_atendimento_rn,vRg.dt_inicio_faturamento,vRg.hr_inicio_faturamento,vRg.dt_final_faturamento,vRg.hr_final_faturamento,vRg.vl_tot_opme,vRg.tp_consulta,vRg.tp_tab_fat_co,vRg.cd_procedimento_co,vRg.vl_procedimento_co,
            vRg.ds_inconsistencias, vRg.cd_versao_tiss_gerada, vRg.tp_cobertura_especial, vRg.tp_regime_atendimento, vRg.tp_saude_ocupacional, vRg.nm_social_paciente --Oswaldo FATURCONV-26150
        );
    --
  elsif pModo = 'ATUALIZA_TOTAIS' then
    --
    Update dbamv.tiss_guia SET
        VL_TOT_SERVICOS       = vRg.VL_TOT_SERVICOS,
        VL_TOT_DIARIAS        = vRg.VL_TOT_DIARIAS,
        VL_TOT_TAXAS          = vRg.VL_TOT_TAXAS,
        VL_TOT_MATERIAIS      = vRg.VL_TOT_MATERIAIS,
        VL_TOT_MEDICAMENTOS   = vRg.VL_TOT_MEDICAMENTOS,
        VL_TOT_OPME           = vRg.VL_TOT_OPME,
        VL_TOT_GASES          = vRg.VL_TOT_GASES,
        VL_TOT_GERAL          = vRg.VL_TOT_GERAL,
        VL_TOTAL_GERAL_HONO   = vRg.VL_TOTAL_GERAL_HONO,
        VL_TOTAL_GERAL_OUTRAS = vRg.VL_TOTAL_GERAL_OUTRAS
      where id = vRg.id;
    --
  elsif pModo = 'ATUALIZA_INCONSISTENCIA' THEN
    --
    IF vPendenciaGuia IS NOT NULL THEN
      Update dbamv.tiss_guia SET
       DS_INCONSISTENCIAS = vPendenciaGuia
      where id = vRg.id;
    END IF;
    vPendenciaGuia := NULL;
    --
  end if;
  --
  RETURN LPAD(vRg.id,20,'0')||',';
  --
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar '||vRg.NM_XML||'. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_GUIA:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissItGuia (   pModo           in varchar2,
                                pTpGuia         in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_itguia%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
  --
BEGIN

  if pModo = 'INSERE' then
    --
    select dbamv.seq_tiss_itguia.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.tiss_itguia
    (   id, id_pai, sq_item, hr_inicio, hr_fim, tp_tab_fat, cd_procedimento, ds_procedimento, qt_realizada, cd_via_acesso, tp_tecnica_utilizada
    , vl_percentual_multipla, vl_unitario, vl_total, dt_realizado, qt_autorizada, cd_pro_fat, tp_pagamento, ds_justificativa_revisao
    , cd_ati_med, cd_motivo_glosa, dt_final
    , cd_mvto, tp_mvto, cd_itmvto, sn_principal
    )
    values
    (  vRg.id, vRg.id_pai, vRg.sq_item, vRg.hr_inicio, vRg.hr_fim, vRg.tp_tab_fat, vRg.cd_procedimento, vRg.ds_procedimento, vRg.qt_realizada, vRg.cd_via_acesso, vRg.tp_tecnica_utilizada
    , vRg.vl_percentual_multipla, vRg.vl_unitario, vRg.vl_total, vRg.dt_realizado, vRg.qt_autorizada, vRg.cd_pro_fat, vRg.tp_pagamento, vRg.ds_justificativa_revisao
    , vRg.cd_ati_med, vRg.cd_motivo_glosa, vRg.dt_final
    , vRg.cd_mvto, vRg.tp_mvto, vRg.cd_itmvto, Nvl(vRg.sn_principal, 'N')
    );
    --
  elsif pModo = 'ATUALIZA_TOTAIS' then
    --
    Update dbamv.tiss_itguia SET
        qt_realizada    = vRg.qt_realizada,
        vl_unitario     = vRg.vl_unitario,
        vl_total        = vRg.vl_total
      where id = vRg.id;
    --
  end if;
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar o servico '||vRg.cd_procedimento||'. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_ITGUIA:'||SQLERRM;
      RETURN null;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissItGuiaEqu (pModo           in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_itguia_equ%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
BEGIN
  --
  select dbamv.seq_tiss_itguia_equ.nextval into vRg.id from sys.dual;
  --
  insert into dbamv.tiss_itguia_equ
 (   id, id_pai, sq_ref, cd_cgc, cd_cpf, cd_operadora, nm_prestador, cd_cbos, ds_conselho, ds_codigo_conselho, uf_conselho, cd_cpf_2
    , cd_ati_med, cd_prestador_conveniado, nr_cgc_cpf, ds_conselho_cod_prof, ds_cod_conselho_cod_prof, uf_conselho_cod_prof
  )
    values
 (  vRg.id, vRg.id_pai, vRg.sq_ref,vRg.cd_cgc, vRg.cd_cpf, vRg.cd_operadora, vRg.nm_prestador, vRg.cd_cbos, vRg.ds_conselho, vRg.ds_codigo_conselho, vRg.uf_conselho, vRg.cd_cpf_2
, vRg.cd_ati_med, vRg.cd_prestador_conveniado, vRg.nr_cgc_cpf, vRg.ds_conselho_cod_prof, vRg.ds_cod_conselho_cod_prof, vRg.uf_conselho_cod_prof
  );
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar Equipe. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_ITGUIA_EQU:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissItGuiaOut( pModo           in varchar2,
                                pTpGuia         in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_itguia_out%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
BEGIN
  if pModo = 'INSERE' then
    --
    select dbamv.seq_tiss_itguia.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.tiss_itguia_out
    ( id, id_pai, sq_item, sq_ref,tp_tab_fat, cd_procedimento, ds_procedimento, tp_despesa, dt_realizado, hr_inicio, hr_fim
    , vl_percentual_multipla, qt_realizada, vl_unitario, vl_total, qt_autorizada, cd_pro_fat, ds_justificativa_revisao, CD_UNIDADE_MEDIDA
    , CD_REGISTRO_ANVISA, CD_CODIGO_FABRICANTE, NR_AUTORIZACAO
    )
    values
    ( vRg.id, vRg.id_pai, vRg.sq_item, vRg.sq_ref, vRg.tp_tab_fat, vRg.cd_procedimento, vRg.ds_procedimento, vRg.tp_despesa, vRg.dt_realizado, vRg.hr_inicio, vRg.hr_fim
    , vRg.vl_percentual_multipla, vRg.qt_realizada, vRg.vl_unitario, vRg.vl_total, vRg.qt_autorizada, vRg.cd_pro_fat, vRg.ds_justificativa_revisao, vRg.CD_UNIDADE_MEDIDA
    , vRg.CD_REGISTRO_ANVISA, vRg.CD_CODIGO_FABRICANTE, vRg.NR_AUTORIZACAO
    );

  elsif pModo = 'ATUALIZA_TOTAIS' then
    --
    Update dbamv.tiss_itguia_out SET
        qt_realizada    = vRg.qt_realizada,
        vl_unitario     = vRg.vl_unitario,
        vl_total        = vRg.vl_total
      where id = vRg.id;
    --
  end if;
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar o servico '||vRg.cd_procedimento||'. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_ITGUIA_OUT:'||SQLERRM;
      RETURN null;
  --
END;
--
--==================================================
FUNCTION  F_ctm_sp_sadtGuia(    pModo          in varchar2,
                                pIdMap         in number,
                                pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                pCdConta       in dbamv.reg_amb.cd_reg_amb%type,
                                pTpClasse      in varchar2,
                                pCdPrest       in dbamv.prestador.cd_prestador%type,
                                pMsg           OUT varchar2,
                                pReserva       in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(1000);
  vCp	            varchar2(1000);
  vRet              varchar2(1000);
  vTissGuia         dbamv.tiss_guia%rowtype;
  vTissItGuia       dbamv.tiss_itguia%rowtype;
  vTissItGuiaEqu    dbamv.tiss_itguia_equ%rowtype;
  vTissItGuiaOut    dbamv.tiss_itguia_out%rowtype;
  pCdConv           dbamv.convenio.cd_convenio%type;
  vCtAutorizSadt    RecAutorizSadt;
  vCtBenef          RecBenef;
  vCtCabec          RecCabec;
  vCtContrat        RecContrat;
  vCtVlTotal        RecVlTotal;
  vCtProcSadt       RecProcSadt;
  vCtOutDesp        RecOutDesp;
  vCtContrProf      RecContrProf;
  vcTissOutDesp     cTissOutDesp%rowtype;
  vCtDadosAtendSp   RecDadosAtendSpSadt;
  vCtDadosSolic     RecDadosSolicitacao;
  pCdPrestTmp       number;
  pModoIt           varchar2(1000);
  pModoOut          varchar2(1000);
  vcTissGuiaOrigem  cTissGuiaOrigem%rowtype;
  vcSolicAvulsa     cSolicAvulsa%rowtype;
  vPrimeiraGuiaAut	cPrimeiraGuiaAut%rowtype;
  pCdEmpresaTmp     dbamv.multi_empresas.cd_multi_empresa%type;
  vCdEmpresaPar     varchar2(10);
  vCdGuiaTmp        dbamv.guia.cd_guia%type;
  vNrGuiaTmp        dbamv.guia.nr_guia%TYPE;
  --
  bImagemPrincipal      BOOLEAN := TRUE;
  bSADTPrincipal        BOOLEAN := TRUE;
  bAtendimentoPrincipal BOOLEAN := TRUE;
  bPrescricaoPrincipal  BOOLEAN := TRUE;
  --
  vTussRel      RecTussRel;
  vTuss         RecTuss;
  pCdLancPed        dbamv.itreg_amb.cd_lancamento%TYPE;
  vGuiaPrincipal    VARCHAR2(1):= 'S'; -- Oswaldo in真cio 210325
BEGIN
  --
  if pModo IS NULL THEN  vGerandoGuia := 'S'; END IF;
  --
  -- Inicia o sequenciamento dos itens
  nSqItem:=0;
  nSqItemOut:=0;
  --

  pCdPrestTmp := pCdPrest;    --  BUG !!!  vari真vel pra contornar erro do sistema que altera variavel pCdPrest dentro do programa!
  -- leitura de cursores de uso geral
  if pCdAtend is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
  end if;
  --
  if pCdConta is not null then
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  else
    vcConta := null;
  end if;
  if pReserva is not null and length(pReserva)>5 then
    open  cTissGuiaOrigem(substr(pReserva,1,20));
    fetch cTissGuiaOrigem into vcTissGuiaOrigem;
    close cTissGuiaOrigem;
  end if;
  IF vcAtendimento.tp_atendimento = 'E' and (cTissSP_Proc%isOpen OR pTpClasse = 'PRINCIPAL') AND vcTissSP_Proc.cd_lanc IS NOT null then
    pCdLancPed := vcTissSP_Proc.cd_lanc;
  END IF;
  ------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv       :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  pCdEmpresaTmp :=  nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa);
  if instr(nvl(pReserva,'X'),'#')>0 then
    pCdEmpresaTmp := substr(pReserva,instr(pReserva,'#')+1,4); -- empresa for真ada para uso aqui na guia
    vCdEmpresaPar := substr(pReserva,instr(pReserva,'#'),5); -- empresa for真ada com m真scara '#9999' pra passar como par真metros p/fun真真es filhas
  end if;
  --
  if nvl(vcConv.cd_convenio,9999) <> nvl(pCdConv,0) THEN
    vcConv := NULL;
    open  cConv(pCdConv);
    fetch cConv into vcConv;
    close cConv;
  end if;
  ------------------
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  vCp := 'ctm_sp-sadtGuia'; vTemp := null;
  if tConf(vCp).tp_utilizacao > 0 then
    --
    -- cabecalhoGuia------------------------------------
    vRet := F_ct_guiaCabecalho(null,1429,pCdAtend,pCdConta,pCdConv,null,'SP',vCtCabec,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.nr_registro_operadora_ans   := vCtCabec.registroANS;
      vTissGuia.NR_GUIA                     := vCtCabec.numeroGuiaPrestador;
      --
      vTissGuia.ID                          := vCtCabec.ID_GUIA; -- op真真o
    else
      RETURN NULL;
    end if;
    --
    -- guiaPrincipal------------------------------------
    vCp := 'guiaPrincipal'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTemp := vcTissGuiaOrigem.NR_GUIA;
        if pTpClasse in ( 'CRED_INTERNACAO','SECUNDARIAS') AND vcAtendimento.tp_atendimento = 'I' then
          vTemp := vcTissGuiaOrigem.NR_GUIA_SOL;
        end if;
        if vTemp is NULL and FNC_CONF('TP_GUIA_PRINCIPAL_EXT_SP',pCdConv,null) = '2' then
          open  cSolicAvulsa(vcAtendimento.cd_paciente, 'I',to_date(vcAtendimento.dt_atendimento,'yyyy-mm-dd'),pCdAtend,null);
          fetch cSolicAvulsa into vcSolicAvulsa;
          close cSolicAvulsa;
          vTemp := vcSolicAvulsa.NR_GUIA;
		  end if;
		-- Rafael Pereira Ramos - FATURCONV-6178 - PROD-4209
		if vTemp is NULL and FNC_CONF('TP_GUIA_PRINCIPAL_EXT_SP',pCdConv,null) = '3' then
          open  cPrimeiraGuiaAut(vcAtendimento.cd_paciente, pCdAtend);
          fetch cPrimeiraGuiaAut into vPrimeiraGuiaAut;
          close cPrimeiraGuiaAut;
          vTemp := vPrimeiraGuiaAut.nr_guia;

        end if;
      vTissGuia.NR_GUIA_PRINCIPAL := F_ST(null,vTemp,vCp,vcAtendimento.cd_guia,pCdAtend,pCdConta,null,null);
    end if;
    --
    -- dadosAutorizacao---------------------------------
    -- SR_TUSS0304 codValidacao, ausenciaCodValidacao
    vRet := F_ct_autorizacaoSADT(null,1433,pCdAtend,pCdConta,vcTissSP_Proc.cd_lanc,null,nCdGuiaSecundaria,null,vCtAutorizSadt,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.NR_GUIA_OPERADORA       := vCtAutorizSadt.numeroGuiaOperadora;
      vTissGuia.DT_AUTORIZACAO          := vCtAutorizSadt.dataAutorizacao;
      vTissGuia.CD_SENHA                := vCtAutorizSadt.senha;
      vTissGuia.DT_VALIDADE_AUTORIZADA  := vCtAutorizSadt.dataValidadeSenha;
      vTissGuia.CD_AUSENCIA_VALIDACAO   := vCtAutorizSadt.ausenciaCodValidacao;
      vTissGuia.CD_VALIDACAO            := vCtAutorizSadt.codValidacao;
      --
      vCdGuiaTmp  := vcAutorizacao.CD_GUIA; -- vari真vel guarda a guia em trabalho (no caso de espec真ficas)
      vNrGuiaTmp  := vcAutorizacao.NR_GUIA; -- vari真vel guarda a guia em trabalho (no caso de espec真ficas)
      --
    end if;
    --
    -- dadosBeneficiario--------------------------------
    vRet := F_ct_beneficiarioDados(null,1438,pCdAtend,pCdConta,null,null,'E',vCtBenef,pMsg,'RelerPac');
    if vRet = 'OK' then
      vTissGuia.NR_CARTEIRA                     := vCtBenef.numeroCarteira;
      vTissGuia.SN_ATENDIMENTO_RN               := vCtBenef.atendimentoRN;
      vTissGuia.NM_PACIENTE                     := vCtBenef.nomeBeneficiario;
	  vTissGuia.NM_SOCIAL_PACIENTE             := vCtBenef.nomeSocialBeneficiario;--Oswaldo FATURCONV-26150
      vTissGuia.NR_CNS                          := vCtBenef.numeroCNS;
      --OSWALDO IN真CIO
	  IF nvl(fnc_conf('SN_GRAVA_ID_BENEFICIARIO_SP',pCdConv,null),'N')='S' then
	    vTissGuia.TP_IDENT_BENEFICIARIO           := vCtBenef.tipoIdent;
        vTissGuia.NR_ID_BENEFICIARIO              := vCtBenef.identificadorBeneficiario;
        --vTissGuia.DS_TEMPLATE_IDENT_BENEFICIARIO  := vCtBenef.templateBiometrico; --Oswaldo FATURCONV-22404
	  end if;
	  --OSWALDO FIM
    end if;
    --
    -- dadosSolicitante
    -- contratadoSolicitante----------------------------
    vRet := F_ct_contratadoDados(null,1444,pCdAtend,nvl(vcConta.cd_conta_pai,pCdConta),pCdLancPed,null,null,null,vCtContrat,pMsg,'SOLIC_SP');
    if vRet = 'OK' then
      vTissGuia.CD_OPERADORA_CONTRATADO := vCtContrat.codigoPrestadorNaOperadora;
      vTissGuia.CD_CPF_CONTRATADO       := vCtContrat.cpfContratado;
      vTissGuia.CD_CGC_CONTRATADO       := vCtContrat.cnpjContratado;
      --vTissGuia.NM_PRESTADOR_CONTRATADO := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 --akiaddchico descomentado
    end if;
    --
    --Oswaldo FATURCONV-22404 inicio
    -- nomeContratadoSolicitante---------------------------------------------
    vCp := 'nomeContratadoSolicitante'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
      vTemp := vCtContrat.nomeContratado;
      vTissGuia.NM_PRESTADOR_CONTRATADO := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
    end if;
    --
    --Oswaldo FATURCONV-22404 fim
    -- profissionalSolicitante
    vRet :=F_ct_contratadoProfissionalDad ( null,1444,pCdAtend,pCdConta,null,null,vCtContrProf,pMsg,'SOLIC_SP');
    if vRet = 'OK' then
      vTissGuia.NM_PRESTADOR_SOL        := vCtContrProf.nomeProfissional;
      vTissGuia.DS_CONSELHO_SOL         := vCtContrProf.conselhoProfissional;
      vTissGuia.DS_CODIGO_CONSELHO_SOL  := vCtContrProf.numeroConselhoProfissional;
      vTissGuia.UF_CONSELHO_SOL         := vCtContrProf.UF;
      vTissGuia.CD_CBOS_SOL             := vCtContrProf.CBOS;
    end if;
    --
    -- dadosSolicitacao
    vRet := F_dadosSolicitacao(null,1456,pCdAtend,pCdConta,vcTissGuiaOrigem.cd_guia,null,vCtDadosSolic,pMsg,pCdLancPed);
    if vRet = 'OK' then
      vTissGuia.DH_ATENDIMENTO          := vCtDadosSolic.dataSolicitacao;
      vTissGuia.CD_CARATER_SOLICITACAO  := vCtDadosSolic.caraterAtendimento;
      vTissGuia.DS_HDA                  := vCtDadosSolic.indicacaoClinica;
      vTissGuia.TP_COBERTURA_ESPECIAL   := vCtDadosSolic.indCobEspecial; --Oswaldo FATURCONV-22404
    end if;
    --
    -- dadosExecutante
    -- contratadoExecutante-----------------------------
    vRet := F_ct_contratadoDados(null,1460,pCdAtend,pCdConta,null,null,pCdPrestTmp,null,vCtContrat,pMsg,vCdEmpresaPar||'@'||pTpClasse);
    if vRet = 'OK' then
      vTissGuia.CD_OPERADORA_EXE    := vCtContrat.codigoPrestadorNaOperadora;
      vTissGuia.CD_CPF_EXE          := vCtContrat.cpfContratado;
      vTissGuia.CD_CGC_EXE          := vCtContrat.cnpjContratado;
      vTissGuia.NM_PRESTADOR_EXE    := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404
    end if;
    --
    -- CNES---------------------------------------------
    vCp := 'CNES'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        if pCdEmpresaTmp <> nvl(vcHospital.cd_multi_empresa, 0) then
          open cHospital(pCdEmpresaTmp);
          fetch cHospital into vcHospital;
          close cHospital;
        end if;
        vTemp := nvl(to_char(vcHospital.nr_cnes),'999999');
      vTissGuia.CD_CNES_EXE := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
    end if;
    --
    -- dadosAtendimento---------------------------------
    vRet := F_ctm_sp_sadtAtendimento(null,1464,pCdAtend,pCdConta,vCtDadosAtendSp,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.TP_ATENDIMENTO         := vCtDadosAtendSp.tipoAtendimento;
      vTissGuia.TP_ACIDENTE            := vCtDadosAtendSp.indicacaoAcidente;
      vTissGuia.TP_CONSULTA            := vCtDadosAtendSp.tipoConsulta;
      vTissGuia.CD_MOTIVO_ALTA         := vCtDadosAtendSp.motivoEncerramento;
      --Oswaldo FATURCONV-22404 inicio
      vTissGuia.TP_REGIME_ATENDIMENTO  := vCtDadosAtendSp.regimeAtendimento;
      vTissGuia.TP_SAUDE_OCUPACIONAL   := vCtDadosAtendSp.saudeOcupacional;
      --Oswaldo FATURCONV-22404 fim
    end if;
    --
    -- observacao---------------------------------------
    vCp := 'observacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        --
        if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_OBS_JUSTIFIC_MED_SP',pCdConv,null) = 'O' then --O - Observacao da tela de guias
          if nvl(vcAutorizacao.cd_guia,0)<>vcAtendimento.cd_guia then
            open  cAutorizacao(vcAtendimento.cd_guia,null);
            fetch cAutorizacao into vcAutorizacao;
            close cAutorizacao;
          end if;
          --
          vTemp := substr(vcAutorizacao.ds_observacao,1,1000);
          --
        elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_OBS_JUSTIFIC_MED_SP',pCdConv,null) = 'J' then --J - Justificativa da tela de guias
          if nvl(vcAutorizacao.cd_guia,0)<>vcAtendimento.cd_guia then
            open  cAutorizacao(vcAtendimento.cd_guia,null);
            fetch cAutorizacao into vcAutorizacao;
            close cAutorizacao;
          end if;
          --
          vTemp := substr(vcAutorizacao.ds_justificativa,1,1000);
          --
        elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_OBS_JUSTIFIC_MED_SP',pCdConv,null) = 'A' then --A - Informa真真o/Observacao do atendimento
          if nvl(vcAtendimentoAUX.cd_atendimento,0)<>pCdAtend then
            open cAtendimentoAUX(pCdAtend);
            fetch cAtendimentoAUX into vcAtendimentoAUX;
            close cAtendimentoAUX;
          end if;
          --
          vTemp := substr(vcAtendimentoAUX.ds_info_atendimento,1,1000); -- ???
          --
        elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_OBS_JUSTIFIC_MED_SP',pCdConv,null) = 'C' AND vcAtendimento.tp_atendimento <> 'I' then --C - CID para ambulatoriais
          --
		  if vcAtendimento.cd_cid is not null then
			vTemp := 'CID:'||vcAtendimento.cd_cid; -- ATEN真真O: sintaxe padronizada da Unimed-BH (n真o alterar)
		  end if;
          --
        end if;
        -- ATEN真真O, coluna aumentada em 30/09/2014 -- vTemp := substr(vTemp,1,100); -- limita真ao provis真ria (de 500 p 100)
      vTissGuia.DS_OBSERVACAO := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
    end if;
    --
    -- assinaturaDigital--------------------------------
    --vRet := F_assinaturaDigital(null,9999,null,null,null,null,null,null);
    --
    -- informa真真es complementares de apoio
    vTissGuia.cd_versao_tiss_gerada := vcConv.cd_versao_tiss;
    vTissGuia.cd_convenio := pCdConv;
    vTissGuia.cd_atendimento := pCdAtend;
    vTissGuia.dt_validade := vcPaciente.dt_validade_carteira;
    if vcAtendimento.tp_atendimento = 'I' then
      vTissGuia.cd_reg_fat := nvl(vcConta.cd_conta_pai,pCdConta);
    else
      vTissGuia.cd_reg_amb := pCdConta;
    end if;
    vTissGuia.cd_remessa := vcConta.cd_remessa;
    if pTpClasse IN ('CREDENCIADOS','CRED_INTERNACAO') then
      vTissGuia.nm_autorizador_conv := 'C'||lpad(pCdEmpresaTmp,2,'0');
    else
      vTissGuia.nm_autorizador_conv := 'P'||lpad(pCdEmpresaTmp,2,'0');
    end if;
    vTissGuia.sn_tratou_retorno := 'N';
    if FNC_CONF('TP_NR_GUIA_PREST_SP',pCdConv,null) = '4' and vNrGuiaTmp IS NOT NULL THEN --vTissGuia.NR_GUIA_OPERADORA is not null then
      vTissGuia.NR_GUIA := vNrGuiaTmp; -- vTissGuia.NR_GUIA_OPERADORA;
    end if;
    --

	-- Oswaldo in真cio 210325
	--Quando a configura真真o TP_ZERA_VALOR_CRED_SP (A) Zera todos Servicos (SP e SD) - Guia Principal
	-- e a variavel vGuiaPrincipal for "S" O valor total e unit真rio da guia principal ser真 zerado.
	IF pTpClasse IN ('CREDENCIADOS','CRED_INTERNACAO') OR vTissGuia.NR_GUIA_PRINCIPAL IS NOT NULL THEN
	  vGuiaPrincipal:= 'N';
	END IF;
	-- Oswaldo fim 210325
    -- Grava真真o
    vResult := F_gravaTissGuia('INSERE','SP',vTissGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    ---------------------------------------------------
    --
    -- procedimentosExecutados
    -- ct_procedimentoExecutadoSadt---------------------
    --
    if NOT cTissSP_Proc%isOpen then
      vcTissSP_Proc := null;
      vGerandoGuia := 'N';
      OPEN  cTissSP_Proc(pCdAtend,pCdConta,pTpClasse,null);
      fetch cTissSP_Proc into vcTissSP_Proc;
      vGerandoGuia := 'S';
    end if;
    --
    LOOP
      --
      if Nvl(vcTissSP_Proc.cd_prestador,0)<>Nvl(pCdPrestTmp,0)
      --
      OR ( (
             ( nvl(FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_AMB',pCdConv,null),'1') = '2' AND vcAtendimento.tp_atendimento <> 'I' ) -- and pTpClasse = 'SECUNDARIAS'
             or
             ( nvl(FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_HOSP',pCdConv,null),'1') = '2' AND vcAtendimento.tp_atendimento = 'I' ) -- and pTpClasse = 'SECUNDARIAS'
            )
           and (   nvl(vcTissSP_Proc.nr_guia_conv,'X') <> nvl(vTissGuia.NR_GUIA_OPERADORA,'X') OR
                   NVL(vcTissSP_Proc.nr_senha_conv,'X')<> NVL(vTissGuia.CD_SENHA,'X')
                   OR (FNC_CONF('TP_NR_GUIA_PREST_SP',pCdConv,null) = '4' AND
                       ( (Nvl(Nvl(vcTissSP_Proc.cd_GUIA, vCdGuiaTmp),0) <> Nvl(vCdGuiaTmp,0)) AND vcTissSP_Proc.nr_senha_conv IS NOT NULL) -- OP 40093 - PDA 839934
                       )
                )
          )
      --
      OR cTissSP_Proc%NOTFOUND then
        if cTissSP_Proc%NOTFOUND then
          close cTissSP_Proc;
        end if;
        EXIT;
      end if;
      --
      if vcTissSP_Proc.cd_pro_fat <> nvl(vcProFat.cd_pro_fat,'X') THEN
        open  cProFat(vcTissSP_Proc.cd_pro_fat);
        fetch cProFat into vcProFat;
        close cProFat;
      end if;
      --
      if (fnc_conf('TP_TOTALIZA_SPSADT',pCdConv,null) <> 'N'  OR (Nvl(fnc_conf('TP_GERA_PROC_EQUIPE_SP',pCdConv,null),'1')='2' AND Nvl(vcProFat.nr_auxiliar,vcProFat.cd_por_ane) IS NOT NULL ))
        and Nvl(vcTissSP_Proc.data,'X')                    = nvl(vTissItGuia.DT_REALIZADO,'X')
        and Nvl(vcTissSP_Proc.hr_ini,'X')                  = nvl(vTissItGuia.HR_INICIO,'X')
        and Nvl(vcTissSP_Proc.hr_fim,'X')                  = nvl(vTissItGuia.HR_FIM,'X')
        and Nvl(vcTissSP_Proc.cod_proc,'X')                = nvl(vTissItGuia.CD_PROCEDIMENTO,'X')
        and Nvl(vcTissSP_Proc.vl_perc_reduc_acres,'X')     = nvl(vTissItGuia.VL_PERCENTUAL_MULTIPLA,'X')
        and Nvl(vcTissSP_Proc.tp_pagamento,'X')            = nvl(vTissItGuia.TP_PAGAMENTO,'X') -- +tp_pagamento(???, reordenar ctiss se preciso)
        AND (   (  nvl(vCtProcSadt.equipeSadt.Last,0)=0
                 OR
                  (Nvl(vCtProcSadt.equipeSadt.Last,0) = 1 AND Nvl(vCtProcSadt.equipeSadt(1).cd_prestador,0) = vcTissSP_Proc.cd_prestador_equ )     -- equipe com at真 1 prestador igual, agrupa
                )
            OR (Nvl(fnc_conf('TP_GERA_PROC_EQUIPE_SP',pCdConv,null),'1')='2' AND Nvl(vcProFat.nr_auxiliar,vcProFat.cd_por_ane) IS NOT null   )  -- equipe fechada (cirurgias) tamb真m agrupa
             )
      then
        pModoIt := 'ATUALIZA_TOTAIS';
      else
        pModoIt := 'INSERE';
        TotAgrupItSP.quantidade := 0; TotAgrupItSP.valortotal := 0; -- zera acumulador de agrupamento
      end if;
      --
      vGerandoGuia := vGerandoGuia||vcTissSP_Proc.cod_proc;
      --
	  -- Oswaldo in真cio 210325
	  --Quando a configura真真o TP_ZERA_VALOR_CRED_SP (A) Zera todos Servicos (SP e SD) - Guia Principal
	  -- e a variavel vGuiaPrincipal for "S" O valor total e unit真rio da guia principal ser真 zerado.
      --Oswaldo FATURCONV-20760 inicio
      IF vHomecareTpGuiaSP = 'S' THEN
        vRet := F_ct_procedimentoExecutadoSadt(null,1469,pCdAtend,pCdConta,vcTissSP_Proc.cd_lanc,vcTissSP_Proc.cd_itlan_med,vGuiaPrincipal,vCtProcSadt,pMsg,pModoIt);
      ELSE
        vRet := F_ct_procedimentoExecutadoSadt(null,1469,pCdAtend,pCdConta,vcTissSP_Proc.cd_lanc,null,vGuiaPrincipal,vCtProcSadt,pMsg,pModoIt);
      END IF;
      --
      --Oswaldo FATURCONV-20760 fim
	  -- Oswaldo fim 210325
      if vRet = 'OK' then
        vTissItGuia.ID_PAI                    := vTissGuia.ID;
        vTissItGuia.SQ_ITEM                   := vCtProcSadt.sequencialItem;
        vTissItGuia.DT_REALIZADO              := vCtProcSadt.dataExecucao;
        vTissItGuia.HR_INICIO                 := vCtProcSadt.horaInicial;
        vTissItGuia.HR_FIM                    := vCtProcSadt.horaFinal;
        vTissItGuia.TP_TAB_FAT                := vCtProcSadt.procedimento.codigoTabela;
        vTissItGuia.CD_PROCEDIMENTO           := vCtProcSadt.procedimento.codigoProcedimento;
        vTissItGuia.DS_PROCEDIMENTO           := vCtProcSadt.procedimento.descricaoProcedimento;
        vTissItGuia.QT_REALIZADA              := vCtProcSadt.quantidadeExecutada;
        vTissItGuia.CD_VIA_ACESSO             := vCtProcSadt.viaAcesso;
        vTissItGuia.TP_TECNICA_UTILIZADA      := vCtProcSadt.tecnicaUtilizada;
        vTissItGuia.VL_PERCENTUAL_MULTIPLA    := vCtProcSadt.reducaoAcrescimo;
        vTissItGuia.VL_UNITARIO               := vCtProcSadt.valorUnitario;
        vTissItGuia.VL_TOTAL                  := vCtProcSadt.valorTotal;
        -- informa真真es complementares de apoio
        vTissItGuia.CD_PRO_FAT    := vcTissSP_Proc.cd_pro_fat;
        vTissItGuia.TP_PAGAMENTO  := vcTissSP_Proc.tp_pagamento;
        --OSWALDO IN真CIO
        vTissItGuia.cd_mvto       := vcItemAux.cd_mvto;
        vTissItGuia.tp_mvto       := vcItemAux.tp_mvto;
        vTissItGuia.cd_itmvto     := vcItemAux.cd_itmvto;
        vTissItGuia.sn_principal  := Nvl(vTissItGuia.sn_principal,'N');
        IF vTissItGuia.tp_mvto = 'Imagem' AND  bImagemPrincipal THEN
          bImagemPrincipal:= FALSE;
          vTissItGuia.sn_principal  := 'S';
        elsIF vTissItGuia.tp_mvto = 'SADT' and  bSADTPrincipal THEN
          bSADTPrincipal:= FALSE;
          vTissItGuia.sn_principal  := 'S';
        elsIF vTissItGuia.tp_mvto = 'Cirurgia'  AND   vcItemAux.sn_principal = 'S' THEN
          vTissItGuia.sn_principal  := 'S';
        elsIF vTissItGuia.tp_mvto = 'Atendimento'  AND  bAtendimentoPrincipal THEN
          bAtendimentoPrincipal:= FALSE;
          vTissItGuia.sn_principal  := 'S';
        elsIF vTissItGuia.tp_mvto = 'Prescricao' and   bPrescricaoPrincipal THEN
          bPrescricaoPrincipal := FALSE;
          vTissItGuia.sn_principal  := 'S';
        END IF;
        --OSWALDO FIM
        --
        -- Grava真真o
        vRet := F_gravaTissItGuia (pModoIt,'SP',vTissItGuia,pMsg,null);
        if pMsg is not null then
          RETURN NULL;
        end if;
        -- Concilia真真o
        if vcAtendimento.tp_atendimento<>'I' then
          vRet := F_concilia_id_it_envio('ITREG_AMB',vTissItGuia.ID,pCdAtend,pCdConta,vcTissSP_Proc.cd_lanc,null,null,pMsg,null);
        else
          vRet := F_concilia_id_it_envio('ITREG_FAT',vTissItGuia.ID,pCdAtend,pCdConta,vcTissSP_Proc.cd_lanc,null,null,pMsg,null);
        end if;
        if pMsg is not null then
          RETURN null;
        end if;
        --
        --IF  pModoIt = 'INSERE' then

          FOR K in 1..nvl(vCtProcSadt.equipeSadt.Last,0) LOOP
            vTissItGuiaEqu.ID_PAI               := vTissItGuia.ID;
            vTissItGuiaEqu.CD_ATI_MED           := vCtProcSadt.equipeSadt(K).grauPart;
            vTissItGuiaEqu.CD_OPERADORA         := vCtProcSadt.equipeSadt(K).codigoPrestadorNaOperadora;
            vTissItGuiaEqu.CD_CPF               := vCtProcSadt.equipeSadt(K).cpfContratado;
            vTissItGuiaEqu.NM_PRESTADOR         := vCtProcSadt.equipeSadt(K).nomeProf;
            vTissItGuiaEqu.DS_CONSELHO          := vCtProcSadt.equipeSadt(K).conselho;
            vTissItGuiaEqu.DS_CODIGO_CONSELHO   := vCtProcSadt.equipeSadt(K).numeroConselhoProfissional;
            vTissItGuiaEqu.UF_CONSELHO          := vCtProcSadt.equipeSadt(K).UF;
            vTissItGuiaEqu.CD_CBOS              := vCtProcSadt.equipeSadt(K).CBOS;
            --OSWALDO
            vTissItGuiaEqu.SQ_REF               := vCtProcSadt.sequencialItem;
            -- Grava真真o
            vRet := F_gravaTissItGuiaEqu ('SP',vTissItGuiaEqu,pMsg,null);
            if pMsg is not null then
              close cTissSP_Proc;
              RETURN NULL;
            end if;
            --
          END LOOP;
        --END IF;
      end if;
      --
      vGerandoGuia := 'N';
      FETCH cTissSP_Proc into vcTissSP_Proc;
      vGerandoGuia := 'S';
      --
    END LOOP;
    --
    if pTpClasse = 'PRINCIPAL' and cTissSP_Proc%isOpen then
      close cTissSP_Proc;
    end if;
    --
    -- outrasDespesas
    -- ct_outrasDespesas--------------------------------
    if pTpClasse in ('PRINCIPAL','CRED_INTERNACAO','CREDENCIADOS','SECUNDARIAS') then
      --
      if pTpClasse = 'SECUNDARIAS' then -- guia espec真fica passa a guia pra achar despesas dela.
        OPEN  cTissOutDesp(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdPrestTmp,Nvl(nCdGuiaSecundaria,vCdGuiaTmp),null);
      else
        OPEN  cTissOutDesp(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdPrestTmp,null,null);
      end if;
      --
      LOOP
        --
        vGerandoGuia := 'N';
        FETCH cTissOutDesp into vcTissOutDesp;
        vGerandoGuia := 'S';
        EXIT WHEN cTissOutDesp%NOTFOUND;
        --
        if cTissOutDesp%FOUND then
          --
          if fnc_conf('TP_TOTALIZA_OUTRAS_DESP_SP',pCdConv,null) <> 'N'
            and vcTissOutDesp.data                    = nvl(vTissItGuiaOut.DT_REALIZADO,'X')
            and vcTissOutDesp.hr_ini                  = nvl(vTissItGuiaOut.HR_INICIO,'X')
            and vcTissOutDesp.hr_fim                  = nvl(vTissItGuiaOut.HR_FIM,'X')
            and vcTissOutDesp.cod_proc                = nvl(vTissItGuiaOut.CD_PROCEDIMENTO,'X')
            and vcTissOutDesp.ds_proc                 = nvl(vTissItGuiaOut.DS_PROCEDIMENTO,'X')
            and vcTissOutDesp.vl_perc_reduc_acres     = nvl(vTissItGuiaOut.VL_PERCENTUAL_MULTIPLA,'X')
            then
            pModoOut := 'ATUALIZA_TOTAIS';
          else
            pModoOut := 'INSERE';
            TotAgrupDesp.quantidade := 0; TotAgrupDesp.valortotal := 0; -- zera acumulador de agrupamento
          end if;
          --
          vGerandoGuia := vGerandoGuia||vcTissOutDesp.cod_proc;
          --
           -- sequencialItem -------------------------------------
          vCp := 'sequencialItem'; vTemp := null;
          IF tconf.EXISTS(vCp) AND tConf(vCp).tp_utilizacao>0 then --OSWALDO
            -- Continua de onde o nSqItem parou
            IF nSqItemOut = 0 THEN
              nSqItemOut:= nSqItem;
            END IF;
            nSqItemOut:= nSqItemOut + 1;
            vTemp := nSqItemOut;
            vTissItGuiaOut.sq_item := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,null);
          end if;
          --
          -- codigoDespesa------------------------------
          vCp := 'codigoDespesa'; vTemp := null;
          if tConf(vCp).tp_utilizacao>0 then
              if vcTissOutDesp.cd_pro_fat <> nvl(vcProFat.cd_pro_fat,'X') then
                open  cProFat(vcTissOutDesp.cd_pro_fat);
                fetch cProFat into vcProFat;
                close cProFat;
              end if;
              if vcTissOutDesp.cd_pro_fat <> nvl(vcProFatAux.cd_pro_fat,'X') then
                open  cProFatAux(vcTissOutDesp.cd_pro_fat, null);
                fetch cProFatAux into vcProFatAux;
                close cProFatAux;
              end if;
              --
              vTemp     := null;
              vTussRel  := null;
            --vTussRel.tp_servico_hospitalar := vcProFat.tp_serv_hospitalar;
            --vTussRel.tp_gru_pro := vcProFatAux.cd_gru_pro;
              vRet  := F_DM(25,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,vTussRel,vTuss,pMsg,null);
              vTemp := vTuss.CD_TUSS;
            vTissItGuiaOut.TP_DESPESA := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,null);   -- dm_outrasDespesas
          end if;
          --
          vRet := F_ct_procedimentoExecutadoOutr(null,1494,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,'SP',vCTOutDesp,pMsg,vTissItGuiaOut.TP_DESPESA);
          if vRet = 'OK' then
            vTissItGuiaOut.ID_PAI                 := vTissGuia.ID;
            vTissItGuiaOut.DT_REALIZADO           := vCTOutDesp.dataExecucao;
            vTissItGuiaOut.HR_INICIO              := vCTOutDesp.horaInicial;
            vTissItGuiaOut.HR_FIM                 := vCTOutDesp.horaFinal;
            vTissItGuiaOut.TP_TAB_FAT             := vCTOutDesp.codigoTabela;
            vTissItGuiaOut.CD_PROCEDIMENTO        := vCTOutDesp.codigoProcedimento;
            vTissItGuiaOut.QT_REALIZADA           := vCTOutDesp.quantidadeExecutada;
            vTissItGuiaOut.CD_UNIDADE_MEDIDA      := vCTOutDesp.unidadeMedida;
            vTissItGuiaOut.VL_PERCENTUAL_MULTIPLA := vCTOutDesp.reducaoAcrescimo;
            vTissItGuiaOut.VL_UNITARIO            := vCTOutDesp.valorUnitario;
            vTissItGuiaOut.VL_TOTAL               := vCTOutDesp.valorTotal;
            vTissItGuiaOut.DS_PROCEDIMENTO        := vCTOutDesp.descricaoProcedimento;
            vTissItGuiaOut.CD_REGISTRO_ANVISA     := vCTOutDesp.registroANVISA;
            vTissItGuiaOut.CD_CODIGO_FABRICANTE   := vCTOutDesp.codigoRefFabricante;
            vTissItGuiaOut.NR_AUTORIZACAO         := vCTOutDesp.autorizacaoFuncionamento;

            --OSWALDO IN真CIO
            -- itemVinculado-------------------------------------
            vCp := 'itemVinculado'; vTemp := null;
            IF tconf.EXISTS(vCp) AND tConf(vCp).tp_utilizacao>0 then
              vTemp := vCTOutDesp.itemVinculado;
              vTissItGuiaOut.SQ_REF  :=  F_ST(null,vTemp,vCp,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,null);
            END IF;
            --OSWALDO FIM
            --informa真真es complementares de apoio
            vTissItGuiaOut.CD_PRO_FAT             := vcTissOutDesp.cd_pro_fat;
            -- Grava真真o
            vRet := F_gravaTissItGuiaOut (pModoOut,'SP',vTissItGuiaOut,pMsg,null);
            if pMsg is not null then
              close cTissOutDesp;
              RETURN NULL;
            end if;
            -- Concilia真真o
            if vcAtendimento.tp_atendimento<>'I' then
              vRet := F_concilia_id_it_envio('ITREG_AMB',vTissItGuiaOut.ID,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,null,pMsg,null);
            else
              vRet := F_concilia_id_it_envio('ITREG_FAT',vTissItGuiaOut.ID,pCdAtend,pCdConta,vcTissOutDesp.cd_lanc,null,null,pMsg,null);
            end if;
            if pMsg is not null then
              RETURN null;
            end if;
            --
          end if;
        end if;
        --
      END LOOP;
      --
      vGerandoGuia := SubStr(vGerandoGuia,1,1);
      --
      close cTissOutDesp;
      --
    end if;
    --
    -- valorTotal--------------------------------
    vRet := F_ct_guiaValorTotal(null,1522,vTissGuia.ID,pCdAtend,pCdConta,pCdConv,vCtVlTotal,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.VL_TOT_SERVICOS         := vCtVlTotal.valorProcedimentos;
      vTissGuia.VL_TOT_DIARIAS          := vCtVlTotal.valorDiarias;
      vTissGuia.VL_TOT_TAXAS            := vCtVlTotal.valorTaxasAlugueis;
      vTissGuia.VL_TOT_MATERIAIS        := vCtVlTotal.valorMateriais;
      vTissGuia.VL_TOT_MEDICAMENTOS     := vCtVlTotal.valorMedicamentos;
      vTissGuia.VL_TOT_OPME             := vCtVlTotal.valorOPME;
      vTissGuia.VL_TOT_GASES            := vCtVlTotal.valorGasesMedicinais;
      vTissGuia.VL_TOT_GERAL            := vCtVlTotal.valorTotalGeral;
      vTissGuia.VL_TOTAL_GERAL_OUTRAS   := vCtVlTotal.valorTotalGeralDesp;  -- somente para relat真rio
      -- Grava真真o
      vRet := F_gravaTissGuia('ATUALIZA_TOTAIS','SP',vTissGuia,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
    end if;
    --
    vRet := F_gravaTissGuia('ATUALIZA_INCONSISTENCIA','SP',vTissGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
  end if;
  -- Oswaldo in真cio 210325
  --Quando SN_GUIA_PRINCIPAL_ZERADA for (1) Nao gerar de ambulatorial ent真o a guia principal de ambulat真rio ser真 abortada.
  IF vGuiaPrincipal = 'S' AND Nvl(DBAMV.pkg_ffcv_tiss_v4.FNC_CONF('SN_GUIA_PRINCIPAL_ZERADA',pCdConv,null),'0') = '1' THEN
    IF vTissGuia.VL_TOT_GERAL = '0.00' THEN
	  -- Apagar guia | N真o gera guia principal
	  DELETE DBAMV.TISS_GUIA WHERE ID = vTissGuia.ID;  -- checar necessidade
	  vTissGuia:= NULL;  -- checar necessidade
	  RETURN NULL; -- pode ser suficiente
	END IF;
  END IF;
  -- Oswaldo fim 210325
  --
  vTissGuia_OLD := vTissGuia;
  --
  vGerandoGuia := 'N';
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS THEN
      IF cTissSP_Proc%isOpen then
        close cTissSP_Proc;
      end if;
      IF cTissOutDesp%ISOPEN THEN
        CLOSE cTissOutDesp;
      END IF;
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_autorizacaoSADT( pModo          in varchar2,
                                pIdMap         in number,
                                pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                pCdConta       in dbamv.reg_amb.cd_reg_amb%type,
                                pCdLanc        in dbamv.itreg_fat.cd_lancamento%type,
                                pCdItLan       in varchar2,
                                pCdGuia        in dbamv.guia.cd_guia%type,
                                pCdConv        in dbamv.convenio.cd_convenio%type,
                                vCt            OUT NOCOPY RecAutorizSadt,
                                pMsg           OUT varchar2,
                                pReserva       in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  pCdGuiaTmp    dbamv.guia.cd_guia%type;
  vCp	        varchar2(1000);
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
  end if;
  if pCdConta is not null then
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  else
    vcConta := null;
  end if;
  --
  if pCdLanc is not null then
    if pCdAtend||pCdConta||pCdLanc <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento, 'XXX') then
      open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,null,null);
      fetch cItem into vcItem;
      close cItem;
    end if;
    IF vcItem.tp_mvto IN ('Imagem','SADT') AND vcAtendimento.tp_atendimento = 'E' then
      if nvl(vcItemAux.cd_atendimento||vcItemAux.cd_conta||vcItemAux.cd_lancamento,'XXX')<>pCdAtend||pCdConta||pCdLanc THEN
        open  cItemAux(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,null,null);
        fetch cItemAux into vcItemAux;
        close cItemAux;
      end if;
    ELSE
      vcItemAux := NULL;
    END IF;
  end if;
  -------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp :=  nvl(pCdConv,nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
  if (vcAtendimento.tp_atendimento = 'I' and nvl(FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_HOSP',pCdConvTmp,null),'1') = '2'
      or vcAtendimento.tp_atendimento <> 'I' and nvl(FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_AMB',pCdConvTmp,null),'1') = '2')
      and pCdLanc is not null
      THEN -- considera guia espec真fica do item
    pCdGuiaTmp := vcItem.cd_guia;
  ELSE
    pCdGuiaTmp := nCdGuiaSecundaria;
  end if;
  --
  if pCdGuiaTmp is null and nCdGuiaPrinc is not null then -- guia principal j真 obtida antes, sen真o obtem abaixo conforme configura真真o
      pCdGuiaTmp := nCdGuiaPrinc;
  else
    if pCdGuiaTmp is null then
      pCdGuiaTmp :=  nvl(pCdGuia,vcAtendimento.cd_guia);
    end if;
    if nCdGuiaPrinc is null then
      nCdGuiaPrinc := pCdGuiaTmp; -- Guia principal guardada em Global
    end if;
  end if;
  -------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  vCp := 'ct_autorizacaoSADT'; vTemp := null;
  if pModo is NOT null or tConf(vCp).tp_utilizacao > 0 then
    --
    vcAutorizacao := null;
    if pCdGuiaTmp is not null then
      vcAutorizacao := null;
      open  cAutorizacao(pCdGuiaTmp,null);
      fetch cAutorizacao into vcAutorizacao;
      close cAutorizacao;
    end if;
    if vcAutorizacao.nr_senha is null and FNC_CONF('SN_SOMENTE_GUIA_AUTORIZADA_SP',pCdConvTmp,null) = 'S' then
      vcAutorizacao := null;
    end if;
    --
    -- numeroGuiaOperadora------------------------------
    vCp := 'numeroGuiaOperadora'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcAutorizacao.nr_guia;
      vCt.numeroGuiaOperadora := F_ST(null,vTemp,vCp,pCdGuiaTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.numeroGuiaOperadora;
    end if;
    --
    -- dataAutorizacao----------------------------------
    vCp := 'dataAutorizacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      IF vcItemAux.dt_autorizacao_guia IS NOT NULL THEN -- caso externo, utilizando tela nova de pedido, informada data no item
        vTemp := vcItemAux.dt_autorizacao_guia;
      ELSE
        vTemp := vcAutorizacao.dt_autorizacao; -- situa真真o normal
      END IF;

      if vcAutorizacao.nr_senha is null and FNC_CONF('SN_SOMENTE_GUIA_AUTORIZADA_SP',pCdConvTmp,null) = 'N' then
        vTemp := vcAutorizacao.dt_solicitacao;
      end if;

      vCt.dataAutorizacao := F_ST(null,vTemp,vCp,pCdGuiaTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.dataAutorizacao;
    end if;
    --
    -- senha--------------------------------------------
    vCp := 'senha'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      --if pCdGuiaTmp is not null then
        if FNC_CONF('TP_DADOS_AUTORIZACAO_SENHA_SP',pCdConvTmp,null) = 'S' then --S-Senha
          vTemp := vcAutorizacao.nr_senha;
        elsif FNC_CONF('TP_DADOS_AUTORIZACAO_SENHA_SP',pCdConvTmp,null) = 'N' then --N-N真mero da Guia
          vTemp := vcAutorizacao.nr_guia;
        end if;
      vCt.senha := F_ST(null,vTemp,vCp,pCdGuiaTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.senha;
    end if;
    --
    -- dataValidadeSenha--------------------------------
    vCp := 'dataValidadeSenha'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcAutorizacao.dt_validade;
      vCt.dataValidadeSenha := F_ST(null,vTemp,vCp,pCdGuiaTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.dataValidadeSenha;
    end if;
    --
    -- ausenciaCodValidacao--------------------------------
    vCp := 'ausenciaCodValidacao'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      --OSWALDO IN真CIO
      if FNC_CONF('TP_ORIGEM_COD_VALIDACAO',pCdConvTmp,null) = 'ELEG' then
          vTemp := vcPaciente.cd_ausencia_validacao;
        else
          vTemp := null;
        end if;
        --OSWALDO FIM
      vCt.ausenciaCodValidacao := F_ST(null,vTemp,vCp,pCdGuiaTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.ausenciaCodValidacao;
    end if;
    --
    -- codValidacao--------------------------------
    vCp := 'codValidacao'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      --OSWALDO IN真CIO
      if FNC_CONF('TP_ORIGEM_COD_VALIDACAO',pCdConvTmp,null) = 'ELEG' then
          vTemp := vcPaciente.cd_validacao;
        else
          vTemp := null;
        end if;
        --OSWALDO FIM
      vCt.codValidacao := F_ST(null,vTemp,vCp,pCdGuiaTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.codValidacao;
    end if;
    --

  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_identEquipeSADT( pModo       in varchar2,
                                pIdMap      in number,
                                pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                pCdConta    in dbamv.reg_amb.cd_reg_amb%type,
                                pCdLanc     in dbamv.itreg_amb.cd_lancamento%type,
                                pCdItLan    in varchar2,
                                vCt         OUT NOCOPY tableEquipe,
                                pMsg        OUT varchar2,
                                pReserva    in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	        varchar2(1000);
  nEqCount      number := 0;
  --
  vTussRel      RecTussRel;
  vTuss         RecTuss;
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdLanc is not null then
      if pCdAtend||pCdConta||pCdLanc||null <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento||null, 'XXXX') then
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,null,null);
        fetch cItem into vcItem;
        close cItem;
      end if;
    end if;
    if vcConv.cd_convenio<>nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd) then
      open  cConv(nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
      fetch cConv into vcConv;
      close cConv;
    end if;
  end if;
  ----------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  ----------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ct_identEquipeSADT').tp_utilizacao > 0 then
    --
    FOR vcTissEquipe in (select cd_prestador, cd_ati_med, nvl(tp_pagamento,'P') tp_pagamento
                            from dbamv.itlan_med
                            where vcAtendimento.tp_atendimento = 'I'
                              and cd_reg_fat = pCdConta
                              and cd_lancamento = pCdLanc
                              and (pCdItLan is null or (pCdItLan is not null and cd_ati_med = pCdItLan))
                              and F_ret_sn_equipe('SP',pCdAtend,pCdConta,pCdLanc,nvl(pCdItLan,cd_ati_med),null) = 'S'
                         union all
                         select vcItem.cd_prestador, vcItem.cd_ati_med, vcItem.tp_pagamento
                            from sys.dual
                            where vcItem.cd_prestador_item is not null
                            and F_ret_sn_equipe('SP',pCdAtend,pCdConta,pCdLanc,null,null) = 'S'
                         order by cd_ati_med)
      LOOP
      --
      nEqCount := nEqCount + 1; -- contador de elementos v真lidos da equipe;
      --
      if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>vcTissEquipe.cd_prestador||pCdConvTmp then
        vcPrestador := null;
        open  cPrestador(vcTissEquipe.cd_prestador,null, pCdConvTmp, NULL ,vcItem.cd_con_pla); -- pda FATURCONV-1372
        fetch cPrestador into vcPrestador;
        close cPrestador;
      end if;
      --
      -- grauPart-----------------------------------------
      vCp := 'grauPart'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTussRel := null;
        vTussRel.cd_ati_med := vcTissEquipe.cd_ati_med;
        vTemp := F_DM(35,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
        vTemp := vTuss.CD_TUSS;
        vCt(nEqCount).grauPart := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);    -- dm_grauPart
        vResult := vCt(nEqCount).grauPart;
      end if;
      --
      FOR I in 1..2 LOOP -- os 2 campos abaixo s真o CHOICE ================
        --
        -- codigoPrestadorNaOperadora---------------------
        vCp := 'codigoPrestadorNaOperadora'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I THEN
		  --PROD-2542 - so vai gerar se o credenciamento estiver ativo ou configura真真o mesmo inativo
          if vcPrestador.sn_ativo_credenciamento = 'S' OR nvl(fnc_conf('TP_CONDICAO_CREDENC_PROF_EQ_SP',pCdConvTmp,null),'1') = '3' then
            vTemp := vcPrestador.cd_prestador_conveniado;
		      else
            vTemp := NULL;
          end if;
            if nvl(fnc_conf('TP_CONDICAO_CREDENC_PROF_EQ_SP',pCdConvTmp,null),'1') = '2' and vcTissEquipe.tp_pagamento<>'C' then
              vTemp := null; -- s真 gera se o servi真o for credenciado nesta condi真真o
            end if;
            IF vTemp IS NULL then
              IF fnc_conf('SN_COD_HOSP_PROF_N_CRED_EQ_SP',pCdConvTmp,null)='S' THEN
                if NVL(vcEmpresaConv.cd_multi_empresa||vcEmpresaConv.cd_convenio,'XX') <> nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa)||pCdConvTmp then
                  open  cEmpresaConv(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa), pCdConvTmp);
                  fetch cEmpresaConv into vcEmpresaConv;
                  close cEmpresaConv;
                END IF;
                vTemp := vcEmpresaConv.cd_hospital_no_convenio;
              END IF;
            END IF;
          vCt(nEqCount).codigoPrestadorNaOperadora := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcTissEquipe.cd_ati_med,null);
          vResult := vCt(nEqCount).codigoPrestadorNaOperadora;
          EXIT when vCt(nEqCount).codigoPrestadorNaOperadora is NOT null;
        end if;
        --
        -- cpfContratado----------------------------------
        vCp := 'cpfContratado'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I THEN
          if length(vcPrestador.nr_cpf_cgc)<=11 then
            vTemp := vcPrestador.nr_cpf_cgc;
          end if;
          vCt(nEqCount).cpfContratado := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcTissEquipe.cd_ati_med,null);
          vResult := vCt(nEqCount).cpfContratado;
          EXIT when vCt(nEqCount).cpfContratado is NOT null;
        end if;
        --
      END LOOP; -- fim do CHOICE =========================
      --
      -- nomeProf-----------------------------------------
      vCp := 'nomeProf'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcPrestador.nm_prestador;
        vCt(nEqCount).nomeProf := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcTissEquipe.cd_ati_med,null);
        vResult := vCt(nEqCount).nomeProf;
      end if;
      --
      -- conselho-----------------------------------------
      vCp := 'conselho'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTussRel := null;
        vTussRel.CD_CONSELHO := vcPrestador.CD_CONSELHO;
        vTemp := F_DM(26,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
        vTemp := vTuss.CD_TUSS;
        vCt(nEqCount).conselho := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcTissEquipe.cd_ati_med,null);    -- dm_conselhoProfissional
        vResult := vCt(nEqCount).conselho;
      end if;
      --
      -- numeroConselhoProfissional-----------------------
      vCp := 'numeroConselhoProfissional'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcPrestador.numero_conselho;
        vCt(nEqCount).numeroConselhoProfissional := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcTissEquipe.cd_ati_med,null);
        vResult := vCt(nEqCount).numeroConselhoProfissional;
      end if;
      --
      -- UF-----------------------------------------------
      vCp := 'UF'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --FUTURO RELACIONAMENTO COM A TELA (Terminologia 59)
        --vTemp := vTuss.CD_TUSS;
          vTemp := vcPrestador.uf_prestador;
        vCt(nEqCount).UF := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcTissEquipe.cd_ati_med,null);  -- dm_UF
        vResult := vCt(nEqCount).UF;
      end if;
      --
      -- CBOS---------------------------------------------
      vCp := 'CBOS'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao > 0 THEN
        vTussRel := null;
        vTussRel.CD_ESPECIALIDADE := vcPrestador.cd_especialid;
        vTussRel.CD_ATI_MED := vcTissEquipe.cd_ati_med;
        vTemp := F_DM(24,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
        vTemp := vTuss.CD_TUSS;
        vCt(nEqCount).CBOS := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,vcTissEquipe.cd_ati_med,null);    -- dm_CBOS
        vResult := vCt(nEqCount).CBOS;
      end if;
      --
      -- informa真真es complementares de apoio
      vCt(nEqCount).cd_prestador := vcTissEquipe.cd_prestador;
      --
    END LOOP;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_procedimentoExecutadoSadt(   pModo       in varchar2,
                                            pIdMap      in number,
                                            pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                            pCdConta    in dbamv.reg_amb.cd_reg_amb%type,
                                            pCdLanc     in dbamv.itreg_amb.cd_lancamento%type,
                                            pCdItLan    in varchar2,
											vGPrincipal in varchar2, -- Oswaldo in真cio 210325
                                            vCt         OUT NOCOPY RecProcSadt,
                                            pMsg        OUT varchar2,
                                            pReserva    in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  vRet          varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	          varchar2(1000);
  vCtProcDados  RecProcDados;
  vCtEquipe     tableEquipe;
  nVlTemp       number;
  nVlAcresDesc  number;
  vcTipoProc    cTipoProc%rowtype;
  --Oswaldo FATURCONV-20760 inicio
  vpCdItLan     NUMBER;
  vpCdItLan2    NUMBER;
  --Oswaldo FATURCONV-20760 fim
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    --Oswaldo FATURCONV-20760 inicio
    IF vHomecareTpGuiaSP = 'S' THEN
      vpCdItLan := pCdItLan;
      vpCdItLan2 := vcItem.cd_itlan_med;
    END IF;
    --Oswaldo FATURCONV-20760 fim
    --if pCdAtend||pCdConta||pCdLanc <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento, 'XXX') then
    if pCdAtend||pCdConta||pCdLanc||Nvl(vpCdItLan, 0) <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento||Nvl(vpCdItLan2,0), 'XXX') THEN --Oswaldo FATURCONV-20760
      --Oswaldo FATURCONV-20760 inicio
      IF vHomecareTpGuiaSP = 'S' THEN
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      ELSE
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,null,null);
      END IF;
      --Oswaldo FATURCONV-20760 fim
      fetch cItem into vcItem;
      close cItem;
    end if;
    if nvl(vcItemAux.cd_atendimento||vcItemAux.cd_conta||vcItemAux.cd_lancamento||vcItemAux.cd_itlan_med,'XXXX')<>pCdAtend||pCdConta||pCdLanc||pCdItLan then
      open  cItemAux(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      fetch cItemAux into vcItemAux;
      close cItemAux;
    end if;
    if vcItem.cd_pro_fat <> nvl(vcProFat.cd_pro_fat,'X') then
      open  cProFat(vcItem.cd_pro_fat);
      fetch cProFat into vcProFat;
      close cProFat;
    end if;
    if vcItem.cd_pro_fat <> nvl(vcProFatAux.cd_pro_fat,'X') then
      open  cProFatAux(vcItem.cd_pro_fat, null);
      fetch cProFatAux into vcProFatAux;
      close cProFatAux;
    end if;
  end if;
  ----------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  ----------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ct_procedimentoExecutadoSadt').tp_utilizacao > 0 then
    --
    -- sequencialItem -------------------------------------
    vCp := 'sequencialItem'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then --OSWALDO
      nSqItem:= nSqItem + 1;
      vTemp := nSqItem;
      vCt.sequencialItem := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.sequencialItem;
    end if;
    --
    -- dataExecucao-------------------------------------
    vCp := 'dataExecucao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if fnc_conf('TP_TOTALIZA_SPSADT',pCdConvTmp,null) = 'U' then --verifica se esta configurado para Agrupar em 真nica data (dt.in真cio da conta);
          vTemp := vcConta.dt_inicio;
        else
          --Opcao 1 - senao tiver agrupamento
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_SP',pCdConvTmp,null) = 'L' then    --Data do Lan真amento do Item
            vTemp := nvl(vcItemAux.dt_pedido,nvl(vcItem.dt_sessao,vcItem.dt_lancamento));
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_SP',pCdConvTmp,null) = 'A' then --Data do Atendimento
            vTemp := vcAtendimento.dt_atendimento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_SP',pCdConvTmp,null) = 'C' then --Data Inicio da Conta
            vTemp := vcConta.dt_inicio;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_SP',pCdConvTmp,null) = 'F' then --Data Fim da Conta
            vTemp := vcConta.dt_final;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_DT_INI_BASICO_SP',pCdConvTmp,null) = 'H' then --Data da Alta (atendimento)
            vTemp := vcAtendimento.dt_alta;
          end if;
          --
        end if;
        --
      vCt.dataExecucao := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.dataExecucao;
    end if;
    --
    -- horaInicial--------------------------------------
    vCp := 'horaInicial'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if fnc_conf('TP_TOTALIZA_SPSADT',pCdConvTmp,null) <> 'N' AND FNC_CONF('TP_HR_INI_BASICO_SP',pCdConvTmp,null) <> 'N' then --verifica se esta configurado para Agrupar em 真nica data (dt.in真cio da conta);
          vTemp := vcConta.hr_inicio;
        else
          --Opcao 1 - senao tiver agrupamento
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_SP',pCdConvTmp,null) = 'L' then    --Hora do Lan真amento do Item
            vTemp := vcItem.hr_lancamento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_SP',pCdConvTmp,null) = 'A' then --Hora do Atendimento
            vTemp := vcAtendimento.hr_atendimento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_SP',pCdConvTmp,null) = 'C' then --Hora Inicio da Conta
            vTemp := vcConta.hr_inicio;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_SP',pCdConvTmp,null) = 'F' then --Hora Fim da Conta
            vTemp := vcConta.hr_final;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_SP',pCdConvTmp,null) = 'H' then --Hora da Alta (atendimento)
            vTemp := vcAtendimento.hr_alta;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_BASICO_SP',pCdConvTmp,null) = 'N' then    --N真o gera Hora
            vTemp := NULL;
          end if;
          --
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_INI_EXEC_COMPL_SP',pCdConvTmp,null) = 'E'
            and nvl(vcItem.sn_horario_especial,'N') = 'S' then --Hor真rio Especial
            vTemp := vcItem.hr_lancamento;
          end if;
          --
        end if;
        --
      vCt.horaInicial := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.horaInicial;
    end if;
    --
    -- horaFinal----------------------------------------
    vCp := 'horaFinal'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if fnc_conf('TP_TOTALIZA_SPSADT',pCdConvTmp,null) <> 'N' AND FNC_CONF('TP_HR_FIM_BASICO_SP',pCdConvTmp,null) <> 'N' then --verifica se esta configurado para Agrupar em 真nica data (dt.in真cio da conta);
          vTemp := vcConta.hr_inicio;
        else
          --Opcao 1 - senao tiver agrupamento
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_SP',pCdConvTmp,null) = 'L' then    --Hora do Lan真amento do Item
            vTemp := vcItem.hr_lancamento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_SP',pCdConvTmp,null) = 'A' then --Hora do Atendimento
            vTemp := vcAtendimento.hr_atendimento;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_SP',pCdConvTmp,null) = 'C' then --Hora Inicio da Conta
            vTemp := vcConta.hr_inicio;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_SP',pCdConvTmp,null) = 'F' then --Hora Fim da Conta
            vTemp := vcConta.hr_final;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_SP',pCdConvTmp,null) = 'H' then --Hora da Alta (atendimento)
            vTemp := vcAtendimento.hr_alta;
          elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_BASICO_SP',pCdConvTmp,null) = 'N' then    --N真o gera Hora
            vTemp := NULL;
          end if;
          --
          if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_HR_FIM_EXEC_COMPL_SP',pCdConvTmp,null) = 'E'
            and nvl(vcItem.sn_horario_especial,'N') = 'S' then --Hor真rio Especial
            vTemp := vcItem.hr_lancamento;
          end if;
          --
        end if;
      vCt.horaFinal := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.horaFinal;
    end if;
    --
    -- procedimentosExecutados--------------------------
    IF pModo IS NULL then
      --Oswaldo FATURCONV-20760 inicio
      IF vHomecareTpGuiaSP = 'S' THEN
        vRet := F_ct_procedimentoDados(null,1474,pCdAtend,pCdConta,pCdLanc,pCdItLan,null,null,'SP',vCtProcDados,pMsg,null);
      ELSE
        vRet := F_ct_procedimentoDados(null,1474,pCdAtend,pCdConta,pCdLanc,null,null,null,'SP',vCtProcDados,pMsg,null);
      END IF;
      --Oswaldo FATURCONV-20760 fim
      if vRet = 'OK' then
        vCt.procedimento.codigoTabela            := vCtProcDados.codigoTabela;
        vCt.procedimento.codigoProcedimento      := vCtProcDados.codigoProcedimento;
        vCt.procedimento.descricaoProcedimento   := vCtProcDados.descricaoProcedimento;
      end if;
    END IF;
    --
    -- quantidadeExecutada------------------------------
    vCp := 'quantidadeExecutada'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        nVlTemp := vcItem.qt_lancamento;
        if pModo is null THEN
          IF (pReserva = 'ATUALIZA_TOTAIS' AND (Nvl(vcProFat.nr_auxiliar,0)=0 OR Nvl(vcProFat.cd_por_ane,0)=0))  THEN
            TotAgrupItSP.quantidade := TotAgrupItSP.quantidade + nVlTemp; -- acumulador em caso de agrupamento
          else
            TotAgrupItSP.quantidade := nVlTemp;
          END IF;
          nVlTemp := TotAgrupItSP.quantidade;
        end if;
        vTemp := nVlTemp;
      vCt.quantidadeExecutada := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.quantidadeExecutada;
    end if;
    --
    -- viaAcesso----------------------------------------
    vCp := 'viaAcesso'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      --FUTURO RELACIONAMENTO COM A TELA (Terminologia 61)
      --vTemp := F_DM(61,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
      --vTemp := vTuss.CD_TUSS;
        if nvl(fnc_conf('TP_SERV_INFORMA_VIA_AMB',pCdConvTmp,null),'1')>'1' then
          if nvl(vcAprTiss.cd_apr_tiss, 0) = 0 then
            open  cAprTiss(NULL);
            fetch cAprTiss into vcAprTiss;
            close cAprTiss;
          end if;
          open  cTipoProc( vcAprTiss.cd_apr_tiss, vcItem.cd_pro_fat);
          fetch cTipoProc into vcTipoProc;
          close cTipoProc;
        end if;
        if vcItem.cd_pro_fat <> nvl(vcProFat.cd_pro_fat,'X') then
          open  cProFat(vcItem.cd_pro_fat);
          fetch cProFat into vcProFat;
          close cProFat;
        end if;
        if ( nvl(vcProFat.nr_auxiliar,0) >0 or vcProFat.cd_por_ane is not null)
           or (vcTipoProc.cd_pro_fat_vinculado is not null and Upper(vcTipoProc.cd_pro_fat_vinculado) = 'VIA') then
          if vcItem.vl_percentual_multipla = '50' then
            vTemp := '2';
          elsif vcItem.vl_percentual_multipla = '70' then
            vTemp := '3';
          else
            vTemp := '1';
          end if;
        end if;
      vCt.viaAcesso := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);   -- dm_viaDeAcesso
      vResult := vCt.viaAcesso;
    end if;
    --
    -- tecnicaUtilizada---------------------------------
    vCp := 'tecnicaUtilizada'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      --FUTURO RELACIONAMENTO COM A TELA (Terminologia 48)
      --vTemp := F_DM(48,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
      --vTemp := vTuss.CD_TUSS;
        if (nvl(vcProFat.nr_auxiliar,0) >0 or vcProFat.cd_por_ane is not null) then
          if nvl(vcItemAux.tp_tecnica_utilizada,'C') ='V' then
            vTemp := '2';
          elsif nvl(vcItemAux.sn_robotica,'N') = 'S' then
            vTemp := '3';
          else
            vTemp := '1';
          end if;
        end if;
      vCt.tecnicaUtilizada := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);    -- dm_tecnicaUtilizada
      vResult := vCt.tecnicaUtilizada;
    end if;
    --
    -- reducaoAcrescimo---------------------------------
    vCp := 'reducaoAcrescimo'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        nVlAcresDesc := vcItem.vl_percentual_multipla;
        --
        if nvl(fnc_conf('TP_PERC_ACRES_DESC_SP',pCdConvTmp,null),'1') in ('3','4') and vcConta.cd_tip_acom is not null then
          -- verifica se h真 configura真真o para representar % de acomoda真真o superior
          if vcItem.cd_regra||vcConta.cd_tip_acom||vcProFatAux.cd_gru_pro||vcItem.cd_pro_fat<>nvl(vcAcomod.cd_regra||vcAcomod.cd_tip_acom||vcAcomod.cd_gru_pro||vcAcomod.cd_pro_fat,'XXXX') then
            vcAcomod := null;
            open  cAcomod(vcItem.cd_regra,vcConta.cd_tip_acom,vcProFatAux.tp_gru_pro,vcProFatAux.cd_gru_pro,vcItem.cd_pro_fat);
            fetch cAcomod into vcAcomod;
            close cAcomod;
          end if;
          if vcAcomod.vl_percentual is not null AND vcAcomod.vl_percentual <> 100 then
            nVlAcresDesc := vcAcomod.vl_percentual;
          end if;
        end if;
        -- verifica se h真 configura真真o para representar H.E. no Percentual (+30%) e soma ao j真 obtido se houver
        if nvl(fnc_conf('TP_PERC_ACRES_DESC_SP',pCdConvTmp,null),'1') IN ('2','4') and vcItem.sn_horario_especial = 'S' then
          --
          if vcItem.cd_regra||vcProFatAux.cd_gru_pro<>nvl(vcIndiceHE.cd_regra||vcIndiceHE.cd_gru_pro,'XX') then
            vcIndiceHE := null;
            open  cIndiceHE(vcItem.cd_regra,vcProFatAux.cd_gru_pro);
            fetch cIndiceHE into vcIndiceHE;
            close cIndiceHE;
          end if;
          if vcIndiceHE.vl_percentual is not null then
            nVlAcresDesc := nvl(nVlAcresDesc,100) + vcIndiceHE.vl_percentual;
          end if;
        end if;
        --
        vTemp := (nVlAcresDesc/100);
        --
      vCt.reducaoAcrescimo := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,null);
      vResult := vCt.reducaoAcrescimo;
      nVlAcresDesc := To_Number(vCt.reducaoAcrescimo,'999.99')*100; -- Guarda percentual para c真lculo valor unit真rio qdo.agrupado
    end if;
    -- valorUnitario------------------------------------
    --
    -- Campo deslocado mais abaixo por quest真es t真cnicas de c真lculo
    --
    -- valorTotal---------------------------------------
    vCp := 'valorTotal'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        nVlTemp := vcItem.vl_total_conta;
        --
        if vcItem.sn_pertence_pacote = 'S' then
          nVlTemp := 0; -- Pertence Pacote, zera
        end if;
        --
        if vcItem.tp_pagamento = 'C' then -- zerar credenciados
          if fnc_conf('TP_ZERA_VALOR_CRED_SP',pCdConvTmp,null) = 'S' OR fnc_conf('TP_ZERA_VALOR_CRED_SP',pCdConvTmp,null)=substr(vcProFatAux.tp_gru_pro,2,1) then
            nVlTemp := 0;
          end if;
		  -- Oswaldo in真cio 210325
		  --Quando a configura真真o TP_ZERA_VALOR_CRED_SP estiver com o valor "A" ent真o o valor da unit真rio e total
		  --da guia principal ser真 zerado.
		  if fnc_conf('TP_ZERA_VALOR_CRED_SP',pCdConvTmp,null) = 'A' AND vGPrincipal = 'S' then
		    nVlTemp := 0;
		  end if;
		  -- Oswaldo fim 210325
        end if;
        if pModo is null then
          TotAgrupItSP.valortotal := TotAgrupItSP.valortotal + nVlTemp;
          nVlTemp := TotAgrupItSP.valortotal;
        end if;
        vTemp := nVlTemp;
      vCt.valorTotal := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,pCdConvTmp);
      vResult := vCt.valorTotal;
    end if;
    --
    -- valorUnitario------------------------------------
    vCp := 'valorUnitario'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if nvl(fnc_conf('TP_VALOR_UNITARIO_SP',pCdConvTmp,null),'1') = '2' then
          vTemp := ((TotAgrupItSP.valortotal/nvl(TotAgrupItSP.quantidade,1))/nvl(nVlAcresDesc/100,1) );
        else
          vTemp := (vcItem.vl_total_conta/vcItem.qt_lancamento);   -- ??? PENDENTE, analisar op真真es j真 existentes
        end if;
        if vcItem.tp_pagamento = 'C' then -- zerar credenciados
          if fnc_conf('TP_ZERA_VALOR_CRED_SP',pCdConvTmp,null) = 'S' OR fnc_conf('TP_ZERA_VALOR_CRED_SP',pCdConvTmp,null)=substr(vcProFatAux.tp_gru_pro,2,1) then
            vTemp := 0;
          end if;
		  -- Oswaldo in真cio 210325
		  if fnc_conf('TP_ZERA_VALOR_CRED_SP',pCdConvTmp,null) = 'A' AND vGPrincipal = 'S' then
		    vTemp := 0;
          end if;
		  -- Oswaldo fim 210325
        end if;
      vCt.valorUnitario := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,null,pCdConvTmp);
      vResult := vCt.valorUnitario;
    end if;
    --
    -- identificacaoEquipe------------------------------
    IF pModo IS NULL then
      --Oswaldo FATURCONV-20760 inicio
      IF vHomecareTpGuiaSP = 'S' THEN
        vRet := F_ct_identEquipeSADT(null,1484,pCdAtend,pCdConta,pCdLanc,pCdItLan,vCtEquipe,pMsg,null);
      ELSE
        vRet := F_ct_identEquipeSADT(null,1484,pCdAtend,pCdConta,pCdLanc,null,vCtEquipe,pMsg,null);
      END IF;
      --Oswaldo FATURCONV-20760 fim
      if vRet = 'OK' then
        vCt.equipeSadt := vCtEquipe;
      end if;
    END IF;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_contratadoProfissionalDad (  pModo          in varchar2,
                                            pIdMap         in number,
                                            pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                            pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                            pCdPrestador   in dbamv.prestador.cd_prestador%type,
                                            pCdConv        in dbamv.convenio.cd_convenio%type,
                                            vCt            OUT NOCOPY RecContrProf,
                                            pMsg           OUT varchar2,
                                            pReserva       in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(1000);
  pCdConvTmp        dbamv.convenio.cd_convenio%type;
  vCdPrestadorTmp   dbamv.prestador.cd_prestador%type;
  vCdPrestExterno   dbamv.prestador_externo.cd_pres_ext%type;
  vCp	            varchar2(1000);
  --
  vTussRel          RecTussRel;
  vTuss             RecTuss;
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if nvl(vcAtendimentoAUX.cd_atendimento,0)<>pCdAtend then
      open cAtendimentoAUX(pCdAtend);
      fetch cAtendimentoAUX into vcAtendimentoAUX;
      close cAtendimentoAUX;
    end if;
  end if;
  if pCdConta is not null then
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  else
    vcConta := null;
  end if;
  ----------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp        :=  nvl(pCdConv,nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
  vCdPrestadorTmp   :=  nvl(pCdPrestador,vcAtendimento.cd_prestador);
  IF nCdPrestExtSol IS NOT NULL AND pCdPrestador IS NULL THEN
    vCdPrestExterno:= nCdPrestExtSol;
    nCdPrestExtSol:= NULL;
    vCdPrestadorTmp:= NULL;
  END IF;

  ----------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ct_contratadoProfissionalDados').tp_utilizacao > 0 then
    -- Profissional Solicitante
    --if pReserva = 'SOLIC_SP' and FNC_CONF('TP_PREST_CONTRATADO_SOLIC_SP',pCdConvTmp,null) = '1' then
      if   vcAtendimento.tp_atendimento = 'E' OR
         ( vcAtendimento.tp_atendimento = 'I' AND FNC_CONF('TP_SOL_GUIA_ESPECIF_INTER_SP',pCdConvTmp,null) = 2 )
      THEN
        if nvl(vcPedidoPrincipal.cd_atendimento,0)<>pCdAtend then
          vcPedidoPrincipal := null;
          open  cPedidoPrincipal(pCdAtend, null);
          fetch cPedidoPrincipal into vcPedidoPrincipal;
          close cPedidoPrincipal;
        end if;
      else
        vcPedidoPrincipal := null;
      end if;
      -- o M真dico 真 do Pedido Principal

   --if FNC_CONF('TP_PROF_CONTRATADO_SOLIC_SP',pCdConvTmp,null) = '2' THEN
   if  Nvl(pReserva,'XX') <> 'SOLIC_SP_PRESCRICAO' AND
      ( FNC_CONF('TP_PROF_CONTRATADO_SOLIC_SP',pCdConvTmp,null) = '2' OR
      ( vcAtendimento.tp_atendimento = 'I' AND FNC_CONF('TP_SOL_GUIA_ESPECIF_INTER_SP',pCdConvTmp,null) = 2 ) )
    THEN --CIMP-4238
   --if Nvl(pReserva,'XX') <> 'SOLIC_SP' AND FNC_CONF('TP_PROF_CONTRATADO_SOLIC_SP',pCdConvTmp,null) = '2' THEN --CIMP-FATURCONV-6740 - Configuracao somente para guias de faturamento - Nao pode ser Nvl(pReserva,'XX') <> 'SOLIC_SP'
        IF vcAtendimentoAUX.cd_pres_ext IS NOT NULL THEN
          vCdPrestExterno := vcAtendimentoAUX.cd_pres_ext;
        ELSIF  nvl(vcPedidoPrincipal.cd_prest_pedido,vcPedidoPrincipal.cd_pres_ext) is not null then
          vCdPrestadorTmp := vcPedidoPrincipal.cd_prest_pedido;
          vCdPrestExterno := vcPedidoPrincipal.cd_pres_ext;
        end IF;
        IF vCdPrestExterno IS NOT NULL then
          vCdPrestadorTmp := NULL;
        END IF;
      end if;
    --end if;
    --
    if vCdPrestadorTmp is not null then
      if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>vCdPrestadorTmp||pCdConvTmp then
        vcPrestador := null;
        open  cPrestador(vCdPrestadorTmp,null, pCdConvTmp, NULL, vcConta.cd_con_pla); -- pda FATURCONV-1372
        fetch cPrestador into vcPrestador;
        close cPrestador;
      end if;
    elsif vCdPrestExterno IS NOT NULL THEN
      IF Nvl(vcPrestadorExterno.cd_pres_ext,0)<>vCdPrestExterno then
        vcPrestadorExterno := null;
        open  cPrestadorExterno(vCdPrestExterno,null);
        fetch cPrestadorExterno into vcPrestadorExterno;
        close cPrestadorExterno;
      END IF;
    else
      vcPrestadorExterno := null;
    end if;
    --
    -- nomeProfissional---------------------------------
    vCp := 'nomeProfissional'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vCdPrestadorTmp is not null then
          vTemp := vcPrestador.nm_prestador;
        elsif vCdPrestExterno is not null then
          vTemp := vcPrestadorExterno.nome_prestador;
        end if;
        --
        if (pReserva = 'SOLIC_SP' and FNC_CONF('TP_PREST_CONTRATADO_SOLIC_SP',pCdConvTmp,null) = '2') and --se prof for o contratado
          (
            ( vCdPrestExterno                   IS NOT NULL AND
              vcPrestadorExterno.nome_prestador IS NOT NULL AND
              vcPrestadorExterno.NM_HOSPITAL    IS NULL AND
              FNC_CONF('TP_PROF_CONTRATADO_SOLIC_SP',pCdConvTmp,null) = '2')   --  e tiver o hospital
            OR
            ( vCdPrestExterno                   IS NULL AND
              FNC_CONF('TP_PROF_CONTRATADO_SOLIC_SP',pCdConvTmp,null) = '2'
            )
          )

          then
          vTemp := null; -- Profissional 真 nulo pois nesta configura真真o ele 真 o Contratado
        end if;        /* mantido para exibir na m_tiss_impressao
        if pReserva = 'CONSULTA_CRED' then
          vTemp := null; -- Nome Profissional 真 nulo para Guia de Consulta de Credenciado, pois o m真dico 真 o Contratado
        end if; */
      vCt.nomeProfissional := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdConvTmp,vCdPrestadorTmp,null);
      vResult := vCt.nomeProfissional;
    end if;
    --
    -- conselhoProfissional-----------------------------
    vCp := 'conselhoProfissional'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      if vCdPrestadorTmp is not null then
        vTussRel.CD_CONSELHO := vcPrestador.CD_CONSELHO;
      elsif vCdPrestExterno is not null then
        vTussRel.CD_CONSELHO := vcPrestadorExterno.cd_conselho;
      end if;
      vTemp := F_DM(26,pCdAtend,pCdConta,null,null,vTussRel,vTuss,pMsg,null);
      --vTemp := '6';  -- ????
      vTemp := vTuss.cd_tuss;
      vCt.conselhoProfissional := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdConvTmp,vCdPrestadorTmp,null);
      vResult := vCt.conselhoProfissional;
    end if;
    --
    -- numeroConselhoProfissional-----------------------
    vCp := 'numeroConselhoProfissional'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vCdPrestadorTmp is not null then
          vTemp := vcPrestador.numero_conselho;
        elsif vCdPrestExterno is not null then
          vTemp := vcPrestadorExterno.numero_conselho;
        end if;
      vCt.numeroConselhoProfissional := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdConvTmp,vCdPrestadorTmp,null);
      vResult := vCt.numeroConselhoProfissional;
    end if;
    --
    -- UF-----------------------------------------------
    vCp := 'UF'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vCdPrestadorTmp is not null then
          vTemp := vcPrestador.uf_prestador;
        elsif vCdPrestExterno is not null then
          vTemp := vcPrestadorExterno.uf_prestador;
        end if;
      vCt.UF := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdConvTmp,vCdPrestadorTmp,null);
      vResult := vCt.UF;
    end if;
    --
    -- CBOS---------------------------------------------
    vCp := 'CBOS'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vCdPrestadorTmp is not null then
          vTussRel.CD_ESPECIALIDADE := vcPrestador.cd_especialid;
        elsif vCdPrestExterno is not null then
          vTussRel.CD_ESPECIALIDADE := vcPrestadorExterno.cd_especialid;
        end if;
        vTemp := F_DM(24,pCdAtend,pCdConta,null,null,vTussRel,vTuss,pMsg,null);
        vTemp := vTuss.CD_TUSS;
      vCt.CBOS := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdConvTmp,vCdPrestadorTmp,null);
      vResult := vCt.CBOS;
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ctm_consultaGuia(   pModo          in varchar2,
                                pIdMap         in number,
                                pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                pCdConta       in dbamv.reg_amb.cd_reg_amb%type,
                                pCdLanc        in dbamv.itreg_fat.cd_lancamento%type,
                                pMsg           OUT varchar2,
                                pReserva       in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(1000);
  vCp	            varchar2(1000);
  vRet              varchar2(1000);
  vTissGuia         dbamv.tiss_guia%rowtype;
  pCdConv           dbamv.convenio.cd_convenio%type;
  vCtBenef          RecBenef;
  vCtCabec          RecCabec;
  vCtContrat        RecContrat;
  vCtContrProf      RecContrProf;
  vCtConsultaAtend  RecConsultaAtend;
  vCdPrestadorTMP   dbamv.atendime.cd_prestador%type;
  vTpGuiaConsulta   varchar2(20);
BEGIN
  --
  if pModo IS NULL THEN  vGerandoGuia := 'S'; END IF;
  --
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdAtend||pCdConta||pCdLanc <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento, 'XXX') then
      open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,null,null);
      fetch cItem into vcItem;
      close cItem;
    end if;
    -------------------------
    -- Campos b真sicos para esta CT, caso n真o venham via par真metro
    pCdConv     :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
    --
    if nvl(vcConv.cd_convenio,9999) <> nvl(pCdConv,0) THEN
      vcConv := NULL;
      open  cConv(pCdConv);
      fetch cConv into vcConv;
      close cConv;
    end if;
    -------------------------
  end if;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  -- Condi真真o para Contratado ser o M真dico se credenciado
  if nvl(FNC_CONF('TP_CONTRATADO_CO',pCdConv,null),'1') = '2' and vcItem.tp_pagamento = 'C' then -- credenciado, gera o m真dico como Contratado ao inv真s do HOSPITAL
    vCdPrestadorTMP := vcAtendimento.cd_prestador;
    vTpGuiaConsulta := 'CONSULTA_CRED';
  end if;
  --
  vCp := 'ctm_consultaGuia'; vTemp := null;
  if tConf(vCp).tp_utilizacao > 0 then
    --
    -- cabecalhoConsulta-------------------------------
    vRet := F_ct_guiaCabecalho(null,1397,pCdAtend,pCdConta,pCdConv,null,'CO',vCtCabec,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.nr_registro_operadora_ans   := vCtCabec.registroANS;
      vTissGuia.NR_GUIA                     := vCtCabec.numeroGuiaPrestador;
      --
      vTissGuia.ID                          := vCtCabec.ID_GUIA; -- op真真o
    else
      RETURN NULL;
    end if;
    --
    -- numeroGuiaOperadora-----------------------------
    vCp := 'numeroGuiaOperadora'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        if nvl(vcAutorizacao.cd_guia,0)<>vcAtendimento.cd_guia then
          open  cAutorizacao(vcAtendimento.cd_guia,null);
          fetch cAutorizacao into vcAutorizacao;
          close cAutorizacao;
        end if;
        vTemp := vcAutorizacao.nr_guia;
      vTissGuia.NR_GUIA_OPERADORA := F_ST(null,vTemp,vCp,vcAtendimento.cd_guia,pCdAtend,pCdConta,null,null);
    end if;
    --

    -- codValidacao--------------------------------------
    vCp := 'codValidacao'; vTemp := null;
    if tconf.EXISTS(vCp) AND tConf(vCp).tp_utilizacao>0 then
      --OSWALDO IN真CIO
      if FNC_CONF('TP_ORIGEM_COD_VALIDACAO',pCdConv,null) = 'ELEG' then
          vTemp := vcPaciente.CD_VALIDACAO;
        else
          vTemp := null;
          --OSWALDO FIM
        end if;
      vTissGuia.CD_VALIDACAO := F_ST(null,vTemp,vCp,vcAtendimento.cd_guia,pCdAtend,pCdConta,null,null);
    end if;
    --

    -- ausenciaCodValidacao------------------------------
    vCp := 'ausenciaCodValidacao'; vTemp := null;
    if tconf.EXISTS(vCp) AND tConf(vCp).tp_utilizacao>0 then
      --OSWALDO IN真CIO
      if FNC_CONF('TP_ORIGEM_COD_VALIDACAO',pCdConv,null) = 'ELEG' then
          vTemp := vcPaciente.CD_AUSENCIA_VALIDACAO;
        else
          vTemp := null;
          --OSWALDO FIM
        end if;
      vTissGuia.CD_AUSENCIA_VALIDACAO := F_ST(null,vTemp,vCp,vcAtendimento.cd_guia,pCdAtend,pCdConta,null,null);
    end if;
    --

    -- dadosBeneficiario-------------------------------
    vRet := F_ct_beneficiarioDados(null,1401,pCdAtend,pCdConta,null,null,'E',vCtBenef,pMsg,'RelerPac');
    if vRet = 'OK' then
      vTissGuia.NR_CARTEIRA                     := vCtBenef.numeroCarteira;
      vTissGuia.SN_ATENDIMENTO_RN               := vCtBenef.atendimentoRN;
      vTissGuia.NM_PACIENTE                     := vCtBenef.nomeBeneficiario;
	  vTissGuia.NM_SOCIAL_PACIENTE              := vCtBenef.nomeSocialBeneficiario; --Oswaldo FATURCONV-26150
      vTissGuia.NR_CNS                          := vCtBenef.numeroCNS;
	  --OSWALDO IN真CIO
      IF nvl(fnc_conf('SN_GRAVA_ID_BENEFICIARIO_CO',pCdConv,null),'N')='S' then
	    vTissGuia.TP_IDENT_BENEFICIARIO           := vCtBenef.tipoIdent;
        vTissGuia.NR_ID_BENEFICIARIO              := vCtBenef.identificadorBeneficiario;
        --vTissGuia.DS_TEMPLATE_IDENT_BENEFICIARIO  := vCtBenef.templateBiometrico; --Oswaldo FATURCONV-22404
	  end if;
	  --OSWALDO FIM
    end if;
    --
    -- contratadoExecutante----------------------------
    vRet := F_ct_contratadoDados(null,1407,pCdAtend,pCdConta,null,null,vCdPrestadorTMP,null,vCtContrat,pMsg,null);
    if vRet = 'OK' then
      vTissGuia.CD_OPERADORA_EXE        := vCtContrat.codigoPrestadorNaOperadora;
      vTissGuia.CD_CPF_EXE              := vCtContrat.cpfContratado;
      vTissGuia.CD_CGC_EXE              := vCtContrat.cnpjContratado;
      vTissGuia.NM_PRESTADOR_EXE_COMPL  := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 inicio
    end if;
    --
    -- CNES--------------------------------------------
    vCp := 'CNES'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 THEN

      if vCdPrestadorTMP is not null THEN

        if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>vCdPrestadorTMP||pCdConv THEN
          vcPrestador := null;
          open  cPrestador(vCdPrestadorTmp,null,pCdConv , NULL ,vcItem.cd_con_pla); -- pda FATURCONV-1372
          fetch cPrestador into vcPrestador;
          close cPrestador;
          --
        end if;
        --
        vTemp := vcPrestador.codigo_cnes;
      else
        if nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa) <> nvl(vcHospital.cd_multi_empresa, 0) THEN
          open cHospital(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa));
          fetch cHospital into vcHospital;
          close cHospital;
        end if;
        vTemp := to_char(vcHospital.nr_cnes);
      END IF;
      --
      vTissGuia.CD_CNES_EXE := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
    end if;
    --
    -- profissionalExecutante--------------------------

    vRet := F_ct_contratadoProfissionalDad ( null,1413,pCdAtend,pCdConta,vCdPrestadorTMP,null,vCtContrProf,pMsg,vTpGuiaConsulta);
    --vRet := F_ct_contratadoProfissionalDad ( null,1413,pCdAtend,pCdConta,null,null,vCtContrProf,pMsg,vTpGuiaConsulta);
    if vRet = 'OK' THEN
      vTissGuia.NM_PRESTADOR_EXE        := vCtContrProf.nomeProfissional;
      vTissGuia.DS_CONSELHO_EXE         := vCtContrProf.conselhoProfissional;
      vTissGuia.DS_CODIGO_CONSELHO_EXE  := vCtContrProf.numeroConselhoProfissional;
      vTissGuia.UF_CONSELHO_EXE         := vCtContrProf.UF;
      vTissGuia.CD_CBOS_EXE             := vCtContrProf.CBOS;
    end if;
    --
    -- indicacaoAcidente-------------------------------
    vCp := 'indicacaoAcidente'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
      --FUTURO RELACIONAMENTO COM A TELA (Terminologia 36)
      --vTemp := F_DM(36,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
      --vTemp := vTuss.CD_TUSS;
        IF vcAtendimento.tp_acidente_tiss IS null then
          vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                        vcAtendimento.cd_pro_int,'TP_ACIDENTE_TISS',vcAtendimento.dt_atendPac);
        END IF;
        IF vtemp IS NULL THEN
          vTemp := nvl( vcAtendimento.tp_acidente_tiss, '9');
        END IF;
      vTissGuia.TP_ACIDENTE := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);   -- dm_indicadorAcidente
    end if;
    --
    -- dadosAtendimento
    vRet :=F_ctm_consultaAtendimento ( null,1420,pCdAtend,pCdConta,pCdLanc,null,null,vCtConsultaAtend,pMsg,null);
    if vRet = 'OK' THEN
      --Oswaldo FATURCONV-22404 inicio
      vTissGuia.TP_COBERTURA_ESPECIAL  := vCtConsultaAtend.coberturaEspecial;
      vTissGuia.TP_REGIME_ATENDIMENTO  := vCtConsultaAtend.regimeAtendimento;
      vTissGuia.TP_SAUDE_OCUPACIONAL   := vCtConsultaAtend.saudeOcupacional;
      --Oswaldo FATURCONV-22404 fim
      vTissGuia.DH_ATENDIMENTO         := vCtConsultaAtend.dataAtendimento;
      vTissGuia.TP_CONSULTA            := vCtConsultaAtend.tipoConsulta;
      vTissGuia.TP_TAB_FAT_CO          := vCtConsultaAtend.codigoTabela;
      vTissGuia.CD_PROCEDIMENTO_CO     := vCtConsultaAtend.codigoProcedimento;
      vTissGuia.VL_PROCEDIMENTO_CO     := vCtConsultaAtend.valorProcedimento;
    end if;
    --
    -- observacao--------------------------------------
    vCp := 'observacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        --
        if FNC_CONF('TP_OBS_JUSTIFIC_MED_CO',pCdConv,null) = 'O' then --O - Observacao da tela de guias
          if nvl(vcAutorizacao.cd_guia,0)<>vcAtendimento.cd_guia then
            open  cAutorizacao(vcAtendimento.cd_guia,null);
            fetch cAutorizacao into vcAutorizacao;
            close cAutorizacao;
          end if;
          --
          vTemp := substr(vcAutorizacao.ds_observacao,1,1000);
          --
        elsif FNC_CONF('TP_OBS_JUSTIFIC_MED_CO',pCdConv,null) = 'J' then --J - Justificativa da tela de guias
          if nvl(vcAutorizacao.cd_guia,0)<>vcAtendimento.cd_guia then
            open  cAutorizacao(vcAtendimento.cd_guia,null);
            fetch cAutorizacao into vcAutorizacao;
            close cAutorizacao;
          end if;
          --
          vTemp := substr(vcAutorizacao.ds_justificativa,1,1000);
          --
        elsif FNC_CONF('TP_OBS_JUSTIFIC_MED_CO',pCdConv,null) = 'A' then --A - Informa真真o/Observacao do atendimento
          if nvl(vcAtendimentoAUX.cd_atendimento,0)<>pCdAtend then
            open cAtendimentoAUX(pCdAtend);
            fetch cAtendimentoAUX into vcAtendimentoAUX;
            close cAtendimentoAUX;
          end if;
          --
          vTemp := substr(vcAtendimentoAUX.ds_info_atendimento,1,1000); -- ???
          --
        end if;

        --CAFL
        vTemp := replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                   vTemp
                 ,'3.02.00','3-02-00')
                 ,'3.02.01','3-02-01')
                 ,'3.02.02','3-02-02')
                 ,'3.03.00','3-03-00')
                 ,'3.03.01','3-03-01')
                 ,'3.03.02','3-03-02')
                 ,'3.03.03','3-03-03')
                 ,'3.04.00','3-04-00')
                 ,'3.04.01','3-04-01')
                 ,'3.05.00','3-05-00')
                 ,'4.00.00','4-00-00')
                 ,'4.00.01','4-00-01')
                 ,'4.01.00','4-01-00');

      vTissGuia.DS_OBSERVACAO := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
    end if;
    --
    -- assinaturaDigital-------------------------------
    --vRet := F_assinaturaDigital(null,9999,null,null,null,null,null,null);
    --
    -- GRAVA真真O DO REGISTRO DA GUIA--------------------
    --
    -- informa真真es complementares de apoio
    vTissGuia.cd_versao_tiss_gerada  := vcConv.cd_versao_tiss;
    vTissGuia.cd_convenio := pCdConv;
    vTissGuia.cd_atendimento := pCdAtend;
    vTissGuia.cd_reg_amb := pCdConta;
    vTissGuia.cd_remessa := vcConta.cd_remessa;
    vTissGuia.dt_validade := vcPaciente.dt_validade_carteira;
    if nvl(vcItem.tp_pagamento,'P') = 'C' then
      vTissGuia.nm_autorizador_conv := 'C'||lpad(vcConta.cd_multi_empresa,2,'0');
    else
      vTissGuia.nm_autorizador_conv := 'P'||lpad(vcConta.cd_multi_empresa,2,'0');
    end if;
    vTissGuia.sn_tratou_retorno := 'N';
    vTissGuia.VL_TOT_GERAL := vTissGuia.VL_PROCEDIMENTO_CO;
    if FNC_CONF('TP_NR_GUIA_PREST_CO',pCdConv,null) = '4' and vTissGuia.NR_GUIA_OPERADORA is not null then
      vTissGuia.NR_GUIA := vTissGuia.NR_GUIA_OPERADORA;
    end if;
    --
    -- Grava真真o
    vResult := F_gravaTissGuia('INSERE','CO',vTissGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
    vRet := F_gravaTissGuia('ATUALIZA_INCONSISTENCIA','CO',vTissGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
  end if;
  --
  vGerandoGuia := 'N';
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ctm_consultaAtendimento(pModo       in varchar2,
                                    pIdMap      in number,
                                    pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                    pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                    pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                    pCdProFat   in dbamv.pro_fat.cd_pro_fat%type,
                                    pCdConv     in dbamv.convenio.cd_convenio%type,
                                    vCt         OUT NOCOPY RecConsultaAtend,
                                    pMsg        OUT varchar2,
                                    pReserva    in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  pCdProFatTmp  dbamv.pro_fat.cd_pro_fat%type;
  vCp	        varchar2(1000);
  --
  vTussRel      RecTussRel;
  vTuss         RecTuss;
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdLanc is not null then
      if pCdAtend||pCdConta||pCdLanc <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento, 'XXX') then
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,null,null);
        fetch cItem into vcItem;
        close cItem;
      end if;
    end if;
  end if;
  ---------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(pCdConv,nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
  pCdProFatTmp  :=  nvl(pCdProFat,vcItem.cd_pro_fat);
  ---------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ctm_consultaAtendimento').tp_utilizacao > 0 then
    --
    vTemp := null;
    vTemp := F_DM(22,pCdAtend,pCdConta,pCdLanc,null,vTussRel,vTuss,pMsg,null);
    if pMsg is not null or vTuss.cd_tuss is null then
      if pCdProFatTmp <> nvl(vcProFat.cd_pro_fat,'X') then
        open  cProFat(pCdProFatTmp);
        fetch cProFat into vcProFat;
        close cProFat;
      end if;
    end if;
    --
    --Oswaldo FATURCONV-22404 inicio
    -- coberturaEspecial----------------------------------
    vCp := 'coberturaEspecial'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
     IF vcAtendimento.tp_cobertura_especial IS null then
      vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                       vcAtendimento.cd_pro_int,'TP_COBERTURA_ESPECIAL',vcAtendimento.dt_atendPac);
     END IF;
     IF vTemp IS NULL then
      IF vcAtendimento.tp_cobertura_especial IS NOT NULL then
        vTemp := LPad(vcAtendimento.tp_cobertura_especial, 2, '0');
      END IF;
     END IF;
      vCt.coberturaEspecial := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);  --dm_cobEsp
      vResult := vCt.coberturaEspecial;
    end if;
    --
    -- regimeAtendimento----------------------------------
    vCp := 'regimeAtendimento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
     IF vcAtendimento.tp_regime_atendimento IS NULL then
      vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                       vcAtendimento.cd_pro_int,'TP_REGIME_ATENDIMENTO',vcAtendimento.dt_atendPac);
     END IF;
     IF vTemp IS NULL then
      IF vcAtendimento.tp_regime_atendimento IS NOT NULL then
        vTemp := LPad(vcAtendimento.tp_regime_atendimento, 2, '0');
      ELSE
        IF vcAtendimento.tp_atendimento = 'H' THEN
           vTemp := '02';
        ELSIF vcAtendimento.tp_atendimento in ('A', 'E') THEN
           vTemp := '01';
        ELSIF vcAtendimento.tp_atendimento = 'I' THEN
           vTemp := '03';
        ELSIF vcAtendimento.tp_atendimento = 'U' THEN
           vTemp := '04';
        END IF;
      END IF;
     END IF;
      vCt.regimeAtendimento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null); --dm_regimeAtendimento
      vResult := vCt.regimeAtendimento;
    end if;
    --
    -- saudeOcupacional----------------------------------
    vCp := 'saudeOcupacional'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
     IF vcAtendimento.tp_saude_ocupacional IS null then
      vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                       vcAtendimento.cd_pro_int,'TP_SAUDE_OCUPACIONAL',vcAtendimento.dt_atendPac);
     END IF;
     IF vTemp IS NULL then
      IF vcAtendimento.tp_saude_ocupacional IS NOT NULL then
        vTemp := LPad(vcAtendimento.tp_saude_ocupacional, 2, '0');
      END IF;
     END IF;
      vCt.saudeOcupacional := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);  --dm_saudeOcupacional
      vResult := vCt.saudeOcupacional;
    end if;
    --
    --Oswaldo FATURCONV-22404 fim
    -- dataAtendimento----------------------------------
    vCp := 'dataAtendimento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcAtendimento.dt_atendimento;
      vCt.dataAtendimento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vResult := vCt.dataAtendimento;
    end if;
    --
    -- tipoConsulta-------------------------------------
    vCp := 'tipoConsulta'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      --FUTURO RELACIONAMENTO COM A TELA (Terminologia 52)
      --vTemp := F_DM(52,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
      --vTemp := vTuss.CD_TUSS;
        vTemp := vcAtendimento.tp_consulta_tiss;
      vCt.tipoConsulta := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vResult := vCt.tipoConsulta;
    end if;
    --
    -- codigoTabela-------------------------------------
    vCp := 'codigoTabela'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vTuss.CD_TIP_TUSS;
      vCt.codigoTabela := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdConta,pCdLanc,pCdProFat);    -- dm_tabela
      vResult := vCt.codigoTabela;
    end if;
    --
    -- codigoProcedimento-------------------------------
    vCp := 'codigoProcedimento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vTuss.CD_TUSS is not null then
          vTemp := vTuss.CD_TUSS;
        else
          vTemp := vcProFat.cd_pro_fat; --senao tiver o relacionamento novo
        end if;
      vCt.codigoProcedimento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdProFat,null);
      vResult := vCt.codigoProcedimento;
    end if;
    --
    -- valorProcedimento--------------------------------
    vCp := 'valorProcedimento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcItem.vl_total_conta;
      vCt.valorProcedimento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,pCdLanc,pCdProFat,null);
      vResult := vCt.valorProcedimento;
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ctm_internacaoDados (   pModo       in varchar2,
                                    pIdMap      in number,
                                    pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                    pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                    vCt         OUT NOCOPY RecInternacaoDados,
                                    pMsg        OUT varchar2,
                                    pReserva    in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	        varchar2(1000);
  nCount        number :=0;
  --
  vTussRel      RecTussRel;
  vTuss         RecTuss;
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if nvl(vcAtendimentoAUX.cd_atendimento,0)<>pCdAtend then
      open cAtendimentoAUX(pCdAtend);
      fetch cAtendimentoAUX into vcAtendimentoAUX;
      close cAtendimentoAUX;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  end if;
  ---------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  ---------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ctm_internacaoDados').tp_utilizacao > 0 then
    --
    -- caraterAtendimento----------------------------------
    vCp := 'caraterAtendimento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
      --vTussRel.tp_atendimento := vcAtendimento.tp_atendimento;
      --vTemp := F_DM(23,pCdAtend,pCdConta,null,null,vTussRel,vTuss,pMsg,null);
      --vTemp := vTuss.CD_TUSS;
      IF vcAtendimento.tp_carater_internacao IS null then
       vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                       vcAtendimento.cd_pro_int,'TP_CARATER_INTERNACAO',vcAtendimento.dt_atendPac);
      END IF;
      IF vTemp IS NULL then
		IF vcAtendimento.tp_carater_internacao in ('U', '2') then
			vTemp := 2;
		else
			vTemp :=1;
		end if;
      END IF;
      vCt.caraterAtendimento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);  -- dm_caraterAtendimento
      vResult := vCt.caraterAtendimento;
    end if;
    --
    -- tipoFaturamento-------------------------------------
    vCp := 'tipoFaturamento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      --FUTURO RELACIONAMENTO COM A TELA (Terminologia 55)
      --vTemp := F_DM(55,null,null,null,null,vTussRel,vTuss,pMsg,null);
      --vTemp := vTuss.CD_TUSS;
      -- regra PROVIS真RIA. Reavaliar e tamb真m definir tipo "Complementar"
        if vcConta.dt_final is null or vcAtendimento.dt_alta is null then
          vTemp := '1'; -- Parcial
        else
          if vcConta.dt_inicio = vcAtendimento.dt_atendimento
             and vcConta.dt_final = vcAtendimento.dt_alta then
            vTemp := '4'; -- Total, 真nica
          elsif vcConta.dt_final = vcAtendimento.dt_alta then
            vTemp := '2'; -- Final, 真ltima conta
          else
            vTemp := '1'; -- Parcial
          end if;
        end if;
      vCt.tipoFaturamento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null); -- dm_tipoFaturamento
      vResult := vCt.tipoFaturamento;
    end if;
    --
    -- dataInicioFaturamento-------------------------------
    vCp := 'dataInicioFaturamento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcConta.dt_inicio;
      vCt.dataInicioFaturamento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vResult := vCt.dataInicioFaturamento;
    end if;
    --
    -- horaInicioFaturamento-------------------------------
    vCp := 'horaInicioFaturamento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcConta.hr_inicio;
      vCt.horaInicioFaturamento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vResult := vCt.horaInicioFaturamento;
    end if;
    --
    -- dataFinalFaturamento--------------------------------
    vCp := 'dataFinalFaturamento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcConta.dt_final;
      vCt.dataFinalFaturamento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vResult := vCt.dataFinalFaturamento;
    end if;
    --
    -- horaFinalFaturamento--------------------------------
    vCp := 'horaFinalFaturamento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcConta.hr_final;
      vCt.horaFinalFaturamento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vResult := vCt.horaFinalFaturamento;
    end if;
    --
    -- tipoInternacao--------------------------------------
    vCp := 'tipoInternacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --FUTURO RELACIONAMENTO COM A TELA (Terminologia 57)
        --vTemp := F_DM(57,null,null,null,null,vTussRel,vTuss,pMsg,null);
        --vTemp := vTuss.CD_TUSS;
        if nvl(vcAprTiss.cd_apr_tiss, 0) = 0 then
          open  cAprTiss(NULL);
          fetch cAprTiss into vcAprTiss;
          close cAprTiss;
        end if;
        if NVL(vcAtendimentoMag.cd_atendimento||vcAtendimentoMag.cd_apr_conta_meio_mag,'XX')<>pCdAtend||vcAprTiss.cd_apr_tiss then
          open  cAtendimentoMag(pCdAtend, vcAprTiss.cd_apr_tiss);
          fetch cAtendimentoMag into vcAtendimentoMag;
          close cAtendimentoMag;
        end if;
        vTemp := vcAtendimentoMag.cd_tip_int_meio_mag;
      vCt.tipoInternacao := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);  -- dm_tipoInternacao
      vResult := vCt.tipoInternacao;
    end if;
    --
    -- regimeInternacao------------------------------------
    vCp := 'regimeInternacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTussRel := null;
        vTussRel.tp_atendimento := vcAtendimento.tp_atendimento_original;
        vTussRel.cd_tip_acom    := vcConta.cd_tip_acom;
        vTemp := F_DM(41,pCdAtend,pCdConta,null,null,vTussRel,vTuss,pMsg,null);
        vTemp := vTuss.CD_TUSS;
        if FNC_CONF('TP_REF_HOSPDIA_RI',pCdConvTmp,null) = 'U' then
          if vcAtendimentoAUX.sn_hospital_dia = 'S' then
            vTemp := '2';
          end if;
        end if;
      vCt.regimeInternacao := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);    -- dm_regimeInternacao
      vResult := vCt.regimeInternacao;
    end if;
    --
    -- DIAGNOSTICO CID-------------------------------------
    vCp := 'diagnostico'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcAtendimento.cd_cid ; --?????
      vCt.diagnostico := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null); -- dm_indicadorAcidente
      vResult := vCt.diagnostico;
    end if;
    --
    -- indicacaoAcidente-----------------------------------
    vCp := 'indicadorAcidente'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      --FUTURO RELACIONAMENTO COM A TELA (Terminologia 36)
      --vTemp := F_DM(36,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
      --vTemp := vTuss.CD_TUSS;
        IF vcAtendimento.tp_acidente_tiss IS null then
           vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                       vcAtendimento.cd_pro_int,'TP_ACIDENTE_TISS',vcAtendimento.dt_atendPac);
        END IF;
        IF vtemp IS NULL THEN
          vTemp := nvl( vcAtendimento.tp_acidente_tiss, '9') ;
        END IF;
      vCt.indicadorAcidente := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null); -- dm_indicadorAcidente
      vResult := vCt.indicadorAcidente;
    end if;
    --
    -- motivoSaida-----------------------------------------
    vCp := 'motivoSaidaInternacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vCt.tipoFaturamento = '1' then -- parcial
          vTemp := '51';    -- parcial, administrativa -- PENDENTE (for真ado ainda)
        else
          vTussRel := null;
          vTussRel.cd_mot_alt := vcAtendimento.cd_mot_alt;
          vTemp := F_DM(39,pCdAtend,pCdConta,null,null,vTussRel,vTuss,pMsg,null);
          vTemp := vTuss.CD_TUSS;
        end if;
      vCt.motivoSaidaInternacao := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);    -- dm_motivoSaidaObito
      vResult := vCt.motivoSaidaInternacao;
    end if;
    --
    -- declaracoes-----------------------------------------
    vCp := 'declaracoes'; vTemp := null;
    if vCp = nvl(pModo,vCp) or tConf(vCp).tp_utilizacao > 0 then
      --
      if vcAtendimento.dt_alta IS NOT NULL AND ( vcConta.dt_final = vcAtendimento.dt_alta ) THEN
        for vcDeclaracoes in cDeclaracoes(pCdAtend,pCdConta,null) LOOP
          --
          nCount := nCount + 1; -- contador de elementos/casos;
          --
          -- declaracaoNascido-------------------------------
          vCp := 'declaracaoNascido';
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            vTemp := vcDeclaracoes.cd_declaracao_nascido_vivo;
            vCt.declaracoes(nCount).declaracaoNascido  := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
            vResult := vCt.declaracoes(nCount).declaracaoNascido;
          end if;
          --
          -- diagnosticoObito--------------------------------
          vCp := 'diagnosticoObito'; vTemp := null;
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            vTemp := vcDeclaracoes.cd_cid_obito;
            vCt.declaracoes(nCount).diagnosticoObito  := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
            vResult := vCt.declaracoes(nCount).diagnosticoObito;
          end if;
          --
          -- declaracaoObito---------------------------------
          vCp := 'declaracaoObito'; vTemp := null;
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            vTemp := vcDeclaracoes.nr_declaracao_obito;
            vCt.declaracoes(nCount).declaracaoObito  := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
            vResult := vCt.declaracoes(nCount).declaracaoObito;
          end if;
          --
          -- indicadorDORN-----------------------------------
          vCp := 'indicadorDORN'; vTemp := null;
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            vTemp := vcDeclaracoes.sn_indicador_DO_RN;
            vCt.declaracoes(nCount).indicadorDORN  := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);  -- dm_simNao
            vResult := vCt.declaracoes(nCount).indicadorDORN;
          end if;
          --
        end loop;
        --
      end if;
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ctm_internacaoDadosSaida (   pModo       in varchar2,
                                         pIdMap      in number,
                                         pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                         pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                         vCt         OUT NOCOPY RecInternacaoDadosSaida,
                                         pMsg        OUT varchar2,
                                         pReserva    in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	        varchar2(1000);
  nCount        number :=0;
  --
  vTussRel      RecTussRel;
  vTuss         RecTuss;
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if nvl(vcAtendimentoAUX.cd_atendimento,0)<>pCdAtend then
      open cAtendimentoAUX(pCdAtend);
      fetch cAtendimentoAUX into vcAtendimentoAUX;
      close cAtendimentoAUX;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  end if;
  ------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  ------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ctm_internacaoDadosSaida').tp_utilizacao > 0 then
    --
    -- DIAGNOSTICO CID----------------------------------
    for i in cCidsSecundarios(vcConta.cd_atendimento) loop
    nCount := nCount + 1;
    vCp := 'diagnostico'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
   -- verificar
   /* if vTemp is null then
        open  cCidsSecundarios( vcConta.cd_atendimento );
        fetch cCidsSecundarios into vcCidsSecundarios;
        close cCidsSecundarios;
        insert into dbamv.tiss_itguia_cid( id, id_pai, tp_cid, cd_cid, ds_cid )
          values( dbamv.seq_tiss_guia.nextval, vGuia.id, substr(vc.tp_cid,1,100), substr(vc.cd_cid,1,100), substr(vc.ds_cid,1,70) ); */
        vTemp := i.cd_cid ;
    --vTemp := 'X' ; --?????
    --end if;
    --vCt.diagnostico(nCount).CidSegundario := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null); -- dm_indicadorAcidente
      vCt.diagnostico(nCount).TP_CID := F_ST(tConf(vCp).tp_dado,i.TP_CID,NULL,NULL,NULL,NULL,NULL,NULL); -- dm_indicadorAcidente
      vCt.diagnostico(nCount).CD_CID := F_ST(tConf(vCp).tp_dado,i.CD_CID,null,NULL,NULL,NULL,NULL,NULL); -- dm_indicadorAcidente
      vCt.diagnostico(nCount).DS_CID := F_ST(tConf(vCp).tp_dado,i.DS_CID,null,NULL,NULL,NULL,NULL,NULL); -- dm_indicadorAcidente
      vResult := vCt.diagnostico(nCount).CD_CID;
    end if;
    --
    end loop;
    /* TRECHO alocado provisoriamente em F_CTM_INTERNACAODADOS()
    -- indicacaoAcidente--------------------------------
    -- motivoSaida--------------------------------------
    */
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissItGuiaDecl (   pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.tiss_itguia_declaracao%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2 IS
BEGIN
  --
  select dbamv.seq_tiss_guia.nextval into vRg.id from sys.dual;
  --
  insert into dbamv.tiss_itguia_declaracao
 (   id, id_pai, cd_decl_nascidos_vivos, cd_cid_obito, cd_declaracao_obito, cd_indicador_do_rn
  )
    values
 (  vRg.id, vRg.id_pai, vRg.cd_decl_nascidos_vivos, vRg.cd_cid_obito , vRg.cd_declaracao_obito , vRg.cd_indicador_do_rn
  );
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_ITGUIA_DECLARACAO:'||SQLERRM;
      RETURN null;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissItGuiaCid (   pModo           in varchar2,
                                   vRg             in OUT NOCOPY dbamv.tiss_itguia_cid%rowtype,
                                   pMsg            OUT varchar2,
                                   pReserva        in varchar2) return varchar2 IS
BEGIN
  select dbamv.seq_tiss_guia.nextval into vRg.id from sys.dual;
  --
  insert into dbamv.tiss_itguia_cid
 (   id, id_pai, tp_cid, cd_cid, ds_cid
  )
    values
 (  vRg.id, vRg.id_pai, vRg.tp_cid, vRg.cd_cid , vRg.ds_cid
  );
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_ITGUIA_CID:'||SQLERRM;
      RETURN null;
  --
END;
--
--==================================================
FUNCTION  F_GERA_ENVIO( pModo           in varchar2,
                        pIdMap          in number,
                        pCdRemessa      in dbamv.remessa_fatura.cd_remessa%type,
                        pCdRemessaGlosa in dbamv.remessa_glosa.cd_remessa_glosa%type,
                        pTpGeracao      in varchar2, -- G = Gera normal(caso n真o exista) ou retorna ID's se j真 existentes / R = Regera todas e retorna ID's gerados
                        pMsg            OUT varchar2,
                        pReserva        in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vCp	            varchar2(1000);
  pCdConv           dbamv.convenio.cd_convenio%type;
  vcObtemMsgEnvio   cObtemMsgEnvio%rowtype;
  vcContaTotTiss    cContaTotTiss%rowtype;
  vcGuiasGeradasAux cGuiasGeradas%rowtype;
  vCtMensagem       RecMensagemLote;
  pnQtdGuias        number;
  vResult           varchar2(2000);
  vIdGuias          varchar2(2000);
  vcTiposGuiaLote   cTiposGuiaLote%rowtype;
  vcTissGuiasCta    cTissGuiasCta%rowtype;
  vIdentContrOrigem varchar2(100);

  --SUP-79153 - inicio
  CURSOR cRemTissGuiaAtual( nCdRemessa in number ) IS
    SELECT tg.cd_remessa
      FROM dbamv.tiss_guia tg
     WHERE tg.cd_remessa IS NOT NULL
       AND tg.cd_reg_fat IN ( SELECT cd_reg_fat FROM dbamv.reg_fat WHERE cd_remessa = nCdRemessa )
       AND tg.cd_remessa <> nCdRemessa
     UNION ALL
    SELECT tg.cd_remessa
      FROM dbamv.tiss_guia tg
     WHERE tg.cd_remessa IS NOT NULL
       AND tg.cd_reg_amb IN ( SELECT cd_reg_amb FROM dbamv.reg_amb WHERE cd_remessa = nCdRemessa )
       AND tg.cd_remessa <> nCdRemessa;

  vcRemTissGuiaAtual cRemTissGuiaAtual%ROWTYPE;
  --SUP-79153 - fim

BEGIN
  -- 真 faturamento
  if pCdRemessa is not null then
    --
    open  cRemessa(pCdRemessa,null);
    fetch cRemessa into vcRemessa;
    close cRemessa;
    --
    if vcConv.cd_convenio<>nvl(vcRemessa.cd_convenio,0) then
      open  cConv(vcRemessa.cd_convenio);
      fetch cConv into vcConv;
      close cConv;
    end if;
    -- << ? ? ? ?   aqui validar protocolo/Vers真o m真nima do Tiss.,
    dbamv.pkg_ffcv_tiss_v4.f_le_conf(1001,vcConv.cd_convenio,'Reler',null); -- Ler configura真真es
    --
    -- s真 gera/regera se remessa fechada
    if nvl(vcRemessa.sn_fechada,'N') = 'S' then
      --
      vcObtemMsgEnvio := null;
      open  cObtemMsgEnvio(pCdRemessa,null, null);
      fetch cObtemMsgEnvio into vcObtemMsgEnvio;
      close cObtemMsgEnvio;

	  --FATURCONV-7309 - inicio
      if vcSnFatDistribuido IS NULL then
        OPEN  cSnFatDistribuido;
        FETCH cSnFatDistribuido INTO vcSnFatDistribuido;
        CLOSE cSnFatDistribuido;
      end if;

      IF Nvl(vcSnFatDistribuido,'N') = 'N' THEN  --SUP-187463 inicio
        --SUP-79153 - inicio
        vcRemTissGuiaAtual := null;
        open  cRemTissGuiaAtual(pCdRemessa);
        fetch cRemTissGuiaAtual into vcRemTissGuiaAtual;
        close cRemTissGuiaAtual;

        IF vcRemTissGuiaAtual.cd_remessa IS NOT NULL THEN
          DELETE dbamv.tiss_guia WHERE id IN (
                                              SELECT tg.id
                                                FROM dbamv.tiss_guia tg
                                              WHERE tg.cd_remessa IS NOT NULL
                                                AND tg.cd_reg_fat IN ( SELECT cd_reg_fat FROM dbamv.reg_fat WHERE cd_remessa = pCdRemessa )
                                                AND tg.cd_remessa <> pCdRemessa
                                              UNION ALL
                                              SELECT tg.id
                                                FROM dbamv.tiss_guia tg
                                              WHERE tg.cd_remessa IS NOT NULL
                                                AND tg.cd_reg_amb IN ( SELECT cd_reg_amb FROM dbamv.reg_amb WHERE cd_remessa = pCdRemessa )
                                                AND tg.cd_remessa <> pCdRemessa
                                              );
          COMMIT;
        END IF;
      END if; --SUP-187463 fim

      --SUP-79153 - fim
      --
      -- Se op真真o de Regerar e houver gera真真o anterior, ent真o apaga Lotes anteriores (lotes e mensagens)
      if nvl(pTpGeracao,'G')='R' and vcObtemMsgEnvio.id is not null then
        vTemp   := F_apaga_tiss('APAGA_LOTE_ENVIO',null,null,pCdRemessa,null,pMsg,null); -- apaga todos lotes da remessa
      else
        -- Se n真o for Regerar e houver gera真真o anterior, aborta avisando.
        if vcObtemMsgEnvio.id is not null then
          pMsg := 'O Xml de Faturamento j真 foi gerado anteriormente!';
        end if;
      end if;
    else
      pMsg := 'Remessa deve estar corretamente fechada. Verifique e tente novamente.';
    end if;
    --
    -- Gera真真o/Confer真ncia de valores
    if pMsg is null then
      --
      -- Lista todas as contas da remessa..
      -- Se par真metro exigir regera真真o, ent真o ele regera as guias de todas contas da remessa;
      -- Tamb真m confere o valor das contas e da remessa;
      for vcRemessaCtas in cRemessaCtas( pCdRemessa ) loop
        --
        vcTissGuiasCta := null;
        open  cTissGuiasCta(vcRemessaCtas.tp_conta,vcRemessaCtas.cd_atendimento, vcRemessaCtas.cd_conta,null,null);
        fetch cTissGuiasCta into vcTissGuiasCta;
        close cTissGuiasCta;
        --
        if pTpGeracao = 'R' or (pTpGeracao = 'G' and vcTissGuiasCta.id is null) then
          --
          vIdGuias := F_GERA_TISS(null,null,vcRemessaCtas.cd_Atendimento,vcRemessaCtas.cd_conta,'R',pMsg,null);
          if pMsg is not null then
            EXIT;
          end if;
          --
        end if;
        --
        -- VERIFICAR TOTAIS das guias recem-geradas do Atendimento
        vcContaTotTiss := null;
        --
        open  cContaTotTiss( vcRemessaCtas.tp_conta,vcRemessaCtas.cd_Atendimento,vcRemessaCtas.cd_conta,'E');
        fetch cContaTotTiss into vcContaTotTiss;
        close cContaTotTiss;
        if nvl( vcContaTotTiss.vl_total_conta, 0 ) <> nvl( vcRemessaCtas.vl_total_conta, 0)
          and nvl(instr(dbamv.fnc_ffcv_conf_tiss('PARAM_ZERA_SERVICOS_TISS',null,null),'@'||lpad(vcConv.cd_convenio,3,'0')),0)=0 then
          if length(nvl(pMsg,0))<10 then
            pMsg := 'ATENCAO:  O Lote de XML-TISS n真o foi gerado pois as guias TISS das contas abaixo apresentam inconsist真ncias.'||chr(10)||
                    'Isto pode ser decorr真ncia de altera真真o de Configura真真o ou Auditoria.'||chr(10)||chr(10)||
                    'SOLUCAO:  Na tela de contas, regere as guias TISS dos casos listados.'||chr(10)||chr(10)||
                    '-----------------------------------------------------';
          end if;
          --
          if length(nvl(pMsg,0))+120 < 4000 then -- acrescenta mais dados, se couber no limite de 4000
            pMsg :=   pMsg||chr(10)||'Atend/Cta '||vcRemessaCtas.cd_atendimento||'/'|| vcRemessaCtas.cd_conta
                      ||'('|| vcRemessaCtas.tp_conta||')'||' diverge em R$'||to_number(nvl(vcRemessaCtas.vl_total_conta,0) - nvl(vcContaTotTiss.vl_total_conta,0))
                      ||' em rela真真o ao faturamento.';
          end if;
        end if;
        --
      end loop;
      --
      -- Gerar Mensagem, Lote e associar Guias Geradas no Lote;
      if pMsg is null then
        --
        pnQtdGuias := 1;
        --
        for vcGuiasGeradas in cGuiasGeradas( pCdRemessa, null, null ) loop
          --
          -- Quebra de Lotes, os CRIT真RIOS:
          --   - Por tipo de guia Diferente
          --   - OU por qtd.guias no Lote
          --   - OU por identifica真真o de prestador Executante Credenciado diferente para SP e CO (espec真fico configurado)
          if vcGuiasGeradas.nm_xml <> nvl(vcGuiasGeradasAux.nm_xml, 'XXX')
            OR nvl(pnQtdGuias, 1) > fnc_conf('NR_LIMITE_GUIAS',vcConv.cd_convenio,null)
            or nvl(vcGuiasGeradas.ident_contr_exe_quebra,'X')<>NVL(vcGuiasGeradasAux.ident_contr_exe_quebra,'X')
            OR (
                vcGuiasGeradas.tp_pagamento_guia <> nvl(vcGuiasGeradasAux.tp_pagamento_guia, 'XXX')
                AND (  (substr(vcGuiasGeradas.nm_xml,1,6)='guiaSP' and nvl(fnc_conf('TP_QUEBRA_LOTE_CRED_SP_CO',vcConv.cd_convenio,null),'1')<>'3')
                      OR substr(vcGuiasGeradas.nm_xml,1,6)<>'guiaSP'  )
                )
            --
          then
            -- Nova Mensagem e Lote
            pnQtdGuias := 1;
            --
			-- Oswaldo in真cio 210325
			--Alterado no cursor o coluna ident_contr_exe_quebra para considerar os tr真s poss真veis campos do prestador executante (cd_cgc_exe,cd_cpf_exe,cd_operadora_exe).
			--Anteriormente era considerado apenas o cd_operadora_exe (ALTERA真真O APENAS NO CURSOR).
			-- Oswaldo fim 210325
            if nvl(fnc_conf('TP_QUEBRA_LOTE_CRED_SP_CO',vcConv.cd_convenio,null),'1')='2' and vcGuiasGeradas.ident_contr_exe_quebra is not null then
              vIdentContrOrigem := '#'||vcGuiasGeradas.ident_contr_exe_quebra;
            end if;
            --
            vTpTransacao      := 'ENVIO_LOTE_GUIAS';      -- vari真vel globais para apoio na montagem do cabe真alho
            vTpGuiasTransacao := vcGuiasGeradas.tp_guia;  -- vari真vel globais para apoio na montagem do cabe真alho
            --
            vTemp := F_mensagemTISS(null,1001,'ENVIO_LOTE_GUIAS',vcRemessa.cd_multi_empresa,vcRemessa.cd_convenio,pCdRemessa,vCtMensagem,pMsg,vcGuiasGeradas.tp_pagamento_guia||vIdentContrOrigem);
            if pMsg is not null then
              EXIT;
            end if;
            --
            vResult  :=  vResult||lpad(vCtMensagem.idMensagem,20,'0')||',';
            --
          end if;
          --
          update dbamv.tiss_guia set id_pai = vCtMensagem.idLote where id = vcGuiasGeradas.id;
          --
          vcGuiasGeradasAux := vcGuiasGeradas;
          --
          pnQtdGuias := pnQtdGuias + 1;
          --
        end loop;
        --
        -- Ap真s gerar um novo lote, ele atualiza a TISS_MENSAGEM (anterior no caso) com informa真真es sobre os tipos de guias do Lote
        if vResult is not null then
          for i in 1..(length(vResult)/21) loop
            vcTiposGuiaLote := null;
            open  cTiposGuiaLote(to_number(substr(vResult,i*21-20,20)),null);
            fetch cTiposGuiaLote into vcTiposGuiaLote;
            close cTiposGuiaLote;
            if vcTiposGuiaLote.id_pai is not null then
              update dbamv.tiss_mensagem
                set tp_mensagem_tiss = vcTiposGuiaLote.tp_guia||','||'?'||','||vcTiposGuiaLote.nm_contratado_exe
                where id = to_number(substr(vResult,i*21-20,20));
            end if;
          end loop;
        end if;
        --
      end if;
      --
    end if;
    --
  end if; -- faturamento
  --
  if pMsg is null then
    COMMIT;
    RETURN vResult;
  else
    ROLLBACK;
    RETURN null;
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA :'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
function f_cancela_envio  ( pnCdRemessa                 in number,       -- 1真 Op真真o  ou
                            pnCdRemessaGlosa            in number,       -- 2真 Op真真o
                            --
                            pnReserva                   in varchar2,
                            --
                            pvMsgErro                   out varchar2) return varchar is

  -- Vari真vel de controle para verificar se existem dados a serem extra真dos pelo cursor
  bCancelEfetuado      boolean := false;
  --
  --OP 40093 - pda 837587 - chamada do cancelamento pelo webservice lote a lote - Inicio
  --cursor para verificar se foi cancelado no convenio, caso tenha dados, significa que foi cancelado com sucesso
  CURSOR cVerificaCancelamentoConv(vIdRetornoCanc varchar2) IS -- Oswaldo BH
    SELECT ds_status_cancelamento
      FROM dbamv.TISS_RETORNO_CANCELA_itGUIA
     WHERE id_pai IN ( SELECT id
                         FROM dbamv.TISS_RETORNO_CANCELA_GUIA
                        WHERE id_pai IN ( SELECT id
                                            FROM dbamv.TISS_MENSAGEM
                                           WHERE id_mensagem_envio = To_Number(vIdRetornoCanc)) );-- Oswaldo BH
  --
  vcVerificaCancelamentoConv  cVerificaCancelamentoConv%ROWTYPE;
  bCancelProtocoloConv        boolean := false;
  vIdEnvio                    VARCHAR2(100);
  vIdRetornoCanc                VARCHAR2(100);
  --
begin

  vIdEnvio := NULL;
  vIdRetornoCanc := pnReserva;

  if instr(pnReserva,'#')>0 then
	  vIdEnvio := substr(pnReserva,instr(pnReserva,'#')+1);
    vIdRetornoCanc := substr(pnReserva,1,instr(pnReserva,'#')-1);
  end if;


  -- Condi真真es normais daqui pra baixo
  for vcObtemMsgEnvio in cObtemMsgEnvio(pnCdRemessa,pnCdRemessaGlosa, vIdEnvio) loop
    --
    bCancelProtocoloConv := FALSE; --OP 40093 - pda 837587
    --
    if pnReserva = 'VERIFICA' then  -- Condi真真o especial (acionamento externo, ex: tela de manuten真真o de remessa)
      pvMsgErro := 'ATEN真真O: H真 lotes de XML-Tiss gerados. Cancele-os antes de fazer manuten真真o na Remessa.';
      return 'ERRO'; -- N真o cancela os Lotes, mas d真 mensagem para ser cancelada pela tela.
    end if;
    --
    --OP 40093 - pda 837587 - chamada do cancelamento pelo webservice lote a lote - Inicio
    IF pnCdRemessa IS NOT NULL THEN
      vcVerificaCancelamentoConv := NULL;
      OPEN  cVerificaCancelamentoConv(vIdRetornoCanc); -- Oswaldo BH
      FETCH cVerificaCancelamentoConv INTO vcVerificaCancelamentoConv;
      CLOSE cVerificaCancelamentoConv;
      --
      IF Nvl(vcVerificaCancelamentoConv.ds_status_cancelamento,'0') = '1' AND -- verificar outros status de acordo com a terminologia 46 da TUSS
         vcObtemMsgEnvio.nr_protocolo_retorno is not null
      THEN
          Update dbamv.tiss_mensagem
             SET nr_protocolo_retorno = null
           where ID = vcObtemMsgEnvio.id;
           --
           bCancelProtocoloConv := TRUE; --apagou com sucesso
           --
          --pvMsgErro := 'N真mero de Protocolo n真o pode ser removido, por favor entrar em contato com o conv真nio.' || SQLERRM;
          --return 'ERRO';
      END IF;
    END IF;
    --OP 40093 - pda 837587 - chamada do cancelamento pelo webservice lote a lote - Fim
    --
  --if vcObtemMsgEnvio.nr_protocolo_retorno is not null THEN
    if vcObtemMsgEnvio.nr_protocolo_retorno is not null AND bCancelProtocoloConv = FALSE THEN --OP 40093 - pda 837587 - variavel para setar que apagou o protocolo
      ROLLBACK; --OP 40093 - pda 837587 - caso o usuario cancele um dos lotes que nao tem protocolo e o que tem nao tem o OK do convenio
      pvMsgErro := 'Cancelamento n真o efetuado !! Um ou mais Lotes desta Remessa/Remessa de Glosa j真 confirmados no Conv真nio!';
      return 'ERRO';
    end if;

    if vcObtemMsgEnvio.id_envio_posterior is not null then
      pvMsgErro := 'Cancelamento n真o efetuado!! H真 reapresenta真真o posterior desta remessa.';
      return 'ERRO';
    end if;
    --
    bCancelEfetuado:= true;
    --
    if vcObtemMsgEnvio.tp_transacao = 'RECURSO_GLOSA' then
      -- Apagando todos os id_it_envio da tabela de glosas relacionados as tabelas de itens da guia
      update dbamv.glosas
         set id_it_envio = null
       where id_it_envio in (select id
                               from dbamv.tiss_itguia
                              where id_pai in (select tg.id
                                                 from dbamv.tiss_guia tg
                                                where tg.id_pai = nvl(vcObtemMsgEnvio.id_tlg,vcObtemMsgEnvio.id_tl))
                             union
                             select id
                               from dbamv.tiss_itguia_out
                              where id_pai in (select tg.id
                                                 from dbamv.tiss_guia tg
                                                where tg.id_pai = nvl(vcObtemMsgEnvio.id_tlg,vcObtemMsgEnvio.id_tl))
                             union
                             select id
                               from dbamv.tiss_itguia_op
                              where id_pai in (select tg.id
                                                 from dbamv.tiss_guia tg
                                                where tg.id_pai = nvl(vcObtemMsgEnvio.id_tlg,vcObtemMsgEnvio.id_tl)));
      -- Excluindo os itens das guias.
      delete dbamv.tiss_itguia
       where id_pai in (select tg.id
                          from dbamv.tiss_guia tg
                         where tg.id_pai = nvl(vcObtemMsgEnvio.id_tlg,vcObtemMsgEnvio.id_tl));
      --
      delete dbamv.tiss_itguia_out
       where id_pai in (select tg.id
                          from dbamv.tiss_guia tg
                         where tg.id_pai = nvl(vcObtemMsgEnvio.id_tlg,vcObtemMsgEnvio.id_tl));
      --
      delete dbamv.tiss_itguia_op
       where id_pai in (select tg.id
                          from dbamv.tiss_guia tg
                         where tg.id_pai = nvl(vcObtemMsgEnvio.id_tlg,vcObtemMsgEnvio.id_tl));
      --
      delete dbamv.tiss_itguia_obito
       where id_pai in (select tg.id
                          from dbamv.tiss_guia tg
                         where tg.id_pai = nvl(vcObtemMsgEnvio.id_tlg,vcObtemMsgEnvio.id_tl));
      --
      delete dbamv.tiss_itguia_cid
       where id_pai in (select tg.id
                          from dbamv.tiss_guia tg
                         where tg.id_pai = nvl(vcObtemMsgEnvio.id_tlg,vcObtemMsgEnvio.id_tl));
      --
      delete dbamv.tiss_itguia_declaracao
       where id_pai in (select tg.id
                          from dbamv.tiss_guia tg
                         where tg.id_pai = nvl(vcObtemMsgEnvio.id_tlg,vcObtemMsgEnvio.id_tl));
      -- Fim da exclus真o dos itens
      --
      delete dbamv.tiss_guia
       where id_pai = nvl(vcObtemMsgEnvio.id_tlg,vcObtemMsgEnvio.id_tl);
      --
    else    -- Envio s真 se apaga individualmente pela fnc_apaga_tiss().
      update dbamv.tiss_guia
         set id_pai = NULL
       where id_pai = nvl(vcObtemMsgEnvio.id_tlg,vcObtemMsgEnvio.id_tl);
      --
    end if;
    --
    delete dbamv.tiss_lote_guia
     where id = vcObtemMsgEnvio.id_tlg;
    --
    delete dbamv.tiss_lote
     where id = vcObtemMsgEnvio.id_tl;
    --
    delete dbamv.tiss_log
     where id_mensagem = vcObtemMsgEnvio.id;
    --
    delete dbamv.tiss_mensagem
     where id = vcObtemMsgEnvio.id;
      --
  end loop;
  --
  if bCancelEfetuado = TRUE then
    COMMIT;
  end if;
  --
  return 'OK';
  --
end;
--
--==================================================
FUNCTION  F_gravaTissMensagem ( pModo           in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_mensagem%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
BEGIN
  if pModo ='INSERE' THEN
    --
    if vRg.tp_transacao = 'ENVIO_LOTE_GUIAS' then
      vRg.NM_XML := 'Envio Lote';
    elsif vRg.tp_transacao = 'SOLICITACAO_PROCEDIMENTOS' then
      vRg.NM_XML := 'Solicitacao Autorizacao';
    elsif vRg.tp_transacao = 'SOLICITACAO_OPME' then
      vRg.NM_XML := 'Solicitacao Opme';
    elsif vRg.tp_transacao = 'SOLICITACAO_QUIMIO' then
      vRg.NM_XML := 'Solicitacao Quimio';
    elsif vRg.tp_transacao = 'SOLICITACAO_RADIO' then
      vRg.NM_XML := 'Solicitacao Radio';
    elsif vRg.tp_transacao = 'SOLICITACAO_INTERNACAO' then
      vRg.NM_XML := 'Solicitacao Internacao';
    elsif vRg.tp_transacao = 'SOLICITACAO_PRORROGACAO' then
      vRg.NM_XML := 'Solicitacao Prorrogacao';
    elsif vRg.tp_transacao = 'VERIFICA_ELEGIBILIDADE' then
      vRg.NM_XML := 'Solicitacao Elegibilidade';
    elsif vRg.tp_transacao = 'SOLICITA_STATUS_AUTORIZACAO' then
      vRg.NM_XML := 'Solicitacao Status Autorizacao';
    elsif vRg.tp_transacao = 'CANCELA_GUIA' then
      vRg.NM_XML := 'Solicitacao Cancelamento Guias';
    elsif vRg.tp_transacao = 'SOLIC_STATUS_PROTOCOLO' then
      vRg.NM_XML := 'Solicitacao Status Protocolo';
    elsif vRg.tp_transacao = 'RECURSO_GLOSA' then
      vRg.NM_XML := 'Envio Lote Recurso';
    elsif vRg.tp_transacao = 'COMUNICACAO_BENEFICIARIO' then
      vRg.NM_XML := 'Comunicacao Beneficiario';
    end if;
    --
    select dbamv.seq_tiss_mensagem.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.tiss_mensagem
    ( id,tp_transacao,dt_transacao,hr_transacao,cd_seq_transacao,cd_origem,cd_destino,nr_registro_ans_origem,nr_registro_ans_destino,cd_versao,
      dt_gerou_xml,dt_retorno,nr_protocolo_retorno,cd_status_protocolo,ds_msg_erro,nr_lote,nm_xml,nr_documento,cd_convenio,tp_mensagem_tiss,
      cd_motivo_glosa,ds_motivo_glosa,id_mensagem_envio,cd_cgc_origem,cd_cpf_origem,cd_cgc_destino,cd_cpf_destino,ds_motivo_cancelamento,
      cd_usuario_cancelou,dt_cancelamento,dt_enviou_xml,cd_status,id_cancelamento,ds_hash,id_mensagem_origem,sn_retorno,nm_aplicativo,
      ds_versao_aplicativo,nm_fabricante_aplicativo
    )
        values
    ( vRg.id,vRg.tp_transacao,vRg.dt_transacao,vRg.hr_transacao,vRg.cd_seq_transacao,vRg.cd_origem,vRg.cd_destino,vRg.nr_registro_ans_origem,vRg.nr_registro_ans_destino,vRg.cd_versao,
      vRg.dt_gerou_xml,vRg.dt_retorno,vRg.nr_protocolo_retorno,vRg.cd_status_protocolo,vRg.ds_msg_erro,vRg.nr_lote,vRg.nm_xml,vRg.nr_documento,vRg.cd_convenio,vRg.tp_mensagem_tiss,
      vRg.cd_motivo_glosa,vRg.ds_motivo_glosa,vRg.id_mensagem_envio,vRg.cd_cgc_origem,vRg.cd_cpf_origem,vRg.cd_cgc_destino,vRg.cd_cpf_destino,vRg.ds_motivo_cancelamento,
      vRg.cd_usuario_cancelou,vRg.dt_cancelamento,vRg.dt_enviou_xml,vRg.cd_status,vRg.id_cancelamento,vRg.ds_hash,vRg.id_mensagem_origem,vRg.sn_retorno,vRg.nm_aplicativo,
      vRg.ds_versao_aplicativo,vRg.nm_fabricante_aplicativo
    );
    --
  elsif pModo = 'ATUALIZA' then
    --
    Update dbamv.tiss_mensagem SET
        CD_STATUS   = vRg.CD_STATUS,
        NR_LOTE     = vRg.NR_LOTE
      where id = vRg.id;
    --
  end if;

  RETURN LPAD(vRg.id,20,'0')||',';
  --
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar '||vRg.NM_XML||'. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_MENSAGEM:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissLote ( pModo           in varchar2,
                            vRg             in OUT NOCOPY dbamv.tiss_lote%rowtype,
                            pMsg            OUT varchar2,
                            pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
  --
BEGIN
  --
  select dbamv.seq_tiss_guia.nextval into vRg.id from sys.dual;
  --
  insert into dbamv.tiss_lote
 ( id,id_pai,nr_lote )
    values
 ( vRg.id,vRg.id_pai,vRg.nr_lote);
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar Lote. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_LOTE:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
function FNC_CONF(  pChave      in varchar2,
                    pCdConv     in number,
                    pReserva    in varchar2) return  varchar2 is
    --
    Cursor cConfChave(pnCdProto in number) is
        select DISTINCT  es.cd_id_estrutura_srv
                from dbamv.estrutura_srv es,
                     dbamv.config_proto  cp
                where ( es.ds_opcoes_condicao1 like '<'||pChave||'#%' or
                        es.ds_opcoes_condicao2 like '<'||pChave||'#%' or
                        es.ds_opcoes_condicao3 like '<'||pChave||'#%' )
                  AND es.cd_id_estrutura_srv>999
                  and cp.cd_proto = pnCdProto
                  and cp.cd_id_estrutura_srv = es.cd_id_estrutura_srv;
    --
    cursor cDadosConv(pnCdConv in number) is
      select c.nr_registro_operadora_ans
           , cct.cd_versao_tiss
           , t.cd_proto
        from dbamv.convenio c
            ,dbamv.convenio_conf_tiss cct
            ,dbamv.tiss_versao t
       where c.cd_convenio      = pnCdConv
         and cct.cd_convenio(+) = c.cd_convenio
         and t.cd_versao_tiss   = cct.cd_versao_tiss;
    --
    pcDadosConv  cDadosConv%rowtype;
    --
    vIdMap      number;
    pCdConvTmp  dbamv.convenio.cd_convenio%type;
begin
  --
  pCdConvTmp := pCdConv;
  if pCdConvTmp is null and pReserva is not null then -- caso de n真o haver conv真nio, ent真o recebe pReserva = '8888888888#9999999999' sendo atendimento+#+conta
    if substr(pReserva,1,10)<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(substr(pReserva,1,10));
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if substr(pReserva,12,10)<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(substr(pReserva,12,10),vcAtendimento.cd_atendimento,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    pCdConvTmp := nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  end if;

  if NOT tConfChave.exists(pChave) then
        pcDadosConv := null;
    open  cDadosConv(pCdConvTmp);
    fetch cDadosConv into pcDadosConv;
    close cDadosConv;
    --
    open  cConfChave(pcDadosConv.cd_proto);
    fetch cConfChave into vIdMap;
    close cConfChave;
    if vIdMap is NOT null then -- achou a chave buscada em uma das 3 op真真es, retorna ID da linha da configura真真o
      F_le_conf(vIdMap,pCdConvTmp,NULL,NULL); -- l真 as configura真真es do ID encontrado e afiliados se houver
    elsif pChave in ('NM_APLICATIVO','DS_VERSAO_APLICATIVO','NM_FABRICANTE_APLICATIVO') then -- excess真o, vers真o do sistema 真 partir de Constantes da Spec
      tConfChave('NM_APLICATIVO') := vNmAplicativo; tConfChave('DS_VERSAO_APLICATIVO') := vDsVersao_aplicativo; tConfChave('NM_FABRICANTE_APLICATIVO') := vNmFabricante_aplicativo;
    end if;
  end if;
  --
  if tConfChave.exists(pChave) then
    RETURN tConfChave(pChave);  -- retorna o valor da configura真真o (carregado por F_le_conf())
  else
    RETURN NULL; -- estudar
  end if;
  --
end;
--
--==================================================
function F_ST(  pChave      in varchar2,
                pValor      in varchar2,
                pCpo        in varchar2,
				par1		in varchar2,
				par2		in varchar2,
				par3		in varchar2,
				par4		in varchar2,
				par5		in varchar2) return  varchar2 is
    --
    nTamMax     number;
    nInteiro    number;
    nDecimal    number;
    pValorTemp  varchar2(4000);
    vResult     varchar2(4000);
    pChaveTemp  varchar2(100);
    vInconsistencia VARCHAR2(1000);
    pChaveOrig  VARCHAR2(100);
begin
  --
  pValorTemp := pValor;
  pChaveTemp := pChave;
  if pChaveTemp is null and pCpo is not null then
    pChaveTemp := tConf(pCpo).tp_dado;
  end if;
  pChaveOrig  := pChaveTemp;
  --
  -- TEM VALOR FIXO ?
  IF pCpo IS NOT NULL THEN
  if tConf(pCpo).DS_VALOR_FIXO is not null and  tConf(pCpo).TP_PREENCHIMENTO = 'F' then
  	pValorTemp := tConf(pCpo).DS_VALOR_FIXO;
  END IF;
  END IF;
  --
  FOR i in 1..2 LOOP
    --
    pValorTemp := replace(replace(replace(replace(
                    Translate( pValorTemp,'真真真真真真真真真真真真真真真真真真真真真真真真真真','CAOAEIOUAEIOUcaoaeiouaeiou')
                        , '>', ' maior '), '<', ' menor '), '---', ' - '), chr(10), ' ');
    --
    if instr(pChaveTemp,'st_texto')>0 and pValorTemp is NOT null then        -- Tipos TEXTO (tamanhos variados)
      --
      nTamMax := substr(pChaveTemp,9);
      if length(pValorTemp)>nTamMax then       -- se tamanho excede m真ximo, trunca;
        vResult := substr(pValorTemp,1,nTamMax);
      else
        vResult := pValorTemp;
      end if;
      --
    elsif (instr(pChaveTemp,'st_numerico')>0
        or pChaveTemp in ('st_registroANS','st_CNPJ','st_CPF')) and pValorTemp is NOT null then  -- Tipos NUM真RICO(tamanhos variados) e mais tipos
      --
      if instr(pChaveTemp,'st_numerico')>0 then
        nTamMax := substr(pChaveTemp,12);
      elsif pChaveTemp = 'st_registroANS' then
        nTamMax := 6;
      elsif pChaveTemp = 'st_CNPJ' then
        nTamMax := 14;
      elsif pChaveTemp = 'st_CPF' then
        nTamMax := 11;
      end if;
      vResult := to_number(pValorTemp);
      if length(vResult)>nTamMax then                          -- se tamanho excede m真ximo, retorna estouro de m真scara;
        vResult := substr('********************',1,nTamMax);
        vInconsistencia := '- valor excede o tamanho na informa真真o >'||pCpo||'<, valor gerado = '||pValorTemp||' em '||SubStr(tConf(pCpo).ds_bloco,5);
      elsif length(vResult)<nTamMax then                       -- se tamanho menor que m真ximo, preenche com Zeros;
        vResult := lpad(to_number(vResult),nTamMax,'0');
      end if;
      --
    elsif instr(pChaveTemp,'st_decimal')>0 and pValorTemp is NOT null then   -- Tipos DECIMAL (tamanhos variados)
      --
      nInteiro := substr(pChaveTemp,11,(instr(pChaveTemp,'-')-11));
      nDecimal := substr(pChaveTemp,instr(pChaveTemp,'-')+1);
      nTamMax  := nvl(nInteiro,0)+nvl(nDecimal,0)+1;
      vResult := to_number(pValorTemp);
      if length(trunc(vResult))>nInteiro then                                             -- se inteiro excede m真ximo, retorna estouro de m真scara;
        vResult := substr('********************',1,nInteiro+nDecimal+1);
        vInconsistencia := '- valor excede o tamanho na informa真真o >'||pCpo||'<, valor gerado = '||pValorTemp||' em '||SubStr(tConf(pCpo).ds_bloco,5);
      else
        vResult := trunc(vResult,nDecimal);                                               -- trunca decimais definidas
        if mod(vResult,1)<>0 and (length(mod(vResult,1))-1)<nDecimal then                 -- se tiver decimais e for menor que definido, acrescenta decimais
          vResult := vResult||substr('0000000000',1,nDecimal-(length(mod(vResult,1))-1));
        end if;
        if mod(vResult,1)=0 and nDecimal<>4 then --                                       -- se n真o tiver decimais, acrescenta zeros decimais (exceto qtd.idetificada por 4 decimais)
          vResult := vResult||'.'||substr('0000000000',1,nDecimal);
        end if;
        vResult := replace( vResult, ',','.');
        if substr(vResult,1,1)='.' then                                                   -- se n真o tem inteiro, coloca '0'
          vResult := '0'||vResult;
        end if;
      end if;
      --
    elsif pChaveTemp = 'st_competencia' and pValorTemp is NOT null then   -- Tipo COMPETENCIA
      --
      nTamMax := 6;   -- esperado formato 'yyyymm'
      vResult := to_number(pValorTemp);
      if length(pValorTemp)<>nTamMax or substr(pValorTemp,5,2)<'01' or substr(pValorTemp,5,2)>'12' then
        vResult := '******';    -- se tamanho diferente do previsto ou m真ses inconsist真ncias, retorna estouro de m真scara;
        vInconsistencia := '- excede o tamanho ou formato ano/mes errado na informa真真o >'||pCpo||'<, valor gerado = '||pValorTemp||' em '||SubStr(tConf(pCpo).ds_bloco,5);
      end if;
      --
    elsif pChaveTemp = 'st_data' and pValorTemp is NOT null then   -- Tipo DATA
      --
      nTamMax := 10;  -- esperado formato 'yyyy-mm-dd'
      vResult := to_number(substr(pValorTemp,1,4)); -- confere se ano 真 num真rico
      vResult := to_number(substr(pValorTemp,6,2)); -- confere se m真s 真 num真rico
      vResult := to_number(substr(pValorTemp,9,2)); -- confere se dia 真 num真rico
      if length(pValorTemp)<>nTamMax or substr(pValorTemp,9,2)<'01' or substr(pValorTemp,9,2)>'31' or substr(pValorTemp,6,2)<'01' or substr(pValorTemp,6,2)>'12'
        or substr(pValorTemp,5,1)<>'-' or substr(pValorTemp,8,1)<>'-' then
        vResult := '**********';    -- se tamanho total diferente do previsto ou dias, m真ses e separadores inconsist真ntes, retorna estouro de m真scara;
        vInconsistencia := '- excede o tamanho ou formato da data errado na informa真真o >'||pCpo||'<, valor gerado = '||pValorTemp||' em '||SubStr(tConf(pCpo).ds_bloco,5);
      else
        vResult := pValorTemp;
      end if;
      --
    elsif pChaveTemp = 'st_dataHora' and pValorTemp is NOT null then   -- Tipo DATAHORA
      --
      nTamMax := 19;  -- esperado formato 'yyyy-mm-ddThh:mm:ss' ou 'yyyy-mm-dd hh:mm:ss' ou 'yyyy-mm-dd'
      vResult := to_number(substr(pValorTemp,1,4));     -- confere se ano 真 num真rico
      vResult := to_number(substr(pValorTemp,6,2));     -- confere se m真s 真 num真rico
      vResult := to_number(substr(pValorTemp,9,2));     -- confere se dia 真 num真rico
      vResult := to_number(substr(pValorTemp,12,2));    -- confere se hora 真 num真rico
      vResult := to_number(substr(pValorTemp,15,2));    -- confere se minuto 真 num真rico
      vResult := to_number(substr(pValorTemp,18,2));    -- confere se segundo 真 num真rico
      vResult := pValorTemp;
      if length(vResult)=10 and instr(vResult,':')=0 then   -- se n真o tiver hora, completa
        vResult := vResult||'T'||'00:00:00';
      end if;
      if instr(vResult,'T')=0 then                          -- se falta 'T', completa
        vResult := substr(vResult,1,10)||'T'||substr(vResult,12);
      end if;
      if substr(vResult,5,1)<>'-' and substr(vResult,8,1)<>'-' then -- se separador de data diferente de '-', ajusta.
        vResult := substr(vResult,1,4)||'-'||substr(vResult,6,2)||'-'||substr(vResult,9);
      end if;
      if length(vResult)<>nTamMax or substr(vResult,9,2)<'01' or substr(vResult,9,2)>'31' or substr(vResult,6,2)<'01' or substr(vResult,6,2)>'12'
        or substr(vResult,12,2)<'00' or substr(vResult,12,2)>'24' or substr(vResult,15,2)<'00' or substr(vResult,15,2)>'59' or substr(vResult,18,2)<'00' or substr(vResult,18,2)>'59'
        or substr(vResult,5,1)<>'-' or substr(vResult,8,1)<>'-' or substr(vResult,14,1)<>':' or substr(vResult,17,1)<>':'
        or substr(vResult,11,1) <> 'T' then
        vResult := '*******************';    -- se tamanho total diferente do previsto ou dias, m真ses, hora/minuto/segundo e separadores inconsist真ntes, retorna estouro de m真scara;
        vInconsistencia := '- excede o tamanho ou formato da data/hora errado na informa真真o >'||pCpo||'<, valor gerado = '||pValorTemp||' em '||SubStr(tConf(pCpo).ds_bloco,5);
      end if;
      --
    elsif pChaveTemp = 'st_hora' and pValorTemp is NOT null then   -- Tipo HORA
      --
      nTamMax := 8;   -- esperado formato 'hh:mm:ss'
      vResult := to_number(substr(pValorTemp,1,2));    -- confere se hora 真 num真rico
      vResult := to_number(substr(pValorTemp,4,2));    -- confere se minuto 真 num真rico
      vResult := to_number(substr(pValorTemp,7,2));    -- confere se segundo 真 num真rico
      if length(pValorTemp)<>nTamMax or substr(pValorTemp,1,2)<'00' or substr(pValorTemp,1,2)>'24' or substr(pValorTemp,4,2)<'00' or substr(pValorTemp,4,2)>'59'
        or substr(pValorTemp,7,2)<'00' or substr(pValorTemp,7,2)>'59' or substr(pValorTemp,3,1)<>':' or substr(pValorTemp,6,1)<>':' then
        vResult := '********';    -- se tamanho total diferente do previsto ou hora/minuto/segundo e separadores inconsist真ntes, retorna estouro de m真scara;
        vInconsistencia := '- excede o tamanho ou formato da hora errado na informa真真o >'||pCpo||'<, valor gerado = '||pValorTemp||' em '||SubStr(tConf(pCpo).ds_bloco,5);
      else
        vResult := pValorTemp;
      end if;
      --
    elsif pChaveTemp = 'st_logico' and pValorTemp is NOT null then   -- Tipo LOGICO
      --
      nTamMax := 5;
      if upper(pValorTemp) not in ('TRUE','FALSE','SIM','NAO','N真O','S','N','1','0') then
        vResult := '*****'; -- se op真真es de conte真do de entrada n真o esperado, retorna estouro de m真scara;
        vInconsistencia := '- formato logico (ex: sim/n真o, 1/0, true/false) errado na informa真真o >'||pCpo||'<, valor gerado = '||pValorTemp||' em '||SubStr(tConf(pCpo).ds_bloco,5);
      else
        if upper(pValorTemp) in ('TRUE','SIM','S','1') then
          vResult := 'true';
        else
          vResult := 'false';
        end if;
      end if;
      --
    elsif pChaveTemp = 'dm_tabela' and pValorTemp is NOT null then
      --
      vResult := lpAd(pValorTemp,2,'0');
      --
    ELSE -- atribui tipo  de mascara por tamanho para outras terminologias espec真ficas
      --
      -- SR_TISS0304 dm_etapasAutorizacao, dm_tipoIdent, dm_ausenciaCodValidacao, dm_declaracaoNascidoObito, dm_diagnosticoCID10
      -- atribui tamanho da string para campos 'dm' (TUSS) - Provis真rio
      select decode(pChaveOrig,'dm_CBOS','6','dm_UF','2','dm_caraterAtendimento','1','dm_conselhoProfissional','2','dm_diagnosticoImagem','1','dm_ecog','1','dm_estadiamento','1','dm_finalidadeTratamento,','1','dm_grauPart','2'
                    ,'dm_indicadorAcidente','1','dm_motivoSaida','2','dm_motivoSaidaObito','2','dm_objetoRecurso','1','dm_opcaoFabricante','1','dm_outrasDespesas','2','dm_regimeInternacao,','1','dm_sexo','1','dm_simNao','1'
                    ,'dm_tabela','2','dm_tecnicaUtilizada','1','dm_tipoAcomodacao','2','dm_tipoAtendimento','2','dm_tipoConsulta','1','dm_tipoDemonstrativoPagamento','1','dm_tipoEvento,','1','dm_tipoFaturamento','1'
                    ,'dm_tipoGlosa','4','dm_tipoGuia','1','dm_tipoInternacao','1','dm_tipoQuimioterapia','1','dm_tipoTransacao','30','dm_unidadeMedida','3','dm_versao','7','dm_viaAdministracao,','2','dm_viaDeAcesso','1'
                    ,'dm_tumor','1','dm_nodulo','1','dm_metastase','1','dm_etapasAutorizacao','1','dm_tipoIdent','2','dm_ausenciaCodValidacao','2','dm_declaracaoNascidoObito',11,'dm_diagnosticoCID10',4,pChaveOrig)
        INTO pChaveTemp
        from sys.dual;
      if pChaveTemp<>pChaveOrig then
        pChaveTemp := 'st_texto'||pChaveTemp;
      END IF;
      --
    END IF;
    --
    if i = 1 AND pCpo is not null AND (( vResult is null and
       tConf(pCpo).ds_valor_fixo is not null and tConf(pCpo).tp_preenchimento = 'C' )
        OR tConf(pCpo).DS_QUERY_ALTERNATIVA is not null  ) then
      -- atribui valor fixo da configura真真o
    -- OP 44582
    --IF tConf(pCpo).ds_valor_fixo is not null THEN
      IF tConf(pCpo).ds_valor_fixo is not null AND pValorTemp IS NULL THEN
        pValorTemp := trim(tConf(pCpo).ds_valor_fixo);
      END IF;
      -- atribui valor de query
      IF tConf(pCpo).ds_valor_fixo IS NULL AND tConf(pCpo).DS_QUERY_ALTERNATIVA is not null THEN
        pValorTemp := f_qry(tConf(pCpo).DS_QUERY_ALTERNATIVA,par1,par2,par3,par4,par5,pValorTemp,pCpo);
        IF SubStr(pValorTemp,1,6)='#FALHA' THEN
          vInconsistencia := '- na informa真真o >'||pCpo||'< falha na QUERY ALTERNATIVA configurada, onde:'||Chr(10)||SubStr(pValorTemp,7)||' <<'||Chr(10)||' em '||SubStr(tConf(pCpo).ds_bloco,5);
        END IF;
        IF SubStr(pValorTemp,1,7)='#ALERTA' THEN
          vInconsistencia := '- na informa真真o >'||pCpo||'< inconsist真ncia: '||SubStr(pValorTemp,8);
        END IF;
      END IF;
      --
      vResult := NULL;
      --
    end if;
    --
    IF i = 2 THEN
      IF vResult IS NULL THEN
        vResult := pValorTemp;
      END IF;
    END IF;
    --
    IF vResult IS NOT NULL OR vInconsistencia IS NOT NULL THEN
      EXIT;
    END IF;
    --
  END LOOP;
  --
  -- ajuste for真ado por corre真真o da ANS (abaixo de 3.03.00 somente 1 d真gito)
  IF pChaveOrig = 'dm_conselhoProfissional' AND Nvl(vcConv.cd_versao_tiss,'3.02.01')<'3.03.00' AND vResult IS NOT NULL AND Length(vResult)=2 THEN
    vResult := To_Char(To_Number(vResult));
  END IF;
  --
  if pCpo is not null THEN
    IF vResult IS NOT NULL AND SubStr(tConf(pCpo).ds_bloco,3,1)='N' THEN
      tConf(pCpo).ds_bloco := substr(tConf(pCpo).ds_bloco,1,2)||'S'||SubStr(tConf(pCpo).ds_bloco,4); -- se campo de bloco n真o-obrigat真rio preenchido, o bloco se torna Obrigat真rio para efeito de valida真真o
    END IF;
    if vInconsistencia IS NULL and tConf(pCpo).sn_obrigatorio = 'S' AND SubStr(tConf(pCpo).ds_bloco,3,1)='S' and vResult is NULL -- se campo obrigat真rio de bloco obrigat真rio n真o preenchido
    --AND (subStr(tConf(pCpo).ds_bloco,1,1)<>'S' OR (subStr(tConf(pCpo).ds_bloco,1,1)='S' AND tConf(pCpo).tp_utilizacao>1  )) -- ... e se campo n真o for escolha, ou for escolha e o pr真ximo n真o e j真 for a 1a. op真真o
      AND (subStr(tConf(pCpo).ds_bloco,1,1)<>'S' ) -- ... e se campo n真o for escolha, ou for escolha e o pr真ximo n真o e j真 for a 1a. op真真o
      THEN
      vInconsistencia := '- obrigat真ria a informa真真o >'||pCpo||'< em '||SubStr(tConf(pCpo).ds_bloco,5);
    END IF;
  END IF;
  --
  -- s真 registra inconsistencias se estiver gerando Guias (n真o valida nas cTiss e outras chamadas dos campos)
  IF SubStr(vGerandoGuia,1,1) = 'S' AND vInconsistencia IS NOT NULL then
      IF Length(Nvl(vPendenciaGuia,'x'))+Length(vInconsistencia)+1<(4000-8) then
        vPendenciaGuia := vPendenciaGuia||vInconsistencia;
        IF SubStr(vGerandoGuia,2) IS NOT NULL THEN
          vPendenciaGuia := vPendenciaGuia||' no item '||SubStr(vGerandoGuia,2)||';'||Chr(10);
        ELSE
          vPendenciaGuia := vPendenciaGuia||Chr(10);
        END IF;
      ELSIF SubStr(vPendenciaGuia,Length(vPendenciaGuia)-7)<>Chr(10)||'...mais' then
        vPendenciaguia := vPendenciaGuia||CHR(10)||'...mais';
      END IF;
  END IF;
  --
  RETURN vResult;
  --
EXCEPTION
    when others then
        RETURN lpad('*',nvl(nTamMax,1),'*');
  --
end;
--
--==================================================
function F_ST(  pChave      in varchar2,
                pValor      in varchar2,
                pCpo        in varchar2) return  varchar2 is

  vResult     varchar2(4000);

begin

  vResult:= F_ST(pChave,pValor,pCpo,null,null,null,null,null);
  --
  RETURN vResult;
  --

end;
--

--==================================================
FUNCTION  F_ct_localContratado(  pModo          in varchar2,
                                 pIdMap         in number,
                                 pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                 pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                 pCdPrestador   in dbamv.prestador.cd_prestador%type,
                                 pCdConv        in dbamv.convenio.cd_convenio%type,
                                 vCt            OUT NOCOPY RecLocContrat,
                                 pMsg           OUT varchar2,
                                 pReserva       in varchar2) return varchar2 IS
  --
  vTemp	                varchar2(1000);
  vResult               varchar2(1000);
  pCdConvTmp            dbamv.convenio.cd_convenio%type;
  pCdMultiEmpresaTmp    dbamv.multi_empresas.cd_multi_empresa%type;
  vCp	                varchar2(1000);
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    --
  end if;
  -------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp            :=  nvl(pCdConv,nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
  pCdMultiEmpresaTmp    := vcAtendimento.cd_multi_empresa; -- DO ATENDIMENTO
  -------------------------
  if vcConv.cd_convenio<>nvl(pCdConvTmp,0) then
    open  cConv(pCdConvTmp);
    fetch cConv into vcConv;
    close cConv;
  end if;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('localContratado').tp_utilizacao > 0 then
    --
    if pCdPrestador is not null then
        if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>pCdPrestador||pCdConvTmp then
          vcPrestador := null;
          open  cPrestador(pCdPrestador,null, pCdConvTmp, NULL ,vcConta.cd_con_pla); -- pda FATURCONV-1372
          fetch cPrestador into vcPrestador;
          close cPrestador;
        end if;
    else
        vcPrestador := null;
        if pCdMultiEmpresaTmp <> nvl(vcHospital.cd_multi_empresa, 0) then
          open cHospital(pCdMultiEmpresaTmp);
          fetch cHospital into vcHospital;
          close cHospital;
        end if;
    end if;
    --
    FOR I in 1..3 LOOP -- os 3 campos abaixo s真o CHOICE ==============================
      --
      -- codigoContratado
      -- codigoNaOperadora-------------------------------------
      vCp := 'codigoNaOperadora'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I then
          if pCdPrestador is not null then
			--PROD-2542 condicao - so vai gerar se o credenciamento estiver ativo
            if vcPrestador.sn_ativo_credenciamento = 'S' then
              vTemp := vcPrestador.cd_prestador_conveniado;
            else
              vTemp := NULL;
            end if;
          else -- 真 o Hospital
            if NVL(vcEmpresaConv.cd_multi_empresa||vcEmpresaConv.cd_convenio,'XX') <> pCdMultiEmpresaTmp||pCdConvTmp then
              open  cEmpresaConv(pCdMultiEmpresaTmp, pCdConvTmp);
              fetch cEmpresaConv into vcEmpresaConv;
              close cEmpresaConv;
            end if;
            vTemp := vcEmpresaConv.cd_hospital_no_convenio;
          end if;
        vCt.codigoNaOperadora := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdConta,null,null);
        vResult := vCt.codigoNaOperadora;
        EXIT when vCt.codigoNaOperadora is NOT null;
      end if;
      --
      -- cnpjLocalExecutante-----------------------------------
      vCp := 'cnpjLocalExecutante'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao = I then
          if pCdPrestador is not null then
            if length(vcPrestador.nr_cpf_cgc)>11 then
              vTemp := vcPrestador.nr_cpf_cgc;
            end if;
          else
            vTemp := vcHospital.cd_cgc;
          end if;
        vCt.cnpjLocalExecutante := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
        vResult := vCt.cnpjLocalExecutante;
        EXIT when vCt.cnpjLocalExecutante is NOT null;
      end if;
      --
    END LOOP; -- fim do CHOICE ================================
    --
    -- nomeContratado-----------------------------------
    vCp := 'nomeContratado'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --
        if pCdPrestador is not null then
          vTemp := vcPrestador.nm_prestador;
        else
          vTemp := vcHospital.ds_razao_social;
        end if;
      vCt.nomeContratado := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vResult := vCt.nomeContratado;
    end if;
    --
    -- cnes---------------------------------------------
    vCp := 'cnes'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --
        if nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa) <> nvl(vcHospital.cd_multi_empresa, 0) then
          open cHospital(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa));
          fetch cHospital into vcHospital;
          close cHospital;
        end if;
        vTemp := nvl(to_char(vcHospital.nr_cnes),'9999999');
        --
      vCt.cnes := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vResult := vCt.cnes;
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_dadosContratadoExecutante (  pModo          in varchar2,
                                            pIdMap         in number,
                                            pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                            pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                                            pCdPrestador   in dbamv.prestador.cd_prestador%type,
                                            pCdConv        in dbamv.convenio.cd_convenio%type,
                                            vCt            OUT NOCOPY RecContrExec,
                                            pMsg           OUT varchar2,
                                            pReserva       in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  pCdPrestTmp   dbamv.prestador.cd_prestador%type;
  vCp	        varchar2(1000);
  pCdEmpresaTmp dbamv.multi_empresas.cd_multi_empresa%type;
  --
  vTussRel      RecTussRel;
  vTuss         RecTuss;
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  end if;
  ----------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(pCdConv,nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
  pCdPrestTmp   :=  nvl(pCdPrestador,vcAtendimento.cd_prestador);
  pCdEmpresaTmp :=  nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa);
  if instr(nvl(pReserva,'X'),'#')>0 then
    pCdEmpresaTmp := substr(pReserva,instr(pReserva,'#')+1,4); -- empresa for真ada
    pCdPrestTmp   := null; -- condi真真o especial, considerar sempre o contratante como empresa mesmo separando por m真dico (neste caso, para guias em branco ainda)
  end if;
  if vcConta.cd_multi_empresa<>vcAtendimento.cd_multi_empresa then
    pCdPrestTmp := null; -- condi真真o especial, considerar sempre o contratante como empresa mesmo separando por m真dico
  end if;
  ----------------------
  if vcConv.cd_convenio<>nvl(pCdConvTmp,0) then
    open  cConv(pCdConvTmp);
    fetch cConv into vcConv;
    close cConv;
  end if;
  --
  if pCdEmpresaTmp <> nvl(vcHospital.cd_multi_empresa, 0) then
    open cHospital(pCdEmpresaTmp);
    fetch cHospital into vcHospital;
    close cHospital;
  end if;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('dadosContratadoExecutante').tp_utilizacao > 0 then
    --
    if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>pCdPrestTmp||pCdConvTmp then
      vcPrestador := null;
      open  cPrestador(pCdPrestTmp,null, pCdConvTmp, NULL ,vcConta.cd_con_pla);-- pda FATURCONV-1372
      fetch cPrestador into vcPrestador;
      close cPrestador;
    end if;
    --
    -- codigonaOperadora---------------------------------
    vCp := 'codigonaOperadora'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0  then
        --
        if pCdPrestador is not null and pCdPrestTmp is not null then
		  --PROD-2542 condicao - so vai gerar se o credenciamento estiver ativo
          if vcPrestador.sn_ativo_credenciamento = 'S' then
            vTemp := vcPrestador.cd_prestador_conveniado;
          else
            vTemp := NULL;
          end if;
--		  FATURCONV-18998 - inicio
          IF vTemp is NULL AND vcAtendimento.tp_atendimento <>'I' THEN
           open  cEmpresaConv(pCdEmpresaTmp, pCdConvTmp);
           fetch cEmpresaConv into vcEmpresaConv;
           close cEmpresaConv;
           vTemp := vcEmpresaConv.cd_hospital_no_convenio;
          END IF;
--		  FATURCONV-18998 - Fim
		else -- 真 o Hospital
          if NVL(vcEmpresaConv.cd_multi_empresa||vcEmpresaConv.cd_convenio,'XX') <> pCdEmpresaTmp||pCdConvTmp then
            open  cEmpresaConv(pCdEmpresaTmp, pCdConvTmp);
            fetch cEmpresaConv into vcEmpresaConv;
            close cEmpresaConv;
          end if;
          vTemp := vcEmpresaConv.cd_hospital_no_convenio;
        end if;
      vCt.codigonaOperadora := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdConta,null,null);
      vResult := vCt.codigonaOperadora;
    end if;
    --
    --Oswaldo FATURCONV-22404 inicio
    -- nomeContratadoExecutante--------------------------
    vCp := 'nomeContratadoExecutante'; vTemp := null;
  --if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
    if vCp = nvl(pModo,vCp) then
        if pCdPrestador is not null and pCdPrestTmp is not null then
          vTemp := vcPrestador.nm_prestador;
        else
          vTemp := vcHospital.ds_razao_social;
        end if;
    --vCt.nomeContratadoExecutante := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vCt.nomeContratadoExecutante := SubStr(vTemp,1,70);
      vResult := vCt.nomeContratadoExecutante;
    end if;
    --
    --Oswaldo FATURCONV-22404 fim
    -- cnesContratadoExecutante--------------------------
    vCp := 'cnesContratadoExecutante'; vTemp := null;
    if  vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --
        if pCdPrestador is not null and pCdPrestTmp is not null then
          vTemp := nvl(to_char(vcPrestador.codigo_cnes),'9999999');
        else
          if pCdEmpresaTmp <> nvl(vcHospital.cd_multi_empresa, 0) then
            open cHospital(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa));
            fetch cHospital into vcHospital;
            close cHospital;
          end if;
          vTemp := nvl(to_char(vcHospital.nr_cnes),'9999999');
        end if;
        --
      vCt.cnesContratadoExecutante := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vResult := vCt.cnesContratadoExecutante;
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
-- ctm_sp-sadtAtendimento
FUNCTION  F_ctm_sp_sadtAtendimento (pModo       in varchar2,
                                    pIdMap      in number,
                                    pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                    pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                    vCt         OUT NOCOPY RecDadosAtendSpSadt,
                                    pMsg        OUT varchar2,
                                    pReserva    in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	        varchar2(1000);
  --
  vTussRel      RecTussRel;
  vTuss         RecTuss;
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
  end if;
  if pCdConta is not null then
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  end if;
  ------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  ------------------
  --
  if pModo is NOT null or tConf('ctm_sp-sadtAtendimento').tp_utilizacao > 0 then
    --
    -- tipoAtendimento----------------------------------
    vCp := 'tipoAtendimento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      --vTussRel.tp_atendimento := vcAtendimento.tp_atendimento;
      --vTemp := F_DM(50,pCdAtend,pCdConta,null,null,vTussRel,vTuss,pMsg,null);
      --vTemp := vTuss.CD_TUSS;
      IF vcAtendimento.tp_atendimento_tiss IS null then
       vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                       vcAtendimento.cd_pro_int,'TP_ATENDIMENTO_TISS',vcAtendimento.dt_atendPac);
	  else
       vTemp :=  LPad( vcAtendimento.tp_atendimento_tiss, 2, '0');
      END IF;
      IF vTemp IS NULL then
        -- Oswaldo FATURCONV-20760 inicio
        if (vcAtendimento.tp_atendimento = 'I' and Nvl(vcProgramasHomecare.tp_guia,'X') <> 'SP') OR
           (vcAtendimento.tp_atendimento_original = 'H' AND vcAtendimento.cd_atendimento_tiss IS NULL)
        THEN
          vTemp := '07'; --VERIFICAR VALOR DEFAULT
        else
         IF  vcAtendimento.tp_atendimento_original = 'H' and vcProgramasHomecare.tp_guia = 'SP'  THEN
            IF vcAtendimento.cd_atendimento_tiss is null then
				vTemp := '06';
			else
				vTemp :=  LPad( vcAtendimento.cd_atendimento_tiss, 2, '0');
			end if;
          ELSE
            IF vcAtendimento.tp_atendimento = 'E' THEN
			  vTemp :=  '05';
			ELSE
			  vTemp :=  '04';
			END IF;
          END IF;
        -- Oswaldo FATURCONV-20760 fim
        end if;
      END IF;
      vCt.tipoAtendimento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);  -- dm_tipoAtendimento
    end if;
    --
    -- indicacaoAcidente--------------------------------
    vCp := 'indicacaoAcidente'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      --FUTURO RELACIONAMENTO COM A TELA (Terminologia 36)
      --vTemp := F_DM(36,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
      --vTemp := vTuss.CD_TUSS;
    IF vcAtendimento.tp_acidente_tiss IS null then
     vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                       vcAtendimento.cd_pro_int,'TP_ACIDENTE_TISS',vcAtendimento.dt_atendPac);
    END IF;
    IF vTemp IS NULL then
        vTemp := nvl( vcAtendimento.tp_acidente_tiss, '9') ;
    END IF;
      vCt.indicacaoAcidente := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null); -- dm_indicadorAcidente
      vResult := vCt.indicacaoAcidente;
    end if;
    --
    -- tipoConsulta-------------------------------------
    vCp := 'tipoConsulta'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vCt.tipoAtendimento = '04' then -- condicionamento do campo de Tipo de Atendimento
        --FUTURO RELACIONAMENTO COM A TELA (52)
        --vTemp := F_DM(52,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
        --vTemp := vTuss.CD_TUSS;
          vTemp := vcAtendimento.tp_consulta_tiss;
        end if;
      vCt.tipoConsulta := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);  -- dm_tipoConsulta
      vResult := vCt.tipoConsulta;
    end if;
    --
    -- motivoEncerramento-------------------------------
    vCp := 'motivoEncerramento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTussRel.cd_mot_alt := vcAtendimento.cd_mot_alt;
        vTemp := F_DM(39,pCdAtend,pCdConta,null,null,vTussRel,vTuss,pMsg,null);
        if nvl(vTuss.CD_TUSS,'0') in ('41','42','43') then
          vTemp := vTuss.CD_TUSS;
        else
          vTemp := null;
        end if;
      vCt.motivoEncerramento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);    -- dm_motivoSaidaObito
      vResult := vCt.motivoEncerramento;
    end if;
    --
    --Oswaldo FATURCONV-22404 inicio
    -- regimeAtendimento-------------------------------
    vCp := 'regimeAtendimento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      IF vcAtendimento.tp_regime_atendimento IS NOT NULL then
        vTemp := LPad(vcAtendimento.tp_regime_atendimento, 2, '0');
      ELSE
       vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                       vcAtendimento.cd_pro_int,'TP_REGIME_ATENDIMENTO',vcAtendimento.dt_atendPac);
       IF vTemp IS NULL THEN

        IF vcAtendimento.tp_atendimento = 'H' THEN
           vTemp := '02';
        ELSIF vcAtendimento.tp_atendimento in ('A', 'E') THEN
           vTemp := '01';
        ELSIF vcAtendimento.tp_atendimento = 'I' THEN
           vTemp := '03';
        ELSIF vcAtendimento.tp_atendimento = 'U' THEN
           vTemp := '04';
        END IF;
       END IF;
      END IF;
      vCt.regimeAtendimento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);  -- dm_regimeAtendimento
      vResult := vCt.regimeAtendimento;
    end if;
    --
    -- saudeOcupacional-------------------------------
    vCp := 'saudeOcupacional'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      IF vcAtendimento.tp_saude_ocupacional IS NOT NULL then
        vTemp := LPad(vcAtendimento.tp_saude_ocupacional, 2, '0');
      ELSE
        vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                       vcAtendimento.cd_pro_int,'TP_SAUDE_OCUPACIONAL',vcAtendimento.dt_atendPac);

      END IF;
      vCt.saudeOcupacional := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);  -- dm_saudeOcupacional
      vResult := vCt.saudeOcupacional;
    end if;
    --
    --Oswaldo FATURCONV-22404 fim
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_dadosSolicitacao(   pModo          in varchar2,
                                pIdMap         in number,
                                pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                pCdConta       in dbamv.reg_amb.cd_reg_amb%type,
                                pCdGuia        in dbamv.guia.cd_guia%type,
                                pIdTmp         IN dbamv.tmpmv_tiss_sol_guia.id_tmp%type,
                                vCt            OUT NOCOPY RecDadosSolicitacao,
                                pMsg           OUT varchar2,
                                pReserva       in varchar2) return varchar2 IS

  -- FUNCTION F_ctm_sp-sadtSolicitacaoGuia(... [N_RETIRAR]
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	        varchar2(1000);
  pCdGuiaTmp    dbamv.guia.cd_guia%type;
  --
  vTussRel      RecTussRel;
  vTuss         RecTuss;
  vDtPedido     VARCHAR2(10);

  /* FATURCONV-4576 */
  CURSOR cTissSolicitacao IS
    SELECT tp_atendimento FROM dbamv.tmpmv_tiss_sol_guia WHERE ID_TMP = pIdTmp;
  /* FATURCONV-4576 */
  rTissSolicitacao cTissSolicitacao%rowtype;

BEGIN

  -- leitura de cursores de uso geral


  if pCdAtend is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
  end if;
  if pCdConta is not null then
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  end if;
/* FATURCONV-4576 */
  if pIdTmp is not null then
    rTissSolicitacao:= NULL;
    open  cTissSolicitacao;
    fetch cTissSolicitacao into rTissSolicitacao;
    close cTissSolicitacao;
    vcAtendimento.tp_atendimento:= rTissSolicitacao.tp_atendimento;
  end if;
/* FATURCONV-4576 */
  IF pReserva IS NOT null then
    if pCdAtend||pCdConta||pReserva <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento, 'XXX') then
      open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pReserva,null,null);
      fetch cItem into vcItem;
      close cItem;
    end if;
    IF vcItem.tp_mvto IN ('Imagem','SADT') AND vcAtendimento.tp_atendimento = 'E' then
      if nvl(vcItemAux.cd_atendimento||vcItemAux.cd_conta||vcItemAux.cd_lancamento,'XXX')<>pCdAtend||pCdConta||pReserva then
        open  cItemAux(vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pReserva,null,null);
        fetch cItemAux into vcItemAux;
        close cItemAux;
      end if;
      vDtPedido := vcItemAux.dt_pedido;
    END IF;
  END IF;
  ---------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp     :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  IF pModo IS NULL then
    pCdGuiaTmp     :=  nvl(pCdGuia,nvl(vcConta.cd_guia,vcAtendimento.cd_guia));
  ELSE
    pCdGuiaTmp     :=  NULL;
  END IF;
  --
  IF vcAtendimento.tp_atendimento = 'E' AND vcItem.cd_guia IS NOT NULL AND vcItem.tp_mvto IN ('Imagem','SADT') THEN
    pCdGuiaTmp := vcItem.cd_guia;
  END IF;
  --
  -- Oswaldo BH in真cio
  --Indicacao clinica via solicitacao nao estava abrindo a solicitacao
  --Data de Solicitacao estava sendo sysdate mesmo quando informada na tela de guias uma data retroativa.
  IF (pModo = 'indicacaoClinica' AND pIdMap = 1558) OR (pModo = 'dataSolicitacao' AND pIdMap = 1556)THEN
    pCdGuiaTmp     :=  pCdGuia;
  END IF;
  -- Oswaldo BH fim
  ---------------------------
  vcAutorizacao := null;
  if pCdGuiaTmp is not null then
    vcAutorizacao := null;
    open  cAutorizacao(pCdGuiaTmp,null);
    fetch cAutorizacao into vcAutorizacao;
    close cAutorizacao;
  end if;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  vCp := 'dadosSolicitacao'; vTemp := null;
  if pModo is NOT null or tConf(vCp).tp_utilizacao > 0 then
    --
    -- caraterAtendimento--------------------------------
    vCp := 'caraterAtendimento';
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
      --vTussRel.tp_atendimento := vcAtendimento.tp_atendimento;
      --vTemp := F_DM(23,pCdAtend,pCdConta,null,null,vTussRel,vTuss,pMsg,null);
      --vTemp := nvl(vTuss.CD_TUSS,'1');
		   IF vcAtendimento.tp_carater_internacao IS null then
         vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                       vcAtendimento.cd_pro_int,'TP_CARATER_INTERNACAO',vcAtendimento.dt_atendPac);
       END IF;
       IF vTemp IS NULL THEN
    /* FATURCONV-4576 */
        if nvl(vcAtendimento.tp_carater_internacao,nvl(vcAtendimento.tp_atendimento,'X')) in ('U','2') then
		/* FATURCONV-4576 */
          vTemp := '2';
        else
          vTemp := '1';
        end if;
       END IF;
      vCt.caraterAtendimento := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);  -- dm_caraterAtendimento
      vResult := vCt.caraterAtendimento;
    end if;
    --
    -- dataSolicitacao-----------------------------------
    vCp := 'dataSolicitacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      if vcItemAux.dt_solicitacao_guia is not null then   --data do item
        vTemp := vcItemAux.dt_solicitacao_guia;
      elsif vcAutorizacao.dt_solicitacao is not null then --data da solicitacao
        vTemp := vcAutorizacao.dt_solicitacao;
      elsif vDtPedido is not null then                    --data do pedido
        vTemp := vDtPedido;
      ELSE
        IF pModo IS NULL then
          vTemp := Nvl(vcAtendimento.dt_atendimento,To_Char(SYSDATE,'yyyy-mm-dd'));            --data do atendimento
        ELSE
          vTemp := To_Char(SYSDATE,'yyyy-mm-dd'); -- com pModo (tag for真ada na fun真真o) indica ser proveniente de Solicita真真o de Autoriza真真o, e assim utiliza sysdate
        END IF;
      end if;
      vCt.dataSolicitacao := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vResult := vCt.dataSolicitacao;
    end if;
    --
    -- indicacaoClinica----------------------------------
    vCp := 'indicacaoClinica'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_INDICACAO_CLI_SP',pCdConvTmp,null) = 'A' then --A-Diagnostico do Atendimento
          open  cDiagnosticoAtendimento (vcAtendimento.cd_atendimento, null);
          fetch cDiagnosticoAtendimento into vDiagnosticoAtendimento;
          close cDiagnosticoAtendimento;
          --
          vTemp := vDiagnosticoAtendimento.ds_diagnostico;
          --
        elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_INDICACAO_CLI_SP',pCdConvTmp,null) = 'G' then --G-Justificativa tela de Guias
          --
          vTemp := vcAutorizacao.ds_justificativa;
          --
        elsif dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_INDICACAO_CLI_SP',pCdConvTmp,null) = 'H' then --H-Historico de doencas anteriores
            vcDsHda := null;
            open  cDsHda(vcAtendimento.cd_casos_atd);
            fetch cDsHda into vcDsHda;
            close cDsHda;
            vTemp := vcDsHda.ds_hda;
          --
        end if;
      vCt.indicacaoClinica := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
      vResult := vCt.indicacaoClinica;
    end if;
    --
    --Oswaldo FATURCONV-22404 inicio
    --indCobEspecial-------------------------------------
    vCp := 'indCobEspecial'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
     IF vcAtendimento.tp_cobertura_especial IS null then
        vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                       vcAtendimento.cd_pro_int,'TP_COBERTURA_ESPECIAL',vcAtendimento.dt_atendPac);
     ELSE
        vtemp := LPad(vcAtendimento.tp_cobertura_especial, 2, '0');
     END IF;
      vCt.indCobEspecial := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null); --dm_cobEsp
      vResult := vCt.indCobEspecial;
    END IF;
    --Oswaldo FATURCONV-22404 fim
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
function F_ret_sn_equipe (  pTpGuia     in varchar2,
                            pCdAtend    in dbamv.atendime.cd_atendimento%type,
                            pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                            pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                            pCdItLan    in varchar2,
                            pReserva    in varchar2    ) return varchar2 is
  --
  vResult	    varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  pCdPrestTmp   dbamv.prestador.cd_prestador%type;
  --
begin
  --
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdLanc is not null then
      if pCdAtend||pCdConta||pCdLanc||pCdItLan <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento||vcItem.cd_itlan_med, 'XXX') then
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
        fetch cItem into vcItem;
        close cItem;
      end if;
    end if;
  end if;
  ------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  pCdPrestTmp   :=  vcItem.cd_prestador;
  ------------------
  if vcItem.cd_pro_fat <> nvl(vcProFat.cd_pro_fat,'X') then
    open  cProFat(vcItem.cd_pro_fat);
    fetch cProFat into vcProFat;
    close cProFat;
  end if;
  if vcItem.cd_pro_fat <> nvl(vcProFatAux.cd_pro_fat,'X') then
    open  cProFatAux(vcItem.cd_pro_fat, null);
    fetch cProFatAux into vcProFatAux;
    close cProFatAux;
  end if;
  if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>pCdPrestTmp||pCdConvTmp then
    vcPrestador := null;
    open  cPrestador(pCdPrestTmp,null, pCdConvTmp, NULL ,vcItem.cd_con_pla); -- pda FATURCONV-1372
    fetch cPrestador into vcPrestador;
    close cPrestador;
  end if;
  --
  if pTpGuia = 'RI' then
    --
    vResult := 'N'; -- default de inicializa真真o:  0 - N真o Gera Equipe
    --
    if FNC_CONF('TP_PROC_GERA_EQUIPE_RI',pCdConvTmp,null) = '1' then    -- 1 - Apenas Cirurgias
      if (nvl(vcProFat.nr_auxiliar,0)>0 or vcProFat.cd_por_ane is not null) then
        vResult := 'S';
      end if;
    elsif FNC_CONF('TP_PROC_GERA_EQUIPE_RI',pCdConvTmp,null) = '2' then -- 2 - Cirurgias e servi真os SP
      if (nvl(vcProFat.nr_auxiliar,0) >0 or vcProFat.cd_por_ane is not null)
        or vcProFatAux.tp_gru_pro = 'SP' then
        vResult := 'S';
      end if;
    elsif FNC_CONF('TP_PROC_GERA_EQUIPE_RI',pCdConvTmp,null) = '3' then -- 3 - Cirurgias, SP e SD(PF)
      if (nvl(vcProFat.nr_auxiliar,0) >0 or vcProFat.cd_por_ane is not null)
        or vcProFatAux.tp_gru_pro = 'SP'
        or (vcProFatAux.tp_gru_pro = 'SD' and nvl(vcPrestador.tp_vinculo,'X')<>'J' ) then
        vResult := 'S';
      end if;
    elsif FNC_CONF('TP_PROC_GERA_EQUIPE_RI',pCdConvTmp,null) = '4' then -- 4 - Todos serv.com prestador
      vResult := 'S';
    end if;
    --
    if vResult = 'S' then
      -- default 1 - Todos Prestadores
      if FNC_CONF('TP_PREST_EQUIPE_RI',pCdConvTmp,null) = '2' then      -- 2 - Somente Prest. Cobran真a (P)
        if vcItem.tp_pagamento = 'C' then
          vResult := 'N';
        end if;
      elsif FNC_CONF('TP_PREST_EQUIPE_RI',pCdConvTmp,null) = '3' then   -- 3 - Somente Prest. Credenc. (C)
        if vcItem.tp_pagamento <> 'C' then
          vResult := 'N';
        end if;
      end if;
      --
    end if;
    --
  elsif pTpGuia = 'SP' then
    --
    vResult := 'N'; -- default de inicializa真真o:  0 - N真o Gera Equipe
    --

    if FNC_CONF('TP_PROC_GERA_EQUIPE_SPSADT',pCdConvTmp,null) = '1' then    -- 1 - Apenas Cirurgias
      if (nvl(vcProFat.nr_auxiliar,0) >0 or vcProFat.cd_por_ane is not null) then
        vResult := 'S';
      end if;
    elsif FNC_CONF('TP_PROC_GERA_EQUIPE_SPSADT',pCdConvTmp,null) = '2' then -- 2 - Cirurgias e servi真os SP
      if (nvl(vcProFat.nr_auxiliar,0) >0 or vcProFat.cd_por_ane is not null)
        or vcProFatAux.tp_gru_pro = 'SP' then
        vResult := 'S';
      end if;
    elsif FNC_CONF('TP_PROC_GERA_EQUIPE_SPSADT',pCdConvTmp,null) = '3' then -- 3 - Cirurgias, SP e SD(PF)
      if (nvl(vcProFat.nr_auxiliar,0) >0 or vcProFat.cd_por_ane is not null)
        or vcProFatAux.tp_gru_pro = 'SP'
        or (vcProFatAux.tp_gru_pro = 'SD' and nvl(vcPrestador.tp_vinculo,'X')<>'J' ) then
        vResult := 'S';
      end if;
    elsif FNC_CONF('TP_PROC_GERA_EQUIPE_SPSADT',pCdConvTmp,null) = '4' then -- 4 - Todos serv.com prestador
      vResult := 'S';
    end if;
    --
    if vResult = 'S' then
      -- default -- 1 - Todos Prestadores
      if FNC_CONF('TP_PREST_EQUIPE_SPSADT',pCdConvTmp,null) = '2' then      -- 2 - Somente Prest. Cobran真a (P)
        if vcItem.tp_pagamento = 'C' then
          vResult := 'N';
        end if;
      elsif FNC_CONF('TP_PREST_EQUIPE_SPSADT',pCdConvTmp,null) = '3' then   -- 3 - Somente Prest. Credenc. (C)
        if vcItem.tp_pagamento <> 'C' then
          vResult := 'N';
        end if;
      end if;
      --
    end if;
    --
  end if;
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS then
      raise_application_error( -20001, pkg_rmi_traducao.extrair_pkg_msg('MSG_3', 'pkg_ffcv_tiss_v4', 'FALHA em f_ret_sn_equipe ', arg_list(SQLERRM)));
      RETURN NULL;
  --
end;
--
--==================================================
function F_ret_sn_HI (  pCdAtend    in dbamv.atendime.cd_atendimento%type,
                        pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                        pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                        pCdItLan    in varchar2,
                        pReserva    in varchar2    ) return varchar2 is
  --
  vResult	    varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  pCdPrestTmp   dbamv.prestador.cd_prestador%type;
  vRet          varchar2(1000);
  --
begin
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdLanc is not null then
      if pCdAtend||pCdConta||pCdLanc||pCdItLan <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento||vcItem.cd_itlan_med, 'XXXX') then
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
        fetch cItem into vcItem;
        close cItem;
      end if;
    end if;
  end if;
  ---------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  pCdPrestTmp   :=  vcItem.cd_prestador;
  ---------------------------
  if vcItem.cd_pro_fat <> nvl(vcProFatAux.cd_pro_fat,'X') then
    open  cProFatAux(vcItem.cd_pro_fat, null);
    fetch cProFatAux into vcProFatAux;
    close cProFatAux;
  end if;
  if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>pCdPrestTmp||pCdConvTmp then
    vcPrestador := null;
    open  cPrestador(pCdPrestTmp,null, pCdConvTmp, NULL ,vcItem.cd_con_pla); -- pda FATURCONV-1372
    fetch cPrestador into vcPrestador;
    close cPrestador;
  end if;
  --
  vResult := 'N'; -- default de inicializa真真o:  N真o Gera H.I.
  --
  -- Somente Credenciado e Condi真真o especial: Faturamento de Empresa-Distribu真do (ex: Sta.Joana SP)
  if vcAtendimento.tp_atendimento = 'I' then
    if (vcItem.tp_pagamento = 'C' AND vcConta.cd_conta_pai is null )
      or (vcItem.tp_pagamento<>'C' AND vcConta.cd_conta_pai is NOT null) then
      --
      if FNC_CONF('TP_GERACAO_HI',pCdConvTmp,null) = '1' then    -- 1-SP de Credenciados
        if vcProFatAux.tp_gru_pro = 'SP' then
          vResult := 'S';
        end if;
      elsif FNC_CONF('TP_GERACAO_HI',pCdConvTmp,null) = '2' then -- 2-SP,SD de Credenciados
        if vcProFatAux.tp_gru_pro in ('SP','SD') then
          vResult := 'S';
        end if;
      elsif FNC_CONF('TP_GERACAO_HI',pCdConvTmp,null) = '3' then -- 3-SP,SD Credenciados(somente P.F.)
        if vcProFatAux.tp_gru_pro = 'SP'
          or (vcProFatAux.tp_gru_pro = 'SD' and nvl(vcPrestador.tp_vinculo,'X')<>'J' ) then
          vResult := 'S';
        end if;
      end if;
    end if;
  end if;
  --
  -- Condi真真o especial: HI para ambulatorial cobran真a ("P") desde que setor com De/Para configurado.
  if vcAtendimento.tp_atendimento<>'I' and vcItem.tp_pagamento<>'C' AND nvl(FNC_CONF('TP_CONTA_HONORARIO_HI',pCdConvTmp,null),'1') = '2' then
    vRet := F_ret_prestador (pCdAtend,pCdConta,pCdLanc,null,null,pCdConvTmp,'HI','CONTRATADO_EXTERNO',null);
    if vRet is not null then
      vResult := 'S';
    end if;
  end if;
  --
  if vcItem.tp_pagamento = 'C' and vcItem.sn_paciente_paga = 'S' then
    vResult := 'N'; -- NUNCA GERA PARA SN_PACIENTE_PAGA.
  end if;
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS then
      raise_application_error( -20001, pkg_rmi_traducao.extrair_pkg_msg('MSG_3', 'pkg_ffcv_tiss_v4', 'FALHA em f_ret_sn_HI ', arg_list(SQLERRM)));
      RETURN NULL;
  --
end;
--
--==================================================
FUNCTION  F_ctm_sp_sadtSolicitacaoGuia  (   pModo       in varchar2,
                                            pIdMap      in number,
                                            pCdAtend    in dbamv.atendime.cd_atendimento%type,          --  <- opt 1
                                            pCdConta    in dbamv.reg_amb.cd_reg_amb%type,               --  <- opt 1
                                            pCdCarteira in number,-- dbamv.carteira.cd_carteira%type    --  <- opt 2
                                            pCdPrestSol in dbamv.prestador.cd_prestador%type,   	    --  <- opt 1,2
                                            pCdOrigem	  in number,                                      --  <- opt 2,3
                                            pTpOrigem	  in varchar2,                                    --  <- opt 2,3
                                            pMsg        OUT varchar2,
                                            pReserva    in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(1000);
  vCp	              varchar2(1000);
  vRet              varchar2(1000);
  vcItensSolProc    cItensSolProc%rowtype;
  vcItensSolProcTMP cItensSolProc%rowtype;
  vTissSolGuia      dbamv.tiss_sol_guia%rowtype;
  vTissItSolGuia    dbamv.tiss_itsol_guia%rowtype;
  pCdConv           dbamv.convenio.cd_convenio%type;
  pCdPaciente       dbamv.paciente.cd_paciente%type;
  vCtProcDados      RecProcDados;
  vCtAutorizSadt    RecAutorizSadt;
  vCtBenef          RecBenef;
  vCtCabec          RecCabec;
  vCtContrat        RecContrat;
  vCtContrProf      RecContrProf;
  vCtDadosSolic     RecDadosSolicitacao;
  nCdGuiaOrigemTmp  number;
  nCdAtendTmp       dbamv.atendime.cd_atendimento%TYPE;
  pCdPrestSolTmp    dbamv.prestador.cd_prestador%type;
  vcPreInt          cPreInt%rowtype;
  vcAviCir          cAviCir%rowtype;
  vResultTMP        varchar2(1000);
  vcTissSolGuiaTpOrigem cTissSolGuiaTpOrigem%rowtype;
  nLinha            number;
  nrLimite            number;
  vJustificativaTmp varchar2(500);
  vOrigemSolicitacao  VARCHAR2(100); --CIMP-4238 - variavel de apoio referente a chamada do PEP
  vcTmpSol          cTmpSol%ROWTYPE;
  nCdEspecialidTmp  dbamv.especialid.cd_especialid%TYPE;
  nCdConPlaTmp      dbamv.con_pla.cd_con_pla%TYPE;
  vNrIdBeneficiario dbamv.tiss_sol_guia.nr_id_beneficiario%TYPE;
  vTpIdentBeneficiario dbamv.tiss_sol_guia.tp_ident_beneficiario%TYPE;--OSWALDO
  --
BEGIN
  --
  IF pTpOrigem IS NOT NULL AND pCdOrigem IS NULL THEN
    pMsg := 'N真o h真 guias 真 gerar. Origem da Solicita真真o n真o encontrada.';
    RETURN NULL;
  END IF;
  --
  nCdPrestExtSol:= NULL;
  if pTpOrigem = 'SOLICITACAO' THEN
    OPEN  cTmpSol(pCdOrigem);
    FETCH cTmpSol INTO vcTmpSol;
    CLOSE cTmpSol;
    nCdPrestExtSol:= vcTmpSol.cd_pres_ext;
    --
    --Oswaldo FATURCONV-22468 inicio
    IF vcTmpSol.cd_paciente IS NOT NULL and (Nvl(vcTmpSol.cd_paciente, 0) <> Nvl(vcPaciente.cd_paciente, 0)) THEN
      open  cPaciente(vcTmpSol.cd_paciente, vcTmpSol.CD_CONVENIO, vcTmpSol.cd_con_pla,vcTmpSol.cd_atendimento,NULL,NULL);
      FETCH cPaciente INTO vcPaciente;
      CLOSE cPaciente;
    END IF;
    --Oswaldo FATURCONV-22468 fim
    --
  END IF;
  --
  vcGuia := null;
  if pTpOrigem = 'GUIA' then
    open  cGuia(pCdOrigem,null);
    fetch cGuia into vcGuia;
    close cGuia;
    if vcGuia.cd_guia is not null and vcGuia.cd_atendimento is null then
      if vcGuia.cd_res_lei is not null then
        open  cPreInt(vcGuia.cd_res_lei);
        fetch cPreInt into vcPreInt;
        close cPreInt;
      elsif vcGuia.cd_aviso_cirurgia is not null then
        open  cAviCir(vcGuia.cd_aviso_cirurgia);
        fetch cAviCir into vcAviCir;
        close cAviCir;
        if vcAviCir.cd_paciente is null then
          pMsg := 'Aviso de Cirurgia sem cadastro de Paciente. N真o 真 poss真vel gerar solicita真真o Tiss.';
          RETURN null;
        end if;
      end if;
    end if;
  END IF;
  --
  -- se existir solicita真真o enviada eletronicamente, retorna ela
  -- se existir solicita真真o N真o enviada eletronicamente, apaga para regerar
  vcTissSolGuia := null;
  IF pTpOrigem in ('SOLICITACAO','GUIA') AND Nvl(vcGuia.cd_guia,vcTmpSol.id_sol) IS NOT null THEN
    open  cTissSolGuia(vcTmpSol.id_sol,vcGuia.cd_guia, vcGuia.nr_guia, null); -- pesquisa solicita真真o existente por id (SOLICITACAO) ou por cd_guia (GUIA)
    fetch cTissSolGuia into vcTissSolGuia;
    close cTissSolGuia;
    if vcTissSolGuia.id_pai is not null then
      RETURN LPAD(vcTissSolGuia.id,20,'0')||','; -- se j真 foi solicitada eletr真nicamente, retorna a pr真pria guia
    end if;
    vRet := F_apaga_tiss_sol(null,vcTissSolGuia.id,pMsg,null); -- apaga solicita真真o anterior
    if pMsg is not null then
      RETURN null;
    END IF;
  END IF;
  --
  nCdAtendTmp := Nvl(pCdAtend,vcTmpSol.cd_atendimento);
  --
  -- leitura de cursores de uso geral
  vcAtendimento := null;
  if nCdAtendTmp is not null then
    open  cAtendimento(nCdAtendTmp);
    fetch cAtendimento into vcAtendimento;
    close cAtendimento;
  end if;
  vcConta := null;
  if pCdConta is not null then
    open  cConta(pCdConta,nCdAtendTmp,vcAtendimento.tp_atendimento);
    fetch cConta into vcConta;
    close cConta;
  end if;
  --
  vcCarteira := null;
  if pCdCarteira is not null then
    open  cCarteira(pCdCarteira,null);
    fetch cCarteira into vcCarteira;
    close cCarteira;
  end if;
--if nvl(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa),dbamv.pkg_mv2000.le_empresa) <> nvl(vcHospital.cd_multi_empresa, 0) then
  if nvl(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa),nEmpresaLogada) <> nvl(vcHospital.cd_multi_empresa, 0) THEN --adhospLeEmpresa
  --open cHospital(nvl(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa),dbamv.pkg_mv2000.le_empresa));
    open cHospital(nvl(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa),nEmpresaLogada)); --adhospLeEmpresa
    fetch cHospital into vcHospital;
    close cHospital;
  end if;
  --
  ----------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv           :=  Nvl(nvl(nvl(Nvl(vcCarteira.cd_convenio,vcTmpSol.CD_CONVENIO),vcConta.cd_convenio),vcAtendimento.cd_convenio_atd),vcGuia.cd_convenio);
  pCdPaciente       :=  Nvl(nvl(nvl(nvl(vcCarteira.cd_paciente,vcTmpSol.cd_paciente),vcAtendimento.cd_paciente),vcGuia.cd_paciente),vcAviCir.cd_paciente);
  pCdPrestSolTmp    :=  nvl(nvl(nvl(Nvl(pCdPrestSol,vcTmpSol.cd_prestador),vcPreInt.cd_prestador),vcAviCir.cd_prestador),vcAtendimento.cd_prestador);
  nCdEspecialidTmp  :=  vcTmpSol.cd_especialid;
  nCdConPlaTmp      :=  vcTmpSol.cd_con_pla;
  vTpOrigemSol      :=  pTpOrigem;  -- coloca em global para visualiza真真o de outras CT acionadas dentro desta guia
  vNrIdBeneficiario :=  vcTmpSol.nr_codigo_barras;

  vTpIdentBeneficiario :=  vcTmpSol.tp_ident_beneficiario;--OSWALDO
  -- Quando a origem for M_TISS_SOLICITACAO e o prestador for externo.
  IF nCdPrestExtSol IS NOT NULL AND pTpOrigem in ('SOLICITACAO') THEN
    pCdPrestSolTmp:= NULL;
  END IF;
  ----------------------
  --
  if nvl(vcConv.cd_convenio,9999) <> nvl(pCdConv,0) THEN
    vcConv := NULL;
    open  cConv(pCdConv);
    fetch cConv into vcConv;
    close cConv;
  end if;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  -- Se for prescri真真o, verifica se h真 itens pra gerar guia, caso contr真rio s真i.
  if pTpOrigem = 'PRESCRICAO' then
    --
    open  cTissSolGuiaTpOrigem(nCdAtendTmp,pCdOrigem,'PRESCRICAO');
    fetch cTissSolGuiaTpOrigem into vcTissSolGuiaTpOrigem;
    close cTissSolGuiaTpOrigem;
    -- J真 existe Solicita真真o da prescri真真o, n真o gera novamente;
    if vcTissSolGuiaTpOrigem.id is not null then
      pMsg := 'OK';
      RETURN Null;
    end if;
    --
    if cItensSolProc%isOpen THEN
      close cItensSolProc;
    END IF;
    --
    OPEN  cItensSolProc(pTpOrigem,pCdOrigem,null);
    FETCH cItensSolProc into vcItensSolProc;
    if cItensSolProc%NOTFOUND then
      close cItensSolProc;
      pMsg := 'OK';
      RETURN NULL;
    end if;
  end if;
  --
  --CIMP-4238 - inicio
  vOrigemSolicitacao := NULL;
  if Nvl(pTpOrigem,'XX') = 'PRESCRICAO' then
    vOrigemSolicitacao := 'SOLIC_SP_PRESCRICAO'; --se a solicitacao for do PEP
  else
    vOrigemSolicitacao := 'SOLIC_SP';            --condicao normal
  end if;
  --CIMP-4238 - fim
  --
  LOOP -- somente para casos em que gera +1 guia na mesma chamada como Prescri真真o
    --
    vCp := 'ctm_sp-sadtSolicitacaoGuia'; vTemp := null;
    if tConf(vCp).tp_utilizacao > 0 then
      --
      --
      vJustificativaTmp := null;
      --
      -- cabecalhoSolicitacao--------------------------------------
      IF pTpOrigem = 'GUIA' THEN
        nCdGuiaOrigemTmp  := pCdOrigem;
      elsif pTpOrigem <> 'GUIA' AND vcTissSolGuia.CD_GUIA IS NOT NULL THEN
        nCdGuiaOrigemTmp := vcTissSolGuia.CD_GUIA;
      else
        nCdGuiaOrigemTmp  := NULL;
      END IF;
      vRet := F_ct_guiaCabecalho(null,1533,nCdAtendTmp,pCdConta,pCdConv,nCdGuiaOrigemTmp,'SOL_SPSADT',vCtCabec,pMsg,null);
      if vRet = 'OK' then
        vTissSolGuia.NR_REGISTRO_OPERADORA_ANS   := vCtCabec.registroANS;
        vTissSolGuia.NR_GUIA                     := vCtCabec.numeroGuiaPrestador;
      else
        RETURN NULL;
      end if;
      --
      -- numeroGuiaPrincipal---------------------------------------
      vCp := 'numeroGuiaPrincipal'; vTemp := null;
      if tConf(vCp).tp_utilizacao>0 then
        if pTpOrigem = 'GUIA' then
          vTemp := vcGuia.nr_guia_principal;
        else
          vTemp := null;
        end if;
        vTissSolGuia.NR_GUIA_PRINCIPAL := F_ST(null,vTemp,vCp,pCdConv,nCdAtendTmp,pCdConta,vcGuia.cd_guia,null);
      end if;
      --
      -- ausenciaCodValidacao---------------------------------------
      vCp := 'ausenciaCodValidacao'; vTemp := null; --[tag/Config]--
      if tconf.EXISTS(vCp) AND tConf(vCp).tp_utilizacao>0 then
        vTemp := NULL; --#PEND: Buscar da elegibilidade --OSWALDO
        vTissSolGuia.CD_AUSENCIA_VALIDACAO := F_ST(null,vTemp,vCp,pCdConv,nCdAtendTmp,pCdConta,vcGuia.cd_guia,null);
      end if;
      --
      -- codValidacao---------------------------------------
      vCp := 'codValidacao'; vTemp := null; --[tag/Config]--
      if tconf.EXISTS(vCp) AND tConf(vCp).tp_utilizacao>0 then
        vTemp := null; --#PEND: Buscar da elegibilidade --OSWALDO
        vTissSolGuia.CD_VALIDACAO := F_ST(null,vTemp,vCp,pCdConv,nCdAtendTmp,pCdConta,vcGuia.cd_guia,null);
      end if;
      --
      -- tipoEtapaAutorizacao-----------------------------------
      vCp := 'tipoEtapaAutorizacao'; vTemp := null; --[tag/Config]--
      if tconf.EXISTS(vCp) AND tConf(vCp).tp_utilizacao>0 then
        IF vTissSolGuia.NR_GUIA IS NOT NULL THEN
          vTemp := '2';
        END IF;
        vTissSolGuia.TP_ETAPA_AUTORIZACAO := F_ST(null,vTemp,vCp,pCdConv,nCdAtendTmp,pCdConta,vcGuia.cd_guia,null);
      end if;
      --

      -- dadosBeneficiario-----------------------------------------
      vRet := F_ct_beneficiarioDados(null,1538,nCdAtendTmp,pCdConta,pCdPaciente,pCdConv,'E',vCtBenef,pMsg,'RelerPac'||'#'||Nvl(vcTmpSol.nr_carteira,vcPreInt.nr_carteira));
      if vRet = 'OK' THEN
        vTissSolGuia.NR_CARTEIRA                     := vCtBenef.numeroCarteira;
        vTissSolGuia.SN_ATENDIMENTO_RN               := vCtBenef.atendimentoRN;
        vTissSolGuia.NM_PACIENTE                     := vCtBenef.nomeBeneficiario;
		vTissSolGuia.NM_SOCIAL_PACIENTE              := vCtBenef.nomeSocialBeneficiario; --Oswaldo FATURCONV-26150
        vTissSolGuia.NR_CNS                          := vCtBenef.numeroCNS;
        --OSWALDO IN真CIO
        vTissSolGuia.NR_ID_BENEFICIARIO              := Nvl(vNrIdBeneficiario,vCtBenef.identificadorBeneficiario);
        vTissSolGuia.TP_IDENT_BENEFICIARIO           := Nvl(vTpIdentBeneficiario, vCtBenef.tipoIdent);
        --vTissSolGuia.NR_ID_BENEFICIARIO            := vCtBenef.identificadorBeneficiario;
        --OSWALDO FIM
        --vTissSolGuia.DS_TEMPLATE_IDENT_BENEFICIARIO  := vCtBenef.templateBiometrico; --Oswaldo FATURCONV-22404
      end if;
      --
      -- dadosSolicitante
      -- contratadoSolicitante-------------------------------------
      vRet := F_ct_contratadoDados(null,1544,nCdAtendTmp,pCdConta,null,null,pCdPrestSolTmp,pCdConv,vCtContrat,pMsg,vOrigemSolicitacao); --CIMP-4238 - substituido o parametro para distinguir do PEP
    --vRet := F_ct_contratadoDados(null,1544,nCdAtendTmp,pCdConta,null,null,pCdPrestSolTmp,pCdConv,vCtContrat,pMsg,'SOLIC_SP');
      if vRet = 'OK' then
        vTissSolGuia.CD_OPERADORA             := vCtContrat.codigoPrestadorNaOperadora;
        vTissSolGuia.CD_CPF                   := vCtContrat.cpfContratado;
        vTissSolGuia.CD_CGC                   := vCtContrat.cnpjContratado;
        --vTissSolGuia.NM_PRESTADOR_CONTRATADO  := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 inicio --akiaddchico descomentado
      end if;
      --
      --Oswaldo FATURCONV-22404 inicio
      -- nomeContratadoSolicitante-----------------------------------------
      vCp := 'nomeContratadoSolicitante'; vTemp := null;
      if tConf(vCp).tp_utilizacao>0 then
        vTemp := vCtContrat.nomeContratado;
        vTissSolGuia.NM_PRESTADOR_CONTRATADO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdConta,null,null,null);
      end if;
      --
      --Oswaldo FATURCONV-22404 fim
      -- profissionalSolicitante
      vRet :=F_ct_contratadoProfissionalDad ( null,1550,nCdAtendTmp,pCdConta,pCdPrestSolTmp,pCdConv,vCtContrProf,pMsg,vOrigemSolicitacao); --CIMP-4238 - substituido o parametro para distinguir do PEP
    --vRet :=F_ct_contratadoProfissionalDad ( null,1550,nCdAtendTmp,pCdConta,pCdPrestSolTmp,pCdConv,vCtContrProf,pMsg,'SOLIC_SP');
      if vRet = 'OK' then
        vTissSolGuia.NM_PRESTADOR        := vCtContrProf.nomeProfissional;
        vTissSolGuia.DS_CONSELHO         := vCtContrProf.conselhoProfissional;
        vTissSolGuia.DS_CODIGO_CONSELHO  := vCtContrProf.numeroConselhoProfissional;
        vTissSolGuia.UF_CONSELHO         := vCtContrProf.UF;
        vTissSolGuia.CD_CBOS             := vCtContrProf.CBOS;
      end if;
      --
      -- dadosSolicitacao
      vTissSolGuia.CD_CARATER_SOLICITACAO   := F_dadosSolicitacao('caraterAtendimento',1557,nCdAtendTmp,pCdConta,vcGuia.cd_guia,pCdOrigem,vCtDadosSolic,pMsg,null);
      vTissSolGuia.DH_SOLICITACAO           := F_dadosSolicitacao('dataSolicitacao',1556,nCdAtendTmp,pCdConta,vcGuia.cd_guia,null,vCtDadosSolic,pMsg,null);
      vTissSolGuia.DS_HDA                   := F_dadosSolicitacao('indicacaoClinica',1558,nCdAtendTmp,pCdConta,vcGuia.cd_guia,null,vCtDadosSolic,pMsg,null);
      vTissSolGuia.TP_COBERTURA_ESPECIAL    := F_dadosSolicitacao('indCobEspecial',1558,nCdAtendTmp,pCdConta,vcGuia.cd_guia,null,vCtDadosSolic,pMsg,null); --Oswaldo FATURCONV-22404
      --
--op 46827 - adicionado o reler
dbamv.pkg_ffcv_tiss_v4.f_le_conf(1565,pCdConv,'Reler',null); -- le configuracoes da cadeia do CT (caso ainda nao tenha sido lido no inicio da guia que o chamou)
      -- dadosExecutante
      -- codigonaOperadora-----------------------------------------
      vCp := 'codigonaOperadora'; vTemp := null;
      if tConf(vCp).tp_utilizacao>0 then
        --if NVL(vcEmpresaConv.cd_multi_empresa||vcEmpresaConv.cd_convenio,'XX') <> Nvl(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa),dbamv.pkg_mv2000.le_empresa)||pCdConv then
          if NVL(vcEmpresaConv.cd_multi_empresa||vcEmpresaConv.cd_convenio,'XX') <> Nvl(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa),nEmpresaLogada)||pCdConv THEN --adhospLeEmpresa
          --open  cEmpresaConv(Nvl(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa),dbamv.pkg_mv2000.le_empresa), pCdConv);
            open  cEmpresaConv(Nvl(nvl(vcConta.cd_multi_empresa,vcAtendimento.cd_multi_empresa),nEmpresaLogada), pCdConv); --adhospLeEmpresa
            fetch cEmpresaConv into vcEmpresaConv;
            close cEmpresaConv;
          end if;
          vTemp := vcEmpresaConv.cd_hospital_no_convenio;
        vTissSolGuia.CD_OPERADORA_AUTORIZADO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdConta,null,null,null);
      end if;
      --
      --Oswaldo FATURCONV-22404 inicio      --akichico verificar
      -- nomeContratado--------------------------------------------
      vCp := 'nomeContratado'; vTemp := null;
      --if tConf(vCp).tp_utilizacao>0 then
      IF vcHospital.ds_razao_social IS NOT NULL then
        vTemp := vcHospital.ds_razao_social;
        --vTissSolGuia.NM_PRESTADOR_AUTORIZADO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdConta,null,null,null);
        vTissSolGuia.NM_PRESTADOR_AUTORIZADO := SubStr(vTemp, 1, 70);
      end if;
      --
      --Oswaldo FATURCONV-22404 fim
      -- CNES------------------------------------------------------
      vCp := 'CNES'; vTemp := null;
      if tConf(vCp).tp_utilizacao>0 then
        vTemp := nvl(to_char(vcHospital.nr_cnes),'9999999');
        vTissSolGuia.NR_CNES_AUTORIZADO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdConta,null,null,null);
      end if;
      --
      -- observacao------------------------------------------------
      vCp := 'observacao'; vTemp := null;
      if tConf(vCp).tp_utilizacao>0 then
        if pTpOrigem = 'GUIA' then
          vTemp := substr(vcGuia.ds_observacao,1,1000);
        else
          vTemp := null;
        end if;
        vTissSolGuia.DS_OBSERVACAO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdConta,null,null,null);
      end if;
      --
      -- assinaturaDigital-----------------------------------------
      --vRet := F_assinaturaDigital(null,9999,null,null,null,null,null,null);
      --
      -- informa真真es complementares de apoio
      vTissSolGuia.cd_paciente        := pCdPaciente;
      vTissSolGuia.cd_convenio        := pCdConv;
      vTissSolGuia.cd_atendimento     := nCdAtendTmp;
      vTissSolGuia.dt_emissao         := to_char(sysdate,'yyyy-mm-dd');
      vTissSolGuia.DH_SOLICITADO      := to_date( to_char( sysdate, 'dd/mm/yyyy' ) || ' ' ||to_char( sysdate, 'hh24:mi'    ), 'dd/mm/yyyy hh24:mi' );
      vTissSolGuia.CD_PRESTADOR_SOL   := pCdPrestSolTmp;
      vTissSolGuia.cd_con_pla         := Nvl(nCdConPlaTmp,vcPaciente.cd_con_pla); -- fora de uso, mas obrigat真rio por Constraint
      vTissSolGuia.ds_con_pla         := Nvl(vcPaciente.ds_con_pla,'X'); -- fora de uso, mas obrigat真rio por Constraint
      vTissSolGuia.cd_especialid      := nCdEspecialidTmp;
      vTissSolGuia.dt_validade        := To_Char(vcTmpSol.dt_validade_carteira,'yyyy-mm-dd');
      vTissSolGuia.sn_tratou_retorno  := 'N';
      vTissSolGuia.sn_cancelado       := 'N';
      if vcAtendimento.tp_atendimento = 'I' then
        vTissSolGuia.tp_atendimento := 'S';
      else
        vTissSolGuia.tp_atendimento := 'A';
      end if;
    --vTissSolGuia.cd_multi_empresa   := dbamv.pkg_mv2000.le_empresa;
      vTissSolGuia.cd_multi_empresa   := nEmpresaLogada; --adhospLeEmpresa
      vTissSolGuia.SN_PREVISAO_USO_OPME   := 'N';
      vTissSolGuia.SN_PREVISAO_USO_QUIMIO := 'N';
    --vTissSolGuia.CD_VERSAO_TISS_GERADA  := '3.02.00';
      vTissSolGuia.CD_VERSAO_TISS_GERADA  := Nvl( vcConv.cd_versao_tiss, '3.02.00' );
      vTissSolGuia.TP_ORIGEM_SOL      := pTpOrigem;
      vTissSolGuia.CD_ORIGEM_SOL      := pCdOrigem;
      if nCdGuiaOrigemTmp IS NOT null then
        vTissSolGuia.CD_GUIA := nCdGuiaOrigemTmp;
      end if;
      vTissSolGuia.nm_social_paciente := vcPaciente.nm_social_paciente;  --Oswaldo FATURCONV-22468
      -- Grava真真o
      vResult := F_gravaTissSolGuia('INSERE','SOL_SPSADT',vTissSolGuia,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
      --
      -- procedimentosSolicitados----------------------------------
      if NOT cItensSolProc%isOpen then
        OPEN  cItensSolProc(pTpOrigem,pCdOrigem,null);
        FETCH cItensSolProc into vcItensSolProc;
      end if;
      --
      nLinha := 1; -- controle de linhas para Solicita真真o de prescri真真o
      --
      LOOP
        --
        if cItensSolProc%FOUND then
          --
          -- procedimento------------------------------------------
          vRet := F_ct_procedimentoDados(null,1559,null,null,null,null,vcItensSolProc.cd_pro_fat,pCdConv,'SOL_SPSADT',vCtProcDados,pMsg,null);
          if vRet = 'OK' then
            vTissItSolGuia.TP_TAB_FAT         := vCtProcDados.codigoTabela;
            vTissItSolGuia.CD_PROCEDIMENTO    := vCtProcDados.codigoProcedimento;
            vTissItSolGuia.DS_PROCEDIMENTO    := vCtProcDados.descricaoProcedimento;
          end if;
          --
          -- quantidadeSolicitada----------------------------------
          vCp := 'quantidadeSolicitada'; vTemp := null;
          if tConf(vCp).tp_utilizacao>0 then
            vTemp := vcItensSolProc.QT_ITEM;
            vTissItSolGuia.QT_SOLICITADA := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdConta,null,null,null);
          end if;
          -- informa真真es complementares de apoio
          vTissItSolGuia.id_pai           := vTissSolGuia.ID;
          vTissItSolGuia.cd_itorigem_sol  := vcItensSolProc.CD_IT_ORIGEM;
          vTissItSolGuia.CD_PRO_FAT       := vcItensSolProc.cd_pro_fat;
          vTissItSolGuia.sn_opme          := 'N';
          -- Grava真真o
          vRet := F_gravaTissItSolGuia('INSERE','SOL_SPSADT',vTissItSolGuia,pMsg,null);
          if pMsg is not null then
            RETURN NULL;
          end if;
          --
        end if;
        --
        vcItensSolProcTMP := vcItensSolProc;
        --
        -- acumula justificativas dos itens p/ gravar na guia.
        if vcItensSolProc.ds_justificativa is not null and length(nvl(vJustificativaTmp,0))<400 then
          IF INSTR(Nvl(vJustificativaTmp,'X'),vcItensSolProc.ds_justificativa, 1, 1) = 0 then
            vJustificativaTmp := substr(vJustificativaTmp||vcItensSolProc.ds_justificativa||', ',1,400);
            if length(vJustificativaTmp)=400 then -- se chegar ao m真ximo, coloca "..." para subentender que h真 mais conte真do n真o exibido.
              vJustificativaTmp := substr(vJustificativaTmp,1,397)||'...';
            end if;
          end if;
        END IF;
       --

		-- FATURCONV-5526
		nrLimite := Nvl( FNC_CONF('NR_LIMITE_LINHAS_SPSOL',pCdConv,null), '1');
        IF nrLimite = 1 THEN
          nrLimite:= 9999;
        END IF;


		-- FATURCONV-5526

        FETCH cItensSolProc into vcItensSolProc;
        --
        EXIT WHEN cItensSolProc%NOTFOUND      -- FIM NORMAL (solicita真真o normal ou final da prescri真真o
			OR ( pTpOrigem = 'SOLICITACAO' AND  nLinha >= nrLimite) -- FATURCONV-5526
            OR ( ( pTpOrigem = 'PRESCRICAO'    -- Demais quebras somente da Prescri真真o de exames/procedimentos
            AND ((      vcItensSolProc.TP_PROCEDIMENTO <> nvl(vcItensSolProcTMP.TP_PROCEDIMENTO,'X') )
             or (nvl(vcItensSolProc.CD_SETOR_ITEM,0)<> nvl(vcItensSolProcTMP.CD_SETOR_ITEM,0))
             or (nvl(vcItensSolProc.CD_PEDIDO,0)    <> nvl(vcItensSolProcTMP.CD_PEDIDO,0))
             or
           ( nvl(vcItensSolProc.ds_justificativa,'X') <> nvl(vcItensSolProcTMP.ds_justificativa,'X') )
             or nLinha+1>5 )    ) );
        --
        nLinha := nLinha+1;
        --
      END LOOP;
      --
    end if;
    --
    if pTpOrigem <> 'PRESCRICAO'  AND  pTpOrigem <> 'SOLICITACAO' then
      EXIT;
    else
      --
      -- Atualizar Observa真真o (que acumulou justificativas dos itens)
      if vJustificativaTmp is not null then
        vTissSolGuia.DS_HDA := vJustificativaTmp;

        vRet := F_gravaTissSolGuia('ATUALIZA_HDA','SOL_SPSADT',vTissSolGuia,pMsg,null);
      end if;
      --
      vResultTMP := vResultTMP||vResult;
      vResult := null;
      IF cItensSolProc%NOTFOUND then
        vResult := vResultTMP;
        EXIT;
      end if;
    end if;
    --
  END LOOP;

  close cItensSolProc;
  --

  vRet := F_gravaTissSolGuia('ATUALIZA_INCONSISTENCIA','SOL_SPSADT',vTissSolGuia,pMsg,null);
  if pMsg is not null then
    RETURN NULL;
  end if;
  --
  IF Nvl(pTpOrigem,'X') = 'PRESCRICAO' THEN
    pMsg := 'OK';
  --COMMIT;
  END IF;
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS THEN
      IF cItensSolProc%ISOPEN THEN
        CLOSE cItensSolProc;
      END IF;
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissSolGuia (  pModo           in varchar2,
                                pTpGuia         in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_sol_guia%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
  --
BEGIN
  --
  if pModo = 'INSERE' then
    --
    if pTpGuia = 'SOL_INT' then
      vRg.NM_XML := 'solicitacaoInternacao';
    elsif pTpGuia = 'SOL_SPSADT' then
      vRg.NM_XML := 'solicitacaoSP-SADT';
    elsif pTpGuia = 'SOL_PRORROG' then
      vRg.NM_XML := 'solicitacaoProrrogacao';
    elsif pTpGuia = 'SOL_QUIMIO' then
      vRg.NM_XML := 'anexoSolicitacaoQuimio';
    elsif pTpGuia = 'SOL_RADIO' then
      vRg.NM_XML := 'anexoSolicitacaoRadio';
    elsif pTpGuia = 'SOL_OPME' then
      vRg.NM_XML := 'anexoSolicitacaoOPME';
    end if;
    --
    select dbamv.seq_tiss_sol_guia.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.tiss_sol_guia
        (   id,  id_pai,  nm_xml,  nr_registro_operadora_ans,  cd_prestador_na_operadora,  cd_convenio,  cd_guia,  nr_guia,  dt_emissao,  nr_guia_principal,  nr_carteira,
            nm_paciente,  ds_con_pla,  dt_validade,  nm_titular,  nr_cns,  cd_cgc_cpf,  nm_prestador,  ds_conselho,  ds_codigo_conselho,  uf_conselho,  cd_cbos,
            cd_tipo_logradouro,  ds_endereco,  nr_endereco,  nm_bairro,  nm_cidade,  cd_ibge,  nr_cep,  cd_cgc_cpf_solicitado,  nm_prestador_solicitado,
            cd_carater_solicitacao,  dh_solicitacao,  cd_cid,  tp_cid,  ds_cid,  ds_hda,  cd_tipo_internacao,  tp_doenca,  nr_tempo_doenca,  tp_tempo_doenca,  tp_acidente,
            dt_autorizacao,  cd_senha,  dt_validade_autorizada,  nm_autorizador_conv,  nr_dias_autorizados,  cd_tip_acom,  cd_cgc_cpf_autorizado,  nm_prestador_autorizado,
            nr_cnes_autorizado,  cd_seq_transacao,  sn_tratou_retorno,  nm_hospital,  nr_cgc_hospital,  cd_guia_pai,  tp_guia,  nr_cnes,  tp_regime_internacao,
            qt_diarias_solicitada,  cd_paciente,  dh_solicitado,  dh_retorno,  tp_atendimento_tiss,  cd_prestador_sol,  cd_con_pla,  tp_atendimento,  uf_solicitante,
            cd_cgc,  cd_cpf,  cd_operadora,  ds_observacao,  nr_dias_solicitados,  cd_cgc_autorizado,  cd_cpf_autorizado,  cd_operadora_autorizado,  cd_tipo_logr_autorizado,
            ds_endereco_autorizado,  nm_bairro_autorizado,  nr_endereco_autorizado,  cd_ibge_autorizado,  nm_cidade_autorizado,  cd_uf_autorizado,  nr_cep_autorizado,
            dt_gerou_xml,  cd_atendimento,  cd_especialid,  sn_cancelado,  nr_guia_operadora,  cd_cpf_solicitado,  nm_prestador_contratado,  dt_provavel_admissao,  nr_id_beneficiario,
            cd_status_cancelamento,  cd_multi_empresa,  cd_codigo_contratado,  ds_motivo_negacao,  cd_fonte_pagadora,  tp_origem_sol,  cd_origem_sol,  cd_acom_tiss,  sn_atendimento_rn,
            dt_sugerida_internacao,  sn_previsao_uso_opme,  sn_previsao_uso_quimio,  qt_diarias_autorizadas,  cd_tip_acom_autorizado,
            DS_ESPECIFICACAO_MATERIAL,NR_PESO,NR_ALTURA,NR_SUPERFICIE_CORPORAL,NR_IDADE,TP_SEXO,NR_TELEFONE_PROFISSIONAL,DS_EMAIL_PROFISSIONAL,DT_DIAGNOSTICO
            ,TP_ESTADIAMENTO,TP_QUIMIOTERAPIA,TP_FINALIDADE,TP_ECOG,DS_PLANO_TERAPEUTICO,DS_INFO_RELEVANTES,NR_CICLOS,NR_CICLO_ATUAL,NR_INTERVALO_CICLOS,CD_VERSAO_TISS_GERADA
            ,CD_TUMOR,CD_NODULO,CD_METASTASE,NR_DIAS_CICLO_ATUAL,DS_INCONSISTENCIAS, TP_IDENT_BENEFICIARIO, TP_ETAPA_AUTORIZACAO, tp_cobertura_especial, tp_regime_atendimento,
			tp_saude_ocupacional, nm_social_paciente --Oswaldo FATURCONV-26150
        )
    values
        (   vRg.id, vRg.id_pai, vRg.nm_xml, vRg.nr_registro_operadora_ans, vRg.cd_prestador_na_operadora, vRg.cd_convenio, vRg.cd_guia, vRg.nr_guia, vRg.dt_emissao, vRg.nr_guia_principal, vRg.nr_carteira,
            vRg.nm_paciente, vRg.ds_con_pla, vRg.dt_validade, vRg.nm_titular, vRg.nr_cns, vRg.cd_cgc_cpf, vRg.nm_prestador, vRg.ds_conselho, vRg.ds_codigo_conselho, vRg.uf_conselho, vRg.cd_cbos,
            vRg.cd_tipo_logradouro, vRg.ds_endereco, vRg.nr_endereco, vRg.nm_bairro, vRg.nm_cidade, vRg.cd_ibge, vRg.nr_cep, vRg.cd_cgc_cpf_solicitado, vRg.nm_prestador_solicitado,
            vRg.cd_carater_solicitacao, vRg.dh_solicitacao, vRg.cd_cid, vRg.tp_cid, vRg.ds_cid, vRg.ds_hda, vRg.cd_tipo_internacao, vRg.tp_doenca, vRg.nr_tempo_doenca, vRg.tp_tempo_doenca, vRg.tp_acidente,
            vRg.dt_autorizacao, vRg.cd_senha, vRg.dt_validade_autorizada, vRg.nm_autorizador_conv, vRg.nr_dias_autorizados, vRg.cd_tip_acom, vRg.cd_cgc_cpf_autorizado, vRg.nm_prestador_autorizado,
            vRg.nr_cnes_autorizado, vRg.cd_seq_transacao, vRg.sn_tratou_retorno, vRg.nm_hospital, vRg.nr_cgc_hospital, vRg.cd_guia_pai, vRg.tp_guia, vRg.nr_cnes, vRg.tp_regime_internacao,
            vRg.qt_diarias_solicitada, vRg.cd_paciente, vRg.dh_solicitado, vRg.dh_retorno, vRg.tp_atendimento_tiss, vRg.cd_prestador_sol, vRg.cd_con_pla, vRg.tp_atendimento, vRg.uf_solicitante,
            vRg.cd_cgc, vRg.cd_cpf, vRg.cd_operadora, vRg.ds_observacao, vRg.nr_dias_solicitados, vRg.cd_cgc_autorizado, vRg.cd_cpf_autorizado, vRg.cd_operadora_autorizado, vRg.cd_tipo_logr_autorizado,
            vRg.ds_endereco_autorizado, vRg.nm_bairro_autorizado, vRg.nr_endereco_autorizado, vRg.cd_ibge_autorizado, vRg.nm_cidade_autorizado, vRg.cd_uf_autorizado, vRg.nr_cep_autorizado,
            vRg.dt_gerou_xml, vRg.cd_atendimento, vRg.cd_especialid, vRg.sn_cancelado, vRg.nr_guia_operadora, vRg.cd_cpf_solicitado, vRg.nm_prestador_contratado, vRg.dt_provavel_admissao, vRg.nr_id_beneficiario,
            vRg.cd_status_cancelamento, vRg.cd_multi_empresa, vRg.cd_codigo_contratado, vRg.ds_motivo_negacao, vRg.cd_fonte_pagadora, vRg.tp_origem_sol, vRg.cd_origem_sol, vRg.cd_acom_tiss, vRg.sn_atendimento_rn,
            vRg.dt_sugerida_internacao, vRg.sn_previsao_uso_opme, vRg.sn_previsao_uso_quimio, vRg.qt_diarias_autorizadas, vRg.cd_tip_acom_autorizado,
            vRg.DS_ESPECIFICACAO_MATERIAL,vRg.NR_PESO,vRg.NR_ALTURA,vRg.NR_SUPERFICIE_CORPORAL,vRg.NR_IDADE,vRg.TP_SEXO,vRg.NR_TELEFONE_PROFISSIONAL,vRg.DS_EMAIL_PROFISSIONAL,vRg.DT_DIAGNOSTICO
            ,vRg.TP_ESTADIAMENTO,vRg.TP_QUIMIOTERAPIA,vRg.TP_FINALIDADE,vRg.TP_ECOG,vRg.DS_PLANO_TERAPEUTICO,vRg.DS_INFO_RELEVANTES,vRg.NR_CICLOS,vRg.NR_CICLO_ATUAL,vRg.NR_INTERVALO_CICLOS, vRg.CD_VERSAO_TISS_GERADA
            ,vRg.CD_TUMOR,vRg.CD_NODULO,vRg.CD_METASTASE,vRg.NR_DIAS_CICLO_ATUAL,vRg.DS_INCONSISTENCIAS, vRg.tp_ident_beneficiario, vRg.TP_ETAPA_AUTORIZACAO, vRg.tp_cobertura_especial, vRg.tp_regime_atendimento,
			vRg.tp_saude_ocupacional, vRg.nm_social_paciente);--Oswaldo FATURCONV-26150
    --
  elsif pModo = 'ATUALIZA_ID' then
    Update dbamv.tiss_sol_guia SET
        ID_PAI  = vRg.id_pai
      where id = vRg.id;
  elsif pModo = 'ATUALIZA_ESPEC' then
    Update dbamv.tiss_sol_guia SET
        DS_ESPECIFICACAO_MATERIAL  = vRg.DS_ESPECIFICACAO_MATERIAL
      where id = vRg.id;
  elsif pModo = 'ATUALIZA_HDA' then
    Update dbamv.tiss_sol_guia SET
        DS_HDA = vRg.DS_HDA
      where id = vRg.id;
  elsif pModo = 'ATUALIZA_INCONSISTENCIA' THEN
    --
    IF vPendenciaGuia IS NOT NULL THEN
      Update dbamv.tiss_sol_guia SET
       DS_INCONSISTENCIAS = vPendenciaGuia
      where id = vRg.id;
    END IF;
    --
  end if;
  --
  RETURN LPAD(vRg.id,20,'0')||',';
  --
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar '||vRg.NM_XML||'. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_SOL_GUIA:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissItSolGuia (pModo           in varchar2,
                                pTpGuia         in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_itsol_guia%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
BEGIN
  --
  if pModo = 'INSERE' then
    --
    if pTpGuia = 'SOL_INT' then
      vRg.NM_XML := 'solicitacaoInternacao.procedimentosSolicitados';
    elsif pTpGuia = 'SOL_SPSADT' then
      vRg.NM_XML := 'solicitacaoSP-SADT.procedimentosSolicitados';
    elsif pTpGuia = 'SOL_PRORROG' then
      vRg.NM_XML := 'solicitacaoProrrogacao.procedimentosSolicitados';
    elsif pTpGuia = 'SOL_QUIMIO' then
      vRg.NM_XML := 'anexoSolicitacaoQuimio.drogaSolicitada';
    elsif pTpGuia = 'SOL_RADIO' then
      vRg.NM_XML := 'anexoSolicitacaoRadio.procedimentoComplementar';
    elsif pTpGuia = 'SOL_OPME' then
      vRg.NM_XML := 'anexoSolicitacaoOPME.opmeSolicitada';
    end if;
    --
    select dbamv.seq_tiss_sol_guia.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.tiss_itsol_guia
    ( id, id_pai, tp_tab_fat, cd_procedimento, ds_procedimento, qt_solicitada, qt_autorizada, cd_pro_fat, sn_opme
    , nm_fabricante_op , vl_unitario, nm_xml, ds_motivo_negacao, ds_observacao, cd_itorigem_sol
    , dt_provavel, qt_doses, tp_via_administracao, nr_registro_anvisa, ds_codigo_ref_fabricante, nr_autorizacao_funcionamento, nr_frequencia, CD_UNIDADE_MEDIDA
    )
    values
    ( vRg.id, vRg.id_pai, vRg.tp_tab_fat, vRg.cd_procedimento, vRg.ds_procedimento, vRg.qt_solicitada, vRg.qt_autorizada, vRg.cd_pro_fat, vRg.sn_opme
    , vRg.nm_fabricante_op , vRg.vl_unitario, vRg.nm_xml, vRg.ds_motivo_negacao, vRg.ds_observacao, vRg.cd_itorigem_sol
    , vRg.dt_provavel, vRg.qt_doses, vRg.tp_via_administracao, vRg.nr_registro_anvisa, vRg.ds_codigo_ref_fabricante, vRg.nr_autorizacao_funcionamento, vRg.nr_frequencia, vRg.CD_UNIDADE_MEDIDA
    );
    --
  end if;
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar o servico '||vRg.cd_procedimento||'. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_ITSOL_GUIA:'||SQLERRM;
      RETURN NULL;
  --
END;
--

FUNCTION  F_gravaTissItSolGuiaTratAnt (pModo           in varchar2,
                                       pTpGuia         in varchar2,
                                       vRg             in OUT NOCOPY dbamv.TISS_ITSOL_GUIA_TRAT_ANTERIOR%rowtype,
                                       pMsg            OUT varchar2,
                                       pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
BEGIN
  --
  if pModo = 'INSERE' then
    --
    select dbamv.seq_tiss_sol_guia.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.tiss_itsol_guia_trat_anterior
    ( id, id_pai, tp_tratamento, tp_historico, ds_historico, dt_historico
    )
    values
    ( vRg.id, vRg.id_pai,
      vRg.tp_tratamento,               --Indica o tipo de tratamento, se Quimioterapia Q ou Radiotarapia R
      vRg.tp_historico,                --Tipo de tratamento anterior (C Cirurgia, Q Quimioterapia, R Radioterapia)
      SubStr( vRg.ds_historico,1,100), --Cirurgia / historico de Quimio / historico de Radio
      vRg.dt_historico                 --Data de realiza真真o / Data de aplicacao
    );
    --
  end if;
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_ITSOL_GUIA_TRAT_ANTERIOR:'||SQLERRM;
      RETURN NULL;
  --
END;


--==================================================
FUNCTION  F_ctm_internacaoSolicitacaoGui  ( pModo       in varchar2,
                                            pIdMap      in number,
                                            pCdAtend    in dbamv.atendime.cd_atendimento%type,          --  <- opt 1
                                            pCdConta    in dbamv.reg_amb.cd_reg_amb%type,               --  <- opt 1
				                                    pCdCarteira in number,-- dbamv.carteira.cd_carteira%type    --  <- opt 2
				                                    pCdPrestSol in dbamv.prestador.cd_prestador%type,   	      --  <- opt 1,2
				                                    pCdOrigem	  in number,                                      --  <- opt 2,3
                                            pTpOrigem	  in varchar2,                                    --  <- opt 2,3
                                            pMsg        OUT varchar2,
                                            pReserva    in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(1000);
  vCp	            varchar2(1000);
  vRet              varchar2(1000);
  vcItensSolInt     cItensSolInt%rowtype;
  vTissSolGuia      dbamv.tiss_sol_guia%rowtype;
  vTissItSolGuia    dbamv.tiss_itsol_guia%rowtype;
  pCdConv           dbamv.convenio.cd_convenio%type;
  pCdPaciente       dbamv.paciente.cd_paciente%type;
  vCtProcDados      RecProcDados;
  vCtAutorizSadt    RecAutorizSadt;
  vCtBenef          RecBenef;
  vCtCabec          RecCabec;
  vCtContrat        RecContrat;
  vCtContrProf      RecContrProf;
  vCtDadosSolic     RecDadosSolicitacao;
  vcPreInt          cPreInt%rowtype;
  vcAviCir          cAviCir%rowtype;
  --
  vTussRel          RecTussRel;
  vTuss             RecTuss;
  vTpOrigemTmp      varchar2(100);
  nCdOrigemTmp      number;
  pCdPrestSolTmp    dbamv.prestador.cd_prestador%type;
  pCdAtendTmp       dbamv.atendime.cd_atendimento%TYPE;
  vcTmpSol          cTmpSol%ROWTYPE;
  vDiasSolicitadosTmp cDiasSolicitadosTmp%ROWTYPE;
  nCdEspecialidTmp  dbamv.especialid.cd_especialid%TYPE;
  --
  vNrIdBeneficiario dbamv.tiss_sol_guia.nr_id_beneficiario%TYPE;
  vTpIdentBeneficiario dbamv.tiss_sol_guia.tp_ident_beneficiario%TYPE;
  vReserva          VARCHAR2(200); -- Oswaldo BH
  vCdTipoInt        NUMBER;
  vTpIntMeioMag     varchar2(10);
  --
BEGIN
  --
  IF pTpOrigem IS NOT NULL THEN
    vReserva := pTpOrigem||'@'; --Oswaldo FATURCONV-22468
  END IF;
  if pTpOrigem = 'SOLICITACAO' then
    OPEN  cTmpSol(pCdOrigem);
    FETCH cTmpSol INTO vcTmpSol;
    CLOSE cTmpSol;
    --
    --Oswaldo FATURCONV-22468 inicio
    IF vcTmpSol.cd_paciente IS NOT NULL and (Nvl(vcTmpSol.cd_paciente, 0) <> Nvl(vcPaciente.cd_paciente, 0)) THEN
      open  cPaciente(vcTmpSol.cd_paciente, vcTmpSol.CD_CONVENIO, vcTmpSol.cd_con_pla,vcTmpSol.cd_atendimento,NULL,NULL);
      FETCH cPaciente INTO vcPaciente;
      CLOSE cPaciente;
    END IF;
    --Oswaldo FATURCONV-22468 fim
    --
  END IF;
  --
  pCdAtendTmp := Nvl(pCdAtend,vcTmpSol.cd_atendimento);
  --
  -- leitura de cursores de uso geral
  vcAtendimento := null;
  if pCdAtendTmp is not null then
    open  cAtendimento(pCdAtendTmp);
    fetch cAtendimento into vcAtendimento;
    close cAtendimento;
  end if;
  vcConta := null;
  if pCdConta is not null then
    open  cConta(pCdConta,pCdAtendTmp,vcAtendimento.tp_atendimento);
    fetch cConta into vcConta;
    close cConta;
  end if;
  vcCarteira := null;
  if pCdCarteira is not null then
    open  cCarteira(pCdCarteira,null);
    fetch cCarteira into vcCarteira;
    close cCarteira;
  end if;
  --
  vcTissSolGuia := null;
  IF pTpOrigem in ('SOLICITACAO','GUIA') THEN
    vcGuia      := null;
	vReserva := pTpOrigem||'@';
    if pTpOrigem = 'GUIA' then
      open  cGuia(pCdOrigem,null);
      fetch cGuia into vcGuia;
      close cGuia;
      if vcGuia.cd_guia is not null and vcGuia.cd_atendimento is null then
        if vcGuia.cd_res_lei is not null then
          open  cPreInt(vcGuia.cd_res_lei);
          fetch cPreInt into vcPreInt;
          close cPreInt;
          IF pCdOrigem IS NOT NULL then
            vReserva := pTpOrigem||'@'||pCdOrigem; -- Oswaldo BH
          ELSE
            vReserva := pTpOrigem; -- Oswaldo BH
          END IF;
          vCdTipoInt :=  vcPreInt.cd_tipo_internacao;
          --OP 46693
          if vcPreInt.cd_paciente is null then
            pMsg := 'Pr真-Interna真真o sem cadastro de Paciente. N真o 真 poss真vel gerar solicita真真o Tiss.';
            RETURN null;
          end if;

        elsif vcGuia.cd_aviso_cirurgia is not null then
          open  cAviCir(vcGuia.cd_aviso_cirurgia);
          fetch cAviCir into vcAviCir;
          close cAviCir;
          if vcAviCir.cd_paciente is null then
            pMsg := 'Aviso de Cirurgia sem cadastro de Paciente. N真o 真 poss真vel gerar solicita真真o Tiss.';
            RETURN null;
          end if;
        end if;
      end if;
    END IF;
    vcTissSolGuia := null;
    open  cTissSolGuia(vcTmpSol.id_sol,vcGuia.cd_guia, vcGuia.nr_guia, null);
    fetch cTissSolGuia into vcTissSolGuia;
    close cTissSolGuia;
    if vcTissSolGuia.id_pai is not null then
      RETURN LPAD(vcTissSolGuia.id,20,'0')||','; -- se j真 foi solicitada eletr真nicamente, retorna a pr真pria guia
    else
      vRet := F_apaga_tiss_sol(null,vcTissSolGuia.id,pMsg,null); -- cancela solicita真真o anterior para sincronizar com Guia
      if pMsg is not null then
        RETURN null;
      end if;
    end if;
  end if;
  --
  ------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv           :=  nvl(nvl(Nvl(vcCarteira.cd_convenio,vcTmpSol.CD_CONVENIO),nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd)),vcGuia.cd_convenio);
  pCdPaciente       :=  nvl(nvl(nvl(Nvl(vcCarteira.cd_paciente,vcTmpSol.cd_paciente),vcAtendimento.cd_paciente),vcGuia.cd_paciente),vcAviCir.cd_paciente);
  vTpOrigemTmp      :=  nvl(pTpOrigem,'INTERNACAO');
  nCdOrigemTmp      :=  nvl(pCdOrigem,vcAtendimento.cd_atendimento);
  pCdPrestSolTmp    :=  nvl(nvl(Nvl(pCdPrestSol,vcTmpSol.cd_prestador),vcPreInt.cd_prestador),vcAviCir.cd_prestador);
  vTpOrigemSol      :=  NULL;
  nCdEspecialidTmp  :=  vcTmpSol.cd_especialid;
  vNrIdBeneficiario :=  vcTmpSol.nr_codigo_barras;
  vTpIdentBeneficiario :=  vcTmpSol.tp_ident_beneficiario;--OSWALDO
  ------------------------------------------------------

  if nvl(vcConv.cd_convenio,9999) <> nvl(pCdConv,0) THEN
    vcConv := NULL;
    open  cConv(pCdConv);
    fetch cConv into vcConv;
    close cConv;

  end if;
  --


  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)


  --
  vCp := 'ctm_internacaoSolicitacaoGuia'; vTemp := null;
  if tConf(vCp).tp_utilizacao > 0 then
    --
    -- registroANS--------------------------------------
    vCp := 'registroANS';
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcConv.nr_registro_operadora_ans;
      vTissSolGuia.NR_REGISTRO_OPERADORA_ANS := F_ST(null,vTemp,vCp,pCdConv,pCdAtendTmp,pCdConta,null,null);
    end if;
    --
    -- numeroGuiaPrestador------------------------------
    vCp := 'numeroGuiaPrestador'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vTpOrigemTmp = 'GUIA' and vcGuia.nr_guia is not null then
          vTemp := vcGuia.nr_guia;
        ELSE
        --vTemp := fnc_retornar_guia_faixa ( pCdConv,dbamv.pkg_mv2000.le_empresa,'I',vcAtendimento.cd_paciente,pMsg);
          vTemp := fnc_retornar_guia_faixa ( pCdConv,nEmpresaLogada,'I',vcAtendimento.cd_paciente,pMsg); --adhospLeEmpresa
          if pMsg is not null then
            RETURN NULL;
          end if;
        end if;
      vTissSolGuia.NR_GUIA := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- codValidacao------------------------------
    vCp := 'codValidacao'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := null; --#PEND: Pegar da elegibilidade --OSWALDO
      vTissSolGuia.CD_VALIDACAO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- ausenciaCodValidacao------------------------------
    vCp := 'ausenciaCodValidacao'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      vTemp := null;  --#PEND: Pegar da elegibilidade --OSWALDO
      vTissSolGuia.CD_AUSENCIA_VALIDACAO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- tipoEtapaAutorizacao------------------------------
    vCp := 'tipoEtapaAutorizacao'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
      IF vTissSolGuia.NR_GUIA IS NOT NULL THEN
        vTemp := '2';
      END IF;
      vTissSolGuia.TP_ETAPA_AUTORIZACAO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --

    -- dadosBeneficiario--------------------------------
    vRet := F_ct_beneficiarioDados(null,1577,pCdAtendTmp,pCdConta,pCdPaciente,pCdConv,'E',vCtBenef,pMsg,'RelerPac'||'#'||Nvl(vcTmpSol.nr_carteira,vcPreInt.nr_carteira));
    if vRet = 'OK' then
      vTissSolGuia.NR_CARTEIRA                     := vCtBenef.numeroCarteira;
      vTissSolGuia.SN_ATENDIMENTO_RN               := vCtBenef.atendimentoRN;
      vTissSolGuia.NM_PACIENTE                     := vCtBenef.nomeBeneficiario;
	  vTissSolGuia.NM_SOCIAL_PACIENTE              := vCtBenef.nomeSocialBeneficiario; --Oswaldo FATURCONV-26150
      vTissSolGuia.NR_CNS                          := vCtBenef.numeroCNS;
      vTissSolGuia.TP_IDENT_BENEFICIARIO           := Nvl(vTpIdentBeneficiario, vCtBenef.tipoIdent);
      vTissSolGuia.NR_ID_BENEFICIARIO              := Nvl(vNrIdBeneficiario, vCtBenef.identificadorBeneficiario);
      --vTissSolGuia.DS_TEMPLATE_IDENT_BENEFICIARIO  := vCtBenef.templateBiometrico; --Oswaldo FATURCONV-22404
    end if;
    --
    -- identificacaoSolicitante
    -- dadosDoContratado--------------------------------
    vRet := F_ct_contratadoDados(null,1583,pCdAtendTmp,pCdConta,null,null,null,pCdConv,vCtContrat,pMsg,'INTER#'||vReserva); -- Oswaldo BH
    if vRet = 'OK' then
      vTissSolGuia.CD_OPERADORA             := vCtContrat.codigoPrestadorNaOperadora;
      vTissSolGuia.CD_CPF                   := vCtContrat.cpfContratado;
      vTissSolGuia.CD_CGC                   := vCtContrat.cnpjContratado;
      vTissSolGuia.NM_PRESTADOR_CONTRATADO  := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 inicio
    end if;
    --
    -- profissionalSolicitante
    vRet :=F_ct_contratadoProfissionalDad ( null,1589,pCdAtendTmp,pCdConta,pCdPrestSolTmp,pCdConv,vCtContrProf,pMsg,null);
    if vRet = 'OK' then
      vTissSolGuia.NM_PRESTADOR        := vCtContrProf.nomeProfissional;
      vTissSolGuia.DS_CONSELHO         := vCtContrProf.conselhoProfissional;
      vTissSolGuia.DS_CODIGO_CONSELHO  := vCtContrProf.numeroConselhoProfissional;
      vTissSolGuia.UF_CONSELHO         := vCtContrProf.UF;
      vTissSolGuia.CD_CBOS             := vCtContrProf.CBOS;
    end if;
    --
    -- dadosHospitalSolicitado--------------------------
    --
    -- codigoIndicadonaOperadora
    vCp := 'codigoIndicadonaOperadora'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then

        vTemp := dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_contratadoDados','codigoIndicadonaOperadora',1595,pCdAtendTmp,pCdConta,null,null,null,pCdConv,'SOLIC_INT#'||vReserva); -- CIMP-4580 -- Oswaldo BH
      vTissSolGuia.CD_OPERADORA_AUTORIZADO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- nomeContratadoIndicado
    vCp := 'nomeContratadoIndicado'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then

        vTemp := dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_contratadoDados','nomeContratadoIndicado',1595,pCdAtendTmp,pCdConta,null,null,null,pCdConv,'SOLIC_INT#'||vReserva); -- CIMP-4580 -- Oswaldo BH
      vTissSolGuia.NM_PRESTADOR_AUTORIZADO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- dataSugeridaInternacao
    vCp := 'dataSugeridaInternacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        if pTpOrigem = 'GUIA' and vcPreInt.dt_prev_internacao is not null then
          vTemp := vcPreInt.dt_prev_internacao;
        elsif vcAtendimento.tp_atendimento = 'I' then
          vTemp := vcAtendimento.dt_atendimento;
        else
          vTemp := null;
        end if;
      vTissSolGuia.DT_SUGERIDA_INTERNACAO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- dadosInternacao----------------------------------
    -- caraterAtendimento
    vCp := 'caraterAtendimento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
        IF vcAtendimento.tp_carater_internacao IS null then
         vTemp := f_retorna_campo_tiss(nEmpresaLogada,vcAtendimento.cd_convenio_atd,vcAtendimento.tp_atendimento,vcAtendimento.cd_ori_ate,
                                       vcAtendimento.cd_pro_int,'TP_CARATER_INTERNACAO',vcAtendimento.dt_atendPac);
        END IF;
        IF vtemp IS NULL THEN
         if vcAtendimento.tp_carater_internacao in ('U','2') then
           vTemp := '2';
         else
           vTemp := '1';
         end if;
        END IF;
      --vTussRel.tp_atendimento := nvl(vcAtendimento.tp_atendimento,'I');
      --vTemp := F_DM(23,pCdAtendTmp,pCdConta,null,null,vTussRel,vTuss,pMsg,null);
      --vTemp := vTuss.CD_TUSS;
      vTissSolGuia.CD_CARATER_SOLICITACAO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);  -- dm_caraterAtendimento
    end if;
    --
    -- tipoInternacao
    vCp := 'tipoInternacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --FUTURO RELACIONAMENTO COM A TELA (Terminologia 57)
        --vTemp := F_DM(57,null,null,null,null,vTussRel,vTuss,pMsg,null);
        --vTemp := vTuss.CD_TUSS;
        if nvl(vcAprTiss.cd_apr_tiss, 0) = 0 then
          open  cAprTiss(NULL);
          fetch cAprTiss into vcAprTiss;
          close cAprTiss;
        end if;
        if NVL(vcAtendimentoMag.cd_atendimento||vcAtendimentoMag.cd_apr_conta_meio_mag,'XX')<>pCdAtendTmp||vcAprTiss.cd_apr_tiss then
          open  cAtendimentoMag(pCdAtendTmp, vcAprTiss.cd_apr_tiss);
          fetch cAtendimentoMag into vcAtendimentoMag;
          close cAtendimentoMag;
        end if;
		IF(vcAtendimentoMag.cd_tip_int_meio_mag IS null and vCdTipoInt is not null) THEN
          OPEN  cTipInternacao(vcAprTiss.cd_apr_tiss, vCdTipoInt);
          FETCH cTipInternacao INTO vTpIntMeioMag ;
          CLOSE cTipInternacao;
          vTemp :=Nvl(vTpIntMeioMag,'1');
        ELSE
        vTemp := nvl(vcAtendimentoMag.cd_tip_int_meio_mag,'1');
		END IF;
      vTissSolGuia.CD_TIPO_INTERNACAO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- regimeInternacao
    vCp := 'regimeInternacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTussRel.tp_atendimento := vcAtendimento.tp_atendimento_original;
		--
		-- Oswaldo BH in真cio
		--SUP-273226 Acrescentado essa linha para que o campo seja preechido no fluxo de pr真-interna真真o e retorne registro no cursor cTuss
        vTussRel.cd_tip_acom := vcPreInt.cd_tip_acom;
		-- Oswaldo BH fim
		--
        vTemp := F_DM(41,pCdAtendTmp,pCdConta,null,null,vTussRel,vTuss,pMsg,null);
        vTemp := vTuss.CD_TUSS;
      vTissSolGuia.TP_REGIME_INTERNACAO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- qtDiariasSolicitadas
    vCp := 'qtDiariasSolicitadas'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vTpOrigemTmp = 'GUIA' then
          vTemp := nvl( vcGuia.nr_dias_solicitados, 0 );
        ELSIF vTpOrigemTmp = 'SOLICITACAO' then
          OPEN  cDiasSolicitadosTmp(vcTmpSol.id_tmp);
          FETCH cDiasSolicitadosTmp INTO vDiasSolicitadosTmp;
          CLOSE cDiasSolicitadosTmp;
          vTemp := Nvl(vDiasSolicitadosTmp.qt_diarias,0);
        else
          vTemp := null;
        end if;
      vTissSolGuia.QT_DIARIAS_SOLICITADA := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- indicadorOPME
    vCp := 'indicadorOPME'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := null;   -- ??? PENDENTE
      vTissSolGuia.SN_PREVISAO_USO_OPME := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- indicadorQuimio
    vCp := 'indicadorQuimio'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := null;   -- ??? PENDENTE
      vTissSolGuia.SN_PREVISAO_USO_QUIMIO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- indicacaoClinica
    vCp := 'indicacaoClinica'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
        if vTpOrigemTmp = 'GUIA' then
          vTemp := vcGuia.ds_justificativa;
        else
          vTemp := null;
        end if;
      vTissSolGuia.DS_HDA := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- hipotesesDiagnosticas----------------------------
    -- PENDENTE:  apenas o diagn真stico principal. Implementar demais em tabela j真 existe de CID
    -- diagnosticoCID
    vCp := 'diagnosticoCID'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vTpOrigemTmp = 'GUIA' then
          vTemp := nvl(nvl(vcAtendimento.cd_cid,vcPreInt.cd_cid),vcAviCir.cd_cid);
        ELSIF vTpOrigemTmp = 'SOLICITACAO' then
          vTemp := vcTmpSol.cd_cid_principal;
        else
          vTemp := null;
        end if;
      vTissSolGuia.CD_CID := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- indicadorAcidente
    vCp := 'indicadorAcidente'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      --FUTURO RELACIONAMENTO COM A TELA (Terminologia 36)
      --vTemp := F_DM(36,null,null,null,null,vTussRel,vTuss,pMsg,null);
      --vTemp := vTuss.CD_TUSS;
        vTemp := nvl( vcAtendimento.tp_acidente_tiss, '9');
      vTissSolGuia.TP_ACIDENTE := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- dataSolicitacao----------------------------------
    vCp := 'dataSolicitacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if vTpOrigemTmp = 'GUIA' then
          vTemp := To_Char(vcGuia.dt_solicitacao,'yyyy-mm-dd'); --Oswaldo 09/12
        ELSIF vTpOrigemTmp = 'SOLICITACAO' then
          vTemp := To_Char(vcTmpSol.dt_solicitacao,'yyyy-mm-dd');
        else
          vTemp :=  to_char( sysdate, 'yyyy-mm-dd' );
        end if;
      vTissSolGuia.DH_SOLICITACAO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- observacao---------------------------------------
    vCp := 'observacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        if vTpOrigemTmp = 'GUIA' then
          vTemp := substr(vcGuia.ds_observacao,1,1000);
        else
          vTemp := null;
        end if;
      vTissSolGuia.DS_OBSERVACAO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- assinaturaDigital--------------------------------
    --vRet := F_assinaturaDigital(null,9999,null,null,null,null,null,null);
    --
    -- informa真真es complementares de apoio
    vTissSolGuia.cd_paciente        := pCdPaciente;
    vTissSolGuia.cd_convenio        := pCdConv;
    vTissSolGuia.cd_atendimento     := pCdAtendTmp;
    vTissSolGuia.dt_emissao         := to_char(sysdate,'yyyy-mm-dd');
    vTissSolGuia.CD_PRESTADOR_SOL   := pCdPrestSolTmp;
    vTissSolGuia.cd_con_pla         := Nvl(vcPaciente.cd_con_pla,nvl(vcAtendimento.cd_con_pla,vcPreInt.cd_con_pla)); -- fora de uso, mas obrigat真rio por Constraint
    vTissSolGuia.ds_con_pla         := Nvl(vcPaciente.ds_con_pla,'X'); -- fora de uso, mas obrigat真rio por Constraint
    vTissSolGuia.sn_tratou_retorno  := 'N';
    vTissSolGuia.sn_cancelado       := 'N';
    vTissSolGuia.dt_validade        := To_Char(vcTmpSol.dt_validade_carteira,'yyyy-mm-dd');
  --vTissSolGuia.cd_multi_empresa   := dbamv.pkg_mv2000.le_empresa;
    vTissSolGuia.cd_multi_empresa   := nEmpresaLogada; --adhospLeEmpresa
    vTissSolGuia.tp_atendimento     := 'I';
    vTissSolGuia.SN_PREVISAO_USO_OPME   := 'N';
    vTissSolGuia.SN_PREVISAO_USO_QUIMIO := 'N';
  --vTissSolGuia.CD_VERSAO_TISS_GERADA  := '3.02.00';
    vTissSolGuia.CD_VERSAO_TISS_GERADA  := Nvl( vcConv.cd_versao_tiss, '3.02.00' );
    vTissSolGuia.TP_ORIGEM_SOL      := vTpOrigemTmp;
    vTissSolGuia.CD_ORIGEM_SOL      := nCdOrigemTmp;
    vTissSolGuia.DH_SOLICITADO      := to_date( to_char( sysdate, 'dd/mm/yyyy' ) || ' ' ||to_char( sysdate, 'hh24:mi'    ), 'dd/mm/yyyy hh24:mi' );
    vTissSolGuia.cd_especialid      := nCdEspecialidTmp;
    if vTpOrigemTmp = 'GUIA' then
      vTissSolGuia.CD_GUIA := nCdOrigemTmp;
    end if;
    vTissSolGuia.nm_social_paciente := vcPaciente.nm_social_paciente; --Oswaldo FATURCONV-22468
    --
    -- Grava真真o
    vResult := F_gravaTissSolGuia('INSERE','SOL_INT',vTissSolGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
    -- procedimentosSolicitados-------------------------
    OPEN  cItensSolInt(vTpOrigemTmp,nCdOrigemTmp,null);
    --
    LOOP
      --
      FETCH cItensSolInt into vcItensSolInt;
      EXIT WHEN cItensSolInt%NOTFOUND;
      --
      if cItensSolInt%FOUND then
        --
        -- procedimento---------------------------------
        vRet := F_ct_procedimentoDados(null,1610,null,null,null,null,vcItensSolInt.cd_pro_fat,pCdConv,'SOL_INT',vCtProcDados,pMsg,null);
        if vRet = 'OK' then
          vTissItSolGuia.TP_TAB_FAT         := vCtProcDados.codigoTabela;
          vTissItSolGuia.CD_PROCEDIMENTO    := vCtProcDados.codigoProcedimento;
          vTissItSolGuia.DS_PROCEDIMENTO    := vCtProcDados.descricaoProcedimento;
        end if;
        --
        -- quantidadeSolicitada-------------------------
        vCp := 'quantidadeSolicitada'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
          vTemp := vcItensSolInt.QT_ITEM;
          vTissItSolGuia.QT_SOLICITADA := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
        end if;
        -- informa真真es complementares de apoio
        vTissItSolGuia.id_pai           := vTissSolGuia.ID;
        vTissItSolGuia.cd_itorigem_sol  := vcItensSolInt.CD_IT_ORIGEM;
        vTissItSolGuia.CD_PRO_FAT       := vcItensSolInt.cd_pro_fat;
        vTissItSolGuia.sn_opme          := 'N';
        -- Grava真真o
        vRet := F_gravaTissItSolGuia('INSERE','SOL_INT',vTissItSolGuia,pMsg,null);
        if pMsg is not null then
          RETURN NULL;
        end if;
        --
      end if;
      --
    END LOOP;
    --
    close cItensSolInt;
    --

    vRet := F_gravaTissSolGuia('ATUALIZA_INCONSISTENCIA','SOL_INT',vTissSolGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
  end if;
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS then
    --pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM || 'Empresa: '|| Pkg_mv2000.le_empresa();
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM || 'Empresa: '|| nEmpresaLogada; --adhospLeEmpresa
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ctm_prorrogacaoSolicitacaoGu  ( pModo       in varchar2,
                                            pIdMap      in number,
                                            pCdAtend    in dbamv.atendime.cd_atendimento%type,          --  <- opt 1
                                            pCdConta    in dbamv.reg_amb.cd_reg_amb%type,               --  <- opt 1
				                                    pCdCarteira in number,-- dbamv.carteira.cd_carteira%type    --  <- opt 2
				                                    pCdPrestSol in dbamv.prestador.cd_prestador%type,   	      --  <- opt 1,2
				                                    pCdOrigem	  in number,                                      --  <- opt 2,3
                                            pTpOrigem	  in varchar2,                                    --  <- opt 2,3
                                            pMsg        OUT varchar2,
                                            pReserva    in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(1000);
  vCp	              varchar2(1000);
  vRet              varchar2(1000);
  vcItensSolProrrog cItensSolProrrog%rowtype;
  vTissSolGuia      dbamv.tiss_sol_guia%rowtype;
  vTissItSolGuia    dbamv.tiss_itsol_guia%rowtype;
  pCdConv           dbamv.convenio.cd_convenio%type;
  pCdPaciente       dbamv.paciente.cd_paciente%type;
  vCtProcDados      RecProcDados;
  vCtAutorizSadt    RecAutorizSadt;
  vCtBenef          RecBenef;
  vCtCabec          RecCabec;
  vCtContrat        RecContrat;
  vCtContrProf      RecContrProf;
  vCtDadosSolic     RecDadosSolicitacao;
  --
  vTussRel          RecTussRel;
  vTuss             RecTuss;
  pCdAtendTmp       dbamv.atendime.cd_atendimento%TYPE;
  pCdPrestSolTmp    dbamv.prestador.cd_prestador%type;
  vcTmpSol          cTmpSol%ROWTYPE;
  nCdEspecialidTmp  dbamv.especialid.cd_especialid%TYPE;
  vDiasSolicitadosTmp cDiasSolicitadosTmp%ROWTYPE;
  --
BEGIN
  -- leitura de cursores de uso geral
  --
  if pTpOrigem = 'SOLICITACAO' then
    OPEN  cTmpSol(pCdOrigem);
    FETCH cTmpSol INTO vcTmpSol;
    CLOSE cTmpSol;
    --
    --Oswaldo FATURCONV-22468 inicio
    IF vcTmpSol.cd_paciente IS NOT NULL and (Nvl(vcTmpSol.cd_paciente, 0) <> Nvl(vcPaciente.cd_paciente, 0)) THEN
      open  cPaciente(vcTmpSol.cd_paciente, vcTmpSol.CD_CONVENIO, vcTmpSol.cd_con_pla,vcTmpSol.cd_atendimento,NULL,NULL);
      FETCH cPaciente INTO vcPaciente;
      CLOSE cPaciente;
    END IF;
    --Oswaldo FATURCONV-22468 fim
    --
  END IF;
  --
  pCdAtendTmp := Nvl(pCdAtend,vcTmpSol.cd_atendimento);
  --
  vcAtendimento := null;
  if pCdAtend is not null then
    open  cAtendimento(pCdAtendTmp);
    fetch cAtendimento into vcAtendimento;
    close cAtendimento;
  end if;
  vcConta := null;
  if pCdConta is not null then
    open  cConta(pCdConta,pCdAtendTmp,vcAtendimento.tp_atendimento);
    fetch cConta into vcConta;
    close cConta;
  end if;
  vcCarteira := null;
  if pCdCarteira is not null then
    open  cCarteira(pCdCarteira,null);
    fetch cCarteira into vcCarteira;
    close cCarteira;
  end if;

  --
  -- Oswaldo BH in真cio
  /* --akilucascommit - codigo removido - inicio
  vcTissSolGuia := null;
  IF pTpOrigem in ('SOLICITACAO','GUIA') AND Nvl(vcTissSolGuia.id,vcTmpSol.id_sol) IS NOT null THEN
    vcGuia := null;
    if pTpOrigem = 'GUIA' then
      open  cGuia(pCdOrigem,null);
      fetch cGuia into vcGuia;
      close cGuia;
    END IF;
    vcTissSolGuia := null;
    open  cTissSolGuia(vcTmpSol.id_sol,vcGuia.cd_guia);
    fetch cTissSolGuia into vcTissSolGuia;
    close cTissSolGuia;
    if vcTissSolGuia.id_pai is not null then
      RETURN LPAD(vcTissSolGuia.id,20,'0')||','; -- se j真 foi solicitada eletr真nicamente, retorna a pr真pria guia
    else
      vRet := F_apaga_tiss_sol(null,vcTissSolGuia.id,pMsg,null); -- cancela solicita真真o anterior para sincronizar com Guia
      if pMsg is not null then
        RETURN null;
      end if;
    end if;
  end if;
  */ --akilucascommit - codigo removido - fim
  --
  --akilucascommit - codigo adicionado (substitui o de cima) - inicio
  if pTpOrigem = 'GUIA' then
	vcGuia := null;
    open  cGuia(pCdOrigem,null);
    fetch cGuia into vcGuia;
    close cGuia;
  END IF;

  vcTissSolGuia := null;
  IF pTpOrigem in ('SOLICITACAO','GUIA') AND Nvl(vcGuia.cd_guia,vcTmpSol.id_sol) IS NOT NULL THEN
    vcTissSolGuia := null;
    open  cTissSolGuia(vcTmpSol.id_sol,vcGuia.cd_guia, vcGuia.nr_guia, null);
    fetch cTissSolGuia into vcTissSolGuia;
    close cTissSolGuia;
    if vcTissSolGuia.id_pai is not null then
      RETURN LPAD(vcTissSolGuia.id,20,'0')||','; -- se j?? foi solicitada eletr??nicamente, retorna a pr??pria guia
    else
      vRet := F_apaga_tiss_sol(null,vcTissSolGuia.id,pMsg,null); -- cancela solicita????o anterior para sincronizar com Guia
      if pMsg is not null then
        RETURN null;
      end if;
    end if;
  end if;
  --akilucascommit - codigo adicionado - fim
  -- Oswaldo BH fim
  -------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv           :=  nvl(Nvl(vcCarteira.cd_convenio,vcTmpSol.CD_CONVENIO),nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
  pCdPaciente       :=  nvl(Nvl(vcCarteira.cd_paciente,vcTmpSol.cd_paciente),vcAtendimento.cd_paciente);
  vTpOrigemSol      :=  NULL;
  pCdPrestSolTmp    :=  Nvl(pCdPrestSol,vcTmpSol.cd_prestador);
  nCdEspecialidTmp  :=  vcTmpSol.cd_especialid;
  -------------------
  if nvl(vcConv.cd_convenio,9999) <> nvl(pCdConv,0) THEN
    vcConv := NULL;
    open  cConv(pCdConv);
    fetch cConv into vcConv;
    close cConv;
  end if;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  vCp := 'ctm_prorrogacaoSolicitacaoGuia'; vTemp := null;
  if tConf(vCp).tp_utilizacao > 0 then
    --
    -- registroANS------------------------------------------------
    vCp := 'registroANS';
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcConv.nr_registro_operadora_ans;
      vTissSolGuia.NR_REGISTRO_OPERADORA_ANS := F_ST(null,vTemp,vCp,pCdConv,pCdAtend,pCdConta,null,null);
    end if;
    --
    -- numeroGuiaPrestador----------------------------------------
    vCp := 'numeroGuiaPrestador'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      --vTemp := fnc_retornar_guia_faixa ( pCdConv,dbamv.pkg_mv2000.le_empresa,'I',vcAtendimento.cd_paciente,pMsg);
        if pTpOrigem = 'GUIA' and vcGuia.nr_guia is not null then
          vTemp := nvl(vcGuia.nr_guia,fnc_retornar_guia_faixa ( pCdConv,nEmpresaLogada,'I',vcAtendimento.cd_paciente,pMsg));
        ELSE
		  vTemp := fnc_retornar_guia_faixa ( pCdConv,nEmpresaLogada,'I',vcAtendimento.cd_paciente,pMsg); --adhospLeEmpresa -- saulo_UnimedBH
		end if;
        if pMsg is not null then
          RETURN NULL;
        end if;
      vTissSolGuia.NR_GUIA := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- nrGuiaReferenciada-----------------------------------------
    vCp := 'nrGuiaReferenciada'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if pTpOrigem = 'GUIA' then
          vTemp := vcGuia.nr_guia_principal;
        else
          vTemp := null;
        end if;
      vTissSolGuia.NR_GUIA_PRINCIPAL := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- dadosBeneficiario------------------------------------------
    vTissSolGuia.NR_CARTEIRA                     := F_ct_beneficiarioDados('numeroCarteira',1627,pCdAtendTmp,pCdConta,pCdPaciente,pCdConv,'E',vCtBenef,pMsg,'RelerPac'||'#'||vcTmpSol.nr_carteira);
    vTissSolGuia.NM_PACIENTE                     := F_ct_beneficiarioDados('nomeBeneficiario',1628,pCdAtendTmp,pCdConta,pCdPaciente,pCdConv,'E',vCtBenef,pMsg,null);
    vTissSolGuia.NM_SOCIAL_PACIENTE              := F_ct_beneficiarioDados('nomeSocialPaciente',1628,pCdAtendTmp,pCdConta,pCdPaciente,pCdConv,'E',vCtBenef,pMsg,null); --Oswaldo FATURCONV-26150
	vTissSolGuia.TP_IDENT_BENEFICIARIO           := F_ct_beneficiarioDados('tipoIdent',2000,pCdAtendTmp,pCdConta,pCdPaciente,pCdConv,'E',vCtBenef,pMsg,null);
    vTissSolGuia.NR_ID_BENEFICIARIO              := F_ct_beneficiarioDados('identificacaoBeneficiario',1629,pCdAtendTmp,pCdConta,pCdPaciente,pCdConv,'E',vCtBenef,pMsg,null);
    --vTissSolGuia.DS_TEMPLATE_IDENT_BENEFICIARIO  := F_ct_beneficiarioDados('templateBiometrico',2001,pCdAtendTmp,pCdConta,pCdPaciente,pCdConv,'E',vCtBenef,pMsg,null); --Oswaldo FATURCONV-22404
    --

    -- dadosContratadoSolicitante---------------------------------
    vRet := F_ct_contratadoDados(null,1630,pCdAtendTmp,pCdConta,null,null,null,pCdConv,vCtContrat,pMsg,null);
    if vRet = 'OK' then
      vTissSolGuia.CD_OPERADORA             := vCtContrat.codigoPrestadorNaOperadora;
      vTissSolGuia.CD_CPF                   := vCtContrat.cpfContratado;
      vTissSolGuia.CD_CGC                   := vCtContrat.cnpjContratado;
      vTissSolGuia.NM_PRESTADOR_CONTRATADO  := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 inicio
    end if;
    --
    --Oswaldo FATURCONV-22404 inicio
    -- nomeContratadoSolicitante-----------------------------------------
    vCp := 'nomeContratadoSolicitante'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      vTemp := vCtContrat.nomeContratado;
      vTissSolGuia.NM_PRESTADOR_CONTRATADO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --Oswaldo FATURCONV-22404 fim
    --
    -- dadosProfissionalSolicitante-------------------------------
    vRet := F_ct_contratadoProfissionalDad ( null,1635,pCdAtendTmp,pCdConta,pCdPrestSolTmp,pCdConv,vCtContrProf,pMsg,null);
    if vRet = 'OK' then
      vTissSolGuia.NM_PRESTADOR        := vCtContrProf.nomeProfissional;
      vTissSolGuia.DS_CONSELHO         := vCtContrProf.conselhoProfissional;
      vTissSolGuia.DS_CODIGO_CONSELHO  := vCtContrProf.numeroConselhoProfissional;
      vTissSolGuia.UF_CONSELHO         := vCtContrProf.UF;
      vTissSolGuia.CD_CBOS             := vCtContrProf.CBOS;
    end if;
    --
    -- dadosInternacao--------------------------------------------
    -- qtDiariasAdicionais
    vCp := 'qtDiariasAdicionais'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if pTpOrigem = 'GUIA' then
          vTemp := nvl( vcGuia.nr_dias_solicitados, 0 );
        ELSIF pTpOrigem = 'SOLICITACAO' then
          OPEN  cDiasSolicitadosTmp(vcTmpSol.id_tmp);
          FETCH cDiasSolicitadosTmp INTO vDiasSolicitadosTmp;
          CLOSE cDiasSolicitadosTmp;
          vTemp := Nvl(vDiasSolicitadosTmp.qt_diarias,0);
        else
          vTemp := null;
        end if;
      vTissSolGuia.QT_DIARIAS_SOLICITADA := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- tipoAcomodacaoSolicitada
    vCp := 'tipoAcomodacaoSolicitada'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if pTpOrigem = 'GUIA' then
          vTussRel.cd_tip_acom := vcGuia.cd_tip_acom;
        else
          vTussRel.cd_tip_acom := vcAtendimento.cd_tip_acom;
        end if;
        vTemp := F_DM(49,pCdAtendTmp,pCdConta,null,null,vTussRel,vTuss,pMsg,null);
        vTemp := vTuss.CD_TUSS;
      vTissSolGuia.CD_TIP_ACOM := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- indicacaoClinica
    vCp := 'indicacaoClinica'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN
        if pTpOrigem = 'GUIA' then
          vTemp := vcGuia.ds_justificativa;
        else
          vTemp := null;
        end if;
      vTissSolGuia.DS_HDA := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- observacao-------------------------------------------------
    vCp := 'observacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        if pTpOrigem = 'GUIA' then
          vTemp := substr(vcGuia.ds_observacao,1,1000);
        else
          vTemp := null;
        end if;
	-- Oswaldo BH in真cio
	--vTissSolGuia.DS_OBSERVACAO := F_ST(null,pCdAtendTmp,vCp,pCdAtend,pCdConta,null,null,null); --akilucascommit - substituido pelo codigo abaixo
      vTissSolGuia.DS_OBSERVACAO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
	  -- Oswaldo BH fim
    end if;
    --
    -- dataSolicitacao--------------------------------------------
    vCp := 'dataSolicitacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if pTpOrigem = 'GUIA' then
          vTemp := To_Char(vcGuia.dt_solicitacao,'yyyy-mm-dd'); -- Oswaldo BH
        ELSIF pTpOrigem = 'SOLICITACAO' then
          vTemp := To_Char(vcTmpSol.dt_solicitacao,'yyyy-mm-dd');
        else
          vTemp :=  to_char( sysdate, 'yyyy-mm-dd' );
        end if;
      vTissSolGuia.DH_SOLICITACAO := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
    end if;
    --
    -- assinaturaDigital------------------------------------------
    --vRet := F_assinaturaDigital(null,9999,null,null,null,null,null,null);
    --
    -- informa真真es complementares de apoio
    vTissSolGuia.cd_paciente        := pCdPaciente;
    vTissSolGuia.cd_convenio        := pCdConv;
    vTissSolGuia.cd_atendimento     := pCdAtendTmp;
    vTissSolGuia.dt_emissao         := to_char(sysdate,'yyyy-mm-dd');
    vTissSolGuia.CD_PRESTADOR_SOL   := Nvl(pCdPrestSolTmp,vcAtendimento.cd_prestador);
    vTissSolGuia.cd_con_pla         := vcPaciente.cd_con_pla; -- fora de uso, mas obrigat真rio por Constraint
    vTissSolGuia.ds_con_pla         := Nvl(vcPaciente.ds_con_pla, 'X'); -- fora de uso, mas obrigat真rio por Constraint
    vTissSolGuia.sn_tratou_retorno  := 'N';
    vTissSolGuia.sn_cancelado       := 'N';
  --vTissSolGuia.cd_multi_empresa   := dbamv.pkg_mv2000.le_empresa;
    vTissSolGuia.cd_multi_empresa   := nEmpresaLogada; --adhospLeEmpresa
    vTissSolGuia.tp_atendimento     := 'P';
    vTissSolGuia.SN_ATENDIMENTO_RN  := 'N'; -- PENDENTE -- deve ser o mesmo da Solicita真真o Interna真真o
    vTissSolGuia.SN_PREVISAO_USO_OPME   := 'N';
    vTissSolGuia.SN_PREVISAO_USO_QUIMIO := 'N';
  --vTissSolGuia.CD_VERSAO_TISS_GERADA  := '3.02.00';
    vTissSolGuia.CD_VERSAO_TISS_GERADA  := Nvl( vcConv.cd_versao_tiss, '3.02.00' );
    vTissSolGuia.TP_ORIGEM_SOL      := pTpOrigem;
    vTissSolGuia.CD_ORIGEM_SOL      := pCdOrigem;
    vTissSolGuia.DH_SOLICITADO      := to_date( to_char( sysdate, 'dd/mm/yyyy' ) || ' ' ||to_char( sysdate, 'hh24:mi'    ), 'dd/mm/yyyy hh24:mi' );
    vTissSolGuia.cd_especialid      := nCdEspecialidTmp;
    vTissSolGuia.dt_validade        := To_Char(vcTmpSol.dt_validade_carteira,'yyyy-mm-dd');
    if pTpOrigem = 'GUIA' then
      vTissSolGuia.CD_GUIA := pCdOrigem;
    end if;
    vTissSolGuia.nm_social_paciente := vcPaciente.nm_social_paciente; --Oswaldo FATURCONV-22468
    --
    -- Grava真真o
    vResult := F_gravaTissSolGuia('INSERE','SOL_PRORROG',vTissSolGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
    -- procedimentosAdicionais------------------------------------
    OPEN  cItensSolProrrog(pTpOrigem,pCdOrigem,null);
    --
    LOOP
      --
      FETCH cItensSolProrrog into vcItensSolProrrog;
      EXIT WHEN cItensSolProrrog%NOTFOUND;
      --
      if cItensSolProrrog%FOUND then
        --
        -- procedimento-------------------------------------------
        vRet := F_ct_procedimentoDados(null,1645,null,null,null,null,vcItensSolProrrog.cd_pro_fat,pCdConv,'SOL_PRORROG',vCtProcDados,pMsg,null);
        if vRet = 'OK' then
          vTissItSolGuia.TP_TAB_FAT         := vCtProcDados.codigoTabela;
          vTissItSolGuia.CD_PROCEDIMENTO    := vCtProcDados.codigoProcedimento;
          vTissItSolGuia.DS_PROCEDIMENTO    := vCtProcDados.descricaoProcedimento;
        end if;
        --
        -- quantidadeSolicitada-----------------------------------
        vCp := 'quantidadeSolicitada'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
          vTemp := vcItensSolProrrog.QT_ITEM;
          vTissItSolGuia.QT_SOLICITADA := F_ST(null,vTemp,vCp,pCdAtendTmp,pCdConta,null,null,null);
        end if;
        -- informa真真es complementares de apoio
        vTissItSolGuia.id_pai           := vTissSolGuia.ID;
        vTissItSolGuia.cd_itorigem_sol  := vcItensSolProrrog.CD_IT_ORIGEM;
        vTissItSolGuia.CD_PRO_FAT       := vcItensSolProrrog.cd_pro_fat;
        vTissItSolGuia.sn_opme          := 'N';
        -- Grava真真o
        vRet := F_gravaTissItSolGuia('INSERE','SOL_PRORROG',vTissItSolGuia,pMsg,null);
        if pMsg is not null then
          RETURN NULL;
        end if;
        --
      end if;
      --
    END LOOP;
    --
    close cItensSolProrrog;
    --

    vRet := F_gravaTissSolGuia('ATUALIZA_INCONSISTENCIA','SOL_PRORROG',vTissSolGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
  end if;
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
function fnc_retornar_guia_faixa ( pnCdConvenio in dbamv.convenio.cd_convenio%type,
                                   pnCdMultiEmp in dbamv.multi_empresas.cd_multi_empresa%type,
                                   pvTpGuia     in varchar2,
                                   pvReserva    in varchar2,
                                   pvMsgErro    out varchar2 ) return varchar2 is
  --
  Pragma AUTONOMOUS_TRANSACTION; -- Transa真真o aut真noma, ou seja, o Commit dela n真o interfere no que est真 pendente
                                 -- na fun真真o que chamou esta.
  --
  cursor cFaixaGuia (nCdMultiEmpresa in number, cTpGuia in varchar) is
    select fg.cd_faixa_guia
          ,decode(nvl( fg.tp_guia, 'T' ), 'I',1, 'S',2, 'C',3, 'E',4, 'G',5, 'U',6 ,7) ordem
          ,tp_geracao_nr_guia
          ,nr_inicial
          ,nr_tamanho_fixo
      from dbamv.faixa_guia_convenio fg
     where fg.cd_convenio = pnCdConvenio
       and fg.cd_multi_empresa = nCdMultiEmpresa
       and (   ( cTpGuia in ('I','SI')  and nvl( fg.tp_guia, 'T' ) in ('I','U','T') )
            or ( cTpGuia in ('C','SS')  and nvl( fg.tp_guia, 'T' ) in ('S','E','U','T') )
            or ( cTpGuia in ('CO')      and nvl( fg.tp_guia, 'T' ) in ('C','G','T') )
            or ( cTpGuia in ('SP')      and nvl( fg.tp_guia, 'T' ) in ('E','G','T') )
            or ( cTpGuia in ('RI','HI') and nvl( fg.tp_guia, 'T' ) in ('G','T') )
           )
       and exists( select it.cd_faixa_guia from dbamv.item_faixa_guia_convenio it
                    where it.cd_faixa_guia = fg.cd_faixa_guia
                      and it.nr_guia is null )
     order by ordem, nr_inicial;
  --
  cursor cItemFaixaGuia( pnFaixa in number ) is
    select  it.cd_item_faixa_guia, it.nr_sequencia
      from  dbamv.item_faixa_guia_convenio it
     where  it.cd_faixa_guia = pnFaixa
       and  it.nr_sequencia in ( select min( itf.nr_sequencia )
                                   from dbamv.item_faixa_guia_convenio itf
                                  where itf.cd_faixa_guia = pnFaixa
                                    and itf.nr_guia is null )
       FOR UPDATE;
  --
  vIdentificaFaixa      dbamv.faixa_guia_convenio.nr_tamanho_fixo%type;
  nCdItemFaixaGuia      dbamv.item_faixa_guia_convenio.cd_item_faixa_guia%type := null;
  nNrSequencia          varchar2(50);
  nNrGuia               dbamv.item_faixa_guia_convenio.nr_guia%type            := null;
  vTpGeracaoNrGuia      dbamv.faixa_guia_convenio.tp_geracao_nr_guia%type;
  bEntrouFaixa          boolean := false;
  bTpGeracaoNrGuia      boolean := false;
  bRetornouFaixa        boolean := false;
  nCdPaciente           dbamv.paciente.cd_paciente%TYPE;
begin
  if pnCdConvenio is null or pnCdMultiEmp is null or pvTpGuia is null then
    pvMsgErro := 'Falta par真metros na fun真真o FNC_RETORNAR_FAIXA_GUIAS.';
    return NULL;
  end if;
  --
  -- Reuso de guias (qdo. faixa)
  if tFaixaGuias.exists(pvTpGuia) and length(tFaixaGuias(pvTpGuia).nr_guias)> 20 then
    nNrGuia := trim(substr(tFaixaGuias(pvTpGuia).nr_guias,1,20));
    tFaixaGuias(pvTpGuia).nr_guias := substr(tFaixaGuias(pvTpGuia).nr_guias,22);
    RETURN nNrGuia; -- retorna Guia j真 utilizada anteriormente
  end if;
  --
  nCdPaciente := pvReserva;
  --
  begin
    --
    -- Loop de Faixas (ver ordem no cursor)
    FOR vcFaixaGuia in cFaixaGuia(pnCdMultiEmp,pvTpGuia)  LOOP
      bRetornouFaixa := False;
      bTpGeracaoNrGuia := false;
      vTpGeracaoNrGuia := nvl( vcFaixaGuia.tp_geracao_nr_guia, '2' );
      if nvl( vTpGeracaoNrGuia,'N' ) in ('1','2') then
        bTpGeracaoNrGuia:= true;
        bEntrouFaixa := true;
        -- Loop de itens da faixa
        while not bRetornouFaixa loop
          open cItemFaixaGuia( vcFaixaGuia.cd_faixa_guia );
          fetch cItemFaixaGuia into nCdItemFaixaGuia, nNrSequencia;
          if cItemFaixaGuia%notfound then
            close cItemFaixaGuia;
            nNrGuia := null;
            exit;
          end if;
          nNrGuia := null;
          If vcFaixaGuia.nr_tamanho_fixo is not null Then
            nNrGuia := lpad(nNrSequencia, vcFaixaGuia.nr_tamanho_fixo,0);
          else
            nNrGuia := nNrSequencia;
          end if;
          -- Verificando se um n真mero de Guia informado j真 est真 cadastrado para o Conv真nio em outro atendimento.
          if dbamv.fnc_ffcv_verifica_utiliz_guia ( nNrGuia, nCdPaciente, null, pnCdConvenio ) then
            bRetornouFaixa := true;
          end if;
          nNrGuia := null;
          if nNrSequencia is not null then
            vIdentificaFaixa := null;
            nNrGuia := nNrSequencia;
            --
            if vcFaixaGuia.nr_tamanho_fixo is not null Then
              nNrGuia := lpad(dbamv.fnc_ffcv_gera_numero_guia( vTpGeracaoNrGuia, nNrSequencia ), vcFaixaGuia.nr_tamanho_fixo,0);
            else
              nNrGuia := dbamv.fnc_ffcv_gera_numero_guia( vTpGeracaoNrGuia, nNrSequencia );
            end if;
            --
            update dbamv.item_faixa_guia_convenio
               set dt_lancamento  = sysdate,
                   nr_guia        = nNrGuia
             where cd_item_faixa_guia = nCdItemFaixaGuia;
            --
            commit;    -- libera o LOCK da faixa (o "for Update" do cursor cItemFaixaGuia)
          end if;
          close cItemFaixaGuia;
        end loop;
      end if;
      if nNrGuia is not null then
        return nNrGuia;
      End if;
    end loop;
    --
    if not bEntrouFaixa and pvTpGuia in ( 'SI', 'SS', 'I', 'C' ) then
      null;
    else
      if not bTpGeracaoNrGuia then
        pvMsgErro:= 'Aten真真o: Tipo de gera真真o do n真mero da guia n真o informado no cadastro da faixa de guia do conv真nio';
        return NULL;
      end if;
      if nNrSequencia is null then
        pvMsgErro := 'N真o h真 intervalo de guia dispon真vel, deve ser criada uma Faixa de Guias para o Conv真nio.';
      end if;
    end if;
  end;
  if nNrGuia is not null then
    return nNrGuia;
  else
    return NULL;
  end if;
end;
--
--==================================================
FUNCTION  F_DM  (pCdTipTuss in varchar2,
                 pCdAtend   in dbamv.atendime.cd_atendimento%type,
                 pCdConta   in dbamv.reg_fat.cd_reg_fat%type,
                 pCdLanc    in dbamv.itreg_fat.cd_lancamento%type,
                 pCdItLan   in varchar2,
                 pTussRel   in OUT RecTussRel,
                 pTuss      OUT RecTuss,
                 pMsg       OUT varchar2,
                 pReserva   in varchar2) return varchar2 IS
  --
  vResult       varchar2(1000);
  --
  vSnMesmoCaso varchar2(1) := 'N';
BEGIN
  -- leitura de cursores de uso geral
  --
  if pCdAtend||pCdConta||pCdConta||pCdLanc is not null then
    if pCdAtend is not null then
      if pCdAtend <> nvl(vcAtendimento.cd_atendimento,0) then
        vcAtendimento := null;
        open  cAtendimento(pCdAtend);
        fetch cAtendimento into vcAtendimento;
        close cAtendimento;
      end if;
    end if;
    --
    if pCdConta is not null then
      if pCdConta <> nvl(vcConta.cd_conta,0) then
        vcConta := null;
        open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
        fetch cConta into vcConta;
        close cConta;
      end if;
    end if;
    --
    if pCdLanc is not null then
      if pCdAtend||'-'||pCdConta||'-'||pCdLanc||'-'||pCdItLan <> nvl(vcItem.cd_atendimento||'-'||vcItem.cd_conta||'-'||vcItem.cd_lancamento||'-'||vcItem.cd_itlan_med, 'XXXX') then --OP 44488 - ajuste na condicao
        vcItem := null;
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
        fetch cItem into vcItem;
        close cItem;
      end if;
    end if;
    --
  end if;
  --
  -------------------------------------------------------------
  -- L真gica para carregar campos de relacionamento 真 partir de cursores de atendimento/conta/item caso informados
  if pCdConta is NOT null then
    if pTussRel.CD_MULTI_EMPRESA is null then
      pTussRel.CD_MULTI_EMPRESA := vcConta.cd_multi_empresa;
    end if;
    --
    if pTussRel.CD_CONVENIO is null then
      pTussRel.CD_CONVENIO := vcConta.cd_convenio;
    end if;
    --
    if pTussRel.CD_TIP_ACOM is null then
      pTussRel.CD_TIP_ACOM := vcConta.cd_tip_acom;
    end if;
    --
    if pTussRel.CD_MOT_ALT is null then
      pTussRel.CD_MOT_ALT := vcConta.cd_mot_alt;
    end if;
    --
    if pTussRel.DT_VIGENCIA is null AND Nvl(FNC_CONF('TP_VIGENCIA_PROCED_TUSS',vcConta.cd_convenio,null), '1')='1' then
      pTussRel.DT_VIGENCIA := to_date(vcConta.dt_inicio,'yyyy-mm-dd');
    end if;
  end if;
  --
  if pCdAtend is NOT null then
    if pTussRel.CD_MULTI_EMPRESA is null then
      pTussRel.CD_MULTI_EMPRESA := vcAtendimento.cd_multi_empresa;
    end if;
    --
    if pTussRel.CD_CONVENIO is null then
      pTussRel.CD_CONVENIO := vcAtendimento.cd_convenio_atd;
    end if;
    --
    if pTussRel.CD_TIP_ACOM is null then
      pTussRel.CD_TIP_ACOM := vcAtendimento.cd_tip_acom;
    end if;
    --
    if pTussRel.CD_MOT_ALT is null then
      pTussRel.CD_MOT_ALT := vcAtendimento.cd_mot_alt;
    end if;
    --
    if pTussRel.TP_ATENDIMENTO is null then
      pTussRel.TP_ATENDIMENTO := vcAtendimento.tp_atendimento_original;
    end if;
    --
    if pTussRel.CD_ESPECIALIDADE is null then
      pTussRel.CD_ESPECIALIDADE := vcAtendimento.cd_especialid;
    end if;
    --
    if pTussRel.TP_SEXO is null then
      if vcAtendimento.cd_paciente <> nvl(vcPaciente.cd_paciente, 0) then
        open  cPaciente(vcAtendimento.cd_paciente, pTussRel.CD_CONVENIO, nvl(vcConta.cd_con_pla,vcAtendimento.cd_con_pla),pCdAtend,NULL,NULL); --OSWALDO
        fetch cPaciente into vcPaciente;
        close cPaciente;
      end if;
      pTussRel.TP_SEXO := vcPaciente.tp_sexo;
    end if;
    --
    if pTussRel.CD_SERVICO is null then
      pTussRel.CD_SERVICO := vcAtendimento.cd_servico;
    end if;
    --
    if pTussRel.DT_VIGENCIA is NULL AND Nvl(FNC_CONF('TP_VIGENCIA_PROCED_TUSS',vcAtendimento.cd_convenio_atd,null), '1')='1' then
      pTussRel.DT_VIGENCIA := to_date(vcAtendimento.dt_atendimento,'yyyy-mm-dd');
    end if;
  end if;
  --
  if pCdLanc is NOT null then
    if pTussRel.CD_PRO_FAT is null then
      pTussRel.CD_PRO_FAT := vcItem.cd_pro_fat;
    end if;
    --
    if pTussRel.CD_ATI_MED is null then
      if vcItem.cd_itlan_med is not null then
        pTussRel.CD_ATI_MED := vcItem.cd_itlan_med;
      elsif vcItem.cd_ati_med is not null then
        pTussRel.CD_ATI_MED := vcItem.cd_ati_med;
      end if;
    end if;
    --
    if pTussRel.CD_PRO_FAT <> nvl(vcProFat.cd_pro_fat,'X') then
       open  cProFat(pTussRel.CD_PRO_FAT);
       fetch cProFat into vcProFat;
       close cProFat;
    end if;
    --
    if pTussRel.CD_PRO_FAT <> nvl(vcProFatAux.cd_pro_fat,'X') then
      open  cProFatAux(pTussRel.CD_PRO_FAT, null);
      fetch cProFatAux into vcProFatAux;
      close cProFatAux;
    end if;
    --VERIFICAR A REGRA
    pTussRel.CD_GRU_PRO := vcProFatAux.cd_gru_pro;
    pTussRel.TP_GRU_PRO := vcProFatAux.tp_gru_pro;
    pTussRel.TP_SERVICO_HOSPITALAR := vcProFat.tp_serv_hospitalar;
    pTussRel.CD_SETOR   := vcItem.CD_SETOR_PRODUZIU;
    --
    if pTussRel.DT_VIGENCIA is NULL AND Nvl(FNC_CONF('TP_VIGENCIA_PROCED_TUSS',vcAtendimento.cd_convenio_atd,null), '1')='2' then
      pTussRel.DT_VIGENCIA := to_date(vcItem.dt_lancamento,'yyyy-mm-dd');
    end if;
    --
  end if;
  --
  if pTussRel.CD_PRO_FAT is NOT null then
    if pTussRel.CD_PRO_FAT <> nvl(vcProFat.cd_pro_fat,'X') then
       open  cProFat(pTussRel.CD_PRO_FAT);
       fetch cProFat into vcProFat;
       close cProFat;
    end if;
    --
    if pTussRel.CD_PRO_FAT <> nvl(vcProFatAux.cd_pro_fat,'X') then
      open  cProFatAux(pTussRel.CD_PRO_FAT, null);
      fetch cProFatAux into vcProFatAux;
      close cProFatAux;
    end if;
    --
    if pTussRel.CD_GRU_PRO is null then
      pTussRel.CD_GRU_PRO := vcProFatAux.cd_gru_pro;
    end if;
    --
    if pTussRel.TP_GRU_PRO is null then
      pTussRel.TP_GRU_PRO := vcProFatAux.tp_gru_pro;
    end if;
    --
    if pTussRel.TP_SERVICO_HOSPITALAR is null then
      pTussRel.TP_SERVICO_HOSPITALAR := vcProFat.tp_serv_hospitalar;
    end if;
  end if;
  -- if pTussRel.CD_CONSELHO is null then       -- sem refer真ncia interna pra buscar. Confiar no par真metro
  -- if pTussRel.CD_MOTIVO_GLOSA is null then   -- sem refer真ncia interna pra buscar. Confiar no par真metro
  if pTussRel.DT_VIGENCIA is null then
    pTussRel.DT_VIGENCIA := trunc(sysdate);
  end if;
  ---------------------
    --
    -- Pesquisa TUSS
    pTuss       := null;
    --pTuss_Old   := null;
    --

    IF Nvl(pCdTipTuss,0) NOT IN (0,18,19,20,22,98) then
      open  cTuss(pCdTipTuss,pTussRel,null);
      fetch cTuss into pTuss;
      close cTuss;
    ELSE
      if pTuss_Old.cd_tuss is null or
    ( (pTuss_Old.cd_tuss is not null and pTussRel.cd_pro_fat <> nvl(pTussRel_old.CD_PRO_FAT,'X')) OR
      (pTussRel.dt_vigencia is not null and pTussRel.dt_vigencia <> pTussRel_old.dt_vigencia) ) THEN     -- OP 31911
        open  cTuss(pCdTipTuss,pTussRel,null);
        fetch cTuss into pTuss;
        close cTuss;
      else  -- Mesma pesquisa, e j真 tem o resultado antigo, reaproveita.
        pTuss := pTuss_Old;
      end if;
      pTussRel_old  := pTussRel;
      pTuss_Old     := pTuss;
    END IF;
    --
  --
  RETURN 'OK';
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA obtendo Tuss na tabela '||pCdTipTuss||'. Erro : '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_GERA_ELEGIBILIDADE( pModo           in varchar2,
                                pIdMap          in number,
                                pTpAcao         in varchar2,    -- 'G' - gerar dados / 'S' - Status
                                --
                                pCdAtend        dbamv.atendime.cd_atendimento%type, --1a.opt
                                pCdConta        dbamv.reg_fat.cd_reg_fat%type,      --1a.opt
                                pCdPaciente     dbamv.paciente.cd_paciente%type,    --2a.opt
                                pCdConvenio     dbamv.convenio.cd_convenio%type,    --2a.opt
                                pCdConPla       dbamv.con_pla.cd_con_pla%type,      --2a.opt
                                pIdBeneficiario varchar2,                           --   opt
                                --
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS

  -- FUNCTION F_ct_elegibilidadeVerifica(... [N_RETIRAR]
  --
  cursor cTissSolEleg (pPac dbamv.paciente.cd_paciente%type, pConv dbamv.convenio.cd_convenio%type) is
    select   tse.id
            ,tse.id_pai
            ,tse.cd_paciente
            ,tse.cd_convenio
            ,upper(tse.sn_aprovado) sn_aprovado
            ,tse.dh_solicitado
            ,tse.dh_retorno
            ,tse.tp_ident_beneficiario
            ,tse.ds_template_ident_beneficiario
            ,tse.cd_ausencia_validacao
            ,tse.cd_validacao
            ,tse.ds_glosa
      from dbamv.tiss_sol_eleg tse
     where tse.cd_paciente = pPac
       and tse.cd_convenio = pConv
    order by tse.id desc;
  --
  cursor cRetornoElegGlosa (pIdMensagemEnvio number) is
    select trg.cd_motivo_glosa, trg.ds_motivo_glosa
        from dbamv.tiss_retorno_eleg_g trg, dbamv.tiss_retorno_eleg tr, dbamv.tiss_mensagem tm
        where tm.id_mensagem_envio = pIdMensagemEnvio
          and tr.id_pai = tm.id
          and trg.id_pai = tr.id;
  --
  vTemp             varchar2(1000);
  vResult           varchar2(1000);
  vCp               varchar2(1000);
  vRet              varchar2(1000);
  pCdConv           dbamv.convenio.cd_convenio%type;
  pCdPlano          dbamv.con_pla.cd_con_pla%type;
  pCdPac            dbamv.paciente.cd_paciente%type;
  vTissSolEleg      dbamv.tiss_sol_eleg%rowtype;
  vCtContrat        RecContrat;
  vCtBenef          RecBenef;
  vCtMensagem       RecMensagemLote;
  vcTissSolEleg     cTissSolEleg%rowtype;
BEGIN
  -- leitura de cursores de uso geral
  vcAtendimento := null;
  vcConta       := null;
  IF pCdAtend is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  end if;
  -------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv       :=  nvl(pCdConvenio,nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd));
  pCdPac        :=  nvl(pCdPaciente,vcAtendimento.cd_paciente);
  pCdPlano      :=  nvl(pCdConPla,nvl(vcConta.cd_con_pla,vcAtendimento.cd_con_pla));
  vTpOrigemSol  :=  NULL;
  --
  if vcConv.cd_convenio<>nvl(pCdConv,0) then
    open  cConv(pCdConv);
    fetch cConv into vcConv;
    close cConv;
  end if;
  if pCdPac <> nvl(vcPaciente.cd_paciente, 0) then
    open  cPaciente(pCdPac, pCdConv, pCdPlano, pCdAtend,'P',NULL); --OSWALDO
    fetch cPaciente into vcPaciente;
    close cPaciente;
  end if;
  -------------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  -------------------------------------------------------
  if pTpAcao = 'G' then
    --
    -- dadosPrestador------------------------------------
    vRet := F_ct_contratadoDados(null,1659,pCdAtend,pCdConta,null,null,null,pCdConv,vCtContrat,pMsg,null);
    if vRet = 'OK' then
      vTissSolEleg.CD_CONTRATADO_NA_OPERADORA   := vCtContrat.codigoPrestadorNaOperadora;
      vTissSolEleg.CD_CPF_CONTRATADO            := vCtContrat.cpfContratado;
      vTissSolEleg.CD_CNPJ_CONTRATADO           := vCtContrat.cnpjContratado;
      vTissSolEleg.NM_CONTRATADO                := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 inicio
    end if;
    --
    vTissSolEleg.NR_CARTEIRA := F_ct_beneficiarioDados('numeroCarteira',1663,pCdAtend,pCdConta,pCdPac,pCdConv,'P',vCtBenef,pMsg,'RelerPac');
    if pReserva is not null then -- carteira avulsa
      vTissSolEleg.NR_CARTEIRA := pReserva;
    end if;



    --
    vTissSolEleg.NM_PACIENTE                     := F_ct_beneficiarioDados('nomeBeneficiario',1664,pCdAtend,pCdConta,pCdPac,pCdConv,'P',vCtBenef,pMsg,null);
    vTissSolEleg.NR_CNS                          := F_ct_beneficiarioDados('numeroCNS',1665,pCdAtend,pCdConta,pCdPac,pCdConv,'P',vCtBenef,pMsg,null);
    vTissSolEleg.TP_IDENT_BENEFICIARIO           := F_ct_beneficiarioDados('tipoIdent',1969,pCdAtend,pCdConta,pCdPac,pCdConv,'P',vCtBenef,pMsg,null);
    vTissSolEleg.NR_ID_BENEFICIARIO              := NVL(pIdBeneficiario,F_ct_beneficiarioDados('identificadorBeneficiario',1666,pCdAtend,pCdConta,pCdPac,pCdConv,'P',vCtBenef,pMsg,null));
    --vTissSolEleg.DS_TEMPLATE_IDENT_BENEFICIARIO  := F_ct_beneficiarioDados('templateBiometrico',1970,pCdAtend,pCdConta,pCdPac,pCdConv,'P',vCtBenef,pMsg,null); --Oswaldo FATURCONV-22404
    vTissSolEleg.CD_AUSENCIA_VALIDACAO           := F_ct_beneficiarioDados('ausenciaCodValidacao',1971,pCdAtend,pCdConta,pCdPac,pCdConv,'P',vCtBenef,pMsg,null);
    vTissSolEleg.CD_VALIDACAO                    := F_ct_beneficiarioDados('codValidacao',1972,pCdAtend,pCdConta,pCdPac,pCdConv,'P',vCtBenef,pMsg,null);


    -- validadeCarteira----------------------------------
    vCp := 'validadeCarteira'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcPaciente.dt_validade_carteira;
      vTissSolEleg.DT_VALIDADE  := F_ST(null,vTemp,vCp,pCdAtend,pCdConta,null,null,null);
    end if;
    --
    -- informa真真es complementares de apoio
    vTissSolEleg.dh_solicitado              :=  sysdate;
    vTissSolEleg.nm_xml                     :=  'verificaElegibilidade';
  --vTissSolEleg.cd_multi_empresa           :=  dbamv.pkg_mv2000.le_empresa;
    vTissSolEleg.cd_multi_empresa           :=  nEmpresaLogada; --adhospLeEmpresa
    vTissSolEleg.cd_paciente                :=  pCdPac;
    vTissSolEleg.cd_convenio                :=  pCdConv;
    vTissSolEleg.cd_con_pla                 :=  pCdPlano;
    vTissSolEleg.nr_registro_operadora_ans  :=  vcConv.nr_registro_operadora_ans;
    vTissSolEleg.ds_plano                   :=  'X';    -- cumprir constraint
    --
  --vRet := F_mensagemTISS(null,1001,'VERIFICA_ELEGIBILIDADE',dbamv.pkg_mv2000.le_empresa,pCdConv,vTissSolEleg.NR_CARTEIRA,vCtMensagem,pMsg,null);
    vRet := F_mensagemTISS(null,1001,'VERIFICA_ELEGIBILIDADE',nEmpresaLogada,pCdConv,vTissSolEleg.NR_CARTEIRA,vCtMensagem,pMsg,null); --adhospLeEmpresa
    if pMsg is null then
      --
      vTissSolEleg.ID_PAI := vCtMensagem.idMensagem;
      -- Grava真真o
      vRet := F_gravaTissSolEleg('INSERE',vTissSolEleg,pMsg,null);
      if pMsg is null then
        vResult  :=  lpad(vCtMensagem.idMensagem,20,'0');
      end if;
      --
    end if;
    --
  elsif pTpAcao = 'S' then
    open  cTissSolEleg(pCdPac,pCdConv);
    fetch cTissSolEleg into vcTissSolEleg;
    close cTissSolEleg;
    for i in cRetornoElegGlosa(vcTissSolEleg.ID_PAI) loop
      pMsg := pMsg||i.cd_motivo_glosa||'-'||i.ds_motivo_glosa||', ';
    end loop;

    IF pMsg IS NULL AND vcTissSolEleg.DS_GLOSA IS NOT NULL THEN
      pMsg:= vcTissSolEleg.DS_GLOSA;
    END IF;

    if vcTissSolEleg.sn_aprovado = 'S' and pMsg is null then
      vResult := 'OK';
    else
      if pMsg is null then
        pMsg := 'Tempo esgotado sem resposta do Conv真nio !';
      end if;
    end if;
  end if;
  --
  if vResult is null then
    ROLLBACK;
    return NULL;
  else
    COMMIT;
    return vResult;
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA na verifica真真o de Elegibilidade. Erro:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissSolEleg (  pModo           in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_sol_eleg%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
  --
BEGIN
  if pModo = 'INSERE' then
    vRg.NM_XML := 'verificaElegibilidade';
    --
    select dbamv.seq_tiss.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.tiss_sol_eleg
        (   id, id_pai, cd_multi_empresa, cd_paciente, cd_convenio, cd_con_pla, cd_carteira, dh_solicitado, nm_xml, nr_registro_operadora_ans, dh_retorno, sn_aprovado,
            ds_glosa, cd_cnpj_contratado, cd_cpf_contratado, cd_contratado_na_operadora, nm_contratado, ds_endereco, nr_endereco, nm_bairro, nm_cidade, uf, cd_ibge , nr_cep,
            nr_cnes, nr_carteira, nm_paciente, ds_plano, dt_validade, nr_cns, ds_identificador_beneficiario, cd_tipo_logradouro,tp_ident_beneficiario,nr_id_beneficiario,ds_template_ident_beneficiario,
            cd_validacao, cd_ausencia_validacao
        )
    values
        (   vRg.id, vRg.id_pai, vRg.cd_multi_empresa, vRg.cd_paciente, vRg.cd_convenio, vRg.cd_con_pla, vRg.cd_carteira, vRg.dh_solicitado, vRg.nm_xml, vRg.nr_registro_operadora_ans, vRg.dh_retorno, vRg.sn_aprovado,
            vRg.ds_glosa, vRg.cd_cnpj_contratado, vRg.cd_cpf_contratado, vRg.cd_contratado_na_operadora, vRg.nm_contratado, vRg.ds_endereco, vRg.nr_endereco, vRg.nm_bairro, vRg.nm_cidade, vRg.uf, vRg.cd_ibge , vRg.nr_cep,
            vRg.nr_cnes, vRg.nr_carteira, vRg.nm_paciente, vRg.ds_plano, vRg.dt_validade, vRg.nr_cns, vRg.ds_identificador_beneficiario, vRg.cd_tipo_logradouro, vRg.tp_ident_beneficiario, vRg.nr_id_beneficiario, vRg.ds_template_ident_beneficiario,
            vRg.cd_validacao, vRg.cd_ausencia_validacao );
    --
  end if;
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar '||vRg.NM_XML||'. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_SOL_ELEG:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_GERA_SOLIC (    pModo           in varchar2,
                            pIdMap          in number,
                            --
                            pIdTissSolGuia  dbamv.tiss_sol_guia.id%type,
                            --
                            pMsg            OUT varchar2,
                            pReserva        in varchar2) return varchar2 IS
  --
  vTemp             varchar2(1000);
  vResult           varchar2(1000);
  vCp               varchar2(1000);
  vRet              varchar2(1000);
  pCdConv           dbamv.convenio.cd_convenio%type;
  vTissSolGuia      dbamv.tiss_sol_guia%rowtype;
  vCtMensagem       RecMensagemLote;
  FalhaGuia         exception;
BEGIN
  -- leitura de cursores de uso geral
  if pIdTissSolGuia<>nvl(vcTissSolGuia.id,0) then
    vcTissSolGuia := null;
    open  cTissSolGuia(pIdTissSolGuia,null,null,null);
    fetch cTissSolGuia into vcTissSolGuia;
    close cTissSolGuia;
    if vcTissSolGuia.id is null then
      raise FalhaGuia;
    end if;

	if Nvl(vcAtendimento.cd_atendimento,'0')<>nvl(vcTissSolGuia.cd_atendimento,0) and vcTissSolGuia.cd_atendimento is not null then
      vcAtendimento := null;
      open  cAtendimento(vcTissSolGuia.cd_atendimento);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
      if vcAtendimento.cd_atendimento is null then
        raise FalhaGuia;
      end if;
    end if;

	IF vcTissSolGuia.cd_atendimento IS NULL then
      vcAtendimento := null;
      vcAtendimentoAUX := NULL;
    END IF;
  end if;

  ------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv   :=  vcTissSolGuia.cd_convenio;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(1001,pCdConv,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  ------------
  -- Reservado:  gravar Lote (tabela intermedi真ria?) no caso dos Anexos de Quimio/Radio/Opme
  ------------
  if vcTissSolGuia.nm_xml = 'anexoSolicitacaoOPME' THEN
  --vTemp := F_mensagemTISS(null,1001,'ENVIO_ANEXO',dbamv.pkg_mv2000.le_empresa,pCdConv,vcTissSolGuia.nr_guia,vCtMensagem,pMsg,null);
    vTemp := F_mensagemTISS(null,1001,'ENVIO_ANEXO',nEmpresaLogada,pCdConv,vcTissSolGuia.nr_guia,vCtMensagem,pMsg,null); --adhospLeEmpresa
  elsif vcTissSolGuia.nm_xml = 'anexoSolicitacaoQuimio' then
  --vTemp := F_mensagemTISS(null,1001,'ENVIO_ANEXO',dbamv.pkg_mv2000.le_empresa,pCdConv,vcTissSolGuia.nr_guia,vCtMensagem,pMsg,null);
    vTemp := F_mensagemTISS(null,1001,'ENVIO_ANEXO',nEmpresaLogada,pCdConv,vcTissSolGuia.nr_guia,vCtMensagem,pMsg,null); --adhospLeEmpresa
  elsif vcTissSolGuia.nm_xml = 'anexoSolicitacaoRadio' then
  --vTemp := F_mensagemTISS(null,1001,'ENVIO_ANEXO',dbamv.pkg_mv2000.le_empresa,pCdConv,vcTissSolGuia.nr_guia,vCtMensagem,pMsg,null);
    vTemp := F_mensagemTISS(null,1001,'ENVIO_ANEXO',nEmpresaLogada,pCdConv,vcTissSolGuia.nr_guia,vCtMensagem,pMsg,null); --adhospLeEmpresa
  elsif vcTissSolGuia.nm_xml = 'solicitacaoInternacao' then
  --vTemp := F_mensagemTISS(null,1001,'SOLICITACAO_PROCEDIMENTOS',dbamv.pkg_mv2000.le_empresa,pCdConv,vcTissSolGuia.nr_guia,vCtMensagem,pMsg,null);
  -- Oswaldo BH in真cio
  --vTemp := F_mensagemTISS(null,1001,'SOLICITACAO_PROCEDIMENTOS',nEmpresaLogada,pCdConv,vcTissSolGuia.nr_guia,vCtMensagem,pMsg,null); --adhospLeEmpresa
  --SUP-273226 Concatenando o vcTissSolGuia.nr_guia com ID da TISS_SOL_GUIA
    vTemp := F_mensagemTISS(null,1001,'SOLICITACAO_PROCEDIMENTOS',nEmpresaLogada,pCdConv,vcTissSolGuia.nr_guia||'@'||To_Char(pIdTissSolGuia),vCtMensagem,pMsg,null); --adhospLeEmpresa
  -- Oswaldo BH fim
  elsif vcTissSolGuia.nm_xml = 'solicitacaoProrrogacao' then
  --vTemp := F_mensagemTISS(null,1001,'SOLICITACAO_PROCEDIMENTOS',dbamv.pkg_mv2000.le_empresa,pCdConv,vcTissSolGuia.nr_guia,vCtMensagem,pMsg,null);
    vTemp := F_mensagemTISS(null,1001,'SOLICITACAO_PROCEDIMENTOS',nEmpresaLogada,pCdConv,vcTissSolGuia.nr_guia,vCtMensagem,pMsg,null); --adhospLeEmpresa
  else -- solicitacaoSP-SADT
  --vTemp := F_mensagemTISS(null,1001,'SOLICITACAO_PROCEDIMENTOS',dbamv.pkg_mv2000.le_empresa,pCdConv,vcTissSolGuia.nr_guia,vCtMensagem,pMsg,null);
    vTemp := F_mensagemTISS(null,1001,'SOLICITACAO_PROCEDIMENTOS',nEmpresaLogada,pCdConv,vcTissSolGuia.nr_guia,vCtMensagem,pMsg,null); --adhospLeEmpresa
  end if;
  --
  if pMsg is null then
    vTissSolGuia.ID     := pIdTissSolGuia;
    if vcTissSolGuia.nm_xml in ('anexoSolicitacaoQuimio','anexoSolicitacaoRadio','anexoSolicitacaoOPME') then
      vTissSolGuia.ID_PAI := vCtMensagem.idLote;        -- solicita真真o Onco/Opme (o ID_PAI 真 Tiss_lote)
    else
      vTissSolGuia.ID_PAI := vCtMensagem.idMensagem;    -- solicita真真o normal (o ID_PAI 真 a Tiss_mensagem
    end if;
    -- Grava真真o

    vResult := F_gravaTissSolGuia('ATUALIZA_ID',null,vTissSolGuia,pMsg,null);
    if pMsg is null then
      vResult  :=  lpad(vCtMensagem.idMensagem,20,'0');
    end if;
    --
  end if;
  --
  if vResult is null then
    ROLLBACK;
    return NULL;
  else
    COMMIT;
    return vResult;
  end if;
  --
  EXCEPTION
    when FalhaGuia then
      pMsg := 'Solicita真真o ID = '||pIdTissSolGuia||' n真o encontrada ou mal-formada.';
      RETURN null;
    when OTHERS then
      pMsg := 'FALHA na Solicita真真o de Autoriza真真o. Erro: '||SQLERRM;
      RETURN null;
  --
END;
--
--==================================================
FUNCTION  F_ct_anexoCabecalho(   pModo          in varchar2,
                                 pIdMap         in number,
                                 pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                 pCdConv        in dbamv.convenio.cd_convenio%type,
                                 pCdGuia        in dbamv.guia.cd_guia%type,
                                 pTpGuia        in varchar2,
                                 vCt            OUT NOCOPY RecAnexoCabec,
                                 pMsg           OUT varchar2,
                                 pReserva       in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	          varchar2(1000);
  --
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
  end if;
  --
  if pCdGuia<>nvl(vcGuia.cd_guia,0) then
    vcGuia := null;
    open  cGuia(pCdGuia,null);
    fetch cGuia into vcGuia;
    close cGuia;
  end if;
  ------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(pCdConv,vcAtendimento.cd_convenio_atd);
  ------------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if nvl(vcConv.cd_convenio,0)<>pCdConvTmp then
    open  cConv(pCdConvTmp);
    fetch cConv into vcConv;
    close cConv;
  end if;
  --
  if pModo is NOT null or tConf('ct_anexoCabecalho').tp_utilizacao > 0 then
    --
    -- registroANS--------------------------------------
    vCp := 'registroANS'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcConv.nr_registro_operadora_ans;
      vCt.registroANS := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,null,null,null);
      vResult := vCt.registroANS;
    end if;
    --
    -- numeroGuiaAnexo----------------------------------
    vCp := 'numeroGuiaAnexo'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if pCdGuia is not null and vcGuia.NR_GUIA is not null then
          vTemp := vcGuia.NR_GUIA;
        ELSE
        --vTemp := fnc_retornar_guia_faixa ( pCdConv,dbamv.pkg_mv2000.le_empresa,'SP',vcAtendimento.cd_paciente,pMsg);
          vTemp := fnc_retornar_guia_faixa ( pCdConv,nEmpresaLogada,'SP',vcAtendimento.cd_paciente,pMsg); --adhospLeEmpresa
          if pMsg is not null then
            RETURN NULL;
          end if;
        end if;
      vCt.numeroGuiaAnexo := F_ST(null,vTemp,vCp,pCdAtend,pCdGuia,null,null,null);
      vResult := vCt.numeroGuiaAnexo;
    end if;
    --
    -- numeroGuiaReferenciada---------------------------
    vCp := 'numeroGuiaReferenciada'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          vTemp := vcGuia.nr_guia_principal;
      vCt.numeroGuiaReferenciada := F_ST(null,vTemp,vCp,pCdAtend,pCdGuia,null,null,null);
      vResult := vCt.numeroGuiaReferenciada;
    end if;
    --
    -- numeroGuiaOperadora------------------------------
    vCp := 'numeroGuiaOperadora'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          vTemp := NULL;    --- PENDENTE - provis真rio, implementar mais
      vCt.numeroGuiaOperadora := F_ST(null,vTemp,vCp,pCdAtend,pCdGuia,null,null,null);
      vResult := vCt.numeroGuiaOperadora;
    end if;
    --
    -- dataSolicitacao----------------------------------
    vCp := 'dataSolicitacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          vTemp := null;    --- PENDENTE - provis真rio, implementar mais
          if pTpGuia = 'QM' then
            vTemp := to_char(sysdate,'yyyy-mm-dd');
          end if;
		  -- Oswaldo BH in真cio
		  IF pTpGuia = 'OP' THEN
            vTemp := to_char(Nvl(vcGuia.dt_solicitacao,sysdate),'yyyy-mm-dd');
          END IF;
		  -- Oswaldo BH fim
      vCt.dataSolicitacao := F_ST(null,vTemp,vCp,pCdAtend,pCdGuia,null,null,null);
      vResult := vCt.dataSolicitacao;
    end if;
    --
    -- senha--------------------------------------------
    vCp := 'senha'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          vTemp := NULL;    --- PENDENTE - provis真rio, implementar mais
      vCt.senha := F_ST(null,vTemp,vCp,pCdAtend,pCdGuia,null,null,null);
      vResult := vCt.senha;
    end if;
    --
    -- dataAutorizacao----------------------------------
    vCp := 'dataAutorizacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          vTemp := NULL;    --- PENDENTE - provis真rio, implementar mais
      vCt.dataAutorizacao := F_ST(null,vTemp,vCp,pCdAtend,pCdGuia,null,null,null);
      vResult := vCt.dataAutorizacao;
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ctm_anexoSolicitante(pModo          in varchar2,
                                 pIdMap         in number,
                                 pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                 pCdPrestador   in dbamv.prestador.cd_prestador%type,
                                 pCdConv        in dbamv.convenio.cd_convenio%type,
                                 vCt            OUT NOCOPY RecAnexoSolicitante,
                                 pMsg           OUT varchar2,
                                 pReserva       in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	        varchar2(1000);
  --
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    --
  end if;
  -------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(pCdConv,vcAtendimento.cd_convenio_atd);
  -------------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConvTmp,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  if pModo is NOT null or tConf('ctm_anexoSolicitante').tp_utilizacao > 0 then
    --
    if pCdPrestador is not null then
        if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>pCdPrestador||pCdConvTmp then
          vcPrestador := null;
          open  cPrestador(pCdPrestador,null, pCdConvTmp, NULL ,null);-- pda FATURCONV-1372
          fetch cPrestador into vcPrestador;
          close cPrestador;
        end if;
    else
      vcPrestador := null;
    end if;
    --
    -- nomeProfissional----------------------------------
    vCp := 'nomeProfissional'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcPrestador.nm_prestador;
      vCt.nomeProfissional := F_ST(null,vTemp,vCp,pCdAtend,null,null,null,null);
      vResult := vCt.nomeProfissional;
    end if;
    --
    -- telefoneProfissional------------------------------
    vCp := 'telefoneProfissional'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcPrestador.nr_fone_contato;
      vCt.telefoneProfissional := F_ST(null,vTemp,vCp,pCdAtend,null,null,null,null);
      vResult := vCt.telefoneProfissional;
    end if;
    --
    -- emailProfissional---------------------------------
    vCp := 'emailProfissional'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcPrestador.ds_email;
      vCt.emailProfissional := F_ST(null,vTemp,vCp,pCdAtend,null,null,null,null);
      vResult := vCt.emailProfissional;
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ct_diagnosticoOncologico(   pModo          in varchar2,
                                        pIdMap         in number,
                                        pCdAtend       in dbamv.atendime.cd_atendimento%type,
                                        pCdPreMed      in dbamv.pre_med.cd_pre_med%type,
                                        pCdConv        in dbamv.convenio.cd_convenio%type,
                                        pTpGuia        in varchar2,
                                        vCt            OUT NOCOPY RecDiagnosticoOnco,
                                        pMsg           OUT varchar2,
                                        pReserva       in varchar2) return varchar2 IS
  --
  vTemp	        varchar2(1000);
  vResult       varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  vCp	          varchar2(1000);
  vcCid         cCid%rowtype;
  --
  vcTratamento  cTratamento%rowtype;
  vRet          varchar2(1000);
  --
BEGIN
  -- leitura de cursores de uso geral
  if pCdAtend is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdAtend<>nvl(vDiagnosticoAtendimento.cd_atendimento,0) then
      vDiagnosticoAtendimento := null;
      open  cDiagnosticoAtendimento (pCdAtend, null);
      fetch cDiagnosticoAtendimento into vDiagnosticoAtendimento;
      close cDiagnosticoAtendimento;
    end if;

    vcTratamento := NULL;
    open  cTratamento(pCdPreMed,null);
    fetch cTratamento into vcTratamento;
    close cTratamento;

    open  cCid(vDiagnosticoAtendimento.cd_histologia,null);
    fetch cCid into vcCid;
    close cCid;
  end if;
  --------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  nvl(pCdConv,vcAtendimento.cd_convenio_atd);
  --------------------------------------------------------
  if nvl(vcConv.cd_convenio,0)<>pCdConvTmp then
    open  cConv(pCdConvTmp);
    fetch cConv into vcConv;
    close cConv;
  end if;
  --
  if pModo is NOT null or tConf('ct_diagnosticoOncologico').tp_utilizacao > 0 then
    --
    -- registroANS----------------------------------------
    vCp := 'dataDiagnostico'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vDiagnosticoAtendimento.dh_diagnostico;
      vCt.dataDiagnostico := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdPreMed,null,null);
      vResult := vCt.dataDiagnostico;
    end if;
    --
    -- diagnosticoCID-------------------------------------
    vCp := 'diagnosticoCID'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := NVL(vDiagnosticoAtendimento.CD_CID,vcAtendimento.CD_CID);
      vCt.diagnosticoCID := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdPreMed,null,null);
      vResult := vCt.diagnosticoCID;
    end if;
    --
    -- estadiamento---------------------------------------
    vCp := 'estadiamento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      vTemp := vDiagnosticoAtendimento.ds_estadiamento;
      vCt.estadiamento := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdPreMed,null,null);
      vResult := vCt.estadiamento;
    end if;
    --
    -- tumor---------------------------------------
    vCp := 'tumor'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN -- 真 partir da 3.03.00
    --vTemp := NULL; -- ??? pendente
      vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConvTmp,'PKG_MVPEP_INFO_TISS','TUMOR_QM',pCdAtend,pCdPreMed,null,null,null,null,null,null,vRet,null);
      vCt.tumor := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdPreMed,null,null);
      vResult := vCt.tumor;
    end if;
    --
    -- nodulo---------------------------------------
    vCp := 'nodulo'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN -- 真 partir da 3.03.00
    --vTemp := NULL; -- ??? pendente
      vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConvTmp,'PKG_MVPEP_INFO_TISS','NODULO_QM',pCdAtend,pCdPreMed,null,null,null,null,null,null,vRet,null);
      vCt.nodulo := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdPreMed,null,null);
      vResult := vCt.nodulo;
    end if;
    --
    -- metastase---------------------------------------
    vCp := 'metastase'; vTemp := null;
    if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 THEN -- 真 partir da 3.03.00
    --vTemp := NULL; -- ??? pendente
      vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConvTmp,'PKG_MVPEP_INFO_TISS','METASTASE_QM',pCdAtend,pCdPreMed,null,null,null,null,null,null,vRet,null);
      vCt.metastase := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdPreMed,null,null);
      vResult := vCt.metastase;
    end if;
    --
    -- tipoQuimioterapia---------------------------------------
    vCp := 'tipoQuimioterapia'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcTratamento.tp_quimioterapia ;
      vCt.tipoQuimioterapia := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdPreMed,null,null);
      vResult := vCt.tipoQuimioterapia;
    end if;
    --
    -- finalidade-----------------------------------------
    vCp := 'finalidade'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcTratamento.tp_finalidade ;
      vCt.finalidade := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdPreMed,null,null);
      vResult := vCt.finalidade;
    end if;
    --
    -- ecog-----------------------------------------------
    vCp := 'ecog'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcTratamento.tp_ecog;
      vCt.ecog := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdPreMed,null,null);
      vResult := vCt.ecog;
    end if;
    --
    -- planoTerapeutico---------------------------
    vCp := 'planoTerapeutico'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
    --vTemp := dbamv.pkg_mvpep_info_tiss.FNC_PKG_TISS_PEP_CAMPO_26(pCdAtend,NULL,NULL,NULL,NULL,NULL,NULL);
      vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConvTmp,'PKG_MVPEP_INFO_TISS','PLANOTERAPEUTICO_QM',pCdAtend,null,null,null,null,null,null,null,vRet,null);
      vCt.planoTerapeutico := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdPreMed,null,null);
      vResult := vCt.planoTerapeutico;
    end if;
    --
    -- diagnosticoHispatologico---------------------------
    vCp := 'diagnosticoHispatologico'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      vTemp := null;
      --vTemp := dbamv.pkg_mvpep_info_tiss.FNC_PKG_TISS_PEP_CAMPO_27(pCdAtend,pCdPreMed,NULL,NULL,NULL,NULL,NULL);
      vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConvTmp,'PKG_MVPEP_INFO_TISS','DIAGNOSTICOHISPATOLOGICO_QM',pCdAtend,pCdPreMed,null,null,null,null,null,null,vRet,null);
      vCt.diagnosticoHispatologico := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdPreMed,null,null);
      vResult := vCt.diagnosticoHispatologico;
    end if;
    --
    -- infoRelevantes-------------------------------------
    vCp := 'infoRelevantes'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
      vTemp := null; --vDiagnosticoAtendimento.ds_observacao;
    --vTemp := dbamv.pkg_mvpep_info_tiss.FNC_PKG_TISS_PEP_CAMPO_28(pCdAtend,null,NULL,NULL,NULL,NULL,NULL);
      vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConvTmp,'PKG_MVPEP_INFO_TISS','INFORELEVANTES_QM',pCdAtend,null,null,null,null,null,null,null,vRet,null);
      vCt.infoRelevantes := F_ST(null,vTemp,vCp,pCdConvTmp,pCdAtend,pCdPreMed,null,null);
      vResult := vCt.infoRelevantes;
    end if;
    --
  end if;
  --
  if pModo is NOT null then
    return vResult;
  else
    RETURN 'OK';
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ctm_anexoSolicitacaoQuimio  (   pModo           in varchar2,
                                            pIdMap          in number,
                                            pCdAtend        in dbamv.atendime.cd_atendimento%type,
				                                    pCdPreMed       in dbamv.pre_med.cd_pre_med%type,
				                                    pCdTratamento   in dbamv.tratamento.cd_tratamento%type,
				                                    pNrCiclo        in dbamv.ciclo_tratamento.nr_ciclo%type,
				                                    pNrSessao       in dbamv.sessao_tratamento.nr_sessao%type,
				                                    pCdGuia         in dbamv.guia.cd_guia%type,
                                            pMsg            OUT varchar2,
                                            pReserva        in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(1000);
  vCp	              varchar2(1000);
  vRet              varchar2(1000);
  vcItensSolProc    cItensSolProc%rowtype;
  vTissSolGuia      dbamv.tiss_sol_guia%rowtype;
  vTissItSolGuia    dbamv.tiss_itsol_guia%rowtype;
  vTissItSolGuiaTratAnt dbamv.tiss_itsol_guia_trat_anterior%rowtype;
  pCdConv           dbamv.convenio.cd_convenio%type;
  pCdPaciente       dbamv.paciente.cd_paciente%type;
  vCtProcDados      RecProcDados;
  vCtAutorizSadt    RecAutorizSadt;
  vCtBenef          RecBenef;
  vCtContrat        RecContrat; -- Oswaldo BH
  vCtAnexoCabec     RecAnexoCabec;
  vCtAnexoSolicitante   RecAnexoSolicitante;
  vCtRecDiagnosticoOnco RecDiagnosticoOnco;
  vCtDadosSolic     RecDadosSolicitacao;
  vTussRel          RecTussRel;
  vTuss             RecTuss;
  vcItguia          cItGuia%rowtype;
  vcPreMed          cPreMed%rowtype;
  vcTissSolGuiaTpOrigem cTissSolGuiaTpOrigem%rowtype;
  nAltura           number;
  nPeso             number;
  nSupCorp          number;
  vcTratamento      cTratamento%rowtype;
  vPesqUnid         varchar2(1000);
  pCdPrestSolTmp    number;
  --Oswaldo FATURCONV-18974 inicio
  vcTmpSol          cTmpSol%ROWTYPE;
  nCdConPlaTmp      NUMBER;
  pcdTmpSol         NUMBER;
  ptpTmpSol         varchar2(20);
  --Oswaldo FATURCONV-18974 fim
  nCdAtendTmp       dbamv.atendime.cd_atendimento%TYPE; --TISS-608
  --
BEGIN
  --Oswaldo FATURCONV-18974 inicio
  pcdTmpSol := SubStr(pReserva,12);
  ptpTmpSol := SubStr(pReserva,1,11);

  if Nvl(ptpTmpSol, 'X') = 'SOLICITACAO' THEN
    OPEN  cTmpSol(pcdTmpSol);
    FETCH cTmpSol INTO vcTmpSol;
    CLOSE cTmpSol;
    nCdPrestExtSol:= vcTmpSol.cd_pres_ext;
    --
    --Oswaldo FATURCONV-22468 inicio
    IF vcTmpSol.cd_paciente IS NOT NULL and (Nvl(vcTmpSol.cd_paciente, 0) <> Nvl(vcPaciente.cd_paciente, 0)) THEN
      open  cPaciente(vcTmpSol.cd_paciente, vcTmpSol.CD_CONVENIO, vcTmpSol.cd_con_pla,vcTmpSol.cd_atendimento,NULL,NULL);
      FETCH cPaciente INTO vcPaciente;
      CLOSE cPaciente;
    END IF;
    --Oswaldo FATURCONV-22468 fim
    --
  END IF;
  --Oswaldo FATURCONV-18974 fim
  nCdAtendTmp := Nvl(pCdAtend,vcTmpSol.cd_atendimento); --TISS-608
  -- leitura de cursores de uso geral
  vcAtendimento := null;
  if nCdAtendTmp is not null then
    open  cAtendimento(nCdAtendTmp);
    fetch cAtendimento into vcAtendimento;
    close cAtendimento;
  end if;
  --
  vcGuia := null;
  if pCdGuia is not null then
    open  cGuia(pCdGuia,null);
    fetch cGuia into vcGuia;
    close cGuia;
  end if;
  vcTissSolGuia := null;
  open  cTissSolGuia(vcTmpSol.id_sol,vcGuia.cd_guia, vcGuia.nr_guia, null); --Oswaldo FATURCONV-18974
  fetch cTissSolGuia into vcTissSolGuia;
  close cTissSolGuia;
  --Oswaldo FATURCONV-26126 inicio
  if vcTissSolGuia.id_pai is not NULL or (vcTissSolGuia.id IS NOT NULL AND vcTissSolGuia.cd_guia IS NOT NULL) then
  --Oswaldo FATURCONV-26126 fim
    RETURN LPAD(vcTissSolGuia.id,20,'0')||','; -- se j真 foi solicitada eletr真nicamente, retorna a pr真pria guia
  else
    vRet := F_apaga_tiss_sol(null,vcTissSolGuia.id,pMsg,null); -- cancela solicita真真o anterior para sincronizar com Guia
    if pMsg is not null then
      RETURN null;
    end if;
  end if;
  --
  if pCdPreMed is not null then
    open  cPreMed(pCdPreMed,null);
    fetch cPreMed into vcPreMed;
    close cPreMed;
    open  cTissSolGuiaTpOrigem(nCdAtendTmp,pCdPreMed,'PRESCRICAO');
    fetch cTissSolGuiaTpOrigem into vcTissSolGuiaTpOrigem;
    close cTissSolGuiaTpOrigem;
    if vcTissSolGuiaTpOrigem.id_pai is not null then
      RETURN LPAD(vcTissSolGuiaTpOrigem.id,20,'0')||','; -- se j真 foi solicitada eletr真nicamente, retorna a pr真pria guia
    else
      vRet := F_apaga_tiss_sol(null,vcTissSolGuiaTpOrigem.id,pMsg,null); -- cancela solicita真真o anterior para sincronizar
      if pMsg is not null then
        RETURN null;
      end if;
    end if;
    -- PENDENTE - estudar acionamento din真mico (PROBLEMA: sql din真mico n真o suporte Boolean)
    --if not (dbamv.pkg_avaliacao.fnc_super_corporea_tiss(pCdAtend,nAltura,nPeso,nSupCorp)) then
    --  null;
    --end if;
    if nCdAtendTmp<>nvl(vDiagnosticoAtendimento.cd_atendimento,0) then
      vDiagnosticoAtendimento := null;
      open  cDiagnosticoAtendimento (nCdAtendTmp, null);
      fetch cDiagnosticoAtendimento into vDiagnosticoAtendimento;
      close cDiagnosticoAtendimento;
    end if;
    open  cTratamento(pCdPreMed,null);
    fetch cTratamento into vcTratamento;
    close cTratamento;
    --
  end if;
  --
  --------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  --Oswaldo FATURCONV-18974 inicio
  pCdConv     :=  Nvl(vcAtendimento.cd_convenio_atd, vcTmpSol.cd_convenio);
  pCdPaciente :=  Nvl(vcAtendimento.cd_paciente, vcTmpSol.cd_paciente);
--pCdPrestSolTmp    :=  nvl(nvl(vcAtendimento.cd_prestador,vcPreInt.cd_prestador),vcAviCir.cd_prestador);
  pCdPrestSolTmp    :=  Nvl(Nvl(vcPreMed.cd_prestador, vcAtendimento.cd_prestador), vcTmpSol.cd_prestador);
  nCdConPlaTmp      :=  vcTmpSol.cd_con_pla;
  --Oswaldo FATURCONV-18974 fim
  --------
  if nvl(vcConv.cd_convenio,9999) <> nvl(pCdConv,0) THEN
    vcConv := NULL;
    open  cConv(pCdConv);
    fetch cConv into vcConv;
    close cConv;
  end if;
  --
  if pCdPaciente <> nvl(vcPaciente.cd_paciente, 0) then
    vcPaciente := null;
	open  cPaciente(pCdPaciente, pCdConv, vcAtendimento.cd_con_pla,nCdAtendTmp,'E', To_Date( vcAtendimento.dt_atendimento, 'yyyy/mm/dd') );
    fetch cPaciente into vcPaciente;
    close cPaciente;
  end if;
  --
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  vCp := 'ctm_anexoSolicitacaoQuimio'; vTemp := null;
  if tConf(vCp).tp_utilizacao > 0 then
    --
    -- cabecalhoAnexo----------------------------------------------
    vRet := F_ct_anexoCabecalho(null,1739,nCdAtendTmp,pCdConv,pCdGuia,'QM',vCtAnexoCabec,pMsg,null);
    if vRet = 'OK' then
      vTissSolGuia.NR_REGISTRO_OPERADORA_ANS   := vCtAnexoCabec.registroANS;
      vTissSolGuia.NR_GUIA                     := vCtAnexoCabec.numeroGuiaAnexo;
      vTissSolGuia.NR_GUIA_PRINCIPAL           := vCtAnexoCabec.numeroGuiaReferenciada;
      vTissSolGuia.NR_GUIA_OPERADORA           := vCtAnexoCabec.numeroGuiaOperadora;
      vTissSolGuia.DH_SOLICITACAO              := vCtAnexoCabec.dataSolicitacao;
      vTissSolGuia.CD_SENHA                    := vCtAnexoCabec.senha;
      vTissSolGuia.DT_AUTORIZACAO              := vCtAnexoCabec.dataAutorizacao;
    else
      RETURN NULL;
    end if;
    --
    -- dadosBeneficiario-------------------------------------------
    vRet := F_ct_beneficiarioDados(null,1747,nCdAtendTmp,NULL,pCdPaciente,pCdConv,'E',vCtBenef,pMsg,'RelerPac'||'#'||vcTmpSol.nr_carteira); --Oswaldo FATURCONV-18974
    if vRet = 'OK' then
      vTissSolGuia.NR_CARTEIRA                     := vCtBenef.numeroCarteira;
      vTissSolGuia.SN_ATENDIMENTO_RN               := vCtBenef.atendimentoRN;
      vTissSolGuia.NM_PACIENTE                     := vCtBenef.nomeBeneficiario;
	  vTissSolGuia.NM_SOCIAL_PACIENTE              := vCtBenef.nomeSocialBeneficiario; --Oswaldo FATURCONV-26150
      vTissSolGuia.NR_CNS                          := vCtBenef.numeroCNS;
      vTissSolGuia.TP_IDENT_BENEFICIARIO           := vCtBenef.tipoIdent;
      vTissSolGuia.NR_ID_BENEFICIARIO              := vCtBenef.identificadorBeneficiario;
      --vTissSolGuia.DS_TEMPLATE_IDENT_BENEFICIARIO  := vCtBenef.templateBiometrico; --Oswaldo FATURCONV-22404
    end if;
    --
    -- dadosComplementaresBeneficiario
    -- peso--------------------------------------------------------
    vCp := 'peso'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        if pCdPreMed is not null then
    	  vRet := dbamv.fnc_ffcv_gera_tiss(vcAtendimento.cd_convenio_atd,'FNC_SUPER_CORPOREA_TISS',nCdAtendTmp,'PESO',pCdPreMed,null,null,null,null,null,null,vTemp,null); --OP 46052
        else
          vTemp := null;
        end if;
      vTissSolGuia.NR_PESO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,null,null);
    end if;
    --
    -- altura------------------------------------------------------
    vCp := 'altura'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        if pCdPreMed is not null then
    	  vRet := dbamv.fnc_ffcv_gera_tiss(vcAtendimento.cd_convenio_atd,'FNC_SUPER_CORPOREA_TISS',nCdAtendTmp,'ALTURA',pCdPreMed,null,null,null,null,null,null,vTemp,null); --OP 46052
        else
          vTemp := null;
        end if;
      vTissSolGuia.NR_ALTURA := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,null,null);
    end if;
    --
    -- superficieCorporal------------------------------------------
    vCp := 'superficieCorporal'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        if pCdPreMed is not null then
    	  vRet := dbamv.fnc_ffcv_gera_tiss(vcAtendimento.cd_convenio_atd,'FNC_SUPER_CORPOREA_TISS',nCdAtendTmp,'SUPCORP',pCdPreMed,null,null,null,null,null,null,vTemp,null); --OP 46052
        else
          vTemp := null;
        end if;
      vTissSolGuia.NR_SUPERFICIE_CORPORAL := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,null,null);
    end if;
    --
    -- idade-------------------------------------------------------
    vCp := 'idade'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTemp := TRUNC(MONTHS_BETWEEN(sysdate,to_date(vcPaciente.dt_nascimento,'yyyy-mm-dd'))/12);
      vTissSolGuia.NR_IDADE := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,null,null);
    end if;
    --
    -- sexo--------------------------------------------------------
    vCp := 'sexo'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTussRel.TP_SEXO := vcPaciente.tp_sexo;
        vResult := F_DM(43,nCdAtendTmp,null,null,null,vTussRel,vTuss,pMsg,null);
        vTemp := vTuss.CD_TUSS;
      vTissSolGuia.TP_SEXO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,null,null);
    end if;
    --
    -- medicoSolicitante-------------------------------------------
    --vRet := F_ctm_anexoSolicitante(null,1759,pCdAtend,vcAtendimento.cd_prestador,pCdConv,vCtAnexoSolicitante,pMsg,null);
    vRet := F_ctm_anexoSolicitante(null,1759,nCdAtendTmp,pCdPrestSolTmp,pCdConv,vCtAnexoSolicitante,pMsg,null);
    if vRet = 'OK' then
      vTissSolGuia.NM_PRESTADOR             := vCtAnexoSolicitante.nomeProfissional;
      vTissSolGuia.NR_TELEFONE_PROFISSIONAL := vCtAnexoSolicitante.telefoneProfissional;
      vTissSolGuia.DS_EMAIL_PROFISSIONAL    := vCtAnexoSolicitante.emailProfissional;
    end if;
    --
    -- diagnosticoOncologicoQuimioterapia
    vRet :=F_ct_diagnosticoOncologico ( null,1763,nCdAtendTmp,pCdPreMed,pCdConv,'QM',vCtRecDiagnosticoOnco,pMsg,null);
    if vRet = 'OK' then
      vTissSolGuia.DT_DIAGNOSTICO       := vCtRecDiagnosticoOnco.dataDiagnostico;
      vTissSolGuia.CD_CID               := vCtRecDiagnosticoOnco.diagnosticoCID;
      vTissSolGuia.TP_ESTADIAMENTO      := vCtRecDiagnosticoOnco.estadiamento;
      vTissSolGuia.TP_QUIMIOTERAPIA     := vCtRecDiagnosticoOnco.tipoQuimioterapia;
      vTissSolGuia.TP_FINALIDADE        := vCtRecDiagnosticoOnco.finalidade;
      vTissSolGuia.TP_ECOG              := vCtRecDiagnosticoOnco.ecog;
      vTissSolGuia.CD_TUMOR             := vCtRecDiagnosticoOnco.tumor;
      vTissSolGuia.CD_NODULO            := vCtRecDiagnosticoOnco.nodulo;
      vTissSolGuia.CD_METASTASE         := vCtRecDiagnosticoOnco.metastase;
      vTissSolGuia.DS_PLANO_TERAPEUTICO := vCtRecDiagnosticoOnco.planoTerapeutico;
      if pCdGuia is not NULL THEN
        vTissSolGuia.DS_HDA             := vcGuia.ds_justificativa;
      else
        vTissSolGuia.DS_HDA             := vCtRecDiagnosticoOnco.diagnosticoHispatologico;
      end if;
      vTissSolGuia.DS_INFO_RELEVANTES   := vCtRecDiagnosticoOnco.infoRelevantes;
    end if;
    --
    -- numeroCiclos------------------------------------------------
    vCp := 'numeroCiclos'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        --
        if pCdPreMed is not null then
          vTemp := vcTratamento.qt_ciclo; -- somente se origem prescri真真o
        else
          vTemp := null;
        end if;
      vTissSolGuia.NR_CICLOS := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,null,null);
    end if;
    --
    -- cicloAtual--------------------------------------------------
    vCp := 'cicloAtual'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        if pCdPreMed is not null then
          vTemp := vcTratamento.nr_ciclo_atual; -- somente se origem prescri真真o
        else
          vTemp := null;
        end if;
      vTissSolGuia.NR_CICLO_ATUAL := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,null,null);
    end if;
    --
    -- diasCicloAtual--------------------------------------------------
    vCp := 'diasCicloAtual'; vTemp := null;
    if tconf.EXISTS(vCp) AND tConf(vCp).tp_utilizacao>0 then
        if pCdPreMed is not null then
        --vTemp := NULL; -- ??? pendente
          vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConv,'PKG_MVPEP_INFO_TISS','NR_DIAS_CICLO_QM',nCdAtendTmp,pCdPreMed,null,null,null,null,null,null,vRet,null);
        else
          vTemp := null;
        end if;
      vTissSolGuia.NR_DIAS_CICLO_ATUAL := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,null,null);
    end if;
    --
    -- intervaloCiclos---------------------------------------------
    vCp := 'intervaloCiclos'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        --
        if pCdPreMed is not null then
        --vTemp := vcTratamento.qt_intervalo_dias; -- somente se origem prescri真真o
          vTemp := vcTratamento.NR_TOT_DIA; -- somente se origem prescri真真o
        else
          vTemp := null;
        end if;
      vTissSolGuia.NR_INTERVALO_CICLOS := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,null,null);
    end if;
    --
    -- observacao--------------------------------------------------
    vCp := 'observacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        if pCdGuia is not null then
          vTemp := substr(vcGuia.ds_observacao,1,1000);
        else
          vTemp := null;
        end if;
      vTissSolGuia.DS_OBSERVACAO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,null,null);
    end if;
    --
    -- assinaturaDigital-------------------------------------------
    --vRet := F_assinaturaDigital(null,9999,null,null,null,null,null,null);
    --
	-- Oswaldo BH in真cio
	-- dadosSolicitante
    -- contratadoSolicitante-------------------------------------
    -- OBS.: essa TAG n真o faz parte na solicita真真o do QUIMIO, por真m 真 necess真ria uma vez que caso haja um servi真o SOLICITA_STATUS_AUTORIZACAO
    -- do QUIMIO esses campos ser真o necess真rios
    if  Nvl(ptpTmpSol, 'X') <> 'SOLICITACAO' THEN --Oswaldo FATURCONV-18974
      vRet := F_ct_contratadoDados(null,1544,nCdAtendTmp,null,null,null,pCdPrestSolTmp,pCdConv,vCtContrat,pMsg,'SOLIC_SP');
      if vRet = 'OK' then
        vTissSolGuia.CD_OPERADORA             := vCtContrat.codigoPrestadorNaOperadora;
        vTissSolGuia.CD_CPF                   := vCtContrat.cpfContratado;
        vTissSolGuia.CD_CGC                   := vCtContrat.cnpjContratado;
        vTissSolGuia.NM_PRESTADOR_CONTRATADO  := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 inicio
      end if;
    END IF;
	-- Oswaldo BH fim
	--
    -- informa真真es complementares de apoio
    vTissSolGuia.cd_paciente        := pCdPaciente;
    vTissSolGuia.cd_convenio        := pCdConv;
    vTissSolGuia.cd_atendimento     := nCdAtendTmp;
    vTissSolGuia.dt_emissao         := to_char(sysdate,'yyyy-mm-dd');
    vTissSolGuia.DH_SOLICITADO      := to_date( to_char( sysdate, 'dd/mm/yyyy' ) || ' ' ||to_char( sysdate, 'hh24:mi'    ), 'dd/mm/yyyy hh24:mi' );
    --vTissSolGuia.CD_PRESTADOR_SOL   := vcAtendimento.cd_prestador; --pCdPrestSolTmp;
    vTissSolGuia.CD_PRESTADOR_SOL   := pCdPrestSolTmp;
    vTissSolGuia.cd_con_pla         := vcPaciente.cd_con_pla; -- fora de uso, mas obrigat真rio por Constraint
    vTissSolGuia.ds_con_pla         := Nvl(vcPaciente.ds_con_pla, 'X'); -- fora de uso, mas obrigat真rio por Constraint
    vTissSolGuia.sn_tratou_retorno  := 'N';
    vTissSolGuia.sn_cancelado       := 'N';
  --vTissSolGuia.cd_multi_empresa   := dbamv.pkg_mv2000.le_empresa;
    vTissSolGuia.cd_multi_empresa   := nEmpresaLogada; --adhospLeEmpresa
    vTissSolGuia.tp_atendimento     := 'Q';
    vTissSolGuia.SN_PREVISAO_USO_OPME   := 'N';
    vTissSolGuia.SN_PREVISAO_USO_QUIMIO := 'S';
  --vTissSolGuia.CD_VERSAO_TISS_GERADA  := '3.02.00';
    vTissSolGuia.CD_VERSAO_TISS_GERADA  := Nvl( vcConv.cd_versao_tiss, '3.02.00' ); --OP 48413
    if pCdGuia is not NULL then
      vTissSolGuia.cd_guia            := pCdGuia;
      vTissSolGuia.tp_origem_sol      := 'GUIA';
      vTissSolGuia.cd_origem_sol      := pCdGuia;
    elsif pCdPreMed is not null then
      vTissSolGuia.tp_origem_sol      := 'PRESCRICAO';
      vTissSolGuia.cd_origem_sol      := pCdPreMed;
    end if; -- OUTROS ?
    --
    --Oswaldo FATURCONV-18974 inicio
    if  Nvl(ptpTmpSol, 'X') = 'SOLICITACAO' then
		  vTissSolGuia.tp_origem_sol := 'SOLICITACAO';
	  end if;
    --Oswaldo FATURCONV-18974 fim
    vTissSolGuia.nm_social_paciente := vcPaciente.nm_social_paciente;  --Oswaldo FATURCONV-22468
    -- Grava真真o

    vResult := F_gravaTissSolGuia('INSERE','SOL_QUIMIO',vTissSolGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
    -- drogasSolicitadas-------------------------------------------
    OPEN  cItGuia(Nvl(pCdGuia,pcdTmpSol),pCdPreMed, ptpTmpSol); -- Oswaldo FATURCONV-18974
    --
    LOOP
      --
      FETCH cItGuia into vcItGuia;
      EXIT WHEN cItGuia%NOTFOUND;
      --
      if cItGuia%FOUND then
        --
        -- dataProvavel--------------------------------------------
        vCp := 'dataProvavel'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
          if pCdPreMed is not null then
          --vTemp := vcTratamento.dh_inicio; -- somente se origem prescri真真o
            vTemp := vcItGuia.DH_INICIAL;
          else
            vTemp := null;
          end if;
          vTissItSolGuia.DT_PROVAVEL := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,vcItGuia.cd_pro_fat,null);
        end if;
        --
        -- procedimento--------------------------------------------
        vRet := F_ct_procedimentoDados(null,1774,null,null,null,null,vcItGuia.cd_pro_fat,pCdConv,'SOL_QUIMIO',vCtProcDados,pMsg,null);
        if vRet = 'OK' then
          vTissItSolGuia.TP_TAB_FAT         := vCtProcDados.codigoTabela;
          vTissItSolGuia.CD_PROCEDIMENTO    := vCtProcDados.codigoProcedimento;
          vTissItSolGuia.DS_PROCEDIMENTO    := vCtProcDados.descricaoProcedimento;
        end if;
        --
        -- qtDoses-------------------------------------------------
        vCp := 'qtDoses'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
        --vTemp := vcItGuia.qt_autorizado;
        --vTemp := dbamv.pkg_mvpep_info_tiss.FNC_PKG_TISS_PEP_CAMPO_33(null,null,vcItGuia.cd_itpre_med,NULL,NULL,NULL,NULL);
          vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConv,'PKG_MVPEP_INFO_TISS','QTDOSES_QM',null,null,vcItGuia.cd_itpre_med,null,null,null,null,null,vRet,null);

          vTissItSolGuia.QT_DOSES := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,vcItGuia.cd_pro_fat,null);
        end if;
        --
        -- unidadeMedida------------------------------------
        vCp := 'unidadeMedida'; vTemp := null;
        --if tconf.EXISTS(vCp) and  vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        if tConf(vCp).tp_utilizacao>0 then
          --FUTURO RELACIONAMENTO COM A TELA
          --vTemp := F_DM(60,pCdAtend,pCdConta,pCdLanc,pCdItLan,vTussRel,vTuss,pMsg,null);
          --vTemp := vTuss.CD_TUSS;

		  --CIMP-2402
          if vcItGuia.cd_pro_fat <> nvl(vcProFat.cd_pro_fat,'X') then
            open  cProFat(vcItGuia.cd_pro_fat);
            fetch cProFat into vcProFat;
            close cProFat;
          end if;
          --
          if vCodUnid is null then
            declare
              type rUnid is record (cd_tuss dbamv.tuss.cd_tuss%type, ds_tuss dbamv.tuss.ds_tuss%type, ds_descricao_detalhada dbamv.tuss.ds_descricao_detalhada%type);
              type tUnid is table of rUnid;
              vUnid tUnid;
            begin
              --
              SELECT cd_tuss, ds_tuss, ds_descricao_detalhada BULK COLLECT into vUnid from dbamv.tuss where cd_tip_tuss = 60 order by cd_tuss;
              --
              for i in vUnid.first..vUnid.last loop
                vCodUnid      := vCodUnid||','||vUnid(i).cd_tuss;
                vTermoUnid    := vTermoUnid||','||vUnid(i).ds_tuss;
                vDescUnid     := vDescUnid||','||UPPER(vUnid(i).ds_descricao_detalhada);
              end loop;
            exception
              when others then
                null;
            end;
          end if;
          --
          declare
            k number; k2 number;
          begin
            vPesqUnid := vTermoUnid; -- procura por termo EXATO
            k := instr(vTermoUnid||',',','||vcProFat.ds_unidade||','); --k := instr(vTermoUnid,','||vcProFat.ds_unidade);
            IF k=0 THEN              -- procura por termo em 3 d真gitos
              k := instr(vTermoUnid,','||SubStr(vcProFat.ds_unidade,1,3));
            END IF;
            IF k=0 THEN              -- procura por termo em 2 d真gitos
              k := instr(vTermoUnid,','||SubStr(vcProFat.ds_unidade,1,2));
            END IF;
            if k=0 then
              vPesqUnid := vDescUnid; -- procura por descri真真o detalhada
              k := instr(vPesqUnid,','||vcProFat.ds_unidade);
            end if;
            if k<>0 then
              for k1 in 1..100 loop
                k2 := instr(vPesqUnid,',',1,k1);
                if k2 = k then
                  vTemp := substr(vCodUnid,k1*4-2,3);
                  EXIT;
                end if;
              end loop;
            end if;
          exception
           when others then
             null;
          end;
          vTissItSolGuia.CD_UNIDADE_MEDIDA := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,vcItGuia.cd_pro_fat,null);     -- dm_unidadeMedida
        end if;
        --
        -- viaAdministracao----------------------------------------
        vCp := 'viaAdministracao'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
        --vTemp := null;  -- PENDENTE
        --vTemp := dbamv.pkg_mvpep_info_tiss.FNC_PKG_TISS_PEP_CAMPO_34(null,null,vcItGuia.cd_itpre_med,NULL,NULL,NULL,NULL);
          vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConv,'PKG_MVPEP_INFO_TISS','VIAADMINISTRACAO_QM',null,null,vcItGuia.cd_itpre_med,null,null,null,null,null,vRet,null);
          vTissItSolGuia.TP_VIA_ADMINISTRACAO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,vcItGuia.cd_pro_fat,null);
        end if;
        --
        -- frequencia----------------------------------------------
        vCp := 'frequencia'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
        --vTemp := null; -- PENDENTE
        --vTemp := dbamv.pkg_mvpep_info_tiss.FNC_PKG_TISS_PEP_CAMPO_35(null,null,vcItGuia.cd_itpre_med,NULL,NULL,NULL,NULL);
          vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConv,'PKG_MVPEP_INFO_TISS','FREQUENCIA_QM',null,null,vcItGuia.cd_itpre_med,null,null,null,null,null,vRet,null);
          vTissItSolGuia.NR_FREQUENCIA := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,vcItGuia.cd_pro_fat,null);
        end if;
        -- informa真真es complementares de apoio
        vTissItSolGuia.id_pai           := vTissSolGuia.ID;
        if pCdGuia is not null then
          vTissItSolGuia.cd_itorigem_sol  := vcItGuia.cd_it_guia;
        elsif pCdPreMed is not null then
          vTissItSolGuia.cd_itorigem_sol  := vcItGuia.cd_itpre_med;
        end if; -- OUTROS ?
        vTissItSolGuia.CD_PRO_FAT       := vcItGuia.cd_pro_fat;
        vTissItSolGuia.sn_opme          := 'N';
        -- Grava真真o
        vRet := F_gravaTissItSolGuia('INSERE','SOL_QUIMIO',vTissItSolGuia,pMsg,null);
        if pMsg is not null then
          RETURN NULL;
        end if;
        --
      end if;
      --
    END LOOP;
    --
    close cItGuia;
    --
    -- tratamentosAnteriores------------------------------------------
    /*
    OPEN  cTratAnteriores(pTpTrat,pCdTratamento,null); -- PENDENTE
    --
    LOOP
        --
        -- cirurgia-------------------------------------------------
        -- datacirurgia---------------------------------------------
        -- areaIrradiada--------------------------------------------
        -- dataIrradiacao-------------------------------------------
        vRet := F_gravaTissItSolGuiaTratAnt('INSERE','SOL_QUIMIO',vTissItSolGuiaTratAnt,pMsg,null);
      --
    END LOOP;
    --
    close cTratAnteriores;
    */

    -- tratamentosAnteriores------------------------------------------
    -- informa真真es complementares de apoio
    vTissItSolGuiaTratAnt.id_pai           := vTissSolGuia.ID;
    vTissItSolGuiaTratAnt.tp_tratamento := 'Q'; --Quimioterapia Q ou Radiotarapia R
    --
    -- cirurgia-------------------------------------------------   DS_CIRURGIA
    vCp := 'cirurgia'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
      vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConv,'PKG_MVPEP_INFO_TISS','DS_CIRURGIA_QM',nCdAtendTmp,pCdPreMed,null,null,null,null,null,null,vRet,null);
      vTissItSolGuiaTratAnt.DS_HISTORICO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,vcItGuia.cd_pro_fat,null);
    end if;
    --
    -- datacirurgia---------------------------------------------  DT_REALIZACAO
    vCp := 'datacirurgia'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
      vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConv,'PKG_MVPEP_INFO_TISS','DT_REALIZACAO_QM',nCdAtendTmp,pCdPreMed,null,null,null,null,null,null,vRet,null);
      vTemp := to_char(To_Date(vTemp,'DD-MM-RRRR'),'RRRR-MM-DD') ; --ajuste na formatacao
      vTissItSolGuiaTratAnt.DT_HISTORICO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,vcItGuia.cd_pro_fat,null);
    end if;
    --
    if vTissItSolGuiaTratAnt.DS_HISTORICO IS NOT NULL OR vTissItSolGuiaTratAnt.DT_HISTORICO IS NOT NULL then
      vTissItSolGuiaTratAnt.tp_historico  := 'C'; --C Cirurgia, Q Quimioterapia, R Radioterapia
      vRet := F_gravaTissItSolGuiaTratAnt('INSERE','SOL_QUIMIO',vTissItSolGuiaTratAnt,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
    end if;
    --
    -- areaIrradiada--------------------------------------------  DS_AREA_IRRADIADA
    vCp := 'areaIrradiada'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
      vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConv,'PKG_MVPEP_INFO_TISS','DS_AREA_IRRADIADA_QM',nCdAtendTmp,pCdPreMed,null,null,null,null,null,null,vRet,null);
      vTissItSolGuiaTratAnt.DS_HISTORICO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,vcItGuia.cd_pro_fat,null);
    end if;
    --
    -- dataIrradiacao-------------------------------------------  DT_APLICACAO
    vCp := 'dataIrradiacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
      vTemp := dbamv.fnc_ffcv_gera_tiss(pCdConv,'PKG_MVPEP_INFO_TISS','DT_APLICACAO_QM',nCdAtendTmp,pCdPreMed,null,null,null,null,null,null,vRet,null);
      vTemp := to_char(To_Date(vTemp,'DD-MM-RRRR'),'RRRR-MM-DD') ; --ajuste na formatacao
      vTissItSolGuiaTratAnt.DT_HISTORICO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,pCdPreMed,vcItGuia.cd_pro_fat,null);
    end if;
    --
    if vTissItSolGuiaTratAnt.DS_HISTORICO IS NOT NULL OR vTissItSolGuiaTratAnt.DT_HISTORICO IS NOT NULL then
      vTissItSolGuiaTratAnt.tp_historico  := 'R'; --C Cirurgia, Q Quimioterapia, R Radioterapia
      vRet := F_gravaTissItSolGuiaTratAnt('INSERE','SOL_QUIMIO',vTissItSolGuiaTratAnt,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
    end if;

    --

    vRet := F_gravaTissSolGuia('ATUALIZA_INCONSISTENCIA','SOL_QUIMIO',vTissSolGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
  end if;
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS THEN
      IF cItGuia%ISOPEN THEN
        CLOSE cItGuia;
      END IF;
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ctm_anexoSolicitacaoRadio   (   pModo           in varchar2,
                                            pIdMap          in number,
                                            pCdAtend        in dbamv.atendime.cd_atendimento%type,
                                            pCdPreMed       in dbamv.pre_med.cd_pre_med%type,
                                            pCdGuia         in dbamv.guia.cd_guia%type,
                                            pMsg            OUT varchar2,
                                            pReserva        in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(1000);
  vCp	            varchar2(1000);
  vRet              varchar2(1000);
  vcItensSolProc    cItensSolProc%rowtype;
  vTissSolGuia      dbamv.tiss_sol_guia%rowtype;
  vTissItSolGuia    dbamv.tiss_itsol_guia%rowtype;
  pCdConv           dbamv.convenio.cd_convenio%type;
  pCdPaciente       dbamv.paciente.cd_paciente%type;
  vCtProcDados      RecProcDados;
  vCtAutorizSadt    RecAutorizSadt;
  vCtBenef          RecBenef;
  vCtContrat        RecContrat; -- Oswaldo BH
  vCtAnexoCabec     RecAnexoCabec;
  vCtAnexoSolicitante   RecAnexoSolicitante;
  vCtRecDiagnosticoOnco RecDiagnosticoOnco;
  vCtDadosSolic     RecDadosSolicitacao;
  vcItguia          cItGuia%rowtype;
  vTussRel          RecTussRel;
  vTuss             RecTuss;
  --Oswaldo FATURCONV-18977 inicio
  vcTmpSol          cTmpSol%ROWTYPE;
  nCdConPlaTmp      NUMBER;
  pCdPrestSolTmp    NUMBER;
  pcdTmpSol         NUMBER;
  ptpTmpSol         varchar2(20);
  --Oswaldo FATURCONV-18977 fim
  nCdAtendTmp       dbamv.atendime.cd_atendimento%TYPE; --TISS-608
  --
BEGIN
	--Oswaldo FATURCONV-18977 inicio
  pcdTmpSol := SubStr(pReserva,12);
  ptpTmpSol := SubStr(pReserva,1,11);

  if Nvl(ptpTmpSol, 'X') = 'SOLICITACAO' THEN
    OPEN  cTmpSol(pcdTmpSol);
    FETCH cTmpSol INTO vcTmpSol;
    CLOSE cTmpSol;
    nCdPrestExtSol:= vcTmpSol.cd_pres_ext;
    --
    --Oswaldo FATURCONV-22468 inicio
    IF vcTmpSol.cd_paciente IS NOT NULL and (Nvl(vcTmpSol.cd_paciente, 0) <> Nvl(vcPaciente.cd_paciente, 0)) THEN
      open  cPaciente(vcTmpSol.cd_paciente, vcTmpSol.CD_CONVENIO, vcTmpSol.cd_con_pla,vcTmpSol.cd_atendimento,NULL,NULL);
      FETCH cPaciente INTO vcPaciente;
      CLOSE cPaciente;
    END IF;
    --Oswaldo FATURCONV-22468 fim
    --
  END IF;
  --Oswaldo FATURCONV-18977 fim
  nCdAtendTmp := Nvl(pCdAtend,vcTmpSol.cd_atendimento); --TISS-608
  -- leitura de cursores de uso geral
  vcAtendimento := null;
  if nCdAtendTmp is not null then
    open  cAtendimento(nCdAtendTmp);
    fetch cAtendimento into vcAtendimento;
    close cAtendimento;
  end if;
  --
  vcGuia := null;
  if pCdGuia is not null then
    open  cGuia(pCdGuia,null);
    fetch cGuia into vcGuia;
    close cGuia;
  end if;
  vcTissSolGuia := null;
  open  cTissSolGuia(vcTmpSol.id_sol,vcGuia.cd_guia, vcGuia.nr_guia, null); --Oswaldo FATURCONV-18977
  fetch cTissSolGuia into vcTissSolGuia;
  close cTissSolGuia;
  --Oswaldo FATURCONV-26126 inicio
  if vcTissSolGuia.id_pai is not NULL or (vcTissSolGuia.id IS NOT NULL AND vcTissSolGuia.cd_guia IS NOT NULL) then
  --Oswaldo FATURCONV-26126 fim
    RETURN LPAD(vcTissSolGuia.id,20,'0')||','; -- se j真 foi solicitada eletr真nicamente, retorna a pr真pria guia
  else
    vRet := F_apaga_tiss_sol(null,vcTissSolGuia.id,pMsg,null); -- cancela solicita真真o anterior para sincronizar com Guia
    if pMsg is not null then
      RETURN null;
    end if;
  end if;
  -------------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv     :=  Nvl(nvl(vcGuia.cd_convenio, vcAtendimento.cd_convenio_atd),vcTmpSol.cd_convenio); --Oswaldo FATURCONV-18977
  pCdPaciente :=  Nvl(nvl(vcGuia.cd_paciente,vcAtendimento.cd_paciente),vcTmpSol.cd_paciente); --Oswaldo FATURCONV-18977
  --Oswaldo FATURCONV-18977 inicio
  pCdPrestSolTmp    :=  nvl(vcAtendimento.cd_prestador, vcTmpSol.cd_prestador);
  nCdConPlaTmp      :=  vcTmpSol.cd_con_pla;
  --Oswaldo FATURCONV-18977 fim
  -------------------------------------------------------------
  if nvl(vcConv.cd_convenio,9999) <> nvl(pCdConv,0) THEN
    vcConv := NULL;
    open  cConv(pCdConv);
    fetch cConv into vcConv;
    close cConv;
  end if;
  if pCdPaciente <> nvl(vcPaciente.cd_paciente, 0) then
    vcPaciente := null;
    open  cPaciente(pCdPaciente, pCdConv, vcAtendimento.cd_con_pla,nCdAtendTmp,'E', To_Date( vcAtendimento.dt_atendimento, 'yyyy/mm/dd') ); --OSWALDO
    fetch cPaciente into vcPaciente;
    close cPaciente;
  end if;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  vCp := 'ctm_anexoSolicitacaoRadio'; vTemp := null;
  if tConf(vCp).tp_utilizacao > 0 then
    --
    -- cabecalhoAnexo----------------------------------------------------
    vRet := F_ct_anexoCabecalho(null,1688,nCdAtendTmp,pCdConv,pCdGuia,'QM',vCtAnexoCabec,pMsg,null);
    if vRet = 'OK' then
      vTissSolGuia.NR_REGISTRO_OPERADORA_ANS   := vCtAnexoCabec.registroANS;
      vTissSolGuia.NR_GUIA                     := vCtAnexoCabec.numeroGuiaAnexo;
      vTissSolGuia.NR_GUIA_PRINCIPAL           := vCtAnexoCabec.numeroGuiaReferenciada;
      vTissSolGuia.NR_GUIA_OPERADORA           := vCtAnexoCabec.numeroGuiaOperadora;
      vTissSolGuia.DH_SOLICITACAO              := vCtAnexoCabec.dataSolicitacao;
      vTissSolGuia.CD_SENHA                    := vCtAnexoCabec.senha;
      vTissSolGuia.DT_AUTORIZACAO              := vCtAnexoCabec.dataAutorizacao;
    else
      RETURN NULL;
    end if;
    --
    -- dadosBeneficiario-------------------------------------------------
    vRet := F_ct_beneficiarioDados(null,1696,nCdAtendTmp,NULL,pCdPaciente,pCdConv,'E',vCtBenef,pMsg,'RelerPac'||'#'||vcTmpSol.nr_carteira); --Oswaldo FATURCONV-18977
    if vRet = 'OK' then
      vTissSolGuia.NR_CARTEIRA                     := vCtBenef.numeroCarteira;
      vTissSolGuia.SN_ATENDIMENTO_RN               := vCtBenef.atendimentoRN;
      vTissSolGuia.NM_PACIENTE                     := vCtBenef.nomeBeneficiario;
	  vTissSolGuia.NM_SOCIAL_PACIENTE              := vCtBenef.nomeSocialBeneficiario; --Oswaldo FATURCONV-26150
      vTissSolGuia.NR_CNS                          := vCtBenef.numeroCNS;
      vTissSolGuia.TP_IDENT_BENEFICIARIO           := vCtBenef.tipoIdent;
      vTissSolGuia.NR_ID_BENEFICIARIO              := vCtBenef.identificadorBeneficiario;
      --vTissSolGuia.DS_TEMPLATE_IDENT_BENEFICIARIO  := vCtBenef.templateBiometrico; --Oswaldo FATURCONV-22404
    end if;
    --
    -- dadosComplementaresBeneficiario
    -- idade-------------------------------------------------------------
    vCp := 'idade'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTemp := TRUNC(MONTHS_BETWEEN(sysdate,to_date(vcPaciente.dt_nascimento,'yyyy-mm-dd'))/12);
      vTissSolGuia.NR_IDADE := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,null,null,null);
    end if;
    --
    -- sexo--------------------------------------------------------------
    vCp := 'sexo'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTussRel.TP_SEXO := vcPaciente.tp_sexo;
        vResult := F_DM(43,nCdAtendTmp,null,null,null,vTussRel,vTuss,pMsg,null);
        vTemp := vTuss.CD_TUSS;
      vTissSolGuia.TP_SEXO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,null,null,null);
    end if;
    --
    -- medicoSolicitante-------------------------------------------------
    vRet := F_ctm_anexoSolicitante(null,1705,nCdAtendTmp,pCdPrestSolTmp,pCdConv,vCtAnexoSolicitante,pMsg,null); --Oswaldo FATURCONV-18977
    if vRet = 'OK' then
      vTissSolGuia.NM_PRESTADOR             := vCtAnexoSolicitante.nomeProfissional;
      vTissSolGuia.NR_TELEFONE_PROFISSIONAL := vCtAnexoSolicitante.telefoneProfissional;
      vTissSolGuia.DS_EMAIL_PROFISSIONAL    := vCtAnexoSolicitante.emailProfissional;
    end if;
    --
    -- diagnosticoOncologicoRadio
    vRet :=F_ct_diagnosticoOncologico ( null,1709,nCdAtendTmp,NULL,pCdConv,'QM',vCtRecDiagnosticoOnco,pMsg,null);
    if vRet = 'OK' then
      vTissSolGuia.DT_DIAGNOSTICO       := vCtRecDiagnosticoOnco.dataDiagnostico;
      vTissSolGuia.CD_CID               := vCtRecDiagnosticoOnco.diagnosticoCID;
      vTissSolGuia.TP_ESTADIAMENTO      := vCtRecDiagnosticoOnco.estadiamento;
      vTissSolGuia.TP_FINALIDADE        := vCtRecDiagnosticoOnco.finalidade;
      vTissSolGuia.TP_ECOG              := vCtRecDiagnosticoOnco.ecog;
      vTissSolGuia.DS_PLANO_TERAPEUTICO := vCtRecDiagnosticoOnco.planoTerapeutico;
      vTissSolGuia.DS_HDA               := vCtRecDiagnosticoOnco.diagnosticoHispatologico;
      vTissSolGuia.DS_INFO_RELEVANTES   := vCtRecDiagnosticoOnco.infoRelevantes;
    end if;
    --
    -- diagnosticoImagem-------------------------------------------------
    vCp := 'diagnosticoImagem'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTemp := null; -- ??? PENDENTE - estudar op真真es
      vTissSolGuia.TP_DIAGNOSTICO_IMAGEM := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,null,null,null);
    end if;
    --
    -- numeroCampos------------------------------------------------------
    vCp := 'numeroCampos'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTemp := null; -- ??? PENDENTE - estudar op真真es
      vTissSolGuia.NR_CAMPOS := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,null,null,null);
    end if;
    --
    -- doseCampo---------------------------------------------------------
    vCp := 'doseCampo'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTemp := null; -- ??? PENDENTE - estudar op真真es
      vTissSolGuia.NR_DOSE_CAMPO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,null,null,null);
    end if;
    --
    -- doseTotal---------------------------------------------------------
    vCp := 'doseTotal'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTemp := null; -- ??? PENDENTE - estudar op真真es
      vTissSolGuia.NR_DOSE_TOTAL := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,null,null,null);
    end if;
    --
    -- nrDias------------------------------------------------------------
    vCp := 'nrDias'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTemp := null; -- ??? PENDENTE - estudar op真真es
      vTissSolGuia.NR_DIAS := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,null,null,null);
    end if;
    --
    -- dtPrevistaInicio--------------------------------------------------
    vCp := 'dtPrevistaInicio'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTemp := null; -- ??? PENDENTE - estudar op真真es
      vTissSolGuia.DT_PREVISTA_INICIO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,null,null,null);
    end if;
    --
    -- observacao--------------------------------------------------------
    vCp := 'observacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTemp := substr(vcGuia.ds_observacao,1,1000);
      vTissSolGuia.DS_OBSERVACAO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,null,null,null);
    end if;
    --
    -- assinaturaDigital-------------------------------------------------
    --vRet := F_assinaturaDigital(null,9999,null,null,null,null,null,null);
    --
	-- Oswaldo BH in真cio
	-- dadosSolicitante
    -- contratadoSolicitante-------------------------------------
    -- OBS.: essa TAG n真o faz parte na solicita真真o do RADIO, por真m 真 necess真ria uma vez que caso haja um servi真o SOLICITA_STATUS_AUTORIZACAO
    -- do RADIO esses campos ser真o necess真rios
    if Nvl(ptpTmpSol, 'X') <> 'SOLICITACAO' THEN --Oswaldo FATURCONV-18977
      vRet := F_ct_contratadoDados(null,1544,nCdAtendTmp,null,null,null,pCdPrestSolTmp,pCdConv,vCtContrat,pMsg,'SOLIC_SP'); --Oswaldo FATURCONV-18977
      if vRet = 'OK' then
        vTissSolGuia.CD_OPERADORA             := vCtContrat.codigoPrestadorNaOperadora;
        vTissSolGuia.CD_CPF                   := vCtContrat.cpfContratado;
        vTissSolGuia.CD_CGC                   := vCtContrat.cnpjContratado;
        vTissSolGuia.NM_PRESTADOR_CONTRATADO  := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 inicio
      end if;
    END IF;
	-- Oswaldo BH in真cio
	--
    -- informa真真es complementares de apoio
    vTissSolGuia.cd_paciente        := pCdPaciente;
    vTissSolGuia.cd_convenio        := pCdConv;
    vTissSolGuia.cd_atendimento     := nCdAtendTmp;
    vTissSolGuia.dt_emissao         := to_char(sysdate,'yyyy-mm-dd');
    vTissSolGuia.DH_SOLICITADO      := to_date( to_char( sysdate, 'dd/mm/yyyy' ) || ' ' ||to_char( sysdate, 'hh24:mi'    ), 'dd/mm/yyyy hh24:mi' );
    --Oswaldo FATURCONV-18977 inicio
    --vTissSolGuia.CD_PRESTADOR_SOL   := vcAtendimento.cd_prestador; --pCdPrestSolTmp;
    vTissSolGuia.CD_PRESTADOR_SOL   := pCdPrestSolTmp;
    --Oswaldo FATURCONV-18977 fim
    vTissSolGuia.cd_con_pla         := vcPaciente.cd_con_pla; -- fora de uso, mas obrigat真rio por Constraint
    vTissSolGuia.ds_con_pla         := Nvl(vcPaciente.ds_con_pla, 'X'); -- fora de uso, mas obrigat真rio por Constraint
    vTissSolGuia.sn_tratou_retorno  := 'N';
    vTissSolGuia.sn_cancelado       := 'N';
  --vTissSolGuia.cd_multi_empresa   := dbamv.pkg_mv2000.le_empresa;
    vTissSolGuia.cd_multi_empresa   := nEmpresaLogada; --adhospLeEmpresa
    vTissSolGuia.tp_atendimento     := 'R';
    --Oswaldo FATURCONV-18977 inicio
    if pCdGuia is not NULL then
      vTissSolGuia.cd_guia            := pCdGuia;
      vTissSolGuia.tp_origem_sol      := 'GUIA';
      vTissSolGuia.cd_origem_sol      := pCdGuia;
    END IF;
    --Oswaldo FATURCONV-18977 fim
    vTissSolGuia.SN_PREVISAO_USO_OPME   := 'N';
    vTissSolGuia.SN_PREVISAO_USO_QUIMIO := 'N';
  --vTissSolGuia.CD_VERSAO_TISS_GERADA  := '3.02.00';
    vTissSolGuia.CD_VERSAO_TISS_GERADA  := Nvl( vcConv.cd_versao_tiss, '3.02.00' ); --OP 48413
    vTissSolGuia.nm_social_paciente := vcPaciente.nm_social_paciente; --Oswaldo FATURCONV-22468
    --
    -- Grava真真o
    --Oswaldo FATURCONV-18977 inicio
    if Nvl(ptpTmpSol, 'X') = 'SOLICITACAO' then
      vTissSolGuia.tp_origem_sol := 'SOLICITACAO';
    end if;
    --Oswaldo FATURCONV-18977 fim

    vResult := F_gravaTissSolGuia('INSERE','SOL_RADIO',vTissSolGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
    --
    -- procedimentosComplementares---------------------------------------
    --Oswaldo FATURCONV-18977 /*Comentado pois em qu真mio e em OPME n真o 真 utilizado*/
    --vCp := 'procedimentosComplementares';
    --if tconf.EXISTS(vCp) THEN -- DESCONTINUADO a partir 3.03.00
      --
      OPEN  cItGuia(Nvl(pCdGuia,pcdTmpSol),null, ptpTmpSol); --Oswaldo FATURCONV-18977
      --
      LOOP
        --
        FETCH cItGuia into vcItGuia;
        EXIT WHEN cItGuia%NOTFOUND;
        --
        if cItGuia%FOUND then
          --
          --Oswaldo FATURCONV-18977 inicio
          --TAG dataProvavel n真o existe na solicita真真o de RADIOTERAPIA
          -- dataProvavel--------------------------------------------------
          /*vCp := 'dataProvavel'; vTemp := null;
          if tConf(vCp).tp_utilizacao>0 then
            vTemp := null; -- PENDENTE -- vcItGuia.???;
            vTissItSolGuia.DT_PROVAVEL := F_ST(null,vTemp,vCp,pCdAtend,pCdGuia,vcItGuia.cd_pro_fat,null,null);
          end if;*/
          --
          --Oswaldo FATURCONV-18977 fim
          -- procedimento--------------------------------------------------
          vRet := F_ct_procedimentoDados(null,1728,null,null,null,null,vcItGuia.cd_pro_fat,pCdConv,'SOL_RADIO',vCtProcDados,pMsg,null);
          if vRet = 'OK' then
            vTissItSolGuia.TP_TAB_FAT         := vCtProcDados.codigoTabela;
            vTissItSolGuia.CD_PROCEDIMENTO    := vCtProcDados.codigoProcedimento;
            vTissItSolGuia.DS_PROCEDIMENTO    := vCtProcDados.descricaoProcedimento;
          end if;
          --
          --Oswaldo FATURCONV-18977 inicio
          --TAG dataProvavel n真o existe na solicita真真o de RADIOTERAPIA
          -- quantidade----------------------------------------------------
          /*vCp := 'quantidade'; vTemp := null;
          if tConf(vCp).tp_utilizacao>0 then
            vTemp := vcItGuia.qt_autorizado;
            -- vTissItSolGuia.QT_SOLICITADA := F_ST(null,vTemp,vCp,pCdAtend,pCdGuia,vcItGuia.cd_pro_fat,null,null);
            vTissItSolGuia.QT_SOLICITADA := To_Number(F_ST(null,vTemp,vCp,pCdAtend,pCdGuia,vcItGuia.cd_pro_fat,null,null), '999999999999.9999');
          end if;*/
          --
          --Oswaldo FATURCONV-18977 fim
          -- informa真真es complementares de apoio
          vTissItSolGuia.id_pai           := vTissSolGuia.ID;
          vTissItSolGuia.cd_itorigem_sol  := vcItGuia.cd_it_guia;
          vTissItSolGuia.CD_PRO_FAT       := vcItGuia.cd_pro_fat;
          vTissItSolGuia.sn_opme          := 'N';
          -- Grava真真o
          vRet := F_gravaTissItSolGuia('INSERE','SOL_RADIO',vTissItSolGuia,pMsg,null);
          if pMsg is not null then
            RETURN NULL;
          end if;
          --
        end if;
        --
      END LOOP;
      --
      close cItGuia;
      --
    --END IF;
    --
    -- tratamentosAnteriores-------------------------------------------------------------------------------
    /*
    OPEN  cTratAnteriores(pTpTrat,pCdTratamento,null); -- PENDENTE
    LOOP
      --
        -- cirurgia-------------------------------------------------------------------------------
        -- datacirurgia-------------------------------------------------------------------------------
        -- quimioterapia-------------------------------------------------------------------------------
        -- dataIrradiacao-------------------------------------------------------------------------------
        vRet := F_gravaTissItSolGuiaTratAnt('INSERE','SOL_RADIO',vTissItSolGuiaTratAnt,pMsg,null);
      --
    END LOOP;
    --
    close cTratAnteriores;
    */
    --

    vRet := F_gravaTissSolGuia('ATUALIZA_INCONSISTENCIA','SOL_RADIO',vTissSolGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
  end if;
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS THEN
      IF cItGuia%ISOPEN THEN
        CLOSE cItGuia;
      END IF;
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_ctm_anexoSolicitacaoOPME   (    pModo           in varchar2,
                                            pIdMap          in number,
                                            pCdAtend        in dbamv.atendime.cd_atendimento%type,
                                            pCdGuia         in dbamv.pre_med.cd_pre_med%type,
                                            pMsg            OUT varchar2,
                                            pReserva        in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vResult           varchar2(1000);
  vCp	            varchar2(1000);
  vRet              varchar2(1000);
  vcItensSolProc    cItensSolProc%rowtype;
  vTissSolGuia      dbamv.tiss_sol_guia%rowtype;
  vTissItSolGuia    dbamv.tiss_itsol_guia%rowtype;
  pCdConv           dbamv.convenio.cd_convenio%type;
  pCdPaciente       dbamv.paciente.cd_paciente%type;
  vCtProcDados      RecProcDados;
  vCtBenef          RecBenef;
  vCtContrat        RecContrat; -- Oswaldo BH
  vCtAnexoCabec     RecAnexoCabec;
  vCtAnexoSolicitante   RecAnexoSolicitante;
  vcItguia          cItGuia%rowtype;
  vEspecTemp        varchar2(500);
  vTussRel          RecTussRel;
  vTuss             RecTuss;
  pCdPrestSolTmp    dbamv.prestador.cd_prestador%type;
  vcPreInt          cPreInt%rowtype;
  vcAviCir          cAviCir%rowtype;
  vcFornecedor          cFornecedor%rowtype;
  vcProdutoFornecedor   cProdutoFornecedor%rowtype;
  vcProdutoOPME  cProdutoOPME%rowtype;
  --Oswaldo FATURCONV-18980 inicio
  vcTmpSol       cTmpSol%ROWTYPE;
  pcdTmpSol      NUMBER;
  ptpTmpSol      varchar2(20);
  --Oswaldo FATURCONV-18980 fim
  nCdAtendTmp       dbamv.atendime.cd_atendimento%TYPE; --TISS-608
  --
BEGIN
  --
  --Oswaldo FATURCONV-18980 inicio
  pcdTmpSol := SubStr(pReserva,12);
  ptpTmpSol := SubStr(pReserva,1,11);

  if Nvl(ptpTmpSol, 'X') = 'SOLICITACAO' THEN
    OPEN  cTmpSol(pcdTmpSol);
    FETCH cTmpSol INTO vcTmpSol;
    CLOSE cTmpSol;
    nCdPrestExtSol:= vcTmpSol.cd_pres_ext;
    --
    --Oswaldo FATURCONV-22468 inicio
    IF vcTmpSol.cd_paciente IS NOT NULL and (Nvl(vcTmpSol.cd_paciente, 0) <> Nvl(vcPaciente.cd_paciente, 0)) THEN
      open  cPaciente(vcTmpSol.cd_paciente, vcTmpSol.CD_CONVENIO, vcTmpSol.cd_con_pla,vcTmpSol.cd_atendimento,NULL,NULL);
      FETCH cPaciente INTO vcPaciente;
      CLOSE cPaciente;
    END IF;
    --Oswaldo FATURCONV-22468 fim
    --
  END IF;
  --Oswaldo FATURCONV-18980 fim
  nCdAtendTmp := Nvl(pCdAtend,vcTmpSol.cd_atendimento); --TISS-608
  -- leitura de cursores de uso geral
  vcAtendimento := null;
  if nCdAtendTmp is not null then
    open  cAtendimento(nCdAtendTmp);
    fetch cAtendimento into vcAtendimento;
    close cAtendimento;
  end if;
  --
  vcGuia := null;
  if pCdGuia is not null then
    open  cGuia(pCdGuia,null);
    fetch cGuia into vcGuia;
    close cGuia;
    if vcGuia.cd_guia is not null and vcGuia.cd_atendimento is null then
      if vcGuia.cd_res_lei is not null then
        open  cPreInt(vcGuia.cd_res_lei);
        fetch cPreInt into vcPreInt;
        close cPreInt;
      elsif vcGuia.cd_aviso_cirurgia is not null then
        open  cAviCir(vcGuia.cd_aviso_cirurgia);
        fetch cAviCir into vcAviCir;
        close cAviCir;
        if vcAviCir.cd_paciente is null then
          pMsg := 'Aviso de Cirurgia sem cadastro de Paciente. N真o 真 poss真vel gerar solicita真真o Tiss.';
          RETURN null;
        end if;
      end if;
    end if;
  end if;
    vcTissSolGuia := null;
    open  cTissSolGuia(vcTmpSol.id_tmp,vcGuia.cd_guia, vcGuia.nr_guia, null);  --Oswaldo FATURCONV-18980
    fetch cTissSolGuia into vcTissSolGuia;
    close cTissSolGuia;
    --Oswaldo FATURCONV-26126 inicio
    if vcTissSolGuia.id_pai is not NULL or (vcTissSolGuia.id IS NOT NULL AND vcTissSolGuia.cd_guia IS NOT NULL) then
    --Oswaldo FATURCONV-26126 fim
      RETURN LPAD(vcTissSolGuia.id,20,'0')||','; -- se j真 foi solicitada eletr真nicamente, retorna a pr真pria guia
    else
      vRet := F_apaga_tiss_sol(null,vcTissSolGuia.id,pMsg,null); -- cancela solicita真真o anterior para sincronizar com Guia
      if pMsg is not null then
        RETURN null;
      end if;
    end if;
  --
  ---------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv           :=  Nvl(nvl(vcGuia.cd_convenio, vcAtendimento.cd_convenio_atd),vcTmpSol.cd_convenio);  --Oswaldo FATURCONV-18980
  pCdPaciente       :=  Nvl(nvl(nvl(vcGuia.cd_paciente,vcAtendimento.cd_paciente),vcAviCir.cd_paciente),vcTmpSol.cd_paciente); --Oswaldo FATURCONV-18980
  pCdPrestSolTmp    :=  Nvl(nvl(nvl(vcAtendimento.cd_prestador,vcPreInt.cd_prestador),vcAviCir.cd_prestador),vcTmpSol.cd_prestador); --Oswaldo FATURCONV-18980
  ---------
  if nvl(vcConv.cd_convenio,9999) <> nvl(pCdConv,0) THEN
    vcConv := NULL;
    open  cConv(pCdConv);
    fetch cConv into vcConv;
    close cConv;
  end if;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  vCp := 'ctm_anexoSolicitacaoOPME'; vTemp := null;
  if tConf(vCp).tp_utilizacao > 0 then
    --
    -- cabecalhoAnexo------------------------------------------------------------------
    vRet := F_ct_anexoCabecalho(null,1794,nCdAtendTmp,pCdConv,pCdGuia,'OP',vCtAnexoCabec,pMsg,null);
    if vRet = 'OK' then
      vTissSolGuia.NR_REGISTRO_OPERADORA_ANS   := vCtAnexoCabec.registroANS;
      vTissSolGuia.NR_GUIA                     := vCtAnexoCabec.numeroGuiaAnexo;
      vTissSolGuia.NR_GUIA_PRINCIPAL           := vCtAnexoCabec.numeroGuiaReferenciada;
      vTissSolGuia.NR_GUIA_OPERADORA           := vCtAnexoCabec.numeroGuiaOperadora;
      vTissSolGuia.DH_SOLICITACAO              := vCtAnexoCabec.dataSolicitacao;
      vTissSolGuia.CD_SENHA                    := vCtAnexoCabec.senha;
      vTissSolGuia.DT_AUTORIZACAO              := vCtAnexoCabec.dataAutorizacao;
    else
      RETURN NULL;
    end if;
    --
    -- dadosBeneficiario---------------------------------------------------------------
    vRet := F_ct_beneficiarioDados(null,1802,nCdAtendTmp,NULL,pCdPaciente,pCdConv,'E',vCtBenef,pMsg,'RelerPac'||'#'||Nvl(vcPreInt.nr_carteira,vcTmpSol.nr_carteira)); --Oswaldo FATURCONV-18980
    if vRet = 'OK' then
      vTissSolGuia.NR_CARTEIRA                     := vCtBenef.numeroCarteira;
      vTissSolGuia.SN_ATENDIMENTO_RN               := vCtBenef.atendimentoRN;
      vTissSolGuia.NM_PACIENTE                     := vCtBenef.nomeBeneficiario;
	  vTissSolGuia.NM_SOCIAL_PACIENTE              := vCtBenef.nomeSocialBeneficiario; --Oswaldo FATURCONV-26150
      vTissSolGuia.NR_CNS                          := vCtBenef.numeroCNS;
      vTissSolGuia.TP_IDENT_BENEFICIARIO           := vCtBenef.tipoIdent;
      vTissSolGuia.NR_ID_BENEFICIARIO              := vCtBenef.identificadorBeneficiario;
      --vTissSolGuia.DS_TEMPLATE_IDENT_BENEFICIARIO  := vCtBenef.templateBiometrico; --Oswaldo FATURCONV-22404
    end if;
    --
    -- profissionalSolicitante---------------------------------------------------------
    vRet := F_ctm_anexoSolicitante(null,1808,nCdAtendTmp,pCdPrestSolTmp,pCdConv,vCtAnexoSolicitante,pMsg,null);
    if vRet = 'OK' then
      vTissSolGuia.NM_PRESTADOR             := vCtAnexoSolicitante.nomeProfissional;
      vTissSolGuia.NR_TELEFONE_PROFISSIONAL := vCtAnexoSolicitante.telefoneProfissional;
      vTissSolGuia.DS_EMAIL_PROFISSIONAL    := vCtAnexoSolicitante.emailProfissional;
    end if;
    --
    -- justificativaTecnica------------------------------------------------------------
    vCp := 'justificativaTecnica'; vTemp := NULL;
    if tConf(vCp).tp_utilizacao>0 then
        --
        vTemp := vcGuia.DS_JUSTIFICATIVA;
      vTissSolGuia.DS_HDA := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,null,null,null);
    end if;
    --
    -- especificacaoMaterial-----------------------------------------------------------
    vCp := 'especificacaoMaterial'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        --
        vTemp := null; -- ??? PENDENTE - estudar op真真es
      vTissSolGuia.DS_ESPECIFICACAO_MATERIAL := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,null,null,null);
    end if;
    --
    -- Observacao----------------------------------------------------------------------
    vCp := 'Observacao'; vTemp := null;
    if tConf(vCp).tp_utilizacao>0 then
        vTemp := substr(vcGuia.DS_OBSERVACAO,1,1000);
      vTissSolGuia.DS_OBSERVACAO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,null,null,null);
    end if;
    --
    -- assinaturaDigital---------------------------------------------------------------
    --vRet := F_assinaturaDigital(null,9999,null,null,null,null,null,null);
    --
	-- Oswaldo BH in真cio
	-- dadosSolicitante
    -- contratadoSolicitante-------------------------------------
    -- OBS.: essa TAG n真o faz parte na solicita真真o do OPME, por真m 真 necess真ria uma vez que caso haja um servi真o SOLICITA_STATUS_AUTORIZACAO
    -- do OPME esses campos ser真o necess真rios
    IF Nvl(ptpTmpSol, 'X') <> 'SOLICITACAO' THEN --Oswaldo FATURCONV-18980
      vRet := F_ct_contratadoDados(null,1544,nCdAtendTmp,null,null,null,pCdPrestSolTmp,pCdConv,vCtContrat,pMsg,'SOLIC_SP');
      if vRet = 'OK' then
        vTissSolGuia.CD_OPERADORA             := vCtContrat.codigoPrestadorNaOperadora;
        vTissSolGuia.CD_CPF                   := vCtContrat.cpfContratado;
        vTissSolGuia.CD_CGC                   := vCtContrat.cnpjContratado;
        vTissSolGuia.NM_PRESTADOR_CONTRATADO  := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 inicio
      end if;
    END IF;
	-- Oswaldo BH fim
	--
    -- informa真真es complementares de apoio
    vTissSolGuia.cd_paciente        := pCdPaciente;
    vTissSolGuia.cd_convenio        := pCdConv;
    vTissSolGuia.cd_atendimento     := nCdAtendTmp;
    vTissSolGuia.dt_emissao         := to_char(sysdate,'yyyy-mm-dd');
    vTissSolGuia.DH_SOLICITADO      := to_date( to_char( sysdate, 'dd/mm/yyyy' ) || ' ' ||to_char( sysdate, 'hh24:mi'    ), 'dd/mm/yyyy hh24:mi' );
    vTissSolGuia.CD_PRESTADOR_SOL   := pCdPrestSolTmp;
    vTissSolGuia.cd_con_pla         := Nvl(vcPaciente.cd_con_pla,nvl(vcAtendimento.cd_con_pla,vcPreInt.cd_con_pla)); -- fora de uso, mas obrigat真rio por Constraint
    vTissSolGuia.ds_con_pla         := Nvl(vcPaciente.ds_con_pla,'X'); -- fora de uso, mas obrigat真rio por Constraint
    vTissSolGuia.sn_tratou_retorno  := 'N';
    vTissSolGuia.sn_cancelado       := 'N';
  --vTissSolGuia.cd_multi_empresa   := dbamv.pkg_mv2000.le_empresa;
    vTissSolGuia.cd_multi_empresa   := nEmpresaLogada; --adhospLeEmpresa
    vTissSolGuia.tp_atendimento     := 'O';
    IF pCdGuia IS NOT NULL THEN
      vTissSolGuia.cd_guia            := pCdGuia;
      vTissSolGuia.tp_origem_sol      := 'GUIA';
      vTissSolGuia.cd_origem_sol      := pCdGuia;
    END IF;
    --vTissSolGuia.cd_prestador_sol   := vcAtendimento.cd_prestador;
    -- PENDENTE - obrigat真rios, revisar
    --Oswaldo FATURCONV-18980 inicio
    --PENDENTE - verificar se o DS_CONSELHO, DS_CODIGO_CONSELHO e UF_CONSELHO 真 necess真rio
    --vTissSolGuia.DS_CONSELHO            := 99;
    --vTissSolGuia.DS_CODIGO_CONSELHO     := 99999;
    --vTissSolGuia.UF_CONSELHO            := 99;
    --Oswaldo FATURCONV-18980 fim
    vTissSolGuia.SN_PREVISAO_USO_OPME   := 'S';
    vTissSolGuia.SN_PREVISAO_USO_QUIMIO := 'N';
  --vTissSolGuia.CD_VERSAO_TISS_GERADA  := '3.02.00';
    vTissSolGuia.CD_VERSAO_TISS_GERADA  := Nvl( vcConv.cd_versao_tiss, '3.02.00' );
    vTissSolGuia.nm_social_paciente := vcPaciente.nm_social_paciente; --Oswaldo FATURCONV-22468
    --Oswaldo FATURCONV-18980 inicio
    if Nvl(ptpTmpSol, 'X') = 'SOLICITACAO' then
      vTissSolGuia.tp_origem_sol := 'SOLICITACAO';
    end if;
    --Oswaldo FATURCONV-18980 fim

    --
    -- Grava真真o

    vResult := F_gravaTissSolGuia('INSERE','SOL_OPME',vTissSolGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
    -- opmeSolicitada------------------------------------------------------------------
    OPEN  cItGuia(Nvl(pCdGuia,pcdTmpSol),null,ptpTmpSol); --Oswaldo FATURCONV-18980
    --
    LOOP
      --
      FETCH cItGuia into vcItGuia;
      EXIT WHEN cItGuia%NOTFOUND;
      --
      if cItGuia%FOUND then
        --
        -- procedimento----------------------------------------------------------------
        vRet := F_ct_procedimentoDados(null,1817,null,null,null,null,vcItGuia.cd_pro_fat,pCdConv,'SOL_OPME',vCtProcDados,pMsg,null);
        if vRet = 'OK' AND vcItGuia.cd_pro_fat IS NOT NULL THEN   --FATURCONV-2819 // LPDO
          vTissItSolGuia.TP_TAB_FAT         := vCtProcDados.codigoTabela;
          vTissItSolGuia.CD_PROCEDIMENTO    := vCtProcDados.codigoProcedimento;
          vTissItSolGuia.DS_PROCEDIMENTO    := vCtProcDados.descricaoProcedimento;
        end if;
        --
        -- dados de apoio obtidos na TUSS
        vTussRel.cd_convenio := pCdConv;
        vTussRel.cd_pro_fat  := vcItGuia.cd_pro_fat;
        vTuss := null;
        vTemp := F_DM(19,nCdAtendTmp,null,null,null,vTussRel,vTuss,pMsg,null);
        --
        -- opcaoFabricante-------------------------------------------------------------
        vCp := 'opcaoFabricante'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
          vTemp := '1'; -- PENDENTE
          -- PENDENTE -- vTissItSolGuia.??? := F_ST(null,vTemp,vCp,null,null,null,null,null);
        end if;
        --
        -- quantidadeSolicitada--------------------------------------------------------
        vCp := 'quantidadeSolicitada'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
          vTemp := vcItGuia.qt_autorizado;
          vTissItSolGuia.QT_SOLICITADA := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,vcItGuia.cd_pro_fat,null,null);
        end if;
        --
        -- valorSolicitado-------------------------------------------------------------
        vCp := 'valorSolicitado'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
          vTemp := vcItGuia.vl_unitario;
          vTissItSolGuia.VL_UNITARIO := To_Number(F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,vcItGuia.cd_pro_fat,null,null),'999999.99');
          vTissItSolGuia.VL_UNITARIO := Nvl(vTissItSolGuia.VL_UNITARIO,To_Number(vTemp));
          -- PENDENTE-- vTissItSolGuia.VL_UNITARIO := F_ST(null,vTemp,vCp,null,null,null,null,null);
          --vTissItSolGuia.VL_UNITARIO      := vcItGuia.vl_unitario;
        end if;
        --
        -- registroANVISA--------------------------------------------------------------
        vCp := 'registroANVISA'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
          vTemp := vTuss.CD_REFERENCIA;
		  -- FATURCONV-3565 - LPDO / NR_REGISTRO_OPERADORA_ANS Quando n真o existi procedimento.
          vTissItSolGuia.NR_REGISTRO_ANVISA := Nvl(F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,vcItGuia.cd_pro_fat,null,null),vcItGuia.nr_registro_operadora_ans);
        end if;
        --
        -- codigoRefFabricante---------------------------------------------------------
        vCp := 'codigoRefFabricante'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
            if vTissItSolGuia.TP_TAB_FAT = '00' then
              if vTuss.CD_REF_FABRICANTE is not null then
				vTemp := vTuss.CD_REF_FABRICANTE;
                vTemp := SubStr(vTuss.CD_REF_FABRICANTE,1,20);
              elsif vcItGuia.cd_fornecedor is not null then
                vcProdutoFornecedor := null;
                open  cProdutoFornecedor(vcItGuia.cd_pro_fat,vcItGuia.cd_fornecedor);
                fetch cProdutoFornecedor into vcProdutoFornecedor;
                close cProdutoFornecedor;
                vTemp := vcProdutoFornecedor.cd_prod_forn;
              end if;
            end if;
          vTissItSolGuia.DS_CODIGO_REF_FABRICANTE := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,vcItGuia.cd_pro_fat,null,null);
        end if;
        --
        -- autorizacaoFuncionamento----------------------------------------------------
        vCp := 'autorizacaoFuncionamento'; vTemp := null;
        if tConf(vCp).tp_utilizacao>0 then
            if vcItguia.cd_rms is not null then
              vTemp := vcItGuia.cd_rms;
            elsif vcItGuia.cd_fornecedor is not null then
              open  cFornecedor(vcItGuia.cd_fornecedor);
              fetch cFornecedor into vcFornecedor;
              close cFornecedor;
              vTemp := vcFornecedor.cd_afe;
              vTissItSolGuia.nm_fabricante_op := vcFornecedor.nm_fornecedor; -- PENDENTE -- informa真真o de Apoio ??? (deslocar)
          end if;
          vTissItSolGuia.NR_AUTORIZACAO_FUNCIONAMENTO := F_ST(null,vTemp,vCp,nCdAtendTmp,pCdGuia,vcItGuia.cd_pro_fat,null,null);
        end if;
        --
        -- informa真真es complementares de apoio
        vTissItSolGuia.id_pai           := vTissSolGuia.ID;
        vTissItSolGuia.CD_PRO_FAT       := vcItGuia.cd_pro_fat;
        vTissItSolGuia.cd_itorigem_sol  := vcItGuia.cd_it_guia;
        vTissItSolGuia.sn_opme          := 'S';

OPEN  cProdutoOPME ( vcItGuia.cd_pro_fat, NULL );
FETCH cProdutoOPME INTO vcProdutoOPME;
CLOSE cProdutoOPME;

      --vEspecTemp                      := substr(vEspecTemp||', '||vcItGuia.ds_especificacao,1,500);
        --Oswaldo TISS-46 inicio
        IF vcProdutoOPME.ds_especificacao IS NOT NULL THEN
          IF vEspecTemp IS NULL THEN
            vEspecTemp                      := substr(vcProdutoOPME.ds_especificacao,1,500);
          ELSE
            vEspecTemp                      := substr(vEspecTemp||', '||vcProdutoOPME.ds_especificacao,1,500);
          END IF;
        END IF;
        --Oswaldo TISS-46 fim
        --
        -- Grava真真o
        vRet := F_gravaTissItSolGuia('INSERE','SOL_OPME',vTissItSolGuia,pMsg,null);
        vTissItSolGuia := NULL; -- FATURCONV-3565 - LPDO / Resetando Array
        if pMsg is not null then
          RETURN NULL;
        end if;
        --
      end if;
      --
    END LOOP;
    --
    close cItGuia;
    --
    -- atualiza Campo Especifica真真o do Material no TISS_SOL_GUIA com base nas especifica真真es concatenadas nos loop de itens
    if vEspecTemp is not null and vTissSolGuia.id is not null then
        vTissSolGuia.DS_ESPECIFICACAO_MATERIAL := vEspecTemp;

        vResult := F_gravaTissSolGuia('ATUALIZA_ESPEC','SOL_OPME',vTissSolGuia,pMsg,null);
        if pMsg is not null then
            RETURN NULL;
        end if;
    end if;
    --
    vEspecTemp := NULL; --Oswaldo TISS-46
    vRet := F_gravaTissSolGuia('ATUALIZA_INCONSISTENCIA','SOL_OPME',vTissSolGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
  end if;
  --
  RETURN vResult;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA no campo:'||vCp||', IdMap='||pIdMap||', '||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_GERA_SOL_STATUS (   pModo           in varchar2,
                                pIdMap          in number,
                                --
                                pIdTissSolGuia  dbamv.tiss_sol_guia.id%type,
                                --
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS
  --
  vTemp             varchar2(1000);
  vResult           varchar2(1000);
  vCp               varchar2(1000);
  vRet              varchar2(1000);
  vTissItSolStatus  dbamv.TISS_ITEM_SOLICITA_STATUS_AUT%rowtype;
  pCdConv           dbamv.convenio.cd_convenio%type;
  pCdPac            dbamv.paciente.cd_paciente%type;
  vCtMensagem       RecMensagemLote;
  FalhaGuia         exception;
  vNaoTemAtend      varchar2(1000); --TISS-475
  --
BEGIN
  -- leitura de cursores de uso geral
  vcTissSolGuia := null;
  open  cTissSolGuia(pIdTissSolGuia,null,null,null);
  fetch cTissSolGuia into vcTissSolGuia;
  close cTissSolGuia;
  if vcTissSolGuia.id is null then
    raise FalhaGuia;
  end if;
  --
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv   :=  vcTissSolGuia.cd_convenio;
  pCdPac    :=  vcTissSolGuia.cd_paciente;
  --
   dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  -- identificacaoSolicitacao-------------------------------------------------------------------------------
  vTissItSolStatus.NR_REGISTRO_OPERADORA_ANS    := vcTissSolGuia.NR_REGISTRO_OPERADORA_ANS;
  vTissItSolStatus.NR_GUIA                      := vcTissSolGuia.NR_GUIA;
  --
  -- dadosBeneficiario---------------------------------------------------------------------------------------
  vTissItSolStatus.NR_CARTEIRA                    := vcTissSolGuia.NR_CARTEIRA;
  vTissItSolStatus.SN_ATENDIMENTO_RN              := vcTissSolGuia.SN_ATENDIMENTO_RN;
  vTissItSolStatus.NM_PACIENTE                    := vcTissSolGuia.NM_PACIENTE;
  vTissItSolStatus.NR_CNS                         := vcTissSolGuia.NR_CNS;
  vTissItSolStatus.TP_IDENT_BENEFICIARIO          := vcTissSolGuia.TP_IDENT_BENEFICIARIO;
  vTissItSolStatus.NR_ID_BENEFICIARIO             := vcTissSolGuia.NR_ID_BENEFICIARIO;
  vTissItSolStatus.DS_TEMPLATE_IDENT_BENEFICIARIO := vcTissSolGuia.DS_TEMPLATE_IDENT_BENEFICIARIO;
  --
  -- dadosContratado-------------------------------------------------------------------------------
  vTissItSolStatus.CD_OPERADORA             :=  vcTissSolGuia.CD_OPERADORA;
  vTissItSolStatus.CD_CPF                   :=  vcTissSolGuia.CD_CPF;
  vTissItSolStatus.CD_CGC                   :=  vcTissSolGuia.CD_CGC;
  vTissItSolStatus.NM_PRESTADOR_CONTRATADO  :=  vcTissSolGuia.NM_PRESTADOR_CONTRATADO;
  --
  vNaoTemAtend := 'SOLICITA_STATUS_AUTORIZACAO#'||vcTissSolGuia.id; --TISS-475
  -- informa真真es complementares de apoio
--vTemp := F_mensagemTISS(null,1001,'SOLICITA_STATUS_AUTORIZACAO',dbamv.pkg_mv2000.le_empresa,pCdConv,vTissItSolStatus.NR_GUIA,vCtMensagem,pMsg,null);
  vTemp := F_mensagemTISS(null,1001,'SOLICITA_STATUS_AUTORIZACAO',nEmpresaLogada,pCdConv,vTissItSolStatus.NR_GUIA,vCtMensagem,pMsg,nvl(to_char(vcTissSolGuia.cd_atendimento), vNaoTemAtend)); --adhospLeEmpresa -- Oswaldo BH --TISS-475
  if pMsg is null then
    --
    vTissItSolStatus.ID_PAI := vCtMensagem.idMensagem;
    -- Grava真真o
    vResult := F_gravaTissItSolStatus('INSERE',vTissItSolStatus,pMsg,null);
    if pMsg is null then
      vResult  :=  lpad(vCtMensagem.idMensagem,20,'0');
    end if;
    --
  end if;
  --
  if vResult is null then
    ROLLBACK;
    return NULL;
  else
    COMMIT;
    return vResult;
  end if;
  --
  EXCEPTION
    when FalhaGuia then
      pMsg := 'Solicita真真o ID = '||pIdTissSolGuia||' n真o encontrada ou mal-formada.';
      RETURN null;
    when OTHERS then
      pMsg := 'FALHA na Solicita真真o de Status. Erro:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissItSolStatus (  pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.TISS_ITEM_SOLICITA_STATUS_AUT%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
  --
BEGIN
  if pModo = 'INSERE' then
    --
    select dbamv.seq_tiss.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.TISS_ITEM_SOLICITA_STATUS_AUT
        (   id, id_pai, NR_REGISTRO_OPERADORA_ANS, NR_GUIA, NR_CARTEIRA, /*SN_ATENDIMENTO_RN,*/ NM_PACIENTE, NR_CNS, TP_IDENT_BENEFICIARIO, NR_ID_BENEFICIARIO, DS_TEMPLATE_IDENT_BENEFICIARIO
            , CD_OPERADORA, CD_CPF, CD_CGC, NM_PRESTADOR_CONTRATADO   )
    values
        (   vRg.id, vRg.id_pai, vRg.NR_REGISTRO_OPERADORA_ANS, vRg.NR_GUIA, vRg.NR_CARTEIRA, /*vRg.SN_ATENDIMENTO_RN,*/ vRg.NM_PACIENTE, vRg.NR_CNS, vRg.TP_IDENT_BENEFICIARIO, vRg.NR_ID_BENEFICIARIO, vRg.DS_TEMPLATE_IDENT_BENEFICIARIO,
            vRg.CD_OPERADORA, vRg.CD_CPF, vRg.CD_CGC, vRg.NM_PRESTADOR_CONTRATADO);
    --
  end if;
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar Solicita真真o Status Guia. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_ITEM_SOLICITA_STATUS_AUT:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_GERA_GUIA_CANCELAMENTO (    pModo           in varchar2,
                                        pIdMap          in number,
                                        --
                                        pTpGuia         varchar2,
                                        pIdMensagemEnv  dbamv.tiss_mensagem.id%type,    -- 1a. opt
                                        pIdTissSolGuia  dbamv.tiss_sol_guia.id%type,    -- 2a. opt -- caso Solicita真真o
                                        pIdTissGuia     dbamv.tiss_guia.id%type,        -- 2a. opt -- caso Envio
                                        pTpCancelamento VARCHAR2,  --Oswaldo FATURCONV-22406
                                        --
                                        pMsg            OUT varchar2,
                                        pReserva        in varchar2) return varchar2 IS
  --
  vTemp                 varchar2(1000);
  vResult               varchar2(1000);
  vCp                   varchar2(1000);
  vRet                  varchar2(1000);
  vTissSolCancGuia      dbamv.TISS_SOL_CANCELA_GUIA%rowtype;
  vTissItSolCancGuia    dbamv.TISS_ITSOL_CANCELA_GUIA%rowtype;
  pCdConv               dbamv.convenio.cd_convenio%type;
  vCtMensagem           RecMensagemLote;
  vcMensagemEnv         cMensagem%rowtype;
  vcTissGuiaOrigem      cTissGuiaOrigem%rowtype;
  FalhaGuia             exception;
  vCtContrat            RecContrat;
  --
BEGIN
  -- leitura de cursores de uso geral
  if pIdMensagemEnv is not null then
    open  cMensagem(pIdMensagemEnv, null,null, null);
    fetch cMensagem into vcMensagemEnv;
    close cMensagem;
  end if;
  --
  IF pTpCancelamento = '2' then --Oswaldo FATURCONV-22406
    vcTissSolGuia := null;
    --  vcTissGuia    := null;
    if Nvl(pTpGuia,'1') = '1' THEN --OSWALDO
      open  cTissSolGuia(pIdTissSolGuia,null,null,null);
      fetch cTissSolGuia into vcTissSolGuia;
      close cTissSolGuia;
      if vcTissSolGuia.id is null then
        raise FalhaGuia;
      end if;
    elsif pTpGuia = '2' and (pIdTissGuia is not null and pIdTissGuia <> 0 ) then -- 1 guia de faturamento -- Oswaldo BH
      open  cTissGuiaOrigem(pIdTissGuia);
      fetch cTissGuiaOrigem into vcTissGuiaOrigem;
      close cTissGuiaOrigem;
      if vcTissGuiaOrigem.id is null then
        raise FalhaGuia;
      end if;
    end if;
    vTissSolCancGuia.tp_guia := pTpGuia; --Oswaldo FATURCONV-22406
  END IF;
  --
  -------------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv       :=  nvl(nvl(vcTissSolGuia.cd_convenio,vcTissGuiaOrigem.cd_convenio),vcMensagemEnv.cd_convenio);
  vTpOrigemSol  :=  NULL;
  -------------------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  -------------------------------------------------------------
  --
  -- dadosPrestador-------------------------------------------------------------------------------
  vRet := F_ct_contratadoDados(null,1877,null,null,null,null,null,pCdConv,vCtContrat,pMsg,null);
  if pMsg is null then
    vTissSolCancGuia.CD_OPERADORA    := vCtContrat.codigoPrestadorNaOperadora;
    vTissSolCancGuia.CD_CPF          := vCtContrat.cpfContratado;
    vTissSolCancGuia.CD_CGC          := vCtContrat.cnpjContratado;
    vTissSolCancGuia.NM_CONTRATADO   := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 inicio
  end if;
  --
  -- informa真真es complementares de apoio
--vRet := F_mensagemTISS(null,1001,'CANCELA_GUIA',dbamv.pkg_mv2000.le_empresa,pCdConv,nvl(vcMensagemEnv.nr_documento,nvl(vcTissGuiaOrigem.NR_GUIA,vcTissSolGuia.NR_GUIA)),vCtMensagem,pMsg,null);
  vRet := F_mensagemTISS(null,1001,'CANCELA_GUIA',nEmpresaLogada,pCdConv,nvl(vcMensagemEnv.nr_documento,nvl(vcTissGuiaOrigem.NR_GUIA,vcTissSolGuia.NR_GUIA)),vCtMensagem,pMsg,null); --adhospLeEmpresa
  if pMsg is null then
    --
    vTissSolCancGuia.ID_PAI := vCtMensagem.idMensagem;
    -- Grava真真o
    vTemp := F_gravaTissSolCancGuia('INSERE',vTissSolCancGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
  end if;
  --
  -- guiasCancelamento--------------------------------------------------------
  vTissItSolCancGuia.ID_PAI := vTemp;
  --
  IF pTpCancelamento = '2' THEN --Oswaldo FATURCONV-22406
    if pTpGuia = '1' then -- Oswaldo BH
      vTissItSolCancGuia.NR_GUIA              := vcTissSolGuia.NR_GUIA;
      vTissItSolCancGuia.NR_GUIA_OPERADORA    := vcTissSolGuia.NR_GUIA_OPERADORA;
      --
      -- Grava真真o -- caso de 1 guia apenas
      vRet := F_gravaTissItSolCancGuia('INSERE',vTissItSolCancGuia,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
      --
    -- Oswaldo BH in真cio
    ELSIF pTpGuia = '2' and (pIdTissGuia is not null and pIdTissGuia = 0 ) THEN
      FOR i IN (SELECT tgr.id
                FROM dbamv.tiss_guia_reapresentacao tgr
               WHERE sn_rejeitada = 'N'
			     AND sn_reapresentada = 'N'
                 --Oswaldo BH in真cio
				 AND ID IN ((SELECT ID FROM DBAMV.TISS_GUIA WHERE ID_PAI IN (SELECT ID FROM DBAMV.TISS_LOTE WHERE ID_PAI = pIdMensagemEnv)))
				 --Oswaldo BH fim
               ORDER BY 1 DESC) LOOP

        OPEN cTissGuiaOrigem(i.id);
        FETCH cTissGuiaOrigem INTO vcTissGuiaOrigem;
        CLOSE cTissGuiaOrigem;

        vTissItSolCancGuia.NR_GUIA            := vcTissGuiaOrigem.NR_GUIA;
        vTissItSolCancGuia.NR_GUIA_OPERADORA  := vcTissGuiaOrigem.NR_GUIA_OPERADORA;
		IF vcMensagemEnv.nr_protocolo_retorno IS NOT NULL THEN --Oswaldo FATURCONV-22406
		  vTissItSolCancGuia.NR_PROTOCOLO_GUIA := vcMensagemEnv.nr_protocolo_retorno;
		END IF;
        --Grava真真o
        vRet := F_gravaTissItSolCancGuia('INSERE',vTissItSolCancGuia,pMsg,null);
        if pMsg is not null then
          RETURN NULL;
        end if;
      END LOOP;
	  -- Oswaldo BH fim
	  --
    END IF;
  --Oswaldo FATURCONV-22406 inicio
  else
    --
    vTissSolCancGuia.nr_lote := vcMensagemEnv.nr_lote;
    vTissSolCancGuia.NR_PROTOCOLO := vcMensagemEnv.nr_protocolo_retorno;
    --
    -- Grava真真o
    vRet := F_gravaTissSolCancGuia('ATUALIZA',vTissSolCancGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
  end if;
  --Oswaldo FATURCONV-22406 fim
  --
  if pMsg is null then
    vResult  :=  lpad(vCtMensagem.idMensagem,20,'0');
  end if;
  --
  if vResult is null then
    ROLLBACK;
    return NULL;
  else
    COMMIT;
    return vResult;
  end if;
  --
  EXCEPTION
    when FalhaGuia then
      pMsg := 'Solicita真真o Cancelamento ID = '||nvl(pIdTissSolGuia,pIdTissGuia)||' n真o encontrada ou mal-formada.';
      RETURN null;
    when OTHERS then
      pMsg := 'FALHA na Solicita真真o de Cancelamento Guia. Erro:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissSolCancGuia (  pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.TISS_SOL_CANCELA_GUIA%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2 IS
  --
BEGIN
  if pModo = 'INSERE' then
    --
    select dbamv.seq_tiss.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.TISS_SOL_CANCELA_GUIA
        (   id, id_pai, CD_OPERADORA, CD_CPF, CD_CGC, NM_CONTRATADO, TP_GUIA, NR_PROTOCOLO  )
    values
        (   vRg.id, vRg.id_pai, vRg.CD_OPERADORA, vRg.CD_CPF, vRg.CD_CGC, vRg.NM_CONTRATADO, vRg.TP_GUIA, vRg.NR_PROTOCOLO );
    --
  ELSIF pModo = 'ATUALIZA' THEN
    UPDATE dbamv.tiss_sol_cancela_guia
       SET nr_lote = vRg.nr_lote
	      ,NR_PROTOCOLO = vRg.NR_PROTOCOLO
     WHERE id = vRg.id;
  end if;
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_SOL_CANCELA_GUIA:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissItSolCancGuia (pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.TISS_ITSOL_CANCELA_GUIA%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2 IS
  --
BEGIN
  --
  if pModo = 'INSERE' then
    --
    select dbamv.seq_tiss.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.TISS_ITSOL_CANCELA_GUIA
        (   id, id_pai, NR_GUIA, NR_GUIA_OPERADORA, NR_PROTOCOLO_GUIA  )
    values
        (   vRg.id, vRg.id_pai, vRg.NR_GUIA, vRg.NR_GUIA_OPERADORA, vRg.NR_PROTOCOLO_GUIA);
    --
  end if;
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_ITSOL_CANCELA_GUIA:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_GERA_SOL_STATUS_PROTOCOLO ( pModo           in varchar2,
                                        pIdMap          in number,
                                        --
                                        pIdMensagemEnv  dbamv.tiss_mensagem.id%type,
                                        --
                                        pMsg            OUT varchar2,
                                        pReserva        in varchar2) return varchar2 IS
  --
  vTemp                 varchar2(1000);
  vResult               varchar2(1000);
  vCp                   varchar2(1000);
  vRet                  varchar2(1000);
  vTissSolStatusProt    dbamv.TISS_SOL_PROTOCOLO%rowtype;
  pCdConv               dbamv.convenio.cd_convenio%type;
  vCtMensagem           RecMensagemLote;
  vcMensagemEnv         cMensagem%rowtype;
  vCtContrat            RecContrat;
  --
BEGIN
  --
  -- leitura de cursores de uso geral
  open  cMensagem(pIdMensagemEnv, null,null, null);
  fetch cMensagem into vcMensagemEnv;
  close cMensagem;
  --
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv       :=  vcMensagemEnv.cd_convenio;
  vTpOrigemSol  :=  NULL;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  -- dadosPrestador-------------------------------------------------------------------------------
  vRet := F_ct_contratadoDados(null,1887,null,null,null,null,null,pCdConv,vCtContrat,pMsg,null);
  if pMsg is null then
    vTissSolStatusProt.CD_OPERADORA    := vCtContrat.codigoPrestadorNaOperadora;
    vTissSolStatusProt.CD_CPF          := vCtContrat.cpfContratado;
    vTissSolStatusProt.CD_CGC          := vCtContrat.cnpjContratado;
    vTissSolStatusProt.NM_PRESTADOR    := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 inicio
  end if;
  --
  vTissSolStatusProt.NR_PROTOCOLO   :=  vcMensagemEnv.NR_PROTOCOLO_RETORNO;
  --
  -- informa真真es complementares de apoio
--vRet := F_mensagemTISS(null,1001,'SOLIC_STATUS_PROTOCOLO',dbamv.pkg_mv2000.le_empresa,pCdConv,vcMensagemEnv.NR_DOCUMENTO,vCtMensagem,pMsg,null);
  vRet := F_mensagemTISS(null,1001,'SOLIC_STATUS_PROTOCOLO',nEmpresaLogada,pCdConv,vcMensagemEnv.NR_DOCUMENTO,vCtMensagem,pMsg,null); --adhospLeEmpresa
  if pMsg is null then
    --
    vTissSolStatusProt.ID_PAI := vCtMensagem.idMensagem;
    -- Grava真真o
    vRet := F_gravaTissSolStatProto('INSERE',vTissSolStatusProt,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
    vResult := lpad(vCtMensagem.idMensagem,20,'0');
    --
  end if;
  --
  if vResult is null then
    ROLLBACK;
    return NULL;
  else
    COMMIT;
    return vResult;
  end if;
  --
  --------------------------------------------------
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA na Solicita真真o de Status do Protocolo. Erro:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissSolStatProto ( pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.TISS_SOL_PROTOCOLO%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
  --
BEGIN
  --
  if pModo = 'INSERE' then
    --
    select dbamv.seq_tiss.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.TISS_SOL_PROTOCOLO
        (   id, id_pai, CD_OPERADORA, CD_CPF, CD_CGC, NM_PRESTADOR, NR_PROTOCOLO  )
    values
        (   vRg.id, vRg.id_pai, vRg.CD_OPERADORA, vRg.CD_CPF, vRg.CD_CGC, vRg.NM_PRESTADOR, vRg.NR_PROTOCOLO);
    --
  end if;
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  --------------------------------------------------
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar Sol.Status Protocolo. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_SOL_CANCELA_GUIA:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_concilia_id_it_envio  ( pModo           in varchar2,
                                    pIdItEnvio      in dbamv.tiss_itguia.id%type,
                                    pCdAtend        in dbamv.atendime.cd_atendimento%type,
                                    pCdConta        in dbamv.reg_fat.cd_reg_fat%type,
                                    pCdLanc         in dbamv.itreg_fat.cd_lancamento%type,
                                    pCdItLan        in varchar2,
                                    pCdGlosas       in dbamv.glosas.cd_glosas%type,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2 IS
  --
BEGIN
  if pModo = 'ITREG_FAT' then
    --
    update dbamv.itreg_fat SET ID_IT_ENVIO = pIdItEnvio where cd_reg_fat = pCdConta and cd_lancamento = pCdLanc;
    --
  elsif pModo = 'ITLAN_MED' then
    --
    update dbamv.itlan_med SET ID_IT_ENVIO = pIdItEnvio where cd_reg_fat = pCdConta and cd_lancamento = pCdLanc and cd_ati_med = pCdItLan AND ROWNUM = 1;
    --
  elsif pModo = 'ITREG_AMB' then
    --
    update dbamv.itreg_amb SET ID_IT_ENVIO = pIdItEnvio where cd_atendimento = pCdAtend and cd_reg_amb = pCdConta and cd_lancamento = pCdLanc;
    --
  elsif pModo = 'GLOSAS' then
    --
    update dbamv.glosas SET ID_IT_ENVIO = pIdItEnvio where cd_glosas = pCdGlosas;
    --
  end if;
  --
  RETURN 'OK';
  --
  --------------------------------------------------
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA conciliacao '||pModo||': '||SQLERRM;
      RETURN 'FALHA';
  --
END;
--
--==================================================
function FNC_TRADUZ_REVERSO (   pModo           in varchar2,              --'CD_PRO_FAT'        --  obg
                                pCdTuss         in dbamv.tuss.cd_tuss%type,                     --  obg
                                pCdConvenio     in dbamv.convenio.cd_convenio%type,             --  obg
                                pCdTipTuss      in dbamv.tip_tuss.cd_tip_tuss%type,             --  opt
                                pCdMultiEmpresa in dbamv.multi_empresas.cd_multi_empresa%type,  --  opt
                                pTpAtendimento  in dbamv.atendime.tp_atendimento%type,          --  opt
                                pCdSetor        in dbamv.setor.cd_setor%type,                   --  opt
                                pData           in dbamv.tuss.dt_fim_vigencia%type,             --  opt
                                pReserva        in varchar2) return  varchar2 is
    --
    vResult           varchar2(1000);
    vcTussReverso     cTussReverso%rowtype;
    nTpTussTMP        number;
    --
begin
  --
  if pCdTuss is not null then
    --
    if pModo = 'CD_MOTIVO_GLOSA' then
      nTpTussTMP := 38;
    else
      nTpTussTMP := pCdTipTuss;
    end if;
    --
  --open  cTussReverso ( pCdTuss,pCdConvenio,nvl(pCdMultiEmpresa,dbamv.pkg_mv2000.le_empresa),pTpAtendimento,pCdSetor,nvl(pData,SYSDATE),nTpTussTMP,null);
    open  cTussReverso ( pCdTuss,pCdConvenio,nvl(pCdMultiEmpresa,nEmpresaLogada),pTpAtendimento,pCdSetor,nvl(pData,SYSDATE),nTpTussTMP,null); --adhospLeEmpresa
    fetch cTussReverso into vcTussReverso;
    close cTussReverso;
    --
    if nvl(pModo,'CD_PRO_FAT') = 'CD_PRO_FAT' then
      --
      vResult := nvl(vcTussReverso.CD_PRO_FAT,pCdTuss);
      --
    end if;
    --
    if pModo = 'CD_MOTIVO_GLOSA' then
      --
      vResult := nvl(vcTussReverso.CD_MOTIVO_GLOSA,pCdTuss);
      --
    end if;
    --
  end if;
  --
  RETURN vResult;
  --
end;
--
--==================================================
FUNCTION  F_GERA_ENVIO_RECURSO (pModo           in varchar2,
                                pIdMap          in number,
                                pCdRemessaGlosa in dbamv.remessa_glosa.cd_remessa_glosa%type,
                                pTpGeracao      in varchar2, -- G = Gera normal(caso n真o exista) ou retorna ID's se j真 existentes / R = Regera todas e retorna ID's gerados
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS

  -- FUNCTION F_recursoGlosa(... [N_RETIRAR]
  --
  vRet                  varchar2(1000);
  vCp	                  varchar2(1000);
  vResult               varchar2(1000);
  vIdGuias              varchar2(1000);
  vcTiposGuiaLote       cTiposGuiaLote%rowtype;
  --
  --vcRemessaGlosa        cRemessaGlosa%rowtype;
  vcMensagem            cMensagem%rowtype;
  vCtMensagem           RecMensagemLote;
  vTissGuia             dbamv.tiss_guia%rowtype;
  vTissItGuia           dbamv.tiss_itguia%rowtype;
  vcTissGuiaOrigem      cTissGuiaOrigem%rowtype;
  vcTissItGuiaOrigem    cTissItGuiaOrigem%rowtype;
  vTissLoteGuia         dbamv.tiss_lote_guia%rowtype;
  vTissGuiaJustificaGlosa dbamv.Tiss_Guia_Justifica_Glosa%ROWTYPE;
  vCtProcDados          RecProcDados;
  vTussRel              RecTussRel;
  vTuss                 RecTuss;
  vTemp	                varchar2(1000);
  nTotRecursadoLote     number := 0;
  nTotRecursadoRecurso  number := 0;
  nTotRecursadoFFAG     NUMBER := 0;
  vcGlosaCta            cGlosas%ROWTYPE;
  --
BEGIN
  --
  FOR vcRemessaGlosa IN cRemessaGlosa(pCdRemessaGlosa) LOOP
    --
    dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,vcRemessaGlosa.cd_convenio,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
    --
    -- Reuso da Mensagem de Envio
    if vcRemessaGlosa.id_mensagem_envio is null THEN
      pMsg := 'Lote de Envio Tiss n真o Encontrado. Necess真rio para Recurso.';
      EXIT;
    END IF;
    --
    IF nTotRecursadoFFAG = 0 THEN -- na primeira passagem
      -- guarda o valor recursado total do Recurso/Remessa
      nTotRecursadoFFAG := vcRemessaGlosa.vl_total_remessa;
      -- Cancela Lote de Recurso Anterior
      if 'R' = 'R' then -- sempre regera inicialmente   -- nvl(pTpGeracao,'R')='R'  then
        vRet := f_cancela_envio(null,pCdRemessaGlosa,null,pMsg);
        EXIT WHEN pMsg IS NOT NULL;
      end if;
      --
    END IF;
    --
    open  cMensagem (vcRemessaGlosa.id_mensagem_envio, 'ENVIO_LOTE_GUIAS',vcRemessaGlosa.cd_remessa, null);
    fetch cMensagem into vcMensagem;
    close cMensagem;
    --
    vRet := F_mensagemTISS(null,1001,'RECURSO_GLOSA',vcRemessaGlosa.cd_multi_empresa,vcRemessaGlosa.cd_convenio,vcRemessaGlosa.cd_remessa,vCtMensagem,pMsg,null);
    if pMsg is NOT null THEN
      EXIT;
    END IF;
    --
    vResult := vResult||lpad(vCtMensagem.idMensagem,20,'0')||',';
    --
    -- recursoGuia
    for vcRemessaGlosaCtas in cRemessaGlosaCtas( pCdRemessaGlosa ,vcRemessaGlosa.id_mensagem_envio) loop
      --
      -- opcaoRecurso
      -- recursoGuia
      open  cTissGuiaOrigem(vcRemessaGlosaCtas.id_guia_envio);
      fetch cTissGuiaOrigem into vcTissGuiaOrigem;
      close cTissGuiaOrigem;
      --
      vTissGuia := NULL;
      --
      -- Inicia o sequenciamento dos itens
      nSqItem:=0;
      --
      -- numeroGuiaOrigem ---------------------------------------------
      vCp := 'numeroGuiaOrigem'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcTissGuiaOrigem.nr_guia;
        vTissGuia.NR_GUIA  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,null,null);
      end if;
      --
      -- numeroGuiaOperadora-------------------------------------------
      vCp := 'numeroGuiaOperadora'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcTissGuiaOrigem.nr_guia_operadora;
        vTissGuia.NR_GUIA_OPERADORA  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,null,null);
      end if;
      --
      -- senha---------------------------------------------------------
      vCp := 'senha'; vTemp := null;
      if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcTissGuiaOrigem.cd_senha;
        vTissGuia.CD_SENHA  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,null,null);
      end if;
      --
      -- informa真真es complementares de apoio
      vTissGuia.ID_PAI              := vCtMensagem.idLote;
      -- vTissGuia.cd_versao_tis_gerada  := vcConv.cd_versao_tiss;
      vTissGuia.cd_convenio         := vcRemessaGlosa.cd_convenio;
      vTissGuia.cd_atendimento      := vcTissGuiaOrigem.cd_atendimento;
      vTissGuia.cd_reg_fat          := vcRemessaGlosaCtas.cd_reg_fat;
      vTissGuia.cd_reg_amb          := vcRemessaGlosaCtas.cd_reg_amb;
      vTissGuia.cd_remessa          := vcRemessaGlosa.cd_remessa;
      vTissGuia.cd_remessa_glosa    := pCdRemessaGlosa;
      vTissGuia.nm_autorizador_conv := 'P';
      vTissGuia.sn_atendimento_rn	:= 'N';
      --
      -- Grava真真o
      vRet := F_gravaTissGuia('INSERE','RECURSO',vTissGuia,pMsg,null);
      if pMsg is not null then
        RETURN NULL;
      end if;
      --
      ---------------------------------------------------
      -- opcaoRecursoGuia
      -- recursoGuiaCompleta --------------------------------------------
      IF vcRemessaGlosaCtas.CD_GLOSA_TOTAL IS NOT null THEN
        --
        -- busca 1 glosa que seja total para justificar a guia
        vcGlosaCta := NULL;
        OPEN  cGlosas (pCdRemessaGlosa,vcRemessaGlosaCtas.id_guia_envio,vcRemessaGlosaCtas.CD_GLOSA_TOTAL);
        FETCH cGlosas INTO vcGlosaCta;
        CLOSE cGlosas;
        --
        -- codGlosaGuia ---------------------------------------------------------
        vCp := 'codGlosaGuia'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          vTussRel := null;
          vTussRel.cd_motivo_glosa := vcGlosaCta.cd_motivo_glosa;
          vRet := F_DM(38,vcRemessaGlosaCtas.cd_atendimento,Nvl(vcRemessaGlosaCtas.cd_reg_fat,vcRemessaGlosaCtas.cd_reg_amb),null,null,vTussRel,vTuss,pMsg,null);
          vTemp := vTuss.CD_TUSS;
        --vTissGuiaJustificaGlosa.cd_motivo_glosa  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcRemessaGlosaCtas.cd_atendimento,pCdConta,vcRemessaGlosaCtas.CD_GLOSA_TOTAL,null);
          vTissGuiaJustificaGlosa.cd_motivo_glosa  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcRemessaGlosaCtas.cd_atendimento,Nvl(vcRemessaGlosaCtas.cd_reg_fat,vcRemessaGlosaCtas.cd_reg_amb),vcRemessaGlosaCtas.CD_GLOSA_TOTAL,null);
        end if;
        --
        -- justificativaGuia -----------------------------------------------------
        vCp := 'justificativaGuia'; vTemp := null;
        if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
          vTemp := SubStr(vcGlosaCta.ds_justifica_glosa,1,500);
          IF vcGlosaCta.ds_complemento_justifica IS NOT NULL THEN
            IF vTemp IS NOT NULL then
              vTemp := SubStr(vTemp||', '||vcGlosaCta.ds_complemento_justifica,1,500);
            ELSE
              vTemp := SubStr(vcGlosaCta.ds_complemento_justifica,1,500);
            END IF;
          END IF;
        --vTissGuiaJustificaGlosa.ds_justifica_guia  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcRemessaGlosaCtas.cd_atendimento,pCdConta,vcRemessaGlosaCtas.CD_GLOSA_TOTAL,vcGlosaCta.cd_justifica_glosa);
          vTissGuiaJustificaGlosa.ds_justifica_guia  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcRemessaGlosaCtas.cd_atendimento,Nvl(vcRemessaGlosaCtas.cd_reg_fat,vcRemessaGlosaCtas.cd_reg_amb),vcRemessaGlosaCtas.CD_GLOSA_TOTAL,vcGlosaCta.cd_justifica_glosa);
        end if;
        --
        -- informa真真es complementares de apoio
        vTissGuiaJustificaGlosa.ID_PAI  :=  vTissGuia.ID;
        --
        -- Grava真真o
        vRet := F_gravaTissGuiaJustificaGlosa (null,vTissGuiaJustificaGlosa,pMsg,null);
        if pMsg is not null then
          RETURN NULL;
        end if;
        --
      END IF;
      ---------------------------------------------------
      -- opcaoRecursoGuia
      -- itensGuia ------------------------------------------------------
      for vcGlosas in cGlosas(pCdRemessaGlosa,vcRemessaGlosaCtas.id_guia_envio,null) loop
        --
        IF vcRemessaGlosaCtas.CD_GLOSA_TOTAL IS null THEN
          --
          vcTissItGuiaOrigem := null;
          if vcGlosas.id_it_envio is not null then
            open  cTissItGuiaOrigem(vcGlosas.id_it_envio);
            fetch cTissItGuiaOrigem into vcTissItGuiaOrigem;
            close cTissItGuiaOrigem;
          end if;
          -- se n真o encontrar item origem, l真 informa真真es de base para gerar novas informa真真es
          if vcTissItGuiaOrigem.ID is NULL then
            if vcGlosas.cd_atendimento<>nvl(vcAtendimento.cd_atendimento,'0') then
              vcAtendimento := null;
              open  cAtendimento(vcGlosas.cd_atendimento);
              fetch cAtendimento into vcAtendimento;
              close cAtendimento;
            end if;
            if nvl(vcGlosas.cd_reg_fat,vcGlosas.cd_reg_amb)<>nvl(vcConta.cd_conta,0) then
              vcConta := null;
              open  cConta(nvl(vcGlosas.cd_reg_fat,vcGlosas.cd_reg_amb),vcGlosas.cd_atendimento,vcAtendimento.tp_atendimento);
              fetch cConta into vcConta;
              close cConta;
            end if;
            vcItem := null;
            open  cItem( vcAtendimento.tp_atendimento,vcGlosas.cd_atendimento,nvl(vcGlosas.cd_reg_fat,vcGlosas.cd_reg_amb),nvl(vcGlosas.cd_lancamento_fat,vcGlosas.cd_lancamento_amb),vcGlosas.cd_ati_med,null);
            fetch cItem into vcItem;
            close cItem;
          end if;
          --

         -- sequencialItem -------------------------------------
         vCp := 'sequencialItem'; vTemp := null;
         if tconf.EXISTS(vCp) AND vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then --OSWALDO
            if vcTissItGuiaOrigem.ID is not null then
              vTemp := vcTissItGuiaOrigem.sq_item;
            else
               nSqItem:= nSqItem + 1;
               vTemp := nSqItem;
            end if;
            vTissItGuia.sq_item := F_ST(null,vTemp,vCp,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,null,null,null);
          end if;
          --
          -- dataInicio------------------------------------------------------------
          vCp := 'dataInicio'; vTemp := null;
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            if vcTissItGuiaOrigem.ID is not null then
              vTemp := vcTissItGuiaOrigem.dt_realizado;
            else
              vTemp := vcItem.dt_lancamento;
            end if;
            vTissItGuia.dt_realizado  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,vcGlosas.cd_glosas,vcGlosas.cd_pro_fat);
          end if;
          --
          -- dataFim---------------------------------------------------------------
          vCp := 'dataFim'; vTemp := null;
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            if vcTissItGuiaOrigem.ID is not null then
              vTemp := vcTissGuiaOrigem.dt_final_faturamento;
            else
              vTemp := vcConta.dt_final;
            end if;
            vTissItGuia.dt_final  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,vcGlosas.cd_glosas, Nvl( vcGlosas.cd_lancamento_amb, vcGlosas.cd_lancamento_fat) );
          end if;
          --
          -- procRecurso
          if vcTissItGuiaOrigem.ID is null then
            vRet := F_ct_procedimentoDados(null,1851,vcAtendimento.cd_atendimento,vcConta.cd_conta,vcItem.cd_lancamento,null,null,null,'RECURSO',vCtProcDados,pMsg,null);
          end if;
          --
          -- codigoTabela ---------------------------------------------------------
          vCp := 'codigoTabela'; vTemp := null;
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            if vcTissItGuiaOrigem.ID is not null then
              vTemp := vcTissItGuiaOrigem.tp_tab_fat;
            else
              vTemp := vCtProcDados.codigoTabela;
            end if;
            vTissItGuia.tp_tab_fat  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,vcGlosas.cd_glosas,vcGlosas.cd_pro_fat);
          end if;
          --
          -- codigoProcedimento ---------------------------------------------------
          vCp := 'codigoProcedimento'; vTemp := null;
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            if vcTissItGuiaOrigem.ID is not null then
              vTemp := vcTissItGuiaOrigem.cd_procedimento;
            else
              vTemp := nvl(vCtProcDados.codigoProcedimento,vcGlosas.cd_pro_fat);
            end if;
            vTissItGuia.cd_procedimento  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,vcGlosas.cd_glosas,vcGlosas.cd_pro_fat);
          end if;
          --
          -- descricaoProcedimento ------------------------------------------------
          vCp := 'descricaoProcedimento'; vTemp := null;
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            if vcTissItGuiaOrigem.ID is not null then
              vTemp := vcTissItGuiaOrigem.ds_procedimento;
            else
              vTemp := vCtProcDados.descricaoProcedimento;
            end if;
            vTissItGuia.ds_procedimento  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,vcGlosas.cd_glosas,vcGlosas.cd_pro_fat);
          end if;
          --
          -- grauParticipacao -----------------------------------------------------
          vCp := 'grauParticipacao'; vTemp := null;
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            if vcTissItGuiaOrigem.ID is not null then
              vTemp := vcTissItGuiaOrigem.cd_ati_med;
            else
              vTussRel := null;
              vRet := F_DM(35,vcAtendimento.cd_atendimento,vcConta.cd_conta,vcItem.cd_lancamento,vcGlosas.cd_ati_med,vTussRel,vTuss,pMsg,null);
              vTemp := vTuss.CD_TUSS;
            end if;
            vTissItGuia.cd_ati_med  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,vcGlosas.cd_glosas,vcGlosas.cd_pro_fat);
          end if;
          --
          -- codGlosaItem ---------------------------------------------------------
          vCp := 'codGlosaItem'; vTemp := null;
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            vTussRel := null;
            vTussRel.cd_convenio := vcRemessaGlosa.cd_convenio;
            vTussRel.cd_motivo_glosa := vcGlosas.cd_motivo_glosa;
            vRet := F_DM(38,vcAtendimento.cd_atendimento,vcConta.cd_conta,vcItem.cd_lancamento,vcGlosas.cd_ati_med,vTussRel,vTuss,pMsg,null);
            vTemp := vTuss.CD_TUSS;
            vTissItGuia.cd_motivo_glosa  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,vcGlosas.cd_glosas,vcGlosas.cd_pro_fat);
          end if;
          --
          -- valorRecursado -------------------------------------------------------
          vCp := 'valorRecursado'; vTemp := null;
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            vTemp := vcGlosas.vl_reapresentado;
            vTissItGuia.vl_total  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,null,null);
          end if;
          --
          -- justificativaItem -----------------------------------------------------
          vCp := 'justificativaItem'; vTemp := null;
          if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
            vTemp := vcGlosas.ds_justifica_glosa;
            IF vcGlosas.ds_complemento_justifica IS NOT NULL THEN
              IF vTemp IS NOT NULL then
                vTemp := vTemp||', '||vcGlosas.ds_complemento_justifica;
              ELSE
                vTemp := vcGlosas.ds_complemento_justifica;
              END IF;
            END IF;
            vTissItGuia.ds_justificativa_revisao  := F_ST(null,vTemp,vCp,pCdRemessaGlosa,vcTissGuiaOrigem.cd_atendimento,vcTissGuiaOrigem.cd_conta,vcGlosas.cd_glosas,vcGlosas.cd_pro_fat);
          end if;
          --
          -- informa真真es complementares de apoio
          vTissItGuia.ID_PAI        := vTissGuia.ID;
          vTissItGuia.CD_PRO_FAT    := vcGlosas.cd_pro_fat;
          vTissItGuia.TP_PAGAMENTO  := 'P';
          --
          -- Grava真真o
          vTissItGuia.sn_principal  := Nvl(vTissItGuia.sn_principal,'N');
          vRet := F_gravaTissItGuia ('INSERE','RECURSO',vTissItGuia,pMsg,null);
          if pMsg is not null then
            RETURN NULL;
          end if;
          -- Concilia真真o
          vRet := F_concilia_id_it_envio('GLOSAS',vTissItGuia.ID,null,null,null,null,vcGlosas.CD_GLOSAS,pMsg,null);
          if pMsg is not null then
            RETURN null;
          end if;
          --
        END IF;
        --
        nTotRecursadoLote         := nTotRecursadoLote    + vcGlosas.vl_reapresentado;  -- totaliza Lote
        nTotRecursadoRecurso      := nTotRecursadoRecurso + vcGlosas.vl_reapresentado;  -- totaliza Recurso Total
        --
      end loop;
      --
    end loop;
    --
    -- Informa真真es complentares do Lote (previamente gravado na f_mensagemTISS)
    vTissLoteGuia.ID := vCtMensagem.idLote;
    --
    -- valorTotalRecursado ------------------------------------------------------
    vCp := 'valorTotalRecursado'; vTemp := null;
    vTemp := nTotRecursadoLote;
    vTissLoteGuia.VL_TOTAL_RECURSADO := F_ST(null,vTemp,vCp,NULL,NULL,NULL,NULL,NULL); --nTotRecursado;
    -- numeroGuiaRecGlosaPrestador-----------------------------------------------
    vTissLoteGuia.NR_GUIA_REC_GLOSA_PREST := pCdRemessaGlosa;
    -- dataRecurso --------------------------------------------------------------
    vTissLoteGuia.DT_RECURSO    := to_char(sysdate,'yyyy-mm-dd');
    -- numeroLote----------------------------------------------------------------
    vTissLoteGuia.NR_LOTE := vcMensagem.NR_LOTE;
    -- numeroProtocolo ----------------------------------------------------------
    vTissLoteGuia.NR_PROTOCOLO  := vcMensagem.nr_protocolo_retorno;
    --
    vRet := F_gravaTissLoteGuia ('ATUALIZA',vTissLoteGuia,pMsg,null);
    if pMsg is not null then
      RETURN NULL;
    end if;
    --
    nTotRecursadoLote := 0;
    --
  end LOOP;
  --
  IF pMsg IS NULL then
    IF vResult IS NOT NULL THEN
      if nTotRecursadoRecurso <> nTotRecursadoFFAG then
        pMsg := 'Soma dos Valores detalhados do recurso no Tiss totaliza diferente do valor da Remessa-Glosa';
      end if;
    else
      pMsg := 'Recurso n真o Gerado/n真o encontrado.';
    END IF;
  END IF;
  --
  if pMsg is null then
    COMMIT;
    RETURN vResult;
  ELSE
    ROLLBACK;
    RETURN null;
  end if;
  --
  --------------------------------------------------
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA :'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissLoteGuia ( pModo           in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_lote_guia%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
  --
BEGIN
  --
  if pModo ='INSERE' THEN
    --
    select dbamv.seq_tiss_guia.nextval into vRg.id from sys.dual;
    ----
    insert into dbamv.tiss_lote_guia
    ( id,id_pai,nr_lote,nr_protocolo,nr_registro_ans,nr_guia_rec_glosa_prest,nm_operadora,tp_objeto_recurso
      ,nr_guia_rec_glosa_oper,cd_operadora_exe,cd_cpf_exe,cd_cgc_exe,nm_prestador_exe,dt_recurso,vl_total_recursado )
        values
    ( vRg.id,vRg.id_pai,vRg.nr_lote,vRg.nr_protocolo,vRg.nr_registro_ans,vRg.nr_guia_rec_glosa_prest,vRg.nm_operadora,vRg.tp_objeto_recurso
      ,vRg.nr_guia_rec_glosa_oper,vRg.cd_operadora_exe,vRg.cd_cpf_exe,vRg.cd_cgc_exe,vRg.nm_prestador_exe,vRg.dt_recurso,vRg.vl_total_recursado);
    --
  elsif pModo = 'ATUALIZA' then
    --
    Update dbamv.tiss_lote_guia SET
        NR_PROTOCOLO            = vRg.NR_PROTOCOLO,
        NR_GUIA_REC_GLOSA_PREST = vRg.NR_GUIA_REC_GLOSA_PREST,
        DT_RECURSO              = vRg.DT_RECURSO,
        VL_TOTAL_RECURSADO      = vRg.VL_TOTAL_RECURSADO,
        NR_LOTE                 = vRg.NR_LOTE
      where id = vRg.id;
    --
  end if;
  RETURN 'OK';
  --
  --------------------------------------------------
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar Lote Recurso. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_LOTE_GUIA:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
function F_apaga_tiss_sol(  pModo           in varchar2,
                            pIdTissSol      in dbamv.guia.cd_guia%type,
                            pMsg            OUT varchar2,
                            pReserva        in varchar2) return varchar2 IS
  --
  vResult	          varchar2(1000);
  --
begin
  delete dbamv.tiss_itsol_guia
    where id_pai = pIdTissSol;
  --
  delete dbamv.tiss_sol_guia
    where id = pIdTissSol;
  --
  vResult := 'OK';
  --
  RETURN vResult;
  --
  --------------------------------------------------
  EXCEPTION
    when OTHERS then
      pMsg := 'Erro ao apagar informa真真es anteriores da Solicita真真o. FALHA: '||SQLERRM;
      RETURN NULL;
  --
end;
--
--==================================================
function fnc_recebe_protocolo( pnIdMensEnvio        in number,
                               pvNrProtocolo        in varchar2,
                               --
                               pMsg                 out varchar2,
                               --
                               pReserva             in varchar2) return varchar2 is

     vcTissRetornoProtocolo    dbamv.tiss_retorno_protocolo%ROWTYPE;
     vcDadosMensagem           cMensagem%rowtype;
     nqtdLote                  NUMBER;
     nQtdProtocolo             NUMBER;
BEGIN
  -- Dados da Tiss_Mensagem
  open  cMensagem(pnIdMensEnvio,null,null,null);
  fetch cMensagem into vcDadosMensagem;
  close cMensagem;
  --
  SELECT  qt_lote,
          qt_protocolo
    INTO nqtdLote, nQtdProtocolo
    FROM (SELECT Count(id) qt_lote
            FROM dbamv.tiss_mensagem, dbamv.remessa_fatura, dbamv.fatura
           WHERE nr_lote = vcDadosMensagem.nr_lote
             and tiss_mensagem.cd_convenio = vcDadosMensagem.cd_convenio
             and remessa_fatura.cd_remessa = to_number(tiss_mensagem.nr_documento)
             and remessa_fatura.cd_fatura = fatura.cd_fatura
           --and fatura.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
             and fatura.cd_multi_empresa = nEmpresaLogada --adhospLeEmpresa
             and tiss_mensagem.tp_transacao = 'ENVIO_LOTE_GUIAS'
             AND cd_status not in ('CA','PE'))lote,
         (SELECT Count(id) qt_protocolo
            FROM dbamv.tiss_mensagem, dbamv.remessa_fatura, dbamv.fatura
           WHERE tiss_mensagem.nr_protocolo_retorno = pvNrProtocolo
             and tiss_mensagem.cd_convenio = vcDadosMensagem.cd_convenio
             and remessa_fatura.cd_remessa = to_number(tiss_mensagem.nr_documento)
             and remessa_fatura.cd_fatura = fatura.cd_fatura
           --and fatura.cd_multi_empresa = dbamv.pkg_mv2000.le_empresa
             and fatura.cd_multi_empresa = nEmpresaLogada --adhospLeEmpresa
             and tiss_mensagem.tp_transacao = 'ENVIO_LOTE_GUIAS') protocolo;
  --
  if nqtdLote > 1 THEN
    pMsg := 'H真 mais de um lote com mesmo n真mero e para o mesmo conv真nio. N真mero do protocolo n真o pode ser informado.';
    RETURN null;
  end if;

  if nqtdprotocolo > 0 then
    pMsg := 'N真mero de protocolo j真 existe para outro lote ou para esse mesmo lote.'; -- Oswaldo BH
    RETURN null;
  end if;
  --
  -- Grava真真o direta na Tiss_mensagem
  begin
    Update dbamv.tiss_mensagem
       SET nr_protocolo_retorno = pvNrProtocolo
     where ID = pnIdMensEnvio;
  exception
    when others then
      pMsg := 'Erro ao Gravar N真mero de Protocolo.' || SQLERRM;
      return null;
  end;
  --
  RETURN 'OK';
  --
end;
--
--==================================================
FUNCTION  F_GERA_SOL_DEMONSTRATIVO (pModo           in varchar2,
                                    pIdMap          in number,
                                    pTpDemon        in varchar2,    -- '1' - Dem.Pagamento / '2' - Dem.AnaliseConta
                                    --
                                    pIdMensagemEnv  dbamv.tiss_mensagem.id%type,    -- pTpDemon = 2
                                    pCdConvenio     dbamv.convenio.cd_convenio%type, -- pTpDemon = 1
                                    pDtPagamento    varchar2,                       -- pTpDemon = 1
                                    pCompetencia    varchar2,                       -- pTpDemon = 1 (AAAAMM)
                                    --
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2 IS

  -- FUNCTION F_ct_demonstrativoSolicitacao(... [N_RETIRAR]
  --
  vTemp             varchar2(1000);
  vResult           varchar2(1000);
  vCp               varchar2(1000);
  vRet              varchar2(1000);
  pCdConv           dbamv.convenio.cd_convenio%type;
  vCtContrat        RecContrat;
  vCtMensagem       RecMensagemLote;
  vcMensagem        cMensagem%rowtype;
  vTissSolDemon     dbamv.tiss_sol_demon%rowtype;
  --
BEGIN
  --
  -- leitura de cursores de uso geral
  if pIdMensagemEnv is not null then
    open  cMensagem (pIdMensagemEnv, null,null, null);
    fetch cMensagem into vcMensagem;
    close cMensagem;
  end if;
  --
  -------------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv       :=  nvl(pCdConvenio,vcMensagem.cd_convenio);
  vTpOrigemSol  :=  NULL;
  --
  if vcConv.cd_convenio<>nvl(pCdConv,0) then
    open  cConv(pCdConv);
    fetch cConv into vcConv;
    close cConv;
  end if;
  --
  -------------------------------------------------------------
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  --------------------------------------------------------------------
  --demonstrativoPagamento
  if pTpDemon = '1' then
    --
    -- dadosPrestador-------------------------------------------------------------------
    vRet := F_ct_contratadoDados(null,1902,NULL,NULL,null,null,null,pCdConv,vCtContrat,pMsg,null);
    if vRet = 'OK' then
      vTissSolDemon.CD_OPERADORA    := vCtContrat.codigoPrestadorNaOperadora;
      vTissSolDemon.CD_CPF          := vCtContrat.cpfContratado;
      vTissSolDemon.CD_CGC          := vCtContrat.cnpjContratado;
      vTissSolDemon.NM_PRESTADOR    := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 inicio
    end if;
    --
    -- dataSolicitacao------------------------------------------------------------------
    vCp := 'dataSolicitacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := to_char( sysdate, 'yyyy-mm-dd');
      vTissSolDemon.DT_SOLICITACAO  := F_ST(null,vTemp,vCp,NULL,NULL,null,null,null);
    end if;
    --
    -- tipoDemonstrativo----------------------------------------------------------------
    vCp := 'tipoDemonstrativo'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := '1';   -- fixo
      vTissSolDemon.TP_DEMONSTRATIVO  := F_ST(null,vTemp,vCp,NULL,NULL,null,null,null);
    end if;
    --
    -- periodo
    -- dataPagamento---------------------------------------------------------------
    vCp := 'dataPagamento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := pDtPagamento;
      vTissSolDemon.DT_INICIAL  := F_ST(null,vTemp,vCp,NULL,NULL,null,null,null);
    end if;
    --
    -- competencia-------------------------------------------------------------------
    vCp := 'competencia'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := pCompetencia;
      vTissSolDemon.DT_FINAL  := F_ST(null,vTemp,vCp,NULL,NULL,null,null,null);
    end if;
    --
  else --demonstrativoAnalise  -- pTpDemon = '2' then
    --
    -- dadosPrestador---------------------------------------------------------------
    vRet := F_ct_contratadoDados(null,1913,NULL,NULL,null,null,null,pCdConv,vCtContrat,pMsg,null);
    if vRet = 'OK' then
      vTissSolDemon.CD_OPERADORA    := vCtContrat.codigoPrestadorNaOperadora;
      vTissSolDemon.CD_CPF          := vCtContrat.cpfContratado;
      vTissSolDemon.CD_CGC          := vCtContrat.cnpjContratado;
      vTissSolDemon.NM_PRESTADOR    := vCtContrat.nomeContratado; --Oswaldo FATURCONV-22404 inicio
    end if;
    --
    -- dataSolicitacao--------------------------------------------------------------
    vCp := 'dataSolicitacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := to_char( sysdate, 'yyyy-mm-dd');
      vTissSolDemon.DT_SOLICITACAO  := F_ST(null,vTemp,vCp,NULL,NULL,null,null,null);
    end if;
    --
    -- protocolos
    -- numeroProtocolo---------------------------------------------------------------
    vCp := 'numeroProtocolo'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTemp := vcMensagem.nr_protocolo_retorno;
      vTissSolDemon.NR_PROTOCOLO  := F_ST(null,vTemp,vCp,NULL,NULL,null,null,null);
    end if;
    --
    -- informa真真es complementares de apoio
    vTissSolDemon.TP_DEMONSTRATIVO := '2';
    --
  end if;
  --
  ------------
--vRet := F_mensagemTISS(null,1001,'SOLIC_DEMONSTRATIVO_RETORNO',dbamv.pkg_mv2000.le_empresa,pCdConv,null,vCtMensagem,pMsg,null);
  vRet := F_mensagemTISS(null,1001,'SOLIC_DEMONSTRATIVO_RETORNO',nEmpresaLogada,pCdConv,null,vCtMensagem,pMsg,null); --adhospLeEmpresa
  if pMsg is null then
    --
    vTissSolDemon.ID_PAI := vCtMensagem.idMensagem;
    -- Grava真真o
    vRet := F_gravaTissSolDemon('INSERE',vTissSolDemon,pMsg,null);
    if pMsg is null then
      vResult  :=  lpad(vCtMensagem.idMensagem,20,'0');
    end if;
    --
  end if;
  --
  if vResult is null then
    ROLLBACK;
    return NULL;
  else
    COMMIT;
    return vResult;
  end if;
  --
  --------------------------------------------------
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA na Solicita真真o de Demonstrativo. Erro:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissSolDemon ( pModo           in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_sol_demon%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS
  --
BEGIN
  --
  if pModo = 'INSERE' then
    --
    select dbamv.seq_tiss.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.tiss_sol_demon
        ( id,id_pai,nr_registro_operadora_ans,cd_cgc,cd_cpf,cd_operadora,nm_prestador,cd_tipo_logradouro,ds_endereco
         ,nr_endereco,ds_complemento,cd_ibge,nm_cidade,cd_uf,nr_cep,cd_cnes,dt_solicitacao,tp_demonstrativo,dt_inicial
         ,dt_final,nr_protocolo )
    values
        (vRg.id,vRg.id_pai,vRg.nr_registro_operadora_ans,vRg.cd_cgc,vRg.cd_cpf,vRg.cd_operadora,vRg.nm_prestador,vRg.cd_tipo_logradouro,vRg.ds_endereco
        ,vRg.nr_endereco,vRg.ds_complemento,vRg.cd_ibge,vRg.nm_cidade,vRg.cd_uf,vRg.nr_cep,vRg.cd_cnes,vRg.dt_solicitacao,vRg.tp_demonstrativo,vRg.dt_inicial
        ,vRg.dt_final,vRg.nr_protocolo);
    --
  end if;
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  --------------------------------------------------
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_SOL_DEMON:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_GERA_NOTIFICACAO_INTERN (   pModo           in varchar2,
                                        pIdMap          in number,
                                        pTpAcao         in varchar2,    -- 'I' - Interna真真o / 'A' - Alta
                                        --
                                        pCdAtend        dbamv.atendime.cd_atendimento%type,
                                        --
                                        pMsg            OUT varchar2,
                                        pReserva        in varchar2) return varchar2 IS

  -- FUNCTION F_ctm_beneficiarioComunicacao(... [N_RETIRAR]
  --
  vTemp             varchar2(1000);
  vResult           varchar2(1000);
  vCp               varchar2(1000);
  vRet              varchar2(1000);
  pCdConv           dbamv.convenio.cd_convenio%type;
  pCdPlano          dbamv.con_pla.cd_con_pla%type;
  pCdPac            dbamv.paciente.cd_paciente%type;
  vTissComunBenef   dbamv.tiss_comunicacao_beneficiario%rowtype;
  vCtBenef          RecBenef;
  vCtMensagem       RecMensagemLote;
  vTussRel          RecTussRel;
  vTuss             RecTuss;
  --
BEGIN
  --
  -- leitura de cursores de uso geral
  vcAtendimento := null;
  if pCdAtend is not null then
    open  cAtendimento(pCdAtend);
    fetch cAtendimento into vcAtendimento;
    close cAtendimento;
  end if;
  --
  -------------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv   :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  pCdPac    :=  vcAtendimento.cd_paciente;
  pCdPlano  :=  nvl(vcConta.cd_con_pla,vcAtendimento.cd_con_pla);
  --
  if vcConv.cd_convenio<>nvl(pCdConv,0) then
    open  cConv(pCdConv);
    fetch cConv into vcConv;
    close cConv;
  end if;
  -------------------------------------------------------------
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,pCdConv,'Reler',null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  --------------------------------------------------------------------
  -- dadosBeneficiario--------------------------------------------------------------------
  vRet := F_ct_beneficiarioDados(null,1922,pCdAtend,null,null,null,'E',vCtBenef,pMsg,'RelerPac');
  if vRet = 'OK' THEN
    vTissComunBenef.NR_CARTEIRA                     := vCtBenef.numeroCarteira;
    -- vTissComunBenef.SN_ATENDIMENTO_RN            := vCtBenef.atendimentoRN;
    vTissComunBenef.NM_PACIENTE                     := vCtBenef.nomeBeneficiario;
    vTissComunBenef.NR_CNS                          := vCtBenef.numeroCNS;
    vTissComunBenef.TP_IDENT_BENEFICIARIO           := vCtBenef.tipoIdent;
    vTissComunBenef.NR_ID_BENEFICIARIO              := vCtBenef.identificadorBeneficiario;
    --vTissComunBenef.DS_TEMPLATE_IDENT_BENEFICIARIO  := vCtBenef.templateBiometrico; --Oswaldo FATURCONV-22404

  end if;
  --
  -- dataEvento----------------------------------------------------------------------------
  vCp := 'dataEvento'; vTemp := null;
  if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
    if pTpAcao = 'I' then
      vTemp := vcAtendimento.dt_atendimento;
    elsif pTpAcao = 'A' then
      vTemp := vcAtendimento.dt_alta;
    end if;
    vTissComunBenef.DT_EVENTO  := F_ST(null,vTemp,vCp,pCdAtend,null,null,null,null);
  end if;
  --
  -- tipoEvento-----------------------------------------------------------------------
  vCp := 'tipoEvento'; vTemp := null;
  if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
    vTemp := pTpAcao;
    vTissComunBenef.TP_EVENTO  := F_ST(null,vTemp,vCp,pCdAtend,null,null,null,null);
  end if;
  --
  -- dadosInternacao------------------------------------------------------------------
  if pTpAcao = 'I' then
    --
    -- tipoInternacao-----------------------------------------------------------------
    vCp := 'tipoInternacao'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        --FUTURO RELACIONAMENTO COM A TELA (Terminologia 57)
        --vTemp := F_DM(57,null,null,null,null,vTussRel,vTuss,pMsg,null);
        --vTemp := vTuss.CD_TUSS;
        if nvl(vcAprTiss.cd_apr_tiss, 0) = 0 then
          open  cAprTiss(NULL);
          fetch cAprTiss into vcAprTiss;
          close cAprTiss;
        end if;
        if NVL(vcAtendimentoMag.cd_atendimento||vcAtendimentoMag.cd_apr_conta_meio_mag,'XX')<>pCdAtend||vcAprTiss.cd_apr_tiss then
          open  cAtendimentoMag(pCdAtend, vcAprTiss.cd_apr_tiss);
          fetch cAtendimentoMag into vcAtendimentoMag;
          close cAtendimentoMag;
        end if;
        vTemp := vcAtendimentoMag.cd_tip_int_meio_mag;
      vTissComunBenef.TP_INTERNACAO := F_ST(null,vTemp,vCp,pCdAtend,null,null,null,null);  -- dm_tipoInternacao
    end if;
    --
  elsif pTpAcao = 'A' then
    --
    -- motivoEncerramento------------------------------------------------------------------
    vCp := 'motivoEncerramento'; vTemp := null;
    if vCp = nvl(pModo,vCp) and tConf(vCp).tp_utilizacao>0 then
        vTussRel := null;
        vTussRel.cd_mot_alt := vcAtendimento.cd_mot_alt;
        vTemp := F_DM(39,pCdAtend,null,null,null,vTussRel,vTuss,pMsg,null);
        vTemp := vTuss.CD_TUSS;
        vTissComunBenef.TP_SAIDA := F_ST(tConf(vCp).tp_dado,vTemp,vCp,pCdAtend,null,null,null,null);
    end if;
    --
  end if;
  --
  -- informa真真es complementares de apoio
  vTissComunBenef.dh_transacao              :=  sysdate;
  vTissComunBenef.cd_paciente               :=  pCdPac;
  vTissComunBenef.cd_convenio               :=  pCdConv;
  vTissComunBenef.cd_con_pla                :=  pCdPlano;
  vTissComunBenef.nr_registro_operadora_ans :=  vcConv.nr_registro_operadora_ans;
  vTissComunBenef.ds_plano                  :=  'X';    -- cumprir constraint
  --
  ------------
--vRet := F_mensagemTISS(null,1001,'COMUNICACAO_BENEFICIARIO',dbamv.pkg_mv2000.le_empresa,pCdConv,vTissComunBenef.NR_CARTEIRA,vCtMensagem,pMsg,null);
  vRet := F_mensagemTISS(null,1001,'COMUNICACAO_BENEFICIARIO',nEmpresaLogada,pCdConv,vTissComunBenef.NR_CARTEIRA,vCtMensagem,pMsg,null); --adhospLeEmpresa
  if pMsg is null then
    --
    vTissComunBenef.ID_PAI := vCtMensagem.idMensagem;
    -- Grava真真o
    vRet := F_gravaTissComunBenef('INSERE',vTissComunBenef,pMsg,null);
    if pMsg is null then
      vResult  :=  lpad(vCtMensagem.idMensagem,20,'0');
    end if;
    --
  end if;
  --
  if vResult is null then
    ROLLBACK;
    return NULL;
  else
    COMMIT;
    return vResult;
  end if;
  --
  --------------------------------------------------
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA na verifica真真o de Elegibilidade. Erro:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
FUNCTION  F_gravaTissComunBenef (   pModo           in varchar2,
                                    vRg             in OUT NOCOPY dbamv.tiss_comunicacao_beneficiario%rowtype,
                                    pMsg            OUT varchar2,
                                    pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
  --
BEGIN
  --
  if pModo = 'INSERE' then
    --
    select dbamv.seq_tiss.nextval into vRg.id from sys.dual;
    --
    insert into dbamv.tiss_comunicacao_beneficiario
        (   id, id_pai, nr_registro_operadora_ans, cd_cnpj_operadora, nr_carteira, nm_paciente, ds_plano, dt_validade, nr_cns,
            lo_identificador_beneficiario, dt_evento, tp_evento, tp_saida, tp_internacao, cd_paciente, cd_convenio, cd_con_pla, dh_transacao
        )
    values
        (   vRg.id, vRg.id_pai, vRg.nr_registro_operadora_ans, vRg.cd_cnpj_operadora, vRg.nr_carteira, vRg.nm_paciente, vRg.ds_plano, vRg.dt_validade, vRg.nr_cns,
            vRg.lo_identificador_beneficiario, vRg.dt_evento, vRg.tp_evento, vRg.tp_saida, vRg.tp_internacao, vRg.cd_paciente, vRg.cd_convenio, vRg.cd_con_pla, vRg.dh_transacao  );
    --
  end if;
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  --------------------------------------------------
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha tentando gravar Comunicacao_Beneficiario. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_COMUNICACAO_BENEFICIARIO:'||SQLERRM;
      RETURN NULL;
  --
END;
--
--==================================================
function F_ret_info_guias   (   pModo       in varchar2,
                                pCdAtend    in dbamv.atendime.cd_atendimento%type,
                                pCdConta    in dbamv.reg_fat.cd_reg_fat%type,
                                pCdLanc     in dbamv.itreg_fat.cd_lancamento%type,
                                pCdItLan    in varchar2,
                                pTpGuia     in varchar2,
                                pCdGuia     in dbamv.guia.cd_guia%type,
                                pReserva    in varchar2    ) return varchar2 is
  --
  pCdConv       dbamv.convenio.cd_convenio%type;
  vResult	    varchar2(1000);
begin
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
    if pCdLanc is not null then
      if pCdAtend||pCdConta||pCdLanc||pCdItLan <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento||vcItem.cd_itlan_med, 'XXXX') then
        open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
        fetch cItem into vcItem;
        close cItem;
      END IF;
      if vcItem.cd_guia is not null then
        if nvl(vcAutorizacao.cd_guia,0)<>vcItem.cd_guia then
          open  cAutorizacao(vcItem.cd_guia,null);
          fetch cAutorizacao into vcAutorizacao;
          close cAutorizacao;
        end if;
      ELSE
        vcAutorizacao := NULL;
      end if;
    end if;
  end if;
  --
  -------------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConv   :=  nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  --
  -------------------------------------------------------------
  if pModo = 'NR_GUIA_ESPECIFICA' then
      --
      if vcAtendimento.tp_atendimento <> 'I' then
      --
      -- SP/SADT Ambulatorial
      if pTpGuia = 'SPA'
        and nvl(FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_AMB',pCdConv,null),'1') = '2'
        --and vcItem.cd_guia is not null
        --and vcItem.cd_guia <> nvl(nCdGuiaPrinc,vcItem.cd_guia) then
      --AND vcitem.cd_guia <> nvl(  nvl(ncdguiaprinc,vcatendimento.cd_guia ), vcitem.cd_guia)THEN  --sup-58031
        AND vcItem.cd_guia is NOT  null

        and ( ( vcItem.cd_guia is not null AND vcatendimento.cd_guia IS NULL )
                OR
              ( vcItem.cd_guia <> Nvl(vcatendimento.cd_guia,vcItem.cd_guia) )
            )
      THEN
        vResult := 'S';
      else
        vResult := 'N';
      end if;
      --
    else
      --
      -- SP/SADT Hospitalar
      if pTpGuia = 'SPH' and
         (
         nvl(FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_HOSP',pCdConv,null),'1') = '2'
        and vcItem.cd_guia is not null
      --and vcItem.cd_guia <> nvl(nCdGuiaPrinc,vcItem.cd_guia) then
        and ( ( vcItem.cd_guia is not null AND vcatendimento.cd_guia IS NULL )
                OR
              ( vcItem.cd_guia <> Nvl(vcatendimento.cd_guia,vcItem.cd_guia) )
            )
            )OR (vcAtendimento.tp_atendimento_original = 'H' AND vcatendimento.cd_atendimento_tiss IS NOT NULL and vcProgramasHomecare.tp_guia = 'SP' ) --Oswaldo FATURCONV-20760
	  then
        vResult := 'S';
      else
        vResult := 'N';
      end if;
      --
    end if;
    --
    if vResult is null then
      vResult := pReserva; -- reserva contem o pr真prio n真mero da guia principal se n真o utiliza a Guia Espec真fica
    end if;
  elsif pModo = 'SN_DESPESA_DA_GUIA' then
    --
    if ( ( (vcAtendimento.tp_atendimento <> 'I' and nvl(FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_AMB',pCdConv,null),'1') = '1'
       or (vcAtendimento.tp_atendimento =  'I' and nvl(FNC_CONF('TP_QUEBRA_GUIA_AUTORIZACAO_HOSP',pCdConv,null),'1') = '1'  ) ) )
    OR (   (pCdGuia is null and vcItem.cd_guia is null)
        or (pCdGuia is null and vcItem.cd_guia = nvl(nCdGuiaPrinc,vcItem.cd_guia))
        or Nvl(vcAutorizacao.TP_SITUACAO,'N') <> 'A'
        or (pCdGuia is NOT null and vcItem.cd_guia is not null and vcItem.cd_guia = pCdGuia) ) )  then
      --
      vResult := 'S';
      --
    else
      --
      vResult := 'N';
      --
    end if;
    --
  elsif pModo = 'RET_GUIA_ESPECIFICA' THEN
    IF pTpGuia = 'HI' AND nvl(FNC_CONF('TP_SENHA_HI',pCdConv,null),'1') = '2' then
      vResult := vcAutorizacao.nr_guia;
    END IF;
  elsif pModo = 'RET_SENHA_ESPECIFICA' THEN
    IF pTpGuia = 'HI' AND nvl(FNC_CONF('TP_GUIA_HI',pCdConv,null),'1') = '2' then
     vResult := vcAutorizacao.nr_senha;
    END IF;
  end if;
  --
  RETURN vResult;
  --
  --------------------------------------------------
  EXCEPTION
    when OTHERS then
      raise_application_error( -20001, pkg_rmi_traducao.extrair_pkg_msg('MSG_3', 'pkg_ffcv_tiss_v4', 'FALHA em f_ret_info_guias ', arg_list(SQLERRM)));
      RETURN NULL;
  --
end;
--
--==================================================
function F_ret_prestador (   pCdAtend       in dbamv.atendime.cd_atendimento%type,
                             pCdConta       in dbamv.reg_fat.cd_reg_fat%type,
                             pCdLanc        in dbamv.itreg_fat.cd_lancamento%type,
                             pCdItLan       in varchar2,
                             pCdPrestador   in dbamv.prestador.cd_prestador%type,
                             pCdConv        in dbamv.convenio.cd_convenio%type,
                             pTpGuia        in varchar2,
                             pTpClasse      IN varchar2,
                             pReserva       in varchar2    ) return varchar2 is
  --
  vResult	    varchar2(1000);
  pCdConvTmp    dbamv.convenio.cd_convenio%type;
  pCdPrestTmp   dbamv.prestador.cd_prestador%type;
  --
begin
  --
  if pCdAtend is not null and pCdConta is not null then
    if pCdAtend<>nvl(vcAtendimento.cd_atendimento,'0') then
      vcAtendimento := null;
      open  cAtendimento(pCdAtend);
      fetch cAtendimento into vcAtendimento;
      close cAtendimento;
    end if;
    if pCdConta<>nvl(vcConta.cd_conta,0) then
      vcConta := null;
      open  cConta(pCdConta,pCdAtend,vcAtendimento.tp_atendimento);
      fetch cConta into vcConta;
      close cConta;
    end if;
  end if;
  if pCdLanc is not null then
    if pCdAtend||pCdConta||pCdLanc||pCdItLan <> nvl(vcItem.cd_atendimento||vcItem.cd_conta||vcItem.cd_lancamento||vcItem.cd_itlan_med, 'XXXX') then
      open  cItem( vcAtendimento.tp_atendimento,pCdAtend,pCdConta,pCdLanc,pCdItLan,null);
      fetch cItem into vcItem;
      close cItem;
    end if;
  end if;
  -------------------------------------------------------------
  -- Campos b真sicos para esta CT, caso n真o venham via par真metro
  pCdConvTmp    :=  pCdConv;
  pCdPrestTmp   :=  pCdPrestador;
  if pCdConvTmp is null and pCdAtend is not null then
    pCdConvTmp := nvl(vcConta.cd_convenio,vcAtendimento.cd_convenio_atd);
  end if;
  if pCdPrestTmp is null and pCdLanc is not null then
    pCdPrestTmp := vcItem.cd_prestador;
  end if;
  if pCdPrestTmp is not null then
    if NVL(vcPrestador.cd_prestador||vcPrestador.cd_convenio,'XX')<>pCdPrestTmp||pCdConvTmp then
      vcPrestador := null;
      open  cPrestador(pCdPrestTmp,null, pCdConvTmp, NULL ,vcItem.cd_con_pla); -- pda FATURCONV-1372
      fetch cPrestador into vcPrestador;
      close cPrestador;
    end if;
  end if;
  -------------------------------------------------------------
  if pCdPrestTmp is null then
    vResult := null;
  else
    --
    -- Regra espec真fica de Terceirizados/Cooperativas --
    if  pTpClasse in ('CREDENCIADOS','CRED_INTERNACAO') then
      if ( pTpGuia = 'HI' OR (pTpGuia = 'SPA' and FNC_CONF('TP_GERA_CRED_SP',pCdConvTmp,null)='6') or (pTpGuia = 'SPH' and FNC_CONF('TP_GERA_CRED_SP_HOSP',pCdConvTmp,null)='6'))

        and (substr(nvl(vcPrestador.cd_unidade_origem,'X'),1,4) = 'COOP'  and length(vcPrestador.cd_unidade_origem) = 8 AND vcPrestador.sn_ativo_credenciamento = 'S' ) then
        --
        pCdPrestTmp := substr(vcPrestador.cd_unidade_origem,5,4);
        vcPrestador := null;
        open  cPrestador(pCdPrestTmp, null, pCdConvTmp, NULL ,vcItem.cd_con_pla); -- pda FATURCONV-1372
        fetch cPrestador into vcPrestador;
        close cPrestador;
        vResult := vcPrestador.cd_prestador;  -- Retorna o c真digo do Prestador que 真 cooperativa.
        --
        -- Regra de agrupamento de prestadores, se agrupados na guia retorna nulo, se individual por guia retorna o prestador.
      elsif  (pTpGuia = 'SPA' and FNC_CONF('TP_CONTRAT_CRED_SP_AMBUL',pCdConvTmp,null) = '1')
          or (pTpGuia = 'SPH' and FNC_CONF('TP_CONTRAT_CRED_SP_HOSP',pCdConvTmp,null)  = '1')
          OR (pTpGuia = 'HI'  and FNC_CONF('TP_DETALHE_PREST_HON_IND',pCdConvTmp,null) = '2')   then
          vResult := vcItem.cd_prestador;
      else
        vResult := null;
      end if;
    else
      vResult := null;
    end if;
    --
  end if;
  --
  if pTpClasse = 'CONTRATADO_EXTERNO' then
    --
    vResult := null;
    --
    if vcAtendimento.tp_atendimento<>'I' AND nvl(FNC_CONF('TP_CONTA_HONORARIO_HI',pCdConvTmp,null),'1') = '2' then
      if nvl(vcAprTiss.cd_apr_tiss, 0) = 0 then
        open  cAprTiss(NULL);
        fetch cAprTiss into vcAprTiss;
        close cAprTiss;
      end if;
      if NVL(vcAtendimentoMag.cd_atendimento||vcAtendimentoMag.cd_apr_conta_meio_mag,'XX')<>pCdAtend||vcAprTiss.cd_apr_tiss then
        vcAtendimentoMag := null;
        open  cAtendimentoMag(pCdAtend, vcAprTiss.cd_apr_tiss);
        fetch cAtendimentoMag into vcAtendimentoMag;
        close cAtendimentoMag;
      end if;
      if vcAtendimentoMag.tp_servico_meio_mag is not null then
        vcPrestador := null;
        open  cPrestador(vcAtendimentoMag.tp_servico_meio_mag, null, pCdConvTmp, NULL ,vcItem.cd_con_pla); -- pda FATURCONV-1372
        fetch cPrestador into vcPrestador;
        close cPrestador;
        if vcPrestador.cd_prestador is not null then
          vResult := vcPrestador.cd_prestador;  -- Retorna o c真digo do Prestador configurado no Servi真o
        end if;
      end if;
    end if;
    --
  end if;
  --
  RETURN vResult;
  --------------------------------------------------
  EXCEPTION
    when OTHERS then
      raise_application_error( -20001, pkg_rmi_traducao.extrair_pkg_msg('MSG_3', 'pkg_ffcv_tiss_v4', 'FALHA em F_ret_prestador ', arg_list(SQLERRM)));
      RETURN NULL;
  --
end;
--
--==================================================
FUNCTION  F_gravaTissGuiaJustificaGlosa ( pModo           in varchar2,
                                          vRg             in OUT NOCOPY dbamv.TISS_GUIA_JUSTIFICA_GLOSA%rowtype,
                                          pMsg            OUT varchar2,
                                          pReserva        in varchar2) return varchar2 IS
BEGIN
  select DBAMV.SEQ_TISS_GUIA_JUSTIFICA_GLOSA.nextval into vRg.id from sys.dual;
  --
  insert into dbamv.TISS_GUIA_JUSTIFICA_GLOSA
 (   id, id_pai, cd_motivo_glosa, ds_justifica_guia
  )
    values
 (  vRg.id, vRg.id_pai, vRg.cd_motivo_glosa, vRg.ds_justifica_guia
  );
  --
  RETURN LPAD(vRg.id,20,'0');
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA grava真真o TISS_GUIA_JUSTIFICA_GLOSA:'||SQLERRM;
      RETURN null;
  --
END;
--
--==================================================
--


FUNCTION  F_GERA_REENVIO( pModo           in varchar2,
                         pIdMap          in number,
                         pCdRemessa      in dbamv.remessa_fatura.cd_remessa%type,
                         pMsg            OUT varchar2,
                         pReserva        in varchar2) return varchar2 IS
  --
  vTemp	            varchar2(1000);
  vCp	              varchar2(1000);
  pCdConv           dbamv.convenio.cd_convenio%type;
  vcObtemMsgEnvio   cObtemMsgEnvio%rowtype;
  vcContaTotTiss    cContaTotTiss%rowtype;
  vcGuiasGeradasAux cGuiasGeradas%rowtype;
  vCtMensagem       RecMensagemLote;
  pnQtdGuias        number;
  vResult           varchar2(2000);
  vIdGuias          varchar2(2000);
  vcTiposGuiaLote   cTiposGuiaLote%rowtype;
  vcTissGuiasCta    cTissGuiasCta%rowtype;
  vIdentContrOrigem varchar2(100);

BEGIN

  if pCdRemessa is not null THEN
	SELECT SUM(ACHOU) ACHOU
	  INTO pnQtdGuias
	  FROM (SELECT COUNT(1) ACHOU
			  FROM DBAMV.TISS_GUIA TG
				 , DBAMV.REG_FAT RG
			 WHERE TG.CD_REG_FAT = RG.CD_REG_FAT
			   AND RG.CD_REMESSA = pCdRemessa
			   AND TG.ID_PAI IS NULL
	  UNION
			SELECT COUNT(1) ACHOU
			  FROM DBAMV.TISS_GUIA TG
				 , DBAMV.REG_AMB RA
			 WHERE TG.CD_REG_AMB = RA.CD_REG_AMB
			   AND RA.CD_REMESSA = pCdRemessa
			   AND TG.ID_PAI IS NULL);





























    IF pnQtdGuias = 0 THEN
      pMsg:= 	'ATEN真真O: N真o existem guias para reapresenta真真o nesta Remessa('||pCdRemessa||').';
    END IF;
    --
    open  cRemessa(pCdRemessa,null);
    fetch cRemessa into vcRemessa;
    close cRemessa;
    --
    if vcConv.cd_convenio<>nvl(vcRemessa.cd_convenio,0) then
      open  cConv(vcRemessa.cd_convenio);
      fetch cConv into vcConv;
      close cConv;
    end if;
    -- << ? ? ? ?   aqui validar protocolo/Vers真o m真nima do Tiss.,
    dbamv.pkg_ffcv_tiss_v4.f_le_conf(1001,vcConv.cd_convenio,'Reler',null); -- Ler configura真真es
    --
    -- Gera真真o/Confer真ncia de valores
    if pMsg is null then
      --
      -- Gerar Mensagem, Lote e associar Guias Geradas no Lote;
      if pMsg is null then
        --
        pnQtdGuias := 1;
        --
        for vcGuiasGeradas in cGuiasGeradas( pCdRemessa, null, null ) loop
          --
          -- Quebra de Lotes, os CRIT真RIOS:
          --   - Por tipo de guia Diferente
          --   - OU por qtd.guias no Lote
          --   - OU por identifica真真o de prestador Executante Credenciado diferente para SP e CO (espec真fico configurado)
          if vcGuiasGeradas.nm_xml <> nvl(vcGuiasGeradasAux.nm_xml, 'XXX')
            OR nvl(pnQtdGuias, 1) > fnc_conf('NR_LIMITE_GUIAS',vcConv.cd_convenio,null)
            or nvl(vcGuiasGeradas.ident_contr_exe_quebra,'X')<>NVL(vcGuiasGeradasAux.ident_contr_exe_quebra,'X')
            OR (
                vcGuiasGeradas.tp_pagamento_guia <> nvl(vcGuiasGeradasAux.tp_pagamento_guia, 'XXX')
                AND (  (substr(vcGuiasGeradas.nm_xml,1,6)='guiaSP' and nvl(fnc_conf('TP_QUEBRA_LOTE_CRED_SP_CO',vcConv.cd_convenio,null),'1')<>'3')
                      OR substr(vcGuiasGeradas.nm_xml,1,6)<>'guiaSP'  )
                )
            --
          then
            -- Nova Mensagem e Lote
            pnQtdGuias := 1;
            --
            if nvl(fnc_conf('TP_QUEBRA_LOTE_CRED_SP_CO',vcConv.cd_convenio,null),'1')='2' and vcGuiasGeradas.ident_contr_exe_quebra is not null then
              vIdentContrOrigem := '#'||vcGuiasGeradas.ident_contr_exe_quebra;
            end if;
            --
            vTpTransacao      := 'ENVIO_LOTE_GUIAS';      -- vari真vel globais para apoio na montagem do cabe真alho
            vTpGuiasTransacao := vcGuiasGeradas.tp_guia;  -- vari真vel globais para apoio na montagem do cabe真alho
            --
            vTemp := F_mensagemTISS(null,1001,'ENVIO_LOTE_GUIAS',vcRemessa.cd_multi_empresa,vcRemessa.cd_convenio,pCdRemessa,vCtMensagem,pMsg,vcGuiasGeradas.tp_pagamento_guia||vIdentContrOrigem);
            if pMsg is not null then
              EXIT;
            end if;
            --
            vResult  :=  vResult||lpad(vCtMensagem.idMensagem,20,'0')||',';
            --
          end if;
          --
          update dbamv.tiss_guia set id_pai = vCtMensagem.idLote where id = vcGuiasGeradas.id;
          --
          vcGuiasGeradasAux := vcGuiasGeradas;
          --
          pnQtdGuias := pnQtdGuias + 1;
          --
        end loop;
        --
        -- Ap真s gerar um novo lote, ele atualiza a TISS_MENSAGEM (anterior no caso) com informa真真es sobre os tipos de guias do Lote
        if vResult is not null then
          for i in 1..(length(vResult)/21) loop
            vcTiposGuiaLote := null;
            open  cTiposGuiaLote(to_number(substr(vResult,i*21-20,20)),null);
            fetch cTiposGuiaLote into vcTiposGuiaLote;
            close cTiposGuiaLote;
            if vcTiposGuiaLote.id_pai is not null then
              update dbamv.tiss_mensagem
                set tp_mensagem_tiss = vcTiposGuiaLote.tp_guia||','||'?'||','||vcTiposGuiaLote.nm_contratado_exe
                where id = to_number(substr(vResult,i*21-20,20));
            end if;
          end loop;
        end if;
        --
      end if;
      --
    end if;
    --
  end if; -- faturamento
  --
  if pMsg is null then
    COMMIT;
    RETURN vResult;
  else
    ROLLBACK;
    RETURN null;
  end if;
  --
  EXCEPTION
    when OTHERS then
      pMsg := 'FALHA :'||SQLERRM;
      RETURN NULL;
  --
END;
--
--Oswaldo FATURCONV-22406 inicio

FUNCTION  F_ENVIO_DOCUMENTOS( pModo        in varchar2,
                              pIdMap       in number,
                              pEnvioDocId  in dbamv.tiss_envio_documentos.id%type,
                              pMsg         OUT varchar2,
                              pReserva     in varchar2) return varchar2 IS
  --
  cursor cTissEnvioDoc (pEnvioDocId number) is
    SELECT ted.id,
           ted.tp_guia,
           ted.nr_lote,
           ted.nr_protocolo_lote,
           ted.nr_guia,
           ted.nr_guia_operadora,
           ted.cd_atendimento,
           ted.cd_convenio
      from dbamv.tiss_envio_documentos ted
     where ted.id = pEnvioDocId
    order by ted.id desc;
  --
  rTissEnvioDoc    cTissEnvioDoc%ROWTYPE;
  vTissEnviaDoc    dbamv.tiss_envio_documentos%rowtype;
  vTemp            varchar2(1000);
  vResult          varchar2(1000);
  vCtMensagem      RecMensagemLote;
  vTpGuia          VARCHAR2(10);
  vCdConvenio      NUMBER;
  FalhaEnvDoc      exception;
  --
begin
  --
  if pEnvioDocId<>nvl(rTissEnvioDoc.id,0) then
    rTissEnvioDoc := NULL;
    OPEN cTissEnvioDoc(pEnvioDocId);
    FETCH cTissEnvioDoc INTO rTissEnvioDoc;
    CLOSE cTissEnvioDoc;
    if rTissEnvioDoc.id is null then
      raise FalhaEnvDoc;
    end if;
  end if;
  --
  vCdConvenio := rTissEnvioDoc.cd_convenio;
  --
  dbamv.pkg_ffcv_tiss_v4.f_le_conf(pIdMap,vCdConvenio,null,null); -- l真 configura真真es da cadeia do CT (caso ainda n真o tenha sido lido no in真cio da guia que o chamou)
  --
  vTemp := F_mensagemTISS(null,1001,'ENVIO_DOCUMENTO',nEmpresaLogada,vCdConvenio,null,vCtMensagem,pMsg,null);
  --
  IF pMsg IS NULL THEN
    vTissEnviaDoc.id := pEnvioDocId;
    vTissEnviaDoc.id_pai := vCtMensagem.idMensagem;

    -- Grava真真o
    vResult := F_gravaTissEnviaDoc('ATUALIZA_ID',null,vTissEnviaDoc,pMsg,null);
    if pMsg is null then
      vResult  :=  lpad(vCtMensagem.idMensagem,20,'0');
    end if;
  END IF;
  --
  if vResult is null then
    ROLLBACK;
    return NULL;
  else
    COMMIT;
    return vResult;
  end if;
  --
  EXCEPTION
    when FalhaEnvDoc then
      pMsg := 'Solicita真真o ID = '||pEnvioDocId||' n真o encontrada ou mal-formada.';
      RETURN null;
    when OTHERS then
      pMsg := 'FALHA na Solicita真真o do Envio de Documento. Erro: '||SQLERRM;
      RETURN null;
  --
END;

FUNCTION  F_gravaTissEnviaDoc (  pModo           in varchar2,
                                pTpGuia         in varchar2,
                                vRg             in OUT NOCOPY dbamv.tiss_envio_documentos%rowtype,
                                pMsg            OUT varchar2,
                                pReserva        in varchar2) return varchar2 IS
  --
  NULL_VALUES EXCEPTION; PRAGMA EXCEPTION_INIT(NULL_VALUES, -1400);
  --
BEGIN
  --
  if pModo = 'ATUALIZA_ID' then
    Update dbamv.tiss_envio_documentos
       SET ID_PAI  = vRg.id_pai
     where id = vRg.id;
  END IF;
  --
  RETURN LPAD(vRg.id,20,'0')||',';
  --
  EXCEPTION
    when NULL_VALUES then
        pMsg := substr(SQLERRM,instr(SQLERRM,'.',-1)+2);pMsg := substr(pMsg,1,length(pMsg)-2);
        pMsg := 'Falha ao tentar atualizar o Envio de Documentos. Campo essencial sem conte真do: '||pMsg;
      RETURN NULL;
    when OTHERS then
      pMsg := 'FALHA na atualiza真真o da TISS_ENVIO_DOC:'||SQLERRM;
      RETURN NULL;
  --
END;

--Oswaldo FATURCONV-22406 fim
--Igor Inicio
FUNCTION f_retorna_campo_tiss(                           nMultiEmp in NUMBER
                                                        ,nConvenio in NUMBER
                                                        ,nTpAtendimento IN VARCHAR2
                                                        ,nCdOriAte IN NUMBER
                                                        ,cProFat in VARCHAR2
                                                        ,nCampoTiss in VARCHAR2
                                                        ,nDt_vigencia in DATE ) RETURN varchar2 is

CURSOR cRegrasTiss is
SELECT VL_CAMPO_TISS
      FROM dbamv.tiss_config_atend
     WHERE (tiss_config_atend.cd_multi_empresa = nMultiEmp OR tiss_config_atend.cd_multi_empresa  IS NULL)
       AND (tiss_config_atend.cd_convenio = nConvenio or tiss_config_atend.cd_convenio is null)
       AND  tiss_config_atend.ds_campo_tiss = nCampoTiss
       AND (tiss_config_atend.tp_atendimento = nTpAtendimento or tiss_config_atend.tp_atendimento is null)
       AND (tiss_config_atend.cd_ori_ate = nCdOriAte or tiss_config_atend.cd_ori_ate is null)
       AND  tiss_config_atend.dt_vigencia <= nDt_vigencia
       AND (tiss_config_atend.cd_pro_fat  = cProFat or tiss_config_atend.cd_pro_fat is null)
  ORDER BY dt_vigencia DESC ,cd_pro_fat,cd_ori_ate,tp_atendimento,cd_convenio,cd_multi_empresa;



p_valor VARCHAR2(500);

BEGIN

    OPEN cRegrasTiss;
    FETCH cRegrasTiss INTO p_valor;
    CLOSE cRegrasTiss;

    IF p_valor IS NOT NULL THEN

      RETURN p_valor;
    ELSE
      RETURN null;
    END IF;

END f_retorna_campo_tiss;

--IgorFim


END;
/

GRANT EXECUTE ON dbamv.pkg_ffcv_tiss_v4 TO dbaps;
GRANT EXECUTE ON dbamv.pkg_ffcv_tiss_v4 TO dbasgu;
GRANT EXECUTE ON dbamv.pkg_ffcv_tiss_v4 TO mv2000;
GRANT EXECUTE ON dbamv.pkg_ffcv_tiss_v4 TO mvintegra;
