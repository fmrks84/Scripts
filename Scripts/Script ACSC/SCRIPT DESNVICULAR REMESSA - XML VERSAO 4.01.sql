select * from remessa_fatura 
where cd_remessa in (402328,402334);

delete from it_repasse xp where xp.cd_reg_fat = 629630

SELECT FROM CON_rEC WHERE cd_con_rec in (1374369, 1374375)

select * from fatura 
where cd_fatura in (select cd_fatura from remessa_fatura 
                     where cd_remessa in (402328,402334));

DELETE  from itfat_nota_fiscal 
where cd_remessa in (402328,402334);

select * from nota_fiscal 
where  cd_nota_fiscal in (587564, 587505, 588558, 583430, 583375, 583559, 587028, 583613, 588543, 586927, 585252, 587121, 586945, 584647, 587127, 588432, 583512, 587182);

select cd_con_rec from con_rec 
where cd_nota_fiscal  in (583375, 583430, 583512, 583559, 583613, 584647, 585252, 586927, 586945, 587028, 587121, 587127, 587182, 587505, 587564, 588432, 588543, 588558);

--1� desvincular o contas a receber  
update dbamv.con_rec set cd_remessa = null, cd_nota_fiscal = null 
where cd_nota_fiscal  in (583375, 583430, 583512, 583559, 583613, 584647, 585252, 586927, 586945, 587028, 587121, 587127, 587182, 587505, 587564, 588432, 588543, 588558);
commit;

--excluir a  glosa 
delete dbamv.itmov_glosas   
where cd_itfat_nf in  (select cd_itfat_nf from itfat_nota_fiscal where cd_remessa in (402328,402334))

alter trigger dbamv.TRG_MOV_GLOSAS_LANCA_FINANC disable;
delete dbamv.mov_glosas   
where cd_reccon_rec in  (select cd_reccon_rec from it_recebimento where cd_itfat_nf in (select cd_itfat_nf from itfat_nota_fiscal where cd_remessa in (402328,402334) ) );
alter trigger dbamv.TRG_MOV_GLOSAS_LANCA_FINANC enable;
commit;

-- excluir o recebimento 
delete dbamv.it_recebimento   
where cd_itfat_nf in  (select cd_itfat_nf from it_recebimento where  cd_itfat_nf in (select cd_itfat_nf from itfat_nota_fiscal where cd_remessa in (402328,402334 ) ));
commit;

delete dbamv.glosas   
where cd_itfat_nf in  (select cd_itfat_nf from itfat_nota_fiscal where cd_remessa in (402328,402334) );
commit;


delete dbamv.FINAN_RECEB_ITEM   
where cd_itfat_nf in  (select cd_itfat_nf from itfat_nota_fiscal where cd_remessa in (402328,402334) );
commit;

-- excluir item de nota fiscal 
delete dbamv.itfat_nota_fiscal where cd_nota_fiscal in (399112);
commit;



--- excluir remessa glosa 
alter trigger dbamv.TRG_MOV_GLOSAS_LANCA_FINANC disable;
alter trigger dbamv.trg_reccon_rec_lanca_financ disable;
alter trigger dbamv.trg_reccon_rec_before disable;
delete from rec_mov_con rr where rr.cd_reccon_rec in (select rmx.cd_reccon_rec from reccon_rec rmx where rmx.cd_remessa_glosa in (select rm.cd_remessa_glosa from remessa_glosa rm where rm.cd_remessa in (399112)));

delete from mov_glosas r3 where r3.cd_reccon_rec in (select rmx.cd_reccon_rec from reccon_rec rmx where rmx.cd_remessa_glosa in (select rm.cd_remessa_glosa from remessa_glosa rm where rm.cd_remessa in (399112)));

delete from reccon_rec rmx where rmx.cd_remessa_glosa in (select rm.cd_remessa_glosa from remessa_glosa rm where rm.cd_remessa in (399112));

delete from remessa_glosa where cd_remessa in (399112);

alter trigger dbamv.TRG_MOV_GLOSAS_LANCA_FINANC enable;
alter trigger dbamv.trg_reccon_rec_lanca_financ enable;
alter trigger dbamv.trg_reccon_rec_before enable;
commit;

-- excluir protocolo 
delete from tiss_lote b where b.id_pai in (select a.ID from DBAMV.V_TISS_STATUS_PROTOCOLO A    
where a.cd_remessa in (399112));
commit;

-- alterar remessa 
update dbamv.remessa_fatura set  sn_paga = 'N', dt_importacao_fnfi = null, cd_con_rec = null where cd_remessa in (342389,342346,342421,342480,342103,341854,346949,346972,350952,351792,352990,353023,353760,354554,354541,354545);
commit;

-- excluir repasse 
delete from it_repasse irp where irp.cd_reg_amb in (select cd_Reg_amb from reg_amb where cd_remessa in (342389,342346,342421,342480,342103,341854,346949,346972,350952,351792,352990,353023,353760,354554,354541,354545 ));
commit;

delete from it_repasse irp where irp.cd_reg_fat in (select cd_Reg_fat from reg_fat where cd_remessa in (342389,342346,342421,342480,342103,341854,346949,346972,350952,351792,352990,353023,353760,354554,354541,354545));
commit;

--excluir guia tiss
delete from tiss_guia where cd_remessa in (342389,342346,342421,342480,342103,341854,346949,346972,350952,351792,352990,353023,353760,354554,354541,354545);
commit;
