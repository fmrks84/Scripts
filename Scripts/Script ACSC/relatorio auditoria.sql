select 'Interno',
       decode(r.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC') empresa,
       decode(v.tipo_auditoria, 'O', 'Operacional', 'A', 'Auditoria') tipo,
       v.acao,
       v.dt_auditoria,
       m.ds_motivo_auditoria,
       v.cd_reg_Fat conta,
       v.cd_Atendimento,
       r.cd_remessa,
       to_char(f.dt_competencia, 'mm/yyyy') competencia,
       to_char(r.dt_fechamento,'mm/yyyy')mes_conta_faturada, ---
       c.nm_convenio,
       v.cd_gru_fat,
       g.ds_gru_fat,
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
       gru_fat                      g          
 where v.cd_motivo_auditoria = m.cd_motivo_auditoria
   and v.cd_convenio = c.cd_Convenio
   and v.cd_pro_fat = p.cd_pro_fat
   and v.cd_reg_fat = r.cd_reg_fat
   and r.cd_remessa = re.cd_remessa
   and re.cd_fatura = f.cd_fatura
   and v.cd_setor_produziu = s.cd_setor
   and v.cd_gru_fat = g.cd_gru_fat
   and v.cd_reg_fat is not null
  --  and to_char (f.dt_competencia,'yyyy') = '2020'
    and f.dt_competencia = '01/03/2021'
  -- and r.cd_multi_empresa = 3
   /*and v.cd_pro_fat in ('90208790','90184599','90184580','00039353','00039354','00039355','00039356','00039357','00039358','00039359','90030850','90344189','90144414','90184050','90173392','90215508','90184106','90184114','90251180','90020294',
'90291980','90144406','90383818','90295897','90144333','90144350','90255100','90255232','90255224','90348729','90348737','90136675','90145127','90184076','90144686','00071879','90357507','90331788','90020359','90020367','90020537','90265700',
'90131371','90144562','90020308','90227190','90195000','90144651','90355962','90144538','90404777','90144376','90144384','90230280','90144228','90144236','90144457','90144473','90144490','90145143','90145151','90489250','90203135','90265670')*/
union all

select 'Ambulatorio',
       decode(r.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC') empresa,
       decode(v.tipo_auditoria, 'O', 'Operacional', 'A', 'Auditoria') tipo,
       v.acao,
       v.dt_auditoria,
       m.ds_motivo_auditoria,
       v.cd_reg_amb conta,
       v.cd_Atendimento,
       r.cd_remessa,
       to_char(f.dt_competencia, 'mm/yyyy') competencia,
       to_char(r.dt_fechamento,'mm/yyyy')mes_faturamento,
       c.nm_convenio,
       v.cd_gru_fat,
       g.ds_gru_fat,
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
       gru_fat                      g
 where v.cd_motivo_auditoria = m.cd_motivo_auditoria
   and v.cd_convenio = c.cd_Convenio
   and v.cd_pro_fat = p.cd_pro_fat
   and v.cd_reg_amb = r.cd_reg_amb
   and r.cd_remessa = re.cd_remessa
   and re.cd_fatura = f.cd_fatura
    and v.cd_setor_produziu = s.cd_setor
   and v.cd_gru_fat = g.cd_gru_fat
   and v.cd_reg_fat is null
   --and to_char(f.dt_competencia,'yyyy') = '2020'  --f.dt_competencia = '01/02/2021'
   and f.dt_competencia = '01/03/2021'
  -- and r.cd_multi_empresa = 3
  /* and v.cd_pro_fat in ('90208790','90184599','90184580','00039353','00039354','00039355','00039356','00039357','00039358','00039359','90030850','90344189','90144414','90184050','90173392','90215508','90184106','90184114','90251180','90020294',
'90291980','90144406','90383818','90295897','90144333','90144350','90255100','90255232','90255224','90348729','90348737','90136675','90145127','90184076','90144686','00071879','90357507','90331788','90020359','90020367','90020537','90265700',
'90131371','90144562','90020308','90227190','90195000','90144651','90355962','90144538','90404777','90144376','90144384','90230280','90144228','90144236','90144457','90144473','90144490','90145143','90145151','90489250','90203135','90265670')
*/
