SELECT a.cd_multi_empresa, a.dh_realizacao_consolidacao, a.dh_realizacao_fechamento_mes , a.cd_usuario_consolidacao,a.dt_competencia
FROM FECHAMENTO_DO_MES A 
WHERE  A.CD_MULTI_EMPRESA IN (2)
order by a.dt_competencia desc 
--,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
 --AND A.DT_COMPETENCIA = '01/05/2022' ORDER BY 1  
 --
select * FROM LOG_ERRO_ENT_PRO -- DELETAR O LOG 

--SELECT * FROM MULTI_EMPRESAS WHERE CD_MULTI_EMPRESA IN (14)
--SELECT *  FROM LOG_ERRO_ENT_PRO


--DBAMV.PRC_MGES_CUSTO_DIARIO_EXCEPTION_PRINCIPAL

--select * from nota_fiscal x where x.nr_id_nota_fiscal = 877643

