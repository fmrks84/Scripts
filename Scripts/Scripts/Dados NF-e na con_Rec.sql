select a.cd_con_rec, 
       a.cd_processo , 
       a.nr_documento NR_RPS ,
       d.nr_nota_fiscal_nfe NR_NFE 
from dbamv.con_rec a 
       inner join dbamv.itcon_rec b on b.cd_con_rec = a.cd_con_rec
       inner join dbamv.nota_fiscal d on d.cd_nota_fiscal = a.cd_nota_fiscal
        and a.cd_con_rec = 381711
         

