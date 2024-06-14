prompt Importing table val_pro...
set feedback off
set define off

insert into val_pro (CD_TAB_FAT, CD_PRO_FAT, DT_VIGENCIA, VL_HONORARIO, VL_OPERACIONAL, VL_TOTAL, CD_IMPORT, VL_SH, VL_SD, QT_PONTOS, QT_PONTOS_ANEST, SN_ATIVO, NM_USUARIO, DT_ATIVACAO, CD_SEQ_INTEGRA, DT_INTEGRA)
values (484, '60023139', to_date('01-01-2022', 'dd-mm-yyyy'), 0.0100, 0.0100, 0.0100, null, null, null, null, null, 'S', null, null, null, null);

prompt Done.
