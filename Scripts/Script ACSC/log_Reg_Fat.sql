select * from dbamv.reg_Fat where cd_Atendimento = 4577189--cd_reg_Fat in (505295);
select * from sys.itreg_fat_audit a where  a.cd_reg_Fat in (575817)order by a.dt_aud desc ---(304957)

select * from sys.itreg_amb_audit b where b.cd_reg_amb = (mento = 3998547  order by c.dt_aud desc ---and c.o_cd_pro_fat = 28458391-- c.n_cd_gru_fat = 6--c.cd_reg_amb = 505295    --and (c.o_cd_pro_fat = 00115140 or c.n_cd_pro_fat = 00115140) order by c.dt_aud desc 
select * from itreg_amb where cd_reg_amb = 1849635 --


select * from regra_substituicao_proced z where z.cd_pro_fat in  (40304108,40304280,40304299)


select * from sys.itreg_fat_audit x where  x.cd_reg_Fat in (577585)--,479796)--(304957)

select * from sys.reg_fat_audit where /*o_cd_atendimento = 4688994 and*/ cd_reg_Fat = 5283659   order by dt_aud desc 

select * from sys.itreg_fat_audit where cd_lancamento = 131

select * from dbamv.v_auditoria_itens_ffcv v where v.cd_reg_fat = 577585  and v.acao = 'E' and v.cd_gru_fat = 7 --and v.cd_pro_fat = 81029322-v.cd_reg_amb = 3318567 --v.cd_reg_fat = 483695
select * from auditoria_conta t where t.cd_reg_fat = 422464 -- and t.cd_pro_fat = 30904170 

select * from atendime where cd_atendimento = 4577189

select * from pro_Fat where cd_pro_Fat = '41101014'
select * from ped_rx where cd_atendimento = 4577189
select * from ped_lab where cd_atendimento = 4577189

select * from auditoria_conta aud where aud.cd_reg_fat = 425573 order by aud.cd_gru_fat --and aud.cd_pro_fat = '78363403'--aud.cd_auditoria_conta = 20659516

select * from dbasgu.vw_usuarios us where us.CD_USUARIO = 'DALMEIDA'
select * from audit_dbamv.itreg_fat itr where itr.cd_reg_fat = 422464  and itr.cd_pro_fat = 78363403

select * from itreg_fat where cd_reg_fat = 575817-- and cd_pro_Fat = cd_lancamento = 48

select * from dbamv.reg_Fat where cd_atendimento = 5092272
select * from log_falha_importacao lg where lg.cd_reg_fat = 575817


select * from atendime atd where atd.cd_atendimento = 5203461 ;
select * from mvto_estoque mvt 
inner join itmvto_estoque imvt on imvt.cd_mvto_estoque = mvt.cd_mvto_estoque
where mvt.cd_atendimento = 5203461
and imvt.cd_produto = 55604;



select * from regra_substituicao_proced rl where rl.cd_pro_fat = 78363403
select * from aviso_cirurgia cir where cir.cd_atendimento = 3828452
select * from reg_Fat where cd_reg_fat = 422464
select * from itreg_fat where cd_reg_Fat = 422464 and cd_mvto = '280274'
