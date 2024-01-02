delete from
dbamv.configu_importacao_gru_fat  -- empresa 7
where cd_setor in (2,3,4,10,12,17,18,24,26,27,28,31,32,35,37,
                     38,39,40,44,45,72,73,105,106,107,132,147,
                     150,151,155,156,157,158,175,183,184,199,
                     200,208,211,232,235,236,237,249,253,270,
                     311,3129)
and cd_produto is not null  
