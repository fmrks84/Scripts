select * from atendime where cd_atendimento = 2962773;
select * from paciente where cd_paciente = 3142141

select * from it_protocolo_doc itp where itp.cd_reg_amb = 2962773---itp.cd_atendimento = 2434705
select * from 

--[12:03] Laila Aparecida Hamzi
/*PASTA PARCIAL x ATEND.*/
select r.cd_atendimento,
r.cd_reg_fat,
r.dt_inicio,
r.dt_final,
d.cd_documento_pasta_parcial,
d.nr_pasta,
d.dt_abertura,
d.dt_encerramento
from reg_fat r, documento_pasta_parcial d
where r.cd_reg_fat = d.cd_reg_fat (+)
and r.cd_atendimento in (4782375)
order by 2
;
--[12:04] Laila Aparecida Hamzi
/*PROTOCOLO_DOC x PASTA PARCIAL*/
select p.cd_protocolo_doc,
p.cd_atendimento,
p.dt_realizacao,
p.dt_recebimento,
p.cd_documento_pasta_parcial,
d.nr_pasta

from it_protocolo_doc p, documento_pasta_parcial d
where p.cd_documento_pasta_parcial = d.cd_documento_pasta_parcial(+)
and p.cd_atendimento in (4782375)
and d.nr_pasta = 2
order by 3
-- 29/01 13:01 at� 31/01 as 13:00
select * from 
select d.cd_documento_pasta_parcial from documento_pasta_parcial d order by d.cd_documento_pasta_parcial desc 
279816
280595 -- prod

update documento_pasta_parcial set dt_Abertura = '12/03/2023 00:10:00' where cd_documento_pasta_parcial = 418944
select * from documento_pasta_parcial d where d.cd_atendimento =      4740528-- for update 

select * from it_protocolo_doc p where p.cd_protocolo_doc in (3242211,
3245880,
3249063,
3249788
) -- inserir nr_documento_pasta_parcial 


update it_protocolo_doc p set p.cd_documento_pasta_parcial = '418944'
where p.cd_protocolo_doc in (1823444,1810733,1798924,1793602) ---p.cd_documento_pasta_parcial = 279816

select * from protocolo_doc where cd_protocolo_doc in (3242211,
3245880,
3249063,
3249788

)
select * from 

select * from setor st where st.cd_setor in (200,10,3734,3433)
/*\*PROTOCOLO_DOC x PASTA PARCIAL*\
Pasta 4 UPDATE P/ Pasta 2 e
ajustar o per�odo p.dt_realizacao, p.dt_recebimento,
Where cd_documento_pasta_parcial 279817

DEPOIS
\*PASTA PARCIAL x ATEND.*\
Inserir o cd_documento_pasta_parcial 279817 p/ o campo em branco (REG_FAT 281763)
d.cd_documento_pasta_parcial 279817
d.nr_pasta 2
d.dt_abertura 29/01/2021 13:01:00
d.dt_encerramento 31/01/2021 13:00:00*/

delete from  documento_pasta_parcial d where d.cd_atendimento = 4740528 and d.cd_documento_pasta_parcial = 418944-- for update 

update  documento_pasta_parcial d set d.dt_encerramento = null , d.cd_usuario_encerramento = null where d.cd_atendimento = 4740528-- for update 
