--select distinct cd_atendimento, cd_reg_amb from dbamv.itreg_amb where cd_reg_amb in (select cd_reg_amb from dbamv.reg_amb where cd_remessa = 64208)

select * from dbamv.tiss_guia g where g.cd_remessa = 64503
and g.id in (03230890)

--select * from dbamv.carteira c where c.cd_paciente = 450436
