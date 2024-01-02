select distinct decode(n.cd_multi_empresa,3,'CASA DE SAUDE SAO JOSE',4,'HOSPITAL SANTA TEREZA',7,'HOSPITAL SANTA CATARINA',10,'HOSPITAL SAO JOSE',25,'HOSPITAL DE CLINICAS NOSSA SENHORA DA CONCEICAO')CASA
      ,n.nr_id_nota_fiscal NF_MV
      ,n.nr_nota_fiscal_nfe NF_PREFEITURA 
      ,decode(n.cd_status,'E','EMITIDA','C','CANCELADA')STATUS_NF
      ,c.cd_convenio
      ,c.nm_convenio
      ,n.nm_cliente 
      ,n.nr_cgc_cpf CPF_CNPJ
      ,n.dt_emissao 
     ,r.dt_prevista_para_pgto 
     ,d.vl_previsto vl_bruto_nota
      ,n.vl_total_nota  
     ,n.cd_nota_fiscal 
      
      
from nota_fiscal n 
    ,itfat_nota_fiscal a
    ,remessa_fatura r
    ,convenio c    
    ,con_Rec d 
               
where n.cd_nota_fiscal = a.cd_nota_fiscal(+)
and r.cd_remessa(+) = a.cd_remessa
and d.cd_nota_fiscal(+) = a.cd_nota_fiscal
and n.cd_convenio = c.cd_convenio
and n.dt_emissao BETWEEN  To_Date ('01/01/2020','dd/mm/yyyy') and To_Date ('28/02/2021','dd/mm/yyyy')
and c.tp_convenio = 'C'
and n.cd_status in ('E','C')
and n.cd_multi_empresa in ('3','4','7','10','25')
order by 1,10

