
select *
from reg_Fat 
where cd_Reg_Fat = 471815--471518

  -- 15985,76

select   --15957,95
--x1.cd_pro_fat,  
--x1.cd_lancamento,
--x1.id_it_envio
sum()
from
itreg_fat x1 
where x1.sn_pertence_pacote = 'N'
and x1.cd_reg_fat = 471518
and x1.cd_lancamento = 147
--and x1.cd_pro_fat = 60018585
--and x1.cd_reg_fat = 471518
--group by 
--x1.cd_reg_fat
--order by 2 
;

select 
*
from
itfat_nota_fiscal x3
where x3.cd_remessa = 316152
and x3.cd_pro_fat= 60018585
--and x3.cd_lancamento_fat = 146
/*and*/ --x3.cd_reg_fat = 471518



