--with rem as (
select inf.cd_atendimento,
       pct.nm_paciente,
       inf.cd_reg_fat,
       inf.cd_remessa,
       sum(inf.vl_itfat_nf)
From itfat_nota_fiscal inf 
inner join atendime at on at.cd_atendimento = inf.cd_atendimento
inner join paciente pct on pct.cd_paciente = at.cd_paciente
where inf.cd_remessa = 346728
group by inf.cd_atendimento,
       pct.nm_paciente,
       inf.cd_reg_fat,
       inf.cd_remessa
order by pct.nm_paciente

;

select 
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
where rf.cd_remessa = 346728


--rf.cd_remessa in 
--rm.cd_remessa in (346728)
--order by pc.nm_paciente

-- 515843
--192407,00
;
/*
select * from itreg_Fat where cd_reg_Fat = 515843

select * from sys.itreg_fat_audit x where  x.cd_reg_Fat in (515843) order by x.dt_aud desc 
select * from audit_dbamv.itreg_fat where cd_reg_Fat in (515843) order by 1 desc 
select * from auditoria_conta where cd_reg_Fat = (515843)order by 2 desc 
select * from dbamv.v_auditoria_itens_ffcv v where v.cd_reg_fat = 515843 order by 4 desc */
