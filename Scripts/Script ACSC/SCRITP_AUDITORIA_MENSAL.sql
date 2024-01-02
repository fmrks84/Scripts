select 
*
from
(
select 'Interno'TIPO_ATEND,
       r.cd_multi_empresa empresa,
       decode(v.tipo_auditoria, 'O', 'Operacional', 'A', 'Auditoria') tipo,
       v.acao,
       v.dt_auditoria,
       m.ds_motivo_auditoria,
       v.cd_usuario_aud,
       d.nm_usuario,
       v.cd_reg_Fat conta,
       v.cd_Atendimento,
       r.cd_remessa,
       to_char(f.dt_competencia, 'mm/yyyy') competencia,
    --   to_char(f.dt_competencia,'dd/mm/yyyy')compx,
       c.cd_convenio,
       c.nm_convenio,
       p.cd_gru_pro,
       g.ds_gru_pro,
       v.cd_gru_fat,
       gf.ds_gru_fat,
       v.cd_pro_fat,
       p.ds_pro_fat,
       v.cd_prestador,
       prt.nm_prestador,
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
       gru_pro                      g,
       prestador                    prt,
       gru_fat                      gf
 where v.cd_motivo_auditoria = m.cd_motivo_auditoria
   and v.cd_convenio = c.cd_Convenio
   and v.cd_pro_fat = p.cd_pro_fat
   and v.cd_reg_fat = r.cd_reg_fat
   and r.cd_remessa = re.cd_remessa
   and re.cd_fatura = f.cd_fatura
   and v.cd_usuario_aud = d.cd_usuario
   and v.cd_setor_produziu = s.cd_setor
   and p.cd_gru_pro = g.cd_gru_pro
   and v.cd_prestador = prt.cd_prestador(+)
   and v.cd_gru_fat = gf.cd_gru_fat
   and v.cd_reg_fat is not null
   --and f.dt_competencia = '01/09/2022'
  and to_char(f.dt_competencia,'mm/yyyy') = '11/2023'-- between '05/2023' and '06/2023'
 -- and v.cd_convenio in (7,641)
 --and v.cd_atendimento = 4813316
-- and r.cd_reg_fat = 557377 
-- and  v.cd_pro_fat = 10001123
  -- and r.cd_multi_empresa = 7

union all

select 'Ambulatorio'TIPO_ATEND ,
       r.cd_multi_empresa  empresa,
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
       c.cd_convenio,
       c.nm_convenio,
       p.cd_gru_pro,
       g.ds_gru_pro,
       v.cd_gru_fat,
       gf.ds_gru_fat,
       v.cd_pro_fat,
       p.ds_pro_fat,
       v.cd_prestador,
       prts.nm_prestador,
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
       gru_pro                      g,
       prestador                    prts,
       gru_fat                      gf
 where v.cd_motivo_auditoria = m.cd_motivo_auditoria
   and v.cd_convenio = c.cd_Convenio
   and v.cd_pro_fat = p.cd_pro_fat
   and v.cd_reg_amb = r.cd_reg_amb
   and r.cd_remessa = re.cd_remessa
   and re.cd_fatura = f.cd_fatura
   and v.cd_usuario_aud = d.cd_usuario
   and v.cd_setor_produziu = s.cd_setor
   and p.cd_gru_pro = g.cd_gru_pro
   and prts.cd_prestador = v.cd_prestador(+)
   AND v.cd_gru_fat = gf.cd_gru_fat
   and v.cd_reg_fat is null
 --  and v.cd_atendimento = 4813316
  --AND V.cd_reg_amb = 557377 
  -- and  v.cd_pro_fat = 552236
   and to_char(f.dt_competencia,'mm/yyyy') = '11/2023' ---between '05/2023' and '06/2023'
  -- and f.dt_competencia = '01/09/2022'
  -- and r.cd_multi_empresa =7
  -- AND v.cd_convenio in (7,641)
)--where cd_pro_Fat = '10001661'
--and acao = 'E'
order by competencia,cd_atendimento

