/*select * from  dbamv.con_pla_obs a1 where a1.cd_convenio = 464 and a1.tp_atendimento in ('A','H')
AND A1.CD_MULTI_EMPRESA = 7 

update dbamv.empresa_con_pla a set a.ds_observacao = 'Atendimento somente para Adultos, nao atende pediatria'
where a.cd_convenio IN (214) ;
commit
;
update  dbamv.empresa_con_pla a set a.ds_observacao = 'Nao Autorizado Consulta para Especialidade de Bucomaxilo para Atendimentos de Ambulatorio e Externo' 
where a.cd_convenio = 199 and a.ds_observacao is null 
;*/
insert into dbamv.con_pla_obs (cd_Convenio,cd_con_pla,tp_atendimento,cd_multi_empresa,ds_observacao)  
(SELECT cd_convenio,cd_con_pla,'E',cd_multi_empresa,'NAO AUTORIZADO CONSULTA PARA ESPECIALIDADE DE BUCOMAXILO' FROM EMPRESA_CON_PLA WHERE CD_CONVENIO in (234,199) AND SN_ATIVO = 'S');

insert into dbamv.con_pla_obs (cd_Convenio,cd_con_pla,tp_atendimento,cd_multi_empresa,ds_observacao)  
(SELECT cd_convenio,cd_con_pla,'H',cd_multi_empresa,'NAO AUTORIZADO CONSULTA PARA ESPECIALIDADE DE BUCOMAXILO' FROM EMPRESA_CON_PLA WHERE CD_CONVENIO in (234,199) AND SN_ATIVO = 'S') ;

insert into dbamv.con_pla_obs (cd_Convenio,cd_con_pla,tp_atendimento,cd_multi_empresa,ds_observacao)  
(SELECT cd_convenio,cd_con_pla,'A',cd_multi_empresa,'NAO AUTORIZADO CONSULTA PARA ESPECIALIDADE DE BUCOMAXILO' FROM EMPRESA_CON_PLA WHERE CD_CONVENIO in (234,199) AND SN_ATIVO = 'S') ;
commit
;



    

select DISTINCT A1.CD_CON_PLA from  dbamv.con_pla_obs a1 where a1.cd_convenio = 464 and a1.tp_atendimento in ('A','H')
AND A1.CD_MULTI_EMPRESA = 7 

select * from Empresa_Con_Pla where cd_convenio = 214 order by cd_con_pla 
