select a.cd_atendimento from aviso_cirurgia a where a.cd_aviso_cirurgia = 433182  -- 1�
select cd_reg_Fat from reg_Fat where cd_atendimento = 5853379 --- 2�
select * from dbamv.itcob_pre where cd_reg_fat = 649828 ---- 3� 
delete dbamv.itcob_pre where cd_reg_fat = 649828;
COMMIT;   --- 4�


