create or replace view ensemble.vw_despesa_conta_fatura_hospit as
select
rf.cd_atendimento id_Atendimento,
rf.cd_reg_fat id_conta,
irf.cd_lancamento id_lancamento,
'I' tp_conta,
case when tts.cd_tip_tuss = 18 then 'TUSS_TAXAS'
when tts.cd_tip_tuss = 19 then 'TUSS_MATERIAIS'
when tts.cd_tip_tuss = 20 then 'TUSS_MEDICAMENTOS'
when tts.cd_tip_tuss = 22 then 'TUSS_PROCEDIMENTOS'
when tts.cd_tip_tuss = 98 then 'PROPRIA_PACOTES'
when tts.cd_tip_tuss = 00 then 'PROPRIA_OPERADORAS'
when gf.cd_gru_fat in (1,2,3,13) then 'TUSS_TAXAS'
when gf.cd_gru_fat in (6,7,14) then 'TUSS_PROCEDIMENTOS'
when gf.cd_gru_fat in (4,5,9)then 'TUSS_MATERIAIS'
when gf.cd_gru_fat in (8)then 'TUSS_MEDICAMENTOS'
when gf.cd_gru_fat in (11,16) then 'PROPRIA_PACOTES' end codig_tabela,
dbamv.fc_acsc_tuss(rf.cd_multi_empresa,
                   irf.cd_pro_fat,
                    rf.cd_convenio,
                   'COD')COD_TUSS,
dbamv.fc_acsc_tuss(rf.cd_multi_empresa,
                   irf.cd_pro_fat,
                    rf.cd_convenio,
                   'DESC')DS_TUSS,
case when gf.ds_gru_fat in ('TAXAS','TAXA DE VIDEO')
     then 'TAXAS_E_ALUGUEIS'
     when gf.ds_gru_fat = 'GASES MEDICINAIS'
     then 'GASES_MEDICINAIS'
     when gf.ds_gru_fat in ('MATERIAIS DESCARTAVEIS','MATERIAIS ESPECIAIS (ME)')
     then 'MATERIAIS'
     when gf.ds_gru_fat = 'ORTESES E PROTESES(OP)'
     then 'OPME'
     else gf.ds_gru_fat
     end Codigo_Despesa,
pf.ds_unidade Unidade_Medida,
rf.dt_inicio,
rf.dt_final,
irf.qt_lancamento,
''reducao_Acrescimo ,
nvl(irf.vl_unitario,0) vl_unitario,
nvl(irf.vl_total_conta,0) valor_total,
irf.vl_percentual_multipla ValorPercPago -- solicitado inclusao 19-07-2021
from
dbamv.reg_Fat rf
left join dbamv.itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join dbamv.atendime atend on atend.cd_atendimento = rf.cd_atendimento
inner join ensemble.vw_convenio_faturamento conv on conv.cd_convenio = rf.cd_convenio
LEFT join dbamv.tuss ts on ts.cd_pro_fat = irf.cd_pro_fat and ts.cd_multi_empresa = rf.cd_multi_empresa
                                                           and ts.cd_convenio = rf.cd_convenio
inner join dbamv.gru_fat gf on gf.cd_gru_fat = irf.cd_gru_fat
inner join dbamv.pro_Fat pf on pf.cd_pro_fat = irf.cd_pro_fat
left join dbamv.tip_tuss tts on tts.cd_tip_tuss = ts.cd_tip_tuss
where ts.dt_fim_vigencia is null
and gf.cd_gru_fat in (1,2,3,13,4,5,9,8);
