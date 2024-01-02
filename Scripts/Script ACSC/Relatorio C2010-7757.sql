SELECT 
TIPO_ATENDIMENTO,
cd_atendimento,
/*nm_paciente,
Nm_Responsavel,
Nr_Fone,
cd_tip_paren,
ds_tip_paren,
nr_cep,
ds_endereco,
Nr_Endereco,
ds_complemento,
nm_bairro,
cd_cidade,
nm_cidade,
ds_documento,
nr_cpf,*/
CONTA,
CD_CONVENIO,
DS_GRU_FAT,
CD_LANCAMENTO,
CD_PRO_FAT,
DS_PRO_FAT,
DT_LANCAMENTO,
QT_LANCAMENTO,
VL_UNITARIO,
VL_TOTAL_CONTA,
vl_percentual_Faturado,
cd_prestador,
nm_prestador,
cd_prestador_repasse,
prestador_repasse,
COMP_MES
FROM 
(
select 
       decode(atend.tp_atendimento,'I','INTERNADO')TIPO_ATENDIMENTO,
       rf.cd_atendimento cd_atendimento,
       /*pct.nm_paciente,
       resp_Atend.Nm_Responsavel,
       resp_Atend.Nr_Fone,
       resp_atend.cd_tip_paren,
       par.ds_tip_paren,
       resp_atend.nr_cep,
       resp_atend.ds_endereco,
       resp_Atend.Nr_Endereco,
       resp_atend.ds_complemento,
       resp_atend.nm_bairro,
       resp_atend.cd_cidade,
       cid.nm_cidade,
       resp_atend.ds_documento,
       resp_atend.nr_cpf,*/
       rf.cd_reg_fat CONTA,
       rf.cd_convenio cd_convenio,
       gf.ds_gru_fat ds_gru_fat,
       irf.cd_lancamento cd_lancamento,
       pf.cd_pro_fat cd_pro_fat,
       pf.ds_pro_fat ds_pro_fat,
       trunc(irf.dt_lancamento)dt_lancamento,
       irf.qt_lancamento qt_lancamento,
       irf.vl_unitario vl_unitario,
       irf.vl_total_conta vl_total_conta,
       irf.vl_percentual_multipla vl_percentual_Faturado,
       irf.cd_prestador cd_prestador,
       med.nm_prestador nm_prestador,
       med.cd_prestador_repasse cd_prestador_repasse,
       (select x.nm_prestador from  prestador x  where x.cd_prestador = med.cd_prestador_repasse)prestador_repasse,
       to_char(irf.dt_lancamento,'MM/YYYY')COMP_MES
       
        
from 
dbamv.pro_Fat pf
inner join dbamv.gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro 
inner join dbamv.gru_Fat gf on gf.cd_gru_fat = gp.cd_gru_fat 
inner join itreg_fat irf on irf.cd_pro_fat = pf.cd_pro_fat 
inner join reg_Fat rf on rf.cd_reg_fat = irf.cd_reg_fat
inner join atendime atend on atend.cd_atendimento = rf.cd_atendimento
inner join paciente pct on pct.cd_paciente = atend.cd_paciente
--inner join responsa resp_atend on resp_atend.cd_atendimento = atend.cd_atendimento
--inner join tip_paren par on par.cd_tip_paren = resp_atend.cd_tip_paren
---inner join cidade cid on cid.cd_cidade = resp_atend.cd_cidade 
inner join prestador med on med.cd_prestador = irf.cd_prestador
inner join it_repasse itrep on itrep.cd_reg_fat = irf.cd_reg_fat and itrep.cd_lancamento_fat = irf.cd_lancamento
where trunc(irf.dt_lancamento) between '01/06/2020' and '31/08/2020'
and gf.cd_gru_fat = 6--EXAMES E DIAGNOSTICOS
and rf.cd_multi_empresa = 4
and rf.cd_convenio in (152)
and pf.sn_ativo = 'S'
and irf.vl_base_repassado not in (0,00)
and med.cd_prestador_repasse = 18590

         
UNION ALL

select 
decode (atend.tp_atendimento,'A','AMBULATORIO','U','AMBULATORIO','E','AMBULATORIO')TIPO_ATENDIMENTO,
iramb.cd_atendimento cd_atendimento,
/*pct1.nm_paciente,
resp_Atend1.Nm_Responsavel,
resp_Atend1.Nr_Fone,
resp_atend1.cd_tip_paren,
par1.ds_tip_paren,
resp_atend1.nr_cep,
resp_atend1.ds_endereco,
resp_Atend1.Nr_Endereco,
resp_atend1.ds_complemento,
resp_atend1.nm_bairro,
resp_atend1.cd_cidade,
cid1.nm_cidade,
resp_atend1.ds_documento,
resp_atend1.nr_cpf,*/
iramb.cd_reg_amb CONTA,
ramb.cd_convenio cd_convenio,
gf.ds_gru_fat ds_gru_fat,
iramb.cd_lancamento cd_lancamento,
pf1.cd_pro_fat cd_pro_fat,
pf1.ds_pro_fat ds_pro_fat,
trunc(iramb.hr_lancamento)dt_lancamento,
iramb.qt_lancamento qt_lancamento,
iramb.vl_unitario vl_unitario,
iramb.vl_total_conta vl_total_conta,
iramb.vl_percentual_multipla vl_percentual_Faturado,
iramb.cd_prestador cd_prestador,
med1.nm_prestador nm_prestador,
MED1.CD_PRESTADOR_REPASSE CD_PRESTADOR_REPASSE,
(select x1.nm_prestador from  prestador x1  where x1.cd_prestador = med1.cd_prestador_repasse)prestador_repasse,
 to_char(iramb.hr_lancamento,'MM/YYYY')COMP_MES

from
dbamv.pro_Fat pf1
inner join dbamv.gru_pro gp on gp.cd_gru_pro = pf1.cd_gru_pro 
inner join dbamv.gru_Fat gf on gf.cd_gru_fat = gp.cd_gru_fat 
inner join itreg_amb iramb on iramb.cd_pro_fat = pf1.cd_pro_fat 
inner join reg_amb ramb on ramb.cd_reg_amb = iramb.cd_reg_amb
inner join atendime atend on atend.cd_atendimento = iramb.cd_atendimento
inner join paciente pct1 on pct1.cd_paciente = atend.cd_paciente
--inner join responsa resp_atend1 on resp_atend1.cd_atendimento = atend.cd_atendimento
--inner join tip_paren par1 on par1.cd_tip_paren = resp_atend1.cd_tip_paren
--inner join cidade cid1 on cid1.cd_cidade = resp_atend1.cd_cidade 
inner join prestador med1 on med1.cd_prestador = iramb.cd_prestador
inner join it_repasse itrep on itrep.cd_reg_amb = iramb.cd_reg_amb and itrep.cd_lancamento_amb = iramb.cd_lancamento
where trunc(iramb.hr_lancamento) between '01/06/2020' and '31/08/2020'
and gf.cd_gru_fat = 6--EXAMES E DIAGNOSTICOS
and ramb.cd_multi_empresa = 4
and ramb.cd_convenio in (152)
and pf1.sn_ativo = 'S'
and iramb.vl_base_repassado not in (0,00)
and med1.cd_prestador_repasse = 18590
)
ORDER BY CD_ATENDIMENTO,
         COMP_MES
