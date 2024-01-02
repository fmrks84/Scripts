
/*select COUNT (*),
       A.CD_PRO_FAT,
       A.TP_PROIBICAO,
       A.TP_ATENDIMENTO from proibicao a where a.cd_multi_empresa = 11 and a.cd_pro_fat in 
(select cd_pro_fat from pro_Fat where sn_ativo = 'S' AND cd_gru_pro in 
(select cd_gru_pro from gru_pro
where tp_gru_pro in ('SP','SD','OP')  ))
--AND A.CD_PRO_FAT = '20102135'
GROUP BY 
 A.CD_PRO_FAT,
       A.TP_PROIBICAO,
       A.TP_ATENDIMENTO*/

/*insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO, 
CD_MULTI_EMPRESA)(SELECT CD_CON_PLA, CD_CONVENIO,'02040478','FC',to_date('01/01/2022','dd/mm/yyyy'),'A',4 FROM EMPRESA_CON_PLA WHERE CD_CONVENIO = 154 AND SN_ATIVO = 'S')

*/

/*insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO,
CD_MULTI_EMPRESA)(SELECT CD_CON_PLA,CD_CONVENIO,(select ''cd_pro_fat from pro_Fat where sn_ativo = 'S' AND cd_gru_pro in ()
)),'AG',to_date('01/10/2022','dd/mm/yyyy'),'A',CD_MULTI_EMPRESA FROM EMPRESA_CON_PLA 
WHERE CD_MULTI_EMPRESA = 11  AND SN_ATIVO = 'S' AND CD_CONVENIO IN SELECT CD_CONVENIO FROM CONVENIO WHERE TP_CONVENIO = 'C'));
commit*/
/*;
insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO, 
CD_MULTI_EMPRESA)(SELECT CD_CON_PLA, CD_CONVENIO,(select cd_pro_fat from pro_Fat where sn_ativo = 'S' AND cd_gru_pro in
(select cd_gru_pro from gru_pro
where tp_gru_pro in ('SP','SD','OP'))),'AG',to_date('01/10/2022','dd/mm/yyyy'),'E',CD_MULTI_EMPRESA FROM EMPRESA_CON_PLA 
WHERE CD_MULTI_EMPRESA = 11  AND SN_ATIVO = 'S' AND CD_CONVENIO IN 
(SELECT CD_CONVENIO FROM CONVENIO WHERE TP_CONVENIO = 'C'));
commit
;
insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO, 
CD_MULTI_EMPRESA)(SELECT CD_CON_PLA, CD_CONVENIO,(select cd_pro_fat from pro_Fat where sn_ativo = 'S' AND cd_gru_pro in
(select cd_gru_pro from gru_pro
where tp_gru_pro in ('SP','SD','OP'))),'AG',to_date('01/10/2022','dd/mm/yyyy'),'I',CD_MULTI_EMPRESA FROM EMPRESA_CON_PLA
WHERE CD_MULTI_EMPRESA = 11  AND SN_ATIVO = 'S' AND CD_CONVENIO IN 
(SELECT CD_CONVENIO FROM CONVENIO WHERE TP_CONVENIO = 'C'));
commit
;
insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO, 
CD_MULTI_EMPRESA)(SELECT CD_CON_PLA, CD_CONVENIO,(select cd_pro_fat from pro_Fat where sn_ativo = 'S' AND cd_gru_pro in
(select cd_gru_pro from gru_pro
where tp_gru_pro in ('SP','SD','OP'))),'AG',to_date('01/10/2022','dd/mm/yyyy'),'U',CD_MULTI_EMPRESA FROM EMPRESA_CON_PLA 
WHERE CD_MULTI_EMPRESA = 11  AND SN_ATIVO = 'S' AND CD_CONVENIO IN 
(SELECT CD_CONVENIO FROM CONVENIO WHERE TP_CONVENIO = 'C'));
commit*/

/*(select cd_pro_fat from pro_Fat where sn_ativo = 'S' AND cd_gru_pro in
(select cd_gru_pro from gru_pro
where tp_gru_pro in ('SP','SD','OP')))


delete FROM DBAMV.PROIBICAO WHERE CD_PRO_FAT in (select cd_pro_fat from pro_Fat where sn_ativo = 'S' AND cd_gru_pro in
(select cd_gru_pro from gru_pro
where tp_gru_pro in ('SP','SD','OP')))AND CD_MULTI_EMPRESA = 11*/
