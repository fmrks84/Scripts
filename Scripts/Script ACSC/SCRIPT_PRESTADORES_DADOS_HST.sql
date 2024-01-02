select p.cd_prestador,
       p.nm_prestador,
       p.ds_codigo_conselho crm,
       p.nr_cpf_cgc,
       esp.ds_especialid
        from prestador p 
        inner join esp_med ep on ep.cd_prestador = p.cd_prestador
        inner join especialid esp on esp.cd_especialid = ep.cd_especialid
        where ep.sn_especial_principal = 'S'
        

order by 
P.NM_PRESTADOR
--p.cd_prestador
