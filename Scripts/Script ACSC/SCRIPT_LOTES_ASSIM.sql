
select 
        a.cd_remessa,
        a.nr_lote,
        a.cd_convenio,
        a.nm_convenio,
        b.cd_multi_empresa,
        c.ds_multi_empresa,
        sum(d.vl_itfat_nf)vl_total_remessa
 from DBAMV.V_TISS_STATUS_PROTOCOLO A   
 inner join dbamv.empresa_convenio b on b.cd_convenio = a.cd_convenio
 inner join dbamv.multi_empresas c on c.cd_multi_empresa = b.cd_multi_empresa
 inner join dbamv.itfat_nota_fiscal d on d.cd_remessa = a.cd_remessa
where a.nr_lote in(7151,7152,7153,7154,7155,7156,7157,7158,7160,7165,7166,7167,7168,7169,7177,7178,7180,7183,7184,7185,7186,7187,7188,
7189,7190,7191,7192,7192,7194,7195,7196,7197,7208,7220,7221,7223,7224,7225)
and a.cd_convenio in (114,154) 
group by 
        a.cd_remessa,
        a.nr_lote,
        a.cd_convenio,
        a.nm_convenio,
        b.cd_multi_empresa,
        c.ds_multi_empresa
order by a.nr_lote,b.cd_multi_empresa
;


with contas as (
select 
        a.cd_remessa,
        a.nr_lote,
        a.cd_convenio,
        a.nm_convenio,
        b.cd_multi_empresa,
        c.ds_multi_empresa,
        sum(d.vl_itfat_nf)vl_total_remessa
 from DBAMV.V_TISS_STATUS_PROTOCOLO A   
 inner join dbamv.empresa_convenio b on b.cd_convenio = a.cd_convenio
 inner join dbamv.multi_empresas c on c.cd_multi_empresa = b.cd_multi_empresa
 inner join dbamv.itfat_nota_fiscal d on d.cd_remessa = a.cd_remessa
where a.nr_lote in(7151,7152,7153,7154,7155,7156,7157,7158,7160,7165,7166,7167,7168,7169,7177,7178,7180,7183,7184,7185,7186,7187,7188,
7189,7190,7191,7192,7192,7194,7195,7196,7197,7208,7220,7221,7223,7224,7225)
and a.cd_convenio in (114,154) 
group by 
        a.cd_remessa,
        a.nr_lote,
        a.cd_convenio,
        a.nm_convenio,
        b.cd_multi_empresa,
        c.ds_multi_empresa
order by a.nr_lote,b.cd_multi_empresa
)

select 
distinct
iramb.cd_atendimento,
iramb.cd_reg_amb,
ramb.cd_remessa,
ramb.cd_multi_empresa
from
reg_amb ramb
inner join contas ct on ct.cd_remessa = ramb.cd_remessa
inner join itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
order by ramb.cd_remessa
