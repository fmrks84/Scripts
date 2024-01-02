select reg_amb.cd_multi_empresa from reg_amb where cd_reg_amb in (4404896,
4418576,
4391992,
4411725,
4422988,
4414153);

select * from reg_amb where cd_reg_amb in (
4388306,4466771
);

select cd_convenio ,reg_fat.cd_Reg_fat,reg_fat.dt_inicio  from reg_fat where cd_reg_fat in (583545,
589303,
577456,
587178,
589040,
578949,
587179
)

select * from reg_Fat where cd_Reg_Fat in (577456,
578949,
583545,
587178,
587179,
589040,
589303) --- habilitar convenio 55 para criação da remessa 




select * from remessa_fatura where cd_remessa in (385219,385209);
select * from fatura ft where ft.cd_fatura in (52003)


select * from atendime where cd_atendimento (5313697,5328518,5336692,5339627) -- externo manter convenio 55 - ativar para convenio criar remessa 
select * from atendime where cd_atendimento (5309140) -- externo manter convenio 57 - ativar para convenio criar remessa 
select * from config_  diaria_automatica
select * from atendime where cd_atendimento in (5349858,5344753,5402895)-- externo colocar para 56;



