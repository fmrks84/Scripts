select nfe.dt_emissao, nfe.nr_id_nota_fiscal, nfe.cd_nota_fiscal , nfe.nr_nota_fiscal_nfe, nfe.hr_emissao_nfe, nfe.cd_verificacao_nfe, nfe.vl_total_nota 
from nota_fiscal nfe 
where nfe.cd_multi_empresa = 2
and nfe.dt_emissao between '01/02/2022' and '07/03/2022'
and nfe.nr_nota_fiscal_nfe is null 
--and nfe.nr_id_nota_fiscal = 862798

 







--
/*select * from con_Rec rec
inner join itcon_rec irec on rec.cd_con_rec = irec.cd_con_rec
 where nr_documento = '862974'*/
--select * from nota_fiscal where  nota_fiscal.nr_id_nota_fiscal = 862974



--select * from remessa_fatura where cd_remessa = 481130
