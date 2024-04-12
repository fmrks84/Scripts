--BEGIN dbamv.pkg_mv2000.atribui_empresa(10); END;
--Cursor cTissSP_Proc(5825301  in dbamv.atendime.cd_atendimento%type,                        4816495  in dbamv.reg_amb.cd_reg_amb%type,                         'PRINCIPAL' in varchar2,

   SELECT
     DISTINCT
   	 --dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_contratadoDados','nomeContratado',1444,cd_atend,cd_conta,cd_lanc,null,null,null,'SOLIC_SP')            nm_contratado_sol          --  <-+ --Oswaldo FATURCONV-22404
   	dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_contratadoProfissionalDad','nomeProfissional',1444,cd_atend,cd_conta,null,null,null,null,'SOLIC_SP')   nm_contratado_prof_sol     --    |
   	--,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_contratadoDados','nomeContratado',1460,cd_atend,cd_conta,null,null,cd_prestador,null,null)             nm_contratado_exe          --    | QUEBRA GUIAS --Oswaldo FATURCONV-22404
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_autorizacaoSADT','numeroGuiaOperadora',1433,cd_atend,cd_conta,cd_lanc,null,null,null,null)             nr_guia_conv               --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_autorizacaoSADT','senha',1433,cd_atend,cd_conta,cd_lanc,null,null,null,null)                           nr_senha_conv              --  <-+

    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoSadt','dataExecucao',1469,cd_atend,cd_conta,cd_lanc,null,null,null,null)    	data                --  <-+
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoSadt','horaInicial',1469,cd_atend,cd_conta,cd_lanc,null,null,null,null)      	hr_ini              --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoSadt','horaFinal',1469,cd_atend,cd_conta,cd_lanc,null,null,null,null)        	hr_fim              --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoDados','codigoTabela',1469,cd_atend,cd_conta,cd_lanc,null,null,null,'SP')        		  tp_tabela           --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoDados','codigoProcedimento',1469,cd_atend,cd_conta,cd_lanc,null,null,null,'SP')        cod_proc            --    | QUEBRA ITENS
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoDados','descricaoProcedimento',1469,cd_atend,cd_conta,cd_lanc,null,null,null,'SP')     ds_proc             --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoSadt','viaAcesso',1469,cd_atend,cd_conta,cd_lanc,null,null,null,null)     	  tp_via_acesso       --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoSadt','tecnicaUtilizada',1469,cd_atend,cd_conta,cd_lanc,null,null,null,null)	tp_tecnica          --    |
    ,dbamv.pkg_ffcv_tiss_v4.f_tiss('F_ct_procedimentoExecutadoSadt','reducaoAcrescimo',1469,cd_atend,cd_conta,cd_lanc,null,null,null,null)	vl_perc_reduc_acres --  <-+
    ,cd_lanc
    ,cd_pro_fat
    ,tp_pagamento
    ,cd_prestador
    ,cd_prestador_equ
    ,cd_itlan_med  --Oswaldo FATURCONV-20760
    ,cd_conta
    ,cd_guia
    ,cd_convenio
      FROM ( select ita.cd_atendimento                  cd_atend,
                    ita.cd_reg_amb                      cd_conta,
                    ita.cd_lancamento                	cd_lanc,
                    ita.cd_ati_med                      cd_ati_med,
                    null                                cd_itlan_med,
                    ita.cd_pro_fat                      cd_pro_fat,
                    nvl(ita.tp_pagamento,'P')           tp_pagamento,
                    dbamv.pkg_ffcv_tiss_v4.F_ret_prestador (5825301,4816495,ita.cd_lancamento,null,null,null,'SPA','PRINCIPAL',null)  cd_prestador
                    ,ita.cd_prestador cd_prestador_equ
                    --decode(nvl(dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_CONTRAT_CRED_SP_AMBUL',null,lpad(5825301,10,'0')||'#'||lpad(4816495,10,'0')),'1'),'1',
                    ,ita.cd_guia
                    ,ita.cd_convenio
               from dbamv.itreg_amb ita
              where 'PRINCIPAL' in ('PRINCIPAL','CREDENCIADOS','SECUNDARIAS')
                and ita.cd_atendimento   = 5825301
                and ita.cd_reg_amb       = 4816495
                and dbamv.pkg_ffcv_tiss_v4.f_ret_sn_pertence_pacote('SP',ita.cd_atendimento,ita.cd_reg_amb,ita.cd_lancamento, null, null ) <> 'S'
                and (  ('PRINCIPAL' in ('PRINCIPAL','SECUNDARIAS') and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( ita.cd_atendimento,ita.cd_reg_amb,ita.cd_lancamento, ita.cd_ati_med,'SP',null ) = 'P')
                     or('PRINCIPAL'='CREDENCIADOS' and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_pagamento( ita.cd_atendimento,ita.cd_reg_amb,ita.cd_lancamento, ita.cd_ati_med,'SPC',null ) = 'C'))
                and (   ('PRINCIPAL' = 'PRINCIPAL' and dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('NR_GUIA_ESPECIFICA',5825301,4816495,ita.cd_lancamento,null,'SPA',null,null) = 'N')
                     or ( 'PRINCIPAL' = 'SECUNDARIAS' and dbamv.pkg_ffcv_tiss_v4.F_ret_info_guias('NR_GUIA_ESPECIFICA',5825301,4816495,ita.cd_lancamento,null,'SPA',null,null) = 'S')
                     or   'PRINCIPAL' ='CREDENCIADOS' )
                and dbamv.pkg_ffcv_tiss_v4.f_ret_tp_grupro(ita.cd_atendimento,ita.cd_reg_amb,ita.cd_lancamento,null,null,null) in ('SP','SD')
--				        and Decode ('PRINCIPAL','CREDENCIADOS',null,ita.id_it_envio) IS NULL -- <<-- s¿¿ itens n¿¿o gerados ainda (exceto Credenciados que podem ser gerados na principal e nas secund¿¿rias simultaneamente se configurado)
             --
                )
     ORDER BY	nr_guia_conv,
     			    nr_senha_conv,
              Decode(dbamv.pkg_ffcv_tiss_v4.FNC_CONF('TP_NR_GUIA_PREST_SP',cd_convenio,null), '4', cd_guia, NULL),
              --nm_contratado_sol, --Oswaldo FATURCONV-22404
              nm_contratado_prof_sol,
              --nm_contratado_exe, --Oswaldo FATURCONV-22404
           		data,
           		hr_ini,
           		hr_fim,
           		tp_tabela,
           		cod_proc,
           		ds_proc,
           		tp_via_acesso,
           		tp_tecnica,
           		vl_perc_reduc_acres DESC



              isso seria pago.. vc pode fazer isso ai.. gerar AS contas e voltar, pois nao sei o impacto.. entrega tudo e volta