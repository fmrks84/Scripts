/*select * from guia a 
--inner join it_guia b on b.cd_guia = a.cd_guia
where a.cd_atendimento = 3108162*/


select count(*)qt_itens_guia,
      b.cd_pro_fat,
      c.ds_pro_fat,
      b.qt_autorizado,
      b.qt_autorizada_convenio,
      b.qt_autorizada_pre,
      b.qt_autorizada_pos
      from it_guia b
       inner join pro_Fat c on c.cd_pro_fat = b.cd_pro_fat
      where  b.cd_guia in (2942262)
--and b.cd_pro_fat = 09068003
group by b.cd_pro_fat,
         c.ds_pro_fat,
         b.qt_autorizado,
         b.qt_autorizada_convenio,
         b.qt_autorizada_pre,
         b.qt_autorizada_pos
order by b.cd_pro_fat
--(select a.cd_guia from guia a where a.cd_atendimento = 3108162)

select 
*
from it_guia where cd_guia in (304997) 
and cd_pro_Fat = 00240893
for update
  
select * from reg_fat where cd_atendimento = 3108162
select * from itreg_fat where cd_reg_fat = 345576
select * from all_tab_columns z where z.column_name like '%NR_GUIA%'


select x.cd_guia, x.tp_guia, xy.cd_multi_empresa from guia x 
inner join aviso_cirurgia xy on xy.cd_aviso_cirurgia = x.cd_aviso_cirurgia
where x.cd_aviso_cirurgia in (207029)
and x.tp_guia = 'O'--,,,,,,,,)

select * from val_opme_it_guia j where j.cd_guia = 2999507
222620,211518,222618,205126,222614,207276,196508,211445
