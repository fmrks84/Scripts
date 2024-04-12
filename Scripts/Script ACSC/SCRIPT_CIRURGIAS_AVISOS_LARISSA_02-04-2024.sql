select 
distinct
e.cd_multi_empresa,
a.cd_aviso_cirurgia,
a.dt_realizacao,
a.nm_paciente,
a.cd_atendimento,
g.cd_reg_fat,
ff.cd_pro_fat,
ltrim(l.ds_pro_fat)ds_pro_fat,
ff.vl_total_conta,
f.cd_remessa,
to_char(i.dt_competencia,'mm/rrrr') comp_remessa,
b.cd_convenio,
j.nm_convenio

from 
dbamv.aviso_cirurgia a 
inner join dbamv.cirurgia_aviso b on b.cd_aviso_cirurgia = a.cd_aviso_cirurgia and a.tp_situacao = 'R'
inner join dbamv.Prestador_Aviso c on c.cd_aviso_cirurgia = b.cd_aviso_cirurgia
and c.cd_cirurgia = b.cd_cirurgia
inner join dbamv.cirurgia b1 on b1.cd_cirurgia = b.cd_cirurgia
inner join dbamv.prestador d on d.cd_prestador = c.cd_prestador
inner join dbamv.atendime e on e.cd_atendimento = a.cd_atendimento
inner join dbamv.reg_fat f on f.cd_atendimento = e.cd_atendimento
inner join dbamv.itreg_Fat ff on ff.cd_reg_fat = f.cd_reg_fat
and ff.cd_pro_fat = b1.cd_pro_fat
inner join dbamv.itlan_med g on g.cd_reg_fat = f.cd_reg_fat
and g.cd_lancamento = ff.cd_lancamento
inner join dbamv.remessa_fatura h on h.cd_remessa = f.cd_remessa
inner join dbamv.fatura i on i.cd_fatura = h.cd_fatura
inner join dbamv.convenio j on j.cd_convenio = f.cd_convenio
inner join dbamv.pro_fat l on l.cd_pro_fat = ff.cd_pro_fat
where a.cd_multi_empresa = 7 
and a.dt_realizacao between '01/12/2023' and '29/02/2024'
--and g.cd_reg_fat = 624431
--and a.cd_aviso_cirurgia = 436240
order by
a.dt_realizacao,
b.cd_convenio,
a.nm_paciente
--- a.cd_aviso_cirurgia = 412608--412617

/*
--select * from prestador where cd_prestador = 38716
select * from reg_fat where cd_reg_fat = 412617
select * from itreg_amb where cd_reg_amb = 412617

select * from paciente where cd_paciente in (select cd_paciente from atendime where cd_atendimento = 437322)
select * from paciente where nm_paciente like '%JORGE LUIZ MALUF JUNIOR%'
select * from atendime where cd_paciente = 1123955

select * from aviso_cirurgia where cd_atendimento in (select cd_Atendimento from atendime where cd_paciente = 1123955)
select * from */
