select a.cd_atendimento from aviso_cirurgia a where a.cd_aviso_cirurgia = 433182  -- 1º
select cd_reg_Fat from reg_Fat where cd_atendimento = 5853379 --- 2º
select * from dbamv.itcob_pre where cd_reg_fat = 649828 ---- 3º 
delete dbamv.itcob_pre where cd_reg_fat = 649828;
COMMIT;   --- 4º


