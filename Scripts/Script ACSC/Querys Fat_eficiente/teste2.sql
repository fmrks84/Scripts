/*select 
rf.cd_atendimento id,
rf.cd_reg_fat idconta,
tts.cd_tip_tuss codigo_tabela,
dbamv.fc_ovmd_tuss(rf.cd_multi_empresa,
                   irf.cd_pro_fat,
                    rf.cd_convenio,
                   'COD')CD_TUSS,
dbamv.fc_ovmd_tuss(rf.cd_multi_empresa,
                   irf.cd_pro_fat,
                    rf.cd_convenio,
                   'DESC')DS_TUSS,        
gf.ds_gru_fat Codigo_Despesa,
pf.ds_unidade Unidade_Medida,       
rf.dt_inicio,
rf.dt_final,
irf.qt_lancamento,
''reducao_Acrescimo , 
irf.vl_unitario vl_unitario,
irf.vl_total_conta valor_total
                   
            --      *
from 
dbamv.reg_Fat rf
inner join dbamv.itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join dbamv.atendime atend on atend.cd_atendimento = rf.cd_atendimento
inner join dbamv.convenio conv on conv.cd_convenio = rf.cd_convenio
LEFT join dbamv.tuss ts on ts.cd_pro_fat = irf.cd_pro_fat and ts.cd_multi_empresa = rf.cd_multi_empresa 
                                                           and ts.cd_convenio = rf.cd_convenio
inner join dbamv.gru_fat gf on gf.cd_gru_fat = irf.cd_gru_fat
inner join dbamv.pro_Fat pf on pf.cd_pro_fat = irf.cd_pro_fat
inner join dbamv.tip_tuss tts on tts.cd_tip_tuss = ts.cd_tip_tuss
where conv.tp_convenio = 'C'
--and rf.cd_atendimento = 2385933--2541525--2588415,2541525
and irf.sn_pertence_pacote = 'N'




UNION ALL*/

select 
iramb.Cd_Atendimento id,
ramb.cd_reg_amb idconta,
tts1.cd_tip_tuss codigo_tabela,
dbamv.fc_ovmd_tuss(ramb.cd_multi_empresa,
                   iramb.cd_pro_fat,
                    iramb.cd_convenio,
                   'COD')CD_TUSS,
dbamv.fc_ovmd_tuss(ramb.cd_multi_empresa,
                   iramb.cd_pro_fat,
                    iramb.cd_convenio,
                   'DESC')DS_TUSS,
gf1.ds_gru_fat codigo_despesa,
pf1.ds_unidade unidade_medida,
iramb.hr_lancamento dt_inicio,
iramb.hr_lancamento dt_final,
iramb.qt_lancamento,
''reducao_acrescimo,
iramb.vl_unitario,
iramb.vl_total_conta                   


from 
dbamv.reg_amb ramb
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.atendime atend1 on atend1.cd_atendimento = iramb.Cd_Atendimento
inner join dbamv.convenio conv1 on conv1.cd_convenio = iramb.cd_convenio
left join dbamv.tuss ts1 on ts1.cd_pro_fat = iramb.cd_pro_fat and ts1.cd_multi_empresa = ramb.cd_multi_empresa
                                                              and ts1.Cd_Convenio = iramb.Cd_Convenio
inner join dbamv.gru_fat gf1 on gf1.cd_gru_fat = iramb.cd_gru_fat
inner join dbamv.pro_Fat pf1 on pf1.cd_pro_fat = iramb.cd_pro_fat   
inner join dbamv.tip_tuss tts1 on tts1.cd_tip_tuss = ts1.cd_tip_tuss
where conv1.tp_convenio = 'C'
and iramb.Cd_Atendimento = 2588455   
and iramb.sn_pertence_pacote = 'N'                                                  
