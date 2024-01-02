select * from dbamv.proibicao a , dbamv.Pro_Fat b 
where b.cd_gru_pro in (33)
and a.cd_pro_fat = b.cd_pro_fat
and a.cd_convenio = 307
