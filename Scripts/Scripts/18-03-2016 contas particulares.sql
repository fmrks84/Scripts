select distinct r.cd_atendimento ATENDIMENTO,
       p.nm_paciente PACIENTE,
       a.DT_ATENDIMENTO,
       a.DT_ALTA,
       p.nr_identidade DOCUMENTO,
       A.CD_CONVENIO AS CONVENIO_ATENDIMENTO,
       R.CD_CONVENIO AS CONVENIO_PARTICULAR,
       decode (c.nm_convenio, 'PARTICULAR - SANTA JOANA', 'PARTICULAR','PARTICULAR - PROMATRE','PARTICULAR') CONVENIO,
       a.CD_CON_PLA,
       decode(cp.ds_con_pla, 'PARTICULAR - PROMATRE','PARTICULAR','PARTICULAR - SANTA JOANA','PARTICULAR','PARTICULAR - NEGATIVA CONVENIO','NEGATIVA','EMPRESA  BUPA','EMPRESA  BUPA','PARTICULAR-NEGATIVA SECRETARIA','NEGATIVA')PLANO,
       pr.nm_prestador PRESTADOR,
       A.CD_PRO_INT,
       PRO.DS_PRO_FAT PROCEDIMENTO,
       sum(r.Vl_Total_Conta) VALOR,
       decode(it.tp_quitacao, 'C', 'COMPROMETIDO', 'Q','QUITADO','P','PARCIALMENTE QUITADO', 'V','PREVISTO') AS TP_QUITACAO,
       A.CD_MULTI_EMPRESA EMPRESA
  from dbamv.atendime  a,
       dbamv.paciente  p,
       dbamv.reg_fat   r,
       dbamv.prestador pr,
       dbamv.con_rec   cr,
       dbamv.itcon_rec it,
       dbamv.convenio  c,
       dbamv.con_pla   cp,
       DBAMV.PRO_FAT PRO
 where r.cd_atendimento = a.CD_ATENDIMENTO
   and a.CD_PACIENTE = p.cd_paciente
   and r.CD_CONVENIO = c.cd_convenio
   and it.cd_con_rec = cr.cd_con_rec
   AND r.cd_reg_fat = cr.cd_reg_fat
   and a.CD_CON_PLA = cp.cd_con_pla
   and cp.cd_convenio = c.cd_convenio
   AND A.CD_PRO_INT = PRO.CD_PRO_FAT
   --and r.cd_atendimento = 1235475
 --  AND A.CD_MULTI_EMPRESA = 1
   and a.CD_PRESTADOR = pr.cd_prestador
   --and r.sn_fechada = 'S'
  -- AND a.dt_atendimento BETWEEN '01/02/2016' AND '29/02/2016'
 -- and r.cd_convenio in(352,379)
  -- and a.cd_convenio = 352
   --and c.tp_convenio = 'P'
   and r.vl_total_conta <> '0'
 GROUP BY r.cd_atendimento,
          p.nm_paciente,
          a.DT_ATENDIMENTO,
          a.DT_ALTA,
          A.CD_CONVENIO,
          R.CD_CONVENIO,
          c.nm_convenio,
          P.nr_identidade,
          A.CD_MULTI_EMPRESA,
          a.CD_CON_PLA,
          cp.ds_con_pla,
          it.tp_quitacao,
          A.CD_PRO_INT,
          PRO.DS_PRO_FAT,
          pr.nm_prestador
