select 
decode(atd.cd_multi_empresa,4,'HST')CASA,
atd.cd_atendimento,
trunc(ac.dt_realizacao)dt_realizacao,
c.cd_cirurgia,
c.ds_cirurgia,
conv.cd_convenio,
conv.nm_convenio,
pav.cd_prestador,
pr.nm_prestador,
pr.ds_codigo_conselho CRM

from 
cirurgia c
inner join cirurgia_aviso ca on ca.cd_cirurgia = c.cd_cirurgia
inner join aviso_cirurgia ac on ac.cd_aviso_cirurgia = ca.cd_aviso_cirurgia
inner join atendime atd on atd.cd_atendimento = ac.cd_atendimento
inner join convenio conv on conv.cd_convenio = atd.cd_convenio 
inner join prestador_aviso pav on pav.cd_aviso_cirurgia = ac.cd_aviso_cirurgia
and pav.cd_ati_med = 01 
inner join prestador pr on pr.cd_prestador = pav.cd_prestador
where --trunc(atd.dt_atendimento) between '01/01/2023' and '30/09/2023'
trunc(AC.DT_REALIZACAO) between '01/01/2023' and '30/09/2023'
and ac.tp_situacao = 'R'
--and c.ds_cirurgia like 'PARTO%'
AND c.cd_cirurgia in (2389,2399)
and atd.cd_multi_empresa = 4
and conv.tp_convenio NOT IN ('P','H')
---and atd.cd_atendimento = 4540259

order by trunc(AC.DT_REALIZACAO), conv.cd_convenio

/*select * from cirurgia 
WHERE DS_CIRURGIA like 'PARTO%'*/
--select * from tab_Fat where cd_tab_Fat in (3947, 3950, 3953)
--SELECT TP_CONVENIO FROM CONVENIO WHERE CD_CONVENIO = 1 
