select * from dbamv.con_Rec a 
inner join dbamv.itcon_rec b on b.cd_con_rec = a.cd_con_rec
inner join dbamv.reccon_rec c on c.cd_itcon_rec = b.cd_itcon_rec
where 1=1
--c.cd_con_cor = 39
and c.dt_recebimento > = '01/11/2016'
and a.cd_processo = 143
and c.tp_recebimento = 4

----


select * from dbamv.lcto_contabil e where e.cd_lote = 50921
and e.cd_lcto_contabil in (15234131,15234130)
/*
 select r.cd_reduzido
    	 , r.cd_setor
  		 , r.vl_rateio 	vl_rateio
   from dbamv.rat_conrec 	r
   where r.cd_con_rec = 429926
  union all
	select r.cd_reduzido
			 , r.cd_setor
			 , r.vl_rateio vl_rateio   
	from dbamv.rat_conrec r
			 , dbamv.itcon_rec i
	where r.cd_con_rec = i.cd_con_rec
	and i.cd_con_rec_agrup = 429926

 select 'x' 
    from dbamv.con_pag con 
    where con.cd_con_rec_prest = 429926*/
