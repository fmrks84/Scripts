/*Somente para a Empresa 7 HSC
status da conta fechada ou aberta*/

select 
dt_lancamento,
cd_remessa,
cd_convenio,
nm_convenio,
cd_reg_fat conta_int,
cd_reg_amb conta_amb,
cd_pro_Fat,
ds_pro_fat,
cd_gru_pro,
ds_gru_pro,
cd_paciente,
cd_atendimento,
nm_paciente,
repasse_consolidado.cd_prestador_repasse,
prestador.nm_prestador nm_prestador_repasse,
repasse_consolidado.cd_prestador,
repasse_consolidado.nm_prestador,
qt_lancamento,
vl_total_conta vl_conta,
vl_repasse,
vl_perc_repasse,
nm_setor

from DBAMV.repasse_consolidado, prestador
where repasse_consolidado.cd_prestador_repasse = prestador.cd_prestador 
and   a.cd_multi_empresa = 7
and   r.cd_pro_fat in ('30909082','30909112','30909015','30909031','30909023','30913144','30913152','31008046','31008020','31008011','31008119','31008038')
and   r.dt_lancamento >= '01/01/2022'

--and   r.cd_atendimento = 4496778 -- ambulat. todas zeradas
and r.cd_reg_fat = 417498 -- unico q tem valor repasse são as contas de intern.
;
