Select
--cadastro do paciente
 PACIENTE.CD_PACIENTE PRONTUARIO
,PACIENTE.NM_PACIENTE NOME_DO_PACIENTE
,PACIENTE.DT_NASCIMENTO DATA_DE_NASCIMENTO
,(select fn_idade (paciente.dt_nascimento, 'a A / m M / d D' ) from dual) IDADE
,DECODE( PACIENTE.TP_SEXO,'M', 'MASCULINO'
                         ,'F', 'FEMININO'
                         ,'I', 'INDETERMINADO' ) DESCRICAO_DO_SEXO
,PACIENTE.NR_IDENTIDADE NUMERO_DA_IDENTIDADE
,PAIS.NM_PAIS  NACIONALIDADE
,PACIENTE.DS_OM_IDENTIDADE  DESCRICAO_ORGAO_EMISSOR
,PACIENTE.NR_CPF NUMERO_DO_CPF
,PACIENTE.NR_RG_NASC  NUMERO_DO_REGISTRO
,DECODE( PACIENTE.TP_ESTADO_CIVIL,'S', 'SOLTEIRO'
                                 ,'C', 'CASADO'
                                 ,'V','VIUVO'
                                 ,'D', 'DESQUITADO'
                                 ,'I', 'DIVORCIADO'
                                 ,'U', 'UNIÃO CONSENSUAL'
                                 ,NULL, 'NAO INFORMADO' ) DESCRICAO_DO_ESTADO_CIVIL
,'FICHA DE ' || DECODE( ATENDIME.TP_ATENDIMENTO,'U', 'URGENCIA/EMERGENCIA'
                                 ,'I', 'INTERNACAO'
                                 ,'E','EXTERNO'
                                 ,'A', 'AMBULATORIO') TIPO_ATENDIMENTO
,PACIENTE.NM_MAE NOME_DA_MAE
,PACIENTE.NR_CNS CNS
,VDIC_PACIENTE.DESCRICAO_UF  UF
,PACIENTE.NM_PAI NOME_DO_PAI
,GRAU_INS.DS_GRAU_INS
,PACIENTE.NR_FONE NUMERO_DO_TELEFONE
,PACIENTE.NR_CEP NUMERO_DO_CEP
,PACIENTE.DS_ENDERECO DESCRICAO_DO_ENDERECO
,PACIENTE.NR_ENDERECO NUMERO_DO_ENDERECO
,PACIENTE.DS_COMPLEMENTO COMPLEMENTO_DO_ENDERECO
,PACIENTE.NM_BAIRRO DESCRICAO_DO_BAIRRO
,PACIENTE.NM_USUARIO USUARIO_CADASTRO
,RELIGIAO.DS_RELIGIAO RELIGIAO
,PROFISSAO.NM_PROFISSAO
,CIDADE.NM_CIDADE NATURALIDADE
,ATENDIME.NR_CHAMADA_PAINEL
,(Select nm_cidade
    from dbamv.cidade
   where cd_cidade = paciente.cd_cidade) CIDADE

-- atendimento

,lpad(atendime.cd_atendimento,6,'0') atendimento
,ds_ori_ate descricao_origem
,convenio.cd_convenio codigo_convenio
,nm_convenio descricao_convenio
,con_pla.ds_con_pla plano
,cd_pro_int cod_proc_principal
,ds_pro_fat des_proc_principal
,to_char(dt_atendimento, 'DD/MM/YYYY') data_atendimento
,to_char(hr_atendimento, 'HH24:MI:SS') hora_atendimento
,decode(tp_atendimento, 'E', 'Externo', 'A', 'Ambulatorial', 'I', 'Internação', 'U', 'Urgência/Emergência') descricao_tp_atendimento
,prestador.cd_prestador codigo_prestador
,nm_prestador nome_prestador
,ds_conselho
,prestador.ds_codigo_conselho
,ds_especialid especialidade
,ds_leito leito
,ds_enfermaria enfermaria
,ds_unid_int unidade_internacao
,cid.cd_cid codigo_cid
,cid.ds_cid descricao_cid
,ds_servico servico
,ds_tip_acom acomodacao_atendimento
,atendime.nm_usuario usuario_atendimento
,nvl(tip_mar.ds_tip_mar, tipo_internacao.ds_tipo_internacao) tipo_marcacao
,atendime.nr_carteira carteirinha
,ds_multi_empresa
,responsa.nm_responsavel responsavel
,responsa.nr_fone responsavel_fone
,responsa.ds_endereco responsavel_endereco
,tip_paren.ds_tip_paren responsavel_parentesco
,responsa.nr_endereco responsavel_nr_end
,responsa.ds_complemento responsavel_complemento
,responsa.nr_cep responsavel_cep
,guia.nr_guia
,guia.nr_dias_autorizados guia_dias
,guia.nr_horas_autorizadas guia_horas
,ds_loc_proced  local_proced

