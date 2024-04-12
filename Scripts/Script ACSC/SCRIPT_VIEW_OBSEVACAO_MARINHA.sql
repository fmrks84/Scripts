create or replace view dbamv.acsc_obser_pac as
select c.nm_cor||' - '||
       e.ds_especialid||' - '||
       'PACIENTE:'||' '||
       t.nm_paciente,
      dbaportal.fnc_obter_iniciais(t.nm_paciente)observacao,
       t.cd_atendimento 
from dbamv.sacr_cor_referencia c,dbamv.especialid e,dbamv.triagem_atendimento t 
where c.cd_cor_referencia = t.cd_cor_referencia 
and e.cd_especialid = t.cd_especialid --
and t.cd_atendimento = 5871631--:par1
;

select * from dbamv.triagem_atendimento t where t.cd_atendimento = 5871631
select observacao from dbamv.acsc_obser_pac where cd_atendimento = 5871631

select c.nm_cor || ' - ' || e.ds_especialid  from sacr_cor_referencia c, especialid e, triagem_atendimento t where c.cd_cor_referencia = t.cd_cor_referencia and   e.cd_especialid = t.cd_especialid and t.cd_atendimento = :par1
