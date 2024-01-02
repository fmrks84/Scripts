select * from dbamv.remessa_Fatura a where a.cd_remessa = 100463
select * from dbamv.fatura c where c.CD_FATURA = 26384
select * from dbamv.Con_Rec where con_REc.Cd_Con_Rec = 442020
select sum(b.vl_itfat_nf)
 from dbamv.itfat_nota_fiscal b where b.cd_remessa = 100463
 
 select a.cd_remessa,  
       b.cd_convenio,
       sum (to_number (b.vl_total_conta)),
       b.cd_multi_empresa
from          dbamv.remessa_fatura a ,
              dbamv.reg_Fat b
where a.cd_remessa in (100463)--(89490,89491,89492)
and a.cd_remessa = b.cd_remessa
group by 
          a.cd_remessa,
          b.cd_multi_empresa,
          b.cd_convenio
order by 4--NA FATURA MV2000
