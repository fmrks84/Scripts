select pf.cd_pro_fat,
       pf.ds_pro_fat,
       pf.cd_gru_pro,
       vp.cd_tab_fat,
       tf.ds_tab_fat,
       vp.dt_vigencia,
       vp.vl_honorario,
       vp.vl_operacional,
       vp.vl_total
from 
pro_Fat pf      
inner join val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat
inner join tab_fat tf on tf.cd_tab_fat = vp.cd_tab_fat
where vp.dt_vigencia = (select max(x.dt_vigencia) from val_pro x where x.cd_tab_fat = vp.cd_tab_fat and x.cd_pro_fat = vp.cd_pro_fat) 
and pf.cd_pro_fat in ('40601013','40601030','40601110','40601129','40601170',
'40601188','40601196','40601200','40601218','40601226','40601021','40601234','40601242',
'40601250','40601269')
and vp.cd_tab_fat in (1402,574,537,3087,544,558,573,554,536,560,534,541,567,543,535,572,538,4,
561,528,562,1281,3388,549,532,2667,2648,3067,550,533,557,553,575,568,1421,540,559,563,545,530,569,
547,571,548,564,531,551,566,539)
order by pf.cd_pro_fat, vp.cd_tab_fat
