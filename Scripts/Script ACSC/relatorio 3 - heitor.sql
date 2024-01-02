select 
       decode(r.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC') empresa,
       v.cd_Atendimento,
       pct.nm_paciente,
        v.cd_reg_Fat conta,
        'Interno',
        v.acao,
        c.nm_convenio,
       decode(v.tipo_auditoria, 'O', 'Operacional', 'A', 'Auditoria') tipo,
       to_char(f.dt_competencia, 'mm/yyyy') competencia,
       m.ds_motivo_auditoria,
       v.cd_pro_fat,
       p.ds_pro_fat,
       v.dt_lancamento,
       v.qt_lancamento_ant,
       v.qt_lancamento,
       v.vl_percentual_multipla_ant,
       v.vl_percentual_multipla,
       v.vl_total_conta,
       v.vl_total_conta_ant,
       s.nm_setor,
       v.dt_auditoria,
       (v.qt_lancamento - v.qt_lancamento_ant) dif_lan,
       (v.vl_total_conta - v.vl_total_conta_ant) dif_valor   
   
  from dbamv.v_auditoria_itens_ffcv v,
       motivo_auditoria             m,
       convenio                     c,
       pro_fat                      p,
       reg_fat                      r,
       remessa_fatura               re,
       fatura                       f,
       setor                        s,
       gru_fat                      g,
       atendime                     atd,
       paciente                     pct
 where v.cd_motivo_auditoria = m.cd_motivo_auditoria
   and v.cd_convenio = c.cd_Convenio
   and c.cd_convenio = r.cd_convenio
   and v.cd_pro_fat = p.cd_pro_fat
   and v.cd_reg_fat = r.cd_reg_fat
   and r.cd_remessa = re.cd_remessa
   and re.cd_fatura = f.cd_fatura
   and v.cd_setor_produziu = s.cd_setor
   and v.cd_gru_fat = g.cd_gru_fat
   and atd.cd_atendimento = v.cd_atendimento
   and v.cd_atendimento = r.cd_atendimento
   and pct.cd_paciente = atd.cd_paciente
   and v.cd_reg_fat is not null
    and to_char (f.dt_competencia,'yyyy') between '2018' and '2021'
     and r.cd_multi_empresa = 3
    and r.cd_convenio = 261
 
union all

select decode(r.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC') empresa,
       v.cd_Atendimento,
       pct.nm_paciente,
        v.cd_reg_Fat conta,
        'Ambulatorio',
        v.acao,
        c.nm_convenio,
       decode(v.tipo_auditoria, 'O', 'Operacional', 'A', 'Auditoria') tipo,
       to_char(f.dt_competencia, 'mm/yyyy') competencia,
       m.ds_motivo_auditoria,
       v.cd_pro_fat,
       p.ds_pro_fat,
       v.dt_lancamento,
       v.qt_lancamento_ant,
       v.qt_lancamento,
       v.vl_percentual_multipla_ant,
       v.vl_percentual_multipla,
       v.vl_total_conta,
       v.vl_total_conta_ant,
       s.nm_setor,
       v.dt_auditoria,
       (v.qt_lancamento - v.qt_lancamento_ant) dif_lan,
       (v.vl_total_conta - v.vl_total_conta_ant) dif_valor   

  from dbamv.v_auditoria_itens_ffcv v,
       motivo_auditoria             m,
       convenio                     c,
       pro_fat                      p,
       reg_amb                      r,
       remessa_fatura               re,
       fatura                       f,
       setor                        s,
       gru_fat                      g,
       atendime                     atd,
       paciente                     pct
       
 where v.cd_motivo_auditoria = m.cd_motivo_auditoria
   and v.cd_convenio = c.cd_Convenio
   and c.cd_convenio = r.cd_convenio
   and v.cd_pro_fat = p.cd_pro_fat
   and v.cd_reg_amb = r.cd_reg_amb
   and r.cd_remessa = re.cd_remessa
   and re.cd_fatura = f.cd_fatura
    and v.cd_setor_produziu = s.cd_setor
   and v.cd_gru_fat = g.cd_gru_fat
   and v.cd_atendimento = atd.cd_atendimento
   and atd.cd_paciente = pct.cd_paciente
   and v.cd_reg_fat is null
   and to_char(f.dt_competencia,'yyyy') between '2018' and '2021'  
    and r.cd_multi_empresa = 3
    and r.cd_convenio = 261
 
