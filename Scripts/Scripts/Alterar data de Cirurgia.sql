select cd_aviso_cirurgia, cd_atendimento, dt_aviso_cirurgia, dt_realizacao, vl_tempo_duracao, dt_inicio_cirurgia, dt_fim_cirurgia
     , dt_inicio_anestesia, dt_fim_anestesia,  dt_inicio_limpeza, dt_fim_limpeza
from aviso_cirurgia where cd_aviso_cirurgia in (226272)

select * from aviso_cirurgia where cd_aviso_cirurgia = 226272


select cd_paciente, cd_atendimento from aviso_cirurgia where cd_paciente is null and tp_situacao = 'R'

select cd_estoque, cd_mvto_estoque, cd_atendimento, cd_aviso_cirurgia from mvto_estoque where cd_aviso_cirurgia = 10925 --and cd_atendimento is null
order by cd_aviso_cirurgia

select dt_inicio_age_cir from age_cir where cd_aviso_cirurgia = 24195

alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss' -- alterar o formato da hora

select * from prod_atend where cd_aviso_cirurgia is not null and cd_atendimento is null and cd_estoque in (3,4)

SELECT * FROM PROD_ATEND WHERE CD_AVISO_CIRURGIA = 8760
update prod_atend set cd_atendimento = 32124 WHERE CD_AVISO_CIRURGIA = 8760 and cd_atendimento is null
