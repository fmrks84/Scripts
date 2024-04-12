select 
distinct 
a.cd_aviso_cirurgia,
d.cd_pro_fat,
pf.ds_pro_fat,
d.ds_procedimento,
d.cd_usu_autorizou,
a.dt_aviso_cirurgia
from 
aviso_cirurgia a 
inner join IT_AV_PRODUTOS b on b.cd_aviso_cirurgia = a.cd_aviso_cirurgia
inner join guia c on c.cd_aviso_cirurgia = a.cd_aviso_cirurgia
inner join it_guia d on d.cd_guia = c.cd_guia and d.cd_usu_geracao = 'MVINTEGRACAO'
inner join pro_Fat pf on pf.cd_pro_fat = d.cd_pro_fat
where a.cd_multi_empresa = 7
and c.tp_guia = 'O'
and c.cd_atendimento is not null
--AND C.CD_GUIA = 3526605
--AND D.CD_PRO_FAT = '09008231'
--AND c.cd_convenio = 7
--AND A.CD_AVISO_CIRURGIA = 435987
order by a.dt_aviso_cirurgia desc 
;
select * from produto where cd_pro_fat = '09008231'
;
--select * from 
select * from pacote where cd_convenio = 48 and cd_pro_fat = 30710022

