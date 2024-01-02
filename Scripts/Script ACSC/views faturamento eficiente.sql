select * from ensemble.vw_atendimento_faturamento a where a.cd_atendimento in (2370118);--(2370063,2370064,2370104);
select * from ensemble.vw_autorizacao_faturamento b where b.cd_atendimento in (2370118);--(2370063,2370064,2370104) ;

select * from ensemble.vw_conta_faturamento_hospital c where c.id_atendimento in (2370118); --(2370063,2370064,2370105) ;
select * from ensemble.vw_item_conta_fatura_hospital d where d.id_conta in (260618) ;
select * from ensemble.vw_despesa_conta_fatura_hospit d1 where d1.id_conta in (260618);

select * from ensemble.vw_conta_faturamento_ambulat c1 where c1.id_atendimento in (2370117);
select * from ensemble.vw_despesa_conta_fatura_ambul c3 where c3.id_atendimento in (2370118)
select * from ensemble.vw_item_conta_fatura_ambulat e1 where e1.id_atendimento in (2370118);

select * from ensemble.vw_remessa_faturamento f1 where f1.id_remessa = 179188
select * from ensemble.vw_lote_faturamento f2 where f2.cd_remessa = 179185


select * from reg_amb where cd_reg_amb = 1987945;
select * from itreg_amb where cd_reg_amb = 1987945
--select * from all_tab_columns z  where  z.column_name like 'CD_REG_AMB'
