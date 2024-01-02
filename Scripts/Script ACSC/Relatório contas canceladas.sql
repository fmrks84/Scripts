select
Empresa,
cd_atendimento,
Conta,
nm_paciente,
cd_convenio,
nm_convenio,
Tp_atendimento,
ORIGEM_ATENDIMENTO,
dt_inicio,
dt_final,
dt_alta,
IDADE_CONTA,
Possui_OPME_S_N,
cd_pro_fat,
ds_pro_fat,
POSSUI_REPASSE,
motivo_cancel,
dt_cancelamento
from
(
select 
       decode(a.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC')Empresa,
       a.cd_atendimento,
       a.cd_reg_fat as Conta,
       c.nm_paciente as nm_paciente,
       a.cd_convenio as cd_convenio,
       g.nm_convenio as nm_convenio ,
       decode(b.tp_atendimento,'I','INTERNAÇÃO')Tp_atendimento,
       d.ds_ori_ate as ORIGEM_ATENDIMENTO,
       a.dt_inicio as dt_inicio,
       a.dt_final as dt_final,
       b.dt_alta as dt_alta,
       trunc((a.dt_final)-(a.dt_inicio)+1)IDADE_CONTA,
       case
         when e.cd_gru_fat = 5
           then 'SIM'
           else 'NÃO'
         END Possui_OPME_S_N   , 
       e.cd_pro_fat as cd_pro_fat,
       h.ds_pro_fat as ds_pro_fat,
       CASE 
         WHEN E.SN_REPASSADO IN ('X','N')
           THEN 'NÃO'
             ELSE 'SIM'
               END POSSUI_REPASSE,
         j.ds_justificativa as motivo_cancel,
         j.dh_log as dt_cancelamento
           
               
       
from dbamv.reg_fat a
inner join dbamv.atendime b on b.cd_atendimento = a.cd_atendimento 
inner join dbamv.paciente c on c.cd_paciente = b.cd_paciente 
inner join dbamv.ori_ate d on d.cd_ori_ate = b.cd_ori_ate
inner join dbamv.itreg_fat e on e.cd_reg_fat = a.cd_reg_fat 
inner join dbamv.gru_fat f on f.cd_gru_fat = e.cd_gru_fat
inner join dbamv.convenio g on g.cd_convenio = b.cd_convenio
inner join dbamv.pro_Fat h on h.cd_pro_fat = e.cd_pro_fat
inner join dbamv.log_conta_cancelada j on j.cd_reg_fat = a.cd_reg_fat
where  A.TP_CLASSIFICACAO_CONTA = 'O' 
and g.tp_Convenio = 'C'
/*order by a.cd_multi_empresa,
         a.cd_atendimento,
         h.ds_pro_fat*/
union all

select 
decode(c1.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC') empresa,
     c1.cd_atendimento  ,
     a1.cd_reg_amb as Conta,
     d1.nm_paciente as nm_paciente,
     g1.cd_convenio as cd_convenio,
     g1.nm_convenio  as nm_convenio,
     decode(c1.tp_atendimento,'U','URGENCIA','A','AMBULATORIAL','E','EXTERNO')Tp_atendimento,
     e1.ds_ori_ate as ORIGEM_ATENDIMENTO,
      b1.hr_lancamento  as dt_inicio,
      b1.hr_lancamento  as dt_final,
      c1.dt_alta  as dt_alta,
      trunc((b1.hr_lancamento) - (b1.hr_lancamento)+1)IDADE_CONTA,
       case
         when f1.cd_gru_fat = 5
           then 'SIM'
           else 'NÃO'
         END Possui_OPME_S_N,
      b1.cd_pro_fat as cd_pro_fat,
      h1.ds_pro_fat  as ds_pro_fat,
       CASE 
         WHEN b1.SN_REPASSADO IN ('X','N')
           THEN 'NÃO'
             ELSE 'SIM'
               END POSSUI_REPASSE,
       j1.ds_justificativa as motivo_cancel ,
        j1.dh_log as dt_cancelamento


from dbamv.reg_amb a1
inner join dbamv.itreg_amb b1 on b1.cd_reg_amb = a1.cd_reg_amb
inner join dbamv.atendime c1 on c1.cd_atendimento = b1.cd_atendimento-- c1.cd_atendimento = b1.cd_atendimento
inner join dbamv.paciente d1 on d1.cd_paciente = c1.cd_paciente
inner join dbamv.ori_ate e1 on e1.cd_ori_ate = c1.cd_ori_ate
inner join dbamv.gru_fat f1 on f1.cd_gru_fat = b1.cd_gru_fat
inner join dbamv.convenio g1 on g1.cd_convenio = c1.cd_convenio
inner join dbamv.Pro_Fat h1 on h1.cd_pro_fat = b1.cd_pro_fat
inner join dbamv.log_conta_cancelada j1 on j1.cd_reg_amb = a1.cd_reg_amb
where g1.tp_convenio = 'C'
)Order by EMPRESA,
          
