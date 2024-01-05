select 
TF.CD_TAB_FAT,
TF.DS_TAB_FAT,
case when tf.ds_tab_fat like '%SIMPRO' then 'SIMPRO_PURA'
     when tf.ds_tab_fat like '%MATER%BRADESCO%' then 'TABELA_PROPRIA_BRADESCO'
     when tf.ds_tab_fat like '%MATER%SAS%' then 'TABELA_PROPRIA_SULAMERICA'
     when tf.ds_tab_fat like '%MATER%CNU%' then 'TABELA_PROPRIA_CNU'
     when tf.ds_tab_fat like 'HSC%MAT%CONG%PETR%' then 'MATERIAL_TABELA_PROPRIA_PETROBRAS'
     when tf.ds_tab_fat like 'CSSJ%MAT%CONG%PETR%' then 'MATERIAL_SIMPRO_CONGELADA_PETROBRAS_03-2022'
     when tf.ds_tab_fat like 'HCNSC%MAT%CONG%PETR%' then 'MATERIAL_SIMPRO_CONGELADA_PETROBRAS_03-2022'
     when tf.ds_tab_fat like 'HST%MAT%CONG%PETR%' then 'MATERIAL_SIMPRO_CONGELADA_PETROBRAS_03-2022'
     when tf.ds_tab_fat like 'HSJ%MAT%CONG%PETR%' then 'MATERIAL_SIMPRO_CONGELADA_PETROBRAS_03-2022'
     when tf.ds_tab_fat like '%MAT%CONG%UNIM%' then 'MATERIAL_CONGEL_UNIMED_SEGUROS'
     when tf.ds_tab_fat like 'HCNSC%MAT%UNIM%RIOS' then 'MATERIAL_CONGEL_UNIMED_3_RIOS'
     when tf.ds_tab_fat like '%MAT%ASSIM' then 'MATERIAL_SIMPRO_CONGELADA_ASSIM_01-2021'
     when tf.ds_tab_fat like '%HST%ASSIM%MATERIA%' then 'MATERIAL_SIMPRO_CONGELADA_ASSIM_01-2021'
     when tf.ds_tab_fat like '%SEGUROS%UNIM%CONGEL%' then 'MATERIAL_CONGEL_UNIMED_SEGUROS'
     when tf.ds_tab_fat like '%MATER%AMIL%' then 'MATERIAL_SIMPRO_CONGELADA_AMIL_03-2019'
     when tf.ds_tab_fat like '%MATER%SOMPO%' then 'MATERIAL_SIMPRO_CONGELADA_SOMPO_07-2017'
     when tf.ds_tab_fat like '%CASSI%MATER%' then 'MATERIAL_TABELA_PROPRIA_CASSI'
     when tf.ds_tab_fat like '%CASSI%MAT%CONG%' then 'MATERIAL_TABELA_PROPRIA_CASSI'
     when tf.ds_tab_fat like '%MATER%VIVEST%' then 'MATERIAL_TABELA_PROPRIA_VIVEST'
     when tf.ds_tab_fat like '%HSC%MATER%NOTRE%INTER%' then 'MATERIAL_TABELA_PROPRIA_NOTRE_INTERM'
     when tf.ds_tab_fat like '%HST%MATER%NOTRE%INTER%' then 'MATERIAL_SIMPRO_CONGELADA_NOTRE_INTERM_01-05-2022'
     when tf.ds_tab_fat like '%HCNSC%MATER%NOTRE%INTER%' then 'MATERIAL_SIMPRO_CONGELADA_NOTRE_INTERM_30-03-2022'
     when tf.ds_tab_fat like '%HSJ%MATER%NOTRE%INTER%' then 'MATERIAL_SIMPRO_CONGELADA_NOTRE_INTERM_09-04-2022'
     when tf.ds_tab_fat like '%MATER%FRIBURGO%' then 'MATERIAL_TABELA_PROPRIA_FRIBURGO'
     when tf.ds_tab_fat like '%CNEN%MATE%' then 'MATERIAL_TABELA_PROPRIA_CNEN'
     when tf.ds_tab_fat like '%HSC%MATE%ESP%' then 'MATERIAL_ESPECIAL_TABELA_PROPRIA_HSC'
     when tf.ds_tab_fat like '%HCNSC%MATE%ESP%' then 'MATERIAL_ESPECIAL_TABELA_PROPRIA_HCNSC'
     when tf.ds_tab_fat like '%HST%MATE%ESP%' then 'MATERIAL_ESPECIAL_TABELA_PROPRIA_HST'
     when tf.ds_tab_fat like '%CSSJ%MATE%ESP%' then 'MATERIAL_ESPECIAL_TABELA_PROPRIA_CSSJ'
     when tf.ds_tab_fat like '%HSC%MATE%DESC%' then 'MATERIAL_DESCONTINUADO_TABELA_PROPRIA_HSC'
     when tf.ds_tab_fat like '%HMRP%OPME' then 'MATERIAL_OPME_TABELA_PROPRIA_HMRP'


     ELSE 'X'
     END TABELA_REFERENCIA    
from
tab_fat tf 
where (tf.ds_tab_fat like '%HSC%MAT%'
OR  tf.ds_tab_fat like '%CSSJ%MAT%'
OR  tf.ds_tab_fat like '%HST%MAT%'
OR  tf.ds_tab_fat like '%HSJ%MAT%'
OR  tf.ds_tab_fat like '%HMRP%MAT%'
OR  tf.ds_tab_fat like '%HCNSC%MAT%'
OR  tf.ds_tab_fat like '%OPME%')
and tf.ds_tab_fat not like '%INATIVO%'
and tf.ds_tab_fat not like '%BRASIND%'
and tf.ds_tab_fat not like '%PARTI%'
and tf.cd_tab_fat not in (3447)
and tf.cd_tab_fat not in (1605,2127,90,93,1604,2,79,1825,25,53,1747,2967,141,525,582,585)
order by 1 
