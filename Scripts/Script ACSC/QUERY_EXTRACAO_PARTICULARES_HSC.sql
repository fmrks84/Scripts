select 
atd.cd_atendimento,
pct.nm_paciente,
atd.dt_atendimento,
atd.dt_alta,
(atd.dt_alta - atd.dt_atendimento)nr_dias,
sum(rg.vl_total_conta)vl_total_conta,
atd.cd_ori_ate||' - '||ort.ds_ori_ate origem_atendimento,
atd.cd_prestador||' - '||prest.nm_prestador prestador

from 
atendime atd
inner join paciente pct on pct.cd_paciente = atd.cd_paciente
inner join reg_Fat rg on rg.cd_atendimento = atd.cd_atendimento 
inner join prestador prest on prest.cd_prestador = atd.cd_prestador
inner join ori_ate ort on ort.cd_ori_ate = atd.cd_ori_ate
where atd.dt_atendimento between '01/01/2022' and '31/10/2022'--to_char(sysdate,'DD/MM/RRRR')
and atd.cd_convenio = 40
--and atd.cd_atendimento = 3439615
group by
atd.cd_atendimento,
pct.nm_paciente,
atd.dt_atendimento,
atd.dt_alta,
atd.cd_ori_ate,
ort.ds_ori_ate,
atd.cd_prestador,
prest.nm_prestador
order by atd.dt_atendimento
