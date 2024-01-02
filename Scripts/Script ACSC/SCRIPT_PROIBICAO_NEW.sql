insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO,CD_MULTI_EMPRESA)
(select  ecpla.cd_con_pla,ecpla.cd_convenio,'40404161','NA','01/01/2021','A',ECPLA.CD_MULTI_EMPRESA from empresa_con_pla ecpla where ecpla.cd_convenio IN (59,3,5,6,61,641,7,8,10,11,12,13,
14,15,60,983,16,17,18,19,20,23,24,25,29,30,32,33,34,35,38,39,55,56,57,41,42,44,9,45,43,46,47,48,49,50,
51,52,53,821,22))

insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO,CD_MULTI_EMPRESA)
(select  ecpla.cd_con_pla,ecpla.cd_convenio,'40404161','NA','01/01/2021','E',ECPLA.CD_MULTI_EMPRESA from empresa_con_pla ecpla where ecpla.cd_convenio IN (59,3,5,6,61,641,7,8,10,11,12,13,
14,15,60,983,16,17,18,19,20,23,24,25,29,30,32,33,34,35,38,39,55,56,57,41,42,44,9,45,43,46,47,48,49,50,
51,52,53,821,22))

insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO,CD_MULTI_EMPRESA)
(select  ecpla.cd_con_pla,ecpla.cd_convenio,'40404161','NA','01/01/2021','I',ECPLA.CD_MULTI_EMPRESA from empresa_con_pla ecpla where ecpla.cd_convenio IN (59,3,5,6,61,641,7,8,10,11,12,13,
14,15,60,983,16,17,18,19,20,23,24,25,29,30,32,33,34,35,38,39,55,56,57,41,42,44,9,45,43,46,47,48,49,50,
51,52,53,821,22))

insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO,CD_MULTI_EMPRESA)
(select  ecpla.cd_con_pla,ecpla.cd_convenio,'40404161','NA','01/01/2021','U',ECPLA.CD_MULTI_EMPRESA from empresa_con_pla ecpla where ecpla.cd_convenio IN (59,3,5,6,61,641,7,8,10,11,12,13,
14,15,60,983,16,17,18,19,20,23,24,25,29,30,32,33,34,35,38,39,55,56,57,41,42,44,9,45,43,46,47,48,49,50,
51,52,53,821,22))

-------

insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO,CD_MULTI_EMPRESA)
(select  ecpla.cd_con_pla,ecpla.cd_convenio,'28910192','AG','01/01/2021','A',ECPLA.CD_MULTI_EMPRESA from empresa_con_pla ecpla where ecpla.cd_convenio IN (464,501))

insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO,CD_MULTI_EMPRESA)
(select  ecpla.cd_con_pla,ecpla.cd_convenio,'28910192','AG','01/01/2021','E',ECPLA.CD_MULTI_EMPRESA from empresa_con_pla ecpla where ecpla.cd_convenio IN (464,501))

insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO,CD_MULTI_EMPRESA)
(select  ecpla.cd_con_pla,ecpla.cd_convenio,'28910192','AG','01/01/2021','I',ECPLA.CD_MULTI_EMPRESA from empresa_con_pla ecpla where ecpla.cd_convenio IN (464,501))

insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO,CD_MULTI_EMPRESA)
(select  ecpla.cd_con_pla,ecpla.cd_convenio,'28910192','AG','01/01/2021','U',ECPLA.CD_MULTI_EMPRESA from empresa_con_pla ecpla where ecpla.cd_convenio IN (464,501))


SELECT * FROM PROIBICAO WHERE CD_PRO_FAT IN ('28910192') AND CD_CONVENIO IN (464,501) AND TP_aTENDIMENTO = 'U'
