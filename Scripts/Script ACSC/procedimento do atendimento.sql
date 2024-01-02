/*2889559 - Bradesco
2889550 - Sul América
2889491 - Amil
2889546 - Mediservice
2889328 - Golden
2889313 - Marinha
2888508 - Assim
*/

select * from atendime where cd_atendimento = 2889559;
select * from atendime where cd_atendimento = 2889550;
select * from atendime where cd_atendimento = 2889491;
select * from atendime where cd_atendimento = 2889546;
select * from atendime where cd_atendimento = 2889328;
select * from atendime where cd_atendimento = 2889313;
select * from atendime where cd_atendimento = 2888508;


SELECT 
b.cd_convenio,
b.cd_con_pla,
b.tp_atendimento,
b.cd_ori_ate,
b.cd_unid_int,
a.cd_gru_fat,
a.cd_pro_fat,
a.qt_lancada
FROM dbamv.IMPORT_ATEND_PRO_FAT  A
INNER JOIN DBAMV.Import_Atend B ON A.CD_IMPORT_ATEND = B.CD_IMPORT_ATEND
WHERE B.CD_CONVENIO IN (156,185,152,174,170,173,154)
AND A.CD_PRO_FAT = 10101039
