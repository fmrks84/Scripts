select
*
from 
dbamv.reg_Fat rf
inner join itreg_Fat irf on rf.cd_reg_fat = irf.cd_reg_fat 
inner join tiss_guia tg on tg.cd_atendimento = rf.cd_atendimento and tg.cd_reg_fat = irf.cd_reg_fat                                                                  
inner join tiss_itguia itg on itg.id_pai = tg.id and itg.cd_pro_fat = irf.cd_pro_fat and itg.id = irf.id_it_envio 
--nner join tiss_itguia_out iout on iout.id_pai = itg.id_pai and irf.cd_pro_fat = itg.cd_pro_fat
where  rf.cd_atendimento = 2385933



select * from dbamv.reg_fat where cd_reg_Fat = 262264 and cd_pro_fat = 60023040 --210233489
210233438
210233435
select * from tiss_itguia it where it.id_pai = 12432774
select * from tiss_itguia_op op where op.id = 12432774
--select * from tiss_itguia_equ eq where eq.id = 12432774
select * from tiss_itguia_out it2 where it2.id_pai = 12432774

select * 
from tiss_itguia_out iout 
inner join tiss_itguia it on it.id_pai = iout.id_pai
inner join itreg_Fat y on y.id_it_envio = 
where iout.id_pai  =12432774
and 
 -- 210233484  16806834
--select * from tiss_itgui
