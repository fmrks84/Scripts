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
    and f.dt_competencia between '01/03/2020' and '01/10/2020'
    and r.cd_multi_empresa = 3
    and p.cd_pro_Fat in ('00071879','90184050','90184076','90184106','90184114','9013667','90184050','90251180','90251180','90131371',
    '90030850','90355962','90344189','90195000','90144333','90144350','90144414','90144406','90144538','90144562','90291980','90144651',
    '90208790','90144686','90020294','90020308','90020359','90020367','90184580','90184599','90020537','90331788','90145127','90348729'
    ,'90348737','90383818','90227190','90255100','90265700','90215508','00039353','00039354','00039355','00039356','00039357',
    '00039358','00039359','90357507','90173392','90255232','90255224','90295897')


--and v.cd_reg_fat = 21901

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
   and r.cd_multi_empresa = 3
   and v.cd_reg_fat is null
   and f.dt_competencia between '01/03/2020' and '01/10/2020'
   and p.cd_pro_fat  in ('00071879','90184050','90184076','90184106','90184114','9013667','90184050','90251180','90251180','90131371',
    '90030850','90355962','90344189','90195000','90144333','90144350','90144414','90144406','90144538','90144562','90291980','90144651',
    '90208790','90144686','90020294','90020308','90020359','90020367','90184580','90184599','90020537','90331788','90145127','90348729'
    ,'90348737','90383818','90227190','90255100','90265700','90215508','00039353','00039354','00039355','00039356','00039357',
    '00039358','00039359','90357507','90173392','90255232','90255224','90295897')
