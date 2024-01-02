select decode (r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
'Internado', r.cd_atendimento, r.cd_reg_fat conta, c.nm_convenio, p.ds_con_pla ds_plano, i.cd_pro_fat, pf.ds_pro_fat, i.qt_lancamento,
i.vl_unitario, i.vl_total_conta vl_total, i.dt_Lancamento
from reg_Fat r, convenio c, con_pla p, pro_fat pf, gru_pro g, itreg_fat i
where r.cd_convenio = c.cd_convenio
and   r.cd_Convenio = p.cd_convenio
and   r.cd_con_pla = p.cd_con_pla
and   i.cd_pro_fat = pf.cd_pro_fat
and   pf.cd_gru_pro = g.cd_gru_pro
and   r.cd_reg_fat = i.cd_reg_fat
and   p.cd_regra in (78,83
,87,91,100,76,77,113,209,217,218,222,72,84,86
,88,90,95,108,112,262,68,81,85,94,96,102,117,240
,270,69,74,75,110,239,71,80,93,99,101,107,114,22,89
,97,104,105,109,115,221,73,79,82,92,98,103,106,111)
and   r.cd_multi_empresa = 3
and c.tp_convenio = 'C'
--and   r.cd_convenio in (69)
and   i.sn_pertence_pacote = 'N'
and   i.cd_pro_Fat in ('70705313','00015793')
and   i.dt_lancamento between '21/02/2019' and '16/03/2021'

union all

select decode (r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
'Ambulatorial', i.cd_atendimento, r.cd_reg_amb conta, c.nm_convenio, p.ds_con_pla ds_plano, i.cd_pro_fat, pf.ds_pro_fat, i.qt_lancamento,
i.vl_unitario, i.vl_total_conta vl_total, i.hr_Lancamento dt_lancamento
from reg_amb r, convenio c, con_pla p, pro_fat pf, gru_pro g, itreg_amb i
where r.cd_convenio = c.cd_convenio
and   i.cd_Convenio = p.cd_convenio
and   i.cd_con_pla = p.cd_con_pla
and   i.cd_pro_fat = pf.cd_pro_fat
and   pf.cd_gru_pro = g.cd_gru_pro
and   r.cd_reg_amb = i.cd_reg_amb
and   i.sn_pertence_pacote = 'N'
and p.cd_regra in (78,83
,87,91,100,76,77,113,209,217,218,222,72,84,86
,88,90,95,108,112,262,68,81,85,94,96,102,117,240
,270,69,74,75,110,239,71,80,93,99,101,107,114,22,89
,97,104,105,109,115,221,73,79,82,92,98,103,106,111)
and   r.cd_multi_empresa = 3
and c.tp_convenio = 'C'
--and   r.cd_convenio in (69)
and   i.sn_pertence_pacote = 'N'
and   i.cd_pro_Fat  in ('70705313','00015793')
and   i.hr_lancamento between  '21/02/2019' and '16/03/2021'

--union all
