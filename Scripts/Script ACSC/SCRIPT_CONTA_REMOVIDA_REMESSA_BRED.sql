select rf.cd_reg_fat, 
rf.cd_atendimento,
pc.nm_paciente, 
rf.cd_convenio, 
rf.cd_con_pla, 
rf.vl_total_conta,
ft.dt_competencia,
ft.cd_multi_empresa
from reg_fat rf 
inner join atendime atd on atd.cd_atendimento = rf.cd_atendimento
inner join paciente pc on pc.cd_paciente = atd.cd_paciente
inner join remessa_fatura rm on rm.cd_remessa = rf.cd_remessa
inner join fatura ft on ft.cd_fatura = rm.cd_fatura
where rm.cd_remessa = 346728
order by pc.nm_paciente
--171410,77
;


select * from reg_fat where cd_reg_Fat = 515843
;
select inf.cd_atendimento,
       pct.nm_paciente,
       inf.cd_reg_fat,
       sum(inf.vl_itfat_nf)
From itfat_nota_fiscal inf 
inner join atendime at on at.cd_atendimento = inf.cd_atendimento
inner join paciente pct on pct.cd_paciente = at.cd_paciente
where inf.cd_remessa = 346728
group by inf.cd_atendimento,
       pct.nm_paciente,
       inf.cd_reg_fat
order by pct.nm_paciente
-- 515843
--192407,00
;


select * from
 update 
 reg_amb set cd_remessa = null
 where cd_reg_amb = 4186079 
