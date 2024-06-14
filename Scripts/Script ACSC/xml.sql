prompt Importing table dbamv.config_proto...
set feedback off
set define off

insert into dbamv.config_proto (CD_CONVENIO, NM_CONVENIO, CD_HOSPITAL, CD_MULTI_EMPRESA, CD_PROTO, DS_ID_CLIENTE, CD_ID_ESTRUTURA_SRV, CD_CONFIG_PROTO, TP_UTILIZACAO, CD_CONDICAO1, CD_CONDICAO2, CD_CONDICAO3, DS_VALOR_FIXO, DS_QUERY_ALTERNATIVA, TP_PREENCHIMENTO)
values (104, 'SUL AMERICA SAUDE', 1825, 3, 3, '000043', 1435, 6628, '1', null, null, null, null, 'select distinct min(to_char(g.dt_autorizacao,''rrrr-mm-dd''))  from dbamv.guia g where g.cd_atendimento = :par2 and g.tp_guia = ''P''', 'N');



select * from all_tab_columns x where x.column_name like '%CD_CONFIG_PROTO%'
select * from all_sequences xp where xp.sequence_name like '%CONFIG%PROTO%'
select * from tuss where cd_tuss in ('81019734') and cd_convenio = 7     

select * from 
itreg_amb irf 
inner join reg_amb rf on rf.cd_reg_amb = irf.cd_reg_amb and rf.cd_convenio = 7 
where irf.cd_pro_Fat = '10002369' 
order by irf.hr_lancamento desc 
