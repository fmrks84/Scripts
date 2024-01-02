select decode (r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
'Internado', r.cd_atendimento, r.cd_reg_fat conta, c.nm_convenio, p.ds_con_pla ds_plano, i.cd_pro_fat, pf.ds_pro_fat, g.cd_gru_pro, g.ds_gru_pro, 
 t.cd_tab_fat, t.ds_tab_fat, rg.cd_regra, rg.ds_regra, i.vl_percentual_multipla,it.vl_percetual_pago,  i.qt_lancamento,
i.vl_unitario, i.vl_total_conta vl_total, i.dt_Lancamento
from reg_Fat r, convenio c, con_pla p, pro_fat pf, gru_pro g, itreg_fat i, itregra it, tab_fat t , regra rg
where r.cd_convenio = c.cd_convenio
and   r.cd_Convenio = p.cd_convenio
and   r.cd_con_pla = p.cd_con_pla
and   i.cd_pro_fat = pf.cd_pro_fat
and   pf.cd_gru_pro = g.cd_gru_pro  
and   r.cd_reg_fat = i.cd_reg_fat
and   it.cd_regra = p.cd_regra
and   it.cd_regra = rg.cd_regra
and   it.cd_gru_pro = g.cd_gru_pro
and   it.cd_tab_fat = t.cd_tab_fat
and   it.cd_tab_fat in (53) -- 51,50
--and   r.cd_multi_empresa =and   it.cd_regra = 77 4
and c.tp_convenio = 'C'
--and   r.cd_convenio in (72)
and   i.sn_pertence_pacote = 'N'
and   i.cd_pro_Fat  in ('00292015') -- 10009998,10009997
and   i.dt_lancamento  between  '01/05/2018' and '22/09/2021'


union all

select decode (r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
'Ambulatorial', i.cd_atendimento, r.cd_reg_amb conta, c.nm_convenio, p.ds_con_pla ds_plano, i.cd_pro_fat, pf.ds_pro_fat,g.cd_gru_pro, g.ds_gru_pro, 
 t.cd_tab_fat, t.ds_tab_fat, rg.cd_regra, rg.ds_regra,i.vl_percentual_multipla,it.vl_percetual_pago, i.qt_lancamento,
i.vl_unitario, i.vl_total_conta vl_total, i.hr_Lancamento dt_lancamento
from reg_amb r, convenio c, con_pla p, pro_fat pf, gru_pro g, itreg_amb i, itregra it, tab_fat t , regra rg
where r.cd_convenio = c.cd_convenio
and   i.cd_Convenio = p.cd_convenio
and   i.cd_con_pla = p.cd_con_pla
and   i.cd_pro_fat = pf.cd_pro_fat
and   pf.cd_gru_pro = g.cd_gru_pro
and   r.cd_reg_amb = i.cd_reg_amb
and   it.cd_regra = p.cd_regra
and   it.cd_regra = rg.cd_regra
and   it.cd_gru_pro = g.cd_gru_pro
and   it.cd_tab_fat = t.cd_tab_fat
and   i.sn_pertence_pacote = 'N'
and   it.cd_tab_fat in (53) -- 51, 50
--and   it.cd_regra = 77
--and   r.cd_multi_empresa = 7
and c.tp_convenio = 'C'
--and   r.cd_convenio in (72)
and   i.sn_pertence_pacote = 'N'
and   i.cd_pro_Fat in ('00292015')-- 40304809
and   i.hr_lancamento between   '01/05/2018' and '22/09/2021'
;
