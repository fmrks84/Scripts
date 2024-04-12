prompt Importing table regra_proibicao_valor...
set feedback off
set define off

insert into regra_proibicao_valor (CD_REGRA_PROIBICAO_VALOR, CD_CONVENIO, CD_CON_PLA, CD_TAB_FAT, TP_TAB_FAT, TP_GRU_PRO, CD_GRU_PRO, DT_INICIAL_PROIBICAO, TP_PROIBICAO, TP_ATENDIMENTO, VL_BASE, SN_ATIVO, DT_REGISTRO, NM_USUARIO_REGISTROU, DT_DESATIVOU, NM_USUARIO_DESATIVOU)
values (86, 41, null, null, 'R', 'MT', null, to_date('01-07-2017', 'dd-mm-yyyy'), 'AG', 'T', 3000.0000, 'S', to_date('30-06-2017 17:10:25', 'dd-mm-yyyy hh24:mi:ss'), 'HPAULA', null, null);

insert into regra_proibicao_valor (CD_REGRA_PROIBICAO_VALOR, CD_CONVENIO, CD_CON_PLA, CD_TAB_FAT, TP_TAB_FAT, TP_GRU_PRO, CD_GRU_PRO, DT_INICIAL_PROIBICAO, TP_PROIBICAO, TP_ATENDIMENTO, VL_BASE, SN_ATIVO, DT_REGISTRO, NM_USUARIO_REGISTROU, DT_DESATIVOU, NM_USUARIO_DESATIVOU)
values (42, 41, null, null, 'R', 'OP', null, to_date('30-06-2017', 'dd-mm-yyyy'), 'AG', 'T', 0.0010, 'N', to_date('29-06-2017 12:16:39', 'dd-mm-yyyy hh24:mi:ss'), 'HPAULA', to_date('30-06-2017 17:10:53', 'dd-mm-yyyy hh24:mi:ss'), 'HPAULA');

insert into regra_proibicao_valor (CD_REGRA_PROIBICAO_VALOR, CD_CONVENIO, CD_CON_PLA, CD_TAB_FAT, TP_TAB_FAT, TP_GRU_PRO, CD_GRU_PRO, DT_INICIAL_PROIBICAO, TP_PROIBICAO, TP_ATENDIMENTO, VL_BASE, SN_ATIVO, DT_REGISTRO, NM_USUARIO_REGISTROU, DT_DESATIVOU, NM_USUARIO_DESATIVOU)
values (87, 41, null, null, 'R', 'OP', null, to_date('01-07-2017', 'dd-mm-yyyy'), 'AG', 'T', 3000.0000, 'S', to_date('30-06-2017 17:10:46', 'dd-mm-yyyy hh24:mi:ss'), 'HPAULA', null, null);

insert into regra_proibicao_valor (CD_REGRA_PROIBICAO_VALOR, CD_CONVENIO, CD_CON_PLA, CD_TAB_FAT, TP_TAB_FAT, TP_GRU_PRO, CD_GRU_PRO, DT_INICIAL_PROIBICAO, TP_PROIBICAO, TP_ATENDIMENTO, VL_BASE, SN_ATIVO, DT_REGISTRO, NM_USUARIO_REGISTROU, DT_DESATIVOU, NM_USUARIO_DESATIVOU)
values (270, 41, null, null, 'R', 'OP', null, to_date('01-03-2024', 'dd-mm-yyyy'), 'AG', 'T', 4000.0000, 'S', to_date('29-02-2024 16:14:02', 'dd-mm-yyyy hh24:mi:ss'), 'ACDEOLIVEIRA', null, null);

prompt Done.
