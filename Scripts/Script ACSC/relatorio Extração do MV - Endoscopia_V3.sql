select 
distinct
c.cd_exa_rx,
c.ds_exa_rx,
a.cd_setor,
c.exa_rx_cd_pro_fat,
ts.cd_tuss,
ts.ds_tuss,
g.cd_convenio,
h.nm_convenio,
d.cd_tab_fat,
tf.ds_tab_fat,
d.dt_vigencia,
d.vl_total

from dbamv.set_exa a 
inner join exa_set b on b.cd_set_exa = a.cd_set_exa
inner join exa_rx c on c.cd_exa_rx = b.cd_exa_rx
inner join val_pro d on d.cd_pro_fat = c.exa_rx_cd_pro_fat
inner join itregra e on e.cd_tab_fat = d.cd_tab_fat
inner join regra f on f.cd_regra = e.cd_regra
inner join empresa_con_pla g on g.cd_regra = f.cd_regra and f.cd_regra = e.cd_regra
inner join convenio h on h.cd_convenio = g.cd_convenio 
inner join multi_empresas i on i.cd_multi_empresa = g.cd_multi_empresa
inner join tuss ts on ts.cd_pro_fat = d.cd_pro_fat
inner join tab_Fat tf on tf.cd_tab_fat = d.cd_tab_fat
where trunc (d.dt_vigencia) =
(select max(trunc(vl.dt_vigencia)) from val_pro vl where vl.cd_pro_fat = d.cd_pro_fat and vl.cd_tab_fat = d.cd_tab_fat)
and a.cd_setor = 32
and g.cd_multi_empresa = 7
--and d.cd_tab_fat = 19
--and d.cd_pro_fat = '40201031'
and c.sn_ativo = 'S'
ORDER BY 
          
          c.ds_exa_rx,
          h.nm_convenio
          
          
          
          

         
