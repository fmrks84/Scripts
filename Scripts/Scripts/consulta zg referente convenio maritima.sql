select * from dbamv.paciente c where c.nm_paciente like '%JACQUELINE DE MORAES%'
select * from dbamv.Tb_Atendime d where d.cd_paciente = 669801
select distinct d.cd_atendimento from dbamv.carteira e,
              dbamv.Tb_Atendime d
where e.cd_paciente = d.cd_paciente
and e.cd_paciente = 669801

/*select * from dbamv.tiss_nr_guia a,
select * from dbamv.tiss_guia b where B.ID = '43713553'--b.nm_paciente like '%JACQUELINE DE MORAES%'*/

select * from dbamv.tb_atendime where tb_Atendime.Cd_Atendimento in (1670184,1671876,1672012)

select * from dbamv.reg_fat where Reg_Fat.Cd_atendimento = 1672012
select * from dbamv.itreg_fat where itreg_Fat.Cd_Conta_Pai = 1464370

select * from dbamv.itreg_amb  where cd_atendimento in (1672012)--(1670184,1671876,1672012)
select * from dbamv.reg_amb where reg_amb.cd_reg_amb in (1036170,1037241)
select * from dbamv.tiss_nr_guia where tiss_nr_guia.cd_reg_amb in (1036170,1037241)


select Reg_Fat.Cd_Reg_Fat, reg_Fat.Cd_Convenio , reg_Fat.Cd_Multi_Empresa from dbamv.reg_fat where reg_fat.cd_convenio not in (352)
and Reg_Fat.Cd_atendimento = 1685090--1672012
select * from dbamv.itreg_fat where itreg_Fat.Cd_Conta_Pai = 1496985--1464370

select * from dbamv.tiss_nr_guia where tiss_nr_guia.cd_atendimento = 1672012
select * from dbamv.guia where guia.cd_senha = '6536501'--guia.cd_atendimento = 1672012
