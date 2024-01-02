select 
casa,
tp_internacao,
cd_atendimento,
conta,
nm_convenio,
ds_plano,
cd_pro_fat,
ds_pro_fat,
cd_Tab_fat,
ds_Tab_fat,
cd_regra,
ds_regra,
vl_percentual_multipla,
vl_percetual_pago,
qt_lancamento,
vl_unitario,
vl_total,
dt_lancamento,
vl_simpro_vl_brasindice,
(vl_simpro_vl_brasindice * vl_percetual_pago)/100 vl_correto_cobrado,
(vl_simpro_vl_brasindice * vl_percetual_pago)/100 * qt_lancamento vl_x_quantidade,
round(((vl_simpro_vl_brasindice * vl_percetual_pago)/100 * qt_lancamento - vl_total),+2) diferenca
from
(
select decode (r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
'Internado'tp_internacao, 
r.cd_atendimento, 
r.cd_reg_fat conta,
c.nm_convenio, 
p.ds_con_pla ds_plano, 
i.cd_pro_fat, 
pf.ds_pro_fat, 
g.cd_gru_pro, 
g.ds_gru_pro, 
t.cd_tab_fat, 
t.ds_tab_fat, 
rg.cd_regra, 
rg.ds_regra, 
i.vl_percentual_multipla,
it.vl_percetual_pago,  
i.qt_lancamento,
i.vl_unitario, 
i.vl_total_conta vl_total, 
i.dt_Lancamento,
'2241,08'vl_simpro_vl_brasindice  -- colocar o valor brasindice ou simpro 
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
and   it.cd_tab_fat in (&cd_tab_Fat) -- 51,50
--AND   it.cd_regra in (24,25,236)
and c.tp_convenio = 'C'
and   i.sn_pertence_pacote = 'N'
and   i.cd_pro_Fat  in (&cd_pro_Fat)--('90357507') -- 10009998,10009997
and   i.dt_lancamento  between  '&dt_lancamento'/*'01/05/2020'*/ and '&dt_lancamento_fim'--'17/11/2021'

-- 16,15
union all

select decode (r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
'Ambulatorial'tp_internacao, 
i.cd_atendimento, 
r.cd_reg_amb conta, 
c.nm_convenio, 
p.ds_con_pla ds_plano, 
i.cd_pro_fat, 
pf.ds_pro_fat,
g.cd_gru_pro, 
g.ds_gru_pro, 
t.cd_tab_fat, 
t.ds_tab_fat, 
rg.cd_regra, 
rg.ds_regra,
i.vl_percentual_multipla,
it.vl_percetual_pago, 
i.qt_lancamento,
i.vl_unitario, 
i.vl_total_conta vl_total, 
i.hr_Lancamento dt_lancamento,
'2241,08'vl_simpro_vl_brasindice -- colocar o valor brasindice ou simpro
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
and   it.cd_tab_fat in (1) 
--AND   it.cd_regra in (24,25,236)
and c.tp_convenio = 'C'
and   i.sn_pertence_pacote = 'N'
and   i.cd_pro_Fat in ('90357507')-- 40304809
and   i.hr_lancamento between   '01/05/2020' and '17/11/2021'
)--- 10,66
order by dt_lancamento
;

select 
casa,
cd_pro_fat,
ds_pro_fat,
sum(total)
from
(
select 
casa,
cd_pro_fat,
ds_pro_fat,
case 
  when (diferenca) > = 0 then sum(diferenca)
    else 0
    end total
from
(
select 
casa,
tp_internacao,
cd_atendimento,
conta,
nm_convenio,
ds_plano,
cd_pro_fat,
ds_pro_fat,
cd_Tab_fat,
ds_Tab_fat,
cd_regra,
ds_regra,
vl_percentual_multipla,
vl_percetual_pago,
qt_lancamento,
vl_unitario,
vl_total,
dt_lancamento,
vl_simpro_vl_brasindice,
(vl_simpro_vl_brasindice * vl_percetual_pago)/100 vl_correto_cobrado,
(vl_simpro_vl_brasindice * vl_percetual_pago)/100 * qt_lancamento vl_x_quantidade,
round(((vl_simpro_vl_brasindice * vl_percetual_pago)/100 * qt_lancamento - vl_total),+2) diferenca
from
(
select decode (r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
'Internado'tp_internacao, 
r.cd_atendimento, 
r.cd_reg_fat conta,
c.nm_convenio, 
p.ds_con_pla ds_plano, 
i.cd_pro_fat, 
pf.ds_pro_fat, 
g.cd_gru_pro, 
g.ds_gru_pro, 
t.cd_tab_fat, 
t.ds_tab_fat, 
rg.cd_regra, 
rg.ds_regra, 
i.vl_percentual_multipla,
it.vl_percetual_pago,  
i.qt_lancamento,
i.vl_unitario, 
i.vl_total_conta vl_total, 
i.dt_Lancamento,
'2241,08'vl_simpro_vl_brasindice  -- colocar o valor brasindice ou simpro 
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
and   it.cd_tab_fat in (1) -- 51,50
--AND   it.cd_regra in (24,25,236)
and c.tp_convenio = 'C'
and   i.sn_pertence_pacote = 'N'
and   i.cd_pro_Fat  in ('90357507') -- 10009998,10009997
and   i.dt_lancamento  between  '01/05/2020' and '17/11/2021'

-- 16,15
union all

select decode (r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
'Ambulatorial'tp_internacao, 
i.cd_atendimento, 
r.cd_reg_amb conta, 
c.nm_convenio, 
p.ds_con_pla ds_plano, 
i.cd_pro_fat, 
pf.ds_pro_fat,
g.cd_gru_pro, 
g.ds_gru_pro, 
t.cd_tab_fat, 
t.ds_tab_fat, 
rg.cd_regra, 
rg.ds_regra,
i.vl_percentual_multipla,
it.vl_percetual_pago, 
i.qt_lancamento,
i.vl_unitario, 
i.vl_total_conta vl_total, 
i.hr_Lancamento dt_lancamento,
'2241,08'vl_simpro_vl_brasindice -- colocar o valor brasindice ou simpro
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
and   it.cd_tab_fat in (1) 
--AND   it.cd_regra in (24,25,236)
and c.tp_convenio = 'C'
and   i.sn_pertence_pacote = 'N'
and   i.cd_pro_Fat in ('90357507')-- 40304809
and   i.hr_lancamento between   '01/05/2020' and '17/11/2021'
)--- 10,66
order by dt_lancamento
)
GROUP BY 
casa,
cd_pro_fat,
ds_pro_fat,
diferenca
) where total <> 0
group by 
casa,
cd_pro_fat,
ds_pro_fat
