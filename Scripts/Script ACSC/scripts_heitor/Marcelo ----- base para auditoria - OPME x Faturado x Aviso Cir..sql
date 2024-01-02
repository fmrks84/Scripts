/*OPME's x contas faturadas x Aviso de Cir.*/
select distinct
i.cd_lancamento,
DECODE (a.cd_multi_empresa,7,'HSC', 3, 'CSSJ', 4, 'HST', 10,'HSJ', 25,'HCNSC') MULTI_EMPRESA,
e.cd_aviso_cirurgia,
a.cd_atendimento ATENDIMENTO,
a.cd_reg_fat CONTA,
a.dt_inicio,
a.dt_final,
a.cd_convenio,
c.nm_convenio,
i.cd_pro_fat CD_PROCEDIMENTO,
p.ds_pro_fat DS_PROCEDIMENTO,
i.dt_lancamento,
i.qt_lancamento,
i.vl_unitario,
i.sn_pertence_pacote,
a.sn_fechada CONTA_FECHADA,
a.cd_remessa,
r.sn_fechada REMESSA_FECHADA,
r.sn_paga REMESSA_PAGA

from reg_fat a

LEFT JOIN remessa_fatura r ON (a.cd_remessa = r.cd_remessa)
INNER JOIN itreg_fat i ON (a.cd_reg_fat = i.cd_reg_fat)
INNER JOIN pro_fat p ON (i.cd_pro_fat = p.cd_pro_fat)
INNER JOIN convenio c ON (a.cd_convenio = c.cd_convenio)
LEFT JOIN it_guia d  ON d.cd_guia = i.cd_guia and i.cd_pro_fat = d.cd_pro_fat 
LEFT JOIN guia e ON e.cd_guia = d.cd_guia 
where a.cd_multi_empresa = '7'
--and a.dt_inicio BETWEEN To_Date ('01/08/2020','dd/mm/yyyy') AND To_Date ('31/07/2021','dd/mm/yyyy')
--and i.sn_pertence_pacote = 'S'
and i.cd_gru_fat in (5,9)
and a.cd_atendimento in ('2131769','2139172','1902814','2334053','2358368','2420140','2439576','2531899','2603469','2629947')
--and a.cd_reg_fat = 294590

ORDER BY 4,5


;
SELECT * FROM ITREG_FAT WHERE CD_REG_FAT = 294590 AND CD_GRU_FAT IN (5,9)





