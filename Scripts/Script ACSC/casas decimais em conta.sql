select 
vl_procedimento_tabela * 0.3824 + vl_procedimento_tabela vl_cobrado_em_conta
from
(
select 
a.cd_convenio cd_convenio,
a.cd_con_pla cd_con_pla,
a.cd_regra cd_regra,
d.cd_tab_fat cd_tab_fat,
b.cd_reg_fat cd_reg_fat,
b.cd_pro_fat cd_pro_fat,
c.cd_gru_pro cd_gru_pro,
b.dt_lancamento dt_lancamento,
b.hr_lancamento hr_lancamento,
b.qt_lancamento qt_lancamento,
b.vl_unitario vl_unitario,
d.vl_percetual_pago vl_percetual_pago,
b.vl_total_conta vl_total_conta,
a.cd_remessa cd_remessa,
(select e.vl_total from 
val_pro e 
where trunc (e.dt_vigencia) = (select max(x.dt_vigencia) from val_pro x where x.cd_pro_fat = e.cd_pro_fat and x.cd_tab_fat = e.cd_tab_fat) 
and e.cd_tab_fat = 581
and e.cd_pro_fat = 90167406)vl_procedimento_tabela

from 
reg_fat a
inner join itreg_fat b on b.cd_reg_fat = a.cd_reg_fat
inner join pro_fat c on c.cd_pro_fat = b.cd_pro_fat
inner join itregra d on d.cd_regra = a.cd_regra and  d.cd_gru_pro = c.cd_gru_pro
where a.cd_atendimento = 2884419
and b.cd_pro_fat = 90167406
)
;

select 
a.cd_convenio cd_convenio,
a.cd_con_pla cd_con_pla,
a.cd_regra cd_regra,
d.cd_tab_fat cd_tab_fat,
b.cd_reg_fat cd_reg_fat,
b.cd_pro_fat cd_pro_fat,
c.cd_gru_pro cd_gru_pro,
b.dt_lancamento dt_lancamento,
b.hr_lancamento hr_lancamento,
b.qt_lancamento qt_lancamento,
b.vl_unitario vl_unitario,
d.vl_percetual_pago vl_percetual_pago,
b.vl_total_conta vl_total_conta,
a.cd_remessa cd_remessa,
(select e.vl_total from 
val_pro e 
where trunc (e.dt_vigencia) = (select max(x.dt_vigencia) from val_pro x where x.cd_pro_fat = e.cd_pro_fat and x.cd_tab_fat = e.cd_tab_fat) 
and e.cd_tab_fat = 581
and e.cd_pro_fat = 90167406)vl_procedimento_tabela

from 
reg_fat a
inner join itreg_fat b on b.cd_reg_fat = a.cd_reg_fat
inner join pro_fat c on c.cd_pro_fat = b.cd_pro_fat
inner join itregra d on d.cd_regra = a.cd_regra and  d.cd_gru_pro = c.cd_gru_pro
where a.cd_atendimento = 2884419
and b.cd_pro_fat = 90167406

;

select * from DBAMV.V_TISS_STATUS_PROTOCOLO A      -- 1° 
where a.cd_remessa in (225429);--(195899);

select * from tiss_lote b where b.id_pai in(1865836); --for update; -- 2° colocar o id da tabela  V_TISS_STATUS_PROTOCOLO

select * from site_xml c where c.cd_site_servico = 561
and c.cd_wizard_origem in(1865836) --for update           -- 3° colocar o id_pai da tabela tiss_lote 
;

/*;

select 
*
from 
val_pro e 
where trunc (e.dt_vigencia) = (select max(x.dt_vigencia) from val_pro x where x.cd_pro_fat = e.cd_pro_fat and x.cd_tab_fat = e.cd_tab_fat) 
and e.cd_tab_fat = 581
and e.cd_pro_fat = 90167406*/
