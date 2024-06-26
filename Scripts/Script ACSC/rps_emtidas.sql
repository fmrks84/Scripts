select nr_id_nota_fiscal RPS, CD_atendimento, nm_cliente, vl_total_nota, dt_emissao, hr_emissao_Nfe,
 nvl(to_date(hr_emissao_nfe),to_Date(sysdate)) - to_date(dt_emissao) dif_dias, ds_retorno_nfe
 from nota_fiscal
 where cd_multi_empresa = 7
 and   dt_emissao >= '01/01/2021'
 and   cd_atendimento is not null
 and   hr_emissao_nfe is null
 and   cd_status = 'E'


select * from anexos_guia where cd_anexos_guia in (457073,464385,464401,463574)
