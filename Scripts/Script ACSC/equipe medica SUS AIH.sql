update procedimento_sus_detalhe

SET sn_exige_equipe_medica = 'S'

WHERE cd_procedimento = 0409010596  
--Segue anexo evidencias 



select sn_exige_equipe_medica from procedimento_sus_detalhe where cd_procedimento = 0409010596 --for update

select * from procedimento_sus_regra where cd_procedimento = 0409010596

select * from procedimento 

UPDATE dbamv.Procedimento_Detalhe_Vigencia SET sn_exige_equipe_medica = 'S' WHERE cd_procedimento = '0409010596';
COMMIT;
