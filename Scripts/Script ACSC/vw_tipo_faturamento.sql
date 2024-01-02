/*select * from setor where cd_setor = 4034
select decode (tp_classificacao_conta, 'P',1,'N',2,'C',3,4), 

select case when tp_classificacao_conta = 'N' and DT_FINAL iS NOT NULL then '4' when tp_classificacao_conta = 'P' AND DT_FINAL iS NOT NULL then '1' when tp_classificacao_conta = 'C' and dt_final is not null then '3'end tp_classificacao_conta from reg_fat where cd_reg_fat = :par2

select decode (tp_classificacao_conta, 'P',1,'N',2,'C',3,4) from reg_fat where cd_reg_fat = :par2

select * from reg_FAt where cd_reg_FAt = 461255

*/
create or replace view dbamv.vw_tipo_faturamento as (


select 
case when to_Char(rf.dt_final,'dd/mm/rrrr') = to_char(atd.dt_alta,'dd/mm/rrrr') and rf.tp_classificacao_conta <> 'C' then 4
     when to_Char(rf.dt_final,'dd/mm/rrrr') is not null and to_char(atd.dt_alta,'dd/mm/rrrr') is null then 1
     when to_Char(rf.dt_final,'dd/mm/rrrr') = to_char(atd.dt_alta,'dd/mm/rrrr')  and rf.tp_classificacao_conta = 'C' then 3
       end tp_Faturamento,
       rf.cd_reg_fat
from 
dbamv.atendime atd
inner join dbamv.reg_fat rf on rf.cd_atendimento = atd.cd_atendimento 
where rf.cd_reg_fat = rf.cd_reg_fat
)


---select * from tiss_guia where cd_reg_FAt = 461255

select x.TP_FATURAMENTO from dbamv.vw_tipo_faturamento x where x.CD_REG_FAT = :par2 
