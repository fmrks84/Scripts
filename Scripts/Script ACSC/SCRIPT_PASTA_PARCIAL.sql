--[12:03] Laila Aparecida Hamzi
/*PASTA PARCIAL x ATEND.*/
select /*r.cd_atendimento,
r.cd_reg_fat,
r.dt_inicio,
r.dt_final,
d.cd_documento_pasta_parcial,
d.nr_pasta,
d.dt_abertura,
d.dt_encerramento*/
*
from reg_fat r, documento_pasta_parcial d
where r.cd_reg_fat = d.cd_reg_fat (+)
and r.cd_atendimento in (4437003)
--order by 2
;
--[12:04] Laila Aparecida Hamzi
/*PROTOCOLO_DOC x PASTA PARCIAL*/
select /*p.cd_protocolo_doc,
p.cd_atendimento,
p.dt_realizacao,
p.dt_recebimento,
p.cd_documento_pasta_parcial,
d.nr_pasta*/
*
from it_protocolo_doc p, documento_pasta_parcial d
where p.cd_documento_pasta_parcial = d.cd_documento_pasta_parcial
and p.cd_atendimento in (4356506)
--and d.nr_pasta = 1
order by 3
-- 29/01 13:01 até 31/01 as 13:00
select * from 
select d.cd_documento_pasta_parcial from documento_pasta_parcial d order by d.cd_documento_pasta_parcial desc 
279816
280595 -- prod

select * from receb

select * from documento_pasta_parcial d where d.cd_atendimento = 4437003-- for update 
select * from protocolo_doc where cd_atendimento in (4356506)
select p.cd_protocolo_doc,p.cd_atendimento,p.dt_realizacao,p.dt_recebimento,p.nm_usuario_recebimento
 from it_protocolo_doc p  where p.cd_atendimento = 4356506  order by 3 desc--and p.cd_documento_pasta_parcial = 381553--p.cd_protocolo_doc in (1823444,1810733,1798924,1793602) -- inserir nr_documento_pasta_parcial 

/*
update it_protocolo_doc p set p.cd_documento_pasta_parcial = '279816'
where p.cd_protocolo_doc in (1823444,1810733,1798924,1793602) ---p.cd_documento_pasta_parcial = 279816

select * from it_protocolo_doc z where z.cd_atendimento = 2548157
select * from protocolo_doc where cd_protocolo_doc in (1823444,1810733,1798924,1793602)

*/

/*\*PROTOCOLO_DOC x PASTA PARCIAL*\
Pasta 4 UPDATE P/ Pasta 2 e
ajustar o período p.dt_realizacao, p.dt_recebimento,
Where cd_documento_pasta_parcial 279817

DEPOIS
\*PASTA PARCIAL x ATEND.*\
Inserir o cd_documento_pasta_parcial 279817 p/ o campo em branco (REG_FAT 281763)
d.cd_documento_pasta_parcial 279817
d.nr_pasta 2
d.dt_abertura 29/01/2021 13:01:00
d.dt_encerramento 31/01/2021 13:00:00*/


select * from atendime a where a.cd_atendimento = 4437003--177234 --4437003
