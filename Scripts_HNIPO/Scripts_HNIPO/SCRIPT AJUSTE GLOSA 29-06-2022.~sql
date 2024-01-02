/*
SELECT * FROM dbamv.it_recebimento 
WHERE cd_itfat_nf IN ( SELECT cd_itfat_nf FROM dbamv.itfat_nota_fiscal WHERE cd_reg_fat = 235620 )
;
SELECT * FROM dbamv.glosas x where  x.cd_reg_fat = 235620 
--update dbamv.it_recebimento set vl_glosa = '1,88' where cd_itfat_nf = 58703484

select * from  dbamv.it_recebimento where cd_itfat_nf = 59141204;

update dbamv.it_recebimento set vl_glosa = '3,41' where cd_itfat_nf = 59141204

select 


*
from
(
SELECT sum(vl_glosa)vl_glosa FROM dbamv.glosas x where  x.cd_reg_fat = 235620 -- valor glosa;
union all 
SELECT sum(vl_glosa)vl_glosa FROM dbamv.it_recebimento 
WHERE cd_itfat_nf IN ( SELECT cd_itfat_nf FROM dbamv.itfat_nota_fiscal WHERE cd_reg_fat = 235620 ) --- valor glosa financ
)

*/

select gl.cd_glosas, 
      gl.cd_itfat_nf, 
      gl.vl_glosa vl_glosa_gl,
      irg.cd_reccon_rec, 
      irg.cd_itfat_nf , 
      irg.vl_glosa vl_glosa_rec
     
       from glosas gl 
left join it_recebimento irg on gl.cd_itfat_nf = irg.cd_itfat_nf
where gl.cd_reg_fat = 235081
and  gl.vl_glosa <> irg.vl_glosa

       
select * from ITMOV_GLOSAS GL WHERE GL.CD_ITFAT_NF IN (SELECT CD_ITFAT_NF FROM dbamv.it_recebimento 
WHERE cd_itfat_nf IN ( SELECT cd_itfat_nf FROM dbamv.itfat_nota_fiscal WHERE cd_reg_fat = 235091 ) )


update glosas l set l.vl_glosa = '135,46' where l.cd_glosas in (8271964
)


SELECT * FROM glosas l WHERE CD_REG_fAT = 235091 ---FOR UPDATE 

select * from con_Rec r1 where r1.nr_documento = '837382'
select * from itcon_Rec uu where uu.cd_con_rec = 1137839
select * from reccon_rec ui where ui.cd_itcon_rec = 1141056

select * from all_tab_columns hh where hh.column_name = 'CD_GLOSAS'
SELECT * FROM ITMOV_GLOSAS  glu where glu.cd_con_rec = 1137839
select * from itcon_Rec uu where uu.cd_con_rec = 1137839
select * from reccon_rec ui where ui.cd_itcon_rec = 1141056



select * from  dbamv.it_recebimento ju where ju.cd_itfat_nf in (select p.cd_itfat_nf from itfat_nota_fiscal p where p.cd_reg_fat = 235081)

select * from  
update 
dbamv.it_recebimento ju set vl_glosa = '1,18'  -- 287,52
 where ju.cd_itfat_nf = 58703485
 
 
SELECT * FROM CAIX
SELECT * FROM MOV_CAIXA Y WHERE Y.CD_LOTE_CAIXA = 63361
SELECT * FROM DOC_CAIXA UH WHERE UH.CD_DOC_CAIXA IN (SELECT Y.CD_DOC_CAIXA FROM MOV_CAIXA Y WHERE Y.CD_LOTE_CAIXA = 63361)
S
