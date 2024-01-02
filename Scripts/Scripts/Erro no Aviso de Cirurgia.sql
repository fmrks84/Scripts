select * from itmvto_estoque where cd_mvto_estoque = 296857 --cd_atendimento = 12577
delete from mvto_estoque where cd_mvto_estoque = 296857 --cd_atendimento = 12577

select * from prod_atend where cd_aviso_cirurgia = 10925 --and cd_atendimento = 12577
delete from prod_atend where cd_aviso_cirurgia = 10925 --and cd_atendimento = 12577


update prod_atend set cd_atendimento = 12577 where cd_aviso_cirurgia = 3489


