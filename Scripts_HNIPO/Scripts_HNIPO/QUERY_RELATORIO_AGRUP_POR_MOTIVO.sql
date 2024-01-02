select 
*
from
(
select to_char(gl.dt_glosa,'MM/RRRR')COMP,
       decode(A.TP_ATENDIMENTO,'U','AMB/PS/EXT','E','AMB/PS/EXT','A','AMB/PS/EXT','I','INTERNO') TP_ATEND,
       cnv.cd_convenio,
       cnv.nm_convenio,
       GL.CD_MOTIVO_GLOSA,
       MG.DS_MOTIVO_GLOSA,
       mg.tp_motivo_glosa,
       mg.tp_repasse_medico,
      sum(GL.QT_GLOSA) qtd_GLOSA,
      sum(GL.QT_REAPRESENTADA) qtd_REAPRESENTADA,
      sum(GL.VL_GLOSA) Vlr_GLOSA,
      sum(GL.VL_REAPRESENTADO) Vlr_REAPRESENTADO

from dbamv.GLOSAS GL
 INNER JOIN DBAMV.MOTIVO_GLOSA MG ON MG.CD_MOTIVO_GLOSA = GL.CD_MOTIVO_GLOSA
 inner join dbamv.pro_fat pf on pf.cd_pro_fat = gl.cd_pro_fat
 INNER JOIN DBAMV.ITREG_FAT IRF ON IRF.CD_REG_FAT = GL.CD_REG_FAT AND IRF.CD_LANCAMENTO = GL.CD_LANCAMENTO_FAT
 inner join dbamv.reg_fat rf on rf.cd_reg_fat = irf.cd_reg_fat
 inner join dbamv.convenio cnv on cnv.cd_convenio = RF.cd_convenio
 INNER JOIN DBAMV.ATENDIME A ON A.CD_ATENDIMENTO = GL.CD_ATENDIMENTO
 INNER JOIN DBAMV.GRU_PRO GP ON GP.CD_GRU_PRO = PF.CD_GRU_PRO
 inner join dbamv.gru_fat gf on gf.cd_gru_fat = GP.CD_GRU_FAT
where  to_char(gl.dt_glosa,'RRRR/mm') between '2021/01' and '2021/09'
group by
       GL.DT_GLOSA,
       decode(A.TP_ATENDIMENTO,'U','AMB/PS/EXT','E','AMB/PS/EXT','A','AMB/PS/EXT','I','INTERNO') ,
       cnv.cd_convenio,
       cnv.nm_convenio,
       GL.CD_MOTIVO_GLOSA,
       MG.DS_MOTIVO_GLOSA,
       mg.tp_motivo_glosa,
       mg.tp_repasse_medico
       
union all

select to_char(gl.dt_glosa,'MM/RRRR')COMP,
       decode(A.TP_ATENDIMENTO,'U','AMB/PS/EXT','E','AMB/PS/EXT','A','AMB/PS/EXT','I','INTERNO') TP_ATEND,
       cnv.cd_convenio,
       cnv.nm_convenio,
       GL.CD_MOTIVO_GLOSA,
       MG.DS_MOTIVO_GLOSA,
       mg.tp_motivo_glosa,
       mg.tp_repasse_medico,
       sum(GL.QT_GLOSA) qtd_GLOSA,
       sum(GL.QT_REAPRESENTADA) qtd_REAPRESENTADA,
--       (sum(GL.QT_GLOSA) - sum(GL.QT_REAPRESENTADA)) dif_qtd,
       sum(GL.VL_GLOSA) Vlr_GLOSA,
       sum(GL.VL_REAPRESENTADO) Vlr_REAPRESENTADO
--       SUM(GL.VL_RECEBIDO) VLR_RECEBIDO
from dbamv.GLOSAS GL
 INNER JOIN DBAMV.MOTIVO_GLOSA MG ON MG.CD_MOTIVO_GLOSA = GL.CD_MOTIVO_GLOSA
 inner join dbamv.pro_fat pf on pf.cd_pro_fat = gl.cd_pro_fat
 INNER JOIN DBAMV.ITREG_AMB IRA ON IRA.CD_REG_AMB = GL.CD_REG_AMB AND IRA.CD_LANCAMENTO = GL.CD_LANCAMENTO_AMB
 inner join dbamv.reg_amb ra on ra.cd_reg_amb = ira.cd_reg_amb
 inner join dbamv.convenio cnv on cnv.cd_convenio = RA.cd_convenio
 INNER JOIN DBAMV.ATENDIME A ON A.CD_ATENDIMENTO = GL.CD_ATENDIMENTO
 INNER JOIN DBAMV.GRU_PRO GP ON GP.CD_GRU_PRO = PF.CD_GRU_PRO
 inner join dbamv.gru_fat gf on gf.cd_gru_fat = GP.CD_GRU_FAT
 where  1 = 1 -- o_char(gl.dt_glosa,'RRRR/MM') between '2021/01' and '2021/09'
group by GL.DT_GLOSA,
       decode(A.TP_ATENDIMENTO,'U','AMB/PS/EXT','E','AMB/PS/EXT','A','AMB/PS/EXT','I','INTERNO') ,
       cnv.cd_convenio,
       cnv.nm_convenio,
       GL.CD_MOTIVO_GLOSA,
       MG.DS_MOTIVO_GLOSA,
       mg.tp_motivo_glosa,
       mg.tp_repasse_medico
) 
where comp = '08/2021'

order by 1
       
