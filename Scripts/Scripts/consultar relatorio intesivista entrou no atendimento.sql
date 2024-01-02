select cd_registro_documento,
       ds_resposta,
       to_date(dt_informada, 'dd/mm/yyyy') dt_informada,
       cd_multi_empresa
      
from (select r.cd_registro_documento
             ,max(decode(cd_pergunta_doc,19093, substr(rtrim(ltrim(rr.ds_resposta)), 0, 500), 19095, substr(rtrim(ltrim(rr.ds_resposta)), 0, 500), '')) ds_resposta
             ,max(decode(cd_pergunta_doc,1988, substr(rtrim(ltrim(rr.ds_resposta)), 0, 10), 5946, substr(rtrim(ltrim(rr.ds_resposta)), 0, 10), '')) dt_informada
             ,a.CD_MULTI_EMPRESA
        from dbamv.registro_documento r
            ,dbamv.atendime a
            ,dbamv.documento d
            ,dbamv.paciente p
            ,(select ds_resposta
                    ,cd_pergunta_doc
                    ,cd_registro_documento
                    ,ltrim(rtrim(substr(substr(ds_resposta, 0, 10)
                                       ,1
                                       ,instr(substr(ds_resposta, 0, 10), '-', 1) - 1))) codigo_prestador
                from dbamv.registro_resposta) rr

       where p.cd_paciente = a.cd_paciente
         and r.cd_atendimento = a.cd_atendimento
         and r.cd_documento = d.cd_documento
         and r.cd_registro_documento = rr.cd_registro_documento
         and nvl(r.sn_impresso, 'C') <> 'C'
         and a.cd_convenio in (10, 377)
         and r.cd_documento in  (307, 1029)
         and rr.cd_pergunta_doc in ( 19093, 19095, 1988, 5946 )
         and a.cd_atendimento = 1502496--P_CD_ATENDIMENTO
         and exists
           (select 'X'
                   from dbamv.registro_resposta rr1
                  where rr1.cd_registro_documento = r.cd_registro_documento
                    and rr1.cd_pergunta_doc in (1991, 5949)
                    and ltrim(rtrim(substr(substr(rr1.ds_resposta, 0, 10)
                                          ,1
                                          ,instr(substr(rr1.ds_resposta, 0, 10)
                                                ,'-'
                                                ,1) - 1))) in (9315,9093,8670,4552,9243,174,551,9493,8841,1846)--P_CD_PRESTADOR
                                                )
         and rr.ds_resposta is not null
         group by r.cd_registro_documento, a.cd_multi_empresa) doc

   where exists (select 1
                    from dbamv.reg_fat
                   where reg_fat.cd_atendimento = 1502496--p_cd_atendimento
                     and reg_fat.cd_multi_empresa = doc.cd_multi_empresa
                     and reg_fat.cd_conta_pai is null
                     and reg_fat.cd_reg_fat = (select cd_conta_pai from dbamv.reg_fat where cd_reg_fat in (1344902)--,1340423)--p_cd_reg_fat)
                     and reg_fat.cd_convenio not in (352, 379, 351)
                     --and doc.dt_informada between trunc(dt_inicio) and trunc(dt_final)
                     ))
order by dt_informada;
 
---- select dbamv.fnc_hmsj_obs_guia_tiss(:par1,:par3,:par2) from dual

