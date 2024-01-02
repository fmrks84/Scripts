select  dba_jobs_running.sid, dba_jobs_running.job, dba_jobs_running.last_date, dba_jobs_running.this_date,
        user_jobs.what
from  dba_jobs_running, user_jobs
where dba_jobs_running.job = user_jobs.job 
order by 1 desc 

select sysdate from dual

--select count(*) from dbadw.fa_preco -- As 16:52 03/01 180564689
select  what, job, last_date,last_sec, next_date, next_sec,  interval  
from user_jobs 
order by 5,3,4

-- select count (*) from dbadw.fa_preco f where f.id_tempo = '732038'   --- As 08:15 10/02   75161460 (09/2011)
-- select count (*) from dbadw.fa_preco f where f.id_tempo = '732049'   --- As 14:08 07/02   42700000 (10/2011)
-- select count (*) from dbadw.fa_preco f where f.id_tempo = '6032'     --- As 07:41 16/02   29438510 (11/2011)
-- select count (*) from dbadw.fa_preco f where f.id_tempo = '5377'     --- As 08:57 23/02   52200000 (12/2011)                                                                                                                                                                                  
-- select count (*) from dbadw.fa_preco f where f.id_tempo = '5398'     --- As 17:06 06/03   62100000 (01/2012)  
-- select count (*) from dbadw.fa_preco f where f.id_tempo = '5429'     --- As 10:41 26/03  105952123 (02/2012) 
-- select count (*) from dbadw.fa_preco f where f.id_tempo = '5458'     --- As 09:29 05/04   74247877 (03/2012)   
-- select count (*) from dbadw.fa_preco f where f.id_tempo = '5489'        --- As 15:19 05/04   76000000 (04/2012)                                                                                             

select count (*) from dbadw.fa_estoque_consumo  --- 9521817 ---

-----------------------------------Contas--------------------------------------------------------------------
select    f.id_tempo, t.mes, t.ano, f.id_atendimento, f.id_conta_medica, count (*)
from      dbadw.FA_FATURAMENTO_CONTAS f, dbadw.di_tempo t
where     f.id_tempo = t.id_tempo
and       t.ano = '2011'
group by  f.id_tempo, t.mes, t.ano, f.id_atendimento, f.id_conta_medica
order by  f.id_tempo, t.mes, t.ano, f.id_atendimento, f.id_conta_medica

--delete dbadw.di_tempo f where f.id_tempo =  '5733'
 
------------------------------------------Contas--------------------------------------------------------------

select    t.mes, t.ano, count (*)
from      dbadw.FA_FATURAMENTO_CONTAS f, dbadw.di_tempo t
where     f.id_tempo = t.id_tempo
and       t.ano = '2012'
group by  t.mes, t.ano 
order by  t.mes, t.ano

--------------------------------------------Consumo------------------------------------------------------


select   t.ano, count (*)
from     dbadw.fa_estoque_consumo c, dbadw.di_tempo t
where    c.id_tempo     = t.id_tempo
group by  t.ano
order by  t.ano

-------------------------------------Preço------------------------------------------------------------------
select   fap.id_tempo,  cd_convenio, NM_CONVENIO, count(*) 
from     dbadw.fa_preco fap, dbadw.di_plano_convenio dpc
where    fap.id_plano_convenio = dpc.id_plano_convenio
--and      cd_convenio in (10,21,39,302,303,321,377,388,389,394)
and      fap.id_tempo <> '5398'
group by fap.id_tempo, cd_convenio, dpc.nm_convenio
order by fap.id_tempo, cd_convenio, nm_convenio

---------------------------------------------------------------------------------------------------
select  d.mes, d.ano, f.id_tempo, c.cd_convenio, c.nm_convenio, count(*)
from    dbadw.fa_preco f, dbadw.di_tempo d, dbadw.di_plano_convenio c 
where   f.id_plano_convenio =  c.id_plano_convenio
and     f.id_tempo          =  d.id_tempo(+)
--and     d.mes > '04'
and     d.ano = '2012'
--and      cd_convenio in (10,21,39,302,303,321,377,388,389,394)
--and      f.id_tempo  = '5489'
group by d.mes, d.ano, f.id_tempo, c.cd_convenio, c.nm_convenio
order by d.mes, d.ano, f.id_tempo, c.cd_convenio, c.nm_convenio

-------------------------------------------------------------------------------------
select pc.cd_convenio, pc.nm_convenio, count(*) 
from dbadw.di_plano_convenio pc, DBAPORTAL.CONFIG_CON_PLA_PRECO pr 
where pc.cd_convenio = pr.cd_convenio
and   pc.cd_con_pla = pr.cd_con_pla
--and   pr.sn_ativado_carga = 'S'
--and   pr.cd_convenio in (394)
group by 3, pc.cd_convenio, nm_convenio 
order by 1 
--------------------------------------------------------------------------------
select p.cd_convenio, c.nm_convenio, count(*) 
from dbamv.convenio c, dbamv.con_pla p
where c.cd_convenio = p.cd_convenio
and   p.sn_ativo = 'S'
group by  p.cd_convenio, c.nm_convenio 
order by p.cd_convenio 


--------------------------------BKP------------------------------------------
select   cd_convenio, NM_CONVENIO, count(*) 
from     dbadw.bkp_fa_preco fap, dbadw.di_plano_convenio dpc
where    fap.id_plano_convenio = dpc.id_plano_convenio
and      cd_convenio in (27,318,321,392,394)
group by cd_convenio, dpc.nm_convenio
order by cd_convenio, nm_convenio











SELECT DI_PLANO_CONVENIO.CD_CONVENIO,  FA_PRECO.ID_PRO_FAT, DI_PRO_FAT.CD_GRU_PRO
FROM   
       DBADW.FA_PRECO 
     , DBADW.DI_PLANO_CONVENIO
     , DBADW.DI_PRO_FAT
     , DBADW.DI_REGRA
     
WHERE  FA_PRECO.ID_PLANO_CONVENIO    =  DI_PLANO_CONVENIO.ID_PLANO_CONVENIO 
AND    FA_PRECO.ID_PRO_FAT           =  DI_PRO_FAT.ID_PRO_FAT 
AND    FA_PRECO.ID_REGRA             =  DI_REGRA.ID_REGRA
AND    DI_PLANO_CONVENIO.CD_CONVENIO =  388
AND    DI_PRO_FAT.CD_GRU_PRO  NOT IN (8,58,59,62,7,9,11)


--SELECT * FROM DBADW.FA_PRECO
--SELECT * FROM DBADW.DI_REGRA WHERE ID_REGRA = 955

SELECT *
FROM DBA_JOBS_RUNNING

SELECT * FROM DBA_JOBS


select * from v$session u, v$lock v, dba_objects o
where u.sid in (341,354)
  and u.sid = v.sid
--  and u.username is not null
and   o.object_id(+) = v.id1

SELECT * from v$lock
where sid = 341




select * from dba_jobs_running
----------------------------------------------------------------------------------
select distinct d.mes, d.ano 
from dbadw.fa_preco f, dbadw.di_tempo d, dbadw.di_plano_convenio c 
where f.id_plano_convenio =  c.id_plano_convenio
and   d.id_tempo          =  f.id_tempo
and   c.cd_convenio       =  394



