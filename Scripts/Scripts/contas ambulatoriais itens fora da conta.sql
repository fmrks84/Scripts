select  
        e.nm_convenio,
        A.CD_CONVENIO,
        decode(a.cd_multi_empresa,'1','SANTA JOANA','2','PROMATRE')EMPRESA,
        sum(b.vl_total_conta)Vl_Total_Fora_Conta
        
from dbamv.reg_amb a 
inner join dbamv.itreg_amb b on b.cd_reg_amb = a.cd_reg_amb and a.cd_convenio = b.cd_convenio
inner join dbamv.Remessa_Fatura c on c.cd_remessa = a.cd_remessa
inner join dbamv.fatura d on d.cd_Fatura = c.cd_fatura 
inner join dbamv.convenio e on e.cd_convenio = a.cd_convenio
where 1 = 1 
and b.sn_pertence_pacote = 'S'
and a.cd_convenio not in (352,379,378)
--and a.cd_convenio =
--and b.cd_pro_fat not in 00017215
and to_char(d.DT_COMPETENCIA,'mm/yyyy') = '06/2017'
--and a.cd_reg_amb = 995013
group by 
A.CD_CONVENIO,
e.nm_convenio,
a.cd_multi_empresa
order by 
e.nm_convenio,
a.cd_convenio;
------------------------------------------------------
--------------  NIVEL 1 ------------------------------
------------------------------------------------------
select  
        a.cd_reg_amb , 
        b.cd_atendimento,
        DECODE (A.CD_MULTI_EMPRESA,'1','SANTA JOANA','2','PROMATRE')EMPRESA,
        A.CD_CONVENIO,
        b.vl_total_conta
        
from dbamv.reg_amb a 
inner join dbamv.itreg_amb b on b.cd_reg_amb = a.cd_reg_amb and a.cd_convenio = b.cd_convenio
inner join dbamv.Remessa_Fatura c on c.cd_remessa = a.cd_remessa
inner join dbamv.fatura d on d.cd_Fatura = c.cd_fatura 
where 1 = 1 
and b.sn_pertence_pacote = 'S'
and a.cd_convenio not in (352,379,378)
--and a.cd_convenio = #CD_CONVENIO#
--and b.cd_pro_fat not in 00017215
and to_char(d.DT_COMPETENCIA,'mm/yyyy') = '06/2017'
--and a.cd_reg_amb = 995171
order by 
a.cd_convenio




