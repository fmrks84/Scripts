select a.Cd_Atendimento,a.sn_fechada , a.cd_reg_fat, a.cd_conta_pai , a.cd_remessa , a.cd_multi_empresa from dbamv.reg_Fat a where a.cd_atendimento in (1509476
,1512990
,1507157
,1505211
,1505226
,1507967
,1512182
,1507197
,1491593
,1502269)
order by a.cd_atendimento
