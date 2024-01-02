SELECT * FROM  ENSEMBLE.VW_ATENDIMENTO_FATURAMENTO B WHERE B.cd_atendimento in (2370063,2370064);
SELECT * FROM  ensemble.VW_AUTORIZACAO_FATURAMENTO A WHERE a.cd_atendimento in (2370063,2370064);

select
distinct
rf.cd_reg_fat ID_CONTA,
guia.nr_guia numero_guia_prestador,
case when guia.tp_guia = 'I' then 'INTERNACAO' 
    when guia.tp_guia = 'S' then 'SADT'
    when guia.tp_guia = 'O' then 'OPME'
    when guia.tp_guia = 'P' then 'PROCEDIMENTO'
end tipo_Guia,
rf.cd_multi_empresa id_prestador,
emp.ds_multi_empresa nome_prestador,
rf.cd_convenio id_operadora,
conv.nm_convenio nome_operadora,
econv.cd_hospital_no_convenio Codigo_Prestadora_Operadora,
rf.cd_atendimento id_atendimento,
guia.cd_guia id_autorizacao,
case when rf.tp_classificacao_conta = 'P'
     then 'PARCIAL'
     when rf.tp_classificacao_conta = 'C'    
     then 'COMPLEMENTAR'
     when rf.tp_classificacao_conta = 'N'    
     then 'TOTAL'
END Tipo_Faturamento,
''Sequencial_parcial,
rf.dt_inicio Data_Abertura,
rf.dt_fechamento Data_fechamento,
decode (rf.sn_fechada,'S','TRUE','N','FALSE')FECHADA, 
rf.cd_remessa id_remessa ,
''id_lote,
''DataCadastro,
''ResponsavelCadastro ,  
''DataAtualizacao,
''ResponsavelAtualizacao 
from
dbamv.reg_Fat rf 
left join dbamv.itreg_Fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join dbamv.multi_empresas emp on emp.cd_multi_empresa = rf.cd_multi_empresa
inner join dbamv.atendime atend on atend.cd_atendimento = rf.cd_atendimento
inner join dbamv.guia guia on guia.cd_atendimento = atend.cd_atendimento 
left join dbamv.it_guia iguia on iguia.cd_guia = guia.cd_guia and guia.cd_guia = irf.cd_guia 
inner join dbamv.empresa_convenio econv on econv.cd_convenio = rf.cd_convenio and econv.cd_multi_empresa = rf.cd_multi_empresa
inner join dbamv.convenio conv on conv.cd_convenio = econv.cd_convenio 
where atend.cd_atendimento in (2370063,2370064)  
----------
union all
----------
select 
distinct 
ramb.cd_reg_amb id_Conta,
guia1.nr_guia numero_guia_prestador,
case when guia1.tp_guia = 'I' then 'INTERNACAO' 
    when guia1.tp_guia = 'S' then 'SADT'
    when guia1.tp_guia = 'O' then 'OPME'
    when guia1.tp_guia = 'P' then 'PROCEDIMENTO'
end tipo_Guia,
ramb.cd_multi_empresa id_prestador,
emp1.ds_multi_empresa nome_prestador,
iramb.cd_convenio id_operadora,
conv1.nm_convenio nome_operadora,
econv1.cd_hospital_no_convenio Codigo_Prestadora_Operadora,
iramb.cd_atendimento id_atendimento,
guia1.cd_guia id_autorizacao,
'TOTAL'Tipo_Faturamento,
''Sequencial_parcial,
atend1.hr_atendimento Data_Abertura,
iramb.dt_fechamento Data_fechamento,
decode (iramb.sn_fechada,'S','TRUE','N','FALSE')FECHADA, 
ramb.cd_remessa id_remessa,
''id_lote,
''Data_Cadastro,
''Responsavel_Cadastro ,  
''Data_Atualizacao,
''Responsavel_Atualizacao 
from
dbamv.reg_amb ramb 
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.multi_empresas emp1 on emp1.cd_multi_empresa = ramb.cd_multi_empresa
inner join dbamv.atendime atend1 on atend1.cd_atendimento = iramb.cd_atendimento
inner join dbamv.guia guia1 on guia1.cd_atendimento = atend1.cd_atendimento 
left join dbamv.it_guia iguia1 on iguia1.cd_guia = guia1.cd_guia and guia1.cd_guia = iramb.cd_guia 
inner join dbamv.empresa_convenio econv1 on econv1.cd_convenio = iramb.cd_convenio and econv1.cd_multi_empresa = ramb.cd_multi_empresa
inner join dbamv.convenio conv1 on conv1.cd_convenio = econv1.cd_convenio
where iramb.cd_atendimento in (2370063,2370064)


;
select 
rf.cd_atendimento id,
rf.cd_reg_fat idconta,
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
dbamv.fc_ovmd_tuss(rf.cd_multi_empresa,
                   irf.cd_pro_fat,
                    rf.cd_convenio,
                   'COD')CD_TUSS,
dbamv.fc_ovmd_tuss(rf.cd_multi_empresa,
                   irf.cd_pro_fat,
                    rf.cd_convenio,
                   'DESC')DS_TUSS,                     
--irf.cd_pro_fat,                          
gf.ds_gru_fat Codigo_Despesa,
pf.ds_unidade Unidade_Medida,       
rf.dt_inicio,
rf.dt_final,
irf.qt_lancamento,
''reducao_Acrescimo , 
irf.vl_unitario vl_unitario,
irf.vl_total_conta valor_total
--irf.sn_pertence_pacote,
--irf.cd_lancamento                               
            
from 
dbamv.reg_Fat rf
left join dbamv.itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join dbamv.atendime atend on atend.cd_atendimento = rf.cd_atendimento
inner join dbamv.convenio conv on conv.cd_convenio = rf.cd_convenio
LEFT join dbamv.tuss ts on ts.cd_pro_fat = irf.cd_pro_fat and ts.cd_multi_empresa = rf.cd_multi_empresa 
                                                           and ts.cd_convenio = rf.cd_convenio
inner join dbamv.gru_fat gf on gf.cd_gru_fat = irf.cd_gru_fat
inner join dbamv.pro_Fat pf on pf.cd_pro_fat = irf.cd_pro_fat
left join dbamv.tip_tuss tts on tts.cd_tip_tuss = ts.cd_tip_tuss
where conv.tp_convenio = 'C'
and ts.dt_fim_vigencia is null
and rf.cd_atendimento in (2370063,2370064)  

----------
union all
------------
select 
iramb.Cd_Atendimento id,
ramb.cd_reg_amb idconta,
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
--iramb.sn_pertence_pacote,
--iramb.cd_lancamento,
from 
dbamv.reg_amb ramb
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.atendime atend1 on atend1.cd_atendimento = iramb.Cd_Atendimento
inner join dbamv.convenio conv1 on conv1.cd_convenio = iramb.cd_convenio
left join dbamv.tuss ts1 on ts1.cd_pro_fat = iramb.cd_pro_fat and ts1.cd_multi_empresa = ramb.cd_multi_empresa
                                                              and ts1.Cd_Convenio = iramb.Cd_Convenio
inner join dbamv.gru_fat gf1 on gf1.cd_gru_fat = iramb.cd_gru_fat
inner join dbamv.pro_Fat pf1 on pf1.cd_pro_fat = iramb.cd_pro_fat   
left join dbamv.tip_tuss tts1 on tts1.cd_tip_tuss = ts1.cd_tip_tuss
where conv1.tp_convenio = 'C'
and ts1.dt_fim_vigencia is null
and iramb.Cd_Atendimento in (2370063,2370064)  
--and iramb.sn_pertence_pacote = 'N' 
