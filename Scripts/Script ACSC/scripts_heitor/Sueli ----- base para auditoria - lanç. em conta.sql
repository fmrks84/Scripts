select distinct decode(r.cd_multi_empresa, 1,'MADRE REGINA PROTMANN', 7, 'HSC', 3, 'CSSJ', 4, 'HST', 10,'HSJ', 25,'HCNSC') empresa,
                r.cd_Atendimento,
                g.cd_aviso_cirurgia,
                r.cd_reg_Fat conta,
                a.dt_atendimento,
                decode (a.tp_atendimento, 'I', 'Internação', 'U', 'Urgência', 'E', 'Externo', 'A', 'Ambulatorio') tp_atendimento,
                c.nm_convenio,
                'INTERNADO' conta,
                r.cd_remessa,
                rf.dt_abertura,
                r.vl_total_conta vl_Faturado,
                r.vl_total_conta,
                r.dt_inicio dt_abertura,
                r.dt_final dt_fechamento,
                a.dt_alta,
                r.sn_fechada,
                i.cd_gru_fat,
                i.cd_pro_fat,
                p.ds_pro_fat,
                g.nr_guia,
                i.vl_unitario,
                i.vl_total_conta valor_total,
                i.dt_lancamento,
                i.qt_lancamento,
                i.vl_percentual_multipla percent,
                i.vl_percentual_paciente percent_PAGO,
                s.nm_setor,
                u.nm_usuario
 from reg_fat r, atendime a, convenio c, itreg_fat i, pro_fat p, guia g, setor s, dbasgu.usuarios u, remessa_fatura rf
 where r.cd_Atendimento = a.cd_atendimento
   and r.cd_Convenio = c.cd_convenio
   and r.cd_reg_fat = i.cd_reg_fat
   and i.cd_pro_fat = p.cd_pro_fat
   and i.cd_guia = g.cd_guia
   and i.cd_setor_produziu = s.cd_setor
   and i.cd_usuario = u.cd_usuario
   and r.cd_remessa = rf.cd_remessa
   and r.cd_convenio <> 1
   and i.cd_gru_fat in (5,9)
   and r.cd_remessa is not null
   and rf.dt_abertura between '01/07/2020' and '30/06/2021'
   and a.cd_multi_empresa in (3,4,7,10,25)
   and i.sn_pertence_pacote = 'N'
   and r.cd_Atendimento in (2856319) --vários avisos de cirurgia x opme (09014956 - não trouxe)


union all

select distinct decode(r2.cd_multi_empresa, 7, 'HSC', 3, 'CSSJ', 4, 'HST', 10,'HSJ', 25,'HCNSC') empresa,
                i.cd_Atendimento,
                g.cd_aviso_cirurgia,
                r2.cd_reg_amb conta,
                a.dt_atendimento,
                decode (a.tp_atendimento, 'I', 'Internação', 'U', 'Urgência', 'E', 'Externo', 'A', 'Ambulatorio') tp_atendimento,
                c.nm_convenio,
                'AMBULATORIAL' conta,
                r2.cd_remessa,
                rf.dt_abertura,
                r2.vl_total_conta vl_Faturado,
                r2.vl_total_conta,
                r2.dt_lancamento dt_abertura,
                r2.dt_lancamento dt_fechamento,
                a.dt_alta,
                r2.sn_fechada,
                i.cd_gru_fat,
                i.cd_pro_fat,
                p.ds_pro_fat,
                g.nr_guia,
                i.vl_unitario,
                i.vl_total_conta valor_total,
                i.hr_lancamento,
                i.qt_lancamento,
                i.vl_percentual_multipla percent,
                i.vl_percentual_paciente percent_PAGO,
                s.nm_setor,
                u.nm_usuario
  from reg_amb r2, atendime a, convenio c, itreg_amb i, pro_fat p, guia g, setor s, dbasgu.usuarios u, remessa_fatura rf
 where i.cd_Atendimento = a.cd_atendimento
   and r2.cd_Convenio = c.cd_convenio
   and r2.cd_reg_amb = i.cd_reg_amb
   and i.cd_pro_fat = p.cd_pro_fat
   and i.cd_guia = g.cd_guia
   and i.cd_setor_produziu = s.cd_setor
   and i.cd_usuario = u.cd_usuario
   and r2.cd_remessa = rf.cd_remessa
   and r2.cd_remessa is not null
   and i.cd_gru_fat in (5,9)
   and r2.cd_convenio <> 1
   and rf.dt_abertura between '01/07/2020' and '30/06/2021'
   and a.cd_multi_empresa in (3,4,7,10,25)
   and i.sn_pertence_pacote = 'N'

   
