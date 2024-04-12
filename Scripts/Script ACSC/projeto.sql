select * from site_integra_convenio;

insert into site_projeto (SN_ATIVO, VL_ABA_WIZARD, SN_ATIVA_SN_ATIVO, DS_PROJETO, TP_PROJETO, CD_SITE_PROJETO)
values ('S', 1, 'N', 'OVERMIND', 'C', 10);

insert into site_servico (CD_SERVICO, DS_SERVICO, CD_SERVICO_RETORNO, DS_OBSERVACAO, SN_ATIVO, DS_VERSAO, NR_TEMPO_ESPERA_TIMEOUT, TP_SERVICO, CD_SITE_PROJETO, CD_SITE_ELEMENTO_MAPA, SN_VALIDAR_PELO_XSD)
values (10, 'OVERMIND', null, null, 'S', null, null, 'E', 10, null, 'S');

