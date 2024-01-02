select 
sum(vl_total_conta),
sum(vl_glosa)
--SUM(vl)VL

from
(
select 
b.cd_pro_fat, 
c.ds_pro_fat,
b.cd_prestador,
 b.qt_lancamento, 
 b.vl_unitario, 
 b.vl_total_conta,
 b.cd_lancamento,
 '----->',
 a.cd_lancamento_fat, 
 a.qt_glosa,
 a.vl_glosa
  from glosas a
LEFT join itreg_Fat b on b.cd_reg_fat = a.cd_reg_fat and a.cd_lancamento_fat = b.cd_lancamento 
LEFT join pro_fat c on c.cd_pro_fat = b.cd_pro_fat
where a.cd_reg_fat = 235081
and b.sn_pertence_pacote = 'N'
--and b.vl_total_conta = a.vl_glosa
--and a.qt_glosa = 0
)


select * from itreg_fat where cd_reg_Fat = 231543 and sn_pertence_pacote = 'N'
--select * from auditoria_conta x where x.cd_reg_fat = 139730
select * from glosas where cd_Reg_Fat = 235081 -- and vl_glosa_pre_aceita = '0,00' 
SELECT * from glosas where cd_Reg_Fat = 235081 and cd_lancamento_fat in (281,175,42,159,146,197)
SELECT * FROM MOV_GLOSAS XX WHERE XX.CD_REMESSA = 451229
SELECT * FROM ITFAT_NOTA_FISCAL XYY WHERE XYY.CD_ITFAT_NF = 61187959
select * from glosas g
where g.cd_reg_fat = 231579


/*DELETE from itmov_glosas re where re.cd_itfat_nf in (37175961,
37175700,
37175951,
37175791,
37175729,
37175697,
37175779,
37175828)
*/
--select * from all_constraints const where const.CONSTRAINT_NAME like '%CNT_ITMOV_GLOSAS_GLOSAS_FK%'
