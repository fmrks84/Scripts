select * from dbamv.configuracao a
where a.cd_sistema = 'FFCV'
--and a.cd_multi_empresa = 5
and a.chave = 'COD_SERV_NFE_EMP'
for update 
