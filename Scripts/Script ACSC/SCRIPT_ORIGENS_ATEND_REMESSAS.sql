SELECT 
DISTINCT 
ATD.CD_ATENDIMENTO,
ATD.CD_ORI_ATE,
atd.tp_atendimento
FROM 
REMESSA_FATURA RM 
INNER JOIN REG_AMB RA ON RA.CD_REMESSA = RM.CD_REMESSA
INNER JOIN ITREG_AMB IRA ON IRA.CD_REG_AMB = RA.CD_REG_AMB 
INNER JOIN ATENDIME ATD ON ATD.CD_ATENDIMENTO = IRA.CD_ATENDIMENTO
WHERE RM.CD_REMESSA = 384929

select * from ori_Ate where cd_ori_Ate in (141,145,149)


select * from dbasgu.vw_usuarios x where x.CD_USUARIO = 'T122672';
select * from dbasgu.papel_usuarios xx where xx.cd_usuario in (select x.CD_USUARIO from dbasgu.vw_usuarios x where x.CD_USUARIO = 'T122672')
