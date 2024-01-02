/*select distinct 
       a.dt_emissao,
       c.dt_recebimento,
       c.cd_lan_concor,
       c.ds_reccon_rec,
       c.vl_recebido */
select *        from dbamv.con_Rec a ,
              dbamv.itcon_rec b,
              dbamv.reccon_rec c
             
where c.dt_recebimento  between '01/06/2016' and '01/06/2016' --a.cd_con_rec = 368971--c.cd_lan_concor in (73, 80, 11, 688, 665, 673, 668, 691, 696, 532)
--and c.dt_recebimento  between '01/06/2016' and '01/06/2016'
--and a.cd_con_rec = 368971
and a.cd_con_rec = b.cd_con_rec
and b.cd_itcon_rec = c.cd_itcon_rec
and a.nr_documento = c.nr_documento

