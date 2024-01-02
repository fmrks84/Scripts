select 
PF.CD_PRO_FAT,
PF.DS_PRO_FAT,
TS.CD_TUSS,
TS.DS_TUSS,
TS.CD_TIP_TUSS,
TS.CD_REF_FABRICANTE,
lpro.cd_registro anvisa,
ts.dt_inicio_vigencia,
ts.dt_fim_vigencia
from 
tuss ts 
left join pro_fat pf on pf.cd_pro_fat = ts.cd_pro_fat
left join produto pd on pd.cd_pro_fat = pf.cd_pro_fat
and pf.cd_pro_fat = ts.cd_pro_fat
left join lab_pro lpro on lpro.cd_produto = pd.cd_produto
where ts.cd_tip_tuss in (00,20)
and pd.sn_bloqueio_de_compra = 'N'
and pf.sn_ativo = 'S'
and ts.cd_multi_empresa = 7
and ts.cd_convenio = 5


