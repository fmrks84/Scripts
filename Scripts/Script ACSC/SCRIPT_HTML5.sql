select * from dbamv.FSCC_CONFIG_FUNCIONALIDADE;

 
INSERT INTO FSCC_CONFIG_FUNCIONALIDADE VALUES ('TF', 'TRANSFERÊNCIA DE FASE');
INSERT INTO FSCC_CONFIG_FUNCIONALIDADE VALUES ('RC', 'REGISTRAR CONTATO');
INSERT INTO FSCC_CONFIG_FUNCIONALIDADE VALUES ('EE', 'ENVIAR EMAIL');
INSERT INTO FSCC_CONFIG_FUNCIONALIDADE VALUES ('PE', 'PENDÊNCIAS');
INSERT INTO FSCC_CONFIG_FUNCIONALIDADE VALUES ('GU', 'GUIAS');
INSERT INTO FSCC_CONFIG_FUNCIONALIDADE VALUES ('RS', 'RESERVAR SALA');
INSERT INTO FSCC_CONFIG_FUNCIONALIDADE VALUES ('EP', 'EDITAR PRE-AGENDAMENTO');
INSERT INTO FSCC_CONFIG_FUNCIONALIDADE VALUES ('CA', 'CANCELAR AGENDAMENTO');
INSERT INTO FSCC_CONFIG_FUNCIONALIDADE VALUES ('SP', 'SUSPENDER AGENDAMENTO');
INSERT INTO FSCC_CONFIG_FUNCIONALIDADE VALUES ('RB', 'RETIRAR SUSPENSÃO AGENDAMENTO');
commit;

--------------------------INSERT USUARIO WORKFLOW-------------------------------------                            
BEGIN
  FOR USUS IN (select distinct F.tp_funcionalidade,
                               usu.cd_usuario,
                               7 EMPRESA
                 from dbamv.Fscc_Config_Funcionalidade f,
                      (SELECT U.CD_USUARIO
                         FROM DBASGU.USUARIOS U
                        WHERE U.CD_USUARIO IN (/*'CAROLINA.CARMO',
                                               'JOAO.PAULO',
                                               'GUILHERME.TERVEDO',
                                               'IASMIM.FEITOSA',
                                               'BARBARA.PETILLO',*/
                                               'DBAMV')) usu
                where not exists
                (select 1
                         from dbamv.Fscc_Config_Funcionalidade_Usu t
                        where t.cd_usuario = usu.cd_usuario
                          and t.tp_funcionalidade = f.tp_funcionalidade)) LOOP
    insert into dbamv.Fscc_Config_Funcionalidade_Usu
      (tp_funcionalidade, cd_usuario, cd_multi_empresa)
    VALUES
      (USUS.TP_FUNCIONALIDADE, USUS.CD_USUARIO, USUS.EMPRESA); 
      END LOOP;
END;
