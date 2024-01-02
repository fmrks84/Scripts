create or replace view ensemble.vw_despesa_conta_fatura_ambul
(id_atendimento, id_conta, id_lancamento, tp_conta, codig_tabela, cod_tuss, ds_tuss, codigo_despesa, unidade_medida, dt_inicio, dt_final, qt_lancamento, reducao_acrescimo, vl_unitario, valor_total,vl_perc_pago)
as
select
iramb.Cd_Atendimento id_atendimento,
ramb.cd_reg_amb id_conta,
iramb.cd_lancamento id_lancamento,
'A' tp_conta,
case when tts1.cd_tip_tuss = 18 then 'TUSS_TAXAS'
     when tts1.cd_tip_tuss = 19 then 'TUSS_MATERIAIS'
     when tts1.cd_tip_tuss = 20 then 'TUSS_MEDICAMENTOS'
     when tts1.cd_tip_tuss = 22 then 'TUSS_PROCEDIMENTOS'
     when tts1.cd_tip_tuss = 98 then 'PROPRIA_PACOTES'
     when tts1.cd_tip_tuss = 00 then 'PROPRIA_OPERADORAS'
     when gf1.cd_gru_fat in (1,2,3,13) then 'TUSS_TAXAS'
     when gf1.cd_gru_fat in (6,7,14) then 'TUSS_PROCEDIMENTOS'
     when gf1.cd_gru_fat in (4,5,9)then 'TUSS_MATERIAIS'
     when gf1.cd_gru_fat in (8)then 'TUSS_MEDICAMENTOS'
     when gf1.cd_gru_fat in (11,16) then 'PROPRIA_PACOTES'
     end codig_tabela,
dbamv.fc_acsc_tuss(ramb.cd_multi_empresa,
                   iramb.cd_pro_fat,
                    iramb.cd_convenio,
                   'COD')COD_TUSS,
dbamv.fc_acsc_tuss(ramb.cd_multi_empresa,
                   iramb.cd_pro_fat,
                    iramb.cd_convenio,
                   'DESC')DS_TUSS,
case when gf1.ds_gru_fat in ('TAXAS','TAXA DE VIDEO')
     then 'TAXAS_E_ALUGUEIS'
     when gf1.ds_gru_fat = 'GASES MEDICINAIS'
     then 'GASES_MEDICINAIS'
     when gf1.ds_gru_fat in ('MATERIAIS DESCARTAVEIS','MATERIAIS ESPECIAIS (ME)')
     then 'MATERIAIS'
     when gf1.ds_gru_fat = 'ORTESES E PROTESES(OP)'
     then 'OPME'
     else gf1.ds_gru_fat
     end Codigo_Despesa,
pf1.ds_unidade unidade_medida,
iramb.hr_lancamento dt_inicio,
iramb.hr_lancamento dt_final,
iramb.qt_lancamento,
''reducao_acrescimo,
nvl(iramb.vl_unitario,0)vl_unitario,
nvl(iramb.vl_total_conta,0)vl_total_conta,
iramb.vl_percentual_multipla ValorPercPago -- incluido 19-07-2021
from
dbamv.reg_amb ramb
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.atendime atend1 on atend1.cd_atendimento = iramb.Cd_Atendimento
inner join ensemble.vw_convenio_faturamento conv1 on conv1.cd_convenio = iramb.cd_convenio
left join dbamv.tuss ts1 on ts1.cd_pro_fat = iramb.cd_pro_fat and ts1.cd_multi_empresa = ramb.cd_multi_empresa
                                                              and ts1.Cd_Convenio = iramb.Cd_Convenio
inner join dbamv.gru_fat gf1 on gf1.cd_gru_fat = iramb.cd_gru_fat
inner join dbamv.pro_Fat pf1 on pf1.cd_pro_fat = iramb.cd_pro_fat
left join dbamv.tip_tuss tts1 on tts1.cd_tip_tuss = ts1.cd_tip_tuss
where ts1.dt_fim_vigencia is null
and gf1.cd_gru_fat in (1,2,3,13,4,5,9,8);
