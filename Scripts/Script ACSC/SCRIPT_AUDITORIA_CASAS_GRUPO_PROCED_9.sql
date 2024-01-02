select 'Interno',
       decode(r.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC', 11, 'HMRP') empresa,
       decode(v.tipo_auditoria, 'O', 'Operacional', 'A', 'Auditoria') tipo,
       v.acao,
       v.dt_auditoria,
       m.ds_motivo_auditoria,
       v.cd_usuario_aud,
       d.nm_usuario,
       v.cd_reg_Fat conta,
       v.cd_Atendimento,
       r.cd_remessa,
       to_char(f.dt_competencia,'mm/yyyy') competencia,
    --   to_char(f.dt_competencia,'dd/mm/yyyy')compx,
       c.nm_convenio,
       p.cd_gru_pro,
       g.ds_gru_pro,
       v.cd_pro_fat,
       p.ds_pro_fat,
       v.dt_lancamento,
       v.qt_lancamento_ant,
       v.qt_lancamento,
       (v.qt_lancamento - v.qt_lancamento_ant) dif_lan,
       v.vl_total_conta,
       v.vl_total_conta_ant,
       (v.vl_total_conta - v.vl_total_conta_ant) dif_valor,
       v.vl_percentual_multipla,
       v.vl_percentual_multipla_ant,
       s.nm_setor
     
  from dbamv.v_auditoria_itens_ffcv v,
       motivo_auditoria             m,
       convenio                     c,
       pro_fat                      p,
       reg_fat                      r,
       remessa_fatura               re,
       fatura                       f,
       setor                        s,
       dbasgu.vw_usuarios           d,
       gru_pro                      g
 where v.cd_motivo_auditoria = m.cd_motivo_auditoria
   and v.cd_convenio = c.cd_Convenio
   and v.cd_pro_fat = p.cd_pro_fat
   and v.cd_reg_fat = r.cd_reg_fat
   and r.cd_remessa = re.cd_remessa
   and re.cd_fatura = f.cd_fatura
   and v.cd_usuario_aud = d.cd_usuario
   and v.cd_setor_produziu = s.cd_setor
   and p.cd_gru_pro = g.cd_gru_pro
   and v.cd_reg_fat is not null
   --and f.dt_competencia = '01/09/2022'
  and f.dt_competencia between '01/01/2022' and  '01/11/2022'
  and p.cd_gru_pro in (2,3,4,5,6)
 -- and v.cd_atendimento = 4198862
  and r.cd_multi_empresa in  (3,4,7,10,25)

union all

select 'Ambulatorio',
       decode(r.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC', 11, 'HMRP') empresa,
       decode(v.tipo_auditoria, 'O', 'Operacional', 'A', 'Auditoria') tipo,
       v.acao,
       v.dt_auditoria,
       m.ds_motivo_auditoria,
       v.cd_usuario_aud,
       d.nm_usuario,
       v.cd_reg_amb conta,
       v.cd_Atendimento,
       r.cd_remessa,
       to_char(f.dt_competencia, 'mm/yyyy') competencia,
       c.nm_convenio,
       p.cd_gru_pro,
       g.ds_gru_pro,
       v.cd_pro_fat,
       p.ds_pro_fat,
       v.dt_lancamento,
       v.qt_lancamento_ant,
       v.qt_lancamento,
       (v.qt_lancamento - v.qt_lancamento_ant) dif_lan,
       v.vl_total_conta,
       v.vl_total_conta_ant,
       (v.vl_total_conta - v.vl_total_conta_ant) dif_valor,
       v.vl_percentual_multipla,
       v.vl_percentual_multipla_ant,
       s.nm_setor
  from dbamv.v_auditoria_itens_ffcv v,
       motivo_auditoria             m,
       convenio                     c,
       pro_fat                      p,
       reg_amb                      r,
       remessa_fatura               re,
       fatura                       f,
       setor                        s,
       dbasgu.vw_usuarios           d,
       gru_pro                      g
 where v.cd_motivo_auditoria = m.cd_motivo_auditoria
   and v.cd_convenio = c.cd_Convenio
   and v.cd_pro_fat = p.cd_pro_fat
   and v.cd_reg_amb = r.cd_reg_amb
   and r.cd_remessa = re.cd_remessa
   and re.cd_fatura = f.cd_fatura
   and v.cd_usuario_aud = d.cd_usuario
   and v.cd_setor_produziu = s.cd_setor
   and p.cd_gru_pro = g.cd_gru_pro
   and v.cd_reg_fat is null
   and p.cd_gru_pro in (2,3,4,5,6)

   and f.dt_competencia between '01/01/2022' and  '01/11/2022'
  -- and f.dt_competencia = '01/09/2022'
  and r.cd_multi_empresa in (3,4,7,10,25)

