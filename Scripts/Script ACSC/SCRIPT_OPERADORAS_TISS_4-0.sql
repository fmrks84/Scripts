select   
decode(econv.cd_multi_empresa, 7,'HSC', 3, 'CSSJ', 4, 'HST', 10, 'HSJ', 25, 'HCNSC', 11, 'HMRP') CASAS,
---COUNT(*),
x.cd_convenio,
conv.nm_convenio,
x.cd_versao_tiss

-- x.nr_registro_operadora_ans
 from dbamv.convenio_conf_tiss x 
 inner join convenio conv on conv.cd_convenio = x.cd_convenio
 inner join empresa_convenio econv on econv.cd_convenio = x.cd_convenio
 where-- x.cd_versao_tiss like ('4.0%')
-- and econv.cd_multi_empresa = 7
 ---x.nr_registro_operadora_ans is not nulll
 conv.nm_convenio like 'AFRESP%' --or conv.nm_convenio like'NOTRE%' -- SULAMAERICA, ALICE,MEDSENIOR,PORTO,CENTRAL NACIONAL
 --and x.cd_convenio  in (98,108,501,53,139,186,181)
 --and x.nr_registro_operadora_ans in ('326305','324477','366871')
-- and econv.cd_multi_empresa = 3
/*group by 
x.cd_convenio,
conv.nm_convenio,
x.cd_versao_tiss*/
 order by 1

/*
SELECT * FROM AVISO_CIRURGIA WHERE CD_aVISO_CIRURGIA = 380000;
SELECT * FROM CIRURGIA_AVISO WHERE CD_aVISO_CIRURGIA = 380000;
SELECT * FROM CIRURGIA WHERE CD_CIRURGIA = 1674;
SELECT * FROM PRO_fAT WHERE CD_PRO_FAT = '31002390'*/
