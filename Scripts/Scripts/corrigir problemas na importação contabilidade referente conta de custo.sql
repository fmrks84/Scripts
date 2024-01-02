select * from dbamv.con_Rec e where e.cd_con_rec = 489289  -- 1º localizar itcon_Rec
select *  from dbamv.itcon_Rec f where f.cd_con_rec = 489289 -- 2º localizar itcon_Rec f.cd_itcon_rec
select * from dbamv.reccon_rec g where g.cd_itcon_rec in (493556) -- 3º localizar cd_Reccon_Rec g.cd_reccon_rec
select * from dbamv.reccon_rec a where a.cd_reccon_rec in (590834) -- 4 º localizar se possui desconto
select * from dbamv.Rec_Desc_Acres b where b.cd_reccon_rec in (597913)--494118,494119,494120,493510) -- 5º localizar o cd_Rec_desc_acres 
select * from dbamv.ratrec_desc_acres c where c.cd_rec_desc_acres in (3701)--(2464,2717,2718)
--2616,2701) -- 6º verificar se a coluna cd_Setor esta com o codigo do setor 
select * from dbamv.rat_reccon_rec g1 where g1.cd_reccon_rec in (494118,494119,494120) for update  -- para corrigir divergencia nos rateios 
update ratrec_desc_acres d set d.cd_setor = 57 where d.cd_rec_desc_acres in (3751) --7º  fazer o update com cd_Setor ao cd_Rec_desc_Acresc que ira ficar com o codigo do cd_setor 

----
select * from dbamv.lcto_setor_gerencial z where z.

select * from dbamv.con_pag z1 where z1.cd_con_pag in (549674)FOR UPDATE 
select * from dbamv.itcon_pag z2 where z2.cd_con_pag in (549674)FOR UPDATE 
select * from dbamv.pagcon_pag z3 where z3.cd_itcon_pag  in (
)FOR UPDATE 
select * from dbamv.ratcon_pag z4 where z4.cd_con_pag in (549674)for update 
select * from dbamv.ratpag_desc_acres z5 where z5.cd_setor in (567,577)

