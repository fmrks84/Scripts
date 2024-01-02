select
 paciente.cd_paciente prontuario
,dbamv.fnc_hmsj_prestador(hmsj_prestador_paciente.cd_prestador_pac) Nm_Prestador_Pac
,dbamv.mm_dev_pres_cel(hmsj_prestador_paciente.cd_prestador_pac) cel_pres_pac
,decode (hmsj_contr_convenio_n.cd_contr_conv_n, Null, '', 'CONVÊNIO SEM COBERTURA') sn_cobertura
,paciente.nm_paciente nome_do_paciente
,paciente.dt_nascimento data_de_nascimento
,(select fn_idade(paciente.dt_nascimento, 'a A / m M / d D')
    from dual) idade
,decode(paciente.tp_sexo
       ,'M'
       ,'MASCULINO'
       ,'F'
       ,'FEMININO'
       ,'I'
       ,'INDETERMINADO') descricao_do_sexo
,paciente.nr_identidade numero_da_identidade
,paciente.ds_om_identidade descricao_orgao_emissor
,paciente.nr_cpf numero_do_cpf
,paciente.nr_rg_nasc numero_do_registro
,paciente.nr_fone numero_do_telefone
,(select C.NR_DDD from dbamv.contato_paciente c where c.tp_contato = 'C' and c.Sn_Padrao = 'S' and c.cd_paciente = paciente.cd_paciente) DDD_CEL
,(select nr_telefone from dbamv.contato_paciente c where c.tp_contato = 'C' and c.sn_padrao = 'S' and c.cd_paciente = paciente.cd_paciente) contato_cel
,(select C.NR_DDD from dbamv.contato_paciente c where c.tp_contato = 'R' and c.sn_padrao = 'S' and c.cd_paciente = paciente.cd_paciente) DDD_RES
,(select nr_telefone from dbamv.contato_paciente c where c.tp_contato = 'R' and c.sn_padrao = 'S'and c.cd_paciente = paciente.cd_paciente) contato_RES
,(select C.NR_DDD from dbamv.contato_paciente c where c.tp_contato = 'O' and c.sn_padrao = 'S' and c.cd_paciente = paciente.cd_paciente) DDD_COM
,(select nr_telefone from dbamv.contato_paciente c where c.tp_contato = 'O' and c.sn_padrao = 'S' and c.cd_paciente = paciente.cd_paciente) contato_COM
,paciente.nr_cep numero_do_cep
,paciente.ds_endereco descricao_do_endereco
,paciente.nr_endereco numero_do_endereco
,paciente.ds_complemento complemento_do_endereco
,paciente.nm_bairro descricao_do_bairro
,atendime.nm_usuario usuario_cadastro
,cidade.nm_cidade naturalidade
,atendime.nr_chamada_painel
,atendime.cd_atendimento
,(select nm_cidade
    from dbamv.cidade
   where cd_cidade = paciente.cd_cidade) cidade

,convenio.cd_convenio codigo_convenio
,convenio.nm_convenio descricao_convenio
,con_pla.ds_con_pla plano
,cd_pro_int cod_proc_principal
,ds_pro_fat des_proc_principal
,to_char(dt_atendimento, 'DD/MM/YYYY') data_atendimento
,to_char(hr_atendimento, 'HH24:MI:SS') hora_atendimento
,decode(tp_atendimento
       ,'E'
       ,'Externo'
       ,'A'
       ,'Ambulatorial'
       ,'I'
       ,'Internação'
       ,'U'
       ,'Urgência/Emergência') descricao_tp_atendimento
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
/*
,(select decode(hmsj_ficha_pa.ck_emergencia
               ,'S'
               ,'VERMELHO'
               ,decode(hmsj_ficha_pa.ck_urgencia
               ,'S'
               ,'LARANJA'
               ,decode(hmsj_ficha_pa.ck_prioridade1
               ,'S'
               ,'AMARELO'
               ,decode(hmsj_ficha_pa.ck_prioridade2
               ,'S'
               ,'VERDE','')))) cor
  from dbamv.hmsj_ficha_pa
  where cd_ficha_pa = (select max(cd_ficha_pa)
                     from dbamv.hmsj_ficha_pa
                     where ((hmsj_ficha_pa.cd_paciente = atendime.cd_paciente 
                     and     hmsj_ficha_pa.cd_atendimento is null) or (hmsj_ficha_pa.cd_atendimento = atendime.cd_atendimento 
                     and     hmsj_ficha_pa.cd_atendimento is not null)))) cor         */

 ,dbamv.fnc_hmsj_classificacao(atendime.cd_paciente , atendime.cd_atendimento  ) cor
