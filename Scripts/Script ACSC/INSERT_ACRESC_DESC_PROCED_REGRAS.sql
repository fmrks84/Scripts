insert into dbamv.acresc_descontos_proc  (cd_pro_fat,
                                      cd_regra,
                                      vl_perc_acrescimo,
                                      vl_perc_desconto,
                                      tp_atend_ambulatorial,
                                      tp_atend_externo,
                                      tp_atend_internacao,
                                      tp_atend_urgeme,
                                      ds_desconto,
                                      ds_acrescimo,
                                      sn_vl_filme,
                                      sn_vl_honorario,
                                      sn_vl_operacional,
                                      tp_atend_homecare,
                                      sn_destacar_na_fatura,
                                      vl_perc_acrescimo_exame,
                                      ds_acrescimo_exame,
                                      dt_inicio_vigencia,
                                      dt_final_vigencia)
(select 
                                      cd_pro_fat,
                                      353,
                                      vl_perc_acrescimo,
                                      vl_perc_desconto,
                                      tp_atend_ambulatorial,
                                      tp_atend_externo,
                                      tp_atend_internacao,
                                      tp_atend_urgeme,
                                      ds_desconto,
                                      ds_acrescimo,
                                      sn_vl_filme,
                                      sn_vl_honorario,
                                      sn_vl_operacional,
                                      tp_atend_homecare,
                                      sn_destacar_na_fatura,
                                      vl_perc_acrescimo_exame,
                                      ds_acrescimo_exame,
                                      '01/03/2024',
                                      dt_final_vigencia
                                      from dbamv.acresc_descontos_proc
                                      where cd_regra = 334
                                      and dt_final_vigencia is null)
                                    
                                      
                                      
                              
                                      
--select * from dbamv.acresc_descontos_proc where cd_Regra = 353 and dt_inicio_vigencia = '01/03/2024'                    
                                      
