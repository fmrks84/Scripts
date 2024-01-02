select 
case when p.cd_multi_empresa = 3  then 'CSSJ'
     when p.cd_multi_empresa = 4  then 'HST'
     when p.cd_multi_empresa = 7  then 'HSC'
     when p.cd_multi_empresa = 10 then 'HSJ'
     when p.cd_multi_empresa = 25 then 'HCNSC' 
     end NM_EMPRESA,
conv.cd_convenio||' - '||conv.nm_convenio nm_convenio,
cpla.cd_con_pla||' - '||cpla.ds_con_pla nm_plano,
pd.cd_produto,
pd.ds_produto,
p.cd_pro_fat,
p.dt_inicial_proibicao,
p.dt_fim_proibicao,
case when p.tp_atendimento = 'I' then 'INTERNACAO'
     when p.tp_atendimento = 'E' then 'EXTERNO'
     when p.tp_atendimento = 'A' then 'AMBULATORIAL'
     when p.tp_atendimento = 'U' then 'URGENCIA'
     else 'TODOS'
     END TP_ATENDIMENTO,
case when p.tp_proibicao = 'AG' then 'AGUARD.AUTORIZACAO'
     when p.tp_proibicao = 'FC' then 'FORA_DA_CONTA'
     when p.tp_proibicao = 'NA' then 'NAO_AUTORIZADO'
     end TP_PROIBICAO

from 
dbamv.proibicao p
inner join dbamv.produto pd on pd.cd_pro_fat = p.cd_pro_fat
inner join dbamv.empresa_produto epd on epd.cd_produto = pd.cd_produto and epd.cd_multi_empresa = p.cd_multi_empresa
inner join dbamv.convenio conv on conv.cd_convenio = p.cd_convenio 
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
inner join dbamv.con_pla cpla on cpla.cd_con_pla = p.cd_con_pla and cpla.cd_convenio = econv.cd_convenio
inner join empresa_con_pla ecpla on ecpla.cd_con_pla = p.cd_con_pla and ecpla.cd_convenio = p.cd_convenio
where p.cd_convenio = 46
--and p.cd_pro_fat = 70009112
--and p.cd_con_pla = 10
--and p.dt_fim_proibicao is null
order by 3,4
