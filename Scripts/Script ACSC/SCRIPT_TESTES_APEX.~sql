select a.Cd_Aviso_Cirurgia, 
a.cd_guia, 
a.nr_guia ,
a.cd_senha,
a.dt_autorizacao,
f.cd_especie,
c.cd_pro_fat, 
d.ds_pro_fat,
d.cd_gru_pro,
e.cd_gru_fat,
c.cd_usu_geracao,
c.cd_usu_autorizou, 
c.tp_pre_pos_cirurgico
 from guia a 
inner join convenio b on b.cd_convenio = a.cd_convenio
inner join it_guia c on c.cd_guia = a.cd_guia
inner join pro_Fat d on d.cd_pro_fat = c.cd_pro_fat
inner join gru_pro e on e.cd_gru_pro = d.cd_gru_pro
inner join produto f on f.cd_pro_fat = d.cd_pro_fat
where a.tp_guia = 'O' 
and b.cd_convenio = 7
and c.cd_pro_fat is not null
and a.cd_aviso_cirurgia in (286502)--,288231,279269)
--and a.cd_guia = 3991367
and a.cd_aviso_cirurgia is not null order by 1 desc 

--select * from dbasgu.usuarios x


select * from produto where cd_especie in (19,20)
