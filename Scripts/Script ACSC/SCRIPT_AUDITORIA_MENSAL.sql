select 
*
from
(
select 'Interno'TIPO_ATEND,
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
  and to_char(f.dt_competencia,'mm/yyyy') = '07/2023'-- between '05/2023' and '06/2023'
 -- and v.cd_convenio in (7,641)
 --and v.cd_atendimento = 4813316
-- and r.cd_reg_fat = 557377 
-- and  v.cd_pro_fat = 10001123
  -- and r.cd_multi_empresa = 7

union all

select 'Ambulatorio'TIPO_ATEND ,
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
   and to_char(f.dt_competencia,'mm/yyyy') = '07/2023' ---between '05/2023' and '06/2023'
  -- and f.dt_competencia = '01/09/2022'
  -- and r.cd_multi_empresa =7
  -- AND v.cd_convenio in (7,641)
)--where cd_pro_Fat = '10001661'
--and acao = 'E'
order by competencia,cd_atendimento

/*

select X.acao,
       X.dt_auditoria,
       X.cd_mvto,
       X.tp_mvto,
       X.cd_usuario_aud,
       us.NM_USUARIO,
       X.cd_reg_fat,
       X.cd_pro_fat
 from dbamv.v_auditoria_itens_ffcv x 
 inner join dbasgu.vw_usuarios us on us.CD_USUARIO = x.cd_usuario_aud
 where X.cd_reg_fat = 552236  AND x.cd_PRO_FAT IN ('00032692')--x.cd_atendimento =  4756580
and x.acao = 'E'


---select * from atendime where cd_atendimento = 4744688

select * from itreg_fat where cd_reg_fat = 535371 and cd_pro_Fat = 60001959
delete from itlan_med where cd_reg_fat = 535371 and cd_lancamento = 193 

select * from val_pro where cd_pro_fat = '60001959'

select cd_Reg_fat,hr_lancamento,qt_lancamento,cd_pro_fat,cd_usuario from itreg_fat where cd_reg_Fat = 552236 and cd_pro_fat = '00032692'
*/
