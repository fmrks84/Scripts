select cd_registro_documento
          ,ds_resposta
          ,to_date(dt_informada, 'dd/mm/yyyy') dt_informada
          ,cd_multi_empresa
      from (select r.cd_registro_documento
                  ,max(decode(cd_pergunta_doc, 19093, substr(rtrim(ltrim(rr.ds_resposta)), 0, 500), 
                                               19095, substr(rtrim(ltrim(rr.ds_resposta)), 0, 500),
                                               19017, substr(rtrim(ltrim(rr.ds_resposta)), 0, 500),
                                               38403, substr(rtrim(ltrim(rr.ds_resposta)), 0, 500),
                                               38404, substr(rtrim(ltrim(rr.ds_resposta)), 0, 500),
                                               38406, substr(rtrim(ltrim(rr.ds_resposta)), 0, 500),
                                               38407, substr(rtrim(ltrim(rr.ds_resposta)), 0, 500),
                                               40302, substr(rtrim(ltrim(rr.ds_resposta)), 0, 500),
                                               40542, substr(rtrim(ltrim(rr.ds_resposta)), 0, 500),
                                               '')) ds_resposta
                  ,max(decode(cd_pergunta_doc, 1988, substr(rtrim(ltrim(rr.ds_resposta)), 0, 10), 
                                               5946, substr(rtrim(ltrim(rr.ds_resposta)), 0, 10), 
                                               '')) dt_informada
                  ,a.cd_multi_empresa
              from dbamv.registro_documento r
                  ,dbamv.atendime a
                  ,dbamv.documento d
                  ,dbamv.paciente p
                  ,dbamv.registro_resposta rr
             where p.cd_paciente = a.cd_paciente
               and r.cd_atendimento = a.cd_atendimento
               and r.cd_documento = d.cd_documento
               and r.cd_registro_documento = rr.cd_registro_documento
               and nvl(r.sn_impresso, 'C') <> 'C'
               and a.cd_convenio in (10, 377)
               and r.cd_documento in (307, 1029)
               and rr.cd_pergunta_doc in (19093, 19095, 1988, 5946, 19017, 1991,38403,38404,38406,38407,40302,40542
               )
              -- and a.cd_atendimento = &p_cd_atendimento
                
               and ((a.cd_atendimento = &p_cd_atendimento)
                    or 
                   (a.cd_atendimento_pai = &p_cd_atendimento)
                   )
               and exists (select 'X'
                            from dbamv.registro_resposta rr1
                           where rr1.cd_registro_documento =
                                 r.cd_registro_documento
                             and rr1.cd_pergunta_doc in (1991, 5949)
                             and ltrim(rtrim(substr(substr(rr1.ds_resposta, 0, 10), 1, instr(substr(rr1.ds_resposta, 0, 10), '-', 1) - 1))) =  &p_codigo_prestador)
               and rr.ds_resposta is not null
               --and rr.codigo_prestador is not null --Alterado Felps
             group by r.cd_registro_documento, a.cd_multi_empresa) doc
