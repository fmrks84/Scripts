select cd_atendimento , * from dbamv.atendime where dt_prevista_alta is not null 
and dt_prevista_alta Between To_Date('01/01/2013','dd/mm/yyyy') And To_Date('31/01/2013','dd/mm/yyyy')--'01/01/2013' is 31/01/2013'
