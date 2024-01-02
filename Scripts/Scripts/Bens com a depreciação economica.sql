
--------------- NOTA EXPLICATIVA-----
select distinct
       to_char(c.dt_competencia,'MM/YYYY')DT_COMPETENCIA,
   ------- abaixo dados do bem -----------    
       a.cd_bem,
       a.ds_bem,
       a.dt_ult_depre,
       a.tx_depre tx_depr_fiscal_anual,
      -- round (a.tx_depre_mes,+2) tx_depr_fiscal_mensal,
       round (a.tx_aplicada, +2) tx_depr_eco_anual,
      -- round (a.tx_depre_mes_eco, +2) tx_depr_mes_eco_mensal,
       a.vl_compra vl_aquisicao,
       '',
       b.cd_laudo,
       b.cd_it_laudo,
       
       
   ------- abaixo dados Aplicados ---------  
       round (b.tx_aplicada,+3)TX_APLICADA ,
       b.nr_vida_util_aplic Vida_util_aplicada,
       b.vl_recuperavel,
   --------abaixo dados anterior  ---------    
       round (b.tx_anterior, +2)tx_anterior, --r tx_anterior ,
       b.nr_vida_util_ant Vida_util_anterior,
       b.vl_residual Vl_residual ,
       '',
   -------- abaixo depreciações /depreciações economicas 
       round (a.tx_depre_mes,+2) tx_depr_fiscal_mensal,   
       round((c.vl_deprecia_antes),2)vl_deprecia_anterior,
       round((c.vl_deprecia_atual),2)vl_deprecia_residual,
       round((c.vl_deprecia_antes - c.vl_deprecia_atual),2)Vl_depre,
       round (a.tx_depre_mes_eco, +2) tx_depr_mes_eco_mensal,
       round((c.vl_deprecia_antes_eco),2)vl_depr_anterior_eco,
       round((c.vl_deprecia_atual_eco),2)vl_deprecia_residual_eco,
       round((c.vl_deprecia_antes_eco - c.vl_deprecia_atual_eco),2)VL_Depre_econ
from dbamv.bens a 
inner join dbamv.it_laudo b on b.cd_bem = a.cd_bem
inner join dbamv.itdeprecia c on c.cd_bem = b.cd_bem
inner join dbamv.deprecia d on d.cd_deprecia = c.cd_deprecia
where a.cd_bem in (27469)
and c.vl_deprecia_atual_eco is not null 
and (to_char(c.dt_competencia,'MM/YYYY')) = '11/2017'

   
