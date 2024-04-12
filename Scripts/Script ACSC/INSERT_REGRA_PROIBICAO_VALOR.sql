insert into dbamv.regra_proibicao_valor (CD_REGRA_PROIBICAO_VALOR, CD_CONVENIO, CD_CON_PLA, CD_TAB_FAT, TP_TAB_FAT, TP_GRU_PRO, CD_GRU_PRO, DT_INICIAL_PROIBICAO, TP_PROIBICAO, TP_ATENDIMENTO, VL_BASE, SN_ATIVO, DT_REGISTRO, NM_USUARIO_REGISTROU, DT_DESATIVOU, NM_USUARIO_DESATIVOU)
values (seq_regra_proibicao_valor.nextval, 41, null, null, 'R', 'MT', null, to_date('01-03-2024', 'dd-mm-yyyy'), 'AG', 'T', 4000.0000, 'S', sysdate, 'ACDEOLIVEIRA', null, null);
commit;

UPDATE  from regra_proibicao_valor where cd_convenio = 41-- and cd_Regra_proibicao_valor = 283-- ;
select count(*)  from proibicao where cd_convenio = 41  and cd_Regra_proibicao_valor = 288-- */and cd_pro_fat = '09009348' --proibicao.cd_regra_proibicao_valor = 283 ;

insert into dbamv.proibicao (CD_CON_PLA, CD_CONVENIO, CD_PRO_FAT, TP_PROIBICAO, DT_INICIAL_PROIBICAO, TP_ATENDIMENTO,CD_REGRA_PROIBICAO_VALOR,CD_MULTI_EMPRESA) (select cd_con_pla,cd_convenio,'09009348','AG','01/03/2024','T',288,7 FROM DBAMV.EMPRESA_CON_PLA WHERE CD_CONVENIO = 41 AND SN_ATIVO = 'S');
commit;



select 
DISTINCT 
PF.CD_PRO_FAT
from dbamv.pro_Fat pf 
inner join dbamv.gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
INNER JOIN VAL_PRO VP ON VP.CD_PRO_FAT = PF.CD_PRO_FAT AND VP.CD_TAB_FAT = 2
WHERE VP.VL_TOTAL > = '4000,00'
and gp.tp_gru_pro = 'MT' --and gp.cd_gru_pro = 
and pf.sn_ativo = 'S'
order by 1


select * from atendime where cd_atendimento = 5860487;
select * from reg_fat where cd_atendimento = 5860487
