select * from dbamv.registro_documento a 
inner join dbamv.registro_resposta b on b.cd_registro_documento = a.cd_registro_documento
where a.cd_documento =307--.cd_registro_documento = 307
and a.cd_atendimento = 1477376
and b.cd_pergunta_doc = 19093
and a.dt_registro > = '24/12/2016'
for update 
  

select * from dbamv.Registro_Resposta c where c.cd_registro_documento in (
5185819
,5189177
,5193935
,5201014
,5201503
,5201879
,5209266
,5215528
,5216793
,5219585
,5225461
,5225728
,5230725
,5239303
,5241042
,5242138
,5247463
,5177824)
and c.cd_pergunta_doc = 19093
for update 
