SELECT 
PK_CONVENIO                   
,CD_CONVENIO  
,nm_convenio                 
,CD_ATENDIMENTO                
,CD_TIPO_ATENDIMENTO             
,CD_MULTI_EMPRESA              
,CD_SETOR_PRODUZIU             
,CD_SETOR                      
,CONTA 
,CD_PRO_FAT                    
,valor_faturado
,valor_convenio
,valor_amil
,valor_amil_puro
,(valor_convenio+valor_amil+valor_amil_puro)total_pacote
,QT_PRODUZIDO
,DT_COMPETENCIA  
,dt_comp
,SN_PERTENCE_PACOTE   
cd_convenio,
nm_convenio,
dt_competencia


FROM (
-----------inicio faturado -----------------
select 
tff.PK_CONVENIO                   
,tff.CD_CONVENIO      
,tc.nm_convenio             
,tff.CD_ATENDIMENTO                
,tff.CD_TIPO_ATENDIMENTO             
,tff.CD_MULTI_EMPRESA              
,tff.CD_SETOR_PRODUZIU             
,tff.CD_SETOR                      
,tff.cd_reg_fat||cd_reg_amb conta 
,tff.CD_PRO_FAT                    
,tff.VL_TOTAL_CONTA valor_faturado
,0 valor_convenio
,0 valor_amil
,0 valor_amil_puro
,tff.QT_PRODUZIDO
,tff.DT_COMPETENCIA  
,to_char (tff.dt_competencia,'yyyy/mm') dt_comp
,tff.SN_PERTENCE_PACOTE            

from tb_ft_faturamento tff
inner join tb_dim_convenio tc on tc.cd_convenio = tff.cd_convenio
where dt_competencia > = to_date ('01/01/2020','dd/mm/rrrr') 
and dt_competencia < = to_date ('31/12/2020','dd/mm/rrrr')
and sn_pertence_pacote = 0
and tp_pagamento <> 3
--and cd_convenio  <> 5 
and tff.cd_multi_empresa = 3

-----------final faturado -----------------


-------------------------
union all 
-------------------------




-----------inicio pacote convenio -----------------

select 
tff.PK_CONVENIO                   
,tff.CD_CONVENIO    
,tc.nm_convenio               
,tff.CD_ATENDIMENTO                
,tff.CD_TIPO_ATENDIMENTO             
,tff.CD_MULTI_EMPRESA              
,tff.CD_SETOR_PRODUZIU             
,tff.CD_SETOR                      
,tff.cd_reg_fat||cd_reg_amb conta 
,tff.CD_PRO_FAT                    
,0 valor_faturado
,tff.VL_TOTAL_CONTA valor_convenio
,0 valor_amil
,0 valor_amil_puro


,tff.QT_PRODUZIDO
,tff.DT_COMPETENCIA  
,to_char (tff.dt_competencia,'yyyy/mm') dt_comp
,tff.SN_PERTENCE_PACOTE            

from tb_ft_faturamento tff
inner join tb_dim_convenio tc on tc.cd_convenio = tff.cd_convenio
where cd_pro_fat in (select CD_PRO_FAT_PACOTE from tb_dim_pacote)
and dt_competencia > = to_date ('01/01/2020','dd/mm/rrrr')
and dt_competencia < = to_date ('31/12/2020','dd/mm/rrrr')
--and cd_convenio  <> 68 
and tff.cd_multi_empresa = 3 

-----------final pacote convenio -----------------
-------------------------
union all 
-------------------------


-----------inicio pacote da amil -----------------
select 
tff.PK_CONVENIO                   
,tff.CD_CONVENIO     
,tc.nm_convenio              
,tff.CD_ATENDIMENTO                
,tff.CD_TIPO_ATENDIMENTO             
,tff.CD_MULTI_EMPRESA              
,tff.CD_SETOR_PRODUZIU             
,tff.CD_SETOR                      
,tff.cd_reg_fat||cd_reg_amb conta 
,tff.CD_PRO_FAT                    
,0 valor_faturado
,0 valor_convenio
,0 valor_amil
,tff.VL_TOTAL_CONTA valor_amil_puro

,tff.QT_PRODUZIDO
,tff.DT_COMPETENCIA  
,to_char (tff.dt_competencia,'yyyy/mm') dt_comp
,tff.SN_PERTENCE_PACOTE            

from tb_ft_faturamento tff --,tb_fatura_remessa tfr
inner join tb_dim_convenio tc on tc.cd_convenio = tff.cd_convenio
where /*tff.cd_convenio  = 68 
--and tff.cd_agrupamento not in (1,2,3,4,5,6,8)--in (4,5,8)
--and tff.cd_ori_ate in (143,147)---(9,10,26,27,101) 
and*/ tff.sn_pertence_pacote =0
and tff.cd_multi_empresa = 3 
--and tff.remessa=tfr.cd_remessa
and dt_competencia > = to_date ('01/01/2020','dd/mm/rrrr')
and dt_competencia < = to_date ('31/12/2020','dd/mm/rrrr')



-------------------------
union all 
-------------------------

select 
tff.PK_CONVENIO                   
,tff.CD_CONVENIO     
,tc.nm_convenio              
,tff.CD_ATENDIMENTO                
,tff.CD_TIPO_ATENDIMENTO             
,tff.CD_MULTI_EMPRESA              
,tff.CD_SETOR_PRODUZIU             
,tff.CD_SETOR                      
,tff.cd_reg_fat||cd_reg_amb conta 
,tff.CD_PRO_FAT                    
,0 valor_faturado
,0 valor_convenio
,tff.VL_TOTAL_CONTA valor_amil
,0 valor_amil_puro
,tff.QT_PRODUZIDO
,tff.DT_COMPETENCIA  
,to_char (tff.dt_competencia,'yyyy/mm') dt_comp
,tff.SN_PERTENCE_PACOTE            

from tb_ft_faturamento tff
inner join tb_dim_convenio tc on tc.cd_convenio = tff.cd_convenio
where cd_pro_fat in (select CD_PRO_FAT_PACOTE from tb_dim_pacote)
and dt_competencia > = to_date ('01/01/2020','dd/mm/rrrr')
and dt_competencia < = to_date ('31/12/2020','dd/mm/rrrr')
--and cd_convenio  = 68 
--and tff.cd_ori_ate not in (143,147)--not in (9,10,26,27,101)
and tff.cd_multi_empresa = 3 

-----------final pacote da amil -----------------

)
ORDER BY 2

