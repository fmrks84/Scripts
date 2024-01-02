select 
prest.cd_prestador id_prestador,
prest.ds_codigo_conselho numero_conselho,
cons.cd_uf uf_conselho,
prest.nm_prestador,
cbo.cd_cbos nr_cbo,
trunc(prest.dt_cadastro) Data_Cadastro,
''Responsavel_Cadastro,
''Data_Atualizacao,
''Responsavel_Atualizacao

from 
dbamv.prestador prest
inner join dbamv.conselho cons on cons.cd_conselho = prest.cd_conselho
inner join dbamv.esp_med esp on esp.cd_prestador = prest.cd_prestador
inner join dbamv.especialid cbo on cbo.cd_especialid = esp.cd_especialid
where prest.tp_situacao = 'A'
and cons.ds_conselho like 'CRM%'
and esp.sn_especial_principal = 'S'
and prest.cd_tip_presta in (8,38,28,69,82,58)
order by prest.nm_prestador

