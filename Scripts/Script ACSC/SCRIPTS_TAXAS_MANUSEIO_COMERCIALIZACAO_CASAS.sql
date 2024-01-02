select 
*
from
(
select 
casa,
proced,
convenio,
nm_convenio,
round((sum(total_conta) / sum(total_lancamento)),2)ticket_medio,
sum(total_lancamento)total_lancamento,
sum(total_conta)total_conta

from 
(
select 
decode(rf.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',11,'HMRP',25,'HCNSC')CASA,
pf.cd_pro_fat||' - '||pf.ds_pro_fat proced,
rf.cd_convenio convenio,
conv.nm_convenio nm_convenio,
irf.dt_lancamento,
irf.qt_lancamento total_lancamento,
irf.vl_total_conta total_conta


from dbamv.pro_Fat pf
inner join dbamv.itreg_fat irf on irf.cd_pro_fat = pf.cd_pro_fat
inner join dbamv.reg_fat rf on rf.cd_reg_fat = irf.cd_reg_fat
inner join dbamv.convenio conv on conv.cd_convenio = rf.cd_convenio
where TO_DATE(irf.dt_lancamento, 'DD/MM/RRRR') BETWEEN '01/01/2023' AND '30/06/2023'-->= ADD_MONTHS(SYSDATE, -7)*/--to_date(irf.hr_lancamento,'DD/MM/RRRR')
and pf.cd_gru_pro = 14
and pf.cd_pro_fat not in (81091842,81091850,81091869,81091877)
--(pf.ds_pro_fat like '%MANUSEIO%' OR pf.ds_pro_fat like '%TAXA%COMERCIAL%' or pf.ds_pro_fat like '%TAXA%MANIPULA')
and rf.sn_fechada = 'S'
--and rf.cd_remessa is not null
--and rf.cd_multi_empresa = 7
--and rf.cd_convenio = 11
order by TO_DATE(irf.dt_lancamento, 'DD/MM/RRRR'),
         rf.cd_convenio
         desc 
)group by
casa,
proced,
convenio,
nm_convenio
)
pivot 
      (SUM(total_conta)
      for casa in ('HSC' as HSC,
                   'CSSJ' as CSSJ,
                   'HST' AS HST,
                   'HSJ' AS HSJ,
                   'HMRP' AS HMRP,
                   'HCNSC'AS HCNSC))
ORDER BY CONVENIO,PROCED

;

select 
decode(rf.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',11,'HMRP',25,'HCNSC')CASA,
pf.cd_pro_fat||' - '||pf.ds_pro_fat proced,
rf.cd_convenio convenio,
conv.nm_convenio nm_convenio,
rf.cd_reg_fat conta,
irf.dt_lancamento,
irf.qt_lancamento total_lancamento,
irf.vl_total_conta total_conta


from dbamv.pro_Fat pf
inner join dbamv.itreg_fat irf on irf.cd_pro_fat = pf.cd_pro_fat
inner join dbamv.reg_fat rf on rf.cd_reg_fat = irf.cd_reg_fat
inner join dbamv.convenio conv on conv.cd_convenio = rf.cd_convenio
where TO_DATE(irf.dt_lancamento, 'DD/MM/RRRR') BETWEEN '01/01/2023' AND '30/06/2023' -->= ADD_MONTHS(SYSDATE, -7)--to_date(irf.hr_lancamento,'DD/MM/RRRR')
and  pf.cd_gru_pro = 14
and pf.cd_pro_fat not in (81091842,81091850,81091869,81091877) 
--(pf.ds_pro_fat like '%MANUSEIO%' OR pf.ds_pro_fat like '%TAXA%COMERCIAL%'or pf.ds_pro_fat like '%TAXA%MANIPULA')
and rf.sn_fechada = 'S'
--and rf.cd_reg_fat = 433240
--and rf.cd_remessa is not null
--and rf.cd_multi_empresa = 7
--and rf.cd_convenio = 11
order by 
         rf.cd_convenio,
         irf.cd_pro_fat
         desc 
--TX COMERCIALIZAÇÃO DE OPME


--SELECT * FROM PRO_FAT WHERE CD_PRO_FAT = '60001959'

--SELECT * FROM PRO_FAT where cd_gru_pro = 14

--SELECT * FROM ITREG_fAT WHERE CD_REG_fAT = 433240
