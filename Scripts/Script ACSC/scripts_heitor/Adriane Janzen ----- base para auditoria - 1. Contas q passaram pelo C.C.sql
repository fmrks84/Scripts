--Refer�ncias: CSSJ / Contas de Interna��o faturadas de janeiro a abril de 2020 / somente Conv�nios
--1)  Rela��o de atendimentos e contas que tiveram passagem nos Centros Cir�rgicos e UTI (dever� conter tamb�m as colunas (CD_PRO_FAT/ DS_PRO_FAT) e as demais informa��es que constam em relat�rios que voc� j� nos enviou. Ex.: Faturamento

select r.cd_Atendimento, r.cd_reg_Fat conta, c.nm_convenio, to_char(f.dt_competencia,'mm/yyyy')competencia, r.vl_total_conta,
i.cd_pro_Fat, p.ds_pro_Fat, i.qt_lancamento, i.vl_unitario, i.vl_total_conta vl_total, s.nm_setor
from reg_Fat r, itreg_Fat i, pro_Fat p, convenio c, setor s, remessa_fatura rf, fatura f
where r.cd_reg_fat = i.cd_reg_Fat
and   i.cd_pro_fat = p.cd_pro_fat
and   r.cd_convenio = c.cd_convenio
and   i.cd_setor_produziu = s.cd_setor
and   r.cd_remessa = rf.cd_remessa
and   rf.cd_fatura = f.cd_fatura
and   r.cd_multi_empresa = 3
and   c.tp_convenio = 'C'
and   f.dt_competencia between '01/01/2020' and '30/04/2020'
and   r.cd_reg_fat in (Select cd_reg_Fat from itreg_fat where tp_mvto = 'Cirurgia')
and   r.cd_reg_Fat in (select cd_reg_Fat from itreg_Fat where cd_setor_produziu in (select cd_setor from setor where nm_setor like '%UTI%'))
order by 4,2
