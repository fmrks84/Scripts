SELECT
casa,
tp_atendimento,
cd_atendimento,
conta,
cd_convenio,
nm_convenio,
cd_plano,
ds_plano,
cd_pro_fat,
ds_pro_fat,
cd_Tab_fat,
ds_Tab_fat,
cd_regra,
ds_regra,
cd_horario_especial,
sn_horario_especial,
vl_percentual_horario_especial,
vl_percentual_multipla,
vl_percetual_pago,
qt_lancamento,
vl_unitario,
vl_total,
dt_lancamento,
--vl_simpro_vl_brasindice,
--vl_horario_especial,
--vl_horario_especial * qt_lancamento AS vl_x_quantidade,
vl_simpro_vl_brasindice + vl_horario_especial AS valor_unitario_acordado,
(vl_simpro_vl_brasindice + vl_horario_especial) * qt_lancamento AS valor_total_acordado,
(vl_simpro_vl_brasindice + vl_horario_especial) * qt_lancamento - vl_total AS diferenca

FROM (
select distinct
casa,
tp_atendimento,
cd_atendimento,
conta,
cd_convenio,
nm_convenio,
cd_plano,
ds_plano,
cd_pro_fat,
ds_pro_fat,
cd_Tab_fat,
ds_Tab_fat,
cd_regra,
ds_regra,
cd_horario_especial,
sn_horario_especial,
CASE WHEN sn_horario_especial = 'S'
THEN vl_percentual_horario_especial
ELSE 0
END vl_percentual_horario_especial,
vl_percentual_multipla,
vl_percetual_pago,
qt_lancamento,
vl_unitario,
vl_total,
dt_lancamento,
vl_simpro_vl_brasindice,
CASE WHEN sn_horario_especial = 'S'
THEN ((vl_simpro_vl_brasindice * vl_percetual_pago)/100) * (vl_percentual_horario_especial / 100)
ELSE 0
END vl_horario_especial,
round(((vl_simpro_vl_brasindice * vl_percetual_pago)/100 * qt_lancamento - vl_total),+2) diferenca

from
(
select decode (r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
'Internado'tp_atendimento,
r.cd_atendimento,
r.cd_reg_fat conta,
c.cd_convenio,
c.nm_convenio,
p.cd_con_pla cd_plano,
p.ds_con_pla ds_plano,
i.cd_pro_fat,
pf.ds_pro_fat,
g.cd_gru_pro,
g.ds_gru_pro,
t.cd_tab_fat,
t.ds_tab_fat,
rg.cd_regra,
rg.ds_regra,
it.cd_horario cd_horario_especial,
i.sn_horario_especial,
h.vl_percentual vl_percentual_horario_especial,
i.vl_percentual_multipla,
it.vl_percetual_pago,
i.qt_lancamento,
i.vl_unitario,
i.vl_total_conta vl_total,
i.dt_Lancamento,
'&valor'vl_simpro_vl_brasindice --filtro
from reg_Fat r,
     convenio c,
     con_pla p,
     pro_fat pf,
     gru_pro g,
     itreg_fat i,
     itregra it,
     tab_fat t ,
     regra rg,
     horario_especial h
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
and   h.cd_horario (+) = it.cd_horario
and   c.tp_convenio = 'C'
and   i.sn_pertence_pacote = 'N'
and   it.cd_tab_fat in ('&cd_tab_Fat') --filtro
and   i.cd_pro_Fat  in ('&cd_pro_Fat') --filtro
and   i.dt_lancamento  between  '&dt_lancamento' and '&dt_lancamento_fim' --filtro

union all

select decode (r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa,
'Ambulatorial'tp_atendimento,
i.cd_atendimento,
r.cd_reg_amb conta,
c.cd_convenio,
c.nm_convenio,
p.cd_con_pla cd_plano,
p.ds_con_pla ds_plano,
i.cd_pro_fat,
pf.ds_pro_fat,
g.cd_gru_pro,
g.ds_gru_pro,
t.cd_tab_fat,
t.ds_tab_fat,
rg.cd_regra,
rg.ds_regra,
it.cd_horario cd_horario_especial,
i.sn_horario_especial,
h.vl_percentual vl_percentual_horario_especial,
i.vl_percentual_multipla,
it.vl_percetual_pago,
i.qt_lancamento,
i.vl_unitario,
i.vl_total_conta vl_total,
i.hr_Lancamento dt_lancamento,
'&valor'vl_simpro_vl_brasindice -- filtro
from reg_amb r,
     convenio c,
     con_pla p,
     pro_fat pf,
     gru_pro g,
     itreg_amb i,
     itregra it,
     tab_fat t,
     regra rg,
     horario_especial h
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
and   h.cd_horario (+) = it.cd_horario 
and   c.tp_convenio = 'C'
and   i.sn_pertence_pacote = 'N'
and   it.cd_tab_fat in ('&cd_tab_Fat') --filtro
and   i.cd_pro_Fat in ('&cd_pro_fat') --filtro
and   i.hr_lancamento between   '&dt_lancamento' and '&dt_lancamento_fim' --filtro
)
order by dt_lancamento
);

