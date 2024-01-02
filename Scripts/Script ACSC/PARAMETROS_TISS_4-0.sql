-- TELA DE APURACAO
update convenio_conf_tiss x  set x.sn_retorno_fat_tiss  = 'S' where 1 = 1 ;
COMMIT;

-- CHAVE NOVA TELA APURACAO
--FFCV - PARAMENTRO = M_CONVENIO_CONF_TISS DESC= TELA DE APURACAO DE IMPORTACAO DE PAGAMENTOS  CHAVE = S
/*select c.cd_sistema,c.chave,c.valor,c.sn_somente_leitura,c.cd_configuracao,c.cd_configuracao_processo,c.ds_configuracao,c.cd_multi_empresa 
from configuracao c where c.chave = 'M_CONVENIO_CONF_TISS' */

insert into dbamv.configuracao (cd_sistema,chave,valor,sn_somente_leitura,cd_configuracao,cd_configuracao_processo,ds_configuracao,cd_multi_empresa)values
('FFCV','M_CONVENIO_CONF_TISS','S','N',SEQ_CONFIGURACAO.NEXTVAL,NULL,'TELA DE APURACAO DE IMPORTACAO DE PAGAMENTOS',3);
COMMIT;
insert into dbamv.configuracao (cd_sistema,chave,valor,sn_somente_leitura,cd_configuracao,cd_configuracao_processo,ds_configuracao,cd_multi_empresa)values
('FFCV','M_CONVENIO_CONF_TISS','S','N',SEQ_CONFIGURACAO.NEXTVAL,NULL,'TELA DE APURACAO DE IMPORTACAO DE PAGAMENTOS',4);
COMMIT;
insert into dbamv.configuracao (cd_sistema,chave,valor,sn_somente_leitura,cd_configuracao,cd_configuracao_processo,ds_configuracao,cd_multi_empresa)values
('FFCV','M_CONVENIO_CONF_TISS','S','N',SEQ_CONFIGURACAO.NEXTVAL,NULL,'TELA DE APURACAO DE IMPORTACAO DE PAGAMENTOS',7);
COMMIT;
insert into dbamv.configuracao (cd_sistema,chave,valor,sn_somente_leitura,cd_configuracao,cd_configuracao_processo,ds_configuracao,cd_multi_empresa)values
('FFCV','M_CONVENIO_CONF_TISS','S','N',SEQ_CONFIGURACAO.NEXTVAL,NULL,'TELA DE APURACAO DE IMPORTACAO DE PAGAMENTOS',10);
COMMIT;
insert into dbamv.configuracao (cd_sistema,chave,valor,sn_somente_leitura,cd_configuracao,cd_configuracao_processo,ds_configuracao,cd_multi_empresa)values
('FFCV','M_CONVENIO_CONF_TISS','S','N',SEQ_CONFIGURACAO.NEXTVAL,NULL,'TELA DE APURACAO DE IMPORTACAO DE PAGAMENTOS',11);
COMMIT;
insert into dbamv.configuracao (cd_sistema,chave,valor,sn_somente_leitura,cd_configuracao,cd_configuracao_processo,ds_configuracao,cd_multi_empresa)values
('FFCV','M_CONVENIO_CONF_TISS','S','N',SEQ_CONFIGURACAO.NEXTVAL,NULL,'TELA DE APURACAO DE IMPORTACAO DE PAGAMENTOS',25);
COMMIT;

--- ATIVACAO TELA 
/*select MD.CD_MODULO, MD.NM_MODULO,MD.TP_MODULO,MD.DS_OBSERVACAO,MD.CD_CLIENTE,MD.CD_HELP,MD.DT_CRIACAO,MD.CD_SISTEMA_DONO,MD.SN_ATIVO_REL_ESPECIFICO,MD.SN_ARMAZENA_PARAMETRO,MD.SN_CF_ACESSO,MD.DS_MENU_PRINCIPAL,MD.DS_TIPO_SEGMENTO,MD.SN_SEG_ATIVO,MD.TP_TELA,MD.DS_CAMINHO,MD.LO_ICONE,MD.TP_PERFIL,MD.SN_HTML5 
 from dbasgu.modulos md where md.cd_modulo = 'M_BAIXA_LOTE'*/

insert into dbasgu.modulos(cd_modulo,nm_modulo,tp_modulo,ds_observacao,cd_cliente,cd_help,dt_criacao,cd_sistema_dono,sn_ativo_rel_especifico,sn_armazena_parametro,sn_cf_acesso,ds_menu_principal,ds_tipo_segmento,sn_seg_ativo,tp_tela,ds_caminho,lo_icone,tp_perfil,sn_html5)values
('M_BAIXA_LOTE','BAIXA_LOTE','F',null,null,null,to_date(sysdate,'dd/mm/rrrr'),'FNFI','S','N','N',null,null,'N',null,null,null,'SISTEMA','N');
commit;

INSERT INTO DBASGU.AUT_MOD(CD_USUARIO,CD_MODULO,SN_CONSULTAR,SN_ALTERAR,SN_EXCLUIR,SN_INCLUIR)
(SELECT CD_USUARIO,'M_BAIXA_LOTE','N','N','N','N' FROM DBASGU.USUARIOS WHERE SN_ATIVO = 'S');
COMMIT;

