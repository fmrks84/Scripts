SELECT CD_REG_FAT CONTA, REG_FAT.SN_FECHADA FECHADA, CD_CONVENIO CONVENIO, CD_CON_PLA, DT_INICIO INICIO, DT_FINAL FINAL, CD_MULTI_EMPRESA EMPRESA
     , REG_FAT.CD_REMESSA, CD_ATENDIMENTO ATENDIMENTO, CD_CONTA_PAI CONTA_PAI, CD_REMESSA_PAI REMESSA_PAI, VL_TOTAL_CONTA TOTAL_CONTA
     , VL_DESCONTO_CONTA DESCONTO, REG_FAT.DT_FECHAMENTO FECHAMENTO
FROM REG_FAT, REMESSA_FATURA
WHERE NVL(CD_CONTA_PAI,CD_REG_FAT) in (376697)--,354820,359202)
AND  REG_FAT.CD_REMESSA = REMESSA_FATURA.CD_REMESSA(+)
--AND  NVL(CD_CONTA_PAI,CD_REG_FAT) in (325038)
--AND  CD_REG_FAT IN (319967,319963)
ORDER BY CD_ATENDIMENTO, CD_MULTI_EMPRESA, CD_REG_FAT, CD_REMESSA, DT_INICIO, DT_FINAL



alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss' --- Alterar o formato da data.

Begin
  Pkg_Mv2000.Atribui_Empresa(1);  -->> Trocar a empresa e rodar uma vez para cada empresa (Caso seja Multi-Empresa
End;

alter trigger dbamv.trg_vl_total_rfat enable
alter trigger dbamv.trg_vl_total_rfat disable
alter trigger dbamv.trg_reg_fat_existe_nf enable
alter trigger dbamv.trg_reg_fat_existe_nf disable
alter trigger dbamv.trg_reg_fat_dt_inicio enable
alter trigger dbamv.trg_reg_fat_dt_inicio disable
alter trigger dbamv.trg_reg_fat_verifica_remessa enable
alter trigger dbamv.trg_reg_fat_verifica_remessa disable


select CD_REG_FAT, SN_FECHADA, DT_FECHAMENTO, CD_MULTI_EMPRESA, CD_ATENDIMENTO, DT_INICIO, DT_FINAL,CD_CONVENIO, CD_CON_PLA, CD_REGRA, CD_CONTA_PAI, CD_REMESSA, VL_TOTAL_CONTA
from reg_fat where NVL (cd_CONTA_PAI, CD_REG_FAT) IN (388460) ORDER BY 3

select cd_itfat_nf, cd_nota_fiscal, qt_itfat_nf, vl_itfat_nf from itfat_nota_fiscal  where cd_reg_fat = 207672

select dt_inicio, dt_final, cd_multi_empresa, cd_reg_fat, cd_conta_pai from dbamv.reg_fat where nvl(cd_conta_pai,cd_reg_fat) = 309505 order by cd_reg_fat
SELECT * from dbamv.log_falha_importacao where cd_atendimento = 180809 and tp_erro <> '08'

select * from reg_fat where sn_fechada = 'S' and cd_remessa is not null and vl_total_conta = '0,0'
select from conta_kit where cd_reg_fat in (select cd_reg_fat from reg_fat where sn_fechada = 'S' and cd_remessa is not null and vl_total_conta = '0,0')

----------------------------------------------------------

select cd_reg_fat, cd_multi_empresa, cd_pro_fat, qt_lancamento, dt_lancamento, cd_conta_pai, cd_lancamento
from itreg_fat
where cd_reg_fat in (select cd_reg_fat from reg_fat where cd_atendimento = 368914 AND  NVL(CD_CONTA_PAI,CD_REG_FAT) in (330535) )
and cd_gru_fat in (7,6)
--and cd_multi_empresa not in(4,5)
--and cd_mvto in (1799805,1796912,1800975,1800992,1803788,1796236,1800649,168234,160948,106949)
--and cd_reg_fat in ('53010221','53010205')
order by CD_REG_FAT, DT_LANCAMENTO

update itreg_fat set cd_multi_empresa = 4 where cd_reg_fat = 259688 and cd_gru_fat in (6,7) and cd_multi_empresa = 1
update itreg_fat set cd_reg_fat = 264636 where cd_reg_fat = 259688 and cd_gru_fat in (6,7) and cd_multi_empresa = 4
-----------------------------------------------------------------------------

select cd_reg_fat, dt_inicio, dt_final, cd_atendimento, cd_convenio, cd_remessa, cd_conta_pai, vl_total_conta, cd_multi_empresa, sn_fechada, sn_fatura_impressa
from reg_fat
where cd_multi_empresa in (4,5)
and vl_total_conta < '0,01'or vl_total_conta is null
and cd_convenio not in (348,352,379,351)
and sn_fechada = 'S'
and sn_fatura_impressa = 'S'
order by 4 desc





select * from remessa_fatura where cd_remessa in (15073,15074,15075,15660,15659)

select cd_reg_fat, cd_prestador, cd_ati_med, vl_ato from  itlan_med where cd_reg_fat in (242462,242475,242488)




select cd_pro_fat, vl_total_conta from dbamv.itreg_fat where cd_reg_fat = 365219 order by 1 desc
select cd_pro_fat, vl_total_conta, cd_conta_pai, cd_multi_empresa from dbamv.itreg_fat where cd_reg_fat = 365220 order by 1 desc
