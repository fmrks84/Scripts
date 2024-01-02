select pd.cd_produto,
       pd.ds_produto,
       PD.CD_PRO_FAT
        from produto pd where pd.cd_produto in (2037627,2037628);
        
SELECT * FROM EST_PRO PS WHERE PS.CD_PRODUTO =  2037628       
        
select * from pro_fat pf where pf.cd_pro_fat in ('02037627','02037628')

select * from pacote where cd_pro_fat in (/*'02037627',*/'02037628') 
and dt_vigencia_final is null
and cd_convenio = 40



select * from gru_pro

select itreg_FAt.Dt_Lancamento,itreg_fat.cd_reg_fat,cd_pro_fat from itreg_Fat where cd_pro_fat in ('02037627','02037628') 
order by 1 desc 

--select * from convenio where cd_convenio in (40,48,213)
SELECT * FROM VAL_PRO WHERE CD_PRO_FAT = '10001664'
select * from reg_fat where cd_reg_Fat = 546902


select * from pacote where cd_pro_fat_pacote = 10001385
