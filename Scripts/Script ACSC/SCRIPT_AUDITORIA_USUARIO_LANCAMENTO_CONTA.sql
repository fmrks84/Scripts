/*INTERNO*/  
select distinct
       decode(v.tipo_auditoria, 'O', 'Operacional', 'A', 'Auditoria') tipo,
       v.cd_Atendimento,
       v.cd_reg_fat conta,
       c.nm_convenio,
       v.cd_gru_fat,
       g.ds_gru_fat,
       v.dt_lancamento,
       v.cd_pro_fat,
       p.ds_pro_fat,
       v.dt_auditoria,
       v.qt_lancamento_ant,
       v.qt_lancamento,
       v.vl_percentual_multipla,
       v.vl_percentual_multipla_ant,
       m.ds_motivo_auditoria,
       v.cd_usuario_aud,
       d.nm_usuario
  from dbamv.v_auditoria_itens_ffcv v,
       motivo_auditoria             m,
       convenio                     c,
       pro_fat                      p,
       reg_fat                      r,
       gru_fat                      g,
       setor                        s,
       dbasgu.vw_usuarios           d
where v.cd_motivo_auditoria = m.cd_motivo_auditoria
   and v.cd_convenio = c.cd_Convenio
   and v.cd_pro_fat = p.cd_pro_fat
   and v.cd_reg_fat = r.cd_reg_fat
   and g.cd_gru_fat = v.cd_gru_fat
   and v.cd_usuario_aud = d.cd_usuario
   and v.cd_reg_fat in (483695)
  -- and v.cd_gru_fat = 7
   --and v.cd_pro_fat in ('31602118')
  -- and m.ds_motivo_auditoria = 'LANCAMENTO MANUAL'  
  -- and v.dt_auditoria between To_Date ('01/09/2022','dd/mm/yyyy') AND To_Date ('30/09/2022','dd/mm/yyyy')
   -- and r.cd_multi_empresa = 7
   -- and v.cd_usuario_aud = 'LHAMZI'
   order by 10 desc
   



;
/*EXTERNO*/
select distinct
       decode(v.tipo_auditoria, 'O', 'Operacional', 'A', 'Auditoria') tipo,
       v.cd_Atendimento,
       v.cd_reg_amb conta,
       c.nm_convenio,
       v.cd_gru_fat,
       g.ds_gru_fat,
       v.dt_lancamento,
       v.cd_pro_fat,
       p.ds_pro_fat,
       v.dt_auditoria,
       v.qt_lancamento_ant,
       v.qt_lancamento,
       v.vl_unitario,
       m.ds_motivo_auditoria,
       v.cd_usuario_aud,
       d.nm_usuario
  from dbamv.v_auditoria_itens_ffcv v,
       motivo_auditoria             m,
       convenio                     c,
       pro_fat                      p,
       reg_amb                      r,
       gru_fat                      g,
       setor                        s,
       dbasgu.vw_usuarios           d
where v.cd_motivo_auditoria = m.cd_motivo_auditoria
   and v.cd_convenio = c.cd_Convenio
   and v.cd_pro_fat = p.cd_pro_fat
   and v.cd_reg_amb = r.cd_reg_amb
   and g.cd_gru_fat = v.cd_gru_fat
   and v.cd_usuario_aud = d.cd_usuario
   and v.cd_setor_produziu = s.cd_setor
--   and m.ds_motivo_auditoria <> 'LANCAMENTO MANUAL'
   and v.cd_reg_amb in (483695)  
  -- and v.cd_Atendimento = 3229511
;

--tem menu de contexto
