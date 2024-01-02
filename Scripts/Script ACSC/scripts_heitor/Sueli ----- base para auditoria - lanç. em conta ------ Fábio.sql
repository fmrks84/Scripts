select empresa,
       Tipo_atendimento,
       cd_atendimento,
       conta,
       nm_convenio,
       ds_plano,
       cd_pro_fat,
       ds_pro_fat,
       qt_lancamento,
       vl_unitario,
       vl_total,
       dt_Lancamento

from
(
select decode(r.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC') empresa,
 decode(a1.tp_atendimento,'I','Internado')Tipo_atendimento,r.cd_atendimento, r.cd_reg_fat conta, c.nm_convenio, p.ds_con_pla ds_plano, i.cd_pro_fat, pf.ds_pro_fat, i.qt_lancamento,
i.vl_unitario, i.vl_total_conta vl_total, i.dt_Lancamento
from reg_Fat r, convenio c, con_pla p, pro_fat pf, gru_pro g, itreg_fat i , atendime a1
where r.cd_convenio = c.cd_convenio
and r.cd_Convenio = p.cd_convenio
and r.cd_con_pla = p.cd_con_pla
and i.cd_pro_fat = pf.cd_pro_fat
and pf.cd_gru_pro = g.cd_gru_pro
and r.cd_reg_fat = i.cd_reg_fat
and a1.cd_atendimento = r.cd_atendimento
and r.cd_multi_empresa in (10,7)
and i.cd_pro_Fat in ('90358449','60023406')
and i.dt_lancamento between '01/01/2020' and '30/09/2020'
and i.sn_pertence_pacote = 'N'
and a1.cd_atendimento = 2040278

union all

select decode(r.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC') empresa,
decode(a2.tp_atendimento,'A','Ambulatorial', 'U','Urgência','E','Externo')Tipo_atendimento,
i.cd_atendimento, r.cd_reg_amb conta, c.nm_convenio, p.ds_con_pla ds_plano, i.cd_pro_fat, pf.ds_pro_fat, i.qt_lancamento,
i.vl_unitario, i.vl_total_conta vl_total, i.hr_Lancamento dt_lancamento
from reg_amb r, convenio c, con_pla p, pro_fat pf, gru_pro g, itreg_amb i, atendime a2
where r.cd_convenio = c.cd_convenio
and a2.cd_atendimento = i.cd_atendimento
and i.cd_Convenio = p.cd_convenio
and i.cd_con_pla = p.cd_con_pla
and i.cd_pro_fat = pf.cd_pro_fat
and pf.cd_gru_pro = g.cd_gru_pro
and r.cd_reg_amb = i.cd_reg_amb
and r.cd_multi_empresa in (10,7)
and i.cd_pro_Fat in ('90358449','60023406')
and i.hr_lancamento between '01/01/2020' and '30/09/2020'
and i.sn_pertence_pacote = 'N'
)
