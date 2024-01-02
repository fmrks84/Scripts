----------------------------------------------------Alterar o Atendimento----------------------------------------------------------------------------
/*
select * from pre_med where cd_atendimento = 896579   ---- Prescrição Medica
update pre_med set cd_atendimento = 896577 where cd_atendimento = 896579
select * from ligacao_paciente where cd_atendimento = 607753  --- Conta de Telefone
update ligacao_paciente set cd_atendimento = 607733 where cd_atendimento = 607753
select * from mvto_estoque where cd_atendimento = 896579   --- Movimentação do Estoque
update mvto_estoque set cd_atendimento = 896577 where cd_atendimento = 896579
select * from mov_cardapio where cd_atendimento = 466219 ---Movimentação de Cardapio
update mov_cardapio set cd_atendimento = 607733 where cd_atendimento = 607753
select * from solsai_pro where cd_atendimento = 896579  -- Solicitação de Produto
update solsai_pro set cd_atendimento = 896577 where cd_atendimento = 896579
select * from itsolsai_pro where cd_solsai_pro in (select cd_solsai_pro from solsai_pro where cd_atendimento = 466219 )
select * from reg_fat where cd_atendimento = 607753   --- Conta do Paciente
update reg_fat set cd_atendimento = 607733 where cd_atendimento = 607753
select cd_lancamento, cd_reg_fat from dbamv.itreg_fat where cd_reg_fat IN(396506,395463) order by cd_lancamento--396561
update itreg_fat set cd_reg_fat = 395463 where cd_reg_fat IN(396506)
select * from pre_med where cd_pre_med = 3604331 -- Prescrição Medica
select * from ped_lab where cd_atendimento = 466219  -- Pedido de Exames (Laboratorio)
update ped_lab set cd_atendimento = 440157 where cd_atendimento = 439990
select * from guia where cd_atendimento = 466219    --- Guia de Autorização
update guia set cd_atendimento = 440157 where cd_atendimento = 439990
select * from conta_kit where cd_atendimento = 466219  -- Kit da Conta
update conta_kit set cd_atendimento = 440157 where cd_atendimento = 439990
select * from fechamento_pagu where cd_atendimento = 855168  -- Fechamento do PAGU
update fechamento_pagu set cd_atendimento = 896577 where cd_atendimento = 896579
select * from log_diaria_automatica where cd_atendimento = 466219
select * from dbamv.prescricao_medica_via where cd_pre_med in (select cd_pre_med from dbamv.pre_med where cd_atendimento in (589159,588482) ) -- Prescrição Medica Via
select cd_registro_documento from registro_documento where cd_atendimento = 466219
select * from registro_resposta where cd_registro_documento in (select cd_registro_documento from registro_documento where cd_atendimento in (589159,588482))
*/
-----------------------------------------------------------Deletar Atendimento-----------------------------------------------------------------------------

delete from ped_lab where cd_atendimento in (906729);  -- Pedido de exames
delete from itped_lab where cd_ped_lab in (select cd_ped_lab from ped_lab where cd_atendimento in (906726)) ;-- Itens do pedido
delete from itmvto_estoque where cd_mvto_estoque in (select cd_mvto_estoque from mvto_estoque where cd_atendimento in (906726)  ); -- Itens da Movimentação do Estoque
delete from mov_isolamento where cd_atendimento in (906726);   -- Isolamento
delete from tb_solic_limpeza where cd_atendimento in (906726);  -- Limpeza
delete from mov_int where cd_atendimento in (906726);   --  Movimentação de Leito
delete from pendencia_atendimento where cd_atendimento in (906726); -- Pendencia de Atendimento
delete from responsa where cd_atendimento in (906726); --- Responsavel do Atendimento
delete from guia where cd_atendimento in (906726); -- Guia de Atendimento
delete from mvto_estoque where cd_atendimento in (906726);   -- Movimentação de estoque
delete from it_guia where cd_guia in (select cd_guia from guia where cd_atendimento in (906726)); -- Itens da Guia de Atendimento
delete from itmvto_estoque_custo where cd_mvto_estoque in (select cd_mvto_estoque from mvto_estoque where cd_atendimento in (906726)); -- Custo mvto estoque
delete from itmvto_estoque where cd_mvto_estoque in (select U.cd_mvto_estoque from DBAMV.mvto_estoque U where cd_atendimento in (906726) ); -- Custo mvto estoque
delete from itmvto_kits where  cd_mvto_estoque in (select cd_mvto_estoque from mvto_estoque where cd_atendimento in (906726)); -- Kits
delete from solsai_pro where cd_atendimento in (906726) ; -- Solicitação de produto
delete from prod_atend where cd_atendimento in (906726);-- Produto do atendimento
delete from mvto_gases where cd_atendimento in (906726);   -- Gases
delete from log_alta where cd_atendimento in (906726);  --  Log das Altas
delete from mvto_estoque where cd_atendimento in (906726);  -- Movimentaçõs de Produtos
delete from it_same where cd_atendimento in (906726) ; --- Same
delete from reg_fat where cd_atendimento in (906726) ;--- Conta hospitalar
delete from itreg_amb where cd_atendimento in (906726);
delete from itreg_fat where cd_reg_fat in (select cd_reg_fat from reg_fat where cd_atendimento in (906726) );  -- Itens da Conta Hospitalar
delete from aviso_cirurgia where cd_atendimento in (906726) ;  -- aviso de cirurgia
delete from aviso_equipamentos where cd_aviso_cirurgia in (select cd_aviso_cirurgia from aviso_cirurgia where cd_atendimento in (906726)) ;-- equipamentos do aviso
delete from cirurgia_aviso where cd_aviso_cirurgia in (select cd_aviso_cirurgia from aviso_cirurgia where cd_atendimento in (906726)); -- cirurgias do aviso
--delete from itpre_med where cd_pre_med in (select cd_pre_med from pre_med where cd_atendimento in (906726)); --- itens da prescrição
--delete from pre_med where cd_atendimento in (906726);  -- prescrição medica
--delete from dbamv.prescricao_medica_via where cd_pre_med in (select cd_pre_med from dbamv.pre_med where cd_atendimento in (906726)) ;-- Prescrição Medica Via
delete from fechamento_pagu where cd_atendimento in (1013838);  -- fechamento do pagu
delete from dbamv.hritpre_med where cd_atendimento in (1268955);
delete from itsolsai_pro_atendido where cd_itsolsai_pro in (select cd_itsolsai_pro from itsolsai_pro where cd_solsai_pro
                                                        in (select cd_solsai_pro from solsai_pro where cd_atendimento in (906726))) ;-- Itens da Solicitação Atendidos
