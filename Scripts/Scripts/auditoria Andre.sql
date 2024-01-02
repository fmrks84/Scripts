select cd_atendimento ,nm_cliente, cd_reg_Fat ,cd_con_rec , dt_emissao , ds_con_rec ,vl_previsto, cd_remessa, nr_documento ,dt_cancelamento, ds_cancelamento cd_usuario
from dbamv.con_rec where cd_Atendimento = 1008625
 
select cd_atendimento,nm_cliente, nr_id_nota_fiscal, vl_total_nota, dt_emissao, dt_saida, cd_status,cd_usuario_excluiu_conta, dt_excluiu_conta , cd_conta_excluida, dt_cancelamento
from dbamv.nota_fiscal where nr_id_nota_fiscal = 113774 -- nota que foi cancelada (113774)  (113773 nota que foi emitida)

/*
select * from dbamv.itcon_rec where cd_con_rec in (265703)


select * from dbamv.reg_fat where cd_reg _Fat = 918939
select * from dbamv.reccon_rec where cd_itcon_rec in (264046)--(264046,264047)

/


