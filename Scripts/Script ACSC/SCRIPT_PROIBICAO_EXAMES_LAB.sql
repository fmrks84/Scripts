with cpart as (
select 
       distinct
       econv.cd_multi_empresa,
       conv.cd_convenio,
       cpla.cd_con_pla ,
       cpla.cd_regra ,
       irg.cd_gru_pro,
       irg.cd_tab_fat
       from convenio conv 
inner join empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
inner join con_pla cpla on cpla.cd_convenio = econv.cd_convenio
inner join empresa_con_pla ecpla on ecpla.cd_con_pla = cpla.cd_con_pla
and ecpla.cd_convenio = econv.cd_convenio and econv.cd_multi_empresa = ecpla.cd_multi_empresa
inner join itregra irg on irg.cd_regra = cpla.cd_regra 
inner join config_ffcv conf on conf.cd_multi_empresa = econv.cd_multi_empresa 
and conf.cd_convenio_fat_extra = econv.cd_convenio 
and conf.cd_con_pla_fat_extra = cpla.cd_con_pla
where  econv.cd_multi_empresa = 7
)

select 
distinct
ex.cd_exa_lab,
ex.nm_exa_lab,
pf.cd_gru_pro,
ex.cd_pro_fat,
pb.cd_convenio,
---conv.nm_convenio,
pb.cd_con_pla,
--cpla.ds_con_pla,
pb.tp_atendimento,
pb.tp_proibicao,
case when pb.tp_proibicao = 'NA' THEN 'Nao autorizado'
     when pb.tp_proibicao = 'AG' THEN 'Autorizado Guia'
     when pb.tp_proibicao = 'FC' THEN 'Fora Conta'
     end DS_TIP_PROIBICAO,
pb.dt_fim_proibicao,
pb.dt_inicial_proibicao,
max(vp.dt_vigencia)dt_vigencia,
part.cd_Tab_Fat,
max(vp.vl_total)vl_total
from
exa_lab ex 
inner join pro_fat pf on pf.cd_pro_fat = ex.cd_pro_fat
inner join proibicao pb on pb.cd_pro_fat = pf.cd_pro_fat
inner join empresa_convenio econv on econv.cd_convenio = pb.cd_convenio and econv.cd_multi_empresa = pb.cd_multi_empresa
inner join empresa_con_pla ecpla on ecpla.cd_con_pla = pb.cd_con_pla and ecpla.cd_convenio = pb.cd_convenio 
and ecpla.cd_multi_empresa = pb.cd_multi_empresa
left join cpart part on part.cd_gru_pro = pf.cd_gru_pro ---and pb.tp_proibicao = 'NA'
left join val_pro vp on vp.cd_pro_fat =  pb.cd_pro_fat --and vp.cd_tab_fat = part.cd_Tab_fat and pb.tp_proibicao = 'NA'
where /*pb.dt_inicial_proibicao = 
(select max(pbx.dt_inicial_proibicao)from proibicao pbx where \*pbx.cd_pro_fat = pb.cd_pro_fat
and *\pbx.tp_proibicao = pb.tp_proibicao)*/
 ex.sn_ativo = 'S'
and pb.cd_multi_empresa = 7 
and pb.cd_convenio = 7
--and conv.tp_convenio = 'C' 
and pb.tp_atendimento in ('A','E','I','U')
and ex.cd_exa_lab = 5982
--AND PB.TP_PROIBICAO = 'AG'
--and pb.cd_pro_fat = '28014415'
and  pb.cd_con_pla = 72
and pb.tp_atendimento = 'A'
group by
ex.cd_exa_lab,
ex.nm_exa_lab,
pf.cd_gru_pro,
ex.cd_pro_fat,
pb.cd_convenio,
--conv.nm_convenio,
pb.cd_con_pla,
--cpla.ds_con_pla,
pb.tp_atendimento,
pb.tp_proibicao,
pb.dt_inicial_proibicao,
pb.dt_fim_proibicao,
part.cd_Tab_Fat
order by ex.cd_pro_fat,pb.cd_convenio,pb.cd_con_pla,pb.tp_atendimento
/*)
group by 
tp_proibicao*/
--20104466

--)
;
 

select * from val_pro where cd_tab_Fat = 222 and cd_pro_fat = 28599634
