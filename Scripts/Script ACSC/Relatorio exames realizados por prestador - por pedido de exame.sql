select 
atend.cd_ori_ate cd_origem_atendimento,
oat.ds_ori_ate ds_origem_atendimento,
pct.nm_paciente ,
atend.cd_atendimento,
prx.cd_ped_rx codigo_pedido,
prx.dt_pedido,
atend.cd_convenio,
conv.nm_convenio,
iprx.cd_exa_rx cod_exame,
erx.ds_exa_rx nm_exame,
iprx.cd_prestador,
prest.nm_prestador

from 
atendime atend 
inner join ori_ate oat on oat.cd_ori_ate = atend.cd_ori_ate
inner join paciente pct on pct.cd_paciente = atend.cd_paciente
inner join convenio conv on conv.cd_convenio = atend.cd_convenio
inner join ped_rx prx on prx.cd_atendimento = atend.cd_atendimento

inner join itped_rx iprx on iprx.cd_ped_rx = prx.cd_ped_rx 
inner join exa_Rx erx on erx.cd_exa_rx = iprx.cd_exa_rx
inner join prestador prest on prest.cd_prestador = iprx.cd_prestador
where prx.dt_pedido between '01/01/2021' and sysdate 
and iprx.cd_prestador in (1937,189)
and iprx.cd_exa_rx in (1045,1047)
order by 
atend.cd_ori_ate,
prx.dt_pedido



