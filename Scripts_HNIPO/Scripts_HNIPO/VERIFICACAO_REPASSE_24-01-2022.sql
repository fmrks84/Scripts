--- repasse ambulatorial particular quitados

select
irp.cd_repasse,
irp.cd_prestador||' - '||prst.nm_prestador nm_prestador,
irp.cd_prestador_repasse||' - '||(select pr.nm_prestador from prestador pr where pr.cd_prestador = irp.cd_prestador_repasse)nm_grupo_repasse, 
sum(b1.vl_base_repassado)vl_faturado,
sum(irp.vl_repasse)vl_repasse,
rpp.cd_con_pag
from 
atendime a 
inner join itreg_amb b1 on b1.cd_atendimento = a.CD_ATENDIMENTO and a.CD_CONVENIO = b1.cd_convenio
inner join reg_amb c1 on c1.cd_reg_amb = b1.cd_reg_amb 
inner join remessa_fatura d1 on d1.cd_remessa = c1.cd_remessa 
left join itfat_nota_fiscal inf on inf.cd_reg_amb = c1.cd_reg_amb
left join nota_fiscal nf on nf.cd_nota_fiscal = inf.cd_nota_fiscal
left join con_Rec cr on cr.cd_nota_fiscal = nf.cd_nota_fiscal
left join itcon_rec icr on icr.cd_con_rec = cr.cd_con_rec
inner join it_repasse irp on irp.cd_reg_amb = b1.cd_reg_amb
                          and irp.cd_prestador = b1.cd_prestador
left join prestador prst on prst.cd_prestador = irp.cd_prestador
left join repasse rp on rp.CD_REPASSE = irp.cd_repasse
left join repasse_prestador rpp on rpp.cd_repasse = irp.cd_repasse
where a.CD_CONVENIO  in (&cd_convenio)
and b1.cd_prestador = 7466
and to_CHAR(rp.DT_COMPETENCIA,'MM/YYYY') =  ('&dt_competencia')--'12/2021'
and icr.tp_quitacao = 'Q'
group by 
irp.cd_repasse,
irp.cd_prestador,
irp.cd_prestador_repasse,
prst.nm_prestador,
rpp.cd_con_pag

union all 

select 
distinct
rp.CD_REPASSE,
irp.cd_prestador||' - '||prest.nm_prestador nm_prestador,
irp.cd_prestador_repasse||' - '||(select pr.nm_prestador from prestador pr where pr.cd_prestador = irp.cd_prestador_repasse)nm_grupo_repasse, 
rpre.vl_faturado,
rpre.vl_repasse,
rpre.cd_con_pag


from 
repasse rp
inner join it_repasse irp on irp.cd_repasse = rp.CD_REPASSE
inner join repasse_prestador rpre on rpre.cd_repasse = irp.cd_repasse
                                  and rpre.cd_prestador = irp.cd_prestador
inner join prestador prest on prest.cd_prestador = irp.cd_prestador                                  
where to_CHAR(rp.DT_COMPETENCIA,'MM/YYYY') =  ('&dt_competencia') 
and rp.CD_REPASSE = 48276
and irp.cd_prestador = 7466






--and a.cd_reg_amb = 7490874
select 
*
from 
itreg_amb a
where a.cd_prestador = 1148
and a.cd_convenio = 40
and trunc(a.hr_lancamento) between '01/12/2021' and '31/12/2021' 
--and a.cd_reg_amb = 7490874

select * from itreg_amb where cd_atendimento in (8257982,8300625)

select * from it_repasse x 
inner join repasse x1 on x1.CD_REPASSE = x.cd_repasse
where x.cd_prestador = 7466
and x.cd_repasse = 48747
--x.cd_reg_amb = 7490874
--select * from repasse where cd_repasse = 48704

select * from pro_fat where cd_pro_Fat = '00205103'
select * from atendime where cd_atendimento in (8300625,8257982)
