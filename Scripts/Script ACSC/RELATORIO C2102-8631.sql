/*Basicamente, preciso saber o total de lançamentos em conta do Convênio Amil no HST, 
dos anos de 2019 e 2020, em Nº de Contas e Valor separado por sub-plano da operadora ("quebra por plano").
Solicito extração via banco, pois a geração para Excel nativa do sistema não puxa para a planilha os nomes dos sub-planos.*/

----  Visão Geral Conta Internado -----
SELECT ANO,
       'INTERNADO'TIPO_CONTA,     
       CD_CONVENIO,
       NM_CONVENIO,
       CD_CON_PLA,
       DS_CON_PLA,
       SUM(QT_CONTAS_PLANO)QT_CONTAS_PLANO,
       SUM(VALOR_TOTAL_CONTA_HOSPITALAR)TOTAL_GERAL_PLANO
       
FROM
(
select 
DISTINCT
TO_CHAR(IRF.DT_LANCAMENTO,'YYYY')ANO,
RF.CD_CONVENIO,
CONV.NM_CONVENIO,
RF.CD_CON_PLA,
CPLA.DS_CON_PLA,
RF.VL_TOTAL_CONTA VALOR_TOTAL_CONTA_HOSPITALAR,
CASE
  WHEN RF.CD_REG_FAT IS NOT NULL
    THEN 1
      ELSE 0
        END QT_CONTAS_PLANO
from 
dbamv.reg_Fat rf
inner join dbamv.itreg_Fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join dbamv.convenio conv on conv.cd_convenio = rf.cd_convenio
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio and cpla.cd_con_pla = rf.cd_con_pla
where rf.cd_convenio = 152
and to_char(irf.dt_lancamento,'YYYY') in &dt_lancamento
and rf.sn_fechada = 'S'
and rf.cd_remessa is not null
ORDER by RF.CD_CON_PLA
)GROUP BY 
ANO,
CD_CONVENIO,
NM_CONVENIO,
CD_CON_PLA,
DS_CON_PLA
ORDER BY CD_CON_PLA
;
 -- Visão Detalhada conta Internado  
select 
DISTINCT
rf.cd_reg_fat,
RF.CD_CONVENIO,
CONV.NM_CONVENIO,
RF.CD_CON_PLA,
CPLA.DS_CON_PLA,
(RF.VL_TOTAL_CONTA)VALOR_TOTAL_CONTA_HOSPITALAR,
CASE
  WHEN RF.CD_REG_FAT IS NOT NULL
    THEN 1
      ELSE 0
        END QT_CONTAS_PLANO
from 
dbamv.reg_Fat rf
inner join dbamv.itreg_Fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join dbamv.convenio conv on conv.cd_convenio = rf.cd_convenio
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio and cpla.cd_con_pla = rf.cd_con_pla
where rf.cd_convenio = 152
and to_char(irf.dt_lancamento,'YYYY') in &dt_lancamento
and rf.sn_fechada = 'S'
and rf.cd_remessa is not null
ORDER by RF.CD_CON_PLA
;

-------  VISÃO GERAL CONTA AMBULATORIAL ,URGENCIA,EXTERNO
SELECT ANO,
       TIPO_CONTA,     
       CD_CONVENIO,
       NM_CONVENIO,
       CD_CON_PLA,
       DS_CON_PLA,
       SUM(QT_CONTAS_PLANO)QT_CONTAS_PLANO,
       SUM(VALOR_TOTAL_CONTA_AMBULATORIAL)TOTAL_GERAL_PLANO
       
FROM
(
select 
DISTINCT
to_char(ramb.dt_lancamento,'YYYY')ANO,
CASE WHEN atend.tp_atendimento = 'A'
  THEN 'AMBULATORIO'
    WHEN atend.tp_atendimento = 'E'
      THEN 'EXTERNO'
        WHEN atend.tp_atendimento = 'U'
          THEN 'URGENCIA'
            END TIPO_CONTA,  
ramb.cd_reg_amb,
iramb.CD_CONVENIO,
CONV.NM_CONVENIO,
iramb.CD_CON_PLA,
CPLA.DS_CON_PLA,
ramb.VL_TOTAL_CONTA VALOR_TOTAL_CONTA_AMBULATORIAL,
CASE
  WHEN ramb.CD_REG_AMB IS NOT NULL
    THEN 1
      ELSE 0
        END QT_CONTAS_PLANO
from 
dbamv.reg_amb ramb
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.convenio conv on conv.cd_convenio = iramb.cd_convenio
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio and cpla.cd_con_pla = iramb.cd_con_pla
inner join dbamv.atendime  atend on atend.cd_atendimento = iramb.cd_atendimento
where iramb.cd_convenio = 152
and to_char(ramb.dt_lancamento,'YYYY') in &dt_lancamento
and iramb.sn_fechada = 'S'
and ramb.cd_remessa is not null
ORDER by iramb.CD_CON_PLA
)GROUP BY 
ANO,
TIPO_CONTA,
CD_CONVENIO,
NM_CONVENIO,
CD_CON_PLA,
DS_CON_PLA
ORDER BY CD_CON_PLA


; -- Detalhe conta ambulatorial 
select 
DISTINCT
ramb.cd_reg_amb,
iramb.CD_CONVENIO,
CONV.NM_CONVENIO,
iramb.CD_CON_PLA,
CPLA.DS_CON_PLA,
ramb.VL_TOTAL_CONTA VALOR_TOTAL_CONTA_AMBULATORIAL,
CASE
  WHEN ramb.CD_REG_AMB IS NOT NULL
    THEN 1
      ELSE 0
        END QT_CONTAS_PLANO
from 
dbamv.reg_amb ramb
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join dbamv.convenio conv on conv.cd_convenio = iramb.cd_convenio
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio and cpla.cd_con_pla = iramb.cd_con_pla
where iramb.cd_convenio = 152
and to_char(ramb.dt_lancamento,'YYYY') in &dt_lancamento
and iramb.sn_fechada = 'S'
and ramb.cd_remessa is not null
ORDER by iramb.CD_CON_PLA
