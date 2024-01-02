/*chamado C2111/12392 - OPME's x contas faturadas*/
select distinct
DECODE (a.cd_multi_empresa,7,'HSC', 3, 'CSSJ', 4, 'HST', 10,'HSJ', 25,'HCNSC') MULTI_EMPRESA,
a.cd_atendimento ATENDIMENTO,
a.cd_reg_fat CONTA,
a.dt_inicio,
a.dt_final,
a.cd_convenio,
c.nm_convenio,
e.cd_aviso_cirurgia,
i.cd_pro_fat CD_PROCEDIMENTO,
p.ds_pro_fat DS_PROCEDIMENTO,
i.dt_lancamento,
i.qt_lancamento,
i.vl_unitario,
a.sn_fechada CONTA_FECHADA,
a.cd_remessa,
r.sn_fechada REMESSA_FECHADA,
r.sn_paga REMESSA_PAGA,
g.nr_id_nota_fiscal RPS,
g.nr_nota_fiscal_nfe NFE

from reg_fat a

LEFT JOIN remessa_fatura r ON (a.cd_remessa = r.cd_remessa)
INNER JOIN itreg_fat i     ON (a.cd_reg_fat = i.cd_reg_fat)
INNER JOIN pro_fat p       ON (i.cd_pro_fat = p.cd_pro_fat)
INNER JOIN convenio c      ON (a.cd_convenio = c.cd_convenio)
LEFT JOIN it_guia d       ON d.cd_guia = i.cd_guia and i.cd_pro_fat = d.cd_pro_fat --
LEFT JOIN guia e          ON e.cd_guia = d.cd_guia --
INNER JOIN itfat_nota_fiscal f ON f.cd_remessa = a.cd_remessa
INNER JOIN nota_fiscal g       ON g.cd_nota_fiscal = f.cd_nota_fiscal
--INNER JOIN ITMVTO_ESTOQUE F ON F.CD_MVTO_ESTOQUE = I.CD_MVTO
--INNER JOIN MVTO_ESTOQUE G ON G.CD_MVTO_ESTOQUE = F.CD_MVTO_ESTOQUE
where i.cd_gru_fat in (5,9)
and a.dt_inicio BETWEEN To_Date ('01/08/2020','dd/mm/yyyy') AND To_Date ('31/07/2021','dd/mm/yyyy')
and i.sn_pertence_pacote = 'S'
and a.cd_multi_empresa = '7'
--and a.cd_atendimento = 2233744

ORDER BY 2


