select cd_tip_det_reccon_rec, cd_reccon_rec, vl_tributo, vl_tributo_total, cd_con_pag, cd_detalhamento
from tip_det_reccon_rec
where cd_reccon_rec In (50603,51230)
order by cd_tip_det_reccon_rec



select * from tip_det_reccon_rec order by cd_tip_det_reccon_rec 
