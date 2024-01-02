select cd_leito codigo, ds_leito descricao
  from dbamv.leito
 where sn_extra = 'N'
   and tp_situacao = 'A'
   and cd_tip_acom in ( 11, 60)
   and ds_leito like 'BS 3%'
   
   and cd_leito not in (select cd_leito_rn
                          from dbamv.hmsj_leito_mae_rn)
order by descricao

select *
from dbamv.hmsj_leito_mae_rn 
WHERE CD_LEITO_RN IN (2734,2735)


delete from dbamv.hmsj_leito_mae_rn 
WHERE CD_LEITO_RN IN (1379, 1380)
