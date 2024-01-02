-- SELECT * FROM dbamv.comp_fatu_cssj_hsc


begin
DBAMV.PKG_MV2000.atribui_empresa (7);
END;
/

-- CREATE TABLE dbamv.comp_fatu_cssj_hsc AS


WITH fatu_comp AS (

--- bradesco 7, 73 ---
SELECT
cd_convenio,
nm_convenio,
cd_gru_fat,
ds_gru_fat,
cd_gru_pro,
ds_gru_pro,
cd_pro_fat,
ds_pro_fat,
qt_lancamento,
Round ((valor/qt_lancamento),2) Valor_cssj,
Round ((valor),2) Total_cssj,
Round((valor_hsc),2) valor_hsc,
Round((qt_lancamento * valor_hsc),2) total_hsc

FROM (

SELECT
r.cd_convenio,
c.nm_convenio,
i.cd_gru_fat,
gf.ds_gru_fat,
p.cd_gru_pro,
g.ds_gru_pro,
i.cd_pro_fat,
p.ds_pro_fat,
Sum(i.qt_lancamento) qt_lancamento,
Sum(Nvl(m.vl_ato,i.vl_total_conta)) valor,
dbamv.calc_vl_proc_unit ('C',           --TIPO_CONVENIO
                         i.cd_pro_fat,  --PROCEDIMENTO
                         sysdate,       --DT_REFERENCIA
                         sysdate,       --HR_REFERENCIA
                         7,             --CONVENIO
                         1,             --PLANO
                         'I',           --TIPO_ATENDE
                         null,          --TIPO_ACOMODA
                         'U',           --FLAG_VALOR
                         NULL           --nCdFranquia
                         ) valor_hsc
FROM
reg_fat r,
itreg_fat i,
pro_fat p,
gru_pro g,
gru_fat gf,
convenio c,
itlan_med m

WHERE r.cd_reg_fat = i.cd_reg_fat
AND r.cd_convenio = c.cd_convenio
AND i.cd_pro_fat = p.cd_pro_fat
AND p.cd_gru_pro = g.cd_gru_pro
AND i.cd_gru_fat = gf.cd_gru_fat
AND i.cd_reg_fat = m.cd_reg_fat (+)
AND i.cd_lancamento = m.cd_lancamento (+)
AND r.cd_convenio = 73
AND r.cd_remessa IN (SELECT cd_remessa
                      FROM remessa_fatura
                     WHERE cd_fatura IN (SELECT cd_fatura
                                          FROM fatura
                                         WHERE dt_competencia BETWEEN To_Date('01/01/2020','dd/mm/yyyy') and To_Date('31/10/2020','dd/mm/yyyy')
                                         AND cd_convenio = 73 ))
AND i.sn_pertence_pacote = 'N'
AND r.cd_remessa IN (SELECT cd_remessa FROM itfat_nota_fiscal)
GROUP BY r.cd_convenio, c.nm_convenio, i.cd_gru_fat, gf.ds_gru_fat, p.cd_gru_pro, g.ds_gru_pro, i.cd_pro_fat, p.ds_pro_fat
)

UNION ALL

--- cassi 12, 80 ---
SELECT
cd_convenio,
nm_convenio,
cd_gru_fat,
ds_gru_fat,
cd_gru_pro,
ds_gru_pro,
cd_pro_fat,
ds_pro_fat,
qt_lancamento,
Round ((valor/qt_lancamento),2) Valor_cssj,
Round ((valor),2) Total_cssj,
Round((valor_hsc),2) valor_hsc,
Round((qt_lancamento * valor_hsc),2) total_hsc

FROM (

SELECT
r.cd_convenio,
c.nm_convenio,
i.cd_gru_fat,
gf.ds_gru_fat,
p.cd_gru_pro,
g.ds_gru_pro,
i.cd_pro_fat,
p.ds_pro_fat,
Sum(i.qt_lancamento) qt_lancamento,
Sum(Nvl(m.vl_ato,i.vl_total_conta)) valor,
dbamv.calc_vl_proc_unit ('C',           --TIPO_CONVENIO
                         i.cd_pro_fat,  --PROCEDIMENTO
                         sysdate,       --DT_REFERENCIA
                         sysdate,       --HR_REFERENCIA
                         12,             --CONVENIO
                         1,             --PLANO
                         'I',           --TIPO_ATENDE
                         null,          --TIPO_ACOMODA
                         'U',           --FLAG_VALOR
                         NULL           --nCdFranquia
                         ) valor_hsc
FROM
reg_fat r,
itreg_fat i,
pro_fat p,
gru_pro g,
gru_fat gf,
convenio c,
itlan_med m

WHERE r.cd_reg_fat = i.cd_reg_fat
AND r.cd_convenio = c.cd_convenio
AND i.cd_pro_fat = p.cd_pro_fat
AND p.cd_gru_pro = g.cd_gru_pro
AND i.cd_gru_fat = gf.cd_gru_fat
AND i.cd_reg_fat = m.cd_reg_fat (+)
AND i.cd_lancamento = m.cd_lancamento (+)
AND r.cd_convenio = 80
AND r.cd_remessa IN (SELECT cd_remessa
                      FROM remessa_fatura
                     WHERE cd_fatura IN (SELECT cd_fatura
                                          FROM fatura
                                         WHERE dt_competencia BETWEEN To_Date('01/01/2020','dd/mm/yyyy') and To_Date('31/10/2020','dd/mm/yyyy')
                                         AND cd_convenio = 80 ))
AND i.sn_pertence_pacote = 'N'
AND r.cd_remessa IN (SELECT cd_remessa FROM itfat_nota_fiscal)
GROUP BY r.cd_convenio, c.nm_convenio, i.cd_gru_fat, gf.ds_gru_fat, p.cd_gru_pro, g.ds_gru_pro, i.cd_pro_fat, p.ds_pro_fat
)

UNION ALL

--- sul america 48, 104 ---
SELECT
cd_convenio,
nm_convenio,
cd_gru_fat,
ds_gru_fat,
cd_gru_pro,
ds_gru_pro,
cd_pro_fat,
ds_pro_fat,
qt_lancamento,
Round ((valor/qt_lancamento),2) Valor_cssj,
Round ((valor),2) Total_cssj,
Round((valor_hsc),2) valor_hsc,
Round((qt_lancamento * valor_hsc),2) total_hsc

FROM (

SELECT
r.cd_convenio,
c.nm_convenio,
i.cd_gru_fat,
gf.ds_gru_fat,
p.cd_gru_pro,
g.ds_gru_pro,
i.cd_pro_fat,
p.ds_pro_fat,
Sum(i.qt_lancamento) qt_lancamento,
Sum(Nvl(m.vl_ato,i.vl_total_conta)) valor,
dbamv.calc_vl_proc_unit ('C',           --TIPO_CONVENIO
                         i.cd_pro_fat,  --PROCEDIMENTO
                         sysdate,       --DT_REFERENCIA
                         sysdate,       --HR_REFERENCIA
                         48,             --CONVENIO
                         1,             --PLANO
                         'I',           --TIPO_ATENDE
                         null,          --TIPO_ACOMODA
                         'U',           --FLAG_VALOR
                         NULL           --nCdFranquia
                         ) valor_hsc
FROM
reg_fat r,
itreg_fat i,
pro_fat p,
gru_pro g,
gru_fat gf,
convenio c,
itlan_med m

WHERE r.cd_reg_fat = i.cd_reg_fat
AND r.cd_convenio = c.cd_convenio
AND i.cd_pro_fat = p.cd_pro_fat
AND p.cd_gru_pro = g.cd_gru_pro
AND i.cd_gru_fat = gf.cd_gru_fat
AND i.cd_reg_fat = m.cd_reg_fat (+)
AND i.cd_lancamento = m.cd_lancamento (+)
AND r.cd_convenio = 104
AND r.cd_remessa IN (SELECT cd_remessa
                      FROM remessa_fatura
                     WHERE cd_fatura IN (SELECT cd_fatura
                                          FROM fatura
                                         WHERE dt_competencia BETWEEN To_Date('01/01/2020','dd/mm/yyyy') and To_Date('31/10/2020','dd/mm/yyyy')
                                         AND cd_convenio = 104 ))
AND i.sn_pertence_pacote = 'N'
AND r.cd_remessa IN (SELECT cd_remessa FROM itfat_nota_fiscal)
GROUP BY r.cd_convenio, c.nm_convenio, i.cd_gru_fat, gf.ds_gru_fat, p.cd_gru_pro, g.ds_gru_pro, i.cd_pro_fat, p.ds_pro_fat
)

UNION ALL

--- amil 5, 68 ---
SELECT
cd_convenio,
nm_convenio,
cd_gru_fat,
ds_gru_fat,
cd_gru_pro,
ds_gru_pro,
cd_pro_fat,
ds_pro_fat,
qt_lancamento,
Round ((valor/qt_lancamento),2) Valor_cssj,
Round ((valor),2) Total_cssj,
Round((valor_hsc),2) valor_hsc,
Round((qt_lancamento * valor_hsc),2) total_hsc

FROM (

SELECT
r.cd_convenio,
c.nm_convenio,
i.cd_gru_fat,
gf.ds_gru_fat,
p.cd_gru_pro,
g.ds_gru_pro,
i.cd_pro_fat,
p.ds_pro_fat,
Sum(i.qt_lancamento) qt_lancamento,
Sum(Nvl(m.vl_ato,i.vl_total_conta)) valor,
dbamv.calc_vl_proc_unit ('C',           --TIPO_CONVENIO
                         i.cd_pro_fat,  --PROCEDIMENTO
                         sysdate,       --DT_REFERENCIA
                         sysdate,       --HR_REFERENCIA
                         5,             --CONVENIO
                         1,             --PLANO
                         'I',           --TIPO_ATENDE
                         null,          --TIPO_ACOMODA
                         'U',           --FLAG_VALOR
                         NULL           --nCdFranquia
                         ) valor_hsc
FROM
reg_fat r,
itreg_fat i,
pro_fat p,
gru_pro g,
gru_fat gf,
convenio c,
itlan_med m

WHERE r.cd_reg_fat = i.cd_reg_fat
AND r.cd_convenio = c.cd_convenio
AND i.cd_pro_fat = p.cd_pro_fat
AND p.cd_gru_pro = g.cd_gru_pro
AND i.cd_gru_fat = gf.cd_gru_fat
AND i.cd_reg_fat = m.cd_reg_fat (+)
AND i.cd_lancamento = m.cd_lancamento (+)
AND r.cd_convenio = 68
AND r.cd_remessa IN (SELECT cd_remessa
                      FROM remessa_fatura
                     WHERE cd_fatura IN (SELECT cd_fatura
                                          FROM fatura
                                         WHERE dt_competencia BETWEEN To_Date('01/01/2020','dd/mm/yyyy') and To_Date('31/10/2020','dd/mm/yyyy')
                                         AND cd_convenio = 68 ))
AND i.sn_pertence_pacote = 'N'
AND r.cd_remessa IN (SELECT cd_remessa FROM itfat_nota_fiscal)
GROUP BY r.cd_convenio, c.nm_convenio, i.cd_gru_fat, gf.ds_gru_fat, p.cd_gru_pro, g.ds_gru_pro, i.cd_pro_fat, p.ds_pro_fat
))
SELECT * FROM fatu_comp

WHERE total_hsc > 0
