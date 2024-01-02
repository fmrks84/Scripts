select cd_reg_Fat , dt_inicio, dt_final , dt_fechamento , cd_multi_empresa , vl_total_conta
 from dbamv.reg_fat where nvl (cd_conta_pai,cd_reg_Fat) in (979919,987109)
 
 
select cd_reg_Fat , cd_conta_pai , cd_pro_fat , cd_lancamento, dt_lancamento , cd_multi_empresa from dbamv.itreg_Fat where cd_reg_fat in (987109) order by cd_lancamento for update
 
 
 select * From Dbamv.It_Repasse Where cd_reg_Fat = 987109


-------------------------------------------------------------------------------------------------------

select cd_reg_Fat ,cd_conta_pai, dt_inicio, dt_final , dt_fechamento , cd_multi_empresa , vl_total_conta 
 from dbamv.reg_fat where cd_reg_Fat = 999428-- (cd_conta_pai,cd_reg_Fat) in (979919,987109)
 
select * from dbamv.reg_fat a where a.cd_reg_fat = 999428 

select cd_reg_Fat , cd_conta_pai , cd_pro_fat , cd_lancamento, dt_lancamento , cd_multi_empresa from dbamv.itreg_Fat where cd_reg_fat in (999428) order by cd_lancamento for update
