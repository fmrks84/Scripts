SELECT 
a.cd_atendimento,
a.cd_reg_fat,
a.cd_reg_amb,
A.CD_NOTA_FISCAL,
A.DT_EMISSAO,
A.NR_ID_NOTA_FISCAL,
A.HR_EMISSAO_NFE,
A.NR_NOTA_FISCAL_NFE,
A.NM_CLIENTE,
A.VL_TOTAL_NOTA,
D.TP_QUITACAO,
case when a.nr_nota_fiscal_nfe is null then to_char('NF_NAO_CONVERTIDA')
    else to_char(a.nr_nota_fiscal_nfe) 
    END STATUS_RPS_PREF
    
FROM
DBAMV.NOTA_FISCAL A
INNER JOIN DBAMV.CON_REC C ON C.CD_NOTA_FISCAL = A.CD_NOTA_FISCAL
INNER JOIN DBAMV.ITCON_REC D ON D.CD_CON_REC = C.CD_CON_REC
WHERE trunc(a.dt_emissao) = 
(select max (trunc(x.dt_emissao)) from nota_fiscal x  where x.cd_atendimento = a.cd_atendimento and x.hr_emissao_nfe = a.hr_emissao_nfe)                                                        
AND A.DT_EMISSAO BETWEEN '01/03/2022' AND '21/03/2022'
AND A.CD_ATENDIMENTO IS NOT NULL
and a.cd_multi_empresa = 1
ORDER BY A.DT_EMISSAO

;


SELECT 
a.cd_atendimento,
E.CD_REMESSA,
a.cd_reg_fat,
a.cd_reg_amb,
A.CD_NOTA_FISCAL,
A.DT_EMISSAO,
A.NR_ID_NOTA_FISCAL,
A.HR_EMISSAO_NFE,
A.NR_NOTA_FISCAL_NFE,
A.NM_CLIENTE,
sum(e.vl_itfat_nf)vl_total_nota,
D.TP_QUITACAO,
case when a.nr_nota_fiscal_nfe is null then to_char('NF_NAO_CONVERTIDA')
    else to_char(a.nr_nota_fiscal_nfe) 
    END STATUS_RPS_PREF
    
FROM
DBAMV.NOTA_FISCAL A
LEFT JOIN ITFAT_NOTA_FISCAL E ON E.CD_NOTA_FISCAL = A.CD_NOTA_FISCAL
left JOIN DBAMV.CON_REC C ON C.CD_NOTA_FISCAL = A.CD_NOTA_FISCAL
left JOIN DBAMV.ITCON_REC D ON D.CD_CON_REC = C.CD_CON_REC
WHERE trunc(a.dt_emissao) = 
(select max (trunc(x.dt_emissao)) from nota_fiscal x  where x.dt_emissao = a.dt_emissao)                                                        
AND A.DT_EMISSAO BETWEEN '01/03/2022' AND '21/03/2022'
--and a.nr_id_nota_fiscal = 862882
AND A.CD_ATENDIMENTO IS NULL
and a.cd_multi_empresa = 1
group by 
a.cd_atendimento,
E.CD_REMESSA,
a.cd_reg_fat,
a.cd_reg_amb,
A.CD_NOTA_FISCAL,
A.DT_EMISSAO,
A.NR_ID_NOTA_FISCAL,
A.HR_EMISSAO_NFE,
A.NR_NOTA_FISCAL_NFE,
A.NM_CLIENTE,
D.TP_QUITACAO

ORDER BY A.DT_EMISSAO




