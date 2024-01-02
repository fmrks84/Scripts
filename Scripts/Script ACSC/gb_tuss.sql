select t.cd_tip_tuss
      ,t.cd_tuss
      ,t.ds_tuss
      ,t.cd_convenio
      ,t.cd_pro_fat
      ,p.ds_pro_fat
      ,t.cd_multi_empresa
      ,t.dt_fim_vigencia
      
from tuss t
     ,pro_fat p
where t.cd_pro_fat = p.cd_pro_fat
and t.cd_tuss like '%70036802%'
--and (t.cd_convenio in 185 or t.cd_convenio is null)
--and t.ds_tuss like '%GLICOSE 5% FR 250ML%'
and t.cd_multi_empresa = 3

select * from produto where cd_pro_fat = '02038734'

-185

select convenio.cd_convenio,
       convenio.nm_convenio,
       convenio.nr_cgc,
      -- convenio.ds
       convenio.cd_fornecedor,
       empresa_convenio.cd_multi_empresa,
       multi_empresas.ds_multi_empresa,
       Empresa_Convenio.Cd_Formulario_Nf
       from 
empresa_Convenio,
convenio,
multi_empresas

where empresa_convenio.cd_convenio = convenio.cd_convenio 
and empresa_convenio.cd_multi_empresa = multi_empresas.cd_multi_empresa
and multi_empresas.cd_multi_empresa = 4
--and empresa_convenio.cd_convenio = 181
--and convenio.tp_convenio = 'C'
order by convenio.nm_convenio

select * from pro_Fat where cd_pro_fat = '41301080'
select * from itregra z where z.cd_gru_pro = 3

select distinct cd_Regra from itregra z where z.cd_tab_fat in (535)

select * from tab_Fat where cd_tab_fat  in (823,824,1501)
/*
select max(dt_vigencia) ,
       cd_tab_fat,
       cd_pro_Fat,
       vl_total
              
from val_pro 
where cd_pro_fat in ('00040812','00137754','00294823','73334871') 
and cd_Tab_fat in (823,824,1501)
group by cd_pro_fat,vl_total,cd_tab_Fat
order by 1*/


select * from pro_fat a
inner join produto b on b.cd_pro_fat = a.cd_pro_fat
inner join empresa_produto c on c.cd_produto = b.cd_produto
where a.ds_pro_Fat like '%DIALISADOR%'
and c.cd_multi_empresa = 4


select * from convenio where cd_convenio in (181,156)--for update 
