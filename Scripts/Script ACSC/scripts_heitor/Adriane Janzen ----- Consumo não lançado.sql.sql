/*SELECT * FROM log_falha_importacao; */
SELECT distinct decode (r.cd_multi_empresa,'1','HMRP','3','CSSJ','4','HST','7','HSC','10','HSJ','25','HCNSC') as empresa,
r.cd_convenio,
c.nm_convenio,
i.cd_atendimento,
r.cd_reg_amb conta,
i.cd_pro_fat,
p.ds_pro_fat,
l.tp_erro,
l.ds_msg_erro

FROM reg_amb r

inner join itreg_amb i on r.cd_reg_amb = i.cd_reg_amb
inner join pro_fat p on i.cd_pro_fat = p.cd_pro_fat
inner join remessa_fatura rf on r.cd_remessa = rf.cd_remessa
inner join fatura f on f.cd_fatura = rf.cd_fatura
inner join convenio c on r.cd_convenio = c.cd_convenio
inner join log_falha_importacao l on i.cd_atendimento = l.cd_atendimento

and f.dt_competencia between '01/11/2021' and '01/01/2022'
and c.tp_convenio <> all ('H','P')
and r.cd_multi_empresa in (4)
and l.tp_erro <> all (3,4,6,7,9,10)
and r.cd_reg_amb is not null
order by 2

