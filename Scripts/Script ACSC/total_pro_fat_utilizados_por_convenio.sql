select 

b.cd_pro_fat||' - '||a.ds_pro_fat nm_procedimento,
c.cd_convenio||' - '||d.nm_convenio nm_convenio,
count(*)total_utilizado_em_conta
from 
dbamv.pro_fat a 
inner join dbamv.itreg_Fat b on b.cd_pro_fat = a.cd_pro_fat
inner join dbamv.reg_Fat c on c.cd_reg_fat = b.cd_reg_fat
inner join dbamv.convenio d on d.cd_convenio = c.cd_convenio
where a.Cd_Gru_Pro = 6
and trunc(b.dt_lancamento) > = '08/11/2021' 
and a.Sn_Ativo = 'S'
and c.cd_multi_empresa = 7
--and c.cd_atendimento = 3274897 
group by 
b.cd_pro_fat,
c.cd_convenio,
d.nm_convenio,
a.ds_pro_fat
order by c.cd_convenio, a.ds_pro_fat
;

select 
sum(total_utilizado_em_conta)
from
(
select 

b.cd_pro_fat||' - '||a.ds_pro_fat nm_procedimento,
c.cd_convenio||' - '||d.nm_convenio nm_convenio,
count(*)total_utilizado_em_conta
from 
dbamv.pro_fat a 
inner join dbamv.itreg_Fat b on b.cd_pro_fat = a.cd_pro_fat
inner join dbamv.reg_Fat c on c.cd_reg_fat = b.cd_reg_fat
inner join dbamv.convenio d on d.cd_convenio = c.cd_convenio
where a.Cd_Gru_Pro = 6
and trunc(b.dt_lancamento) >= '08/11/2021'
and a.Sn_Ativo = 'S'
and c.cd_multi_empresa = 7
--and c.cd_atendimento = 3274897 
group by 
b.cd_pro_fat,
c.cd_convenio,
d.nm_convenio,
a.ds_pro_fat
order by c.cd_convenio, a.ds_pro_fat
)

/*-- 61395


select 
*
from 
mvto_gases*/
