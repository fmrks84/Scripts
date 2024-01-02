select * from dbamv.tb_coa a 
where a.crm in ('12689','25377','3159151F')
and a.cd_multi_empresa = 2
FOR UPDATE 
