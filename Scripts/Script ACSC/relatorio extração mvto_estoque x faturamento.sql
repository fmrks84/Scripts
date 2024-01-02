select 
       b.cd_mvto_estoque ,
       b.cd_itmvto_estoque, 
       a.tp_mvto_estoque,
       b.cd_produto, 
       a.hr_mvto_estoque ,
       '<<----  Solicitado ao Estoque'OBSERVACAO_1,
       '---->> Entrada em conta'OBSERVACAO_2, 
       c.cd_pro_fat, 
       d.dt_lancamento ,
       d.cd_reg_fat, 
       d.cd_mvto, 
       rf.sn_fechada 
       
 from mvto_estoque a 
inner join dbamv.itmvto_estoque b on a.cd_mvto_estoque = b.cd_mvto_estoque
inner join dbamv.produto c on c.cd_produto = b.cd_produto
left join dbamv.itreg_Fat d on b.cd_itmvto_estoque = d.cd_itmvto
left join dbamv.reg_Fat rf on rf.cd_reg_fat = d.cd_reg_fat 
where a.cd_atendimento = 2689809
and a.tp_mvto_estoque noT in 'C'
and d.cd_reg_fat is null
order by a.hr_mvto_estoque
;
select * from sys.Reg_Fat_Audit a where a.cd_reg_fat = 293323 order by a.dt_aud desc 
;
select * from itreg_fat where cd_itmvto = 88799865
;
select * from mvto_estoque z
inner join itmvto_estoque z1 on z1.cd_mvto_estoque = z.cd_mvto_estoque
where z.cd_mvto_estoque in (18732151)--cd_atendimento = 2641890 
and z1.cd_produto in (2036124,2007283)
and z.tp_mvto_estoque not in 'C'
order by 1

