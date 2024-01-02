select * from tiss_guia a where a.Cd_Atendimento = 4313603

select * from nota_fiscal x where x.nr_id_nota_fiscal = 1000018347
select distinct xi.cd_reg_amb from itfat_nota_fiscal xi where xi.cd_nota_fiscal = 495216
select * from remessa_Fatura x3 where x3.cd_remessa = 295900
select * from reg_amb where cd_remessa = 295900


select  * from  glosas gl where gl.cd_reg_amb in 
(select distinct xi.cd_reg_amb from itfat_nota_fiscal xi where xi.cd_nota_fiscal = 495216)
and gl.cd_remessa_glosa = 422431

select * from it_recebimento g2 where g2.cd_itfat_nf in (select gl.cd_itfat_nf from  glosas gl where gl.cd_reg_amb in 
(select distinct xi.cd_reg_amb from itfat_nota_fiscal xi where xi.cd_nota_fiscal = 495216))
and g2.cd_reccon_rec = 1636860


select * from reccon_Rec x4 where x4.cd_reccon_rec in (1636852,1636860)
