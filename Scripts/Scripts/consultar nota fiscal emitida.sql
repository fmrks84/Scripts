SELECT nf.cd_nota_fiscal, nf.nr_id_nota_fiscal, nf.nm_cliente, nf.cd_convenio, nf.dt_emissao, nf.cd_status, nf.vl_total_nota--, nf.ds_intermediario
  FROM dbamv.nota_fiscal nf 
 WHERE nf.cd_multi_empresa = 3 
   AND nf.cd_convenio = 318 
 ORDER BY nf.cd_nota_fiscal desc