delete from itsolsai_pro where cd_solsai_pro in (select cd_solsai_pro from solsai_pro where cd_atendimento in (906726)); -- Itens da Solicitação
--delete from atendime where cd_atendimento in (906726) ; -- Atendimento
--delete from tb_atendime where cd_atendimento in (906726) ;-- Tb Atendimento
DELETE from mov_hosp where cd_atendimento in (1013838);  -- Movimentação Hospitalar
delete from conta_kit where cd_atendimento in (906726) ;--- Kits da Conta
delete from fracionamento where cd_atendimento in (906726) ; --- Fracionamento da Conta
delete from log_fracionamento where cd_atendimento in (906726);  -- Log do Fracionamento da Conta
delete from log_diaria_acompanhante where cd_mov_int in (906726);   -- Log Diaria de Acompanhante
delete from log_diaria_automatica  where cd_atendimento in (906726) ; -- Diarias
delete from recem_nascido where cd_atendimento in (906726) ; -- Recem Nasido
delete from registro_documento where cd_atendimento in (906726);
delete from registro_resposta where cd_registro_documento in (select cd_registro_documento from registro_documento where cd_atendimento in (906726) );
delete from dbamv.itpre_med where cd_pre_med in (select cd_pre_med from dbamv.pre_med where cd_atendimento in (906726))


Begin
  Pkg_Mv2000.Atribui_Empresa( 1); 
End;


/*


---- Empresa do Atendimento
-->> Trocar a empresa e rodar uma vez para cada empresa


---- Empresa do Atendimento

--- Trigger para Desabilitar (Caso Necessite)
alter trigger dbamv.trg_itpre_med_pre_uso enable
alter trigger dbamv.trg_itpre_med_pre_uso disable

alter trigger dbamv.trg_log_hritpre_med  enable
alter trigger dbamv.trg_log_hritpre_med disable

alter trigger dbamv.trg_u_mvto_estoque enable
alter trigger dbamv.trg_u_mvto_estoque disable

alter trigger dbamv.trg_d_itmvto_estoque enable
alter trigger dbamv.trg_d_itmvto_estoque disable

alter trigger dbamv.trg_lanca_ffcv enable
alter trigger dbamv.trg_lanca_ffcv disable

alter trigger dbamv.trg_solsai_pro enable
alter trigger dbamv.trg_solsai_pro disable

alter trigger dbamv.trg_itsolsai_pro_atendido enable
alter trigger dbamv.trg_itsolsai_pro_atendido disable

---- Trigger para Desabilitar (Caso Necessite)


SELECT * FROM ITMOV_CARDAPIO
 WHERE CD_MOV_CARDAPIO IN
  (SELECT CD_MOV_CARDAPIO
     FROM MOV_CARDAPIO
     WHERE CD_MULTI_EMPRESA = 2 )
 AND QT_CARDAPIO >= 65

*/
