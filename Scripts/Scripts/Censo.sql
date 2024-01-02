select
       atendime.cd_atendimento                  Codigo_do_Atendimento
      ,atendime.cd_ori_ate                      Codigo_da_Origem_Atendimento
      ,atendime.cd_paciente                     Codigo_do_Paciente
      ,atendime.cd_convenio                     Codigo_do_Convenio
      ,atendime.cd_sub_plano                    Codigo_do_Sub_Plano
      ,atendime.cd_convenio_secundario          Codigo_Convenio_Secundario
      ,atendime.cd_con_pla_secundario           Codigo_Plano_Secundario
      ,atendime.dt_atendimento                  Data_do_Atendimento
      ,atendime.hr_atendimento                  Horario_do_Atendimento
      ,atendime.cd_pro_int                      Codigo_Proced_Atendimento
      ,atendime.cd_pro_int_procedimento_entrad  Codigo_Prodec_Entrada
      ,atendime.dt_prevista_alta                Data_Prevista_de_Alta
      ,atendime.dt_alta_medica                  Data_da_Alta_Medica
      ,atendime.hr_alta_medica                  Horario_Alta_Medica
      ,atendime.nm_usuario_alta_medica          Nome_Usuario_Alta_Medica
      ,atendime.dt_alta                         Data_da_Alta
      ,atendime.hr_alta                         Horario_da_Alta
      ,atendime.ds_obs_alta                     Observacoes_da_Alta
      ,atendime.cd_mot_alt                      Codigo_Motivo_Alta
      ,atendime.nm_usuario_alta                 Nome_Usuario_Alta
      ,atendime.cd_tip_res                      Codigo_Tipo_Resultado
      ,atendime.tp_atendimento                  Tipo_do_Atendimento
      ,decode(atendime.tp_atendimento, 'I', 'INTERNACAO'
                                     , 'A', 'AMBULATORIO'
                                     , 'U', 'URGENCIA/EMERGENCIA'
                                     , 'E', 'EXTERNO'
                                     , 'H', 'HOME CARE'
                                     , 'B', 'BUSCA ATIVA'
                                     , 'S', 'SUS AIH' )    Descricao_Tipo_Atendimento
      ,atendime.cd_prestador                    Codigo_do_Prestador
      ,atendime.cd_leito                        Codigo_do_Leito
      ,atendime.cd_loc_trans                    Codigo_Local_Transferencia
      ,atendime.dt_diag                         Data_Diagnostico
      ,atendime.cd_cid                          Codigo_CID
      ,atendime.cd_servico                      Codigo_do_Servico
      ,atendime.cd_loc_proced                   Codigo_Local_Procedencia
      ,atendime.ds_atendimento                  Descricao_do_Atendimento
      ,atendime.cd_tip_acom                     Codigo_Tipo_Acomodacao
      ,atendime.cd_ser_dis
      ,atendime.cd_des_ate
      ,atendime.ds_ate_oco
      ,atendime.cd_casos_atd
      ,atendime.cd_especialid                   Codigo_Especialidade
      ,atendime.ds_destino_transferencia        Destino_da_Transferencia
      ,atendime.cd_tipo_internacao              Codigo_Tipo_Internacao
      ,atendime.cd_ssm_cih
      ,atendime.dt_entrada_same                 Data_Entrada_SAME
      ,atendime.dt_val_guia                     Data_Validade_Guia
      ,atendime.nr_guia                         Numero_da_Guia
      ,atendime.cd_tip_mar
      ,atendime.sn_acompanhante                 Acompanhante
      ,atendime.sn_infeccao                     Infeccao
      ,atendime.sn_obito                        Obito
      ,atendime.sn_recebe_visita                Recebe_Visita
      ,atendime.sn_importa_auto                 Importacao_automatica
      ,atendime.nm_usuario                      Nome_Usuario
      ,atendime.sn_retorno                      Retorno
      ,atendime.dt_retorno                      Data_do_Retorno
      ,atendime.nm_usuario_retorno              Nome_Usuario_Retorno
      ,atendime.qt_sessoes                      Quantidade_Sessoes
      ,atendime.dt_revisao                      Data_Revisao
      ,atendime.cd_servico_saida                Codigo_Servico_Saida
      ,atendime.cd_especialid_saida             Codigo_Especialidade_Saida
      ,atendime.cd_loc_trans_saida              Codigo_Local_Transf_Saida
      ,atendime.cd_mot_trans_saida              Codigo_Motivo_Transf_Saida
      ,atendime.dt_aviso_medico                 Data_Aviso_Medico
      ,atendime.hr_aviso_medico                 Horario_Aviso_Medico
      ,atendime.ds_aviso_tp_contato
      ,atendime.ds_aviso_obs                    Observacao_Aviso_Medico
      ,atendime.nm_aviso_usuario                Nome_Usuario_Aviso
      ,atendime.tp_programa_alta_unidade
      ,atendime.ds_programa_alta
      ,atendime.dt_programa_alta                Data_Programacao_Alta
      ,atendime.nm_usuario_prog_alta            Nome_Usuario_Progr_Alta
      ,atendime.dt_liberacao                    Data_Liberacao
      ,atendime.cd_tip_situacao                 Codigo_Tipo_Situacao
      ,atendime.ds_obs_psih                     Observacao_CCIH
      ,atendime.sn_busca_ativa                  Busca_Ativa
      ,atendime.tp_busca_ativa                  Tipo_Busca_Ativa
      ,atendime.sn_em_atendimento               Em_Atendimento
      ,atendime.tp_prioridade                   Tipo_Prioridade
      ,atendime.cd_ssm_sia
      ,atendime.cd_gru_ate                      Codigo_Grupo_Atendimento
      ,atendime.sn_consulta_siasus
      ,atendime.nr_chamada_painel               Numero_Chamada_Painel
      ,atendime.nr_laudo                        Numero_Laudo
      ,atendime.nr_laudo_alto_custo             Numero_Laudo_Auto_Custo
      ,atendime.nr_pedido_laudo                 Numero_Pedido_Laudo
      ,atendime.cd_usuario_diag                 Codigo_Usuario_Diagnostico
      ,atendime.cd_usuario_upd_diag
      ,atendime.dt_ultima_upd_diag
      ,atendime.cd_escala_dia                   Codigo_Escala_Dia
      ,atendime.hr_agenda                       Horario_Agenda
      ,atendime.cd_tip_acom_cobertura
      ,atendime.senha_sus                       senha_sus
      ,atendime.cd_multi_empresa                Codigo_Multi_Empresa
      ,cid.ds_cid                               Descricao_CID
      ,casos_atd.ds_hda
      ,casos_atd.ds_ex_fis
      ,casos_atd.ds_evolucao
      ,casos_atd.ds_diagnostico
      ,casos_atd.ds_tratamento
      ,casos_atd.cd_cid
      ,convenio.nm_convenio                     Nome_Convenio
      ,conselho.ds_conselho                     Descricao_Conselho
      ,cidade_loc_trans.nm_cidade               Cidade_Transferencia
      ,con_pla.cd_con_pla                       Codigo_Plano_do_Convenio
      ,con_pla.ds_con_pla                       Descricao_Plano_do_Convenio
      ,des_ate.ds_des_ate
      ,especialid.ds_especialid                 Descricao_Especialidade
      ,especialid_saida.ds_especialid           Descricao_Especialidade_Saida
      ,leito.ds_leito                           Descricao_Leito
      ,leito.ds_resumo                          Descricao_Resumida_Leito
      ,leito.cd_unid_int                        Codigo_Unidade_Internacao
      ,loc_trans.ds_loc_trans                   Descricao_Local_Transferencia
      ,loc_trans.ds_endereco                    Endereco_Transferencia
      ,loc_trans.nr_endereco                    Numero_Endereco_Transferencia
      ,loc_trans.ds_complemento                 Complemento_Transferencia
      ,loc_trans.nm_bairro                      Bairro_Transferencia
      ,loc_trans.nr_cep                         CEP_Transferencia
      ,loc_trans.nr_fone                        Fone_Transferencia
      ,loc_proced.ds_loc_proced                 Descricao_Local_Procedencia
      ,loc_trans_saida.ds_loc_trans             Desc_Local_Transferencia_Saida
      ,mot_alt.ds_mot_alt                       Descricao_Motivo_Alta
      ,mot_trans_saida.ds_mot_transferencia     Descricao_Motivo_Transferencia
      ,ori_ate.ds_ori_ate                       Descricao_Origem_Atendimento
      ,paciente.nm_paciente                     Nome_Paciente
      ,pro_fat.ds_pro_fat                       Descricao_Proced_Faturamento
      ,pro_fat_entrada.ds_pro_fat               Descri_Proced_Fatur_Entrada
      ,prestador.nm_prestador                   Nome_Prestador
      ,prestador.nm_mnemonico                   Apelido_Prestador
      ,prestador.ds_codigo_conselho             Descricao_Codigo_Conselho
      ,pro_fat_cih.ds_pro_fat
      ,servico.ds_servico                       Descricao_Servico
      ,ser_dis.ds_ser_dis
      ,servico_saida.ds_servico
      ,tip_res.ds_tip_res                       Descricao_Tipo_Resultado
      ,tip_acom_do_atendimento.ds_tip_acom      Descr_Acomod_Atendimento
      ,tipo_internacao.ds_tipo_internacao       Descricao_Tipo_Internacao
      ,tip_mar.ds_tip_mar
      ,tip_situacao.ds_tip_situacao             Descricao_Tipo_Situacao
      ,tip_acom_cobertura.ds_tip_acom           Descricao_Acomodacao_Cobertura
      ,unid_int.ds_unid_int                     Descricao_Unidade_Internacao
      ,atendime.CD_ATENDIMENTO_SUS_VINCULADO    Codigo_Atend_SUS_Vinculado
 from
       dbamv.atendime
      ,dbamv.ori_ate
      ,dbamv.paciente
      ,dbamv.convenio
      ,dbamv.con_pla
      ,dbamv.pro_fat
      ,dbamv.pro_fat pro_fat_entrada
      ,dbamv.leito
      ,dbamv.unid_int
      ,dbamv.pro_fat pro_fat_cih
      ,dbamv.tip_acom
      ,dbamv.loc_trans
      ,dbamv.loc_trans             loc_trans_saida
      ,dbamv.cidade                cidade_loc_trans
      ,dbamv.mot_transferencia     mot_trans_saida
      ,dbamv.mot_alt
      ,dbamv.cid
      ,dbamv.servico
      ,dbamv.tip_res
      ,dbamv.ser_dis
      ,dbamv.des_ate
      ,dbamv.tipo_internacao
      ,dbamv.loc_proced
      ,dbamv.especialid
      ,dbamv.tip_mar
      ,dbamv.especialid            especialid_saida
      ,dbamv.servico               servico_saida
      ,dbamv.tip_acom              tip_acom_cobertura
      ,dbamv.tip_situacao
      ,dbamv.tip_acom              tip_acom_do_atendimento
      ,dbamv.prestador
      ,dbamv.conselho
      ,dbamv.casos_atd
  where
        ori_ate.cd_ori_ate                     = atendime.cd_ori_ate
    and paciente.cd_paciente                   = atendime.cd_paciente
    and convenio.cd_convenio                   = atendime.cd_convenio
    and con_pla.cd_convenio(+)                 = atendime.cd_convenio
    and con_pla.cd_con_pla(+)                  = atendime.cd_con_pla
    and pro_fat.cd_pro_fat(+)                  = atendime.cd_pro_int
    and pro_fat_entrada.cd_pro_fat(+)          = atendime.cd_pro_int_procedimento_entrad
    and leito.cd_leito(+)                      = atendime.cd_leito
    and unid_int.cd_unid_int(+)                = leito.cd_unid_int
    and pro_fat_cih.cd_pro_fat(+)              = atendime.cd_ssm_cih
    and tip_acom.cd_tip_acom(+)                = atendime.cd_tip_acom
    and loc_trans.cd_loc_trans(+)              = atendime.cd_loc_trans
    and cidade_loc_trans.cd_cidade(+)          = loc_trans.cd_cidade
    and loc_trans_saida.cd_loc_trans(+)        = atendime.cd_loc_trans_saida
    and mot_trans_saida.cd_mot_transferencia(+)= atendime.cd_mot_trans_saida
    and mot_alt.cd_mot_alt(+)                  = atendime.cd_mot_alt
    and cid.cd_cid(+)                          = atendime.cd_cid
    and servico.cd_servico(+)                  = atendime.cd_servico
    and tip_res.cd_tip_res(+)                  = atendime.cd_tip_res
    and ser_dis.cd_ser_dis(+)                  = atendime.cd_ser_dis
    and des_ate.cd_des_ate(+)                  = atendime.cd_des_ate
    and tipo_internacao.cd_tipo_internacao(+)  = atendime.cd_tipo_internacao
    and loc_proced.cd_loc_proced(+)            = atendime.cd_loc_proced
    and especialid.cd_especialid(+)            = atendime.cd_especialid
    and tip_mar.cd_tip_mar(+)                  = atendime.cd_tip_mar
    and servico_saida.cd_servico(+)            = atendime.cd_servico_saida
    and especialid_saida.cd_especialid(+)      = atendime.cd_especialid_saida
    and tip_acom_cobertura.cd_tip_acom(+)      = atendime.cd_tip_acom_cobertura
    and tip_situacao.cd_tip_situacao(+)        = atendime.cd_tip_situacao
    and tip_acom_do_atendimento.cd_tip_acom(+) = atendime.cd_tip_acom
    and prestador.cd_prestador(+)              = atendime.cd_prestador
    and conselho.cd_conselho(+)                = prestador.cd_conselho
    and casos_atd.cd_casos_atd(+)              = atendime.cd_casos_atd
    and atendime.cd_prestador = 1824
    and atendime.tp_atendimento = 'I'
