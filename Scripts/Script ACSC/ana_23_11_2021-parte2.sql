select 
a.cd_nota_fiscal,
d.cd_convenio||' - '||(select x.nm_convenio from convenio x where x.cd_convenio = d.cd_convenio)nm_convenio,
a.nr_id_nota_fiscal,
a.dt_emissao,
c.dt_abertura,
c.dt_fechamento,
c.dt_entrega_da_fatura,
--a.cd_atendimento,
b.cd_remessa,
b.cd_reg_amb||''||b.cd_reg_fat CONTA,
CASE WHEN B.CD_REG_AMB IS NOT NULL THEN 'URG/AMB/EXT'
     WHEN B.CD_REG_FAT IS NOT NULL THEN 'INTERNADOS'
     END TIPO_CONTA,  
sum(b.vl_itfat_nf)valor_total
from nota_Fiscal a
inner join itfat_nota_fiscal b on b.cd_nota_fiscal = a.cd_nota_fiscal
inner join remessa_fatura c on c.cd_remessa = b.cd_remessa
inner join fatura d on d.cd_fatura = c.cd_fatura
where a.dt_emissao = '01/11/2021'
and a.cd_multi_empresa = 3
--and b.cd_reg_fat = 350487 
--and b.cd_reg_amb = 2646621
group by 
a.cd_nota_fiscal,
d.cd_convenio,
a.nr_id_nota_fiscal,
a.dt_emissao,
c.dt_abertura,
c.dt_fechamento,
c.dt_entrega_da_fatura,
--a.cd_atendimento,
b.cd_remessa,
b.cd_reg_amb,
b.cd_reg_fat
order by d.cd_convenio


/*select * from reg_Fat where cd_reg_fat = 353313
select * from reg_amb where cd_Reg_amb = 2697359*/
