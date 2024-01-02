select 
a.cd_reg_fat conta,
a.dt_lancamento,
a.cd_pro_fat,
b.ds_pro_fat,
e.tp_atendimento,
a.qt_lancamento,
a.vl_unitario,
a.vl_total_conta,
d.nm_convenio,
a.Cd_Setor_Produziu,
a.cd_setor cd_setor_solicitante,
f.vl_repasse,
a.sn_pertence_pacote



from 
dbamv.itreg_fat a 
inner join dbamv.pro_Fat b on b.cd_pro_fat = a.cd_pro_fat
inner join dbamv.reg_fat c on c.cd_reg_fat = a.cd_reg_fat
inner join dbamv.convenio d on d.cd_convenio = c.cd_convenio
inner join dbamv.atendime e on e.cd_atendimento = c.cd_atendimento
inner join dbamv.it_repasse f on f.cd_reg_fat = a.cd_reg_fat and a.cd_lancamento = f.cd_lancamento_fat
where trunc(a.dt_lancamento) between '01/01/2019' and '30/04/2021' 
and a.cd_setor_produziu = 39

union all

select
a1.cd_reg_amb conta,
a1.hr_lancamento dt_lancamento,
a1.cd_pro_fat,
a3.ds_pro_fat,
a4.tp_atendimento,
a1.qt_lancamento,
a1.vl_unitario,
a1.vl_total_conta,
a6.nm_convenio,
a1.cd_setor_produziu,
a1.cd_setor cd_setor_solicitante,
a5.vl_repasse,
a1.sn_pertence_pacote


from
dbamv.itreg_amb a1
inner join dbamv.reg_amb a2 on a2.cd_reg_amb = a1.cd_reg_amb
inner join dbamv.pro_Fat a3 on a3.cd_pro_fat = a1.cd_pro_fat
inner join dbamv.atendime a4 on a4.cd_atendimento = a1.cd_atendimento
inner join dbamv.it_repasse a5 on a5.cd_reg_amb = a1.cd_reg_amb and a5.cd_lancamento_amb = a1.cd_lancamento
inner join dbamv.convenio a6 on a6.cd_convenio = a4.cd_convenio
where a1.cd_setor_produziu = 39
and trunc(a1.hr_lancamento) between '01/01/2019' and '30/04/2021'
order by 1,2 


