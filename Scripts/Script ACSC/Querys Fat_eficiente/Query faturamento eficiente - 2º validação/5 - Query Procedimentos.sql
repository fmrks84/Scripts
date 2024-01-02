---------------  PROCEDIMENTOS -----------------------
select 
id_atendimento,
id_conta,
codig_tabela,
COD_TUSS,
DS_TUSS,
dt_inicio,
dt_final,
qt_lancamento,
reducao_Acrescimo,
VL_UNITARIO,
(qt_lancamento * vl_unitario)VALOR_TOTAL,
VIA_ACESSO,
TECNICA_UTILIZADA,
id_profissional,
NM_profissional,
Grau_participacao,
TP_PAGAMENTO
from
(
select 
rf.cd_atendimento id_atendimento,
rf.cd_reg_fat id_conta,
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
                   'COD')COD_TUSS,
dbamv.fc_ovmd_tuss(rf.cd_multi_empresa,
                   irf.cd_pro_fat,
                    rf.cd_convenio,
                   'DESC')DS_TUSS,              
rf.dt_inicio,
rf.dt_final,
irf.qt_lancamento,
''reducao_Acrescimo , 
case when irf.cd_reg_fat = itprest.cd_reg_fat
  then itprest.vl_liquido
    else irf.vl_unitario
      end VL_UNITARIO,                 
irf.vl_total_conta valor_total,
'UNICA'VIA_ACESSO,
'CONVENCIONAL'TECNICA_UTILIZADA,
case when itprest.cd_reg_fat = irf.cd_reg_fat
  then itprest.cd_prestador
    else irf.cd_prestador
      end id_profissional,
(select prest1.nm_prestador from dbamv.prestador prest1 where prest1.cd_prestador = itprest.cd_prestador or irf.cd_prestador = prest1.cd_prestador)NM_PROFISSIONAL,
case 
when irf.cd_ati_med IN (07,15)then 'Clinico'
wheN irf.cd_ati_med IN (01)   then 'Cirurgião'
when irf.cd_ati_med IN (02,16)then 'Primeiro Auxiliar' 
when irf.cd_ati_med IN (03,17)then 'Segundo Auxiliar'
when irf.cd_ati_med IN (03,17)then 'Segundo Auxiliar'
when irf.cd_ati_med IN (04)then 'Terceiro Auxiliar'
when irf.cd_ati_med IN (09)then 'Instrumentador'     
when irf.cd_ati_med IN (06)then 'Anestesista' 
when irf.cd_ati_med IN (14)then 'Intensivista' 
when itprest.cd_ati_med IN (07,15)then 'Clinico'
wheN itprest.cd_ati_med IN (01)then 'Cirurgião'
when itprest.cd_ati_med IN (02,16)then 'Primeiro Auxiliar' 
when itprest.cd_ati_med IN (03,17)then 'Segundo Auxiliar'
when itprest.cd_ati_med IN (03,17)then 'Segundo Auxiliar'
when itprest.cd_ati_med IN (04)then 'Terceiro Auxiliar'
when itprest.cd_ati_med IN (09)then 'Instrumentador'     
when itprest.cd_ati_med IN (06)then 'Anestesista' 
when itprest.cd_ati_med IN (14)then 'Intensivista'   
end Grau_participacao ,
IRF.TP_PAGAMENTO||ITPREST.TP_PAGAMENTO TP_PAGAMENTO
from 
dbamv.reg_Fat rf
inner join dbamv.itreg_fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join dbamv.atendime atend on atend.cd_atendimento = rf.cd_atendimento
inner join dbamv.convenio conv on conv.cd_convenio = rf.cd_convenio
left join dbamv.tuss ts on ts.cd_pro_fat = irf.cd_pro_fat and ts.cd_multi_empresa = rf.cd_multi_empresa 
                                                          and ts.cd_convenio = rf.cd_convenio
inner join dbamv.gru_fat gf on gf.cd_gru_fat = irf.cd_gru_fat
inner join dbamv.pro_Fat pf on pf.cd_pro_fat = irf.cd_pro_fat
left join dbamv.tip_tuss tts on tts.cd_tip_tuss = ts.cd_tip_tuss
left join dbamv.prestador prest on prest.cd_prestador = irf.cd_prestador
left join dbamv.itlan_med itprest on itprest.cd_lancamento = irf.cd_lancamento and itprest.cd_reg_fat = irf.cd_reg_fat 
and ts.dt_fim_vigencia is null
where conv.tp_convenio = 'C'
and IRF.SN_PERTENCE_PACOTE = 'N'
and gf.cd_gru_fat in (6,7,11,14,16)
and rf.cd_atendimento  in (2370063,2370064)
)where TP_PAGAMENTO = 'P'

UNION ALL

select 
iramb.Cd_Atendimento id_atendimento,
ramb.cd_reg_amb id_conta,
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
                   'COD')COD_TUSS,
dbamv.fc_ovmd_tuss(ramb.cd_multi_empresa,
                   iramb.cd_pro_fat,
                    iramb.cd_convenio,
                   'DESC')DS_TUSS,
iramb.hr_lancamento dt_inicio,
iramb.hr_lancamento dt_final,
iramb.qt_lancamento,
''reducao_acrescimo,
nvl(iramb.vl_unitario,0)vl_unitario,
nvl(iramb.qt_lancamento * iramb.vl_unitario,0)vl_total_conta,
'UNICA'VIA_ACESSO,
'CONVENCIONAL'TECNICA_UTILIZADA,
iramb.CD_PRESTADOR ID_profissional,
prest1.nm_prestador nm_profissional,
case 
when iramb.cd_ati_med IN (07,15)then 'Clinico'
wheN iramb.cd_ati_med IN (01)then 'Cirurgião'
when iramb.cd_ati_med IN (02,16)then 'Primeiro Auxiliar' 
when iramb.cd_ati_med IN (03,17)then 'Segundo Auxiliar'
when iramb.cd_ati_med IN (03,17)then 'Segundo Auxiliar'
when iramb.cd_ati_med IN (04)then 'Terceiro Auxiliar'
when iramb.cd_ati_med IN (09)then 'Instrumentador'     
when iramb.cd_ati_med IN (06)then 'Anestesista' 
when iramb.cd_ati_med IN (14)then 'Intensivista' 
end Grau_Participacao,
iramb.tp_pagamento                   
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
left join dbamv.prestador prest1 on prest1.cd_prestador = iramb.cd_prestador
where conv1.tp_convenio = 'C'
and iramb.sn_pertence_pacote = 'N'
and gf1.cd_gru_fat in (6,7,11,14,16)
and iramb.Tp_Pagamento = 'P'
--and iramb.Cd_Atendimento  in (2370063,2370064)                                                
