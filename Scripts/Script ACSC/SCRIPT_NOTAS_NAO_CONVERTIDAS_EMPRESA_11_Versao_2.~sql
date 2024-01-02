select 
'INTERNADO'TIPO_CONTA,
e.dt_atendimento,
a.cd_atendimento,
a.cd_reg_fat CONTA,
case when a.sn_fechada = 'S' THEN 'SIM' ELSE 'NAO' END CONTA_FECHADA,
a.vl_total_conta,
decode (c.tp_quitacao,'C','Comprometido','Q','Quitado',null)TP_QUITACAO,
c.cd_con_rec

from
reg_Fat a 
left join con_Rec b on b.cd_reg_fat = a.cd_reg_fat
left join itcon_Rec c on c.cd_con_rec = b.cd_con_rec
left join nota_Fiscal d on d.cd_nota_fiscal = b.cd_nota_fiscal
inner join atendime e on e.cd_atendimento = a.cd_atendimento
where a.cd_convenio in (307,309)
AND b.cd_nota_fiscal is null

UNION ALL

select 
distinct
'AMB/EXT/URG'TIPO_CONTA,
a4.dt_atendimento,
a2.Cd_Atendimento,
a2.cd_reg_amb CONTA,
case when a2.sn_fechada = 'S' THEN 'SIM' ELSE 'NAO' END CONTA_FECHADA,
a1.vl_total_conta,
decode (a31.tp_quitacao,'C','Comprometido','Q','Quitado',null)TP_QUITACAO,
a31.cd_con_rec
from
reg_amb a1
inner join itreg_amb a2 on a2.cd_reg_amb = a1.cd_reg_amb
left join con_Rec a3 on a3.Cd_Reg_Amb = a2.cd_reg_amb 
left join itcon_Rec a31 on a31.cd_con_rec = a3.cd_con_rec
and a2.Cd_Atendimento = a3.cd_atendimento
inner join atendime a4 on a4.cd_atendimento = a2.cd_atendimento
where a2.cd_convenio in (307,309)
and a3.cd_nota_fiscal is null
order by dt_Atendimento

--select * from nota_fiscal x where x.cd_atendimento = 4363901
