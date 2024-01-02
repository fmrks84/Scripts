
select ''CD_GLOSAS,
       '245'CD_MOTIVO_GLOSA,
       ifn.cd_reg_fat,
       ifn.cd_lancamento_fat,
       ''CD_REG_AMB,
       ''CD_LANCAMENTO_AMB,
       ifn.cd_prestador,
       ifn.cd_ati_med,
       '29/10/2021'DT_GLOSA,
       ifn.qt_itfat_nf qt_glosa,
       ifn.vl_itfat_nf vl_glosa,
        ''VL_REAPRESENTADO,
        ''QT_REAPRESENTADA,
        ''CD_JUSTIFICATIVA_GLOSA,
        ''DT_COMPETENCIA_REAPRESENTA,
        ''DS_COMPLEMENTO_JUSTIFICA,
        ''DT_RECEBIDO,
        ''VL_RECEBIDO,
        ''CD_REMESSA_GLOSA,
        ''VL_BASE_REPASSADO,
        ifn.cd_atendimento,
        ifn.cd_pro_fat,
      --  ''CD_PRO_FAT,
        ''CD_GRU_FAT,
        ''CD_GRU_PRO,
        'N'SN_FINANCEIRO,
        ''CD_GLOSAS_PAI,
        ''DS_OBSERVACAO,
        '1'CD_MULTI_EMPRESA,
        ''VL_RECURSO_REPASSADO,
        ''CD_USUARIO,
        ''VL_GLOSA_PRE_ACEITA,
        ''SN_EM_ANALISE,
        ifn.cd_setor,
        ''ID_IT_ENVIO,
        JU.CD_ITFAT_NF,
        ''CD_CHECK,
        ''CD_SETOR_APOIO,
        ''CD_MOTIVO_ACEITE,
        ''CD_MOTIVO_RECURSO_GLOSA,
        ''CD_JUSTIFICA_RECURSO_GLOSA,
        ''DS_OBSERVACAO_RECURSO,
        ''DS_JUSTIFICA_ACEITE,
        ''CD_GLOSA_CONVENIO
        
    
        from  dbamv.it_recebimento ju 
 inner join dbamv.itfat_nota_fiscal ifn  on ifn.cd_itfat_nf = ju.cd_itfat_nf       
        where ju.cd_reccon_rec in (1431941)
       
and ju.vl_glosa not in (0,00)
and ju.cd_itfat_nf in (select p.cd_itfat_nf from itfat_nota_fiscal p where p.cd_reg_fat = 235091)
order by JU.CD_ITFAT_NF
