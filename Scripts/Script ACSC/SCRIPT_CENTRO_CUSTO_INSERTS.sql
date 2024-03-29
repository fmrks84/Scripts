--10001662

/*insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21412,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921)--02037628


select * from pacote where cd_pro_Fat_pacote = 10001662


*/

/*insert into dbamv.pacote (,
select * from pacote pc where pc.cd_pro_fat = 02037628 and pc.dt_vigencia_final is null
and pc.cd_convenio = 40
order by pc.cd_pro_fat_pacote

*/
insert into pacote x (x.cd_pacote,
                             x.cd_multi_empresa,
                             x.cd_convenio,
                             x.cd_con_pla,
                             x.cd_pro_fat,
                             x.cd_pro_fat_pacote,
                             x.dt_vigencia,
                             x.cd_tip_acom,
                             x.cd_setor,
                             x.tp_atendimento,
                             x.qt_diarias,
                             x.vl_perc_pac_secund,
                             x.tp_extra,
                             x.sn_guia,
                             x.qt_parcelas,
                             x.sn_automatico,
                             x.ds_observacao,
                             x.dt_vigencia_final,
                             x.nr_idade_maxima,
                             x.tp_cobranca_pac_secund,
                             x.vl_perc_pac_secund_2,
                             x.vl_perc_pac_secund_3,
                             x.vl_perc_pac_secund_4,
                             x.cd_tipo_internacao,
                             x.sn_valida_autorizacao,
                             x.sn_day_clinic,
                             x.vl_perc_acres_gemelares,
                             x.vl_perc_desc_rn_uti,
                             x.sn_considera_hora,
                             x.sn_protocolo_de_pacote,
                             x.nr_imc_inicial,
                             x.nr_imc_final,
                             x.sn_obito,
                             x.sn_gemelar,
                             x.sn_diaria_gabarito,
                             x.tp_dispercao,
                             x.sn_nao_intervencionista,
                             x.sn_lanca_no_fechamento,
                             x.sn_pacote_pro_fat,
                             x.sn_profat_descaracteriza,
                             x.sn_proc_fora_pacote)
(select --seq_pacote.nextval,
        pc.cd_pacote,
        pc.cd_multi_empresa,
        pc.cd_convenio,
        pc.cd_con_pla,
        '71000001',
        pc.cd_pro_fat_pacote,
        pc.dt_vigencia,
        pc.cd_tip_acom,
        pc.cd_setor,
        pc.tp_atendimento,
        pc.qt_diarias,
        pc.vl_perc_pac_secund,
        pc.tp_extra,
        pc.sn_guia,
        pc.qt_parcelas,
        pc.sn_automatico,
        pc.ds_observacao,
        pc.dt_vigencia_final,
        pc.nr_idade_maxima,
        pc.tp_cobranca_pac_secund,
        pc.vl_perc_pac_secund_2,
        pc.vl_perc_pac_secund_3,
        pc.vl_perc_pac_secund_4,
        pc.cd_tipo_internacao,
        pc.sn_valida_autorizacao,
        pc.sn_day_clinic,
        pc.vl_perc_acres_gemelares,
        pc.vl_perc_desc_rn_uti,
        pc.sn_considera_hora,
        pc.sn_protocolo_de_pacote,
        pc.nr_imc_inicial,
        pc.nr_imc_final,
        pc.sn_obito,
        pc.sn_gemelar,
        pc.sn_diaria_gabarito,
        pc.tp_dispercao,
        pc.sn_nao_intervencionista,
        pc.sn_lanca_no_fechamento,
        pc.sn_pacote_pro_fat,
        pc.sn_profat_descaracteriza,
        pc.sn_proc_fora_pacote 
from pacote pc 
where pc.cd_pro_fat = '02037636' 
--and pc.dt_vigencia_final is null
and pc.cd_convenio = 40);
COMMIT;

--order by pc.cd_pro_fat_pacote      ;

                   
/*insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21412,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921);--02037628
*/

/*insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21425,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921);
insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21426,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921);
insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21427,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921);
insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21429,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921);
insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21430,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921);
insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21431,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921);
insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21432,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921);
insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21433,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921);
insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21434,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921);
insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21435,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921);
insert into pacote_excecao (cd_pacote_excecao,cd_pacote,cd_gru_pro,cd_pro_fat,cd_Setor,cd_tip_acom)
(select seq_pacote_excecao.nextval,21436,cd_gru_pro,cd_pro_Fat,cd_setor,cd_tip_Acom from pacote_excecao x where x.cd_pacote = 10921);
commit;
*/


select *
from 
pacote pc --set pc.vl_perc_pac_secund_2 = 100.00, pc.vl_perc_pac_secund_3 = 100.00 , pc.vl_perc_pac_secund_4 = 100.00
where pc.cd_pro_fat = '02037636' 
and pc.dt_vigencia_final is null
and pc.cd_convenio = 40 
--order by pc.cd_pro_fat_pacote  


71000001 - TAXA DE CIRURGIA ROBOTICA
SELECT * FROM GRU_PRO GP WHERE GP.CD_GRU_PRO IN (2,71) --FOR UPDATE 
