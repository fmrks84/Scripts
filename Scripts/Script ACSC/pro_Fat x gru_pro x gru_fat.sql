select 
proc.cd_pro_fat CODIGO_PROCEDIMENTO,
proc.ds_pro_fat DS_PROCEDIMENTO,
proc.cd_gru_pro COD_GRUPO_PROCEDIMENTO,
gp.ds_gru_pro DS_GRUPO_PROCEDIMENTO, 
gf.cd_gru_fat COD_GRUPO_FATURAMENTO,
gf.ds_gru_fat DS_GRUPO_FATURAMENTO
from 
dbamv.pro_fat proc
inner join dbamv.gru_pro gp on gp.cd_gru_pro = proc.cd_gru_pro
inner join dbamv.gru_Fat gf on gf.cd_gru_fat = gp.cd_gru_fat
where proc.sn_ativo = 'S'
--and proc.ds_pro_fat is null
--and proc.cd_pro_fat = '41001162'
order by 
         gf.cd_gru_fat
         
--and proc.cd_pro_fat = '60034122'

--select * from dbamv.val_pro t where t.cd_pro_fat = '55020186'

