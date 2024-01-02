select * from dbamv.vw_ovmd_guia_interna_urgencia;
select * from ensemble.vw_ovmd_guia_anexos;
select * from ensemble.vw_ovmd_guia_sadt_eletivo Z where Z.nm_paciente = 'YARA%'--- id = '1202867.1-2701';
--select * from dbamv.vw_ovmd_guia_sadt_urgencia;
select * from atendime a where cd_Atendimento = 2693637
--select * from ensemble.vw_ovmd_guia_anexos;
select * from ensemble.vw_ovmd_guia_sadt_eletivo --where nm_paciente = 'LUIS GUILHERME BAZZOLI' ---CARLOS DE OLIVEIRA NETTO,LUIS GUILHERME BAZZOLI
select * from ensemble.vw_ovmd_guia_interna_urgencia
select * from ensemble.vw_ovmd_guia_anexos;

select * from guia A1  order by a1.dt_geracao desc --where a1.dt_solicitacao 
select * from guia where cd_guia in (2049269,2103192)

select * from res_lei a
where a.Cd_Aviso_Cirurgia is null
and a.Cd_Atendimento is null 
and a.cd_multi_empresa = 7
and a.cd_convenio in (41,42)
--and a.cd_res_lei = 151650
order by a.Dt_Reserva desc 


update guia z set z.dt_geracao = sysdate 
where z.cd_res_lei = 155621;
commit

update res_lei set dt_Reserva = sysdate
where cd_Res_lei = 155621;
commit 

update guia z1 set z1.dt_solicitacao = sysdate
where z1.Cd_Res_Lei = 155621;
commit 

update dbamv.anexos_guia set anexos_Guia.Dt_Efetivacao = sysdate
where anexos_guia.cd_guia = '2103192';
commit
--where cd_res_lei = 70902

select * from tiss_sol_guia y where y.cd_guia = 1323954

select * from convenio cv
inner join empresa_convenio ecv on ecv.cd_convenio = cv.cd_convenio
where ecv.cd_multi_empresa = 7

----------

select * from exa_rx where exa_rx_cd_pro_fat ='40901106'

select * from item_agendamento where cd_exa_rx = 1045 --511

select * from it_agenda_central where cd_convenio = 41 and cd_item_agendamento = 511 and cd_atendimento is null


select * from it_agenda_central where cd_agenda_central in (10096) for update


select * from convenio where cd_convenio = 48



select * from mvintegra.depara a
where a.cd_sistema_integra = 'OVERMIND'


select 
b.cd_convenio,
b.nm_convenio,
a.cd_multi_empresa
from 
dbamv.empresa_convenio a
inner join dbamv.convenio b on b.cd_convenio = a.cd_convenio
where a.cd_multi_empresa in (3,4,7,10)
and b.nm_convenio in ('AMIL ASSIST MED - GRUPO AMIL'
,'BRADESCO SAUDE'
,'CABESP'
,'CARE PLUS'
,'CASSI'
,'CENTRAL NACIONAL UNIMED'
,'GAMA SAUDE'
,'MEDISERVICE'
,'NOTRE DAME'
,'PETROBRAS DISTRIBUIDORA'
,'PETROBRAS PETROLEO BRASILEIRO'
,'SAUDE CAIXA'
,'UNAFISCO SAUDE'
,'VIVEST ( FUNDAÇÃO CESP')
--and b.cd_convenio in (7,12,5,11,22,32,23,34,50,13,38,39,8,9)
and b.tp_convenio = 'C'
order by a.cd_multi_empresa


select * from mvintegra.depara a
where a.cd_sistema_integra = 'OVERMIND'
