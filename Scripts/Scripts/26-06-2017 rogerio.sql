select * from dbamv.con_Rec a where a.cd_con_rec = 442659 for update --62
select * from dbamv.itcon_rec b where b.cd_itcon_rec = 445974 for update --b.cd_con_rec = 442659 for update 
select * from dbamv.reccon_rec c where c.cd_itcon_rec = 445974 for update 
select * from dbamv.rat_conrec d where d.cd_con_rec = 442659 for update 
select * from dbamv.Mov_Caixa e where e.cd_mov_caixa = 684522 for update 

select * from dbamv.reccon_rec  where  cd_itcon_rec =  454828
--+-
TRG_RECCON_REC_LANCA_FINANC
trg_reccon_rec_lanca_contab
select * from dbamv.reccon_rec e where e.cd_fin_car = 62
order by e.dt_recebimento desc 
