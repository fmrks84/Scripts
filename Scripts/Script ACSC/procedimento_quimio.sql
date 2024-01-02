select * from atendime where cd_atendimento in (2796460,2800769,2800979,2801175)
select * from convenio where cd_convenio = 8 
--48
select * from ori_ate a where a.cd_ori_ate in (22,62)
select * from proibicao where cd_convenio = 8 and cd_con_pla = 1 and cd_pro_fat = '20104308'
--ORIGEM 22,62,19,18 NUNCA COBRAR CONSULTAR

--PACOTE 10000414

select * from regra_substituicao_proced x2 where x2.cd_pro_fat_substituto = 10000414
--ORIGEM CENTRO DE INFUSÃO 19
--20104391

select * from tuss where cd_pro_Fat = '10000414'
select 


select * from atendime where cd_atendimento in (2796460)
select * from it_agenda_central a where a.cd_atendimento in (2801175)
select * from agenda_central a1 where a1.cd_agenda_central in (390853);
select * from atendime where cd_Atendimento = 2796460
select * from item_agendamento b where b.cd_item_agendamento in (1947)--1947,2168)
select * from proibicao where cd_convenio = 16 and cd_con_pla = 8 and cd_pro_Fat = '10000414'
select qt_lancamento , cd_gru_Fat , cd_pro_Fat , cd_gru_fat, cd_guia from itreg_amb where cd_Reg_amb = 2337550 

select * from tiss_guia x1 where x1.cd_atendimento = 2839894

select * from itreg_amb where cd_atendimento = 2796460
