select econv.cd_multi_empresa,
     conv.cd_convenio,
   --   CONV.TP_CONVENIO,
       conv.nm_convenio,
       econv.cd_hospital_no_convenio codigo_prestador_operadora
       
        from empresa_convenio econv
inner join convenio conv on conv.cd_convenio = econv.cd_convenio
where econv.cd_multi_empresa in (3,4,7,10,11,25)
and conv.tp_convenio NOT in ('P','H')
and conv.nm_convenio not like '%MEDICINA%'
AND ECONV.CD_HOSPITAL_NO_CONVENIO IS NOT NULL
order by econv.cd_multi_empresa,
      conv.cd_convenio