-- Motivos do Atendimento

,mot_ent.cd_mot_ent
,mot_ent.ds_mot_ent

From dbamv.atendime
    ,dbamv.ori_ate
    ,dbamv.convenio
    ,dbamv.pro_fat
    ,dbamv.prestador
    ,dbamv.leito
    ,dbamv.multi_empresas
    ,dbamv.unid_int
    ,dbamv.mot_alt
    ,dbamv.cid
    ,dbamv.tip_acom
    ,dbamv.servico
    ,dbamv.con_pla
    ,dbamv.especialid
    ,dbamv.tip_mar
    ,dbamv.carteira
    ,dbamv.paciente
    ,dbamv.pais
    ,dbamv.religiao
    ,dbamv.responsa
    ,dbamv.tip_paren
    ,dbamv.profissao
    ,dbamv.cidade
    ,dbamv.tipo_internacao
    ,dbamv.guia
    ,dbamv.loc_proced
    ,dbamv.ate_motivo
    ,dbamv.mot_ent
    ,dbamv.conselho
    ,dbamv.vdic_paciente
    ,dbamv.grau_ins

 where atendime.cd_ori_ate       = ori_ate.cd_ori_ate
   and atendime.cd_atendimento = ate_motivo.cd_atendimento(+)
   and ate_motivo.cd_mot_ent = mot_ent.cd_mot_ent(+)
   and convenio.cd_convenio      = atendime.cd_convenio
   and pro_fat.cd_pro_fat(+)     = atendime.cd_pro_int
   and prestador.cd_prestador(+) = atendime.cd_prestador
   and leito.cd_leito(+)         = atendime.cd_leito
   and unid_int.cd_unid_int(+)   = leito.cd_unid_int
   and pais.cd_pais          = paciente.cd_cidadania (+)
   and mot_alt.cd_mot_alt(+)     = atendime.cd_mot_alt
   and cid.cd_cid(+)             = atendime.cd_cid
   and servico.cd_servico(+)     = atendime.cd_servico
   and tip_acom.cd_tip_acom(+)   = atendime.cd_tip_acom
   and multi_empresas.cd_multi_empresa = atendime.cd_multi_empresa
   and con_pla.cd_con_pla        = atendime.cd_con_pla
   and con_pla.cd_convenio       = atendime.cd_convenio
   and especialid.cd_especialid(+)  = atendime.cd_especialid
   and tip_mar.cd_tip_mar(+)     = atendime.cd_tip_mar
   and carteira.cd_paciente(+)   = atendime.cd_paciente
   and carteira.cd_convenio(+)   = atendime.cd_convenio
   and carteira.cd_con_pla(+)    = atendime.cd_con_pla
   and paciente.cd_paciente   = atendime.cd_paciente
   and paciente.cd_paciente  =  vdic_paciente.codigo_paciente
   and religiao.cd_religiao(+) = paciente.cd_religiao
   and responsa.cd_atendimento(+)  = atendime.cd_atendimento
   and tip_paren.cd_tip_paren(+) = responsa.cd_tip_paren
   and profissao.cd_profissao(+) = paciente.cd_profissao
   and cidade.cd_cidade(+) = paciente.cd_naturalidade
   and tipo_internacao.cd_tipo_internacao(+) = atendime.cd_tipo_internacao
   and guia.cd_atendimento(+) = atendime.cd_atendimento
   and decode(guia.cd_guia, null, 1, 0) = decode(guia.tp_guia, 'I', 0, 'C', 0, 1)
   and atendime.cd_loc_proced =loc_proced.cd_loc_proced(+)
   and conselho.cd_conselho = prestador.cd_conselho
   and paciente.cd_grau_ins  = grau_ins.cd_grau_ins (+)
   and atendime.cd_atendimento = select dbamv.pkg_mv_atendimento.get_cdatendimento from sys.dual)


--SELECT * FROM PACIENTE WHERE CD_PACIENTE = 29111

--SELECT * FROM PAIS
