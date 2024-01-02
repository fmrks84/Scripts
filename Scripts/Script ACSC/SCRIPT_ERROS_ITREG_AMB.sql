select /*cd_pro_fat, vl_unitario , qt_lancamento , vl_total_conta*/ * from itreg_amb where cd_reg_amb in 
(select cd_Reg_amb from reg_amb where cd_remessa = 314793
and cd_reg_amb in (3546846))--,3528609,3538855,3576237)
and cd_pro_fat in (60018593,60027452);

select * from reg_amb where cd_remessa = 314793
and cd_reg_amb in (3546846)

DELETE from tiss_guia y where y.Cd_Reg_amb = 3546846
select * from i
--teste 3200351
update itreg_amb  set cd_reg_amb = 3546846
select * from atendime where cd_atendimento = 4258220 --and id_it_envio is null --= 342860858

--select * from pro_Fat where cd_pro_fat in ('60029293','60018593','60023112','60023180','60028475')--for update
select * from reg_amb order by 1 desc 
select * from reg_amb where  cd_reg_amb in (3546846)-- for update

insert into reg_amb (cd_reg_amb,dt_lancamento,cd_convenio,sn_fatura_impressa,sn_fechada,dt_lancamento_final,cd_multi_empresa,cd_regra)
values (seq_reg_amb.nextval,'29/09/2022',190,'N','N','29/09/2022',25,194)--from reg_amb where cd_multi_empresa = 25

select * from itreg_amb where cd_reg_amb = 3546846 and cd_pro_fat in (60023180,60023112,60018593,60028475)

select * from itreg_amb where cd_pro_Fat in (60023180,60023112,60018593,60028475) and cd_convenio = 190 order by 1 desc 
select * from pro_Fat where cd_pro_fat in ('60023180','60023112','60018593','60028475')

SELECT * FROM EMPRESA_CONVENIO


SELECT * ]
UPDATE VAL_PRO SET SN_ATIVO = 'S'
WHERE CD_PRO_fAT = 60023180 AND CD_tAB_FAT = 842
AND SN_ATIVO = 'N'
