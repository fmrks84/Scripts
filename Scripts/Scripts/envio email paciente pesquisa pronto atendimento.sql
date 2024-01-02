select * from dbamv.mm_pesq_temail a 
where a.informacao not in ('OK')
and trunc (a.data) > = '26/10/2017'
order by a.data desc 
--
--select * from dbamv.Tb_Atendime where cd_atendimento = 1662575--1662572
