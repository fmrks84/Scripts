SELECT cd_multi_empresa,
       sum(VL_FAT_REMESSA)VL_FAT_EMPRESA
FROM
(
select cr.cd_multi_empresa,
       rm.cd_remessa,
       FT.CD_CONVENIO,
       conv.nm_convenio,
       ft.dt_competencia,
       nf.cd_nota_fiscal,
       rm.cd_con_rec,
       cr.nr_documento,
       sum(nf.vl_itfat_nf)VL_FAT_REMESSA
     
  

from
dbamv.remessa_fatura rm
inner join dbamv.fatura ft on ft.cd_fatura = rm.cd_fatura
inner join dbamv.convenio conv on conv.cd_convenio = ft.cd_convenio
inner join dbamv.itfat_nota_fiscal nf on rm.cd_remessa = nf.cd_remessa
left join dbamv.nota_fiscal nf1 on nf1.cd_nota_fiscal = nf.cd_nota_fiscal and nf1.cd_remessa = nf.cd_remessa
left join dbamv.con_Rec cr on cr.cd_con_rec = rm.cd_con_rec
left join dbamv.itcon_rec icr on icr.cd_con_rec = cr.cd_con_rec
left join dbamv.reccon_rec rcon on rcon.cd_itcon_rec = icr.cd_itcon_rec
where cr.cd_multi_empresa in &cd_multi_empresa-- 7
and to_char(ft.dt_competencia,'MM/YYYY' ) =  &dt_competencia--'01/2020'
--AND rm.cd_remessa = 180594
group by 
        cr.cd_multi_empresa,
        rm.cd_remessa,
        FT.CD_CONVENIO,
        conv.nm_convenio,
       ft.dt_competencia,
       nf.cd_nota_fiscal,
       rm.cd_con_rec,
       cr.nr_documento
      
order by 
conv.nm_convenio   
) group by cd_multi_empresa 

;

select nm_convenio,
      sum(vl_nf)VL_FAT_CONVENIO

from
(
select rm.cd_remessa,
       FT.CD_CONVENIO,
       conv.nm_convenio,
       ft.dt_competencia,
       nf.cd_nota_fiscal,
       rm.cd_con_rec,
       cr.nr_documento,
       sum(nf.vl_itfat_nf)VL_NF
     
  

from
dbamv.remessa_fatura rm
inner join dbamv.fatura ft on ft.cd_fatura = rm.cd_fatura
inner join dbamv.convenio conv on conv.cd_convenio = ft.cd_convenio
inner join dbamv.itfat_nota_fiscal nf on rm.cd_remessa = nf.cd_remessa
left join dbamv.nota_fiscal nf1 on nf1.cd_nota_fiscal = nf.cd_nota_fiscal and nf1.cd_remessa = nf.cd_remessa
left join dbamv.con_Rec cr on cr.cd_con_rec = rm.cd_con_rec
left join dbamv.itcon_rec icr on icr.cd_con_rec = cr.cd_con_rec
left join dbamv.reccon_rec rcon on rcon.cd_itcon_rec = icr.cd_itcon_rec
where cr.cd_multi_empresa in &cd_multi_empresa-- 7
and to_char(ft.dt_competencia,'MM/YYYY' ) =  &dt_competencia--'01/2020'
--AND rm.cd_remessa = 180594
group by rm.cd_remessa,
        FT.CD_CONVENIO,
        conv.nm_convenio,
       ft.dt_competencia,
       nf.cd_nota_fiscal,
       rm.cd_con_rec,
       cr.nr_documento
      
order by 
conv.nm_convenio       
)group by nm_convenio
order by nm_convenio
;
select rm.cd_remessa,
       FT.CD_CONVENIO,
       conv.nm_convenio,
       ft.dt_competencia,
       nf.cd_nota_fiscal,
       rm.cd_con_rec,
       cr.nr_documento,
       sum(nf.vl_itfat_nf)VL_FAT_REMESSA
     
  

from
dbamv.remessa_fatura rm
inner join dbamv.fatura ft on ft.cd_fatura = rm.cd_fatura
inner join dbamv.convenio conv on conv.cd_convenio = ft.cd_convenio
inner join dbamv.itfat_nota_fiscal nf on rm.cd_remessa = nf.cd_remessa
left join dbamv.nota_fiscal nf1 on nf1.cd_nota_fiscal = nf.cd_nota_fiscal and nf1.cd_remessa = nf.cd_remessa
left join dbamv.con_Rec cr on cr.cd_con_rec = rm.cd_con_rec
left join dbamv.itcon_rec icr on icr.cd_con_rec = cr.cd_con_rec
left join dbamv.reccon_rec rcon on rcon.cd_itcon_rec = icr.cd_itcon_rec
where cr.cd_multi_empresa in &cd_multi_empresa--7
and to_char(ft.dt_competencia,'MM/YYYY' ) = &dt_competencia--'01/2020'
--AND rm.cd_remessa = 180594
group by rm.cd_remessa,
        FT.CD_CONVENIO,
        conv.nm_convenio,
       ft.dt_competencia,
       nf.cd_nota_fiscal,
       rm.cd_con_rec,
       cr.nr_documento
      
order by 
conv.nm_convenio       
