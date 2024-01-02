select atend.cd_atendimento,
       rf.cd_reg_fat,
       rf.sn_fechada,
       rf.cd_remessa,
       conv.cd_convenio,
       conv.nm_convenio,
       g.nr_guia,
       g.cd_senha senha_autorizacao,
     --  irf.nr_guia_envio,
       rf.dt_inicio,
       rf.dt_final,
       rf.vl_total_conta ,
       irf.cd_pro_fat Cod_procedimento,
       irf.qt_lancamento qt_Proced_lanc_conta,
       irf.vl_total_conta VL_TOTAL_PROCEDIMENTO
       

from 
reg_fat rf
inner join itreg_Fat irf on irf.cd_reg_fat = rf.cd_reg_fat
inner join atendime atend on atend.cd_atendimento = rf.cd_atendimento
inner join convenio conv on conv.cd_convenio = rf.cd_convenio
inner join guia g on g.cd_guia = atend.cd_guia
where trunc(atend.dt_atendimento) between '01/01/2020' and '07/01/2021'
and irf.cd_pro_Fat in ('90184050','90184076')
and atend.cd_multi_empresa = 10
and conv.tp_convenio = 'C'
order by atend.dt_atendimento 
--atend.cd_atendimento, conv.cd_convenio




/*select cd_guia from dbamv.atendime where cd_atendimento = 2187173
select * from dbamv.guia where cd_atendimento = 2187173*/
