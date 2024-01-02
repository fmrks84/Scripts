declare
  nJob number;
begin
 
  select max(job)+1
  into nJob
  from dba_jobs;
 
  sys.dbms_job.submit(job => nJob,
                      what => 'begin dbamv.receita_em_dia; end;',
                      next_date => to_date('07-11-2008 23:00:00', 'dd-mm-yyyy hh24:mi:ss'),
                      interval => 'TRUNC(sysdate+1)');
  commit;
end;
/


/*Para você confirmar que o JOB existe, precisa executar a seguinte busca no banco:
 
select *
from all_jobs
where what like upper ('%dbamv.receita_em_dia%')*/ v



