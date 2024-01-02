--grant connect to drmobile;
grant select, update on dbamv.agenda_central to drmobile;
grant select, insert, update, delete on dbamv.contato_paciente to drmobile;
grant select, update on dbamv.it_agenda_central to drmobile;
grant select on dbamv.convenio to drmobile;
grant select on dbamv.item_agendamento to drmobile;
grant select on dbamv.multi_empresas to drmobile;
grant select on dbamv.atendime to drmobile;
grant select on dbamv.agenda_central_item_agenda to drmobile;
grant select on dbamv.agenda_central_ser_tipo to drmobile;
grant select on dbamv.agenda_central_convenio to drmobile;
grant select, update, insert on dbamv.log_opera_agenda_central to drmobile;
grant select, update, insert on dbamv.movimento_agenda_central to drmobile;
grant select, update, insert on dbamv.it_movimento_agenda_central to drmobile;
grant select on dbamv.prestador to drmobile;
grant select on dbamv.ser_dis to drmobile;
grant select on dbamv.tip_mar to drmobile;
grant select on dbamv.unidade_atendimento to drmobile;
grant select on dbamv.paciente to drmobile;
grant select on dbamv.carteira to drmobile;
grant select on dbamv.especialid to drmobile;
grant select on dbamv.recurso_central to drmobile;
grant select on dbamv.set_exa to drmobile;
grant select on dbamv.setor to drmobile;
grant select on dbamv.pro_fat to drmobile;
grant select on dbamv.esp_med to drmobile;
grant select on dbamv.conselho to drmobile;
grant execute on dbamv.pkg_central_marcacoes to drmobile;
grant execute on dbamv.pkg_mv2000 to drmobile;
grant select on dbamv.seq_it_mov_agenda_central to drmobile;
grant select on dbamv.seq_movimento_agenda_central to drmobile;
grant select on dbamv.seq_log_opera_agenda_central to drmobile;


create table drmobile.horarios_agenda (nr_cpf varchar2(11), itini number,dt_coleta date);


create global temporary table drmobile.diag_fim
(
 idme number,
 dsme varchar2(2000),
 time date,
 med number,
 st number,
 en number
)
on commit delete rows;
