insert into proibicao(,cd_pro_fat,cd_con_pla,cd_convenio,ds_proibicao,)
(SELECT seq_proibicao_idade.nextval,cd_multi_empresa,cd_Convenio,cd_con_pla,'40808041',40,69 FROM EMPRESA_CON_PLA WHERE CD_CONVENIO in (93,661,73,156,174,377,116,132,662,200,663,190) AND SN_ATIVO = 'S')



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


se

----- PROIBICAO POR IDADE

insert into proibicao_idade (cd_proibicao_idade,cd_multi_empresa,cd_convenio,cd_con_pla,cd_pro_fat,nr_idade_inicial,nr_idade_final)
(select seq_proibicao_idade.nextval,cd_multi_empresa,cd_convenio,cd_con_pla,'40808041','01','39' from empresa_con_pla where cd_multi_empresa = 4 and sn_Ativo = 'S')

insert into proibicao_idade (cd_proibicao_idade,cd_multi_empresa,cd_convenio,cd_con_pla,cd_pro_fat,nr_idade_inicial,nr_idade_final)
(select seq_proibicao_idade.nextval,cd_multi_empresa,cd_convenio,cd_con_pla,'40808041','70','200' from empresa_con_pla where cd_multi_empresa = 4 and sn_Ativo = 'S')

/*DELETE from proibicao_idade where cd_pro_fat = '40808041' 
AND  nr_idade_inicial = 01 and nr_idade_final = 39

SELECT * from proibicao_idade where cd_pro_fat = '40808041' 
AND  nr_idade_inicial = 70 and nr_idade_final = 200*/


select * from 

SELECT * FROM
 PROIBICAO A 
  where a.cd_pro_fat in ('40404161','28910192') and a.cd_convenio in(59,3,5,6,61,641,7,8,10,11,12,13,
14,15,60,983,16,17,18,19,20,23,24,25,29,30,32,33,34,35,38,39,55,56,57,41,42,44,9,45,43,46,47,48,49,50,
51,52,53,821,22)
--and a.cd_multi_empresa = 7
