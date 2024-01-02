select 'Paciente'tp_nota,
      a.cd_nota_fiscal,
      a.nr_id_nota_fiscal NR_RPS,
      a.nr_nota_fiscal_nfe NR_NFE,
      a.cd_status,
      a.dt_emissao,
      a.nm_cliente,
      nvl(a.cd_reg_fat,0)cd_Reg_Fat,
      nvl(a.Cd_Reg_Amb,0)cd_reg_amb,
      a.vl_total_nota,
      nvl(a.cd_remessa,0)cd_remessa,
      to_number('0','999999.00')vl_total_remessa
      
       from nota_fiscal a where a.cd_multi_empresa = 11
and a.nr_nota_fiscal_nfe is null
and a.cd_status = 'E'
and a.cd_atendimento is not null

union all 

select distinct
      'Operadora'tp_nota,
      a.cd_nota_fiscal,
      a.nr_id_nota_fiscal NR_RPS,
      a.nr_nota_fiscal_nfe NR_NFE,
      a.cd_status,
      a.dt_emissao,
      a.nm_cliente,
      to_number('0',9999999)cd_reg_Fat,
      to_number('0',9999999)cd_Reg_amb,
      a.vl_total_nota,
      b.cd_remessa,
      sum(b.vl_itfat_nf)vl_total_remessa
       from nota_fiscal a 
       inner join itfat_nota_fiscal b on b.cd_nota_fiscal = a.cd_nota_fiscal
       where a.cd_multi_empresa = 11
and a.nr_nota_fiscal_nfe is null
and a.cd_status = 'E'
and a.cd_atendimento is null
group by 
     --tp_nota,
      a.cd_nota_fiscal,
      a.nr_id_nota_fiscal,
      a.nm_cliente,
      a.cd_status,
      a.dt_emissao,
      a.nr_nota_fiscal_nfe,
      a.vl_total_nota,
      b.cd_remessa
order by 2
