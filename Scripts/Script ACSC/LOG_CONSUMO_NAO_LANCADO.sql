/*consumo nao lancado - log_falha_importacao; */
select distinct decode (a.cd_multi_empresa,'1','HMRP','3','CSSJ','4','HST','7','HSC','10','HSJ','25','HCNSC') as empresa,
       a.cd_convenio,
       c.nm_convenio,
       a.cd_con_pla,
        cpla.ds_con_pla,
       l.cd_atendimento,
       l.cd_reg_fat conta_internado,
       l.cd_reg_amb conta_amb,
       l.cd_pro_fat,
       p.ds_pro_fat,
       l.dt_importacao,
       l.tp_erro,
       l.ds_msg_erro
           
from log_falha_importacao l
inner join atendime a         on a.cd_atendimento = l.cd_atendimento
inner join convenio c         on c.cd_convenio = a.cd_convenio
inner join pro_fat  p         on p.cd_pro_fat = l.cd_pro_fat
inner join dbamv.con_pla cpla on cpla.cd_convenio = a.cd_convenio
                             and cpla.cd_con_pla = a.cd_con_pla



where 1 = 1 -- l.tp_erro = 03 -- <> all (3,4,6,7,9,10)
--and l.dt_importacao between '01/08/2022' and '08/11/2022'
and c.tp_convenio <> all ('A','H','P')
--and a.cd_multi_empresa in (4)
--and a.cd_convenio = 248
and l.cd_atendimento = 5134636
--and l.cd_pro_fat = 60023155
order by 2

