/*select * from dbamv.Mvto_Estoque a 
inner join dbamv.itmvto_estoque b on b.cd_mvto_estoque = a.cd_mvto_estoque
--and a.cd_usuario = 'ANDBISPO'
--and a.cd_usuario_entrega = 'ANDBISPO'
--and b.cd_produto in (4091,4094,53395)
and a.dt_mvto_estoque between '01/03/2017' and '31/03/2017'
*/


select * from dbamv.solsai_pro c 
inner join dbamv.itsolsai_pro d on c.cd_solsai_pro = d.cd_solsai_pro
and c.cd_usuario = 'ANDBISPO'
and c.dt_solsai_pro between '01/03/2017' and '07/04/2017'
--and c.tp_solsai_pro = 'S'
--and c.tp_situacao = 'S'
--and d.cd_produto in (4091,4094,53395)
order by c.dt_solsai_pro

