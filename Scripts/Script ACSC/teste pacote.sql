select * from dbamv.exa_rx a where a.exa_rx_cd_pro_fat = 40201120

select B.CD_REG_AMB from 
dbamv.itreg_amb b 
inner join dbamv.atendime c on c.cd_atendimento = b.Cd_Atendimento
where b.sn_fatura_impressa = 'N'
AND B.Cd_Convenio = 7
and c.tp_atendimento = 'E'
order by b.hr_lancamento desc 


delete from dbamv.itreg_fat where cd_Reg_Fat = 280125
and cd_pro_fat in (00086582,00263989,90222407)
