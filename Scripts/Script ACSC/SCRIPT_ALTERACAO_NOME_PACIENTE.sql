select c.nm_cor||' - '||e.ds_especialid||' - '|| replace (replace (translate (initcap (T.NM_PACIENTE),'abcdefghijklmnopqrstuvxzyw�','�'),' ','.'),'�','') || DECODE (T.NM_PACIENTE,NULL,NULL,'.')observacao from sacr_cor_referencia c, especialid e, triagem_atendimento t where c.cd_cor_referencia = t.cd_cor_referencia and  e.cd_especialid = t.cd_especialid and t.cd_atendimento = 5847723
;
select c.nm_cor || ' - ' || e.ds_especialid  from sacr_cor_referencia c, especialid e, triagem_atendimento t 
where c.cd_cor_referencia = t.cd_cor_referencia and   e.cd_especialid = t.cd_especialid and t.cd_atendimento = 5847723-- :par1
;
select * from tiss_guia where cd_atendimento = 5847723

SELECT c.nm_cor||' - '||e.ds_especialid||' - '||DBAPORTAL.FNC_OBTER_INICIAIS(T.NM_PACIENTE)OBSERVACAO FROM dbamv.sacr_cor_referencia C,dbamv.especialid E,dbamv.triagem_atendimento T WHERE C.cd_cor_referencia = T.cd_cor_referencia AND E.cd_especialid = T.cd_especialid AND T.cd_atendimento = :par1
    
select c.nm_cor || ' - ' || e.ds_especialid  from sacr_cor_referencia c, especialid e, triagem_atendimento t where c.cd_cor_referencia = t.cd_cor_referencia and   e.cd_especialid = t.cd_especialid and t.cd_atendimento = :par1
    
    
