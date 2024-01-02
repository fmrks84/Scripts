SELECT     DISTINCT(cr.cd_atendimento)                                             atendimento,
           p.cd_paciente                                                           matricula,
           cr.NM_CLIENTE                                                           nome,
           fn_idade(p.DT_NASCIMENTO)                                               idade,
           decode(p.NR_CPF,
                  NULL,
                  NULL,
                  translate(to_char(p.NR_CPF / 100, '000,000,000.00'), ',.', '.-'))CPF_paciente,
           To_Char(p.DT_NASCIMENTO, 'dd/mm/yyyy')                                  Data_Nasc_Paciente,
           c.nm_convenio                                                           Convenio,
           rr.nm_responsavel                                                       Responsavel,
           decode(r.NR_CPF,
                  NULL,
                  NULL,
                  translate(to_char(r.NR_CPF / 100, '000,000,000.00'), ',.', '.-'))CPF_Responsavel,
           To_Char(r.DT_NASCIMENTO, 'dd/mm/yyyy')                                  Data_Nasc_Resposnavel,
           To_Char(rr.DT_RECEBIMENTO, 'dd/mm/yyyy')                                Recebimento--,
         --rr.vl_recebido                                                          Valor
FROM       reccon_rec rr,
           itcon_rec ir,
           con_rec cr,
           atendime a,
           paciente p,
           responsavel r,
           convenio c
WHERE      cr.cd_con_rec = ir.cd_con_rec
           AND cr.cd_atendimento = a.CD_ATENDIMENTO
           AND a.CD_PACIENTE = p.CD_PACIENTE
           AND r.CD_RESPOSAVEL = rr.CD_RESPOSAVEL
           AND ir.cd_itcon_rec = rr.cd_itcon_rec
           AND c.cd_convenio = a.cd_convenio
           AND cr.tp_con_rec = 'P'
           AND r.SN_ATIVO = 'S'
           AND r.TP_RESPONSAVEL = 'F'
           AND c.cd_convenio IN (40)
           AND fn_idade(p.DT_NASCIMENTO) > 15
           AND To_Char(rr.dt_recebimento,'yyyy') = '2016'
           AND (       p.NR_CPF IS NULL
                       OR r.NR_CPF IS NULL
                       OR r.DT_NASCIMENTO IS NULL
                       OR p.DT_NASCIMENTO IS NULL
               )
ORDER BY   SubStr(Recebimento,7,4) DESC,
           SubStr(Recebimento,4,2) DESC,
           SubStr(Recebimento,1,2) DESC,
           cr.NM_CLIENTE ASC,
           atendimento DESC,
           Responsavel ASC
