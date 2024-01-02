select a.cd_multi_empresa,a.cd_reduzido_adiant_receb from dbamv.config_fcct a 
where a.cd_multi_empresa in (1,2) for update
