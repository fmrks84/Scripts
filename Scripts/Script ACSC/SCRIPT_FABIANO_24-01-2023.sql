select decode(r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC')casa, r.cd_atendimento, 
decode(a.tp_atendimento,'A','AMBULATORIAL','E','EXTERNO','I','INTERNACAO','U','URGENCIA')tp_atendimento,
r.cd_reg_Fat conta, c.nm_convenio, r.vl_total_conta ,   r.sn_fechada, r.dt_inicio, r.dt_final, f.dt_competencia, i.cd_pro_fat, p.ds_pro_fat, i.vl_unitario,i.qt_lancamento,i.vl_total_conta, g.ds_gru_pro
from reg_fat r, convenio c, atendime a, remessa_fatura rf, fatura f, pro_fat p, gru_pro g, itreg_fat i
where r.cd_convenio = c.cd_convenio
and   r.cd_atendimento = a.cd_atendimento
and   r.cd_reg_fat = i.cd_reg_fat
and   r.cd_remessa = rf.cd_remessa
and   rf.cd_Fatura = f.cd_fatura
and   i.cd_pro_fat = p.cd_pro_fat
and   p.cd_gru_pro = g.cd_gru_pro
and   c.tp_convenio in ('C','P')
and   r.cd_multi_empresa in (7)
and   i.sn_pertence_pacote = 'N'
--and   i.tp_pagamento = 'P'
and   f.dt_competencia between '01/07/2022' and '31/12/2022'
--and  i.cd_reg_fat = 314399

union all

select distinct decode(r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC')casa, i.cd_atendimento, 
decode(a.tp_atendimento,'A','AMBULATORIAL','E','EXTERNO','I','INTERNACAO','U','URGENCIA')tp_atendimento,
r.cd_reg_amb conta, c.nm_convenio, r.vl_total_conta, r.sn_fechada, r.dt_lancamento dt_inicio, r.dt_lancamento dt_final, f.dt_competencia, i.cd_pro_fat, p.ds_pro_fat,i.vl_unitario,i.qt_lancamento,i.vl_total_conta, g.ds_gru_pro
from reg_amb r, convenio c, atendime a, itreg_amb i, remessa_fatura rf, fatura f, pro_fat p, gru_pro g
where r.cd_convenio = c.cd_convenio
and   i.cd_atendimento = a.cd_atendimento
and   r.cd_reg_amb = i.cd_reg_amb
and   r.cd_remessa = rf.cd_remessa
and   rf.cd_Fatura = f.cd_fatura
and   i.cd_pro_fat = p.cd_pro_fat
and   p.cd_gru_pro = g.cd_gru_pro
and   i.sn_pertence_pacote = 'N'
--and   i.tp_pagamento = 'P'
and   c.tp_convenio in ('C','P')
and   r.cd_reg_amb = i.cd_reg_amb
and   r.cd_multi_empresa in (7)
and   f.dt_competencia between '01/07/2022' and '31/12/2022'
order by cd_atendimento, conta