/*
,(select substr(queixa, 0, 100) queixa
  from dbamv.hmsj_ficha_pa
  where cd_ficha_pa = (select max(cd_ficha_pa)
                       from dbamv.hmsj_ficha_pa
                       where ((hmsj_ficha_pa.cd_paciente = atendime.cd_paciente 
                       and    hmsj_ficha_pa.cd_atendimento is null) or    (hmsj_ficha_pa.cd_atendimento = atendime.cd_atendimento 
                       and   hmsj_ficha_pa.cd_atendimento is not null)))) queixa*/

 ,dbamv.fnc_hmsj_queixa(atendime.cd_paciente , atendime.cd_atendimento  ) queixa

  from dbamv.atendime
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
      ,dbamv.paciente
      ,dbamv.contato_paciente ----inclusao 11/11/15 Fabio Marques
      ,dbamv.pais
      ,dbamv.religiao
      ,dbamv.responsa
      ,dbamv.tip_paren
      ,dbamv.profissao
      ,dbamv.cidade
      ,dbamv.tipo_internacao
      ,dbamv.loc_proced
      ,dbamv.ate_motivo
      ,dbamv.mot_ent
      ,dbamv.conselho
      ,dbamv.vdic_paciente
      ,dbamv.grau_ins
      ,dbamv.hmsj_prestador_paciente
      ,dbamv.hmsj_contr_convenio_n
  
 where atendime.cd_ori_ate = ori_ate.cd_ori_ate
   and atendime.cd_atendimento = ate_motivo.cd_atendimento(+)
   and atendime.cd_atendimento = hmsj_prestador_paciente.cd_atendimento (+) --- Acresc
   and atendime.cd_Atendimento = hmsj_contr_convenio_n.cd_atendimento (+)
   and ate_motivo.cd_mot_ent = mot_ent.cd_mot_ent(+)
   and convenio.cd_convenio(+) = atendime.cd_convenio
   and contato_paciente.cd_paciente(+) = paciente.cd_paciente
   and pro_fat.cd_pro_fat(+) = atendime.cd_pro_int
   and prestador.cd_prestador(+) = atendime.cd_prestador
   and leito.cd_leito(+) = atendime.cd_leito
   and unid_int.cd_unid_int(+) = leito.cd_unid_int
   and pais.cd_pais(+) = paciente.cd_cidadania
   and mot_alt.cd_mot_alt(+) = atendime.cd_mot_alt
   and cid.cd_cid(+) = atendime.cd_cid
   and servico.cd_servico(+) = atendime.cd_servico
   and tip_acom.cd_tip_acom(+) = atendime.cd_tip_acom
   and multi_empresas.cd_multi_empresa = atendime.cd_multi_empresa
   and con_pla.cd_con_pla(+) = atendime.cd_con_pla
   and con_pla.cd_convenio(+) = atendime.cd_convenio
   and especialid.cd_especialid(+) = atendime.cd_especialid
   and tip_mar.cd_tip_mar(+) = atendime.cd_tip_mar
   and paciente.cd_paciente = atendime.cd_paciente
   and paciente.cd_paciente = vdic_paciente.codigo_paciente
   and religiao.cd_religiao(+) = paciente.cd_religiao
   and responsa.cd_atendimento(+) = atendime.cd_atendimento
   and tip_paren.cd_tip_paren(+) = responsa.cd_tip_paren
   and profissao.cd_profissao(+) = paciente.cd_profissao
   and cidade.cd_cidade(+) = paciente.cd_naturalidade
   and tipo_internacao.cd_tipo_internacao(+) = atendime.cd_tipo_internacao
   and atendime.cd_loc_proced = loc_proced.cd_loc_proced(+)
   and conselho.cd_conselho = prestador.cd_conselho
   and paciente.cd_grau_ins = grau_ins.cd_grau_ins(+)
   and atendime.cd_atendimento = (select dbamv.pkg_mv_atendimento.get_cdatendimento from sys.dual)
