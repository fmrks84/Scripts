select a.cd_reg_fat, a.audit_dt_registro, a.audit_cd_usuario , a.audit_tp_acao , a.cd_setor_produziu , a.cd_setor , a.audit_cd_modulo 
from audit_dbamv.itreg_fat a  where a.cd_reg_fat = 338440 and a.cd_lancamento in (83) order by 2 desc ;-- --,91,92,93) ;

select a.cd_reg_fat,a.audit_dt_registro, a.audit_cd_usuario , a.audit_tp_acao , a.cd_setor_produziu , a.cd_setor , a.audit_cd_modulo 
from audit_dbamv.itreg_fat a  where a.cd_reg_fat = 338606 and a.cd_lancamento in (97) order by 2 desc ;-- --,91,92,93) 

select a.cd_reg_fat,a.audit_dt_registro, a.audit_cd_usuario , a.audit_tp_acao , a.cd_setor_produziu , a.cd_setor , a.audit_cd_modulo 
from audit_dbamv.itreg_fat a  where a.cd_reg_fat = 339059 and a.cd_lancamento in (69) order by 2 desc; -- --,91,92,93) 

select a.cd_reg_fat,a.audit_dt_registro, a.audit_cd_usuario , a.audit_tp_acao , a.cd_setor_produziu , a.cd_setor , a.audit_cd_modulo 
from audit_dbamv.itreg_fat a  where a.cd_reg_fat = 339052 and a.cd_lancamento in (73) order by 2 desc ;-- --,91,92,93) 

/*reg_fat 338440 -- cod. lanç. 83
reg_fat 338606 -- cod. lanç. 97
reg_fat 339059 -- cod. lanç. 69
reg_fat 339052 -- cod. lanç. 73*/

