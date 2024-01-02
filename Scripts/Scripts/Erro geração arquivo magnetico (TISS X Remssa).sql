delete dbamv.tiss_nr_guia where cd_atendimento in (select cd_atendimento from dbamv.reg_fat where cd_remessa = 51734 )

delete dbamv.tiss_nr_guia where cd_atendimento in (select cd_atendimento from dbamv.itreg_amb where cd_reg_amb IN ( SELECT cd_reg_amb FROM dbamv.reg_amb WHERE cd_remessa = 51734 )
