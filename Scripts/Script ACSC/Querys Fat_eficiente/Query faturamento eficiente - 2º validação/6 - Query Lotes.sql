select 
distinct
a.ID,
a.nr_lote nR_lote,
A.nr_documento,
b.dt_criacao data_emissao,
b.cd_site_servico,
''data_envio,
a.nr_protocolo_retorno,
''data_cadastro,
''responsavel_cadastro,
''data_Atualizacao,
''resposavel_atualizacao,
a.tp_situacao,
a.dt_competencia,
a.cd_remessa,
a.tp_mensagem_tiss

from DBAMV.V_TISS_STATUS_PROTOCOLO A      
inner join site_xml b on b.cd_wizard_origem  = a.ID 
inner join tiss_guia c on c.cd_remessa = a.cd_remessa
where b.cd_site_servico = 561
and a.cd_remessa_glosa  is null
and c.ds_inconsistencias is null 
and a.cd_convenio = 7
and a.tp_situacao = 'LE'
and a.dt_competencia = '01/07/2021'
--and a.nr_documento = '226530'
--and a.cd_remessa IN(177779,178159)
;
/*
select * from tiss_mensagem z where z.nr_documento IN('179188')
select * from v_tiss_status_protocolo z1 where z1.cd_convenio = 7 and z1.cd_remessa IN(177779,178159)*/

