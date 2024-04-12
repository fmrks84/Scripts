--select * from sys.itreg_fat_audit x where x.cd_reg_fat = 492500
select * from sys.reg_fat_audit where cd_reg_Fat = 492500-- 512558--492500
order by dt_aud desc 
;
select * from audit_dbamv.itreg_fat h where h.cd_reg_fat = 492500--492500
and h.cd_pro_fat is not null
and trunc(h.audit_dt_registro) = '06/12/2022'
order by  h.audit_dt_registro desc 
;

select * from sys.reg_fat_audit where cd_reg_Fat = 512558-- 512558--492500
order by dt_aud desc 
;
select * from audit_dbamv.itreg_fat h where h.cd_reg_fat = 512558--492500
and h.cd_pro_fat is not null
and trunc(h.audit_dt_registro) = '08/12/2023'
order by  h.audit_dt_registro desc 
;

select * from dbamv.auditoria_conta_ope where cd_Reg_Fat = 512558 and cd_pro_Fat = '09098429'
order by 3 desc 
;
select * from dbamv.auditoria_conta_ope where cd_Reg_Fat = 492500 and cd_pro_Fat = '10001885'
order by 3 desc 

;

