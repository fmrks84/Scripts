
select * from remessa_fatura where cd_remessa = 482820
select * from agrupamento where cd_agrupamento = 1
select * from repasse a where a.cd_repasse = 50059
select * from repasse_prestador b where b.cd_repasse = 50059 
select * from it_repasse c where c.cd_repasse = 50059

select c.vl_repasse,e.cd_pro_fat, e.cd_prestador, c.cd_reg_amb, e.cd_atendimento from  reg_amb d 
inner join it_repasse c  on c.cd_reg_amb = d.cd_reg_amb 
inner join itreg_amb e on e.cd_reg_amb = d.cd_reg_amb and e.cd_lancamento = c.cd_lancamento_amb
where d.cd_remessa = 482820

select * from itfat_nota_fiscal where cd_remessa = 482820

