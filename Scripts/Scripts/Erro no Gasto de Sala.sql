select cd_aviso_cirurgia, cd_atendimento, cd_paciente from aviso_cirurgia where cd_aviso_cirurgia in (8760)

select cd_paciente, cd_atendimento from aviso_cirurgia where cd_paciente is null and tp_situacao = 'R'

SELECT * FROM DBAMV.IMPRESSAO WHERE TP_ACAO = 'E' AND DESTINO = 'HMSJ_054'

select cd_paciente, cd_atendimento from atendime where cd_atendimento in (35479)

select cd_estoque, cd_mvto_estoque, cd_atendimento, cd_aviso_cirurgia from mvto_estoque where cd_aviso_cirurgia = 10925 --and cd_atendimento is null
order by cd_aviso_cirurgia

select dt_inicio_age_cir from age_cir where cd_aviso_cirurgia = 5329
alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss' -- alterar o formato da hora
select

select * from prod_atend where cd_aviso_cirurgia is not null and cd_atendimento is null and cd_estoque in (3,4)

update prod_atend set cd_atendimento = 22630 where cd_aviso_cirurgia = 5963 and cd_atendimento is null

DELETE ITMVTO_ESTOQUE WHERE CD_MVTO_ESTOQUE = 296857

SELECT * FROM PROD_ATEND WHERE CD_AVISO_CIRURGIA = 8760
update prod_atend set cd_atendimento = 32124 WHERE CD_AVISO_CIRURGIA = 8760 and cd_atendimento is null
