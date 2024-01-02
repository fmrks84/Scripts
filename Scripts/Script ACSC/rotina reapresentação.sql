select
sum(Reg_Fat.Vl_Total_Conta)total_remessa
from 
reg_Fat where reg_fat.cd_remessa = 235477;

select
reg_Fat.Cd_Reg_Fat,
Reg_Fat.Vl_Total_Conta
from 
reg_Fat where reg_fat.cd_remessa = 235477;

select
remessa_fatura.cd_remessa,
remessa_fatura.cd_fatura
from
remessa_fatura where remessa_fatura.cd_remessa = 235477;

select
b.cd_remessa,
c.cd_convenio,
b.nr_remessa_convenio,
sum(c.vl_total_conta)total_remessa
from 
remessa_fatura b
inner join reg_fat c on c.cd_remessa = b.cd_remessa
where b.nr_remessa_convenio like '%REAPRESENTACAO%' OR b.nr_remessa_convenio like '%REAPRESENTAÇÃO%'
and b.cd_remessa in (235477,235478)
group by 
b.cd_remessa,
c.cd_convenio,
b.nr_remessa_convenio

;

select cd_reg_Fat , cd_remessa, vl_total_conta from reg_fat where cd_Reg_fat = 342404
select * from remessa_fatura x where x.cd_remessa in (235478,235477)
select * from fatura where cd_fatura = 32315,235477)
