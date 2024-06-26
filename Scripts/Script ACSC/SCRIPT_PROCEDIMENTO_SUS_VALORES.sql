select
     
      x.cd_grupo_procedimento,
       x.cd_procedimento,
       x.ds_procedimento,
       vl.dt_vigencia,
       vl.vl_servico_ambulatorial,
       vl.vl_servico_hospitalar,
       vl.vl_servico_profissional,
       vl.vl_total_internacao  ,
       vl.qt_pontos,
       x.sn_ato_anestesico,
       pc.tp_complexidade_procedimento
       
       
       
     
        from procedimento_sus x 
inner join procedimento_sus_valor vl on vl.cd_procedimento = x.cd_procedimento
inner join procedimento_detalhe_vigencia vll on vll.cd_procedimento = x.cd_procedimento
and vll.dt_validade_final is null
and vll.sn_aih_principal = 'S'
inner join procedimento_sus_modalidade pm on pm.cd_procedimento = x.cd_procedimento
and pm.tp_modalidade_atendimento = 'I'
--and vlm.tp_modalidade_atendimento = '1
inner join procedimento_sus_complexidade pc on pc.cd_procedimento = x.cd_procedimento
where x.cd_grupo_procedimento = 04
--and x.cd_procedimento = '0407020446'
AND X.SN_ATIVO = 'S'
--and vl.dt_vigencia = '01/12/2023'
order by vl.cd_procedimento,vl.dt_vigencia desc 
