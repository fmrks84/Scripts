select sum(vl_total_conta)VL_TOTAL,
      (select ds_pro_Fat from dbamv.pro_Fat p where p.cd_pro_fat = a)NM_PROCED 
from 
(
select 
 reg_fat.cd_pro_fat_solicitado a,
 reg_Fat.Cd_Multi_Empresa,
 reg_Fat.Cd_Atendimento,
 itreg_fat.cd_reg_fat ,
 itreg_Fat.Cd_Gru_Fat,
 itreg_fat.cd_pro_fat,
 (select ds_pro_Fat from dbamv.pro_Fat p where p.cd_pro_fat = itreg_Fat.Cd_Pro_Fat)NM_PROCED,
 itreg_fat.dt_lancamento,
 itreg_FAt.Qt_Lancamento,
 itreg_FAt.Vl_Total_Conta ,
 reg_fat.cd_remessa
 from dbamv.reg_fat,
      dbamv.itreg_Fat ,
      dbamv.remessa_fatura,
      dbamv.fatura
      
where to_char(fatura.DT_COMPETENCIA, 'MM/YYYY') = '01/2017'
and Reg_Fat.Cd_Convenio = 389
and reg_Fat.Cd_Multi_Empresa in (1)
and remessa_fatura.cd_fatura = fatura.CD_FATURA 
and Reg_Fat.Cd_Remessa = remessa_fatura.cd_remessa
and reg_Fat.Cd_Reg_Fat = itreg_fat.cd_reg_fat
and reg_fat.sn_fechada = 'S' 
and itreg_Fat.Sn_Pertence_Pacote = 'N'

order by 
reg_Fat.Cd_Atendimento,
itreg_fat.dt_lancamento
)
group by 
a






