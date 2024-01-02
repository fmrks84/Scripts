--341790, 341791, 341787, 341782 e 341784

select * from remessa_Fatura where cd_remessa = 341784
select * from tiss_guia x where x.cd_remessa = 341784--;
select * from tiss_itguia xp where xp.id_pai = 24705903
select * from itreg_fat where cd_reg_fat = 516344 and cd_pro_fat in (40813363)

update itreg_fat set vl_unitario = '329,1500' , vl_total_conta = '2633,20' where cd_reg_fat = 516344 and cd_pro_fat in (40813363)

513872
