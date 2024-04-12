delete from itfat_nota_fiscal where cd_reg_fat in (648567,649111,649498,650725,651170);
delete from Reccon_Rec rcc where rcc.cd_itcon_rec in (select irc.cd_itcon_rec from itcon_rec irc where irc.cd_con_rec in (select rc.cd_con_rec from con_rec rc where 
rc.cd_reg_fat in (648567,649111,649498,650725,651170)));
delete from itcon_rec irc where irc.cd_con_rec in (select rc.cd_con_rec from con_rec rc where 
rc.cd_reg_fat in (648567,649111,649498,650725,651170));
delete from rat_conrec ircc where ircc.cd_con_rec in (select rc.cd_con_rec from con_rec rc where 
rc.cd_reg_fat in (648567,649111,649498,650725,651170));
delete from tip_detcon_rec where cd_con_rec in (1409297, 1413231, 1413235, 1412461)
delete from con_Rec rc where  rc.cd_reg_fat in (648567,649111,649498,650725,651170)
--select * from it_repasse irp where irp.cd_reg_fat in (648567,649111,649498,650725,651170)
delete from NOTA_FISCAL_TRIBUTO nft where nft.cd_nota_fiscal in (select nf.cd_nota_fiscal from  nota_fiscal nf where nf.cd_reg_fat in (648567,649111,649498,650725,651170))
delete  from nota_fiscal nf where nf.cd_reg_fat in (648567,649111,649498,650725,651170);
;
select * from all_constraints al where al.constraint_name like '%CNT_NOT_FIS_TR_NOTA_FISCA_1_FK%'
