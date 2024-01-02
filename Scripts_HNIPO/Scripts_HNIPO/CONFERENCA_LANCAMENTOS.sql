select b.cd_pro_fat,
       b.dt_lancamento,
       a.cd_atendimento,
       a.cd_reg_fat conta,
       f.nm_paciente,
       b.qt_lancamento,
       b.vl_unitario,
      case when c.vl_ato is null then (b.qt_lancamento * b.vl_unitario) else c.vl_ato end vl_total,
      case when c.cd_prestador  is null then b.cd_prestador else c.cd_prestador end cd_prestador,
      case when c.cd_ati_med is null then b.Cd_Ati_Med else c.Cd_Ati_Med end cd_ati_med
        from reg_fat a
inner join itreg_fat b on b.cd_reg_fat = a.cd_reg_fat
left join itlan_med c on c.cd_reg_fat = b.cd_reg_fat
                       and c.cd_lancamento = b.cd_lancamento
inner join pro_fat d on d.cd_pro_fat = b.cd_pro_fat
inner join  atendime e on e.cd_atendimento = a.cd_atendimento
inner join paciente f on f.cd_paciente = e.cd_paciente
inner join remessa_fatura g on g.cd_remessa = a.cd_remessa
inner join fatura h on h.cd_fatura = g.cd_fatura
where to_char(h.dt_competencia,'MM/YYYY') = '06/2022' 
and b.sn_pertence_pacote = 'N'
and b.cd_setor = 6
--order by f.nm_paciente

union all

select 
a2.cd_pro_fat,
a1.dt_lancamento,
a2.cd_atendimento,
a2.cd_reg_amb conta,
a5.nm_paciente,
a2.qt_lancamento,
a2.vl_unitario,
(a2.qt_lancamento * a2.vl_unitario)vl_total,
a2.cd_prestador,
a2.cd_ati_med
from 
reg_amb a1
inner join itreg_amb a2 on a2.cd_reg_amb = a1.cd_reg_amb
inner join pro_fat a3 on a3.cd_pro_fat = a2.cd_pro_fat
inner join atendime a4 on a4.cd_atendimento = a2.cd_atendimento
inner join paciente a5 on a5.cd_paciente = a4.cd_paciente
inner join remessa_fatura a6 on a6.cd_remessa = a1.cd_remessa
inner join fatura a7 on a7.cd_fatura = a6.cd_fatura
where to_char(a7.dt_competencia,'MM/YYYY') = '06/2022'
and a2.sn_pertence_pacote = 'N'
and a2.cd_setor = 6
order by nm_paciente

--and a2.cd_reg_amb = 7791085



--)
--select * from itreg_fat where cd_reg_fat = 260048 order by 3 desc 
--select * from itlan_med x where x.cd_reg_fat = 260048
